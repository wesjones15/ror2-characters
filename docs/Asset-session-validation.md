# Asset/session candidate evidence - 2026-11-08

Mario 0.6.3 / SMS ABI 53; Olimar 0.6.3 / PIK ABI 65; Melee 0.5.2 / SSBM ABI 7.
These matching DLL pairs are staged under workspace `target/BepInEx/plugins/`.
No live installation was changed. **Not yet played in Risk of Rain 2.**

## Visual identity and viewer proof

The added flowers/tower, Shine, FLUDD backpack, ground marks, generic enemies and
Onion/captain state illustrations are deliberately authored primitives. They
have no original effect cue, emitter or model IDs. The source is
`libssbm/crates/viewer/examples/session_fallbacks.rs`.

- [Landed: legs and captain visible](asset-free-captures/session-20.png)
- [Boarding ascent](asset-free-captures/session-70.png)
- [Flight: legs and captain hidden](asset-free-captures/session-140.png)
- [Drop: captain visible again](asset-free-captures/session-220.png)

These previews illustrate the presentation contract, not an in-game capture.
Host boarding uses a 1.4-second smooth lift into the actual stand-in pod center,
then hides the body. Drawing pools clear on resets and dispose their resources.

Independent original captain art was rendered in
`libpikmin/crates/viewer/examples/standalone_captain.rs` at frames 30, 45 and 60:
Pianta is exactly `npc/montem/mom_model.bmd`, identified by
`libsms-present/body.rs::pianta_files` (Sunshine NPC model); Captain Pikachu is
`PlPkNr.dat`, identified by `libpikmin-present/pikachu.rs::PikachuSkin::load`.
Both append at model index 19 to a generated anchor rig without loading Pikmin 1
assets. No effect cue/emitter applies. The labeled extracted-art captures are
local only in `output/asset-session/`; they are excluded from packages and git.

## Automated checks

- SMS core/scenario/FFI release suites passed. Actual-DLL no-assets tests now
  require finite gameplay emitters and real wet-ground vertices after spraying,
  alongside sustained spray, nozzle thrust/resource and normal jump checks.
- PIK FFI release suite: 40 passed. The empty-cache view test verifies that
  no world models are drawn and only captain draws are emitted. Core tests passed.
  The broader presentation run reached 14/15 view tests; its optional jump
  articulation assertion failed with this cache. The unchanged November 5
  `view-c4064bd0f4a18b4d.exe` reproduces that exact failure, so it predates this work.
- SessionFeatureCheck passed: solo/mixed/complete support, unknown peers,
  lobby join/leave, locked run, late-join compatibility, reset, flying legs,
  captain ascent into the pod, hide and drop visibility.
- Shared skin/overview/menu metadata checks, Mario/Olimar persistent unlock checks,
  Mario presentation lifecycle and recorded multiplayer packet checks passed.
  Luigi's offered entries follow Melee mod presence while preserving unlocks.
- Melee's actual-DLL no-assets check passed, including built-in Super Scope equip
  and beam travel. Its unchanged native gameplay suite was not rerun for this
  shared C# update. Shipping assembly startup boundary passed.
- All three official builds staged successfully with mandatory no-assets gates.
  Existing architecture/unused-member/obsolete-API warnings remain.

Logs: workspace `output/asset-session/`, including native suites and final builds.
The previously recorded optional Louie head/pelvis anchor failure in
[earlier validation](Optional-assets-validation.md) is also unresolved.

## Remaining manual checks

Test both host directions, no assets / base only / alternate only / both caches,
skin indices and progression, lobby join/leave, P2-only capability without P1 art,
late join during a locked P2 run, deaths/revives, stage changes and return to lobby.
Confirm flowers, wetness, Shine pickup, enemy shapes and the full Onion ride in
RoR2. Recorded packets and policy checks do not certify mixed-client replay parity.
