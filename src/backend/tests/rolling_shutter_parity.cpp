#include "engine/Engine.h"
#include "engine/EngineState.h"
#include "engine/EngineInternal.h"
#include "kernels/pixelwise/PixelWise.cuh"
#include "kernels/background/BackgroundSphericalHarmonics.cuh"
#include <algorithm>
#include <array>
#include <cmath>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <stdexcept>
#include <vector>

namespace {
constexpr int W=64,H=48;
using V=std::array<double,3>;
V add(V a,V b) { for(int k=0;k<3;++k)a[k]+=b[k];return a; }
V mul(V a,double b) { for(auto& v:a)v*=b;return a; }
double dot(V a,V b) { return a[0]*b[0]+a[1]*b[1]+a[2]*b[2]; }
V cross(V a,V b) { return {a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]}; }
V unit(V a) { return mul(a,1/std::sqrt(dot(a,a))); }
V inverse(V w,V p) { return mul(add(add(p,mul(cross(w,p),-1)),mul(w,dot(w,p))),1/(1+dot(w,w))); }
TorchTensorView tv(const void* p,std::vector<int64_t> shape) { return {(uint64_t)p,4,std::move(shape)}; }
TorchTensorView nil() { return {0,4,{0}}; }
void check(bool ok,const char* what) { if(!ok) throw std::runtime_error(what); }
std::vector<float> pull(const float* p,int n) {
    std::vector<float> out(n);
    backend::memcpy_sync(out.data(),p,n*sizeof(float),backend::MemcpyKind::DeviceToHost); return out;
}
float* upload(const std::vector<float>& v) {
    auto* p=(float*)backend::device_malloc(v.size()*sizeof(float));
    backend::memcpy_sync(p,v.data(),v.size()*sizeof(float),backend::MemcpyKind::HostToDevice);return p;
}
double objective(const std::vector<float>& a,const std::vector<float>& b) {
    double x=0;for(size_t k=0;k<a.size();++k)x+=double(a[k])*b[k];return x;
}
void expect_close(double a,double b,double atol,double rtol,const char* name) {
    if(!std::isfinite(a+b) || std::abs(a-b)>atol+rtol*std::max(std::abs(a),std::abs(b))) {
        std::fprintf(stderr,"%s: analytic %.9g reference %.9g\n",name,a,b);
        throw std::runtime_error(name);
    }
}
V ray(int x,int y,bool fish) {
    double u=(x+.5-W/2.)/50.,v=(y+.5-H/2.)/50.;
    if(!fish)return unit({u,v,1});
    double theta=std::hypot(u,v),s=theta>0 ? std::sin(theta)/theta:1;
    return {u*s,v*s,std::cos(theta)};
}
double normal_objective(const std::vector<float>& depth,const std::vector<float>& state,
                        const std::vector<float>& seed,bool fish) {
    const V w{state[0],state[1],state[2]},d{state[3],state[4],state[5]};
    auto fraction=[&](int x,int y) {return state[7]==0 ? (x+.5)/W-.5:(y+.5)/H-.5;};
    auto point=[&](int x,int y) { double s=fraction(x,y);
        return add(mul(d,s),mul(inverse(mul(w,s),ray(x,y,fish)),depth[y*W+x])); };
    double result=0;
    for(int y=1;y<H-1;++y)for(int x=1;x<W-1;++x) {
        V dx=add(point(x+1,y),mul(point(x-1,y),-1));
        V dy=add(point(x,y+1),mul(point(x,y-1),-1));
        V n=unit(inverse(mul(w,-fraction(x,y)),unit(cross(dx,mul(dy,-1)))));
        for(int k=0;k<3;++k)result+=n[k]*seed[(y*W+x)*3+k];
    }
    return result;
}
std::vector<float> render(float* device,const std::vector<float>& motion,bool packed) {
    backend::memcpy_sync(device,motion.data(),motion.size()*sizeof(float),backend::MemcpyKind::HostToDevice);
    forward_3dgs("3dgut",0,packed);
    std::vector<float> rgb(W*H*3);
    engine_copy_render_to_host(tv(rgb.data(),{1,H,W,3}),nil(),nil(),nil(),nil());return rgb;
}
}

