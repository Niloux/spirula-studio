#pragma once

#include "generated/slang.cuh"

struct s_bwdCallableCtx_lerp_0
{
    float _S1;
    float _S2;
    float _S3;
};

struct DiffPair_float_0
{
    float primal_0;
    float differential_0;
};

inline __device__ void _d_lerp_0(DiffPair_float_0 * dpx_0, DiffPair_float_0 * dpy_0, DiffPair_float_0 * dps_0, float dOut_0)
{
    float _S4 = (1.0f - (*dps_0).primal_0) * dOut_0;
    dpx_0->primal_0 = (*dpx_0).primal_0;
    dpx_0->differential_0 = _S4;
    DiffPair_float_0 _S5 = *dpy_0;
    float _S6 = (*dps_0).primal_0 * dOut_0;
    dpy_0->primal_0 = (*dpy_0).primal_0;
    dpy_0->differential_0 = _S6;
    float _S7 = (_S5.primal_0 - (*dpx_0).primal_0) * dOut_0;
    dps_0->primal_0 = _S5.primal_0;
    dps_0->differential_0 = _S7;
    return;
}

inline __device__ void s_bwdProp_lerp_0(s_bwdCallableCtx_lerp_0 * ctx_0, float * d_x_0, float * d_y_0, float * d_s_0, float d_out_0)
{
    DiffPair_float_0 _S8;
    (&_S8)->primal_0 = ctx_0->_S1;
    DiffPair_float_0 _S9;
    (&_S9)->primal_0 = ctx_0->_S2;
    DiffPair_float_0 _S10;
    (&_S10)->primal_0 = ctx_0->_S3;
    _d_lerp_0(&_S8, &_S9, &_S10, d_out_0);
    *d_x_0 = (&_S8)->differential_0;
    *d_y_0 = (&_S9)->differential_0;
    *d_s_0 = (&_S10)->differential_0;
    return;
}

struct Tuple_0
{
    float value0_0;
};

inline __device__ Tuple_0 s_apply_rsqrt_0(float x_0)
{
    Tuple_0 _S11 = { (F32_rsqrt((x_0))) };
    return _S11;
}

struct s_bwdCallableCtx_rsqrt_0
{
    float _S12;
};

inline __device__ void _d_rsqrt_0(DiffPair_float_0 * dpx_1, float dOut_1)
{
    float _S13 = -0.5f / ((*dpx_1).primal_0 * (F32_sqrt(((*dpx_1).primal_0)))) * dOut_1;
    dpx_1->primal_0 = (*dpx_1).primal_0;
    dpx_1->differential_0 = _S13;
    return;
}

inline __device__ void s_bwdProp_rsqrt_0(s_bwdCallableCtx_rsqrt_0 * ctx_1, float * d_x_1, float d_out_1)
{
    DiffPair_float_0 _S14;
    (&_S14)->primal_0 = ctx_1->_S12;
    _d_rsqrt_0(&_S14, d_out_1);
    *d_x_1 = (&_S14)->differential_0;
    return;
}

struct s_bwdCallableCtx_abs_0
{
    float3  _S15;
};

struct DiffPair_vectorx3Cfloatx2C3x3E_0
{
    float3  primal_0;
    float3  differential_0;
};

inline __device__ void _d_abs_vector_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * dpx_2, float3  dOut_2)
{
    float3  _S16 = _slang_select(((*dpx_2).primal_0) > make_float3 (0.0f), make_float3 (1.0f),_slang_select(((*dpx_2).primal_0) == make_float3 (0.0f), make_float3 (0.0f),make_float3 (-1.0f))) * dOut_2;
    dpx_2->primal_0 = (*dpx_2).primal_0;
    dpx_2->differential_0 = _S16;
    return;
}

inline __device__ void s_bwdProp_abs_0(s_bwdCallableCtx_abs_0 * ctx_2, float3  * d_x_2, float3  d_out_2)
{
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S17;
    (&_S17)->primal_0 = ctx_2->_S15;
    _d_abs_vector_0(&_S17, d_out_2);
    *d_x_2 = (&_S17)->differential_0;
    return;
}

struct Tuple_1
{
    float value0_1;
};

inline __device__ Tuple_1 s_apply_sqrt_0(float x_1)
{
    Tuple_1 _S18 = { (F32_sqrt((x_1))) };
    return _S18;
}

struct s_bwdCallableCtx_sqrt_0
{
    float _S19;
};

inline __device__ void _d_sqrt_0(DiffPair_float_0 * dpx_3, float dOut_3)
{
    float _S20 = 0.5f / (F32_sqrt(((F32_max((1.00000001168609742e-07f), ((*dpx_3).primal_0)))))) * dOut_3;
    dpx_3->primal_0 = (*dpx_3).primal_0;
    dpx_3->differential_0 = _S20;
    return;
}

inline __device__ void s_bwdProp_sqrt_0(s_bwdCallableCtx_sqrt_0 * ctx_3, float * d_x_3, float d_out_3)
{
    DiffPair_float_0 _S21;
    (&_S21)->primal_0 = ctx_3->_S19;
    _d_sqrt_0(&_S21, d_out_3);
    *d_x_3 = (&_S21)->differential_0;
    return;
}

struct s_bwdCallableCtx_log10_0
{
    float _S22;
};

inline __device__ void _d_log10_0(DiffPair_float_0 * dpx_4, float dOut_4)
{
    float _S23 = 1.0f / ((*dpx_4).primal_0 * 2.30258512496948242f) * dOut_4;
    dpx_4->primal_0 = (*dpx_4).primal_0;
    dpx_4->differential_0 = _S23;
    return;
}

inline __device__ void s_bwdProp_log10_0(s_bwdCallableCtx_log10_0 * ctx_4, float * d_x_4, float d_out_4)
{
    DiffPair_float_0 _S24;
    (&_S24)->primal_0 = ctx_4->_S22;
    _d_log10_0(&_S24, d_out_4);
    *d_x_4 = (&_S24)->differential_0;
    return;
}

struct Tuple_2
{
    float value0_2;
};

inline __device__ Tuple_2 s_apply_log_0(float x_2)
{
    Tuple_2 _S25 = { (F32_log((x_2))) };
    return _S25;
}

struct s_bwdCallableCtx_log_0
{
    float _S26;
};

inline __device__ void _d_log_0(DiffPair_float_0 * dpx_5, float dOut_5)
{
    float _S27 = 1.0f / (*dpx_5).primal_0 * dOut_5;
    dpx_5->primal_0 = (*dpx_5).primal_0;
    dpx_5->differential_0 = _S27;
    return;
}

inline __device__ void s_bwdProp_log_0(s_bwdCallableCtx_log_0 * ctx_5, float * d_x_5, float d_out_5)
{
    DiffPair_float_0 _S28;
    (&_S28)->primal_0 = ctx_5->_S26;
    _d_log_0(&_S28, d_out_5);
    *d_x_5 = (&_S28)->differential_0;
    return;
}

struct Tuple_3
{
    float value0_3;
};

inline __device__ Tuple_3 s_apply_max_0(float x_3, float y_0)
{
    Tuple_3 _S29 = { (F32_max((x_3), (y_0))) };
    return _S29;
}

struct s_bwdCallableCtx_max_0
{
    float _S30;
    float _S31;
};

inline __device__ void _d_max_0(DiffPair_float_0 * dpx_6, DiffPair_float_0 * dpy_1, float dOut_6)
{
    DiffPair_float_0 _S32 = *dpx_6;
    float _S33;
    if(((*dpx_6).primal_0) > ((*dpy_1).primal_0))
    {
        _S33 = dOut_6;
    }
    else
    {
        if(((*dpx_6).primal_0) < ((*dpy_1).primal_0))
        {
            _S33 = 0.0f;
        }
        else
        {
            _S33 = 0.5f * dOut_6;
        }
    }
    dpx_6->primal_0 = _S32.primal_0;
    dpx_6->differential_0 = _S33;
    DiffPair_float_0 _S34 = *dpy_1;
    if(((*dpy_1).primal_0) > (_S32.primal_0))
    {
        _S33 = dOut_6;
    }
    else
    {
        if(((*dpy_1).primal_0) < ((*dpx_6).primal_0))
        {
            _S33 = 0.0f;
        }
        else
        {
            _S33 = 0.5f * dOut_6;
        }
    }
    dpy_1->primal_0 = _S34.primal_0;
    dpy_1->differential_0 = _S33;
    return;
}

inline __device__ void s_bwdProp_max_0(s_bwdCallableCtx_max_0 * ctx_6, float * d_x_6, float * d_y_1, float d_out_6)
{
    DiffPair_float_0 _S35;
    (&_S35)->primal_0 = ctx_6->_S30;
    DiffPair_float_0 _S36;
    (&_S36)->primal_0 = ctx_6->_S31;
    _d_max_0(&_S35, &_S36, d_out_6);
    *d_x_6 = (&_S35)->differential_0;
    *d_y_1 = (&_S36)->differential_0;
    return;
}

struct Tuple_4
{
    float value0_4;
};

inline __device__ float clamp_0(float x_4, float minBound_0, float maxBound_0)
{
    return (F32_min(((F32_max((x_4), (minBound_0)))), (maxBound_0)));
}

inline __device__ Tuple_4 s_apply_clamp_0(float x_5, float minBound_1, float maxBound_1)
{
    Tuple_4 _S37 = { clamp_0(x_5, minBound_1, maxBound_1) };
    return _S37;
}

struct s_bwdCallableCtx_clamp_0
{
    float _S38;
    float _S39;
    float _S40;
};

inline __device__ void _d_clamp_0(DiffPair_float_0 * dpx_7, DiffPair_float_0 * dpMin_0, DiffPair_float_0 * dpMax_0, float dOut_7)
{
    DiffPair_float_0 _S41 = *dpx_7;
    bool _S42;
    if(((*dpx_7).primal_0) >= ((*dpMin_0).primal_0))
    {
        _S42 = ((*dpx_7).primal_0) <= ((*dpMax_0).primal_0);
    }
    else
    {
        _S42 = false;
    }
    float _S43;
    if(_S42)
    {
        _S43 = dOut_7;
    }
    else
    {
        _S43 = 0.0f;
    }
    dpx_7->primal_0 = _S41.primal_0;
    dpx_7->differential_0 = _S43;
    DiffPair_float_0 _S44 = *dpMin_0;
    if((_S41.primal_0) < ((*dpMin_0).primal_0))
    {
        _S43 = dOut_7;
    }
    else
    {
        _S43 = 0.0f;
    }
    dpMin_0->primal_0 = _S44.primal_0;
    dpMin_0->differential_0 = _S43;
    DiffPair_float_0 _S45 = *dpMax_0;
    if(((*dpx_7).primal_0) > ((*dpMax_0).primal_0))
    {
        _S43 = dOut_7;
    }
    else
    {
        _S43 = 0.0f;
    }
    dpMax_0->primal_0 = _S45.primal_0;
    dpMax_0->differential_0 = _S43;
    return;
}

inline __device__ void s_bwdProp_clamp_0(s_bwdCallableCtx_clamp_0 * ctx_7, float * d_x_7, float * d_minBound_0, float * d_maxBound_0, float d_out_7)
{
    DiffPair_float_0 _S46;
    (&_S46)->primal_0 = ctx_7->_S38;
    DiffPair_float_0 _S47;
    (&_S47)->primal_0 = ctx_7->_S39;
    DiffPair_float_0 _S48;
    (&_S48)->primal_0 = ctx_7->_S40;
    _d_clamp_0(&_S46, &_S47, &_S48, d_out_7);
    *d_x_7 = (&_S46)->differential_0;
    *d_minBound_0 = (&_S47)->differential_0;
    *d_maxBound_0 = (&_S48)->differential_0;
    return;
}

struct s_bwdCallableCtx_abs_1
{
    float _S49;
};

inline __device__ void _d_abs_0(DiffPair_float_0 * dpx_8, float dOut_8)
{
    float _S50 = _slang_select(((*dpx_8).primal_0) > 0.0f, 1.0f,_slang_select(((*dpx_8).primal_0) == 0.0f, 0.0f,-1.0f)) * dOut_8;
    dpx_8->primal_0 = (*dpx_8).primal_0;
    dpx_8->differential_0 = _S50;
    return;
}

inline __device__ void s_bwdProp_abs_1(s_bwdCallableCtx_abs_1 * ctx_8, float * d_x_8, float d_out_8)
{
    DiffPair_float_0 _S51;
    (&_S51)->primal_0 = ctx_8->_S49;
    _d_abs_0(&_S51, d_out_8);
    *d_x_8 = (&_S51)->differential_0;
    return;
}

struct Tuple_5
{
    float value0_5;
};

inline __device__ float dot_0(float3  x_6, float3  y_1)
{
    int i_0 = int(0);
    float result_0 = 0.0f;
    for(;;)
    {
        if(i_0 < int(3))
        {
        }
        else
        {
            break;
        }
        float result_1 = result_0 + _slang_vector_get_element(x_6, i_0) * _slang_vector_get_element(y_1, i_0);
        i_0 = i_0 + int(1);
        result_0 = result_1;
    }
    return result_0;
}

inline __device__ Tuple_5 s_apply_dot_0(float3  x_7, float3  y_2)
{
    Tuple_5 _S52 = { dot_0(x_7, y_2) };
    return _S52;
}

struct s_bwdCallableCtx_dot_0
{
    float3  _S53;
    float3  _S54;
};

inline __device__ void _d_dot_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * dpx_9, DiffPair_vectorx3Cfloatx2C3x3E_0 * dpy_2, float dOut_9)
{
    float3  x_d_result_0;
    *&((&x_d_result_0)->x) = (*dpy_2).primal_0.x * dOut_9;
    float3  y_d_result_0;
    *&((&y_d_result_0)->x) = (*dpx_9).primal_0.x * dOut_9;
    *&((&x_d_result_0)->y) = (*dpy_2).primal_0.y * dOut_9;
    *&((&y_d_result_0)->y) = (*dpx_9).primal_0.y * dOut_9;
    *&((&x_d_result_0)->z) = (*dpy_2).primal_0.z * dOut_9;
    *&((&y_d_result_0)->z) = (*dpx_9).primal_0.z * dOut_9;
    dpx_9->primal_0 = (*dpx_9).primal_0;
    dpx_9->differential_0 = x_d_result_0;
    dpy_2->primal_0 = (*dpy_2).primal_0;
    dpy_2->differential_0 = y_d_result_0;
    return;
}

