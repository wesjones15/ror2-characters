# Optional game assets: release implementation plan

Prepared 2026-11-07. Runtime implementation and automated candidate checks are now in place;
see [validation](Optional-assets-validation.md). Manual RoR2 acceptance/co-op checks remain pending.

## Release outcome

Install Mario, Olimar or Melee and play immediately, with no GameCube disc, extracted
cache, asset downloader, converter or setup tool. The mods still require Risk of Rain 2,
their packaged native DLLs and the declared mod-loader dependencies.

Without game assets, characters and gameplay objects use colored procedural shapes.
Mario is a red cylinder/capsule; FLUDD water is blue cylinders/capsules following the
actual spray. Olimar and Pikmin retain their existing shape presentation. Melee fighters
have distinct colors and sizes, with simple shapes for shots, bombs, eggs and other
gameplay objects. Missing game sounds, music and decorative effects are silent/omitted.
RoR2's normal world audio remains available.

**Arrival rule:** if the custom arrival assets are unavailable, use RoR2's standard
drop pod and its normal exit flow. Apply this consistently to Mario, Olimar and Melee.
Keep Olimar's existing usable stand-in assets; replacing them is not part of this work.

Providing a supported disc/cache is optional. It enables the original presentation and
disc-derived gameplay data where available. Asset-free gameplay uses explicitly authored
fallback tuning and move schedules; exact original-game timing is not promised.
Movement, attacks and progression must work; a visible cylinder with dead skills does
not meet the requirement.

## Findings from the current implementation

Paths below are relative to their individual source repositories.

| Area | Existing behavior and implication |
| --- | --- |
| Olimar simulation | `libpikmin/crates/libpikmin-ffi/src/lib.rs`, `pik_sim_new` and `pik_sim_params_source`, already support built-in defaults without a cache. Reuse this separation between simulation and presentation. |
| Olimar shapes | `ror2-olimar/OlimarTest/PikminView.cs` already draws colored Pikmin capsules, pellets, Onions, sprouts, cursor/whistle rings and an arrival-ship fallback. Extract reusable rendering machinery, leaving Pikmin-specific layout and meaning here. |
| Olimar gaps | `OlimarDriver.FixedUpdate` still gates client control on `AssetsReady`; `PikminWorld` also has an asset-gated replica path. `PikminView.LateUpdate` can leave the underlying captain body visible without models. Verify and finish the captain fallback, rather than assuming the existing swarm fallback completes this task. |
| Mario startup | `MarioDriver.CanDrive` requires `Plugin.AssetsReady`; `libsms-ffi::sms_sim_new` rejects a directory without `params_mario`. Both gates must change. |
| Mario timing | `libsms/src/anim.rs::AnimTable` has a generic missing-clip fallback. State transitions depend on animation clocks, so a generic looping clip alone is not sufficient evidence of usable gameplay. |
| Mario water | Water simulation runs in `libsms-ffi`; its existing `MarioWater` renderer reads `sms_view_water_*`. Add an asset-independent drawing feed from the simulated water, rather than requiring a model/audio view to draw the spray. |
| Melee startup | `ror2-common/src/MeleeDriver.cs` calls its Commando fallback when assets are absent. That restores stock skills and is not playing the selected fighter. |
| Melee native coupling | `libssbm-ffi::ssbm_sim_new_fighter` loads common/special/defense tuning, a rig, animation/action definitions and an audio bank. `Handle` requires a `Rig` and mixer. Missing models or audio can therefore prevent simulation creation. |
| Melee gameplay data | Action scripts, posed hitboxes, root motion, projectile/article data and attachment joints affect gameplay. Replacing only the fighter mesh would leave missing attacks and spawn points. Existing synthetic fixtures and prototype schedules are starting points to audit, not a complete production fallback. |
| Shared displays | `ror2-common/src/DisplayModel.cs` expects `IDisplayActor.Models` to be a `ModelView`; it treats a missing model as failure. Extend this shared seam for procedural actors. |
| Release messaging | Release `README.md`, `docs/Install.md`, `thunderstore/packages.json` and SharedFiles instructions currently describe discs as required. Update these after runtime acceptance passes. |

Existing-work review included the recent project logs, viewer examples,
`libssbm/docs/behavior-spec.md`, `libssbm/docs/first-pass-audit.md` and the asset-test
inventory. In particular, shared commit `068297a` repaired the visible stock fallback;
it did not implement asset-free Melee gameplay. Some older behavior-spec sections
describe historical prototypes, so use current constructors and tests as the baseline.

