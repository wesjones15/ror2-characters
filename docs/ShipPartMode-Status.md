# Ship Repair 0.3.0 preview — implementation and validation

Branch: `feature/ship-part-mode`, based on `modern/1.5.0` with the 0.2.3 ground-wait
hotfix retained. Native ABI 30; objective protocol 2. This is a local feature
preview, not a published release. No game launch or deployment was performed.

## Implemented

- Solo extra-mode button and multiplayer mode picker; all-Olimar/artifacts-off
  preflight and matching-build requirement.
- Shared server-owned ledger of 30 unique parts, ordered deliveries, stage
  epochs, seeded sampling, reliable objective snapshots and late-state hydration.
- Up to ten missing IDs per normal stage: seven ground parts plus three reserved
  enemy parts. Near completion, reserve `min(3, remaining / 3)` for enemies.
  Bosses/champions release the remaining quota; large enemies and strong elites
  release one. Teleporter-charge fallback reveals any undropped physical parts.
- Original 10–50 carrier weights. Parts are hauled to the nearest reachable
  **landed Dolphin**, then fitted on every team's Dolphin. Ordinary pellets and
  corpses still feed the Onion. No seeds or direct enemy-kill awards for parts.
- Placement waits for the Dolphin's landing and checks paths to its actual intake
  goal. Retries are bounded and spread across frames. Discovery markers, sustained
  jam recovery, void recovery and stage departure warnings are included.
- Original wreck/root poses, ordered fitting animations, repair levels, lights,
  sounds and particle cues. Restored stage progress is silent. Arrival repeats
  each stage; the existing arrival music sting remains first-stage-only.
- Final delivery secures victory and freezes repair time. Original celebration,
  farewell music and Dolphin takeoff lead to the normal RoR2 report. Normally
  twelve seconds; queued repairs delay takeoff, with a bounded fallback and host
  skip. Music survives into results and stops on leaving/new run.
- Repair summary shows outcome/count/time/stages/seed/difficulty alongside RoR2's
  report. Detailed text reports include rules/player count/squad/order. No combined
  numeric score is invented before playtesting.
- Normal stage loop retained; Bazaar and Void Fields preserve progress without
  parts. Unsupported terminal destinations redirect to an eligible first-tier
  stage. Other modes retain their normal objectives and repaired Dolphin.

## Disc extraction and provenance

Extracted 1,332 files from the user's `Pikmin (USA) (Rev 1).ciso` into the ignored
`sources/libpikmin/assets` cache. No disc data belongs in Git or the preview ZIP.

The audit loads all thirty part models and their carry animation bundles. The
sixteen exterior parts also have their original appear/fitted-idle animations;
fourteen internal parts have no exterior attachment joint. Five of the exterior
parts change the hull shape and eleven attach to it. The Dolphin animation bundle
includes wreck, intake, repair-level, hatch and takeoff motions. Existing original
effect definitions and disc sounds drive fitting, lighting, repair and flight.

`RotJump` is 35 frames; `WaveJmp` is 20. References: read-only decomp
`pikiState.cpp::PikiEmotionState::init` and `naviState.cpp::NaviClearState::init`.
The complete-ending farewell stream is `SndData/compend0.stx`:
`MoviePlayer.h` GoodEndingWave (75) → `pikidemo.c` audio config 171/0xAB →
`piki_scene.c` stream 11. Decoded as stereo 44,100 Hz, 59.17 seconds. Its local
audition WAV is ignored at `assets/ship-mode-audit/victory-compend0.wav`.
Listening in the game is still pending.

Re-run the local audit from `sources/libpikmin`:

```powershell
cargo run --offline -p libpikmin-assets --example ship_mode_audit -- assets/ship-mode-audit
```

## Automated evidence

- Full offline Rust suites for core, assets, presentation and FFI pass with the
  actual extracted disc cache. This includes default/host Dolphin delivery,
  receiver loss, no seed/direct fitting, snapshots, incremental repair queues,
  restored parts, flight poses, models, animations and particle loaders.
- `NativeCheck` passes against the release DLL and actual cache: all thirty
  weights/names, actual Dolphin intake goal, physical hauling through C# callbacks,
  exactly one completed Dolphin receipt, victory PCM and existing native behavior.
- `ShipRepairCheck` passes: deterministic sampling, duplicate/stale receipt
  rejection, clock boundaries, restart, failure, secured victory, packet truncation,
  invalid state and pending/spawned enemy objective records.
- Shared multiplayer and run-audio headless checks pass.
- Managed Release build succeeds against the installed DLC4 reference assemblies.
  Existing warnings remain: BepInEx reference architecture and unused
  `OlimarDriver.warnedClient` field. These checks do not establish runtime menu,
  network or terrain behavior.

## Manual playtest remaining

1. Open Ship Repair through solo and host menus; verify survivor/artifact preflight
   and matching client builds. Smoke-test Classic, Eclipse and Simulacrum.
2. Observe the initial wreck, all arrivals over multiple stages, first-stage-only
   sting and silently restored partial repairs. Verify original fitting motions,
   hull grounding, lights, SFX and particles during simultaneous deliveries.
3. Check seven ground/three enemy sources, boss/elite drops, fallback wreckage,
   discovery markers, 10–50 carrier rings, slopes, gaps, jams and void recovery
   across the installed normal stages. Fewer safe sites should log and remain
   playable without granting progress.
4. Two-player host/client and late join: shared mask/order, parts delivered to
   either Dolphin, all Dolphins updated, death/respawn/disconnect, packet delay,
   and no replayed fittings or duplicate recoveries.
5. Leave unfinished parts, loop, visit Bazaar/Void Fields and attempt terminal
   portals; confirm progress survives and an onward route remains available.
6. Deliver part 30 during combat/departure/team wipe; verify secured win, queued
   fitting completion, celebration, sound balance, takeoff, skip, report and music
   lifetime. Check failure summary, pause/loading clock and a fresh run afterward.

Pikmin enemies, competitive Dolphin races, mixed-survivor teams, artifacts,
leaderboards and save/resume are deferred. The preview's co-op objective is shared;
there are no per-player duplicate-part inventories.