inline __device__ void s_bwdProp_dot_0(s_bwdCallableCtx_dot_0 * ctx_9, float3  * d_x_9, float3  * d_y_2, float d_out_9)
{
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S55;
    (&_S55)->primal_0 = ctx_9->_S53;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S56;
    (&_S56)->primal_0 = ctx_9->_S54;
    _d_dot_0(&_S55, &_S56, d_out_9);
    *d_x_9 = (&_S55)->differential_0;
    *d_y_2 = (&_S56)->differential_0;
    return;
}

struct Tuple_6
{
    float value0_6;
};

inline __device__ Tuple_6 s_apply_min_0(float x_8, float y_3)
{
    Tuple_6 _S57 = { (F32_min((x_8), (y_3))) };
    return _S57;
}

struct s_bwdCallableCtx_min_0
{
    float _S58;
    float _S59;
};

inline __device__ void _d_min_0(DiffPair_float_0 * dpx_10, DiffPair_float_0 * dpy_3, float dOut_10)
{
    DiffPair_float_0 _S60 = *dpx_10;
    float _S61;
    if(((*dpx_10).primal_0) < ((*dpy_3).primal_0))
    {
        _S61 = dOut_10;
    }
    else
    {
        if(((*dpx_10).primal_0) > ((*dpy_3).primal_0))
        {
            _S61 = 0.0f;
        }
        else
        {
            _S61 = 0.5f * dOut_10;
        }
    }
    dpx_10->primal_0 = _S60.primal_0;
    dpx_10->differential_0 = _S61;
    DiffPair_float_0 _S62 = *dpy_3;
    if(((*dpy_3).primal_0) < (_S60.primal_0))
    {
        _S61 = dOut_10;
    }
    else
    {
        if(((*dpy_3).primal_0) > ((*dpx_10).primal_0))
        {
            _S61 = 0.0f;
        }
        else
        {
            _S61 = 0.5f * dOut_10;
        }
    }
    dpy_3->primal_0 = _S62.primal_0;
    dpy_3->differential_0 = _S61;
    return;
}

inline __device__ void s_bwdProp_min_0(s_bwdCallableCtx_min_0 * ctx_10, float * d_x_10, float * d_y_3, float d_out_10)
{
    DiffPair_float_0 _S63;
    (&_S63)->primal_0 = ctx_10->_S58;
    DiffPair_float_0 _S64;
    (&_S64)->primal_0 = ctx_10->_S59;
    _d_min_0(&_S63, &_S64, d_out_10);
    *d_x_10 = (&_S63)->differential_0;
    *d_y_3 = (&_S64)->differential_0;
    return;
}

inline __device__ void Array_dadd_0(FixedArray<float, 34>  * a_0, FixedArray<float, 34>  * b_0, FixedArray<float, 34>  * _S65)
{
    FixedArray<float, 34>  result_2;
    result_2[int(0)] = (*a_0)[int(0)] + (*b_0)[int(0)];
    result_2[int(1)] = (*a_0)[int(1)] + (*b_0)[int(1)];
    result_2[int(2)] = (*a_0)[int(2)] + (*b_0)[int(2)];
    result_2[int(3)] = (*a_0)[int(3)] + (*b_0)[int(3)];
    result_2[int(4)] = (*a_0)[int(4)] + (*b_0)[int(4)];
    result_2[int(5)] = (*a_0)[int(5)] + (*b_0)[int(5)];
    result_2[int(6)] = (*a_0)[int(6)] + (*b_0)[int(6)];
    result_2[int(7)] = (*a_0)[int(7)] + (*b_0)[int(7)];
    result_2[int(8)] = (*a_0)[int(8)] + (*b_0)[int(8)];
    result_2[int(9)] = (*a_0)[int(9)] + (*b_0)[int(9)];
    result_2[int(10)] = (*a_0)[int(10)] + (*b_0)[int(10)];
    result_2[int(11)] = (*a_0)[int(11)] + (*b_0)[int(11)];
    result_2[int(12)] = (*a_0)[int(12)] + (*b_0)[int(12)];
    result_2[int(13)] = (*a_0)[int(13)] + (*b_0)[int(13)];
    result_2[int(14)] = (*a_0)[int(14)] + (*b_0)[int(14)];
    result_2[int(15)] = (*a_0)[int(15)] + (*b_0)[int(15)];
    result_2[int(16)] = (*a_0)[int(16)] + (*b_0)[int(16)];
    result_2[int(17)] = (*a_0)[int(17)] + (*b_0)[int(17)];
    result_2[int(18)] = (*a_0)[int(18)] + (*b_0)[int(18)];
    result_2[int(19)] = (*a_0)[int(19)] + (*b_0)[int(19)];
    result_2[int(20)] = (*a_0)[int(20)] + (*b_0)[int(20)];
    result_2[int(21)] = (*a_0)[int(21)] + (*b_0)[int(21)];
    result_2[int(22)] = (*a_0)[int(22)] + (*b_0)[int(22)];
    result_2[int(23)] = (*a_0)[int(23)] + (*b_0)[int(23)];
    result_2[int(24)] = (*a_0)[int(24)] + (*b_0)[int(24)];
    result_2[int(25)] = (*a_0)[int(25)] + (*b_0)[int(25)];
    result_2[int(26)] = (*a_0)[int(26)] + (*b_0)[int(26)];
    result_2[int(27)] = (*a_0)[int(27)] + (*b_0)[int(27)];
    result_2[int(28)] = (*a_0)[int(28)] + (*b_0)[int(28)];
    result_2[int(29)] = (*a_0)[int(29)] + (*b_0)[int(29)];
    result_2[int(30)] = (*a_0)[int(30)] + (*b_0)[int(30)];
    result_2[int(31)] = (*a_0)[int(31)] + (*b_0)[int(31)];
    result_2[int(32)] = (*a_0)[int(32)] + (*b_0)[int(32)];
    result_2[int(33)] = (*a_0)[int(33)] + (*b_0)[int(33)];
    *_S65 = result_2;
    return;
}

inline __device__ void Array_dzero_0(FixedArray<float, 34>  * _S66)
{
    (*_S66)[int(0)] = 0.0f;
    (*_S66)[int(1)] = 0.0f;
    (*_S66)[int(2)] = 0.0f;
    (*_S66)[int(3)] = 0.0f;
    (*_S66)[int(4)] = 0.0f;
    (*_S66)[int(5)] = 0.0f;
    (*_S66)[int(6)] = 0.0f;
    (*_S66)[int(7)] = 0.0f;
    (*_S66)[int(8)] = 0.0f;
    (*_S66)[int(9)] = 0.0f;
    (*_S66)[int(10)] = 0.0f;
    (*_S66)[int(11)] = 0.0f;
    (*_S66)[int(12)] = 0.0f;
    (*_S66)[int(13)] = 0.0f;
    (*_S66)[int(14)] = 0.0f;
    (*_S66)[int(15)] = 0.0f;
    (*_S66)[int(16)] = 0.0f;
    (*_S66)[int(17)] = 0.0f;
    (*_S66)[int(18)] = 0.0f;
    (*_S66)[int(19)] = 0.0f;
    (*_S66)[int(20)] = 0.0f;
    (*_S66)[int(21)] = 0.0f;
    (*_S66)[int(22)] = 0.0f;
    (*_S66)[int(23)] = 0.0f;
    (*_S66)[int(24)] = 0.0f;
    (*_S66)[int(25)] = 0.0f;
    (*_S66)[int(26)] = 0.0f;
    (*_S66)[int(27)] = 0.0f;
    (*_S66)[int(28)] = 0.0f;
    (*_S66)[int(29)] = 0.0f;
    (*_S66)[int(30)] = 0.0f;
    (*_S66)[int(31)] = 0.0f;
    (*_S66)[int(32)] = 0.0f;
    (*_S66)[int(33)] = 0.0f;
    return;
}

struct DiffPair_arrayx3Cfloatx2C34x3E_0
{
    FixedArray<float, 34>  primal_0;
    FixedArray<float, 34>  differential_0;
};

struct s_paramCtx_s_bwdCallableCtx_per_pixel_losses_reduce_0
{
    FixedArray<float, 34>  value0_7;
    FixedArray<float, 21>  value1_0;
};

struct s_bwdCallableCtx_per_pixel_losses_reduce_0
{
    s_paramCtx_s_bwdCallableCtx_per_pixel_losses_reduce_0 value0_8;
};

