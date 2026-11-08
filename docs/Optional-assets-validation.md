# Optional-assets candidate validation — 2026-11-07

Candidate versions: Mario 0.6.2 (`sms` ABI 51), Olimar 0.6.2 (`pikmin` ABI 64),
Melee 0.5.1 (`ssbm` ABI 7). **Not yet played in Risk of Rain 2.**

### Source follow-up — 2026-11-08

The original 2026-11-07 ZIP above records ABI 51. Current staged Mario is ABI 52
and includes native pose flags for horizontal dives/slides, a shorter ground pound
and a wider spinning core. Luigi/Louie stand-ins and conditional missing-game
overview notes are implemented. [Pose/skin preview](asset-free-captures/poses-120.png)
has no original asset/cue/model ID; [frames 90](asset-free-captures/poses-90.png) and
[150](asset-free-captures/poses-150.png) show the procedural preview at other times.

Current reference checks match code-only and local asset-backed run/jump traces,
dive/slide distance, pound timing/fall, and all four nozzles' timing, lift, travel
and water use. Mandatory ordinary-jump/no-early-spray-cutoff checks pass. Native
FFI tests pass (21 passed, one opt-in extraction test ignored); shared overview/
skin/menu-metadata checks pass. All three current DLL pairs are staged under
workspace `target/BepInEx/plugins`, with their no-assets gates passing. Melee's
startup boundary also passed; its unchanged native behavior suite was not rerun
for this C# presentation update. Logs are in `output/no-assets-poses/`.

This does **not** establish mixed-disc multiplayer safety. The new
[asset-gate audit](Asset-gate-audit.md) records remaining content gates, possible
invisible Pikmin enemies and inconsistent optional skin indices. RoR2 play and
mixed-disc testing remain pending. The older optional Louie-anchor failure below
was not changed or reclassified by these checks.

## Viewer proof and identity

These are authored procedural stand-ins, with no extracted asset, emitter, model or
cue ID. They are not substitutes presented as original game effects. The source is
`libssbm/crates/viewer/examples/no_assets.rs`, `libssbm/crates/libssbm-assets/src/procedural.rs`,
`libssbm/crates/libssbm/src/builtin.rs`, and Mario's `Params::builtin` / `AnimTable::builtin`.
The viewer reads no game assets or sound banks. It runs Mario/water at 120 Hz and
a Melee fighter at 60 Hz. The Olimar shapes illustrate the existing stand-in vocabulary.

Three distinct frames were captured before host presentation work, then refreshed
with the generated Melee model and live simulation:

- [Frame 90](asset-free-captures/procedural-90.png)
- [Frame 120](asset-free-captures/procedural-120.png)
- [Frame 150](asset-free-captures/procedural-150.png)

Reproduce from `libssbm/`:

```powershell
cargo run --release -p ssbm-viewer --example no_assets -- ../output/no-assets
```

## Automated results

- Mario core/scenario and FFI suites passed. The mandatory empty-path test creates,
  steps, sprays and consumes water with a null view. Separate checks require actual
  Hover/Rocket lift and Turbo travel. Existing FFI regressions passed after the
  constructor changes; the explicit disc-extraction test remains opt-in/ignored.
- Olimar FFI suite passed, including an empty-path constructor and all 30 generic
  Ship Repair parts. Existing applicable snapshot/carry/view tests passed; optional
  disc/expansion cases skip when their data is unavailable.
- Melee workspace tests passed. Mandatory built-in tests cover movement and
  activation/recovery for five attack inputs on all eight fighters, damaging normals
  and native generated models. Existing native/host startup, input, arrival, ground
  recovery and ABI checks passed. Real-disc cases skip without their complete caches.
- Shared `tests/NoAssetsCheck` passed against the actual native DLLs for all three
  mods. It uses empty paths, shipping Mario/Melee bindings/layout checks and Olimar's
  constructor/objective entrypoints. Melee also
  updates each generated view and checks generic projectile travel; Mario copies
  live water geometry state without a native presentation handle.
- Each host build runs the no-assets boundary gate before copying release files.
  Staging is under workspace `target/BepInEx/plugins/`; no live installation was changed.
- Character manifests contain the declared loader dependencies and no mandatory
  SharedFiles dependency. Package checks exclude discs, extracted assets, setup tools
  and developer path pointers.

Full logs and viewer outputs are in workspace `output/no-assets/`; Melee's complete
build/check log is `ror2-samus/dist/build.log`. Build warnings include pre-existing
BepInEx architecture/reference and unused-member warnings; no build errors remain.

An additional Olimar `NativeCheck` run against the available optional caches reports
one failure: **"Louie anchors put the head above the pelvis"**. The same check also
fails against the previous `release-20261106` DLL with the same cache; it predates
this work. Other executed checks in that suite passed, including ABI loading and
the base captain's anchors. This optional-skin check remains a release QA issue;
the mandatory no-assets gates pass. Baseline comparison output is in workspace
`output/no-assets/olimar-baseline-boundary.log`.

## Manual gates before publication

Use a fresh disposable RoR2 profile with none of the developer's discs, caches or
SharedFiles folders. Test each mod separately and all three together: select, exit
the stock pod, move, use each offered skill against an enemy, interact/use equipment,
die/revive, change stages, complete an offered progression loop and return to lobby.
Verify that borrowed survivor sounds/models do not leak through and no shapes linger.
Repeat with valid optional caches to check original presentation/custom arrivals.

Co-op, differing local asset availability and a full Ship Repair playthrough have
not been manually validated. Existing replay/snapshot checks are not that evidence.
Fallback tuning, attack windows and anchors are approximations rather than disc data.

This candidate addresses the technical requirement for external GameCube assets;
it does not claim an appeal decision or resolve other release blockers.
