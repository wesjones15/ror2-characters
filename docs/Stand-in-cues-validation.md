# Stand-in gameplay cues - 2026-11-08

Candidate: Mario 0.6.4 / SMS ABI 54, Olimar 0.6.4 / PIK ABI 65,
Melee 0.5.2 / SSBM ABI 7. Matching DLLs are staged in workspace
`target/BepInEx/plugins/`. **Not yet played in RoR2.**

## Identity and viewer evidence

These are deliberately authored circles, cylinders and HUD shapes. There is no
original model, emitter, effect cue or extracted texture ID. Existing behavior
drives their transforms and state; no approximate original asset was auditioned.

`libpikmin/crates/viewer/examples/fallback_cues.rs` reads the actual native cursor
draw pose and simulation pellet data without loading assets:

- [Free aim: flat pink circle, colored/sized pellets](asset-free-captures/cues-30.png)
- [Locked: circle faces Olimar](asset-free-captures/cues-90.png)
- [Later locked frame](asset-free-captures/cues-120.png)

The textured and empty-cache views share the existing `lock_view` cursor branch
in `libpikmin-present/src/view.rs`: position, facing, interpolation and spin.
The host substitutes a generated pink circle through shared `MarkerQuad`.
Numbered pellets use the same host color table as Pikmin and the actual native
radius/scale. Absorption no longer leaves a forced minimum-size pellet.

`libsms/crates/viewer/examples/fallback_water.rs` runs real built-in Mario/FLUDD
emissions through the shared flight-shape calculation:

- [Spray and short light-trigger burst](asset-free-captures/water-8.png)
- [Burst after release, plus basic HUD vocabulary](asset-free-captures/water-18.png)
- [Later water frame](asset-free-captures/water-30.png)

Water geometry reuses `TModelWaterManager::calcDrawVtx`'s existing stretch rule
(`sms-main/src/Player/ModelWaterManager.cpp`, `mExtension`, `unk5D18 = 4`) through
one `libsms-present::water::flight_shape` function. This is a geometry calculation,
not a loaded particle effect. Both textured quads and no-view FFI segments use it,
including interpolation and clipping behind the drawn nozzle. Cylinder widths
stay thin for ordinary streams and retain simulated size for burst particles.

The yellow Mario lock circle uses the existing shared target placement/eye-facing
quad, size/spin settings and health/shield slices. Its update now runs before the
missing-view return. The generated tank uses the configured FLUDD HUD position and
scale: a circle containing a blue rectangular water meter, a nozzle letter, and
an orange fill rising through the circle with actual Rocket pressure. It also
works while spectating a missing-art Mario. Preview images show native/procedural
vocabulary; they are not Unity screenshots or a RoR2 playtest.

## Checks

- PIK FFI: 40 passed. Empty-cache cursor pose output is retained without world art.
- Cursor tests: 2 passed, including original-art versus empty-cache position and
  rotation through free aim, lock, spin and release using the available local cache.
- Water presentation: 7 passed, including matching textured/primitive head and tail
  coordinates for ordinary Spray and burst, and no tail behind the nozzle.
- SMS FFI: 22 passed, 1 opt-in extraction test ignored. New checks require actual
  short-burst output, bounded segment writes and live normalized Rocket charge.
- Generated tank checks pass for empty/half/full water, ascending charge independent
  of water level, transparent circle bounds and native nozzle letters.
- Presentation lifecycle/spectator, recorded FLUDD packet and shared overview/menu
  metadata checks pass. All three official staged builds pass their actual-DLL
  no-assets gates; Melee's startup boundary/package audit also passes.

Logs/captures: workspace `output/fallback-cues/`. The earlier optional Louie anchor
and jump-articulation QA failures remain recorded in
[prior validation](Asset-session-validation.md). Mixed-assets multiplayer, live
HUD placement, cursor readability, burst appearance and stage/death transitions
still need the manual RoR2 playtest.
