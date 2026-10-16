# Ship Repair mode — design proposal

Status: design only; no playable mode is implemented by this branch. Based on
`modern/1.5.0`, parent commit `9bf1a41`. Working branch: `feature/ship-part-mode`.
The rules below are recommended defaults for a first playable version, subject to
playtesting. Technical findings are in [ShipPartMode-Research.md](ShipPartMode-Research.md)
and the delivery plan is in [ShipPartMode-Implementation.md](ShipPartMode-Implementation.md).

## The pitch

Repair the S.S. Dolphin while surviving a normal Risk of Rain 2 stage loop.
Start with a broken ship, find scattered parts, assign Pikmin to carry them to
the Onion, and watch the Dolphin rebuild itself. Deliver the thirtieth unique
part to win. The central choice is how long to search and haul before taking
the teleporter and letting the remaining parts appear on a later stage.

## Making the mode available

Add **Ship Repair** as a separate mode alongside Classic, Eclipse, and
Simulacrum, using the game's mode selection flow. Use normal difficulty selection
and normal stage progression as its foundation. The installed modern game exposes
`ContentPack.gameModePrefabs` and `Run.userPickable`; a fourth tile is the intended
UX. Registration, menu presentation, and network spawning still need an in-game
spike; the catalog alone does not prove the menu will add a tile automatically.

Suggested description: "The Dolphin is wrecked. Recover 30 unique ship parts
with your Pikmin to escape. Parts left behind can appear on later stages."

For v1, require every participating player to select Olimar. Disable Ready with
a clear explanation if a player has another survivor selected; do not silently
replace their choice. This gives every player the tools to recover the objective.
Mixed survivor co-op can follow after its delivery and disconnect rules are proven.

The selected mode is host-owned and visible to all lobby players. Lock its rules
when the run starts. The existing `Dolphin.ShipPartsMode` config is an unfinished
placeholder; it must not activate or disable this run type. Retire it with a
migration message when the mode ships. Classic, Eclipse, and Simulacrum continue
to use their normal objectives and repaired Dolphin presentation.

## Stage loop

1. The Dolphin lands, Olimar beams down, and the Onion releases the squad on
   **every normal stage**, showing the team's current repairs. The first arrival
   is a wreck with no recovered parts. A damaged ship can still make these short
   hops; all 30 parts are needed for the final escape.
2. Spawn up to **10 distinct uncollected parts** on reachable terrain. Finding a
   part reveals its name, carrier requirement, and a persistent team marker.
3. Throw or swarm Pikmin onto a part. Once it has enough carriers, they haul it
   to a landed Onion. Fight, gather items, and manage the squad as usual.
4. At the end of Onion suction, record the part, update `Parts recovered: N/30`,
   and play the Dolphin's fitting/repair animation. Collection gives no seeds,
   items, experience, or money in v1; it advances the objective.
5. Use the teleporter normally to reach another stage. Taking it is allowed with
   parts still on the map. Show `Leaving X unrecovered parts — they can return`.
6. On delivery 30, secure the win immediately, stop the repair clock, play the
   final repair and celebration, then show results. No final boss is required.

Use the existing starting squad and Onion economy for the first prototype. Tune
part carry requirements only after testing the real extracted weights against
the squad and RoR2 terrain. Never choose a required weight above the supported
squad carrying capacity; report incompatible tuning before a run starts.

## Which parts appear

There are **30 identities**, matching the native ship's part IDs. The run owns a
set of recovered IDs, not a counter that can be increased by duplicate parts.
At each eligible stage, sample without replacement from its uncollected set:

`stage parts = seeded sample(uncollected IDs, min(10, uncollected count))`

An ID appears at most once on a stage. An uncollected ID can appear again on any
later eligible stage. A recovered ID never spawns again. Delivery to any Onion
counts for the whole team; each player's Dolphin reflects the same recovered set.
Use a dedicated seeded random stream so placement does not consume the game's
normal chest or enemy random sequence.

Examples: recover 7 on stage one; stage two samples 10 of the remaining 23 and
may include the 3 left behind. Arrive with 26 recovered; spawn exactly the final
4. Three stages is the theoretical minimum at the default setting. Missing parts
extends the run through the ordinary loop without permanently losing progress.

Only normal combat stages with a working onward teleporter route are eligible.
Hidden realms and intermission scenes preserve progress and spawn no parts.
The mode must retain a looping route rather than require a terminal boss realm.
If a terminal or unsupported scene is reached through a portal, preserve progress
and provide a return to normal stages; block entry with an explanation where
that return cannot be implemented. Never let an alternate ending replace the
30-part objective. Scene eligibility and route handling are release requirements.

## Placement and hauling

Spawn parts independently of interactable credits, after ground and navigation
are ready. Spread them across the reachable stage, outside the arrival zone,
with space for their model and carrier ring. Validate a carryable route to a
safe Onion landing area, slope, clearance, and kill-plane distance. Do not place
parts behind a paid interaction, a survivor-specific jump, or an optional portal.

