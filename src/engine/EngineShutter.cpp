#include "engine/EngineShutter.h"
#include "engine/EngineState.h"
#include "data/DatasetParser.h"
#include "data/Json.h"
#include "data/JsonWrite.h"
#include <algorithm>
#include <cmath>
#include <filesystem>
#include <map>
#include <sstream>
#include <stdexcept>

namespace {
namespace fs = std::filesystem;
const JsonValue& field(const JsonValue& j, const char* key) {
    const auto* v = j.find(key);
    if (!v) throw std::runtime_error(std::string("Rolling shutter: missing ") + key);
    return *v;
}
double number(const JsonValue& j, const char* key) {
    const auto& v = field(j,key);
    if (v.type != JsonValue::Type::Number || !std::isfinite(v.num))
        throw std::runtime_error(std::string("Rolling shutter: invalid ") + key);
    return v.num;
}
std::array<double,3> vector3(const JsonValue& j, const char* key) {
    const auto& v = field(j,key);
    if (!v.is_array() || v.arr.size()!=3) throw std::runtime_error(std::string("Rolling shutter: invalid ")+key);
    std::array<double,3> out;
    for (int k=0;k<3;++k) {
        if (v.arr[k].type != JsonValue::Type::Number || !std::isfinite(v.arr[k].num))
            throw std::runtime_error(std::string("Rolling shutter: nonfinite ")+key);
        out[k]=v.arr[k].num;
    }
    return out;
}
void emit3(std::ostream& out, const std::array<double,3>& v) {
    out << '[' << v[0] << ',' << v[1] << ',' << v[2] << ']';
}
void emit_adam(std::ostream& out, const ShutterAdam& a) {
    out << ",\"adam_count\":" << a.count << ",\"adam_first\":";
    emit3(out,a.first); out << ",\"adam_second\":"; emit3(out,a.second);
}
void restore_adam(const JsonValue& j, ShutterAdam& a) {
    a.count=(int)number(j,"adam_count");
    a.first=vector3(j,"adam_first"); a.second=vector3(j,"adam_second");
    if (a.count<0) throw std::runtime_error("Rolling shutter: negative optimizer step");
    for (double v:a.second) if (v<0) throw std::runtime_error("Rolling shutter: negative Adam variance");
}
double update(ShutterAdam& a, int k, double grad, double lr) {
    if (!std::isfinite(grad)) throw std::runtime_error("Rolling shutter: nonfinite motion gradient");
    a.first[k]=.9*a.first[k]+.1*grad;
    a.second[k]=.999*a.second[k]+.001*grad*grad;
    return lr*(a.first[k]/(1-std::pow(.9,a.count))) /
        (std::sqrt(a.second[k]/(1-std::pow(.999,a.count)))+1e-8);
}

// Pinned download slots, kept for the process; a slot is busy while a readback names it.
struct PinnedSlot {
    float* host = nullptr;
    size_t capacity = 0;
    backend::Event* done = nullptr;
    bool recorded = false;
};
std::vector<PinnedSlot>& pinned_slots() {
    static std::vector<PinnedSlot> slots;
    return slots;
}

int acquire_slot(const ShutterState& s, size_t floats) {
    auto& slots=pinned_slots();
    int i=0;
    while (i<(int)slots.size() && std::any_of(s.readbacks.begin(),s.readbacks.end(),
                                             [&](const ShutterReadback& r) { return r.slot==i; })) ++i;
    if (i==(int)slots.size()) slots.push_back({nullptr,0,backend::event_create(false),false});
    auto& slot=slots[i];
    if (slot.recorded) backend::event_synchronize(slot.done);  // a reset can drop a readback in flight
    if (slot.capacity<floats) {
        if (slot.host) backend::host_free_pinned(slot.host);
        slot.host=(float*)backend::host_malloc_pinned(floats*sizeof(float));
        if (!slot.host) throw std::runtime_error("Rolling shutter: cannot allocate a gradient readback");
        slot.capacity=floats;
    }
    return i;
}

// Adds the downloaded gradients to the images and lenses they belong to: those of
// earlier optimizer steps, or all of them.
void read_gradients(ShutterState& s, bool all) {
    std::vector<ShutterReadback> later;
    for (auto& r:s.readbacks) {
        if (!all && r.generation>=s.generation) { later.push_back(std::move(r)); continue; }
        auto& slot=pinned_slots()[r.slot];
        backend::event_synchronize(slot.done);
        const double scale=r.scale<0 ? engine().optim.grad_scale : r.scale;
        for (int i=0;i<(int)r.batch.size();++i) {
            auto& im=s.images[r.batch[i]]; auto& lens=s.lenses[im.camera];
            im.touched=lens.touched=true;
            const float* g=slot.host+8*i;
            for (int k=0;k<3;++k) {
                if (!std::isfinite(g[k]+g[3+k])) throw std::runtime_error("Rolling shutter: nonfinite motion gradient");
                im.grad[k]+=g[k]*scale;
                lens.grad+=g[3+k]*im.velocity[k]*scale;
            }
        }
    }
    s.readbacks=std::move(later);
}

void apply_updates(ShutterState& s) {
    for (auto& im:s.images) if (im.touched) {
        ++im.adam.count;
        for (int k=0;k<3;++k) {
            const double g=im.grad[k]+s.regularization*(im.rotation[k]-im.initial[k]);
            im.rotation[k]=std::clamp(im.rotation[k]-update(im.adam,k,g,s.rotation_lr),-.05,.05);
        }
        im.grad={}; im.touched=false;
    }
    for (auto& lens:s.lenses) if (lens.touched) {
        ++lens.adam.count;
        const double g=lens.grad+s.regularization*(lens.readout-lens.initial);
        lens.readout=std::clamp(lens.readout-update(lens.adam,0,g,s.readout_lr),-.05,.05);
        lens.grad=0; lens.touched=false;
    }
}

void flush(ShutterState& s) {
    if (s.readbacks.empty()) return;
    read_gradients(s,true);
    apply_updates(s);
}
}

