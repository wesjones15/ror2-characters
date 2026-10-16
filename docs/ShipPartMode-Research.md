# Ship Repair mode — source and API findings

Inspected on 2026-10-15. These findings support the [design](ShipPartMode.md);
they do not claim a playable mode or verified runtime behavior.

## Baseline

| Repository | Pinned commit |
| --- | --- |
| ror2-characters (`modern/1.5.0`) | `9bf1a41` |
| libpikmin | `aa38c94736068afbfa306ef69eb1c1b5071bd383` |
| ror2-olimar | `02c0738c8a9d586cddda09f8b843fb456862846e` |
| ror2-common | `177d4f4b2d89586b0a3a346f9c9c02e70ae17428` |

The feature branch lives in the parent repository. The design does not change
source submodule pins, DLLs, release versions, or the installed game.

## Existing support and gaps

| Requirement | Evidence in pinned sources | Work needed |
| --- | --- | --- |
| Broken Dolphin | [PikminWorld.cs](../sources/ror2-olimar/OlimarTest/PikminWorld.cs), `SpawnDolphin`, adds all 30 parts only when the placeholder config is off | Drive the initial part set from run state; config currently produces a bare ship without an objective |
| Thirty part identities and assets | [ship.rs](../sources/libpikmin/crates/libpikmin-assets/src/ship.rs), `PART_IDS`, `parse_pel_anim`, `ship_joint` | Spawn world parts and expose names/markers in the host |
| Core ship-part carry | [carry.rs](../sources/libpikmin/crates/libpikmin/src/carry.rs), `PelletDesc.ship_part`, `decide_goal`, `suck_step` | Current path deliberately delivers to a grounded ship, not an Onion |
| Onion delivery | Same file, `pellet_has_destination`; test `ship_parts_go_to_the_ship_not_the_onion` | Add an opt-in delivery policy and event; also update destination selection, validation, and completion, which currently expects a ship and would panic for an Onion |
| Host creates a ship part | [FFI lib.rs](../sources/libpikmin/crates/libpikmin-ffi/src/lib.rs), `pik_sim_spawn_pellet` | Current FFI constructor explicitly sets `ship_part: None`; add a dedicated validated part-spawn function |
| World part rendering | [view.rs](../sources/libpikmin/crates/libpikmin-present/src/view.rs), pellet draw loop | Currently selects numbered-pellet models by carrier count; add a branch for actual loose ship-part models and carry motions |
| Restore fitted parts | [onion.rs](../sources/libpikmin/crates/libpikmin/src/onion.rs), `give_ship_part`; matching FFI entry and [Native.cs](../sources/ror2-olimar/OlimarTest/Native.cs) | API exists, but the host does not retain a recovered set across stages |
| Progressive appearance | [repaired_ship.rs](../sources/libpikmin/crates/libpikmin-present/tests/repaired_ship.rs) and [view.rs](../sources/libpikmin/crates/libpikmin-present/src/view.rs) | Test covers empty versus restored full ship; it silently returns without assets and does not verify incremental repairs |
| Part addition animation | [ship.rs](../sources/libpikmin/crates/libpikmin-assets/src/ship.rs), `ShipAnimator.suck_start`, `suck_finish`, `assign_start` | Methods exist, but the current ship path in `View` calls start/land/update rather than the live suck methods; wire ordered deliveries and allow repair poses instead of the fixed grounded root pose |
| Part collection sound | [audio.rs](../sources/libpikmin/crates/libpikmin-present/src/audio.rs), `Event::ShipPartCollected` | Existing sound locates a ship; an Onion receipt event needs correct positioning and exactly-once feedback |
| Stage arrival | [Plugin.cs](../sources/ror2-olimar/OlimarTest/Plugin.cs), `DolphinArrival` registration; [DolphinArrival.cs](../sources/ror2-olimar/OlimarTest/DolphinArrival.cs) | Body initial state is registered, but the game gates pod spawning to stage one; arrange later-stage arrivals explicitly and verify authority/respawns |
| Stage-one sting | [SpawnMusic.cs](../sources/ror2-common/src/SpawnMusic.cs), `PlayOnce` | Already checks `stageClearCount == 0`, local ownership, and `playedRun`; retain those gates |
| Stage persistence | [PikminWorld.cs](../sources/ror2-olimar/OlimarTest/PikminWorld.cs), `NewStage` and `FreeSim` | Squad/storage are preserved separately; a run-scoped repair ledger must survive sim teardown |
| Victory audio lifetime | [RunAudio.cs](../sources/ror2-common/src/RunAudio.cs) | `onClientGameOverGlobal` stops ordinary cues and frees native streams; design celebration ordering before calling game over, or explicitly support a victory-owned audio lifetime |
| Longer victory song | [SpawnMusic.cs](../sources/ror2-common/src/SpawnMusic.cs), `Load`, `extraNames` | Loader accepts at most 10 seconds and does not register a victory cue; a full song needs bounded longer playback or streaming, plus cleanup |