inline __device__ void s_bwdProp_per_pixel_losses_reduce_0(s_bwdCallableCtx_per_pixel_losses_reduce_0 * _S67, FixedArray<float, 34>  * _S68, FixedArray<float, 15>  * _S69)
{
    float _S70 = (&_S67->value0_8)->value0_7[int(0)];
    Tuple_3 _S71 = s_apply_max_0((&_S67->value0_8)->value0_7[int(22)], 1.0f);
    s_bwdCallableCtx_max_0 _S72;
    (&_S72)->_S30 = (&_S67->value0_8)->value0_7[int(22)];
    (&_S72)->_S31 = 1.0f;
    s_bwdCallableCtx_max_0 _S73 = _S72;
    float _S74 = _S71.value0_3 * _S71.value0_3;
    float _S75 = (&_S67->value0_8)->value0_7[int(1)];
    s_bwdCallableCtx_log10_0 _S76;
    (&_S76)->_S22 = (&_S67->value0_8)->value0_7[int(1)] / _S71.value0_3;
    s_bwdCallableCtx_log10_0 _S77 = _S76;
    float _S78 = (&_S67->value0_8)->value0_7[int(23)];
    bool _S79 = ((&_S67->value0_8)->value0_7[int(23)]) > 0.0f;
    bool _S80;
    if(_S79)
    {
        _S80 = ((&_S67->value0_8)->value0_7[int(3)]) != 0.0f;
    }
    else
    {
        _S80 = false;
    }
    float _S81;
    float _S82;
    float _S83;
    float _S84;
    float _S85;
    float _S86;
    float _S87;
    float _S88;
    float _S89;
    float _S90;
    float _S91;
    float _S92;
    s_bwdCallableCtx_clamp_0 _S93;
    s_bwdCallableCtx_sqrt_0 _S94;
    s_bwdCallableCtx_max_0 _S95;
    if(_S80)
    {
        float _S96 = (&_S67->value0_8)->value0_7[int(2)] * (&_S67->value0_8)->value0_7[int(3)];
        float _S97 = _S78 * _S78;
        float _S98 = (&_S67->value0_8)->value0_7[int(6)] - _S96 / _S78;
        float _S99 = (&_S67->value0_8)->value0_7[int(2)] * (&_S67->value0_8)->value0_7[int(2)];
        float _S100 = (&_S67->value0_8)->value0_7[int(4)] - _S99 / _S78;
        float _S101 = (&_S67->value0_8)->value0_7[int(3)] * (&_S67->value0_8)->value0_7[int(3)];
        float _S102 = (&_S67->value0_8)->value0_7[int(5)] - _S101 / _S78;
        float _S103 = _S100 * _S102 + 1.0f;
        Tuple_3 _S104 = s_apply_max_0(9.999999960041972e-13f, _S103);
        s_bwdCallableCtx_max_0 _S105;
        (&_S105)->_S30 = 9.999999960041972e-13f;
        (&_S105)->_S31 = _S103;
        Tuple_1 _S106 = s_apply_sqrt_0(_S104.value0_3);
        s_bwdCallableCtx_sqrt_0 _S107;
        (&_S107)->_S19 = _S104.value0_3;
        float _S108 = _S106.value0_1 * _S106.value0_1;
        s_bwdCallableCtx_clamp_0 _S109;
        (&_S109)->_S38 = 1.0f - _S98 / _S106.value0_1;
        (&_S109)->_S39 = 0.0f;
        (&_S109)->_S40 = 2.0f;
        _S81 = (&_S67->value0_8)->value1_0[int(6)];
        _S93 = _S109;
        _S82 = _S108;
        _S83 = _S98;
        _S84 = _S106.value0_1;
        _S94 = _S107;
        _S95 = _S105;
        _S85 = _S100;
        _S86 = _S102;
        _S87 = _S97;
        _S88 = _S101;
        _S89 = (&_S67->value0_8)->value0_7[int(3)];
        _S90 = _S99;
        _S91 = (&_S67->value0_8)->value0_7[int(2)];
        _S92 = _S96;
    }
    else
    {
        _S81 = 0.0f;
        (&_S93)->_S38 = 0.0f;
        (&_S93)->_S39 = 0.0f;
        (&_S93)->_S40 = 0.0f;
        _S82 = 0.0f;
        _S83 = 0.0f;
        _S84 = 0.0f;
        (&_S94)->_S19 = 0.0f;
        (&_S95)->_S30 = 0.0f;
        (&_S95)->_S31 = 0.0f;
        _S85 = 0.0f;
        _S86 = 0.0f;
        _S87 = 0.0f;
        _S88 = 0.0f;
        _S89 = 0.0f;
        _S90 = 0.0f;
        _S91 = 0.0f;
        _S92 = 0.0f;
    }
    float _S110 = (&_S67->value0_8)->value0_7[int(7)];
    Tuple_3 _S111 = s_apply_max_0((&_S67->value0_8)->value0_7[int(24)], 1.0f);
    s_bwdCallableCtx_max_0 _S112;
    (&_S112)->_S30 = (&_S67->value0_8)->value0_7[int(24)];
    (&_S112)->_S31 = 1.0f;
    s_bwdCallableCtx_max_0 _S113 = _S112;
    float _S114 = _S111.value0_3 * _S111.value0_3;
    float _S115 = (&_S67->value0_8)->value0_7[int(8)];
    Tuple_3 _S116 = s_apply_max_0((&_S67->value0_8)->value0_7[int(25)], 1.0f);
    s_bwdCallableCtx_max_0 _S117;
    (&_S117)->_S30 = (&_S67->value0_8)->value0_7[int(25)];
    (&_S117)->_S31 = 1.0f;
    s_bwdCallableCtx_max_0 _S118 = _S117;
    float _S119 = _S116.value0_3 * _S116.value0_3;
    float _S120 = float((I32_max((int(((&_S67->value0_8)->value0_7[int(24)]) > 0.5f) + int(((&_S67->value0_8)->value0_7[int(25)]) > 0.5f)), (int(1)))));
    float _S121 = (&_S67->value0_8)->value0_7[int(9)];
    Tuple_3 _S122 = s_apply_max_0((&_S67->value0_8)->value0_7[int(27)], 1.0f);
    s_bwdCallableCtx_max_0 _S123;
    (&_S123)->_S30 = (&_S67->value0_8)->value0_7[int(27)];
    (&_S123)->_S31 = 1.0f;
    s_bwdCallableCtx_max_0 _S124 = _S123;
    float _S125 = _S122.value0_3 * _S122.value0_3;
    float _S126 = (&_S67->value0_8)->value0_7[int(10)];
    Tuple_3 _S127 = s_apply_max_0((&_S67->value0_8)->value0_7[int(28)], 1.0f);
    s_bwdCallableCtx_max_0 _S128;
    (&_S128)->_S30 = (&_S67->value0_8)->value0_7[int(28)];
    (&_S128)->_S31 = 1.0f;
    s_bwdCallableCtx_max_0 _S129 = _S128;
    float _S130 = _S127.value0_3 * _S127.value0_3;
    float _S131 = (&_S67->value0_8)->value0_7[int(11)];
    Tuple_3 _S132 = s_apply_max_0((&_S67->value0_8)->value0_7[int(26)], 1.0f);
    s_bwdCallableCtx_max_0 _S133;
    (&_S133)->_S30 = (&_S67->value0_8)->value0_7[int(26)];
    (&_S133)->_S31 = 1.0f;
    s_bwdCallableCtx_max_0 _S134 = _S133;
    float _S135 = _S132.value0_3 * _S132.value0_3;
    float _S136 = (&_S67->value0_8)->value0_7[int(12)];
    float _S137 = (&_S67->value0_8)->value0_7[int(13)];
    float _S138 = (&_S67->value0_8)->value0_7[int(14)];
    float _S139 = (&_S67->value0_8)->value0_7[int(15)];
    float _S140 = (&_S67->value0_8)->value0_7[int(16)];
    Tuple_3 _S141 = s_apply_max_0((&_S67->value0_8)->value0_7[int(29)], 1.0f);
    s_bwdCallableCtx_max_0 _S142;
    (&_S142)->_S30 = (&_S67->value0_8)->value0_7[int(29)];
    (&_S142)->_S31 = 1.0f;
    s_bwdCallableCtx_max_0 _S143 = _S142;
    float _S144 = _S141.value0_3 * _S141.value0_3;
    float _S145 = (&_S67->value0_8)->value0_7[int(17)];
    Tuple_3 _S146 = s_apply_max_0((&_S67->value0_8)->value0_7[int(30)], 1.0f);
    s_bwdCallableCtx_max_0 _S147;
    (&_S147)->_S30 = (&_S67->value0_8)->value0_7[int(30)];
    (&_S147)->_S31 = 1.0f;
    s_bwdCallableCtx_max_0 _S148 = _S147;
    float _S149 = _S146.value0_3 * _S146.value0_3;
    float _S150 = (&_S67->value0_8)->value0_7[int(18)];
    Tuple_3 _S151 = s_apply_max_0((&_S67->value0_8)->value0_7[int(31)], 1.0f);
    s_bwdCallableCtx_max_0 _S152;
    (&_S152)->_S30 = (&_S67->value0_8)->value0_7[int(31)];
    (&_S152)->_S31 = 1.0f;
    s_bwdCallableCtx_max_0 _S153 = _S152;
    float _S154 = _S151.value0_3 * _S151.value0_3;
    float _S155 = (&_S67->value0_8)->value0_7[int(19)];
    Tuple_3 _S156 = s_apply_max_0((&_S67->value0_8)->value0_7[int(32)], 1.0f);
    s_bwdCallableCtx_max_0 _S157;
    (&_S157)->_S30 = (&_S67->value0_8)->value0_7[int(32)];
    (&_S157)->_S31 = 1.0f;
    s_bwdCallableCtx_max_0 _S158 = _S157;
    float _S159 = _S156.value0_3 * _S156.value0_3;
    float _S160 = (&_S67->value0_8)->value0_7[int(20)];
    Tuple_3 _S161 = s_apply_max_0((&_S67->value0_8)->value0_7[int(33)], 1.0f);
    s_bwdCallableCtx_max_0 _S162;
    (&_S162)->_S30 = (&_S67->value0_8)->value0_7[int(33)];
    (&_S162)->_S31 = 1.0f;
    s_bwdCallableCtx_max_0 _S163 = _S162;
    float _S164 = _S161.value0_3 * _S161.value0_3;
    FixedArray<float, 34>  _S165;
    Array_dzero_0(&_S165);
    FixedArray<float, 34>  _S166 = _S165;
    float _S167 = (*_S69)[int(0)];
    float _S168 = (*_S69)[int(1)];
    float _S169 = (*_S69)[int(2)];
    float _S170 = (*_S69)[int(14)] / _S164;
    float _S171 = _S160 * - _S170;
    float _S172 = _S161.value0_3 * _S170;
    float _S173 = 0.0f;
    float _S174 = 0.0f;
    s_bwdCallableCtx_max_0 _S175 = _S163;
    s_bwdProp_max_0(&_S175, &_S173, &_S174, _S171);
    float _S176 = (*_S69)[int(13)] / _S159;
    float _S177 = _S155 * - _S176;
    float _S178 = _S156.value0_3 * _S176;
    float _S179 = 0.0f;
    float _S180 = 0.0f;
    s_bwdCallableCtx_max_0 _S181 = _S158;
    s_bwdProp_max_0(&_S181, &_S179, &_S180, _S177);
    float _S182 = (*_S69)[int(12)] / _S154;
    float _S183 = _S150 * - _S182;
    float _S184 = _S151.value0_3 * _S182;
    float _S185 = 0.0f;
    float _S186 = 0.0f;
    s_bwdCallableCtx_max_0 _S187 = _S153;
    s_bwdProp_max_0(&_S187, &_S185, &_S186, _S183);
    float _S188 = (*_S69)[int(11)] / _S149;
    float _S189 = _S145 * - _S188;
    float _S190 = _S146.value0_3 * _S188;
    float _S191 = 0.0f;
    float _S192 = 0.0f;
    s_bwdCallableCtx_max_0 _S193 = _S148;
    s_bwdProp_max_0(&_S193, &_S191, &_S192, _S189);
    float _S194 = (*_S69)[int(10)] / _S144;
    float _S195 = _S140 * - _S194;
    float _S196 = _S141.value0_3 * _S194;
    float _S197 = 0.0f;
    float _S198 = 0.0f;
    s_bwdCallableCtx_max_0 _S199 = _S143;
    s_bwdProp_max_0(&_S199, &_S197, &_S198, _S195);
    float _S200 = (*_S69)[int(9)] / _S74;
    float _S201 = _S139 * - _S200;
    float _S202 = _S71.value0_3 * _S200;
    float _S203 = (*_S69)[int(8)] / _S74;
    float _S204 = _S138 * - _S203;
    float _S205 = _S71.value0_3 * _S203;
    float _S206 = (*_S69)[int(7)] / _S74;
    float _S207 = _S137 * - _S206;
    float _S208 = _S71.value0_3 * _S206;
    float _S209 = (*_S69)[int(6)] / _S74;
    float _S210 = _S136 * - _S209;
    float _S211 = _S71.value0_3 * _S209;
    float _S212 = (*_S69)[int(5)] / _S135;
    float _S213 = _S131 * - _S212;
    float _S214 = _S132.value0_3 * _S212;
    float _S215 = 0.0f;
    float _S216 = 0.0f;
    s_bwdCallableCtx_max_0 _S217 = _S134;
    s_bwdProp_max_0(&_S217, &_S215, &_S216, _S213);
    float _S218 = (*_S69)[int(4)] / _S130;
    float _S219 = _S126 * - _S218;
    float _S220 = _S127.value0_3 * _S218;
    float _S221 = 0.0f;
    float _S222 = 0.0f;
    s_bwdCallableCtx_max_0 _S223 = _S129;
    s_bwdProp_max_0(&_S223, &_S221, &_S222, _S219);
    float _S224 = (*_S69)[int(4)] / _S125;
    float _S225 = _S121 * - _S224;
    float _S226 = _S122.value0_3 * _S224;
    float _S227 = 0.0f;
    float _S228 = 0.0f;
    s_bwdCallableCtx_max_0 _S229 = _S124;
    s_bwdProp_max_0(&_S229, &_S227, &_S228, _S225);
    float _S230 = (*_S69)[int(3)] / _S120;
    float _S231 = _S230 / _S119;
    float _S232 = _S115 * - _S231;
    float _S233 = _S116.value0_3 * _S231;
    float _S234 = 0.0f;
    float _S235 = 0.0f;
    s_bwdCallableCtx_max_0 _S236 = _S118;
    s_bwdProp_max_0(&_S236, &_S234, &_S235, _S232);
    float _S237 = _S230 / _S114;
    float _S238 = _S110 * - _S237;
    float _S239 = _S111.value0_3 * _S237;
    float _S240 = 0.0f;
    float _S241 = 0.0f;
    s_bwdCallableCtx_max_0 _S242 = _S113;
    s_bwdProp_max_0(&_S242, &_S240, &_S241, _S238);
    float _S243 = _S201 + _S204 + _S207 + _S210;
    FixedArray<float, 34>  _S244 = _S165;
    _S244[int(33)] = _S173;
    _S244[int(20)] = _S172;
    _S244[int(32)] = _S179;
    _S244[int(19)] = _S178;
    _S244[int(31)] = _S185;
    _S244[int(18)] = _S184;
    _S244[int(30)] = _S191;
    _S244[int(17)] = _S190;
    _S244[int(29)] = _S197;
    _S244[int(16)] = _S196;
    _S244[int(15)] = _S202;
    _S244[int(14)] = _S205;
    _S244[int(13)] = _S208;
    _S244[int(12)] = _S211;
    _S244[int(26)] = _S215;
    _S244[int(11)] = _S214;
    _S244[int(28)] = _S221;
    _S244[int(10)] = _S220;
    _S244[int(27)] = _S227;
    _S244[int(9)] = _S226;
    _S244[int(25)] = _S234;
    _S244[int(8)] = _S233;
    _S244[int(24)] = _S240;
    _S244[int(7)] = _S239;
    FixedArray<float, 34>  _S245 = _S165;
    FixedArray<float, 34>  _S246 = _S244;
    FixedArray<float, 34>  _S247;
    Array_dadd_0(&_S245, &_S246, &_S247);
    FixedArray<float, 34>  _S248 = _S247;
    FixedArray<float, 34>  _S249;
    if(_S80)
    {
        float _S250 = _S81 * _S169;
        float _S251 = 0.0f;
        float _S252 = 0.0f;
        float _S253 = 0.0f;
        s_bwdCallableCtx_clamp_0 _S254 = _S93;
        s_bwdProp_clamp_0(&_S254, &_S251, &_S252, &_S253, _S250);
        float _S255 = - _S251 / _S82;
        float _S256 = _S83 * - _S255;
        float _S257 = _S84 * _S255;
        float _S258 = 0.0f;
        s_bwdCallableCtx_sqrt_0 _S259 = _S94;
        s_bwdProp_sqrt_0(&_S259, &_S258, _S256);
        float _S260 = 0.0f;
        float _S261 = 0.0f;
        s_bwdCallableCtx_max_0 _S262 = _S95;
        s_bwdProp_max_0(&_S262, &_S260, &_S261, _S258);
        float _S263 = _S85 * _S261;
        float _S264 = _S86 * _S261;
        float _S265 = - _S263 / _S87;
        float _S266 = _S89 * (_S78 * _S265);
        float _S267 = - _S264 / _S87;
        float _S268 = _S91 * (_S78 * _S267);
        float _S269 = - _S257 / _S87;
        float _S270 = _S78 * _S269;
        float _S271 = _S266 + _S266 + _S91 * _S270;
        float _S272 = _S268 + _S268 + _S89 * _S270;
        float _S273 = _S88 * - _S265 + _S90 * - _S267 + _S92 * - _S269;
        FixedArray<float, 34>  _S274 = _S166;
        _S274[int(5)] = _S263;
        _S274[int(4)] = _S264;
        _S274[int(3)] = _S271;
        _S274[int(2)] = _S272;
        _S274[int(6)] = _S257;
        FixedArray<float, 34>  _S275 = _S248;
        FixedArray<float, 34>  _S276 = _S274;
        FixedArray<float, 34>  _S277;
        Array_dadd_0(&_S275, &_S276, &_S277);
        _S249 = _S277;
        _S81 = _S273;
    }
    else
    {
        _S249 = _S248;
        _S81 = 0.0f;
    }
    if(_S79)
    {
        FixedArray<float, 34>  _S278 = _S166;
        _S278[int(3)] = 0.0f;
        FixedArray<float, 34>  _S279 = _S249;
        FixedArray<float, 34>  _S280 = _S278;
        FixedArray<float, 34>  _S281;
        Array_dadd_0(&_S279, &_S280, &_S281);
        _S249 = _S281;
    }
    else
    {
    }
    float _S282 = -10.0f * _S168;
    float _S283 = 0.0f;
    s_bwdCallableCtx_log10_0 _S284 = _S77;
    s_bwdProp_log10_0(&_S284, &_S283, _S282);
    float _S285 = _S283 / _S74;
    float _S286 = _S71.value0_3 * _S285;
    float _S287 = _S167 / _S74;
    float _S288 = _S71.value0_3 * _S287;
    float _S289 = _S75 * - _S285 + _S70 * - _S287 + _S243;
    float _S290 = 0.0f;
    float _S291 = 0.0f;
    s_bwdCallableCtx_max_0 _S292 = _S73;
    s_bwdProp_max_0(&_S292, &_S290, &_S291, _S289);
    FixedArray<float, 34>  _S293 = _S166;
    _S293[int(23)] = _S81;
    _S293[int(1)] = _S286;
    _S293[int(22)] = _S290;
    _S293[int(0)] = _S288;
    FixedArray<float, 34>  _S294 = _S249;
    FixedArray<float, 34>  _S295 = _S293;
    FixedArray<float, 34>  _S296;
    Array_dadd_0(&_S294, &_S295, &_S296);
    *_S68 = _S296;
    return;
}