Placement uses bounded retries. If fewer than 10 safe sites exist, place fewer,
log the reason, and show the actual stage total. Never award missing parts for
free or block stage departure. A fall into a kill plane returns an undelivered
part to its last verified safe location and releases its carriers. A jammed route
gets a visible recovery prompt after a sustained timeout; recovery moves the part
to its last safe position and never increments progress or teleports it to an Onion.

The Onion remains movable with existing controls. A flying Onion cannot collect a
ship part automatically: land it to receive a carry team. Choose the nearest
reachable landed Onion when hauling begins. Pin that destination while the team
is travelling; if it takes off, dies, or disappears, put the part down safely and
release the carriers to rejoin. Players can land an Onion and reassign the haul.
This prevents a moving goal from towing a part across the map or bypassing carrying.
Ordinary corpse and pellet behavior remains unchanged.

At departure, only completed deliveries persist. Undelivered parts and carry jobs
are discarded with that stage; their IDs return to the sampling pool. Preserve
the mod's current squad/storage transfer rules in v1 and make clear that leaving
a part does not complete its haul. A delivery committed before the server closes
the stage counts; one arriving after that boundary does not.

## Repair feedback and arrival

Every delivery gets a short name/count toast and map-marker removal. Queue part
addition animations in server delivery order; simultaneous deliveries must not
overwrite each other. Keep ordinary play running while parts are fitted. Offer
a small optional ship view later if watching repairs proves hard from across the map.

Restore all recovered parts before a new stage's arrival animation starts. Do not
replay their collection sounds or fitting animations on stage entry, respawn, or
late join. The original ship has exterior and internal parts: **not every part
adds a visible attachment**. Use the original fittings, upgrade motions, lights,
and effects, with a toast for every delivery. Do not substitute an arbitrary
10/20/30 cosmetic progression for the disc's repair data.

The arrival animation and music have separate gates. Run the stage arrival for
each Olimar, once per stage. Keep the existing music sting restricted to each
machine's first local arrival on **stage one**, once per run. Repeated body spawns
on the same stage use a short re-entry and never restart the stage arrival or sting.
Verify the repeated-stage animation in the game; initial-body state registration
alone does not prove the game enters it after every stage transition.

## Victory, failure, and scoring

The server atomically accepts the final unique delivery and enters a winning
state. Stop objective interactions, stage departure, enemy spawning, and damage
so players cannot lose during the celebration. Finish queued repairs, play the
Olimar victory music, let the squad celebrate, and launch the completed Dolphin.
Target an approximately 8–12 second sequence with a hard timeout and a host skip.
Missing music or animation must still end in a successful results screen.

There are native happy jump and spin-jump motions worth auditioning for the
Pikmin celebration. Use real disc motions with staggered timing rather than
promise an unverified dance. The exact victory music clip still needs identification
and listening; ending-track names alone do not identify the desired song.

Team wipe is failure. Show parts recovered and elapsed time even on failure.
Ordinary deaths and revives preserve the recovered set. Disconnects do not reduce
progress or leave a part attached to a removed Onion. With no connected players,
end or tear down according to the normal session lifecycle; do not leave an
unattended repair run advancing. Leaving the run discards its progress; save/resume
is outside v1.

Keep the normal RoR2 run report and available score/stat fields. Add a mode summary:
outcome, parts recovered, **repair time**, stages visited, difficulty, seed, and
the rules used. Repair time starts at first-stage gameplay release after arrivals,
runs during subsequent arrivals and hidden-realm visits, follows the run's actual
pause semantics, and stops at final delivery or failure. It excludes loading and
the celebration. All first-stage players are released together, with a bounded
arrival timeout; joining later never resets or delays the clock.

For comparisons, completed runs rank above failures, then faster repair time wins;
failures rank by parts recovered, then shorter elapsed time. Display native score
alongside these metrics, and use it as a tie-break only where the game supplies a
meaningful comparable field. Do not invent a combined numeric score before
playtesting. Separate results by difficulty, player count, and rules so changing
parts-per-stage or enabling gameplay modifiers does not look like a standard run.

## First playable scope

Include mode/lobby selection, all-Olimar solo and friends co-op, normal stage loops,
seeded placement, Onion hauling, shared 30-part progress, repairs, repeated arrivals,
HUD, victory/failure, and results. Prototype with 10 parts per stage and a fixed
30-part goal; a developer override for spawn count marks the result as custom.

Defer mixed-survivor teams, achievements/unlocks, online leaderboards, save/resume,
new hazards, bespoke part powers, and new Pikmin economies. Artifact combinations
need a later compatibility pass; disable their selection in this mode's v1 lobby
and enforce that rule on the host. Keep the three standard difficulties available.

Playtesting must answer whether 10 recoveries per stage gives interesting routes,
whether native weights make early hauling too slow, whether moving the Onion
removes too much travel, and whether repairs are visible enough during combat.
The first prototype should record discovery, hauling, delivery, and stage-departure
times so these choices can be tuned from actual runs.
