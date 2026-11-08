> **Folder disappearing on launch?** BepInEx removes `BepInEx/plugins/RoR2BepInExPack` (case-insensitive) as obsolete. Rename it before launching, or restore the complete dependency package if already deleted, under `BepInEx/plugins/RiskofThunder-RoR2BepInExPack`. Include its supporting DLLs, including `Newtonsoft.Json.dll`. The native-runtime hotfix does not repair this folder. [Full repair instructions](https://github.com/wesjones15/ror2-characters/blob/modern/1.5.0/docs/FixStartup.md).

> Candidate 0.6.3 for modern/1.5.0. See [asset/session validation](Asset-session-validation.md); not yet played in RoR2.

# Olimar for Risk of Rain 2

Version 0.6.3 (modern). A survivor called **Olimar**: Pikmin's captain leading a squad of Pikmin
through Risk of Rain 2. He uses Commando's body and HUD but fights with Pikmin from
`pikmin.dll` (libpikmin, a reimplementation of Pikmin 1's mechanics), drawn and heard with the
disc's own models, animations and sounds. Commando's skills never fire.

**Offline and friends-only co-op only.** Do not run this online.

## Requirements and dependency mods

- Risk of Rain 2 **modern/1.5.0 (DLC4, Unity 2021.3.45f2)**, Windows x64.
- [BepInExPack by bbepis](https://old.thunderstore.io/package/bbepis/BepInExPack/), with BepInEx 5.4.21.0 and its supporting mods below. The character ZIP does not include or install these dependencies.
- Optional original presentation: your own **Pikmin** GameCube disc image (`.iso`, `.gcm` or `.ciso`). RVZ/WIA/WBFS must be converted to ISO first. No game data is included; stand-ins work without it.

Install the BepInExPack dependency set for the modern game:

| Dependency | Purpose |
| --- | --- |
| [BepInEx_GUI](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/BepInEx_GUI/) | Loader/logging interface. |
| [FixPluginTypesSerialization](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/FixPluginTypesSerialization/) | Unity serialization support for plugin types. |
| [RoR2BepInExPack](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/RoR2BepInExPack/) | RoR2 compatibility fixes; this release was checked with 1.46.0. |
| [SeekersPatcher](https://thunderstore.io/c/riskofrain2/p/pseudopulse/SeekersPatcher/) | Compatibility redirects for game updates. |
| [MiscFixes](https://thunderstore.io/c/riskofrain2/p/score/MiscFixes/) | Fixes for game bugs and mod compatibility. |

## Install

See [Install](Install.md): install `wesleyasaurus-Olimar` and its declared loader dependencies, then play.
Existing stand-ins and generic Ship Repair objectives work without game assets; missing arrivals use RoR2's drop pod.
Optionally add your own Pikmin disc in `BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/`. A Pikmin 2 disc
there as well adds Louie, Pikmin 2's enemies, the treasures and Candypop Buds; a Melee disc (USA, revision 1.02)
adds Captain Pikachu.

Install `OlimarTest.dll` and `pikmin.dll` together. Every participant needs the same build.

## First run

The plugin builds its asset cache from your disc in `SharedFiles/assets/pikmin/` (Pikmin 2's files in its `p2/`
folder): models, animations, tuning, sounds and effects, plus the Impact Site arrival clip. The cache is reused on
later launches without the disc. Captain Pikachu's files go to `SharedFiles/assets/melee/`, shared with the other
mods; the Pianta skin reads the Sunshine files the Mario mod extracts.
- Without the cache the sim runs on code defaults, which differ from the game's tuning, and
  the log says so. Olimar's model and the Pikmin fall back to simple shapes.
- Olimar's character select model and portrait appear once extraction has completed.

## Controls

Olimar uses the Pikmin control scheme: the Pikmin sim moves him, as in Pikmin. VR is not supported in
this release (see Known limitations).

The input layout follows the last device you used: a **gamepad**
(read by button position, so your RoR2 binds don't matter) or **keyboard and mouse** (RoR2's
binds). `Controls.CameraMode` then picks the camera: **Orbit** (default) or **Vanilla**.

### Gamepad

Read by position through Rewired's gamepad template, regardless of your RoR2 binds.

| Button | Does |
| --- | --- |
| Left stick | walk; click it while riding the Onion to boost |
| A | throw a Pikmin or pluck a sprout; in the landed Onion beam, send the Onion plucker |
| B | jump. In an Onion's beam B still jumps; LT boards instead |
| RT (held) + B | whistle. RT is a modifier: holding it stops B jumping, and letting go of RT with B still held doesn't jump |
| RT (held) | the alternate-command modifier: RT + B whistle, RT + right stick swarm, RT + X dump a flying Onion, RT + Y fill it, RT + RB call the Onion over to heal |
| RT (held) + RB | call the Onion over to heal him from its stored Pikmin; it stays low over him while the heal plays. This takes the strike's place on the chord |
| X | hold 0.6 s to raise or lower the Onion (free, and no double-tap any more); in the landed beam, dump stock except one. RoR2 interact prompts take priority. |
| RB | dismiss strike: a melee blow all around Olimar (4 s cooldown). While LT holds a lock, RB cycles targets instead |
| D-pad left / right | choose the colour to throw: Any (nearest), Red, Yellow, Blue (colours not in the squad are skipped) |
| LB | recentre the camera behind Olimar; in the landed Onion beam, whistle back Pikmin stuck on objects with too few carriers |
| LT | lock onto an enemy (LT + A throws rapidly at it); in an Onion's beam, board it (Onion Ride) |
| RT (held) + tap LT | call the Onion to you from anywhere and board it; the same again calls it off. The tap must be fresh: if LT is already down for a lock when RT goes down, it doesn't fire |
| Right stick | pan the camera (Orbit). Up and down tilt it; see `Controls.LookUpDegrees`. With RT held it swarms instead |
| Right stick click | zoom, three levels |
| Y | RoR2's equipment, as usual |
| RoR2's sprint bind | sprint until movement stops |

#### Landed Onion beam (gamepad)

The shortcut panel appears while Olimar stands in the beam. It shows the controller glyphs:
**X** dumps stored Pikmin except one, **Y** stores the squad, **RB** sacrifices stored
Pikmin to heal Olimar, **LB** whistles back carriers stuck on understaffed objects,
**A** sends an Onion plucker for a ready sprout, and **LT** boards the Onion
(Onion Ride, below). Walk out of the beam to dismiss it. Outside the beam, X still
raises or lowers the Onion.

#### Vanilla camera mode

With `Controls.CameraMode = Vanilla` the fixed Pikmin-style camera is used, and the right stick
swarms directly (no RT needed) and RB strikes. LB still recentres and
right stick click still zooms. B jumps and RT + B whistles in both camera modes; there is no top-down view any more.

### Keyboard and mouse

RoR2's binds stand in, by action:

| RoR2 action | Does |
| --- | --- |
| Move | walk |
| Primary skill | throw or pluck; in the landed Onion beam, send the Onion plucker |
| Secondary skill | jump |
| Jump (held) + Secondary | whistle. The jump key is the modifier, so it doesn't jump |
| Jump (tap) | recentre the camera; in an Onion's beam, board it (Onion Ride) |
| Utility skill | hold 0.6 s to lower or raise the Onion (when no interact prompt is up) |
| Special skill (held) | swarm toward the cursor |
| F | dismiss strike |
| V | dump a flying Onion's Pikmin |
| B | fill a flying Onion with the squad |
| Z | call the Onion to you from anywhere and board it; again to call it off |
| Mouse wheel | next throw colour |
| C | zoom |
| G | recall understaffed carriers while standing in the landed Onion beam |
| Sprint | sprint until movement stops; press it while riding the Onion to boost |
| Interact | RoR2's interact; the Onion shortcuts appear automatically in its landed beam |

Keyboard and mouse has no right-stick camera; the camera recentres with a jump tap. Aim
mode (for VR) keeps RoR2's own binds.

### Related settings

| Setting | Default | Effect |
| --- | --- | --- |
| `Controls.Scheme` | Auto | leave it on Auto, or set Pikmin (the only supported scheme) |
| `Controls.CameraMode` | Orbit | Orbit or Vanilla camera |
| `Controls.ThrowReach` | 2 | throw distance as a multiple of Pikmin's own reach |
| `Controls.LookUpDegrees` | 70 | how far the Orbit camera tilts up |
| `Controls.LockRange` | 40 | lock-on reach in metres |
| `Combat.CursorHoming` | on | thrown Pikmin are steered onto the cursor |
| `Items.RideRecharge` | 30 | seconds before Onion Ride's one charge comes back |
| `Combat.StrikeChargeSeconds` | 1 | seconds the squad swarms after a dismiss strike; walking ends it |
| `Enemies.FlintBeetleShipChance` | 50 | percent chance of a Flint Beetle in a Ship Repair stage, per player |
| `Enemies.FlintBeetleOtherChance` | 12 | percent chance elsewhere, per living Olimar |
| `Look.ItemDisplays` | off | draw RoR2's cosmetic item displays on Olimar's drawn body |

### Notes

- A tap between two sim ticks still registers: held buttons are latched until the 30 Hz sim has
  run a tick.
- X is also RoR2's interact button. A press made while an interact prompt is on screen (leaving
  the drop pod, opening a chest) goes only to RoR2 and doesn't also move the Onion.
- The HUD's skill icons show the pad buttons above. The Onion Pluckers are Olimar's passive and
  have no HUD icon.

### Not supported yet

- Rebinding Olimar's buttons. The gamepad layout is fixed by position.

## Playing Olimar

You start each run with 10 Red, 5 Yellow and 5 Blue Pikmin (configurable). The S.S. Dolphin
lands behind you, Olimar beams in and the squad comes out of the Onion's legs. The Onion then
lifts off and follows you.

### What things do

- **Throwing**: throws reach twice as far as in Pikmin (`Controls.ThrowReach`), and thrown
  Pikmin are steered onto the cursor. With a lock-on they end their throw latched onto the
  enemy.
- **Lock-on**: hold LT to lock onto an enemy within 40 m with a clear line; RB cycles targets.
  The cursor stands in front of the enemy, facing Olimar.
- **Fighting**: RoR2's enemies are creatures to the sim, with their hurtboxes as the parts
  Pikmin latch onto. Pikmin hits are RoR2 damage from Olimar, so his damage stat, crits and
  on-hit items apply. Move-speed items speed him up.
- **Dismiss strike**: RoR2 has no captain puzzles, so RB hits every enemy around Olimar for
  four times his punch, staggers them, and sends the squad swarming that way for one
  second (walking cancels it). A kill refunds its cooldown. Set `Combat.StrikeDamage` to 0 for Pikmin 1's
  dismissal instead.
- **Getting hurt**: an enemy hit also hurts the Pikmin near where it landed. Pikmin health is a
  share of Olimar's max health. Pikmin that fall off the map are not lost: like Olimar they are put back beside
  their captain unharmed (a carrier or a latched Pikmin lets go first). When an enemy starts
  an attack, latched Pikmin are shaken off (those latched for under 2 s hold on).
- **Corpses**: a dead enemy leaves a 1, 5, 10 or 20 pellet by size, in a random colour. Pikmin
  carry it to the Onion, which turns it into seeds. Sprouts grow from leaf to bud to flower
  and are plucked with A. Pikmin also grow a stage per two kills. Flowers wilt after five
  minutes. Pikmin collect nearby drops automatically.
- **The Onion**: one Onion holds all three colours. Stand in its landed beam for direct
  stock, heal, recall and plucker shortcuts. Outside the beam, holding X for 0.6 s raises or lowers it.
  It also sends a Pikmin to pluck planted sprouts automatically after a while.
- **Healing**: living Pikmin assigned to Olimar regenerate from his current percentage
  health regeneration, scaled by `Items.MinionHealScale` (default 0.5). Healing wards
  such as Bustling Fungus also heal nearby Pikmin. Directly healing Olimar does not
  automatically heal his squad; unassigned Pikmin do not receive his passive regeneration.
- **Stages**: the squad and the Onion's stock come along to the next stage.
- **Size**: Olimar is two thirds of Commando's height (`Scale.OlimarHeight`), and everything
  scales with him.
- **Falls**: landing damage uses RoR2's own fall rules (`Items.FallDamage`).
- **Flying enemies**: Pikmin hanging on a flier weigh it down to the ground: 5 for a small one, 15 for a large one,
  25 for a boss (a Purple counts as five). `Pikmin.WeighDownFliers` turns it off.

### Purple and White Pikmin, and Candypop Buds

With a Pikmin 2 disc (see First run), every map has **Candypop Buds** on it (14 a stage in Ship Repair, 3 in other
modes): flowers in the five Pikmin colours, plus the odd rainbow Candypop Pop. Throw Pikmin into a bud; every 5 that
go in, it closes and spits 5 Pikmin of its own colour back out. They land beside it, already yours, ready to whistle.
A bud takes 25 Pikmin before it withers (`Candypop.SlotsPerBulb`; a Pikmin of the bud's own colour doesn't use one
up). The rainbow Pop gives 5 Pikmin for every 1, in whichever colour it is showing. Buds can be locked onto with LT,
like enemies.

- **Purple Pikmin** are heavy: a thrown Purple pounds where it lands, hurting what it hits and knocking flying
  enemies down. It carries as much as ten others, and takes 30% less hit damage.
- **White Pikmin** are fast and poisonous: their hit applies RoR2's poison, and another White hit extends the poison
  instead of multiplying its tick damage.
- **Red Pikmin** are immune to fire: fire blasts from RoR2 enemies and fire trails such as elite trails and Fiery
  Bulborb breath do nothing to them.
- **Yellow Pikmin** hit airborne and Mechanical enemies for 1.5x.
- **Blue Pikmin** take 40% less damage while standing in stage water, and one thrown out of water keeps a 1.5x hit
  bonus for 5 s.

### Squad survivability

An enemy melee swing catches at most the two Pikmin nearest the swing (four for champions and elites), each for
twice the swing's damage; a Pikmin that lands a hit is immune to other swipes for 0.3 s. Pikmin regenerate 4% of
their max health a second, 12% a second after 6 s without one hurt, plus a share of Olimar's regeneration
(Cautious Slug, Titanic Knurl, level), doubled by Rejuvenation Rack.

Every skin's Onion stores all five colours, and Louie's squad starts with Purples and Whites.

### Onion Ride

The Utility slot is **Onion Ride**, Olimar's escape and repositioning tool. Stand in the beam
of a live Onion (landed or hovering) and press **LT** to board, or hold **RT** and tap **LT**
from anywhere: the Onion flies to you the way a raised Onion does, comes down, and boards you.
It spends a charge; the 30 s cooldown (`Items.RideRecharge`; cooldown items and Hardlight's
extra charges apply) starts when the ride ends. Olimar lifts into the Onion with Pikmin 1's
bad-ending motion, the Onion takes off if it was landed, and his squad goes in through its legs.

- **Steering**: left stick, at twice his walking speed; clicking the stick boosts to three
  times for 2 s. The right stick is the camera. Nothing else works while riding.
- **Height**: the Onion keeps the ground-relative height it flies at when following him, held
  over pits, and hovers low while Pikmin are still climbing aboard.
- **Clock**: up to 5 s of grace (ends early if the Onion goes more than 10 m from where he
  boarded), then 10 s. Neither pauses or resets.
- **Ending**: A, B, X or Y, the clock, or the Onion's death. Olimar drops out of the beam and
  the Pikmin that went aboard during the ride come out together, a third down each leg; the
  Onion's reserve stays put and Pikmin still climbing drop back to the field.
- **Danger**: the Onion is a normal target and takes the damage; Olimar is not hurt while
  aboard. If he is dropped over a pit, fall recovery returns him to the last ground the ride
  crossed, with his squad.

Raising and lowering the Onion (hold X 0.6 s) is separate, free, and never touches the ride's
charges.

### Skins

Olimar has three alt-skins, picked in the loadout's skin row. Each unlocks once on your profile, at any difficulty:

- **Pianta**: Super Mario Sunshine's Pianta, from the Mario mod's Sunshine cache. Unlocks after stage 1's teleporter
  event as Olimar.
- **Captain Pikachu**: Melee's Pikachu, with Ice Climbers as his Pikmin. Offered with the Melee mod installed; Melee USA 1.02 art is optional.
  Unlocks after stage 2's teleporter event as Olimar.
- **Louie**: from Pikmin 2. Original Louie/Hocotate art is optional. His Purple/White starting squad follows the negotiated P2 gameplay pack.
  Unlocks by recovering all 30 ship parts in one Ship Repair run.

Skin entries follow the installed mods: Pianta needs Mario, Captain Pikachu needs
Melee, and Louie needs only Olimar. Missing local art shows Olimar's available base
model or a generic captain. Alternate captain art can lead a stand-in army without
Pikmin 1 assets. Overview notes identify missing local presentation.

Pikmin 2 bonus gameplay (starting colors, Onion acceptance, buds, P2 enemies and
treasures) requires complete P2 runtime data on every lobby player, independently
of P1 art. The lobby explains when it is disabled. The set locks at run launch;
incompatible late joins receive an explanation and disconnect to wait for a
compatible new run. Solo uses local data. See [optional assets](Optional-assets.md).

Stand-in enemies remain visible when art is missing. The flying stand-in Onion
hides its legs; the generic captain rises into the pod, hides and reappears on drop.

## Ship Repair mode (preview)

Select **Ship Repair** in the solo extra-mode menu or the multiplayer host's mode picker.
Everyone must choose Olimar or Mario (Mario needs `MarioTest.dll` from the same release and carries parts by
hand: see the Mario guide). Turn artifacts off. Generic carry definitions support all 30 parts without disc assets.

Start with a wrecked Dolphin and race to recover **30 unique parts for your own ship**.
The host's config controls the rule, locked at run start:

```ini
[ShipRepair]
CompetitiveMode = true
EnemyPartIntervalSeconds = 30
StageMusic = true
AdaptiveStageMusic = true
StageMusicVolume = 1
```

Set `CompetitiveMode = false` for shared cooperative progress. Competitive is the default.

The Dolphin cannot fly to the teleporter until its Main Engine is fitted; until then the engine lies near every
player when a stage opens (one for the crew when shared). **Pikmin enemies** join the stage's monsters: the Pikmin 1 enemies
(Bulborbs and Bulbears, Wollywogs, the Cannon Beetle, Blowhogs, the Snitchbug, Sheargrubs, the Wogpole, Puffstool, the
Mamuta, Smoky Progg and Giant Eggs, the Water Dumple, Honeywisps, a Breadbug, Fire Geysers, Pellet Posies and a Pearly
Clamclamp), drawn from your disc and running the original game's own enemy states in a RoR2 body. With a Pikmin 2
disc, Pikmin 2's enemies join them: Bulborb Larvae, Orange, Hairy, Dwarf Orange and Snow Bulborbs, the Fiery Bulblax,
Skitter Leaves, Mitites, the Watery Blowhog, the Cannon Beetle Larva, Hermit Crawmads, Spectralids, Snagrets,
Bloysters, Bomb-rocks and gas pipes, the loot-dropping Flint and Glint Beetles and Doodlebug, and bosses: the
Empress and Emperor Bulblax, the Giant Breadbug, the Segmented Crawbster and the three Long Legs. **Pikmin 2
treasures** are scattered over each stage as bonus objectives: carry them to your Dolphin like a part for a
separate treasure score (worth less than a part each). Their corpses become
pellets your Pikmin can carry, a big one always drops a part for whoever killed it, and the Breadbug of the first stage and each
Clamclamp's pearl are parts too. The `[Enemies]` config section sets `Enabled`, a `Weight` and `Cost` for each kind,
`BigMinStagesCleared`, `HealthScale`, `SpeedScale`, `DamageScale`, `CorpseCarrierScale`, `FitSizes` and how many Honeywisps,
water enemies and Pellet Posies come per player and Fire Geysers per stage. See the changelog; none of the enemies has been
played in game yet. Olimar leads the character select, and winning Ship Repair as him unlocks Mario, who is locked only while Ship Repair is the selected mode.
Each normal stage offers up to two shared map pickups, one guaranteed stage-boss part, and
seven other powerful-enemy drops per participating player. That's 10 initial opportunities
solo and 31 with four players. Cooperative mode uses seven enemy drops for the team.
After the non-stage-boss quota is exhausted, powerful enemies have a 20% bonus-drop chance.
There is no lifetime stage cap: stay and farm at the cost of rising difficulty, or teleport.
Undropped guaranteed parts become physical wreckage when the teleporter finishes. Fewer
parts are needed near completion, so the initial supply can shrink.

Ordinary enemy drops have an independent cooldown for each player: 30 seconds between
successful drops by default. Another player's kill/drop never starts your timer. The first
eligible kill can drop immediately, and stage-boss rewards bypass this timer. Kills during
cooldown do not consume supply or queue later rewards. Your Pikmin/minion kills count as yours.
New drops stay at least 25 metres from loose parts; a crowded kill spot uses a clear safe
site elsewhere. Recycled salvage and fallback wreckage also wait for a clear site.

Assign enough Pikmin to haul each new part to **your landed Dolphin**. The carrying majority
determines the destination; an opponent's nearer ship does not receive your haul. Parts use
their disc weights (10ÃƒÂ¢Ã¢â€šÂ¬Ã¢â‚¬Å“50 carriers). The original fitting animations, repair states, lights,
particles and sounds show your repairs. Internal parts do not add an exterior attachment.

Already have that part? Your Pikmin take it to **your landed Onion** for twice its weight in
seeds (20ÃƒÂ¢Ã¢â€šÂ¬Ã¢â‚¬Å“100), split across the three colours. Salvage does not advance the 30-part goal.
Ship parts are excluded from all automatic Onion pickup targeting and ground vacuum.
Only a Pikmin carry team deliberately targeting that Onion can hand a part into it;
following Onions cannot take loose parts or intercept Dolphin-bound teams.
If an active rival still needs it, the part returns to its original map site after at least five
seconds. Its marker says `Onion salvage` for players who have fitted it. Ordinary pellets
also continue feeding the Onion. In cooperative mode, recovered identities stop spawning.

Leaving parts behind is allowed; their IDs can return on later stages. In a race, an identity
remains eligible while any active racer needs it. Discovery shows a name/weight marker. A sustained hauling jam offers a recovery
button that puts the part back on safe ground without awarding progress.

Arrival plays every stage. After dropping off Olimar, Onion and squad, the Dolphin flies
near the teleporter and stays there for deliveries. Multiplayer docks are at least 14 metres
apart, with terrain, clearance and intake-route checks. If no safe dock is found, it stays
at the arrival site. Same-stage respawns preserve the dock.

Ship Repair loops Impact Site music on stage one and seeded random Pikmin stage songs
later. Nearby RoR2 enemies activate the original Pikmin musical layers. Teleporter boss
fights retain RoR2 music, then the Pikmin song resumes. The three music settings above
are local: disable `AdaptiveStageMusic` for steady exploration music, adjust
`StageMusicVolume` alongside RoR2's master/music volume, or disable `StageMusic` to keep
RoR2 music and the first-stage-only arrival sting. Missing music assets/output retain RoR2 music.

The first racer's thirtieth
unique delivery secures victory, freezes repair time, plays the original complete-ending music
and celebration, then launches the winning Dolphin and opens the normal RoR2 report. The host can skip the celebration.
Repair time, count, stages, seed and difficulty appear alongside the report; a detailed summary
is saved in `BepInEx/config/OlimarShipRepairReports`. There is no combined numeric score yet.

HUD and results show each racer's unique-part count, salvage count and winner. With competitive
mode off, players cooperate to repair all Dolphins. Pikmin enemies, mixed survivors,
save/resume and online leaderboards are deferred.
The old `Dolphin.ShipPartsMode` config is ignored; select the actual mode instead.

## Configuration

`BepInEx/config/com.libpikmin.olimartest.cfg`. Main sections: `Controls.*`, `Combat.*`,
`Pikmin.*`, `Growth.*`, `Corpses.*`, `Scale.*`, `Items.*`, `Dolphin.*`, `Sound.*`,
`SpawnMusic.*`, `ShipRepair.*`, `Look.*` and `Debug.*`. Each entry has a description in the file.
`Corpses.CarryBodies` is experimental and off.

## Troubleshooting

Check `BepInEx/LogOutput.log`. A healthy start shows `libpikmin ABI 65`, `Olimar registered`,
and in a run `Pikmin sim started (disc ...)`, `Pikmin models: 19 models` and `captain 0 is ...`.

- *No assets / default tuning*: normal built-in operation. Optionally add your own Pikmin disc in `wesleyasaurus-SharedFiles/put_games_here/` and restart for original presentation/tuning.
- *ABI mismatch error*: you have mixed DLLs from different releases. Reinstall both from one ZIP.
- *Wrong game version*: only DLC4 (2026) is supported.

## Known limitations

- **VR is not supported** in this release. If you have VRMod installed, set `Controls.Scheme` to `Pikmin`, because Auto would switch to unfinished VR controls when it is running in VR.
- **Multiplayer** (new, not yet tested with two players): the host runs the Pikmin and sends them
  to everyone else, who see and hear them and Olimar himself. A client's Olimar moves on their own
  machine, so he doesn't lag, and the host's captain follows. Every player needs the same version of
  the plugin and the disc assets.
- Olimar's footsteps and voice are missing.
- Enemies don't target Pikmin directly; attacks shake latched Pikmin off.
- Hazards (fire, water, electricity) are not implemented, so colours differ only in attack and
  carrying.
- Attack-speed items don't change how fast Pikmin swing.
- Ship Repair uses ground navigation for carrying. Other modes retain straight paths, so corpses can snag on walls between them and the Onion.
- The Onion shortcuts do not pause the game. Multiplayer commands are checked by the host.
- Ship Repair is a feature preview: mode menus, terrain placement, portals, full victory and two-player synchronization still need in-game playtesting. Other modes use a repaired Dolphin.

## Legal

This is an unofficial fan project, not affiliated with Nintendo, Hopoo Games or Gearbox. The
package contains no game assets. All models, animations and audio are extracted on your machine
from a disc you own, and are never uploaded or redistributed. Do not share your extracted
`assets/` folder.

## Shared native audio

Both characters read BepInEx/config/Ror2Common.Audio.cfg, Output.GainDb, default -4 dB.
Restart after editing. Master and SFX/music settings also apply. No additional tone filter is enabled.

The full vanilla sundown bell plays on death and continues through the results screen.
It is generated in memory from your own disc, uses SFX volume, and stops when you leave the run.


## Portrait cache hotfix

Character-select names and character-containing skill pictures follow the selected skin; the HUD cooldown slots use the same pictures for that body. Onion Ride and the sprout passive keep shared artwork. Generated character, skin and skill pictures persist in the local asset cache between launches.

The first launch can hitch while missing pictures generate. Missing or invalid images regenerate individually; ordinary gameplay releases reuse the cache. This hotfix is build/boundary tested and has not yet been played in RoR2.

## Frozen and Pikmin 2 body hotfix

A frozen Olimar, and every skin, now show the same icy sheen as a frozen Pikmin. Purple and White Pikmin load their Pikmin 2 bodies from the shared P2 asset folder even without Louie's cache, and an Onion takes all five colours whenever those bodies load. The Iridescent Flint Beetle and Pellet Posy are drawn at the strategy's position instead of bobbing with the borrowed body.