The original assets have **5 exterior shape-changing parts, 11 attached parts,
and 14 internal parts**. The renderer's restored-ship test expects 16 exterior
attachments, not 30. Internal deliveries need count/toast feedback even if the
ship does not visibly gain a new model. Repair levels come from disc tuning;
do not hardcode cosmetic milestones from the mode's spawn count.

## Installed modern RoR2 API inspection

Read the local DLC4 `Risk of Rain 2_Data/Managed/RoR2.dll` with the installation's
`BepInEx/core/Mono.Cecil.dll`. No game was launched or changed. Reproduce with:

```powershell
powershell -ExecutionPolicy Bypass -File .\docs\tools\InspectShipModeApi.ps1 -RoR2Dir "D:\Games\Risk of Rain 2"
```

Observed metadata:

- `RoR2.GameModeCatalog` catalogs **Run prefabs**, not a `GameModeDef` type.
  Its public legacy `getAdditionalEntries` event forwards registration to
  `ContentPack.gameModePrefabs`. Prefer the existing plugin content-provider
  pattern; validate its registration timing and network prefab requirements.
- `RoR2.Run` exposes `userPickable`, `nameToken`, `gameModeIndex`, starting-scene
  groups, stage RNGs, and run stopwatch APIs. The base `Run` supplies the ordinary
  run flow; do not depend on an assumed `ClassicRun` class.
- `Run.get_spawnWithPod()` returns `Run.instance.stageClearCount == 0` in this
  DLL. That is a concrete reason to investigate later-stage arrival entry rather
  than merely re-register the initial body state. Overriding this property must
  be scoped to the repair run, if that proves to be the right mechanism.
- `Run.BeginGameOver(GameEndingDef)` exists. `GameEndingDef` exposes `isWin`,
  ending text, credits choice, and a game-over controller state. Registration and
  normal failure handling still require a runtime spike.
- `RunReport` includes mode, ending, seed, rulebook, run stopwatch, and player
  reports. `PlayerInfo` has a `StatSheet`. Inspection did not establish one
  universal numeric score to combine with repair time: retain the normal report
  and inspect its actual displayed stats during the UI spike.

Catalog metadata proves registration surfaces exist. It does not verify mode
tile layout, lobby selection, stat persistence, achievements, stage routing,
ending presentation, or multiplayer behavior. Those are explicit prototype tasks.

## Celebration candidates from the local Pikmin 1 decomp

The decomp is a read-only reference in the workspace's `pikmin-main` folder;
it is not a source submodule or distributed game content.

- `src/plugPikiKando/pikiState.cpp`, `PikiEmotionState::init`, chooses
  `PIKIANIM_Jump_B1`, `PIKIANIM_Jump`, or `PIKIANIM_RotJump` for Happy, with
  `SEF_PIKI_JUMP1/2/3`. These are evidence for a happy jump/spin celebration,
  not a verified imported dance sequence.
- `src/plugPikiKando/naviState.cpp`, `NaviClearState::init`, plays
  `PIKIANIM_WaveJmp` for Olimar. Audition it on Olimar's extracted skeleton.
- `src/jaudio/piki_scene.c` names `happyend1.stx`, `compend1.stx`, and
  `compend0.stx`; `src/jaudio/pikidemo.c` has GoodEndingTakeOff handling.
  Treat these as soundtrack leads, not an identification of the requested song.
- [render.rs](../sources/libpikmin/crates/libpikmin-audio/examples/render.rs)
  can render sequenced music/SFX from a discovered asset cache. Check whether
  the desired ending music is streamed or sequenced before choosing an extractor
  path. Listen to candidates and preview motions before committing an asset ID.

Only code and findings belong in Git. Keep audition WAVs, extracted models,
textures, animation data, and disc images in ignored local output directories.