inline __device__ void _S297(DiffPair_arrayx3Cfloatx2C34x3E_0 * _S298, FixedArray<float, 21>  * _S299, FixedArray<float, 15>  * _S300)
{
    s_paramCtx_s_bwdCallableCtx_per_pixel_losses_reduce_0 _S301;
    (&_S301)->value0_7 = _S298->primal_0;
    (&_S301)->value1_0 = *_S299;
    s_bwdCallableCtx_per_pixel_losses_reduce_0 _S302;
    (&_S302)->value0_8 = _S301;
    s_bwdProp_per_pixel_losses_reduce_0(&_S302, &_S298->differential_0, _S300);
    return;
}

struct s_paramCtx_s_bwdCallableCtx_per_pixel_losses_0
{
    float3  value0_9;
    float3  value1_1;
    float value2_0;
    float value3_0;
    float3  value4_0;
    float3  value5_0;
    float3  value6_0;
    float value7_0;
    float value11_0;
    float3  value12_0;
    uint value13_0;
    bool value14_0;
    float value15_0;
    FixedArray<float, 21>  value16_0;
};

struct s_bwdCallableCtx_per_pixel_losses_0
{
    s_paramCtx_s_bwdCallableCtx_per_pixel_losses_0 value0_10;
};

struct Tuple_7
{
    float3  value0_11;
};

inline __device__ Tuple_7 s_apply_rgb_to_yuv_0(float3  _S303)
{
    float _S304 = _S303.x;
    float _S305 = _S303.y;
    float _S306 = _S303.z;
    Tuple_7 _S307;
    (&_S307)->value0_11 = make_float3 (0.29899999499320984f * _S304 + 0.58700001239776611f * _S305 + 0.11400000005960464f * _S306, -0.14712999761104584f * _S304 - 0.28885999321937561f * _S305 + 0.43599998950958252f * _S306, 0.61500000953674316f * _S304 - 0.51498997211456299f * _S305 - 0.10001000016927719f * _S306);
    return _S307;
}

struct s_paramCtx_s_bwdCallableCtx_l1_loss_0
{
    float3  value0_12;
    float3  value1_2;
};

struct Tuple_8
{
    float value0_13;
};

inline __device__ Tuple_8 s_apply_l2_loss_0(float3  _S308, float3  _S309)
{
    float3  _S310 = _S309 - _S308;
    Tuple_8 _S311;
    (&_S311)->value0_13 = s_apply_dot_0(_S310, _S310).value0_5 * 0.3333333432674408f;
    return _S311;
}

struct s_paramCtx_s_bwdCallableCtx_l2_loss_0
{
    float3  value0_14;
    float3  value1_3;
};

struct Tuple_9
{
    float3  value0_15;
};

inline __device__ Tuple_9 s_apply_normalize_normal_0(float3  _S312, bool * mask_0)
{
    bool _S313 = *mask_0;
    Tuple_5 _S314 = s_apply_dot_0(_S312, _S312);
    bool _S315 = (_S314.value0_5) == 0.0f;
    float3  _S316;
    bool _S317;
    if(_S315)
    {
        _S316 = make_float3 (0.0f);
        _S317 = false;
    }
    else
    {
        _S317 = _S313;
    }
    bool _S318 = !_S315;
    if(_S318)
    {
        _S316 = _S312 * make_float3 (s_apply_rsqrt_0(_S314.value0_5).value0_0);
    }
    else
    {
    }
    *mask_0 = _S317;
    Tuple_9 _S319;
    (&_S319)->value0_15 = _S316;
    return _S319;
}

struct s_paramCtx_s_bwdCallableCtx_normalize_normal_0
{
    float3  value0_16;
};

struct s_paramCtx_s_bwdCallableCtx_normal_loss_0
{
    float3  value0_17;
    float3  value1_4;
};

struct s_paramCtx_s_bwdCallableCtx_alpha_loss_0
{
    float value0_18;
    float value1_5;
};

inline __device__ void s_bwdProp_mean3_0(float3  * _S320, float _S321)
{
    float _S322 = 0.3333333432674408f * _S321;
    *_S320 = make_float3 (_S322, _S322, _S322);
    return;
}

struct s_bwdCallableCtx_alpha_loss_0
{
    s_paramCtx_s_bwdCallableCtx_alpha_loss_0 value0_19;
};

struct s_paramCtx_s_bwdCallableCtx_bce_loss_0
{
    float value0_20;
    float value1_6;
};

struct s_bwdCallableCtx_bce_loss_0
{
    s_paramCtx_s_bwdCallableCtx_bce_loss_0 value0_21;
};

inline __device__ void s_bwdProp_bce_loss_0(s_bwdCallableCtx_bce_loss_0 * _S323, float * _S324, float * _S325, float _S326)
{
    float _S327 = 1.0f - (&_S323->value0_21)->value0_20;
    Tuple_3 _S328 = s_apply_max_0(_S327, 9.99999997475242708e-07f);
    s_bwdCallableCtx_max_0 _S329;
    (&_S329)->_S30 = _S327;
    (&_S329)->_S31 = 9.99999997475242708e-07f;
    Tuple_2 _S330 = s_apply_log_0(_S328.value0_3);
    s_bwdCallableCtx_log_0 _S331;
    (&_S331)->_S26 = _S328.value0_3;
    Tuple_3 _S332 = s_apply_max_0((&_S323->value0_21)->value0_20, 9.99999997475242708e-07f);
    s_bwdCallableCtx_max_0 _S333;
    (&_S333)->_S30 = (&_S323->value0_21)->value0_20;
    (&_S333)->_S31 = 9.99999997475242708e-07f;
    Tuple_2 _S334 = s_apply_log_0(_S332.value0_3);
    s_bwdCallableCtx_log_0 _S335;
    (&_S335)->_S26 = _S332.value0_3;
    s_bwdCallableCtx_lerp_0 _S336;
    (&_S336)->_S1 = _S330.value0_2;
    (&_S336)->_S2 = _S334.value0_2;
    (&_S336)->_S3 = (&_S323->value0_21)->value1_6;
    float _S337 = - _S326;
    float _S338 = 0.0f;
    float _S339 = 0.0f;
    float _S340 = 0.0f;
    s_bwdCallableCtx_lerp_0 _S341 = _S336;
    s_bwdProp_lerp_0(&_S341, &_S338, &_S339, &_S340, _S337);
    float _S342 = 0.0f;
    s_bwdCallableCtx_log_0 _S343 = _S335;
    s_bwdProp_log_0(&_S343, &_S342, _S339);
    float _S344 = 0.0f;
    float _S345 = 0.0f;
    s_bwdCallableCtx_max_0 _S346 = _S333;
    s_bwdProp_max_0(&_S346, &_S344, &_S345, _S342);
    float _S347 = 0.0f;
    s_bwdCallableCtx_log_0 _S348 = _S331;
    s_bwdProp_log_0(&_S348, &_S347, _S338);
    float _S349 = 0.0f;
    float _S350 = 0.0f;
    s_bwdCallableCtx_max_0 _S351 = _S329;
    s_bwdProp_max_0(&_S351, &_S349, &_S350, _S347);
    *_S324 = _S344 + - _S349;
    *_S325 = _S340;
    return;
}

inline __device__ void s_bwdProp_alpha_loss_0(s_bwdCallableCtx_alpha_loss_0 * _S352, float * _S353, float * _S354, float _S355)
{
    Tuple_3 _S356 = s_apply_max_0((&_S352->value0_19)->value0_18, (&_S352->value0_19)->value1_5);
    s_bwdCallableCtx_max_0 _S357;
    (&_S357)->_S30 = (&_S352->value0_19)->value0_18;
    (&_S357)->_S31 = (&_S352->value0_19)->value1_5;
    s_paramCtx_s_bwdCallableCtx_bce_loss_0 _S358;
    (&_S358)->value0_20 = _S356.value0_3;
    (&_S358)->value1_6 = (&_S352->value0_19)->value1_5;
    float _S359 = 0.0f;
    float _S360 = 0.0f;
    s_bwdCallableCtx_bce_loss_0 _S361;
    (&_S361)->value0_21 = _S358;
    s_bwdProp_bce_loss_0(&_S361, &_S359, &_S360, _S355);
    float _S362 = 0.0f;
    float _S363 = 0.0f;
    s_bwdCallableCtx_max_0 _S364 = _S357;
    s_bwdProp_max_0(&_S364, &_S362, &_S363, _S359);
    float _S365 = _S360 + _S363;
    *_S353 = _S362;
    *_S354 = _S365;
    return;
}

struct s_bwdCallableCtx_normal_loss_0
{
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 value0_22;
};

inline __device__ void s_bwdProp_normal_loss_0(s_bwdCallableCtx_normal_loss_0 * _S366, float3  * _S367, float3  * _S368, float _S369)
{
    Tuple_5 _S370 = s_apply_dot_0((&_S366->value0_22)->value0_17, (&_S366->value0_22)->value1_4);
    s_bwdCallableCtx_dot_0 _S371;
    (&_S371)->_S53 = (&_S366->value0_22)->value0_17;
    (&_S371)->_S54 = (&_S366->value0_22)->value1_4;
    float cos_sim_loss_0 = 0.5f - 0.5f * _S370.value0_5;
    Tuple_3 _S372 = s_apply_max_0(cos_sim_loss_0, 9.999999960041972e-13f);
    s_bwdCallableCtx_max_0 _S373;
    (&_S373)->_S30 = cos_sim_loss_0;
    (&_S373)->_S31 = 9.999999960041972e-13f;
    s_bwdCallableCtx_sqrt_0 _S374;
    (&_S374)->_S19 = _S372.value0_3;
    float _S375 = 0.0f;
    s_bwdCallableCtx_sqrt_0 _S376 = _S374;
    s_bwdProp_sqrt_0(&_S376, &_S375, _S369);
    float _S377 = 0.0f;
    float _S378 = 0.0f;
    s_bwdCallableCtx_max_0 _S379 = _S373;
    s_bwdProp_max_0(&_S379, &_S377, &_S378, _S375);
    float _S380 = 0.5f * - (_S369 + _S377);
    float3  _S381 = make_float3 (0.0f);
    float3  _S382 = _S381;
    float3  _S383 = _S381;
    s_bwdCallableCtx_dot_0 _S384 = _S371;
    s_bwdProp_dot_0(&_S384, &_S382, &_S383, _S380);
    *_S367 = _S382;
    *_S368 = _S383;
    return;
}

struct s_bwdCallableCtx_normalize_normal_0
{
    s_paramCtx_s_bwdCallableCtx_normalize_normal_0 value0_23;
};

inline __device__ void s_bwdProp_normalize_normal_0(s_bwdCallableCtx_normalize_normal_0 * _S385, float3  * _S386, float3  _S387)
{
    float3  _S388 = make_float3 (0.0f);
    float3  _S389 = (&_S385->value0_23)->value0_16;
    Tuple_5 _S390 = s_apply_dot_0((&_S385->value0_23)->value0_16, (&_S385->value0_23)->value0_16);
    s_bwdCallableCtx_dot_0 _S391;
    (&_S391)->_S53 = (&_S385->value0_23)->value0_16;
    (&_S391)->_S54 = (&_S385->value0_23)->value0_16;
    s_bwdCallableCtx_dot_0 _S392 = _S391;
    bool _S393 = !((_S390.value0_5) == 0.0f);
    float3  _S394;
    s_bwdCallableCtx_rsqrt_0 _S395;
    if(_S393)
    {
        float3  _S396 = make_float3 (s_apply_rsqrt_0(_S390.value0_5).value0_0);
        s_bwdCallableCtx_rsqrt_0 _S397;
        (&_S397)->_S12 = _S390.value0_5;
        _S394 = _S396;
        _S395 = _S397;
    }
    else
    {
        _S394 = _S388;
        (&_S395)->_S12 = 0.0f;
    }
    float _S398;
    if(_S393)
    {
        float3  _S399 = _S389 * _S387;
        float3  _S400 = _S394 * _S387;
        float _S401 = _S399.x + _S399.y + _S399.z;
        float _S402 = 0.0f;
        s_bwdCallableCtx_rsqrt_0 _S403 = _S395;
        s_bwdProp_rsqrt_0(&_S403, &_S402, _S401);
        _S398 = _S402;
        _S394 = _S400;
    }
    else
    {
        _S398 = 0.0f;
        _S394 = _S388;
    }
    float3  _S404 = _S388;
    float3  _S405 = _S388;
    s_bwdCallableCtx_dot_0 _S406 = _S392;
    s_bwdProp_dot_0(&_S406, &_S404, &_S405, _S398);
    *_S386 = _S404 + _S405 + _S394;
    return;
}

struct s_bwdCallableCtx_l2_loss_0
{
    s_paramCtx_s_bwdCallableCtx_l2_loss_0 value0_24;
};

