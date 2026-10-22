#pragma once

// Image metrics for the eval pass. All host-side, all on [0,1] float RGB in
// HWC order, matching torchmetrics. LPIPS has a model behind it and is
// src/lpips/, which the eval reaches through TrainerCore's LpipsHooks.

#include <cstdint>
#include <vector>

namespace spirula {

// `keep`, where given, is one byte per pixel: only nonzero pixels are scored.

// Mean absolute error.
float image_l1(const float* a, const float* b, int64_t num_pixels, int C,
               const uint8_t* keep = nullptr);

// Peak signal-to-noise ratio, data_range = 1 (torchmetrics PeakSignalNoiseRatio).
float image_psnr(const float* a, const float* b, int64_t num_pixels, int C,
                 const uint8_t* keep = nullptr);

// Structural similarity, matching torchmetrics' StructuralSimilarityIndexMeasure
// defaults: 11x11 gaussian, sigma 1.5, data_range 1, per-channel, reflect-padded
// by 5, the map averaged over the full HxW (or the kept pixels), uncropped.
float image_ssim(const float* a, const float* b, int H, int W, int C,
                 const uint8_t* keep = nullptr);

// Warp `img` to match `ref`'s colours: least squares over a quadratic
// expansion of the input pixel, re-solved `num_iters` times while updating
// which pixels count as unsaturated. This is the standard Mip-NeRF 360 /
// bilagrid colour correction that the eval's cc_* metrics are computed on.
// Both inputs are [H*W*C] in [0,1]; the result is clipped to [0,1].
std::vector<float> color_correct(const float* img, const float* ref,
                                 int64_t num_pixels, int C,
                                 int num_iters = 5, float eps = 0.5f / 255.0f);

// Same, writing into a caller-owned buffer (per-view scratch at 4K costs more
// than the arithmetic), and fitting the warp to the `keep` pixels only.
void color_correct_into(const float* img, const float* ref,
                        int64_t num_pixels, int C, std::vector<float>& out,
                        const uint8_t* keep = nullptr,
                        int num_iters = 5, float eps = 0.5f / 255.0f);

}  // namespace spirula
