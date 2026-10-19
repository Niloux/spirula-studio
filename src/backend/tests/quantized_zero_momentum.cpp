// Zero-variance Adam codes must not move an unobserved parameter.
#include "kernels/optim/Optimizer.cuh"

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <exception>
#include <vector>

template <typename T> static T* upload(const std::vector<T>& values) {
    auto* p = static_cast<T*>(backend::device_malloc(values.size()*sizeof(T)));
    backend::memcpy_sync(p,values.data(),values.size()*sizeof(T),
                         backend::MemcpyKind::HostToDevice);
    return p;
}

template <int Bits> static int check_host_codec() {
    const uint16_t codes16[] = {32768, 0, 32768, 65535};
    const uint8_t codes8[] = {128, 0, 128, 255};
    const uint8_t codes4[] = {0x08, 0xf8};
    const uint8_t* codes = Bits == 16 ? reinterpret_cast<const uint8_t*>(codes16)
                         : Bits == 8 ? codes8 : codes4;
    const float4 bounds{-1, 1, 0, 30};
    const auto zero = QuantizedAdamState<Bits>::decode_g1g2(codes, 0, bounds);
    const auto active = QuantizedAdamState<Bits>::decode_g1g2(codes, 1, bounds);
    const bool ok = zero.x == 0.0f && zero.y == 0.0f &&
                    std::isfinite(active.x) && active.x != 0.0f && active.y > 0.0f;
    std::printf("host codec bits=%d: %s\n", Bits, ok ? "ok" : "FAILED");
    return !ok;
}

static int run(int bits) {
    constexpr int64_t N=257, S=3, cells=N*S;
    std::vector<uint8_t> packed(cells*(bits==8 ? 2 : 1),0);
    for (int i=0;i<cells;++i) {
        if (bits==8) {
            packed[2*i]=128;
            packed[2*i+1]=i ? 255 : 0;
        } else packed[i]=i ? 0xf8 : 0x08;
    }
    std::vector<float4> bounds((cells+255)/256,float4{-1,1,0,30});
    auto* param=upload(std::vector<float>(cells,1));
    auto* grad=upload(std::vector<float>(cells,0));
    auto* codes=upload(packed);
    auto* ranges=upload(bounds);
    TorchTensorView p{(uint64_t)param,4u,{N,S,1}};
    TorchTensorView g{(uint64_t)grad,4u,{N,S,1}};
    fused_adam_step_quantized(N,p,g,codes,ranges,.01f,12,{},0,0,bits,
                              {},{},1,false);
    std::vector<float> got(cells);
    backend::memcpy_sync(got.data(),param,got.size()*sizeof(float),
                         backend::MemcpyKind::DeviceToHost);
    const bool zero=got[0]==1.f;
    const bool active=std::isfinite(got[1]) && std::abs(got[1]-1.f)>1e-6f;
    std::printf("zero momentum bits=%d: zero-variance delta=%.9g (%s), "
                "nonzero variance delta=%.9g (%s)\n",bits,got[0]-1.f,
                zero ? "ok" : "FAILED",got[1]-1.f,active ? "ok" : "FAILED");
    backend::device_free(param);
    backend::device_free(grad);
    backend::device_free(codes);
    backend::device_free(ranges);
    return !zero+!active;
}

int main() try {
    int failed = check_host_codec<4>() + check_host_codec<8>() + check_host_codec<16>();
    failed += run(4) + run(8);
    std::printf("quantized_zero_momentum: %s\n",failed ? "FAILED" : "PASSED");
    return failed ? 1 : 0;
} catch (const std::exception& e) {
    std::fprintf(stderr,"quantized_zero_momentum: %s\n",e.what());
    return 1;
}
