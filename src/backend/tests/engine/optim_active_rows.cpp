// Optimizer updates must stop at the live row count, before reserved capacity.
#include "engine/Engine.h"
#include "engine/EngineState.h"

#include <cmath>
#include <cstdio>
#include <exception>
#include <vector>

static TorchTensorView view(void* p, std::vector<int64_t> shape) {
    return {(uint64_t)p, 4u, std::move(shape)};
}

static int run(int lobes, bool trust, int bits) {
    engine_reset();
    constexpr int N=3, capacity=5;
    const int K=lobes ? 2*lobes : 3;
    std::vector<float> means(capacity*3,0.f), quats(capacity*4,0.f);
    std::vector<float> scales(capacity*3,-2.f), opacities(capacity,0.f);
    std::vector<float> dc(capacity*3,.2f), sh(capacity*K*3,.1f);
    for (int i=0;i<capacity;++i) quats[4*i]=1.f;
    set_data_3dgs(N,view(means.data(),{capacity,3}),view(quats.data(),{capacity,4}),
        view(scales.data(),{capacity,3}),view(opacities.data(),{capacity,1}),
        view(dc.data(),{capacity,3}),view(sh.data(),{capacity,K,3}),lobes);
    auto& g=engine().grad;
    g.means.resize(PoolSlot::EngVMeans,capacity); g.means.zero();
    g.quats.resize(PoolSlot::EngVQuats,capacity); g.quats.zero();
    g.scales.resize(PoolSlot::EngVScales,capacity); g.scales.zero();
    g.opacities.resize(PoolSlot::EngVOpacities,capacity); g.opacities.zero();
    g.features_dc.resize(PoolSlot::EngVFeaturesDc,capacity);
    g.features_sh.resize(PoolSlot::EngVFeaturesSh,capacity,K);
    std::vector<float> dc_grad(dc.size(),.25f),sh_grad(sh.size(),.125f);
    backend::memcpy_sync(g.features_dc.data_ptr(),dc_grad.data(),dc_grad.size()*4,
                         backend::MemcpyKind::HostToDevice);
    backend::memcpy_sync(g.features_sh.data_ptr(),sh_grad.data(),sh_grad.size()*4,
                         backend::MemcpyKind::HostToDevice);
    OptimConfig cfg;
    cfg.sh_optim_bits=bits; cfg.sh_value_bits=cfg.non_sh_optim_bits=32;
    cfg.use_color_trust_region=trust;
    cfg.max_gauss_ratio=10.f; cfg.eps_tr=1.f;
    cfg.lr_features_dc=.001f; cfg.lr_features_sh=.002f; cfg.lr_features_sb=.003f;
    engine_optim_step(0,cfg);
    std::vector<float> actual_dc(dc.size()),actual_sh(sh.size());
    backend::memcpy_sync(actual_dc.data(),engine().world.features_dc.data_ptr(),dc.size()*4,
                         backend::MemcpyKind::DeviceToHost);
    backend::memcpy_sync(actual_sh.data(),engine().world.features_sh.data_ptr(),sh.size()*4,
                         backend::MemcpyKind::DeviceToHost);
    int bad=0;
    for (size_t i=0;i<dc.size();++i)
        bad+=i<N*3 ? !(actual_dc[i]<dc[i]) : actual_dc[i]!=dc[i];
    for (size_t i=0;i<sh.size();++i)
        bad+=i<N*K*3 ? !(actual_sh[i]<sh[i]) : actual_sh[i]!=sh[i];
    std::printf("optim active rows SB=%d trust=%d bits=%d bad=%d\n",lobes,trust,bits,bad);
    return bad;
}

int main() try {
    int bad=0;
    for (int bits : {32,8}) for (bool trust : {false,true}) {
        bad+=run(0,trust,bits);
#ifdef SS_BACKEND_VULKAN
        bad+=run(2,trust,bits);
#endif
    }
    engine_reset();
    return bad ? 1 : 0;
} catch (const std::exception& e) {
    std::fprintf(stderr,"optim_active_rows: %s\n",e.what());
    return 1;
}