void engine_init_rolling_shutter(const std::string& dataset, const std::string& image_dir,
    const std::string& recon_dir, const std::vector<std::string>& images,
    const std::string& mode, double scale, double rotation_lr, double readout_lr, double regularization) {
    auto& s=engine().shutter;
    s=ShutterState{};
    if (mode!="auto" && mode!="off" && mode!="fixed" && mode!="optimize")
        throw std::runtime_error("rolling_shutter must be auto, off, fixed or optimize");
    if (mode=="off") return;
    const auto path=fs::path(dataset)/"rolling_shutter.json";
    if (!fs::exists(path)) {
        if (mode!="auto") throw std::runtime_error("rolling_shutter.json is required for rolling-shutter training");
        return;
    }
    if (!(scale>0) || !(rotation_lr>0) || !(readout_lr>0) || !(regularization>=0) ||
        !std::isfinite(scale+rotation_lr+readout_lr+regularization))
        throw std::runtime_error("Rolling shutter: invalid scale or optimizer settings");
    const auto j=json_parse_file(path.string());
    if (number(j,"version")!=1 || field(j,"model").as_string()!="linear rolling shutter about the reference pose")
        throw std::runtime_error("Unsupported rolling-shutter camera model");
    const auto axis=field(j,"readout_axis").as_string();
    if (axis!="rows" && axis!="columns") throw std::runtime_error("Unknown rolling-shutter readout axis");
    s.axis=axis=="rows";
    s.optimize=mode=="optimize";
    s.scale=scale; s.rotation_lr=rotation_lr; s.readout_lr=readout_lr; s.regularization=regularization;
    s.image_root=fs::absolute(fs::path(dataset)/image_dir).lexically_normal().string();
    std::map<int,int> cameras;
    for (const auto& c:field(j,"cameras").arr) {
        ShutterLens lens;
        lens.id=(int)number(c,"camera_id");
        lens.readout=lens.initial=number(c,"readout_s");
        if (std::abs(lens.readout)>.05 || !cameras.emplace(lens.id,(int)s.lenses.size()).second)
            throw std::runtime_error("Rolling shutter: invalid or duplicate camera");
        s.lenses.push_back(lens);
    }
    const auto recon=fs::path(dataset)/find_colmap_model(dataset,recon_dir);
    const auto records=fs::exists(recon/"images.bin") ? read_images_binary(recon.string()) : read_images_text(recon.string());
    std::map<std::string,int> names;
    for (const auto& row:field(j,"images").arr) {
        ShutterImage im;
        im.name=field(row,"name").as_string();
        im.image_id=(int)number(row,"image_id");
        const auto rec=records.find(im.image_id);
        if (rec==records.end() || rec->second.name!=im.name || !cameras.count(rec->second.camera_id))
            throw std::runtime_error("Rolling shutter: COLMAP image identity differs: "+im.name);
        im.camera=cameras.at(rec->second.camera_id);
        if (const auto* id=row.find("camera_id"); id && id->as_int()!=rec->second.camera_id)
            throw std::runtime_error("Rolling shutter: camera identity differs: "+im.name);
        im.rotation=im.initial=vector3(row,"rotation_rad");
        im.velocity=vector3(row,"velocity_m_s");
        const auto displacement=vector3(row,"translation_m");
        for (int k=0;k<3;++k) {
            if (std::abs(im.rotation[k])>.05 || std::abs(displacement[k]-s.lenses[im.camera].readout*im.velocity[k])>1e-8)
                throw std::runtime_error("Rolling shutter: inconsistent motion: "+im.name);
            im.velocity[k]*=scale;
        }
        if (!names.emplace(im.name,(int)s.images.size()).second) throw std::runtime_error("Duplicate rolling-shutter image: "+im.name);
        s.images.push_back(im);
    }
    if (s.images.empty() || s.lenses.empty()) throw std::runtime_error("Rolling shutter: empty camera table");
    engine_shutter_select_images(images);
}