At planning time the canonical `libsms/` pointed at
`explore/luigis-mansion-fludd`. Its release-worktree source is on `modern/1.5.0`.
Implementation switched the primary checkout to `modern/1.5.0`, preserving the exploratory
branch. Builds use the canonical repositories. Existing release submodule working directories
were preserved; release gitlinks record the canonical source commits used for packaging.

## 1. Commonize Olimar's fallback foundation

Use `ror2-common` for the shared Unity implementation, compiled into each plugin as it
is today. Keep gameplay in the existing Rust cores. Do not make Mario or Melee depend
on the Olimar plugin or on `libpikmin`.

- Extract primitive creation, safe materials, color assignment, segment orientation,
  pooling, interpolation support and disposal from `PikminView` where reusable.
  Primitive renderers have no gameplay colliders; authoritative collision stays in the
  existing simulation/host code. Reuse meshes/materials and avoid per-drop allocation.
- Provide one procedural character/display actor and reusable sphere, capsule,
  cylinder/segment, disc and ring drawing. Support facing, scale, skin tint, damage
  flash, visibility, death cleanup and stage transitions through shared code.
- Extend display/portrait handling with a small shared drawing seam or adapter.
  Preserve existing `ModelView` users. Supply generated geometric portraits and skill
  symbols, or text where appropriate, when disc artwork is absent.
- Separate **simulation readiness** from local capabilities for models, audio, effects
  and UI art. A missing audio bank cannot invalidate valid gameplay data or a model.
  A missing decorative effect cannot stop an attack. Report missing assets once as an
  informational fallback decision; invalid optional data gets one actionable warning.
- Use automatic selection by default, plus an explicit built-in-only setting for
  repeatable testing and users who want shapes even with discs present. It must bypass
  discovery/extraction and optional cache reads. Missing native DLLs or ABI mismatches
  remain real errors, distinct from missing optional assets.
- Keep gameplay tuning, move timing, entity semantics and game-to-host units in their
  current cores/adapters. `libcommon` is only for genuinely reused game-neutral Rust
  utilities, not a shared Mario/Melee/Pikmin gameplay implementation.

Extract the helpers from Olimar and verify that its current fallback still works;
preserve its existing shapes and stand-ins rather than redesigning them. Then consume
the same helpers in Mario and Melee. Avoid three separate
primitive-rendering systems or per-fighter copies of the readiness policy.

## 2. Prove the procedural presentation in viewers first

Before changing C# presentation behavior, add a no-assets route to the relevant Rust
viewer/example and capture the proposed shapes. Use a genuinely empty asset location
and no discovery of a developer cache.

- Olimar: captain, several Pikmin colors, Onion, pellet and cursor/whistle feedback.
- Mario: red body and blue FLUDD spray across several frames, including an aimed spray
  and an airborne nozzle action. The geometry follows simulated water, not a cosmetic
  stream independent of damage and range.
- Melee: a generic fighter, a melee active window, a moving projectile and an alternate
  body form such as Samus's ball or Yoshi's egg.

Label captures with **procedural fallback, no extracted asset/cue/model ID** and the
scenario/profile. These are intentionally new shapes, not guesses at original effect
assets. Original-asset fidelity work continues to follow the repository's exact-ID,
viewer-first rules. Deliver viewer captures before host changes, then boundary checks,
then staged builds. If no capture exists after roughly 30 minutes of implementation,
stop with the blocker and one next experiment.

## 3. Finish Olimar's no-assets behavior

- Keep `pik_sim_new`'s default-parameter path and make the active parameter source visible
  in diagnostics. Do not silently present defaults as disc tuning.
- Remove optional-asset gates from control/replica creation where simulation is usable.
  Verify the existing captain stand-in in lobby display, spawn, death and respawn;
  retain it wherever it already works. Suppress unintended borrowed survivor mesh/audio
  only where needed. Missing Dolphin/custom-arrival assets select the standard drop pod.
- Keep follow, whistle, throw, attack, carry, pellet delivery, Onion storage and plucking
  functional with shapes. Test tank/counter/menu equivalents using generated UI/text.
- Audit Ship Repair and other advertised progression: missing part models, part config,
  treasure art, ship cinematics or sounds must not strand a run. Provide authored
  fallback gameplay definitions and simple part/ship shapes for required progression.
  Separately optional expansion content may retain its documented availability rules.

## 4. Make Mario playable without Sunshine assets

- Add an explicit built-in gameplay constructor/profile to `libsms-ffi`, sharing the
  existing `Sim`, FLUDD water manager and host callbacks. Retain the disc-backed path.
  Use existing source-code defaults where suitable and author missing finite action
  durations/loop modes. Test recovery transitions instead of relying on the generic
  missing-animation loop.