inline __device__ void s_bwdProp_l2_loss_0(s_bwdCallableCtx_l2_loss_0 * _S407, float3  * _S408, float3  * _S409, float _S410)
{
    float3  _S411 = (&_S407->value0_24)->value1_3 - (&_S407->value0_24)->value0_14;
    s_bwdCallableCtx_dot_0 _S412;
    (&_S412)->_S53 = _S411;
    (&_S412)->_S54 = _S411;
    float _S413 = 0.3333333432674408f * _S410;
    float3  _S414 = make_float3 (0.0f);
    float3  _S415 = _S414;
    float3  _S416 = _S414;
    s_bwdCallableCtx_dot_0 _S417 = _S412;
    s_bwdProp_dot_0(&_S417, &_S415, &_S416, _S413);
    float3  _S418 = _S415 + _S416;
    *_S408 = - _S418;
    *_S409 = _S418;
    return;
}

struct s_bwdCallableCtx_l1_loss_0
{
    s_paramCtx_s_bwdCallableCtx_l1_loss_0 value0_25;
};

inline __device__ void s_bwdProp_l1_loss_0(s_bwdCallableCtx_l1_loss_0 * _S419, float3  * _S420, float3  * _S421, float _S422)
{
    s_bwdCallableCtx_abs_0 _S423;
    (&_S423)->_S15 = (&_S419->value0_25)->value1_2 - (&_S419->value0_25)->value0_12;
    float3  _S424 = make_float3 (0.0f);
    float3  _S425 = _S424;
    s_bwdProp_mean3_0(&_S425, _S422);
    float3  _S426 = _S424;
    s_bwdCallableCtx_abs_0 _S427 = _S423;
    s_bwdProp_abs_0(&_S427, &_S426, _S425);
    *_S420 = - _S426;
    *_S421 = _S426;
    return;
}

inline __device__ void s_bwdProp_rgb_to_yuv_0(float3  * _S428, float3  _S429)
{
    float _S430 = - _S429.z;
    *_S428 = make_float3 (0.61500000953674316f * _S429.z + -0.14712999761104584f * _S429.y + 0.29899999499320984f * _S429.x, 0.51498997211456299f * _S430 + 0.28885999321937561f * - _S429.y + 0.58700001239776611f * _S429.x, 0.10001000016927719f * _S430 + 0.43599998950958252f * _S429.y + 0.11400000005960464f * _S429.x);
    return;
}