void engine_shutter_select_images(const std::vector<std::string>& images) {
    auto& s=engine().shutter;
    if (s.images.empty()) return;
    flush(s);
    std::map<std::string,int> names;
    for (int i=0;i<(int)s.images.size();++i) names.emplace(s.images[i].name,i);
    s.active.clear(); s.view={};
    for (const auto& image:images) {
        const auto name=fs::absolute(image).lexically_normal().lexically_relative(fs::path(s.image_root)).generic_string();
        const auto found=names.find(name);
        if (found==names.end()) throw std::runtime_error("No rolling-shutter motion for image: "+name);
        s.active.push_back(found->second);
    }
}

void engine_shutter_bind(TorchTensorView indices, bool training) {
    auto& s=engine().shutter;
    s.view={};
    if (s.images.empty()) return;
    const int n=(int)engine().camera.num;
    if (!std::get<0>(indices) || std::get<2>(indices).empty() || std::get<2>(indices)[0]!=n)
        throw std::runtime_error("Rolling shutter needs one image index per camera");
    std::vector<int32_t> ids(n);
    backend::memcpy_sync(ids.data(),(void*)std::get<0>(indices),n*sizeof(int32_t),backend::MemcpyKind::Auto);
    s.batch.resize(n);
    std::vector<float> packed(n*8,0);
    for (int i=0;i<n;++i) {
        if (ids[i]<0 || ids[i]>=(int)s.active.size()) throw std::runtime_error("Rolling shutter: image index out of range");
        const int id=s.active[ids[i]]; s.batch[i]=id;
        const auto& im=s.images[id];
        for (int k=0;k<3;++k) {
            packed[i*8+k]=(float)im.rotation[k];
            packed[i*8+3+k]=(float)(im.velocity[k]*s.lenses[im.camera].readout);
        }
        packed[i*8+7]=(float)s.axis;
    }
    s.motion.resize(PoolSlot::EngShutterMotion,n*8);
    backend::memcpy_sync(s.motion.data_ptr(),packed.data(),packed.size()*sizeof(float),backend::MemcpyKind::HostToDevice);
    if (training && s.optimize) { s.gradient.resize(PoolSlot::EngShutterGradient,n*8); s.gradient.zero(); }
    s.view={s.motion.data_ptr(),training && s.optimize ? s.gradient.data_ptr() : nullptr};
}

// Read at the next optimizer step: a blocking download here drained the queue that
// otherwise covers the wait for the next batch, 7 ms of a 56 ms step (RTX 4090).
void engine_shutter_accumulate() {
    auto& s=engine().shutter;
    if (!s.view.gradient) return;
    const size_t floats=s.batch.size()*8;
    const int slot=acquire_slot(s,floats);
    auto& p=pinned_slots()[slot];
    backend::memcpy_async(p.host,s.gradient.data_ptr(),floats*sizeof(float),backend::MemcpyKind::DeviceToHost);
    backend::event_record(p.done);
    p.recorded=true;
    s.readbacks.push_back({slot,s.generation,-1,s.batch});
}