- Make `MarioDriver` wait for a usable simulation, not extracted models. Apply the same
  path to lobby actors, puppets and clones. Keep native ABI declarations and size checks
  synchronized if the boundary changes.
- Export the minimum read-only water state needed to draw blue segments/droplets from
  the existing water simulation without `sms_view_new`. Use deterministic body-relative
  FLUDD emitter positions when no animated rig supplies them; gameplay and drawing use
  the same emitters. Keep nozzle selection, tank consumption/refill, aim, damage and
  water interactions independent of optional graphics/audio.
- Draw Mario with the shared procedural actor. Preserve his movement, jump family,
  dive/slide, wall interaction, pound and available nozzle skills. Provide text/simple
  HUD for water, nozzle, health and gameplay counters when Sunshine UI pictures are absent.
- Use the standard RoR2 drop pod when statue/portal/custom-arrival assets are missing;
  select that path before the custom sequence starts. Keep death/completion transitions
  bounded when their presentation is missing. Missing presentation must never hold vehicle control,
  input, a camera or a completion sequence indefinitely.
- Audit coins, pickups, carried objects, Yoshi and other enabled gameplay props for
  shape fallbacks. Keep the default Mario selectable without alternate-skin assets.
  Existing experimental content stays under its existing gate and must not crash the
  fallback when enabled.

## 5. Make every registered Melee fighter functional

- Split native gameplay construction from rig/audio construction. Add an explicit
  built-in profile for each registered fighter, using the same `Sim`, behaviors, host
  damage integration and fixed 60 Hz step. Make absent presentation a supported handle
  state across exports; do not create fake extracted files to satisfy constructors.
- Supply authored common/special/defense tuning, attack startup/active/recovery windows,
  melee volumes, projectile definitions and required motion transitions. Audit every
  clip-command or root-motion dependency, including release flags and charge loops.
  Reuse existing prototype behavior only after proving the move works to completion.
- Resolve hitboxes, muzzle/hand/mouth positions, grabs, throws, tethers and item attachment
  through documented body-relative fallback anchors. Share that contract with rendering
  so damaging objects appear where they act. Do not sample nonexistent bones.
- Keep generic projectile visuals independent of native article-model loading. Preserve
  ownership, damage, speed, bounce, homing, explosion, lifetime and cleanup in the
  existing combat services. Omit decorative particles and unavailable sound banks.
- Remove the missing-assets route to Commando skills. Preserve each fighter's identity,
  loadout, controller bindings and implemented mechanics. Give shield/charge/held-item
  states enough simple visual or HUD feedback to be playable.
- Use the standard RoR2 drop pod for missing custom-arrival/figurine assets. Make
  rebirth, KO, transformed bodies, held items and camera recovery work without optional
  animations, banners or effects. No hidden-body or input-lock state
  may wait for an unavailable asset.

Required coverage is the currently registered roster: Samus and Yoshi with normal
settings; Fox, Luigi, Captain Falcon, Link, Pikachu and Donkey Kong when existing
unfinished-content settings enable them. This does not add the separate native Melee
Mario lab as a new survivor or complete unrelated unfinished mechanics.

## 6. Asset selection and optional enhancement behavior

- Decide a complete gameplay profile at simulation creation. Do not silently mix a
  partial set of disc attack data with missing fallback definitions. Local model/audio
  capabilities may degrade independently from that gameplay choice.
- Freeze gameplay profiles for the simulation lifetime. Finish optional extraction in
  the background and use newly available data at a safe lobby/new-run boundary. Never
  change gravity, attack timing or hitboxes midway through a run because extraction
  finished. Valid caches remain usable without a disc.
- Missing, unsupported, corrupt, partial or inaccessible optional assets all leave a
  playable built-in path. Bound work/retries and prevent reading a cache being rewritten;
  reuse existing SharedFiles locking/versioning rather than inventing a second extractor.
- Base survivor/content registration and catalog ordering must not depend on local
  discs. Keep existing experimental/unlock rules stable. Optional skin choices must
  resolve safely to a base shape when their local presentation is unavailable.
- Network replay/shadow simulations need the authority's gameplay profile and profile
  version, not a fresh decision from the receiving machine's cache. An asset-free peer
  must be able to display authoritative gameplay using shapes. Audit whether existing
  replay protocols can support this; if not, add authoritative state support or a
  shared built-in session profile and test that choice. Do not infer working network
  play from single-player or boundary tests.

## 7. Verification and release gates

Mandatory no-assets tests run with no disc, no extracted cache, no environment override
and no inherited working-directory discovery. They **pass or fail, never SKIP**.
Existing real-disc regressions remain optional and print SKIP when their cache is absent.