inline __device__ void s_bwdProp_per_pixel_losses_0(s_bwdCallableCtx_per_pixel_losses_0 * _S431, float3  * _S432, float3  * _S433, float * _S434, float * _S435, float3  * _S436, float3  * _S437, float3  * _S438, float * _S439, float3  * _S440, float * _S441, float3  * _S442, float * _S443, float3  * _S444, FixedArray<float, 34>  * _S445)
{
    float3  _S446 = make_float3 (0.0f);
    uint _S447 = (&_S431->value0_10)->value13_0;
    bool ref_alpha_0 = ((&_S431->value0_10)->value13_0) == 1U;
    bool _S448 = (&_S431->value0_10)->value14_0;
    bool mask_1;
    if((&_S431->value0_10)->value14_0)
    {
        mask_1 = ref_alpha_0;
    }
    else
    {
        mask_1 = true;
    }
    float _S449 = (&_S431->value0_10)->value15_0;
    bool _S450 = ((&_S431->value0_10)->value15_0) > 0.0f;
    bool _S451;
    s_bwdCallableCtx_min_0 _S452;
    s_bwdCallableCtx_min_0 _S453;
    if(_S450)
    {
        float _S454 = (&_S431->value0_10)->value0_9.x;
        float _S455 = (&_S431->value0_10)->value0_9.y;
        Tuple_6 _S456 = s_apply_min_0(_S454, _S455);
        s_bwdCallableCtx_min_0 _S457;
        (&_S457)->_S58 = _S454;
        (&_S457)->_S59 = _S455;
        float _S458 = (&_S431->value0_10)->value0_9.z;
        Tuple_6 _S459 = s_apply_min_0(_S456.value0_6, _S458);
        s_bwdCallableCtx_min_0 _S460;
        (&_S460)->_S58 = _S456.value0_6;
        (&_S460)->_S59 = _S458;
        _S451 = (_S459.value0_6) > _S449;
        _S452 = _S460;
        _S453 = _S457;
    }
    else
    {
        _S451 = false;
        (&_S452)->_S58 = 0.0f;
        (&_S452)->_S59 = 0.0f;
        (&_S453)->_S58 = 0.0f;
        (&_S453)->_S59 = 0.0f;
    }
    bool normal_mask_0;
    s_bwdCallableCtx_min_0 _S461;
    s_bwdCallableCtx_min_0 _S462;
    if(_S451)
    {
        float _S463 = (&_S431->value0_10)->value1_1.x;
        float _S464 = (&_S431->value0_10)->value1_1.y;
        Tuple_6 _S465 = s_apply_min_0(_S463, _S464);
        s_bwdCallableCtx_min_0 _S466;
        (&_S466)->_S58 = _S463;
        (&_S466)->_S59 = _S464;
        float _S467 = (&_S431->value0_10)->value1_1.z;
        Tuple_6 _S468 = s_apply_min_0(_S465.value0_6, _S467);
        s_bwdCallableCtx_min_0 _S469;
        (&_S469)->_S58 = _S465.value0_6;
        (&_S469)->_S59 = _S467;
        normal_mask_0 = (_S468.value0_6) > _S449;
        _S461 = _S469;
        _S462 = _S466;
    }
    else
    {
        normal_mask_0 = false;
        (&_S461)->_S58 = 0.0f;
        (&_S461)->_S59 = 0.0f;
        (&_S462)->_S58 = 0.0f;
        (&_S462)->_S59 = 0.0f;
    }
    if(normal_mask_0)
    {
        mask_1 = false;
    }
    else
    {
    }
    float _S470 = (&_S431->value0_10)->value3_0;
    bool depth_mask_0 = ((&_S431->value0_10)->value3_0) != 0.0f;
    float3  _S471 = (&_S431->value0_10)->value6_0;
    bool _S472 = ((&_S431->value0_10)->value6_0.x + (&_S431->value0_10)->value6_0.y + (&_S431->value0_10)->value6_0.z) > -2.36599993705749512f;
    s_bwdCallableCtx_dot_0 _S473;
    if(_S472)
    {
        Tuple_5 _S474 = s_apply_dot_0(_S471, _S471);
        s_bwdCallableCtx_dot_0 _S475;
        (&_S475)->_S53 = _S471;
        (&_S475)->_S54 = _S471;
        normal_mask_0 = (_S474.value0_5) > 0.25f;
        _S473 = _S475;
    }
    else
    {
        normal_mask_0 = false;
        (&_S473)->_S53 = _S446;
        (&_S473)->_S54 = _S446;
    }
    bool alpha_mask_0;
    if(_S448)
    {
        alpha_mask_0 = _S447 != 2U;
    }
    else
    {
        alpha_mask_0 = false;
    }
    Tuple_7 _S476 = s_apply_rgb_to_yuv_0((&_S431->value0_10)->value0_9);
    Tuple_7 _S477 = s_apply_rgb_to_yuv_0((&_S431->value0_10)->value1_1);
    float dY_0 = _S476.value0_11.x - _S477.value0_11.x;
    float dU_0 = _S476.value0_11.y - _S477.value0_11.y;
    float dV_0 = _S476.value0_11.z - _S477.value0_11.z;
    float _S478 = float(mask_1);
    float _S479 = (&_S431->value0_10)->value16_0[int(0)];
    s_paramCtx_s_bwdCallableCtx_l1_loss_0 _S480;
    (&_S480)->value0_12 = (&_S431->value0_10)->value0_9;
    (&_S480)->value1_2 = (&_S431->value0_10)->value1_1;
    s_paramCtx_s_bwdCallableCtx_l1_loss_0 _S481 = _S480;
    float _S482 = (&_S431->value0_10)->value16_0[int(1)];
    Tuple_8 _S483 = s_apply_l2_loss_0((&_S431->value0_10)->value0_9, (&_S431->value0_10)->value1_1);
    s_paramCtx_s_bwdCallableCtx_l2_loss_0 _S484;
    (&_S484)->value0_14 = (&_S431->value0_10)->value0_9;
    (&_S484)->value1_3 = (&_S431->value0_10)->value1_1;
    s_paramCtx_s_bwdCallableCtx_l2_loss_0 _S485 = _S484;
    float _S486 = (&_S431->value0_10)->value16_0[int(2)];
    s_bwdCallableCtx_abs_1 _S487;
    (&_S487)->_S49 = dY_0;
    s_bwdCallableCtx_abs_1 _S488 = _S487;
    float _S489 = (&_S431->value0_10)->value16_0[int(3)];
    float _S490 = (&_S431->value0_10)->value16_0[int(3)] * dY_0;
    float _S491 = (&_S431->value0_10)->value16_0[int(4)];
    float _S492 = (&_S431->value0_10)->value16_0[int(4)] * dU_0;
    float _S493 = (&_S431->value0_10)->value16_0[int(5)];
    float _S494 = (&_S431->value0_10)->value16_0[int(5)] * dV_0;
    s_bwdCallableCtx_clamp_0 _S495;
    (&_S495)->_S38 = _S483.value0_13;
    (&_S495)->_S39 = 0.0f;
    (&_S495)->_S40 = 1.0f;
    s_bwdCallableCtx_clamp_0 _S496 = _S495;
    bool depth_mask_1 = depth_mask_0 & mask_1;
    bool metric_mask_0;
    if(depth_mask_1)
    {
        metric_mask_0 = ((&_S431->value0_10)->value2_0) > 0.0f;
    }
    else
    {
        metric_mask_0 = false;
    }
    float _S497 = (&_S431->value0_10)->value16_0[int(19)] * float(metric_mask_0);
    float _S498 = (&_S431->value0_10)->value2_0;
    Tuple_3 _S499 = s_apply_max_0((&_S431->value0_10)->value2_0, 0.00009999999747379f);
    s_bwdCallableCtx_max_0 _S500;
    (&_S500)->_S30 = (&_S431->value0_10)->value2_0;
    (&_S500)->_S31 = 0.00009999999747379f;
    s_bwdCallableCtx_max_0 _S501 = _S500;
    Tuple_2 _S502 = s_apply_log_0(_S499.value0_3);
    s_bwdCallableCtx_log_0 _S503;
    (&_S503)->_S26 = _S499.value0_3;
    s_bwdCallableCtx_log_0 _S504 = _S503;
    float _S505 = (&_S431->value0_10)->value16_0[int(20)];
    float _S506 = _S470 * (&_S431->value0_10)->value16_0[int(20)];
    Tuple_3 _S507 = s_apply_max_0(_S506, 0.00009999999747379f);
    s_bwdCallableCtx_max_0 _S508;
    (&_S508)->_S30 = _S506;
    (&_S508)->_S31 = 0.00009999999747379f;
    s_bwdCallableCtx_max_0 _S509 = _S508;
    Tuple_2 _S510 = s_apply_log_0(_S507.value0_3);
    s_bwdCallableCtx_log_0 _S511;
    (&_S511)->_S26 = _S507.value0_3;
    s_bwdCallableCtx_log_0 _S512 = _S511;
    s_bwdCallableCtx_abs_1 _S513;
    (&_S513)->_S49 = _S502.value0_2 - _S510.value0_2;
    s_bwdCallableCtx_abs_1 _S514 = _S513;
    float _S515 = float(depth_mask_1);
    float _S516 = _S515 * _S499.value0_3;
    Tuple_3 _S517 = s_apply_max_0(_S470, 0.00009999999747379f);
    s_bwdCallableCtx_max_0 _S518;
    (&_S518)->_S30 = _S470;
    (&_S518)->_S31 = 0.00009999999747379f;
    s_bwdCallableCtx_max_0 _S519 = _S518;
    float _S520 = _S515 * _S517.value0_3;
    bool _S521 = normal_mask_0 & mask_1;
    bool _S522 = true;
    Tuple_9 _S523 = s_apply_normalize_normal_0((&_S431->value0_10)->value4_0, &_S522);
    s_paramCtx_s_bwdCallableCtx_normalize_normal_0 _S524;
    (&_S524)->value0_16 = (&_S431->value0_10)->value4_0;
    s_paramCtx_s_bwdCallableCtx_normalize_normal_0 _S525 = _S524;
    bool render_normal_mask_0 = _S522;
    bool _S526 = true;
    Tuple_9 _S527 = s_apply_normalize_normal_0((&_S431->value0_10)->value5_0, &_S526);
    s_paramCtx_s_bwdCallableCtx_normalize_normal_0 _S528;
    (&_S528)->value0_16 = (&_S431->value0_10)->value5_0;
    s_paramCtx_s_bwdCallableCtx_normalize_normal_0 _S529 = _S528;
    bool depth_normal_mask_0 = _S526;
    bool _S530 = _S521;
    Tuple_9 _S531 = s_apply_normalize_normal_0(_S471, &_S530);
    s_paramCtx_s_bwdCallableCtx_normalize_normal_0 _S532;
    (&_S532)->value0_16 = _S471;
    s_paramCtx_s_bwdCallableCtx_normalize_normal_0 _S533 = _S532;
    bool normal_mask_1 = _S530;
    float _S534 = (&_S431->value0_10)->value16_0[int(7)] * float(_S522 & _S530);
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 _S535;
    (&_S535)->value0_17 = _S523.value0_15;
    (&_S535)->value1_4 = _S531.value0_15;
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 _S536 = _S535;
    float _S537 = (&_S431->value0_10)->value16_0[int(7)] * float(_S526 & _S530);
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 _S538;
    (&_S538)->value0_17 = _S527.value0_15;
    (&_S538)->value1_4 = _S531.value0_15;
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 _S539 = _S538;
    float _S540 = (&_S431->value0_10)->value16_0[int(10)] * float((_S522 & _S526) & mask_1);
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 _S541;
    (&_S541)->value0_17 = _S523.value0_15;
    (&_S541)->value1_4 = _S527.value0_15;
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 _S542 = _S541;
    bool _S543 = true;
    Tuple_9 _S544 = s_apply_normalize_normal_0((&_S431->value0_10)->value12_0, &_S543);
    s_paramCtx_s_bwdCallableCtx_normalize_normal_0 _S545;
    (&_S545)->value0_16 = (&_S431->value0_10)->value12_0;
    s_paramCtx_s_bwdCallableCtx_normalize_normal_0 _S546 = _S545;
    bool median_normal_mask_0 = _S543;
    if(mask_1)
    {
        normal_mask_0 = _S498 > 1.00000001335143196e-10f;
    }
    else
    {
        normal_mask_0 = false;
    }
    bool mean_median_mask_0;
    if(normal_mask_0)
    {
        mean_median_mask_0 = ((&_S431->value0_10)->value11_0) > 1.00000001335143196e-10f;
    }
    else
    {
        mean_median_mask_0 = false;
    }
    float _S547 = (&_S431->value0_10)->value16_0[int(15)] * float(mean_median_mask_0);
    Tuple_3 _S548 = s_apply_max_0(_S498, 1.00000001335143196e-10f);
    s_bwdCallableCtx_max_0 _S549;
    (&_S549)->_S30 = _S498;
    (&_S549)->_S31 = 1.00000001335143196e-10f;
    s_bwdCallableCtx_max_0 _S550 = _S549;
    Tuple_2 _S551 = s_apply_log_0(_S548.value0_3);
    s_bwdCallableCtx_log_0 _S552;
    (&_S552)->_S26 = _S548.value0_3;
    s_bwdCallableCtx_log_0 _S553 = _S552;
    Tuple_3 _S554 = s_apply_max_0((&_S431->value0_10)->value11_0, 1.00000001335143196e-10f);
    s_bwdCallableCtx_max_0 _S555;
    (&_S555)->_S30 = (&_S431->value0_10)->value11_0;
    (&_S555)->_S31 = 1.00000001335143196e-10f;
    s_bwdCallableCtx_max_0 _S556 = _S555;
    Tuple_2 _S557 = s_apply_log_0(_S554.value0_3);
    s_bwdCallableCtx_log_0 _S558;
    (&_S558)->_S26 = _S554.value0_3;
    s_bwdCallableCtx_log_0 _S559 = _S558;
    s_bwdCallableCtx_abs_1 _S560;
    (&_S560)->_S49 = _S551.value0_2 - _S557.value0_2;
    s_bwdCallableCtx_abs_1 _S561 = _S560;
    float _S562 = (&_S431->value0_10)->value16_0[int(16)] * float((median_normal_mask_0 & depth_normal_mask_0) & mask_1);
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 _S563;
    (&_S563)->value0_17 = _S544.value0_15;
    (&_S563)->value1_4 = _S527.value0_15;
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 _S564 = _S563;
    float _S565 = (&_S431->value0_10)->value16_0[int(17)] * float(median_normal_mask_0 & normal_mask_1);
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 _S566;
    (&_S566)->value0_17 = _S544.value0_15;
    (&_S566)->value1_4 = _S531.value0_15;
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 _S567 = _S566;
    float _S568 = (&_S431->value0_10)->value16_0[int(18)] * float((median_normal_mask_0 & render_normal_mask_0) & mask_1);
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 _S569;
    (&_S569)->value0_17 = _S544.value0_15;
    (&_S569)->value1_4 = _S523.value0_15;
    s_paramCtx_s_bwdCallableCtx_normal_loss_0 _S570 = _S569;
    float _S571 = 1.0f - (&_S431->value0_10)->value7_0;
    Tuple_4 _S572 = s_apply_clamp_0(_S571, 0.0f, 1.0f);
    s_bwdCallableCtx_clamp_0 _S573;
    (&_S573)->_S38 = _S571;
    (&_S573)->_S39 = 0.0f;
    (&_S573)->_S40 = 1.0f;
    s_bwdCallableCtx_clamp_0 _S574 = _S573;
    float _S575 = float(alpha_mask_0);
    float _S576 = (&_S431->value0_10)->value16_0[int(8)] * _S575;
    float _S577 = float(ref_alpha_0);
    s_paramCtx_s_bwdCallableCtx_alpha_loss_0 _S578;
    (&_S578)->value0_18 = _S572.value0_4;
    (&_S578)->value1_5 = _S577;
    s_paramCtx_s_bwdCallableCtx_alpha_loss_0 _S579 = _S578;
    float _S580 = (&_S431->value0_10)->value16_0[int(9)] * _S575;
    float _S581 = 1.0f - _S572.value0_4;
    float _S582 = 1.0f - _S577;
    s_paramCtx_s_bwdCallableCtx_alpha_loss_0 _S583;
    (&_S583)->value0_18 = _S581;
    (&_S583)->value1_5 = _S582;
    s_paramCtx_s_bwdCallableCtx_alpha_loss_0 _S584 = _S583;
    float _S585 = (&_S431->value0_10)->value16_0[int(11)] * _S478 * 4.0f;
    float _S586 = _S585 * _S572.value0_4;
    float _S587 = (&_S431->value0_10)->value16_0[int(12)] * _S478;
    float _S588 = (&_S431->value0_10)->value16_0[int(13)] * _S478;
    float _S589 = (&_S431->value0_10)->value16_0[int(14)] * _S478;
    float _S590 = _S589 * (*_S445)[int(15)];
    float3  _S591 = _S446;
    s_bwdProp_mean3_0(&_S591, _S590);
    float3  _S592 = _S591;
    float _S593 = _S588 * (*_S445)[int(14)];
    float _S594 = _S587 * (*_S445)[int(13)];
    float3  _S595 = _S446;
    s_bwdProp_mean3_0(&_S595, _S594);
    float3  _S596 = _S595;
    float _S597 = _S586 * (*_S445)[int(12)];
    float _S598 = _S585 * (_S581 * (*_S445)[int(12)]);
    float _S599 = _S580 * (*_S445)[int(10)];
    float _S600 = 0.0f;
    float _S601 = 0.0f;
    s_bwdCallableCtx_alpha_loss_0 _S602;
    (&_S602)->value0_19 = _S584;
    s_bwdProp_alpha_loss_0(&_S602, &_S600, &_S601, _S599);
    float _S603 = - (_S597 + _S600);
    float _S604 = _S576 * (*_S445)[int(9)];
    float _S605 = 0.0f;
    float _S606 = 0.0f;
    s_bwdCallableCtx_alpha_loss_0 _S607;
    (&_S607)->value0_19 = _S579;
    s_bwdProp_alpha_loss_0(&_S607, &_S605, &_S606, _S604);
    float _S608 = _S598 + _S603 + _S605;
    float _S609 = 0.0f;
    float _S610 = 0.0f;
    float _S611 = 0.0f;
    s_bwdCallableCtx_clamp_0 _S612 = _S574;
    s_bwdProp_clamp_0(&_S612, &_S609, &_S610, &_S611, _S608);
    float _S613 = - _S609;
    float _S614 = _S568 * (*_S445)[int(19)];
    float3  _S615 = _S446;
    float3  _S616 = _S446;
    s_bwdCallableCtx_normal_loss_0 _S617;
    (&_S617)->value0_22 = _S570;
    s_bwdProp_normal_loss_0(&_S617, &_S615, &_S616, _S614);
    float _S618 = _S565 * (*_S445)[int(18)];
    float3  _S619 = _S446;
    float3  _S620 = _S446;
    s_bwdCallableCtx_normal_loss_0 _S621;
    (&_S621)->value0_22 = _S567;
    s_bwdProp_normal_loss_0(&_S621, &_S619, &_S620, _S618);
    float _S622 = _S562 * (*_S445)[int(17)];
    float3  _S623 = _S446;
    float3  _S624 = _S446;
    s_bwdCallableCtx_normal_loss_0 _S625;
    (&_S625)->value0_22 = _S564;
    s_bwdProp_normal_loss_0(&_S625, &_S623, &_S624, _S622);
    float _S626 = _S547 * (*_S445)[int(16)];
    float _S627 = 0.0f;
    s_bwdCallableCtx_abs_1 _S628 = _S561;
    s_bwdProp_abs_1(&_S628, &_S627, _S626);
    float _S629 = - _S627;
    float _S630 = 0.0f;
    s_bwdCallableCtx_log_0 _S631 = _S559;
    s_bwdProp_log_0(&_S631, &_S630, _S629);
    float _S632 = 0.0f;
    float _S633 = 0.0f;
    s_bwdCallableCtx_max_0 _S634 = _S556;
    s_bwdProp_max_0(&_S634, &_S632, &_S633, _S630);
    float _S635 = _S632;
    float _S636 = 0.0f;
    s_bwdCallableCtx_log_0 _S637 = _S553;
    s_bwdProp_log_0(&_S637, &_S636, _S627);
    float _S638 = 0.0f;
    float _S639 = 0.0f;
    s_bwdCallableCtx_max_0 _S640 = _S550;
    s_bwdProp_max_0(&_S640, &_S638, &_S639, _S636);
    float3  _S641 = _S615 + _S619 + _S623;
    float3  _S642 = _S446;
    s_bwdCallableCtx_normalize_normal_0 _S643;
    (&_S643)->value0_23 = _S546;
    s_bwdProp_normalize_normal_0(&_S643, &_S642, _S641);
    float3  _S644 = _S642;
    float _S645 = _S540 * (*_S445)[int(11)];
    float3  _S646 = _S446;
    float3  _S647 = _S446;
    s_bwdCallableCtx_normal_loss_0 _S648;
    (&_S648)->value0_22 = _S542;
    s_bwdProp_normal_loss_0(&_S648, &_S646, &_S647, _S645);
    float _S649 = _S537 * (*_S445)[int(8)];
    float3  _S650 = _S446;
    float3  _S651 = _S446;
    s_bwdCallableCtx_normal_loss_0 _S652;
    (&_S652)->value0_22 = _S539;
    s_bwdProp_normal_loss_0(&_S652, &_S650, &_S651, _S649);
    float _S653 = _S534 * (*_S445)[int(7)];
    float3  _S654 = _S446;
    float3  _S655 = _S446;
    s_bwdCallableCtx_normal_loss_0 _S656;
    (&_S656)->value0_22 = _S536;
    s_bwdProp_normal_loss_0(&_S656, &_S654, &_S655, _S653);
    float3  _S657 = _S651 + _S655 + _S620;
    float3  _S658 = _S446;
    s_bwdCallableCtx_normalize_normal_0 _S659;
    (&_S659)->value0_23 = _S533;
    s_bwdProp_normalize_normal_0(&_S659, &_S658, _S657);
    float3  _S660 = _S658;
    float3  _S661 = _S647 + _S650 + _S624;
    float3  _S662 = _S446;
    s_bwdCallableCtx_normalize_normal_0 _S663;
    (&_S663)->value0_23 = _S529;
    s_bwdProp_normalize_normal_0(&_S663, &_S662, _S661);
    float3  _S664 = _S662;
    float3  _S665 = _S646 + _S654 + _S616;
    float3  _S666 = _S446;
    s_bwdCallableCtx_normalize_normal_0 _S667;
    (&_S667)->value0_23 = _S525;
    s_bwdProp_normalize_normal_0(&_S667, &_S666, _S665);
    float3  _S668 = _S666;
    float _S669 = _S520 * (*_S445)[int(6)];
    float _S670 = _S520 * (*_S445)[int(5)];
    float _S671 = _S516 * (*_S445)[int(4)];
    float _S672 = _S515 * (_S516 * (*_S445)[int(6)] + _S670 + _S670 + (*_S445)[int(3)]);
    float _S673 = 0.0f;
    float _S674 = 0.0f;
    s_bwdCallableCtx_max_0 _S675 = _S519;
    s_bwdProp_max_0(&_S675, &_S673, &_S674, _S672);
    float _S676 = _S515 * (_S669 + _S671 + _S671 + (*_S445)[int(2)]);
    float _S677 = _S497 * (*_S445)[int(20)];
    float _S678 = 0.0f;
    s_bwdCallableCtx_abs_1 _S679 = _S514;
    s_bwdProp_abs_1(&_S679, &_S678, _S677);
    float _S680 = - _S678;
    float _S681 = 0.0f;
    s_bwdCallableCtx_log_0 _S682 = _S512;
    s_bwdProp_log_0(&_S682, &_S681, _S680);
    float _S683 = 0.0f;
    float _S684 = 0.0f;
    s_bwdCallableCtx_max_0 _S685 = _S509;
    s_bwdProp_max_0(&_S685, &_S683, &_S684, _S681);
    float _S686 = _S505 * _S683;
    float _S687 = 0.0f;
    s_bwdCallableCtx_log_0 _S688 = _S504;
    s_bwdProp_log_0(&_S688, &_S687, _S678);
    float _S689 = _S676 + _S687;
    float _S690 = 0.0f;
    float _S691 = 0.0f;
    s_bwdCallableCtx_max_0 _S692 = _S501;
    s_bwdProp_max_0(&_S692, &_S690, &_S691, _S689);
    float _S693 = _S673 + _S686;
    float _S694 = _S690 + _S638;
    float _S695 = _S478 * (*_S445)[int(1)];
    float _S696 = 0.0f;
    float _S697 = 0.0f;
    float _S698 = 0.0f;
    s_bwdCallableCtx_clamp_0 _S699 = _S496;
    s_bwdProp_clamp_0(&_S699, &_S696, &_S697, &_S698, _S695);
    float _S700 = _S478 * (*_S445)[int(0)];
    float _S701 = _S494 * _S700;
    float _S702 = _S493 * (dV_0 * _S700);
    float _S703 = _S492 * _S700;
    float _S704 = _S491 * (dU_0 * _S700);
    float _S705 = _S490 * _S700;
    float _S706 = _S489 * (dY_0 * _S700);
    float _S707 = _S486 * _S700;
    float _S708 = 0.0f;
    s_bwdCallableCtx_abs_1 _S709 = _S488;
    s_bwdProp_abs_1(&_S709, &_S708, _S707);
    float _S710 = _S696 + _S482 * _S700;
    float3  _S711 = _S446;
    float3  _S712 = _S446;
    s_bwdCallableCtx_l2_loss_0 _S713;
    (&_S713)->value0_24 = _S485;
    s_bwdProp_l2_loss_0(&_S713, &_S711, &_S712, _S710);
    float _S714 = _S479 * _S700;
    float3  _S715 = _S446;
    float3  _S716 = _S446;
    s_bwdCallableCtx_l1_loss_0 _S717;
    (&_S717)->value0_25 = _S481;
    s_bwdProp_l1_loss_0(&_S717, &_S715, &_S716, _S714);
    float _S718 = _S701 + _S702;
    float _S719 = _S703 + _S704;
    float _S720 = _S705 + _S706 + _S708;
    float3  _S721 = make_float3 (- _S720, - _S719, - _S718);
    float3  _S722 = _S446;
    s_bwdProp_rgb_to_yuv_0(&_S722, _S721);
    float3  _S723 = make_float3 (_S720, _S719, _S718);
    float3  _S724 = _S446;
    s_bwdProp_rgb_to_yuv_0(&_S724, _S723);
    float3  _S725 = _S712 + _S716 + _S722;
    float3  _S726 = _S711 + _S715 + _S724;
    float3  _S727;
    if(_S472)
    {
        float3  _S728 = _S446;
        float3  _S729 = _S446;
        s_bwdCallableCtx_dot_0 _S730 = _S473;
        s_bwdProp_dot_0(&_S730, &_S728, &_S729, 0.0f);
        _S727 = _S728 + _S729 + _S660;
    }
    else
    {
        _S727 = _S660;
    }
    float3  _S731;
    if(_S451)
    {
        float _S732 = 0.0f;
        float _S733 = 0.0f;
        s_bwdCallableCtx_min_0 _S734 = _S461;
        s_bwdProp_min_0(&_S734, &_S732, &_S733, 0.0f);
        float _S735 = 0.0f;
        float _S736 = 0.0f;
        s_bwdCallableCtx_min_0 _S737 = _S462;
        s_bwdProp_min_0(&_S737, &_S735, &_S736, _S732);
        _S731 = _S725 + make_float3 (_S735, _S736, _S733);
    }
    else
    {
        _S731 = _S725;
    }
    float3  _S738;
    if(_S450)
    {
        float _S739 = 0.0f;
        float _S740 = 0.0f;
        s_bwdCallableCtx_min_0 _S741 = _S452;
        s_bwdProp_min_0(&_S741, &_S739, &_S740, 0.0f);
        float _S742 = 0.0f;
        float _S743 = 0.0f;
        s_bwdCallableCtx_min_0 _S744 = _S453;
        s_bwdProp_min_0(&_S744, &_S742, &_S743, _S739);
        _S738 = _S726 + make_float3 (_S742, _S743, _S740);
    }
    else
    {
        _S738 = _S726;
    }
    *_S432 = _S738;
    *_S433 = _S731;
    *_S434 = _S694;
    *_S435 = _S693;
    *_S436 = _S668;
    *_S437 = _S664;
    *_S438 = _S727;
    *_S439 = _S613;
    *_S440 = _S596;
    *_S441 = _S593;
    *_S442 = _S592;
    *_S443 = _S635;
    *_S444 = _S644;
    return;
}