void engine_shutter_step() {
    auto& s=engine().shutter;
    for (auto& r:s.readbacks) if (r.generation==s.generation) r.scale=engine().optim.grad_scale;
    read_gradients(s,false);
    apply_updates(s);
    ++s.generation;
}

std::string engine_shutter_save() {
    auto& s=engine().shutter;
    if (s.images.empty()) return {};
    flush(s);
    std::ostringstream out; out.precision(17);
    out << "{\"version\":1,\"model\":\"linear rolling shutter about the reference pose\",\"readout_axis\":"
        << json_quote(s.axis ? "rows" : "columns") << ",\"optimizer_version\":1,\"training_scale\":" << s.scale
        << ",\"optimize\":" << (s.optimize ? "true":"false") << ",\"rotation_lr\":" << s.rotation_lr
        << ",\"readout_lr\":" << s.readout_lr << ",\"regularization\":" << s.regularization << ",\"cameras\":[";
    for (int i=0;i<(int)s.lenses.size();++i) {
        const auto& c=s.lenses[i]; if (i) out << ',';
        out << "{\"camera_id\":" << c.id << ",\"readout_s\":" << c.readout << ",\"initial_readout_s\":" << c.initial;
        emit_adam(out,c.adam); out << '}';
    }
    out << "],\"images\":[";
    for (int i=0;i<(int)s.images.size();++i) {
        const auto& im=s.images[i]; if (i) out << ',';
        out << "{\"image_id\":" << im.image_id << ",\"name\":" << json_quote(im.name)
            << ",\"camera_id\":" << s.lenses[im.camera].id << ",\"rotation_rad\":";
        emit3(out,im.rotation); out << ",\"initial_rotation_rad\":"; emit3(out,im.initial);
        auto v=im.velocity; for (auto& x:v) x/=s.scale;
        out << ",\"velocity_m_s\":"; emit3(out,v);
        for (auto& x:v) x*=s.lenses[im.camera].readout;
        out << ",\"translation_m\":"; emit3(out,v);
        emit_adam(out,im.adam); out << '}';
    }
    out << "]}";
    return out.str();
}

void engine_shutter_restore(const std::string& json) {
    auto& s=engine().shutter;
    if (json.empty()) {
        if (!s.images.empty()) throw std::runtime_error("Checkpoint has no rolling-shutter state");
        return;
    }
    auto j=json_parse(json);
    if (number(j,"optimizer_version")!=1 || number(j,"training_scale")!=s.scale ||
        field(j,"images").arr.size()!=s.images.size() || field(j,"cameras").arr.size()!=s.lenses.size() ||
        field(j,"readout_axis").as_string()!=(s.axis ? "rows":"columns") ||
        field(j,"optimize").as_bool()!=s.optimize)
        throw std::runtime_error("Checkpoint rolling-shutter configuration differs from the dataset");
    for (int i=0;i<(int)s.lenses.size();++i) {
        const auto& row=field(j,"cameras").arr[i]; auto& c=s.lenses[i];
        if (number(row,"camera_id")!=c.id || number(row,"initial_readout_s")!=c.initial)
            throw std::runtime_error("Checkpoint rolling-shutter camera differs");
        c.readout=number(row,"readout_s"); restore_adam(row,c.adam);
    }
    for (int i=0;i<(int)s.images.size();++i) {
        const auto& row=field(j,"images").arr[i]; auto& im=s.images[i];
        const auto velocity=vector3(row,"velocity_m_s");
        if (field(row,"name").as_string()!=im.name || number(row,"image_id")!=im.image_id ||
            number(row,"camera_id")!=s.lenses[im.camera].id || vector3(row,"initial_rotation_rad")!=im.initial)
            throw std::runtime_error("Checkpoint rolling-shutter image differs: "+im.name);
        for (int k=0;k<3;++k) if (std::abs(velocity[k]*s.scale-im.velocity[k])>1e-12)
            throw std::runtime_error("Checkpoint rolling-shutter velocity differs: "+im.name);
        im.rotation=vector3(row,"rotation_rad"); restore_adam(row,im.adam);
    }
    s.rotation_lr=number(j,"rotation_lr"); s.readout_lr=number(j,"readout_lr"); s.regularization=number(j,"regularization");
    s.readbacks.clear();
    s.view={};
}
