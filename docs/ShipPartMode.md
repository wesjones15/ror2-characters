# Ship Repair mode — rules and design

Implemented as the 0.3.4 feature preview on `feature/ship-part-mode`, based on
`modern/1.5.0` and retaining the 0.2.3 hotfix. Automated validation passes;
in-game playtesting is pending. See [current status](ShipPartMode-Status.md),
[baseline research](ShipPartMode-Research.md) and the historical
[implementation plan](ShipPartMode-Implementation.md). Tuning remains provisional.

## Objective and mode selection

Repair the S.S. Dolphin while surviving the normal RoR2 stage loop. Start with a
wreck, find parts, fight for drops and assign Pikmin to haul them home. The first
player to fit all thirty unique identities wins. No Mithrix fight is required.

Select **Ship Repair** in the solo extra-mode menu or multiplayer mode picker.
All participating players choose Olimar; artifacts are off. The host controls
`[ShipRepair] CompetitiveMode`, default **true**, locked when the run starts.
False switches to shared cooperative repair. The old `Dolphin.ShipPartsMode`
placeholder is ignored. Classic, Eclipse and Simulacrum keep normal objectives
and their repaired Dolphin presentation.

## Competitive progress and hauling

Each player owns a thirty-bit recovered set and ordered delivery journal across
stages. Delivering a new identity repairs only that player's Dolphin. A part may
already be fitted by one racer and still be needed by another. Parts are physical,
shared and contestable; whoever killed the enemy does not automatically own its
drop. The carrying majority's captain determines the destination; ties keep the
first carrier's captain. A nearer opponent's Dolphin never steals delivery credit.

The sim routes new parts to that captain's landed Dolphin. Whistling and existing
multi-captain recruitment can change a carrier team and its destination. If the
receiver becomes unavailable, put the part down and release the carriers. The
server validates the current stage epoch, physical pellet, part and receiver
before accepting a delivery. Duplicate or stale receipts cannot advance progress.

If your Dolphin already has the part, your Pikmin haul it to **your landed Onion**.
The Onion ingests it with the normal suction/emission effects and pays **twice
the part's carrier weight in seeds**: 20–100, split over the three colours. Salvage
is tracked separately and never counts toward thirty. If an active rival still
needs the identity, the physical part returns to its original validated map site
after at least five seconds, once that site is clear. This intentionally allows repeated interception and salvage.
The marker identifies duplicates as `Onion salvage`. A flying Onion must land
before it can receive these parts; automatic loose-pellet vacuum shortcuts do not
collect ship parts.
Both the host's following/pickup target selection and the native ground-vacuum
API reject ship parts in every state. Only native carry AI handing over a part
to the team's selected Onion can start salvage ingestion; a passing Onion cannot
intercept loose parts or a team delivering to the Dolphin.

With competitive false, every accepted new identity fits all Dolphins and counts
toward a single team set. Already recovered IDs stop spawning in cooperative mode.
There is no duplicate salvage in that ruleset.

## Stage supply and soft cap

Initial supply per eligible normal stage:

| Source | Competitive | Cooperative |
| --- | --- | --- |
| Shared map pickups | 2 | 2 |
| Stage-boss reward | 1 across the boss group | 1 across the boss group |
| Other powerful-enemy rewards | 7 × participating players | 7 for the team |

That gives ten initial opportunities solo, seventeen with two racers and thirty-one
with four. Near completion, remaining demand can shrink this supply. IDs are chosen
from active racers' missing sets with a dedicated seeded stream; copies can repeat
when multiple racers need an identity. No new drop is chosen solely for identities
every active player has already recovered.

The first qualifying stage-boss death releases its reserved part; multiple members
do not multiply that reward. Other champions/minibosses, enemies with base health
at least 600, and elites with base health at least 200 release one reserved part
per death. Stage bosses never consume the separately scaled ordinary enemy quota.

Ordinary drops have a **30-second independent cooldown per player**, configurable
through `[ShipRepair] EnemyPartIntervalSeconds` and locked at run start. Pikmin and
minion kills resolve to their owning player. The first eligible kill can drop
immediately; another player's drop never starts this player's timer. Kills during
cooldown consume no quota and are not queued. The guaranteed stage-boss reward
bypasses this timer. Successful physical placement starts the killer's cooldown.

After the ordinary quota, each qualifying non-stage-boss death has a **20% bonus
part chance**. There is no lifetime cap on parts from a stage. Players can stay
and farm or leave; increasing difficulty supplies the pressure. Consumed tracking
slots are reused for further drops; a technical limit of 451 simultaneous records
keeps objective packets bounded. This is not a total-earned cap.