int main(int argc,char** argv) {
    try {
        std::vector<float> parity;
        for(bool fish:{false,true})for(int axis:{0,1})for(bool posed:{false,true}) {
            engine_reset(); engine_set_bin_tile_size(bin_tile_x(kMacroLog2Default));
            std::vector<float> mean{.3f,-.2f,2},quat{1,0,0,0},scale{std::log(.18f),std::log(.25f),std::log(.12f)};
            std::vector<float> opacity{0},dc{.4f,.7f,1},sh;
            set_data_3dgs(1,tv(mean.data(),{1,3}),tv(quat.data(),{1,4}),tv(scale.data(),{1,3}),
                tv(opacity.data(),{1,1}),tv(dc.data(),{1,3}),tv(sh.data(),{1,0,3}),0);
            std::vector<float> vm{1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1},intr{50,50,W/2.f,H/2.f},coeffs(8,0);
            if(posed) {
                vm[0]=vm[10]=float(std::cos(.1));vm[2]=float(std::sin(.1));vm[8]=-vm[2];
                vm[3]=.05f;vm[7]=-.03f;vm[11]=.02f;
            }
            auto to_world=[&](V p) {return V{vm[0]*p[0]+vm[4]*p[1]+vm[8]*p[2],
                vm[1]*p[0]+vm[5]*p[1]+vm[9]*p[2],vm[2]*p[0]+vm[6]*p[1]+vm[10]*p[2]};};
            set_camera_params(W,H,fish?"FISHEYE":"PINHOLE","NONE",tv(vm.data(),{1,4,4}),tv(intr.data(),{1,4}),tv(coeffs.data(),{1,8}));
            std::vector<float> m{.02f,-.01f,.015f,.02f,-.015f,.01f,0,float(axis)};
            float* motion=upload(m);float* gradient=upload(std::vector<float>(8,0));
            engine().shutter.view={motion,gradient};
            const auto image=render(motion,m,false);
            V w{m[0],m[1],m[2]},d{m[3],m[4],m[5]};
            for(int y=0;y<H;++y)for(int x=0;x<W;++x) {
                double s=axis ? (y+.5)/H-.5:(x+.5)/W-.5;
                V direction=to_world(unit(inverse(mul(w,s),ray(x,y,fish))));
                V origin=to_world(add(mul(d,s),V{-vm[3],-vm[7],-vm[11]}));
                V gro{(origin[0]-mean[0])/.18,(origin[1]-mean[1])/.25,(origin[2]-mean[2])/.12};
                V grd{direction[0]/.18,direction[1]/.25,direction[2]/.12};
                double alpha=.5*std::exp(-.5*dot(cross(grd,gro),cross(grd,gro))/dot(grd,grd));
                if(alpha<=1./255)alpha=0;
                for(int c=0;c<3;++c)expect_close(image[(y*W+x)*3+c],alpha*(.5+.28209479177387814*dc[c]),5e-5,2e-4,"CPU row-ray render");
            }
            const auto packed=render(motion,m,true);
            for(size_t k=0;k<image.size();++k)expect_close(packed[k],image[k],1e-6,1e-5,"packed render");
            engine().shutter.view={}; forward_3dgs("3dgut",0,false);
            std::vector<float> base(W*H*3);
            engine_copy_render_to_host(tv(base.data(),{1,H,W,3}),nil(),nil(),nil(),nil());
            engine().shutter.view={motion,gradient}; auto zero=m;std::fill(zero.begin(),zero.begin()+6,0);
            auto stationary=render(motion,zero,false);
            for(size_t k=0;k<base.size();++k)expect_close(stationary[k],base[k],1e-6,1e-5,"zero-motion render");
            std::vector<float> seed(W*H*3),z(W*H,0);
            for(size_t k=0;k<seed.size();++k)
                seed[k]=image[(k/3)*3]>.02f ? float(std::sin(k*.13)/(W*H)) : 0;
            render(motion,m,false);backend::memset_sync(gradient,0,8*sizeof(float));
            engine_backward_from_render_grad(tv(seed.data(),{1,H,W,3}),tv(z.data(),{1,H,W,1}),tv(z.data(),{1,H,W,1}));
            const auto analytic=pull(gradient,8);
            for(int k=0;k<6;++k) {
                auto p=m,n=m;p[k]+=1e-3f;n[k]-=1e-3f;
                const double finite=(objective(render(motion,p,false),seed)-objective(render(motion,n,false),seed))/2e-3;
                expect_close(analytic[k],finite,3e-5,.025,"render motion gradient");
            }
            render(motion,m,false);
            std::vector<float> depth(W*H),normal_seed(W*H*3);
            for(int y=0;y<H;++y)for(int x=0;x<W;++x) {
                double s=axis ? (y+.5)/H-.5:(x+.5)/W-.5;
                auto q=inverse(mul(w,s),ray(x,y,fish));
                depth[y*W+x]=float((2-s*d[2])/q[2]);
            }
            for(size_t k=0;k<normal_seed.size();++k)normal_seed[k]=float(std::cos(k*.07)/(W*H));
            auto* dd=upload(depth);auto* dn=upload(std::vector<float>(W*H*3,0));auto* dg=upload(std::vector<float>(W*H,0));
            auto* ns=upload(normal_seed);
            auto normal_render=[&](const std::vector<float>& state) {
                backend::memcpy_sync(motion,state.data(),8*sizeof(float),backend::MemcpyKind::HostToDevice);
                depth_to_normal_forward(fish?"FISHEYE":"PINHOLE","NONE",tv(engine().camera.intrins.data_ptr(),{1,4}),
                    CameraProjectionData(tv(engine().camera.dist_coeffs.data_ptr(),{1,8}),{motion,gradient}),true,
                    DeviceTensor3D<float>(tv(dd,{1,H,W})),DeviceTensor3D<float3>(tv(dn,{1,H,W,3})));
                return pull(dn,W*H*3);
            };
            auto normals=normal_render(m);
            for(int y=1;y<H-1;++y)for(int x=1;x<W-1;++x) {
                double s=axis ? (y+.5)/H-.5:(x+.5)/W-.5;
                V expected=unit(inverse(mul(w,-s),{0,0,-1}));
                for(int c=0;c<3;++c)expect_close(normals[(y*W+x)*3+c],expected[c],2e-4,1e-3,"moving-camera plane normal");
            }
            backend::memset_sync(gradient,0,8*sizeof(float));
            depth_to_normal_backward(fish?"FISHEYE":"PINHOLE","NONE",tv(engine().camera.intrins.data_ptr(),{1,4}),
                CameraProjectionData(tv(engine().camera.dist_coeffs.data_ptr(),{1,8}),{motion,gradient}),true,
                DeviceTensor3D<float>(tv(dd,{1,H,W})),DeviceTensor3D<float3>(tv(ns,{1,H,W,3})),DeviceTensor3D<float>(tv(dg,{1,H,W})));
            const auto ng=pull(gradient,8);
            for(int k=0;k<6;++k) {
                auto p=m,n=m;p[k]+=1e-4f;n[k]-=1e-4f;
                double finite=(normal_objective(depth,p,normal_seed,fish)-normal_objective(depth,n,normal_seed,fish))/(p[k]-n[k]);
                expect_close(ng[k],finite,5e-6,.02,"normal motion gradient");
            }
            const std::vector<float> coefficients{1,1,1,.3f,.1f,-.2f,.2f,-.1f,.3f,-.1f,.2f,.1f};
            float* sky=upload(coefficients);
            auto camera=CameraProjectionData(tv(engine().camera.dist_coeffs.data_ptr(),{1,8}),{motion,gradient});
            auto sky_render=[&](const std::vector<float>& state) {
                backend::memcpy_sync(motion,state.data(),8*sizeof(float),backend::MemcpyKind::HostToDevice);
                render_background_sh_forward(W,H,fish?"FISHEYE":"PINHOLE","NONE",1,
                    tv(engine().camera.viewmats.data_ptr(),{1,4,4}),tv(engine().camera.intrins.data_ptr(),{1,4}),
                    camera,tv(sky,{4,3}),tv(dn,{1,H,W,3}));
                return pull(dn,W*H*3);
            };
            const auto sky_image=sky_render(m);
            auto* v_sky=upload(std::vector<float>(12,0));
            backend::memset_sync(gradient,0,8*sizeof(float));
            render_background_sh_backward(W,H,fish?"FISHEYE":"PINHOLE","NONE",1,
                tv(engine().camera.viewmats.data_ptr(),{1,4,4}),tv(engine().camera.intrins.data_ptr(),{1,4}),
                camera,tv(sky,{4,3}),tv(dn,{1,H,W,3}),tv(ns,{1,H,W,3}),tv(v_sky,{4,3}));
            const auto sg=pull(gradient,8);
            for(int k=0;k<6;++k) {
                auto p=m,n=m;p[k]+=1e-3f;n[k]-=1e-3f;
                double finite=(objective(sky_render(p),normal_seed)-objective(sky_render(n),normal_seed))/2e-3;
                expect_close(sg[k],finite,2e-5,.02,"SH background motion gradient");
            }
            parity.insert(parity.end(),image.begin(),image.end());parity.insert(parity.end(),analytic.begin(),analytic.end());
            parity.insert(parity.end(),normals.begin(),normals.end());parity.insert(parity.end(),ng.begin(),ng.end());
            parity.insert(parity.end(),sky_image.begin(),sky_image.end());parity.insert(parity.end(),sg.begin(),sg.end());
            for(auto* p:{motion,gradient,dd,dn,dg,ns,sky,v_sky})backend::device_free(p);
        }
        auto& state=engine().shutter;state=ShutterState{};state.optimize=true;
        ShutterImage im;im.name="frame.jpg";im.image_id=1;im.velocity={1,2,3};im.rotation=im.initial={.01,.02,.03};
        ShutterLens lens;lens.id=1;lens.readout=lens.initial=.02;
        state.images.push_back(im);state.lenses.push_back(lens);
        auto step=[] { auto& s=engine().shutter;s.images[0].grad={.2,-.3,.4};s.images[0].touched=true;
            s.lenses[0].grad=.6;s.lenses[0].touched=true;engine_shutter_step(); };
        step();auto saved=engine_shutter_save();
        step();auto uninterrupted=engine_shutter_save();
        engine_shutter_restore(saved);step();check(engine_shutter_save()==uninterrupted,"Adam continuation mismatch");
        engine_ensure_optim_state(32,32,32,false);
        const auto dir=std::filesystem::temp_directory_path()/"spirula-rolling-shutter-checkpoint";
        check(!std::filesystem::exists(dir),"checkpoint fixture already exists");
        engine_save_checkpoint(dir.string(),true,17);
        step();engine_load_checkpoint(dir.string());check(engine_shutter_save()==uninterrupted,"checkpoint motion state mismatch");
        std::filesystem::remove_all(dir);
        if(argc==3) {
            if(std::string(argv[1])=="dump") { std::ofstream out(argv[2],std::ios::binary);out.write((char*)parity.data(),parity.size()*sizeof(float)); }
            else if(std::string(argv[1])=="compare") {
                std::vector<float> ref(parity.size());std::ifstream in(argv[2],std::ios::binary);in.read((char*)ref.data(),ref.size()*sizeof(float));
                check(bool(in),"invalid parity reference");
                for(size_t k=0;k<ref.size();++k)expect_close(parity[k],ref[k],3e-4,.003,"backend parity");
            } else throw std::runtime_error("usage: rolling_shutter_parity [dump|compare reference]");
        }
        std::puts("rolling_shutter_parity: row/column cameras, CPU oracle, gradients, zero motion, packed, normals, Adam and checkpoint passed");
        return 0;
    }catch(const std::exception& e){std::fprintf(stderr,"rolling_shutter_parity: %s\n",e.what());return 1;}
}