inline __device__ void _S745(DiffPair_vectorx3Cfloatx2C3x3E_0 * _S746, DiffPair_vectorx3Cfloatx2C3x3E_0 * _S747, DiffPair_float_0 * _S748, DiffPair_float_0 * _S749, DiffPair_vectorx3Cfloatx2C3x3E_0 * _S750, DiffPair_vectorx3Cfloatx2C3x3E_0 * _S751, DiffPair_vectorx3Cfloatx2C3x3E_0 * _S752, DiffPair_float_0 * _S753, DiffPair_vectorx3Cfloatx2C3x3E_0 * _S754, DiffPair_float_0 * _S755, DiffPair_vectorx3Cfloatx2C3x3E_0 * _S756, DiffPair_float_0 * _S757, DiffPair_vectorx3Cfloatx2C3x3E_0 * _S758, uint _S759, bool _S760, float _S761, FixedArray<float, 21>  * _S762, FixedArray<float, 34>  * _S763)
{
    s_paramCtx_s_bwdCallableCtx_per_pixel_losses_0 _S764;
    (&_S764)->value0_9 = _S746->primal_0;
    (&_S764)->value1_1 = _S747->primal_0;
    (&_S764)->value2_0 = _S748->primal_0;
    (&_S764)->value3_0 = _S749->primal_0;
    (&_S764)->value4_0 = _S750->primal_0;
    (&_S764)->value5_0 = _S751->primal_0;
    (&_S764)->value6_0 = _S752->primal_0;
    (&_S764)->value7_0 = _S753->primal_0;
    (&_S764)->value11_0 = _S757->primal_0;
    (&_S764)->value12_0 = _S758->primal_0;
    (&_S764)->value13_0 = _S759;
    (&_S764)->value14_0 = _S760;
    (&_S764)->value15_0 = _S761;
    (&_S764)->value16_0 = *_S762;
    s_bwdCallableCtx_per_pixel_losses_0 _S765;
    (&_S765)->value0_10 = _S764;
    s_bwdProp_per_pixel_losses_0(&_S765, &_S746->differential_0, &_S747->differential_0, &_S748->differential_0, &_S749->differential_0, &_S750->differential_0, &_S751->differential_0, &_S752->differential_0, &_S753->differential_0, &_S754->differential_0, &_S755->differential_0, &_S756->differential_0, &_S757->differential_0, &_S758->differential_0, _S763);
    return;
}

inline __device__ float lerp_0(float x_9, float y_4, float s_0)
{
    return x_9 + (y_4 - x_9) * s_0;
}

inline __device__ float3  abs_0(float3  x_10)
{
    float3  result_3;
    int i_1 = int(0);
    for(;;)
    {
        if(i_1 < int(3))
        {
        }
        else
        {
            break;
        }
        *_slang_vector_get_element_ptr(&result_3, i_1) = (F32_abs((_slang_vector_get_element(x_10, i_1))));
        i_1 = i_1 + int(1);
    }
    return result_3;
}

inline __device__ void per_pixel_losses(float3  render_rgb_0, float3  ref_rgb_0, float render_depth_0, float ref_depth_0, float3  render_normal_0, float3  depth_normal_0, float3  ref_normal_0, float render_Ts_0, float3  rgb_dist_0, float depth_dist_0, float3  normal_dist_0, float median_depth_0, float3  median_normal_0, uint ref_mask_0, bool has_mask_0, float saturation_threshold_0, FixedArray<float, 21>  weights_0, FixedArray<float, 34>  * _S766)
{
    bool _S767;
    float3  _S768;
    bool _S769;
    float3  _S770;
    float3  _S771;
    bool _S772;
    float3  _S773;
    FixedArray<float, 34>  losses_0;
    bool ref_alpha_1 = ref_mask_0 == 1U;
    bool mask_2;
    if(has_mask_0)
    {
        mask_2 = ref_alpha_1;
    }
    else
    {
        mask_2 = true;
    }
    bool normal_mask_2;
    if(saturation_threshold_0 > 0.0f)
    {
        normal_mask_2 = (F32_min(((F32_min((render_rgb_0.x), (render_rgb_0.y)))), (render_rgb_0.z))) > saturation_threshold_0;
    }
    else
    {
        normal_mask_2 = false;
    }
    if(normal_mask_2)
    {
        normal_mask_2 = (F32_min(((F32_min((ref_rgb_0.x), (ref_rgb_0.y)))), (ref_rgb_0.z))) > saturation_threshold_0;
    }
    else
    {
        normal_mask_2 = false;
    }
    if(normal_mask_2)
    {
        mask_2 = false;
    }
    else
    {
    }
    bool depth_mask_2 = ref_depth_0 != 0.0f;
    if((ref_normal_0.x + ref_normal_0.y + ref_normal_0.z) > -2.36599993705749512f)
    {
        normal_mask_2 = (dot_0(ref_normal_0, ref_normal_0)) > 0.25f;
    }
    else
    {
        normal_mask_2 = false;
    }
    bool alpha_mask_1;
    if(has_mask_0)
    {
        alpha_mask_1 = ref_mask_0 != 2U;
    }
    else
    {
        alpha_mask_1 = false;
    }
    float _S774 = render_rgb_0.x;
    float _S775 = render_rgb_0.y;
    float _S776 = render_rgb_0.z;
    float _S777 = ref_rgb_0.x;
    float _S778 = ref_rgb_0.y;
    float _S779 = ref_rgb_0.z;
    float dY_1 = 0.29899999499320984f * _S774 + 0.58700001239776611f * _S775 + 0.11400000005960464f * _S776 - (0.29899999499320984f * _S777 + 0.58700001239776611f * _S778 + 0.11400000005960464f * _S779);
    float dU_1 = -0.14712999761104584f * _S774 - 0.28885999321937561f * _S775 + 0.43599998950958252f * _S776 - (-0.14712999761104584f * _S777 - 0.28885999321937561f * _S778 + 0.43599998950958252f * _S779);
    float dV_1 = 0.61500000953674316f * _S774 - 0.51498997211456299f * _S775 - 0.10001000016927719f * _S776 - (0.61500000953674316f * _S777 - 0.51498997211456299f * _S778 - 0.10001000016927719f * _S779);
    float _S780 = float(mask_2);
    float3  _S781 = ref_rgb_0 - render_rgb_0;
    float3  _S782 = abs_0(_S781);
    float _S783 = dot_0(_S781, _S781) * 0.3333333432674408f;
    losses_0[int(0)] = _S780 * (weights_0[int(0)] * ((_S782.x + _S782.y + _S782.z) * 0.3333333432674408f) + weights_0[int(1)] * _S783 + weights_0[int(2)] * (F32_abs((dY_1))) + weights_0[int(3)] * dY_1 * dY_1 + weights_0[int(4)] * dU_1 * dU_1 + weights_0[int(5)] * dV_1 * dV_1);
    losses_0[int(1)] = _S780 * clamp_0(_S783, 0.0f, 1.0f);
    bool depth_mask_3 = depth_mask_2 & mask_2;
    bool metric_mask_1;
    if(depth_mask_3)
    {
        metric_mask_1 = render_depth_0 > 0.0f;
    }
    else
    {
        metric_mask_1 = false;
    }
    float _S784 = float(metric_mask_1);
    float _S785 = (F32_max((render_depth_0), (0.00009999999747379f)));
    losses_0[int(20)] = weights_0[int(19)] * _S784 * (F32_abs(((F32_log((_S785))) - (F32_log(((F32_max((ref_depth_0 * weights_0[int(20)]), (0.00009999999747379f)))))))));
    float _S786 = float(depth_mask_3);
    float _S787 = _S786 * _S785;
    float _S788 = _S786 * (F32_max((ref_depth_0), (0.00009999999747379f)));
    losses_0[int(2)] = _S787;
    losses_0[int(3)] = _S788;
    losses_0[int(4)] = _S787 * _S787;
    losses_0[int(5)] = _S788 * _S788;
    losses_0[int(6)] = _S787 * _S788;
    bool _S789 = normal_mask_2 & mask_2;
    for(;;)
    {
        float norm2_0 = dot_0(render_normal_0, render_normal_0);
        bool _S790 = norm2_0 == 0.0f;
        _S767 = _S790;
        if(_S790)
        {
            _S768 = make_float3 (0.0f);
            break;
        }
        _S768 = render_normal_0 * make_float3 ((F32_rsqrt((norm2_0))));
        break;
    }
    bool _S791 = !_S767;
    for(;;)
    {
        float norm2_1 = dot_0(depth_normal_0, depth_normal_0);
        bool _S792 = norm2_1 == 0.0f;
        _S769 = _S792;
        if(_S792)
        {
            _S770 = make_float3 (0.0f);
            break;
        }
        _S770 = depth_normal_0 * make_float3 ((F32_rsqrt((norm2_1))));
        break;
    }
    bool _S793 = !_S769;
    for(;;)
    {
        float norm2_2 = dot_0(ref_normal_0, ref_normal_0);
        if(norm2_2 == 0.0f)
        {
            _S771 = make_float3 (0.0f);
            normal_mask_2 = false;
            break;
        }
        _S771 = ref_normal_0 * make_float3 ((F32_rsqrt((norm2_2))));
        normal_mask_2 = _S789;
        break;
    }
    float _S794 = float(_S791 & normal_mask_2);
    float cos_sim_loss_1 = 0.5f - 0.5f * dot_0(_S768, _S771);
    losses_0[int(7)] = weights_0[int(7)] * _S794 * (cos_sim_loss_1 + (F32_sqrt(((F32_max((cos_sim_loss_1), (9.999999960041972e-13f)))))));
    float _S795 = float(_S793 & normal_mask_2);
    float cos_sim_loss_2 = 0.5f - 0.5f * dot_0(_S770, _S771);
    losses_0[int(8)] = weights_0[int(7)] * _S795 * (cos_sim_loss_2 + (F32_sqrt(((F32_max((cos_sim_loss_2), (9.999999960041972e-13f)))))));
    float _S796 = float((_S791 & _S793) & mask_2);
    float cos_sim_loss_3 = 0.5f - 0.5f * dot_0(_S768, _S770);
    losses_0[int(11)] = weights_0[int(10)] * _S796 * (cos_sim_loss_3 + (F32_sqrt(((F32_max((cos_sim_loss_3), (9.999999960041972e-13f)))))));
    for(;;)
    {
        float norm2_3 = dot_0(median_normal_0, median_normal_0);
        bool _S797 = norm2_3 == 0.0f;
        _S772 = _S797;
        if(_S797)
        {
            _S773 = make_float3 (0.0f);
            break;
        }
        _S773 = median_normal_0 * make_float3 ((F32_rsqrt((norm2_3))));
        break;
    }
    bool _S798 = !_S772;
    if(mask_2)
    {
        metric_mask_1 = render_depth_0 > 1.00000001335143196e-10f;
    }
    else
    {
        metric_mask_1 = false;
    }
    bool mean_median_mask_1;
    if(metric_mask_1)
    {
        mean_median_mask_1 = median_depth_0 > 1.00000001335143196e-10f;
    }
    else
    {
        mean_median_mask_1 = false;
    }
    float _S799 = float(mean_median_mask_1);
    losses_0[int(16)] = weights_0[int(15)] * _S799 * (F32_abs(((F32_log(((F32_max((render_depth_0), (1.00000001335143196e-10f)))))) - (F32_log(((F32_max((median_depth_0), (1.00000001335143196e-10f)))))))));
    float _S800 = float((_S798 & _S793) & mask_2);
    float cos_sim_loss_4 = 0.5f - 0.5f * dot_0(_S773, _S770);
    losses_0[int(17)] = weights_0[int(16)] * _S800 * (cos_sim_loss_4 + (F32_sqrt(((F32_max((cos_sim_loss_4), (9.999999960041972e-13f)))))));
    float _S801 = float(_S798 & normal_mask_2);
    float cos_sim_loss_5 = 0.5f - 0.5f * dot_0(_S773, _S771);
    losses_0[int(18)] = weights_0[int(17)] * _S801 * (cos_sim_loss_5 + (F32_sqrt(((F32_max((cos_sim_loss_5), (9.999999960041972e-13f)))))));
    float _S802 = float((_S798 & _S791) & mask_2);
    float cos_sim_loss_6 = 0.5f - 0.5f * dot_0(_S773, _S768);
    losses_0[int(19)] = weights_0[int(18)] * _S802 * (cos_sim_loss_6 + (F32_sqrt(((F32_max((cos_sim_loss_6), (9.999999960041972e-13f)))))));
    float render_alpha_0 = clamp_0(1.0f - render_Ts_0, 0.0f, 1.0f);
    float _S803 = float(alpha_mask_1);
    float _S804 = float(ref_alpha_1);
    float _S805 = (F32_max((render_alpha_0), (_S804)));
    losses_0[int(9)] = weights_0[int(8)] * _S803 * - lerp_0((F32_log(((F32_max((1.0f - _S805), (9.99999997475242708e-07f)))))), (F32_log(((F32_max((_S805), (9.99999997475242708e-07f)))))), _S804);
    float _S806 = 1.0f - render_alpha_0;
    float _S807 = 1.0f - _S804;
    float _S808 = (F32_max((_S806), (_S807)));
    losses_0[int(10)] = weights_0[int(9)] * _S803 * - lerp_0((F32_log(((F32_max((1.0f - _S808), (9.99999997475242708e-07f)))))), (F32_log(((F32_max((_S808), (9.99999997475242708e-07f)))))), _S807);
    losses_0[int(12)] = weights_0[int(11)] * _S780 * 4.0f * render_alpha_0 * _S806;
    losses_0[int(13)] = weights_0[int(12)] * _S780 * ((rgb_dist_0.x + rgb_dist_0.y + rgb_dist_0.z) * 0.3333333432674408f);
    losses_0[int(14)] = weights_0[int(13)] * _S780 * depth_dist_0;
    losses_0[int(15)] = weights_0[int(14)] * _S780 * ((normal_dist_0.x + normal_dist_0.y + normal_dist_0.z) * 0.3333333432674408f);
    losses_0[int(21)] = 1.0f;
    losses_0[int(22)] = _S780;
    losses_0[int(23)] = _S786;
    losses_0[int(24)] = _S794;
    losses_0[int(25)] = _S795;
    losses_0[int(26)] = _S796;
    if(alpha_mask_1)
    {
        mask_2 = !ref_alpha_1;
    }
    else
    {
        mask_2 = false;
    }
    losses_0[int(27)] = float(mask_2);
    if(alpha_mask_1)
    {
        mask_2 = ref_alpha_1;
    }
    else
    {
        mask_2 = false;
    }
    losses_0[int(28)] = float(mask_2);
    losses_0[int(29)] = _S799;
    losses_0[int(30)] = _S800;
    losses_0[int(31)] = _S801;
    losses_0[int(32)] = _S802;
    losses_0[int(33)] = _S784;
    *_S766 = losses_0;
    return;
}