If an eligible death cannot place its part safely, use its validated safe site.
Any undropped guaranteed rewards become physical wreckage when the teleporter
charges, covering missing/unusable combat callbacks. This fallback still requires
a haul. Normal stage routes loop; Bazaar and Void Fields preserve progress without
parts. Unsupported terminal destinations redirect to an eligible first-tier stage.

## Placement, recovery and departure

After drop-off, the Dolphin leaves Olimar, his Onion and squad at their spawn
and flies to a dock near the teleporter. It stays there for deliveries. Dock
selection checks floor slope, hull clearance and a no-jump route to its actual
intake. Multiplayer docks reserve at least 14 metres of horizontal separation.
If no valid dock is found, the Dolphin retains its safe arrival site. Same-stage
respawns keep the existing dock and fitted parts.

Wait for all Dolphin relocations to finish and navigation to be ready. Spread initial sites
outside arrival, check ground/slope/clearance and a carryable route to an actual
Dolphin intake goal. Do not consume chest/interactable RNG or credits. Placement
retries are bounded and spread over frames; fewer safe sites means fewer initial
parts, with a logged explanation rather than free progress.

Keep at least **25 metres of horizontal separation** from undelivered physical
parts. Enemy deaths in a crowded kill zone use a clear validated site elsewhere;
if none is available, no drop or cooldown is consumed. Fallback wreckage and
recycled salvage also wait for clear sites. This prevents localized piles without
coupling the players' drop timers.

Discovery shows the part's name, disc carrier weight and marker. Native weights
are 10–50; players must grow their squad through the existing Onion economy.
A sustained hauling jam offers a recovery prompt; a void fall returns the part
to safe ground. Recovery releases carriers and never grants progress.

Departure is allowed with unfinished parts. Only completed recoveries persist;
remaining identities stay eligible on later stages. Accept receipts before the
server closes the stage, reject them after it. Ordinary corpse and pellet rewards
continue feeding the Onion.

## Original repair feedback and arrival

Use the user's extracted thirty part models and original carry/fitting bundles,
Dolphin wreck/root poses, repair motions, lights, SFX and particles. There are
five exterior shape-changing parts, eleven other attachments and fourteen internal
parts; an internal recovery does not add an invented exterior model.

Queue fittings in delivery order, keep combat running and show a toast per recovery.
Restore personal parts silently before each new stage's arrival. Stage entry,
respawn and late join must not replay old collection sounds or repair animations.
Arrival plays once per player per stage. Same-stage respawns use short re-entry.

With local `[ShipRepair] StageMusic = true` (default), the full Impact Site song
loops on stage one. Later stages choose from the five original Pikmin stage songs
using the run seed, without consecutive repeats; late joiners select the same
song. Teleporter boss fights retain RoR2 music and pause the Pikmin song, which
resumes afterward. Hidden realms retain RoR2 music. Victory uses the existing
complete-ending farewell stream.

`AdaptiveStageMusic = true` activates Pikmin's original enemy-proximity layers
when a living RoR2 monster is within 30 metres of the local player, held for two
seconds after contact. `StageMusicVolume = 1` multiplies RoR2's master/music gain
independently of Pikmin SFX. Pause freezes playback. Missing music assets or output
leave RoR2 music active. With stage music disabled, the original first-stage-only
arrival sting remains available; other modes retain their existing soundtrack.

## Victory, failure and reporting

The server atomically accepts the first thirtieth unique recovery and secures the
race. Freeze repair time and stop departure, enemy spawning and damage. Finish
queued repairs, play the extracted complete-ending farewell music, celebrate with
original `RotJump`/`WaveJmp` motions and launch the winning Dolphin. Cooperative
victory launches all Dolphins. Normally this takes twelve seconds; pending fitting
queues can extend it, with a bounded fallback and host skip. Missing presentation
must not prevent successful results.

Keep RoR2's normal run report and add winner, standings, unique-part/salvage counts,
repair time, stages, seed and difficulty. Save detailed rules and journals in
`BepInEx/config/OlimarShipRepairReports`. No combined numeric score is defined yet.

Time starts when first-stage arrivals release gameplay, counts subsequent arrivals
and hidden-realm play, follows pause semantics, and excludes loading/celebration.
It freezes at the winning delivery or team wipe. Death/respawn retains progress;
leaving the run discards it. The first prototype needs manual host/client, late
join, disconnect, simultaneous delivery, terrain, routing and sound-balance tests.

Pikmin enemies, mixed-survivor teams, artifacts, online leaderboards, save/resume,
new hazards and bespoke part powers remain deferred.
