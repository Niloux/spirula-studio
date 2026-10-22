# Rolling-shutter training

The `3dgut` primitive can train directly on original rolling-shutter photos.
`rolling_shutter.json` beside the dataset supplies the initial motion. Native
pinhole and fisheye cameras retain their distortion. Image warping and applied
EXIF rotation are rejected because the readout axis belongs to the source pixels.

GeosunPre exports this layout whenever its shutter correction is accepted. The
exported photos and masks are the original files, the COLMAP poses describe the
middle of the readout, and depth/normal supervision uses the original image
coordinates.

```sh
spirula train --data /path/to/dataset --primitive 3dgut --save-full-checkpoint 1
spirula train --resume /path/to/checkpoint
```

`--rolling-shutter auto` is the default: a dataset without the sidecar keeps the
global-shutter path; a sidecar renders with the supplied motion without updating
it, as `fixed` does. `optimize` also updates the motion. `off` ignores the
sidecar. Explicit `fixed` and `optimize` require the file. Other primitives
reject an enabled rolling-shutter dataset.

## Camera convention

Version 1 uses GeosunPre's linear readout model. At source coordinate `c` along
`readout_axis` (`rows` or `columns`), with pixel centres starting at `0.5`,

```text
s = c / N - 0.5
p(s) = (I + s [rotation_rad]x) (R X + t - s readout_s velocity_m_s)
```

`R,t` are the COLMAP world-to-camera reference pose. Each image has a full-readout
rotation in radians and a reference-camera velocity in metres per second. Each
COLMAP camera shares one signed readout time in seconds. The sign encodes scan
order. This is the first-order rotation model, including its exact matrix inverse;
it is not interpreted as an interpolation between two rigid poses.

The sidecar contains `version`, `model`, `readout_axis`, a `cameras` array of
`camera_id,readout_s`, and an `images` array of
`image_id,name,rotation_rad,velocity_m_s,translation_m`. Each image may also carry
`camera_id`; it is optional, and when present it must equal the image's COLMAP camera
(GeosunPre writes it and checks it the same way on read-back). `translation_m` must equal
`readout_s * velocity_m_s`. Names and COLMAP IDs identify each image independently
of dataset sorting, train/eval splitting and variable-resolution batching.
`relative_scale` also scales readout translations; centering does not change them.

## Rendering and optimization

Each raster pixel uses its own origin and direction. A splat's tile bounds are the
3DGUT footprint at the readout instant of its centre (two fixed-point steps from the
reference pose), grown by how far the image can move between that instant and the
farthest line the footprint spans. The image speed bound combines the angular rate
of the camera (rotation, and displacement over the splat's nearest distance), the
lens magnification at the widest angle the splat reaches and the distortion Jacobian
at its centre; a footprint `span` lines from the instant's line grows by
`speed * span / (N - speed)`, and the culling ellipse grows by the same disc. A
splat therefore covers about the tiles it covers in a global-shutter view, and the
bound is as tight, and as approximate, as the unscented footprint itself.
Equirectangular views, angles where the lens has no bound and splats whose readout
displacement reaches the camera fall back to the whole image. Zero motion retains
the existing projection bounds. Splat SH colour and tile ordering use the reference
pose.

A strict bound, a sphere around the opacity-threshold ellipsoid swept over the whole
readout with interval distortion, grows every splat by the motion of the full
readout: on a 3600x3600 dual-fisheye dataset (210k splats, RTX 4090) it made about
100 times the global path's tile pairs and 0.67 s per step against 0.044 s. The
readout-instant bound makes 1-2% more pairs than the global path on the same images
(16-pixel bins); a step is 8% slower than the global path's with motion
optimization (0.052 s against 0.048 s) and 3% slower with fixed motion, the rest of
the optimizing step being the ray gradients the rasterizer backward computes.

Depth-derived normals reconstruct neighbouring points in the
reference camera before transforming their normal into the pixel's readout frame.
The inverse readout direction keeps its length so the rendered depth parameter is
distance in that pixel's camera, matching GeosunPre's exported depth convention.
SH backgrounds use the same readout rays, and the fused appearance chain and the
per-stage path both pass their motion derivatives to the optimizer. The per-pixel
motion derivatives of the depth-derived normals and of the SH background are summed
per warp before the atomic add: one float atomic per pixel into the same six values
cost 109 ms of a 0.58 s step on the dataset above.

Reference poses, intrinsics and navigation velocities stay fixed. Adam updates
each image's rotation and each camera's shared readout time. Optimizing readout
time and free velocity simultaneously would leave their product ambiguous.
Rotation components are bounded to `[-0.05,0.05]` radians and readout times to
`[-0.05,0.05]` seconds, matching the imported model's operating range.

`--shutter-rotation-lr` defaults to `1e-4`, `--shutter-readout-lr` to `1e-6`, and
`--shutter-regularization` to `20`. Regularization adds `weight * (x - x0)` to the
gradient of each rotation component and readout time, in radians and seconds. On a
580-image GeosunPre dual-fisheye dataset (3000 steps) the photometric gradients had
an RMS of 0.05 per radian for rotations and 0.01-0.02 per second for readout
times, so the default balances them at deviations of about 2.5 mrad and 1 ms; at
`1e-3` the penalty was four orders of magnitude below them. Split batches and mixed resolutions accumulate motion
gradients before a single optimizer update. The gradients are downloaded without
waiting for the device and applied at the next optimizer step, or earlier when a
checkpoint is written or the image set changes: an image is rendered again long
after its update, and the shared readout time lags one step. Held-out images retain their supplied
rotation; their camera's readout time is shared with training images.

Every checkpoint includes an updated `rolling_shutter.json`, also stored inside
`state.tar`. It includes the motion, initial estimates, Adam moments and per-image
and per-camera update counts. Resume verifies image identities, fixed velocities,
scale and readout convention before restoring the state. A resumable splat model
still requires `--save-full-checkpoint 1`.

`rolling_shutter_parity` checks row/column readout, pinhole/fisheye cameras, a
double-precision CPU rendering reference, motion-gradient finite differences,
zero-motion and packed rendering, moving-camera plane normals, Adam continuation
and the checkpoint archive. It supports `dump <reference>` and `compare <reference>`
for CUDA/Vulkan comparisons.
