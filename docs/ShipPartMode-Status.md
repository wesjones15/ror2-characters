# Ship Repair 0.3.2 preview — implementation and validation

Branch: `feature/ship-part-mode`, based on `modern/1.5.0` with the 0.2.3 ground-wait
hotfix retained. Native ABI 31; objective protocol 3. This is a local feature
preview, not a published release. No game launch or deployment was performed.

## Implemented

- Solo extra-mode button and multiplayer mode picker; all-Olimar/artifacts-off
  preflight and matching-build requirement.
- Host-owned `[ShipRepair] CompetitiveMode = true`, locked at run start and shown
  in the lobby. Each player has an independent 30-part ledger. First to finish
  secures the race. False preserves shared cooperative repair. HUD/results show
  racer progress, salvage totals and the winner; objective packets retain ordered
  journals, epochs and late-state hydration.
- Two shared map parts, one guaranteed stage-boss part, seven other powerful-enemy
  parts per player (per team in cooperative mode). Initial totals are 10 solo and
  31 with four racers. Parts are limited by actual remaining demand near completion.
  Stage bosses consume their separate single quota across a multi-member group.
  After the ordinary enemy quota, each eligible kill has a 20% bonus-drop chance.
  No lifetime stage cap; up to 451 simultaneous tracking records, with consumed
  slots reused for further bonus drops. Teleporter-charge fallback reveals any
  undropped guaranteed physical parts.
- Independent per-player ordinary drop cooldown, default 30 seconds through
  `[ShipRepair] EnemyPartIntervalSeconds`, locked at run start. Owning players
  receive attribution for Pikmin/minion kills. No cooldown-kill queue or quota
  consumption; the stage-boss reward bypasses the gate. All spawn paths check
  25-metre horizontal spacing from loose parts, relocating crowded enemy drops
  to clear safe sites and waiting when a salvage/fallback site is occupied.
- Original 10–50 carrier weights. Parts are hauled to the nearest reachable
  **owner's landed Dolphin**, chosen by the carrier majority. Ordinary pellets and
  corpses still feed the Onion. Enemy kills never directly award objective progress.
- Duplicate hauls go to the owner's **landed Onion** for twice the carrier weight
  in seeds, split among the three colours. Salvage does not count toward 30. If an
  active rival still needs the identity, the physical part returns to its original
  validated map site after at least five seconds once clear. Each racer can salvage it again.
- Placement waits for the Dolphin's landing and checks paths to its actual intake
  goal. Retries are bounded and spread across frames. Discovery markers, sustained
  jam recovery, void recovery and stage departure warnings are included.
- Original wreck/root poses, ordered fitting animations, repair levels, lights,
  sounds and particle cues. Restored stage progress is silent. Arrival repeats
  each stage; the existing arrival music sting remains first-stage-only.
- Final delivery secures victory and freezes repair time. Original celebration,
  farewell music and winning Dolphin takeoff lead to the normal RoR2 report. Normally
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
  exactly one completed Dolphin receipt, a competitive duplicate haul into its
  owner's Onion with host-granted seeds, victory PCM and existing native behavior.
- `ShipRepairCheck` passes: deterministic sampling, duplicate/stale receipt
  rejection, clock boundaries, restart, failure, secured victory, packet truncation,
  invalid state and pending/spawned enemy objective records. New race checks cover
  independent duplicate identities, salvage without progress, first winner,
  scaling, near-completion demand, winner packets and recycled map parts.
- Pacing checks pass for independent players, exact 30-second boundaries,
  unattributed kills/invalid clock rejection, stage reset and sustained
  four-player kill bursts without queued rewards.
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
3. Check two map/one boss/seven-per-player enemy supply, 20% post-quota bonus drops,
   multi-boss single reward, four-player scaling, fallback wreckage,
   independent player cooldowns/Pikmin kill attribution, crowded kill-zone
   relocation and blocked salvage/fallback sites,
   discovery markers, 10–50 carrier rings, slopes, gaps, jams and void recovery
   across the installed normal stages. Fewer safe sites should log and remain
   playable without granting progress.
4. Two-player host/client and late join: independent mask/order, correct owned
   Dolphin, personal repairs, duplicate Onion salvage/seed payout/five-second
   recycling, death/respawn/disconnect and delayed packets. Also test competitive
   false for shared repairs and no replayed fittings or duplicate recoveries.
5. Leave unfinished parts, loop, visit Bazaar/Void Fields and attempt terminal
   portals; confirm progress survives and an onward route remains available.
6. Deliver part 30 during combat/departure/team wipe; verify secured win, queued
   fitting completion, celebration, sound balance, takeoff, skip, report and music
   lifetime. Check failure summary, pause/loading clock and a fresh run afterward.

Pikmin enemies, mixed-survivor teams, artifacts, online leaderboards and save/resume
are deferred. Competitive races are now the default; cooperative repair is optional.