inline __device__ void per_pixel_losses_bwd(float3  render_rgb_1, float3  ref_rgb_1, float render_depth_1, float ref_depth_1, float3  render_normal_1, float3  depth_normal_1, float3  ref_normal_1, float render_Ts_1, float3  rgb_dist_1, float depth_dist_1, float3  normal_dist_1, float median_depth_1, float3  median_normal_1, uint ref_mask_1, bool has_mask_1, float saturation_threshold_1, FixedArray<float, 21>  weights_1, FixedArray<float, 34>  v_losses_0, float3  * v_render_rgb_0, float3  * v_ref_rgb_0, float * v_render_depth_0, float * v_ref_depth_0, float3  * v_render_normal_0, float3  * v_depth_normal_0, float3  * v_ref_normal_0, float * v_render_Ts_0, float3  * v_rgb_dist_0, float * v_depth_dist_0, float3  * v_normal_dist_0, float * v_median_depth_0, float3  * v_median_normal_0)
{
    float3  _S809 = make_float3 (0.0f);
    DiffPair_vectorx3Cfloatx2C3x3E_0 dp_render_rgb_0;
    (&dp_render_rgb_0)->primal_0 = render_rgb_1;
    (&dp_render_rgb_0)->differential_0 = _S809;
    DiffPair_vectorx3Cfloatx2C3x3E_0 dp_ref_rgb_0;
    (&dp_ref_rgb_0)->primal_0 = ref_rgb_1;
    (&dp_ref_rgb_0)->differential_0 = _S809;
    DiffPair_float_0 dp_render_depth_0;
    (&dp_render_depth_0)->primal_0 = render_depth_1;
    (&dp_render_depth_0)->differential_0 = 0.0f;
    DiffPair_float_0 dp_ref_depth_0;
    (&dp_ref_depth_0)->primal_0 = ref_depth_1;
    (&dp_ref_depth_0)->differential_0 = 0.0f;
    DiffPair_vectorx3Cfloatx2C3x3E_0 dp_render_normal_0;
    (&dp_render_normal_0)->primal_0 = render_normal_1;
    (&dp_render_normal_0)->differential_0 = _S809;
    DiffPair_vectorx3Cfloatx2C3x3E_0 dp_depth_normal_0;
    (&dp_depth_normal_0)->primal_0 = depth_normal_1;
    (&dp_depth_normal_0)->differential_0 = _S809;
    DiffPair_vectorx3Cfloatx2C3x3E_0 dp_ref_normal_0;
    (&dp_ref_normal_0)->primal_0 = ref_normal_1;
    (&dp_ref_normal_0)->differential_0 = _S809;
    DiffPair_float_0 dp_render_Ts_0;
    (&dp_render_Ts_0)->primal_0 = render_Ts_1;
    (&dp_render_Ts_0)->differential_0 = 0.0f;
    DiffPair_vectorx3Cfloatx2C3x3E_0 dp_rgb_dist_0;
    (&dp_rgb_dist_0)->primal_0 = rgb_dist_1;
    (&dp_rgb_dist_0)->differential_0 = _S809;
    DiffPair_float_0 dp_depth_dist_0;
    (&dp_depth_dist_0)->primal_0 = depth_dist_1;
    (&dp_depth_dist_0)->differential_0 = 0.0f;
    DiffPair_vectorx3Cfloatx2C3x3E_0 dp_normal_dist_0;
    (&dp_normal_dist_0)->primal_0 = normal_dist_1;
    (&dp_normal_dist_0)->differential_0 = _S809;
    DiffPair_float_0 dp_median_depth_0;
    (&dp_median_depth_0)->primal_0 = median_depth_1;
    (&dp_median_depth_0)->differential_0 = 0.0f;
    DiffPair_vectorx3Cfloatx2C3x3E_0 dp_median_normal_0;
    (&dp_median_normal_0)->primal_0 = median_normal_1;
    (&dp_median_normal_0)->differential_0 = _S809;
    FixedArray<float, 21>  _S810 = weights_1;
    FixedArray<float, 34>  _S811 = v_losses_0;
    _S745(&dp_render_rgb_0, &dp_ref_rgb_0, &dp_render_depth_0, &dp_ref_depth_0, &dp_render_normal_0, &dp_depth_normal_0, &dp_ref_normal_0, &dp_render_Ts_0, &dp_rgb_dist_0, &dp_depth_dist_0, &dp_normal_dist_0, &dp_median_depth_0, &dp_median_normal_0, ref_mask_1, has_mask_1, saturation_threshold_1, &_S810, &_S811);
    *v_render_rgb_0 = dp_render_rgb_0.differential_0;
    *v_ref_rgb_0 = dp_ref_rgb_0.differential_0;
    *v_render_depth_0 = dp_render_depth_0.differential_0;
    *v_ref_depth_0 = dp_ref_depth_0.differential_0;
    *v_render_normal_0 = dp_render_normal_0.differential_0;
    *v_depth_normal_0 = dp_depth_normal_0.differential_0;
    *v_ref_normal_0 = dp_ref_normal_0.differential_0;
    *v_render_Ts_0 = dp_render_Ts_0.differential_0;
    *v_rgb_dist_0 = dp_rgb_dist_0.differential_0;
    *v_depth_dist_0 = dp_depth_dist_0.differential_0;
    *v_normal_dist_0 = dp_normal_dist_0.differential_0;
    *v_median_depth_0 = dp_median_depth_0.differential_0;
    *v_median_normal_0 = dp_median_normal_0.differential_0;
    return;
}

inline __device__ void per_pixel_losses_reduce(FixedArray<float, 34>  raw_losses_0, FixedArray<float, 21>  weights_2, FixedArray<float, 15>  * _S812)
{
    FixedArray<float, 15>  losses_1;
    float _S813 = (F32_max((raw_losses_0[int(22)]), (1.0f)));
    losses_1[int(0)] = raw_losses_0[int(0)] / _S813;
    losses_1[int(1)] = -10.0f * (F32_log10((raw_losses_0[int(1)] / _S813)));
    bool _S814;
    if((raw_losses_0[int(23)]) > 0.0f)
    {
        _S814 = (raw_losses_0[int(3)]) != 0.0f;
    }
    else
    {
        _S814 = false;
    }
    float _S815;
    if(_S814)
    {
        _S815 = weights_2[int(6)] * clamp_0(1.0f - (raw_losses_0[int(6)] - raw_losses_0[int(2)] * raw_losses_0[int(3)] / raw_losses_0[int(23)]) / (F32_sqrt(((F32_max((9.999999960041972e-13f), ((raw_losses_0[int(4)] - raw_losses_0[int(2)] * raw_losses_0[int(2)] / raw_losses_0[int(23)]) * (raw_losses_0[int(5)] - raw_losses_0[int(3)] * raw_losses_0[int(3)] / raw_losses_0[int(23)]) + 1.0f)))))), 0.0f, 2.0f);
    }
    else
    {
        _S815 = 0.0f;
    }
    losses_1[int(2)] = _S815;
    losses_1[int(3)] = (raw_losses_0[int(7)] / (F32_max((raw_losses_0[int(24)]), (1.0f))) + raw_losses_0[int(8)] / (F32_max((raw_losses_0[int(25)]), (1.0f)))) / float((I32_max((int((raw_losses_0[int(24)]) > 0.5f) + int((raw_losses_0[int(25)]) > 0.5f)), (int(1)))));
    losses_1[int(4)] = raw_losses_0[int(9)] / (F32_max((raw_losses_0[int(27)]), (1.0f))) + raw_losses_0[int(10)] / (F32_max((raw_losses_0[int(28)]), (1.0f)));
    losses_1[int(5)] = raw_losses_0[int(11)] / (F32_max((raw_losses_0[int(26)]), (1.0f)));
    losses_1[int(6)] = raw_losses_0[int(12)] / _S813;
    losses_1[int(7)] = raw_losses_0[int(13)] / _S813;
    losses_1[int(8)] = raw_losses_0[int(14)] / _S813;
    losses_1[int(9)] = raw_losses_0[int(15)] / _S813;
    losses_1[int(10)] = raw_losses_0[int(16)] / (F32_max((raw_losses_0[int(29)]), (1.0f)));
    losses_1[int(11)] = raw_losses_0[int(17)] / (F32_max((raw_losses_0[int(30)]), (1.0f)));
    losses_1[int(12)] = raw_losses_0[int(18)] / (F32_max((raw_losses_0[int(31)]), (1.0f)));
    losses_1[int(13)] = raw_losses_0[int(19)] / (F32_max((raw_losses_0[int(32)]), (1.0f)));
    losses_1[int(14)] = raw_losses_0[int(20)] / (F32_max((raw_losses_0[int(33)]), (1.0f)));
    *_S812 = losses_1;
    return;
}

inline __device__ void per_pixel_losses_reduce_bwd(FixedArray<float, 34>  raw_losses_1, FixedArray<float, 21>  weights_3, FixedArray<float, 15>  v_losses_1, FixedArray<float, 34>  * _S816)
{
    FixedArray<float, 34>  _S817;
    Array_dzero_0(&_S817);
    DiffPair_arrayx3Cfloatx2C34x3E_0 dp_raw_losses_0;
    (&dp_raw_losses_0)->primal_0 = raw_losses_1;
    (&dp_raw_losses_0)->differential_0 = _S817;
    FixedArray<float, 21>  _S818 = weights_3;
    FixedArray<float, 15>  _S819 = v_losses_1;
    _S297(&dp_raw_losses_0, &_S818, &_S819);
    *_S816 = (&dp_raw_losses_0)->differential_0;
    return;
}

