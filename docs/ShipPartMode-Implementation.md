# Ship Repair mode — implementation and validation plan

Status: this is the original milestone plan, with delivery corrected to the
Dolphin. The 0.3.0 preview now implements its first playable scope; see
[current implementation and validation](ShipPartMode-Status.md). Follow the
[ruleset](ShipPartMode.md) and [baseline source findings](ShipPartMode-Research.md).
Each numbered milestone is a separate commit or small sequence of commits; commit
the relevant checks with the behavior they verify. Do not deploy while designing.

## Ownership and state

Keep RoR2 rules, scores, scene eligibility, and win/loss in `ror2-olimar`.
Keep generic carrying and delivery policy in `libpikmin`, and ship posing in
`libpikmin-present` / `libpikmin-assets`. Extend `ror2-common` only for reusable
audio lifetime/playback behavior. The sim must not know about RoR2 modes.

Proposed host objects (names are design suggestions):

- `ShipRepairRun`: registered Run prefab/component and host-owned lifecycle.
- `ShipRepairProgress`: recovered mask, monotonic delivery revision, delivery
  journal, clock, outcome, seed, rules, stage ordinal, and stage epoch. It lives
  for the run, outside `PikminWorld` and the native sim.
- `ShipPartStageSpawner`: seeded candidate selection, placement, marker records,
  safe-position recovery, and the current epoch's pellet-to-part mapping.
- `ShipRepairHud`: replicated objective, discovered markers, notifications, and
  results summary. It never awards progress from client interactions.

Use the low 30 bits of a mask for recovered identities; reject IDs outside 0–29.
Count is its population count. A stage record contains `(epoch, pelletId, partId)`
and an accepted flag. Native entity IDs are stage-local and must never be the
identity used for run progression. Do not rely on per-ship `parts.len()` as the
shared run total.

Lifecycle:

```text
Lobby -> StageLoading -> Arriving -> Playing -> Departing -> StageLoading
                                           -> Winning -> Results
                                           -> Failed  -> Results
Any state -> Teardown on leaving the run
```

Only the first Arriving -> Playing transition starts the clock; later stages
retain it. Winning/Failed freeze the clock. Teardown removes every subscription,
message handler, marker, presentation queue, and audio object owned by the run.

## Delivery transaction

1. Core finishes suction into a permitted landed Dolphin and emits an explicit
   ship-part receipt event, without seed production or direct ship mutation.
2. Host verifies the active run is Playing, the stage is accepting receipts,
   the event matches the current epoch's registered pellet/part/Dolphin, and the
   part's recovered bit is clear. Reject stale or duplicate receipts.
3. Atomically set the bit and mark the stage record accepted, assign a delivery
   revision, append the journal entry, and stamp the authoritative repair time.
4. Broadcast progress and the receipt; remove its marker and enqueue the fitting
   on each Dolphin. Gameplay completion must not wait for animation completion.
5. At 30, atomically transition to Winning and lock departure/failure handling.
   A second receipt or an enemy hit cannot reverse a secured win.

Process objective receipts before wipe/departure decisions within a server tick.
A final valid delivery in the same tick as a lethal hit wins; without that delivery,
normal team-wipe failure applies. Close stage acceptance before freeing the native
sim. This gives delivery-versus-transition races a defined result.

Native snapshots remain responsible for world motion. Replicate run state with
run identity, stage epoch, outcome, recovered mask, revision, clock, and rules.
Send full state on join/stage entry and reliable receipt messages for live toasts
and animations. Include ordered delivery IDs or a recoverable journal so a
dropped snapshot cannot erase a fitting. Clients deduplicate by revision and
ignore older epochs. A fresh join or restored stage hydrates existing parts
silently; reconnecting clients do not replay the entire journal. Never accept a
client request to increment the recovered mask.

## Commit-sized milestones

### 1. Prove mode registration and stage routing

In `ror2-olimar`, use the existing content-pack provider to register a run prefab
through `gameModePrefabs`, a win definition through `gameEndingDefs`, and any
required network prefabs. Inspect the ordinary run prefab before choosing how
to reuse it; avoid two competing Run components. Build the Ship Repair mode
entry, normal difficulty selection, all-Olimar Ready validation, artifact
restriction, and host/client compatibility checks. Gate every new hook on this
run's identity. Retire the placeholder config when the real selector works.

Enumerate supported normal stages and optional/terminal scene routes against
the installed game. Ensure the last normal stage continues into a loop. Prevent
alternate endings from bypassing repair; preserve team-wipe failure. Disable or
redirect unsupported portal destinations visibly. Deliver an actual scene policy
table, including DLC-owned scene availability, with this spike.

Check: the fourth mode can be selected, started, and joined; leaving and starting
Classic works; wrong survivor/build is explained; difficulties work; a full loop
returns to playable stages without an accidental alternate win or dead end.
Record any required dependency change rather than silently adding R2API.

### 2. Add an isolated run ledger and repair clock

Implement recovered-set validation, stage epochs, seeded part sampling, immutable
run rules, and lifecycle transitions in host code that can be checked without
Unity. Connect run start/destroy, scene entry, death/revive, and disconnect.
Restore the recovered set to every newly created Dolphin before its view starts.

Use a server clock that counts active scene gameplay, including active time in
hidden realms and later arrivals. Explicitly define pause/loading gates; do not
assume the vanilla difficulty stopwatch counts all hidden-realm time. First-stage
arrival releases the players together or ends at its timeout. Late joins do not
alter the start time. Keep the mode clock separate from native scoring stats.

