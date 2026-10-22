#pragma once
#include "core/Tensor.h"
#include "core/RollingShutter.cuh"
#include <array>
#include <string>
#include <vector>

struct ShutterAdam {
    std::array<double,3> first{}, second{};
    int count = 0;
};
struct ShutterImage {
    std::string name;
    int image_id = 0, camera = 0;
    std::array<double,3> rotation{}, initial{}, velocity{}, grad{};
    ShutterAdam adam;
    bool touched = false;
};
struct ShutterLens {
    int id = 0;
    double readout = 0, initial = 0, grad = 0;
    ShutterAdam adam;
    bool touched = false;
};
// A motion-gradient download in flight; `scale` is the optimizer step's gradient
// scale once that step has run (negative before).
struct ShutterReadback {
    int slot = 0, generation = 0;
    double scale = -1;
    std::vector<int> batch;
};
struct ShutterState {
    std::vector<ShutterImage> images;
    std::vector<ShutterLens> lenses;
    std::vector<int> active, batch;
    DeviceVector<float> motion, gradient;
    RollingShutterView view;
    std::vector<ShutterReadback> readbacks;
    int generation = 0;  // optimizer steps taken
    int axis = 1;
    bool optimize = false;
    double rotation_lr = 1e-4, readout_lr = 1e-5, regularization = 1e-3;
    double scale = 1;
    std::string image_root;
};

void engine_init_rolling_shutter(const std::string& dataset, const std::string& image_dir,
    const std::string& recon_dir, const std::vector<std::string>& images,
    const std::string& mode, double scale, double rotation_lr, double readout_lr, double regularization);
void engine_shutter_select_images(const std::vector<std::string>& images);
void engine_shutter_bind(TorchTensorView indices, bool training);
void engine_shutter_accumulate();
void engine_shutter_step();
std::string engine_shutter_save();
void engine_shutter_restore(const std::string& json);
