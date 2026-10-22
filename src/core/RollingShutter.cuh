#pragma once
#include "backend/api/BackendTypes.h"

// Per-view rows: readout rotation xyz, displacement xyz, unused, axis (0=x, 1=y).
struct RollingShutterView {
    const float* motion = nullptr;
    float* gradient = nullptr;
    __host__ __device__ bool moving() const {
        return motion && (motion[0]!=0 || motion[1]!=0 || motion[2]!=0 ||
                          motion[3]!=0 || motion[4]!=0 || motion[5]!=0);
    }
    __host__ __device__ RollingShutterView camera(int i) const {
        return {motion ? motion + 8 * i : nullptr,
                gradient ? gradient + 8 * i : nullptr};
    }
};