| Gate | Required evidence |
| --- | --- |
| Viewer | Labeled no-assets captures above, including several frames of moving water/projectiles. |
| Rust simulation | Empty/nonexistent asset directory creates each supported sim; movement, attacks and recovery advance; resource values remain finite; no required asset reads; deterministic stepping/profile selection. |
| Mario gameplay | Spray hits an enemy and drains/refills water; Hover/Rocket/Turbo activate and end; jumps, slide, pound, damage and death recover without animation/view handles. |
| Olimar gameplay | Recruit, throw, attack, carry, deliver, grow/pluck and transition stages; offered progression can complete without assets. |
| Melee gameplay | Per fighter: every offered skill activates, does its intended gameplay work, spends/recharges resources and exits. Include normals, charge/release, defense, grabs/throws, projectiles and alternate forms where implemented. No fallback to Commando. |
| C# boundary | Use the real packaged native DLLs with empty roots. Exercise constructors, null/absent view paths, new state exports, ABI/layout checks, projectiles, cleanup and repeated create/free. Required checks precede staging. |
| Drop pod | With custom arrival assets absent, all three mods select the standard pod; normal interaction exits it, hands control to the selected character's sim, restores the camera and leaves no pending custom-arrival state. Test spawn and subsequent stage arrivals. |
| Partial assets | Valid gameplay data without audio/models; missing/corrupt gameplay data; unsupported disc; extraction failure; absent/read-only SharedFiles; successful later extraction. Each selects a usable documented path without error spam or hangs. |
| Cache regression | Valid extracted assets still select the existing enhanced path. Missing one optional presentation capability does not disable the others. |
| Manual release smoke | Fresh disposable profile outside developer search paths, each mod alone and all three together: select, spawn, move, kill an enemy with each offered skill, use equipment/interact, die/revive, change stage, end run and return to lobby. Check displays, UI, stock-audio leakage and cleanup. |
| Networking regression | Boundary/replay tests for matching built-in profiles and differing local presentation availability; manual multi-instance play only when actually performed and within the repository's play restrictions. |

Do not delete or relocate the user's real caches to simulate absence. Use isolated test
roots/profiles. A built-in-only setting helps coverage but does not replace the clean
installation smoke test, which catches startup/discovery dependencies.

## 8. Release packaging, documentation and appeal evidence

- Remove mandatory `wesleyasaurus-SharedFiles` dependencies from character manifests;
  it is a folder-only optional convenience package. Shared code already compiled into
  each plugin must tolerate the folder being absent. Discover/create optional cache
  folders lazily and handle write failure without disabling built-in play.
- Preserve declared loader/runtime dependencies. No downloadable content pack, external
  executable or undocumented local file may be necessary for basic play.
- Update release/source READMEs, `docs/Install.md`, Thunderstore descriptions and
  `ror2-common/sharedfiles` instructions: installation is install-and-play; a separate
  optional section explains original models, textures, sound and disc-derived tuning.
  Clearly describe approximate fallback gameplay where it differs.
- Keep existing package checks excluding discs/extracted content. Add an installed-file
  check and clean-profile smoke checklist proving that all required runtime DLLs are
  packaged and no developer path, `assets_dir.txt`, cache or optional folder is required.
- Build from the verified release branches, run appropriate Rust and C# checks, refresh
  release submodule pins, then stage under workspace `target/`. Do not deploy to or
  launch the user's live installation. Commit each verified increment by explicit path.
- Assemble appeal evidence: package file list/dependencies, fresh-profile setup,
  no-assets gameplay captures and logs, successful checks, and optional-assets wording.
  Record manual play separately. Addressing this dependency blocker does not claim the
  appeal is approved or that other blockers are resolved.

## Ordered implementation increments

1. Add failing no-assets constructor/behavior checks and small viewer demonstrations;
   capture the proposed procedural presentation before C# visual edits.
2. Extract and verify common fallback helpers through Olimar; finish captain/client and
   required progression gaps.
3. Deliver Mario's built-in simulation, finite action clocks, independent water drawing,
   red body, blue spray, UI and safe lifecycle transitions as one playable increment.
4. Refactor Melee's mandatory rig/audio dependency; complete and test one fighter
   end-to-end, then apply the shared implementation to the remaining roster. Do not
   mark Melee complete with only the first fighter working.
5. Close partial-cache, profile/replay and enhanced-path regressions; run the release
   smoke matrix, update packages/docs and stage the release candidate.

Completion means the declared runtime dependencies and packaged files are sufficient
to play every offered character with working skills. Until the manual smoke test is
performed, report builds as **not yet played**.