Check: deterministic samples with no stage duplicates or recovered IDs; 0, 7,
26, 29, and 30 recovered; repeated stage loads; run restart; pauses and loading;
late join; duplicate delivery; invalid part ID; exactly-once terminal transition.

### 3. Extend native carry APIs for host-owned Dolphin receipts

Add an opt-in generic ship-part delivery policy, defaulting to existing ship
delivery. Expose a validated dedicated part-spawn ABI using the disc's config
for weight, size, and identity. Add a receipt event that names the actual receiving
Dolphin. Keep ship fitting as a separate operation driven by the host ledger.

Change destination selection, destination validity, and suction completion
together. In repair mode require a landed reachable Dolphin, pin the selected
goal, and release/put down safely if it becomes unavailable. Part receipts never
produce seeds or call `ship.as_mut().expect(...)` on an Onion. Exclude parts from
the flying-Onion loose-pellet pickup path and other auto-suction shortcuts.

Mirror declarations in `Native.cs`; update the ABI version, size checks,
snapshot encoding/version where fields change, replica event handling, and
multiplayer envelope compatibility together. Update and retain the old
ship-delivery test to prove default behavior still works.

Check in Rust: normal pellet/corpse economy unchanged; default ship delivery;
opt-in host Dolphin delivery; airborne receiver rejection; goal removal/takeoff; no seed
gain; repeated completion; invalid IDs; snapshot round trips. Run the native ABI
size and managed/native compatibility checks for the new contract.

### 4. Place and render recoverable world parts

Connect part spawning after ground/navigation readiness using a dedicated RNG.
Validate paths with the host's carrying/pathing facilities and bound retries.
Track safe positions for kill-plane and jam recovery. Connect discovery, carrier
count, team markers, and the objective HUD. Selection must be reproducible for
the same seed/rules/stage; placement logs must explain rejected candidates.

The current pellet renderer draws numbered pellets by carrier count. Add a real
world-part rendering branch using `ship_part`, the loaded part model, disc scale,
and carry motion. Keep it distinct from fitted attachments on the ship and check
the Unity fallback path. Audit all 30 models and carry requirements; flag missing
required data before enabling the mode rather than making an invisible objective.

Check: 10/10 deliveries on several open and indoor stages; final stage with
fewer than 10 missing parts; bounded placement failure; falling/stuck part;
large carrier ring clearance; marker sync; unavailable Dolphins; departing with unfinished
hauls. A later stage can offer those IDs again.

### 5. Connect live repair presentation and every-stage arrival

Give each Dolphin view an ordered repair queue. Hydrate a restored part set with
`ShipAnimator.start`; use `suck_start` / `suck_finish` and original upgrade cues
for new deliveries. Handle internal parts and consecutive upgrades. Revisit the
current grounded root-pose override so it does not suppress repair motions.
Expose an animation-completion signal or a bounded fallback for queue advancement.

Explicitly enter `DolphinArrival` once per stage/player in this run, using the
pod gate or a stage-arrival hook selected by the spike. Scope protection and
input locking to arrival, handle low roofs and GroundGate waits, and guarantee
release on timeout or teardown. Mid-stage revive uses a short re-entry. Keep
`SpawnMusic.PlayOnce` first-stage/local/once-per-run checks unchanged.

Check: first wreck arrival; later partially repaired arrival; two players with
different load times; mid-stage revive; late join; two deliveries in one tick;
internal then exterior part; visible upgrade motion; no repeated stings or
collection sounds on restoration. Test with actual extracted assets; an
asset-dependent test that skips is not visual evidence.

### 6. Secure victory, celebration, and results

On Winning, stop damage/spawning/departure and freeze repair metrics. Drain the
repair queue, audition and select the disc victory audio and happy motions, then
play the squad celebration and takeoff. Make host skip and hard timeout converge
on the same successful ending. Keep queue drain and music inside the timeout.

Call the normal game-over path after the celebration, preserving its report and
`StatSheet`. Audit the existing `RunAudio` cleanup before wiring music; ordinary
cue playback after `onClientGameOverGlobal` would be stopped. Add a reusable
bounded victory playback path only if needed for the selected song's duration.
Missing optional audio/motions fall back to a toast and normal results.

Add the mode summary without replacing native report fields. Keep multiplayer
results available until the report UI has consumed them, even if the sim has
already been freed. Verify how custom mode names/endings and supplemental metrics
survive report save/load; add a versioned companion record keyed by run GUID if
the native format has no extension point. Do not mutate the native report schema.

Check: final delivery during combat, simultaneous final receipt/wipe/departure,
duplicate final messages, missing optional assets, host skip, timeout, clients
joining/disconnecting during Winning, failed run summary, leaving during audio,
and a clean next run. Confirm no unintended unlocks, rewards, or credits behavior.

### 7. Integrate source pins and playtest the full run

Create `feature/ship-part-mode` from each affected component's `modern/1.5.0`
before implementation, commit changes there, then commit updated parent pins.
The current design branch changes only parent docs and the read-only inspection
helper. Build the pinned modern package and run the existing relevant native,
network, ABI, and audio checks. Update player docs/changelog when it is playable;
mark runtime checks as pending until performed. Publish/deploy only when requested.

Manual acceptance: solo full 30-part win; two-Olimar host/client full win; death
and revival; abandoned parts returning; complete normal stage loop; hidden realm
and blocked terminal route; all 30 parts audited; missing optional celebration
assets; Classic/Eclipse/Simulacrum regression smoke checks. Capture repair split
times and typical native stats. Tune spawn count, carrying, and celebration length
from those runs before choosing a numeric score formula or widening mode support.
