# Olimar changelog

Modern releases target the modern/1.5.0 game branch (DLC4, Unity 2021.3.45f2), BepInEx 5.4.21.0 and RoR2BepInExPack 1.46.0. Native ABI 46 from 0.4.0; ABI 44 from 0.3.15; ABI 41 in 0.3.14; ABI 39 in 0.3.13; ABI 37 in 0.3.8 to 0.3.11; ABI 35 from 0.3.5; ABI 33 in 0.3.4; ABI 32 in 0.3.3; ABI 31 in 0.3.1–0.3.2; ABI 30 in 0.3.0; ABI 29 through 0.2.3.

Each entry lists only what changed since the previous published version. Everyone in a multiplayer game needs the same Olimar build.

## 0.4.1 - 2026-10-25

Nothing changes for Olimar in this release: no gameplay, balance or control changes, and no new options. The build is rebuilt from the same sources with the shared library that Mario and Melee changed, and the version moves so each mod in the pack carries its own number. Install both DLLs with the other mods' 0.4.x builds.

## 0.4.0 - 2026-10-24

- **Less network traffic with large squads.** Pikmin snapshots are smaller, targeting the heavy update traffic when a squad grows past 100 Pikmin. Multiplayer performance still needs an in-game check.
- **Lock onto the job at hand.** Aim at pellets, corpses and ship parts as well as enemies. The free cursor follows the camera and can aim much closer to Olimar.
- **A more useful Onion.** The hovering Onion offers its beam menu, and arrival placement gives it more room beside Olimar and the Dolphin.
- **A clearer Ship Repair field.** Parts show their in-game names; once Pikmin carry a part, its carrier count gets the space. Pikmin and carried parts route around the landed Dolphin, and carriers animate at their carrying pace.
- **More deliberate squad attacks.** Dismiss strikes send Pikmin jumping onto enemies ahead, and attached Pikmin stay closer to the enemy's visible body.
- Corpses come from Olimar, Pikmin and allied minion kills by default; their pellet color follows the Pikmin that made the kill.
- **New skill portraits and clearer controls.** Pluck, Throw, Whistle, Onion and Strike have cached native-model portraits. Sprouts sit properly in the soil, Onion flight sparkles are closer to the source, and Olimar keeps his own fallen pose at game over.

Install both DLLs for this mod from this release. New gameplay changes have headless checks; in-game validation remains pending.

## 0.3.17 - 2026-10-22

Install both DLLs (`OlimarTest.dll`, `pikmin.dll`; native ABI 44, unchanged). 0.3.16 was never published; its change is here.

- **Pikmin that fall off the map come back instead of dying.** Until now a Pikmin more than 60 m below Olimar was killed.
  Now, like Olimar, it is put back beside its captain unharmed. That covers Pikmin carrying a load, latched to an
  enemy, flattened, swallowed, drinking or blooming when they go over the edge: they let go of what they were doing
  first. A Pikmin standing about, following or knocked about also comes back from more than 40 m below onto lower
  ground, the same distance as Olimar's own "fell too long" rescue. Pikmin in Olimar's hand or climbing an Onion are not
  affected.
- **Character select order:** Olimar is first in Ship Repair, and Mario is first in every other mode.

Headless checks pass. Neither change was played in game before release.

## 0.3.15 - 2026-10-21

Every Pikmin 1 enemy in Ship Repair, and Olimar leads the character select. Install both DLLs (`OlimarTest.dll`,
`pikmin.dll`; native ABI 44, Pikmin protocol 5 and repair protocol 5). Everyone in a multiplayer game needs this build.

- **Olimar leads the survivor list, and winning Ship Repair as Olimar unlocks Mario** (the Mario 0.3.8 plugin registers the
  unlock; "Mario unlocked." appears in chat).
- **Pikmin enemies run their own AI.** The enemy strategies are ported from Pikmin's own code (`libpikmin-teki`) and drive
  RoR2 bodies: they keep the borrowed monster's health and hurt boxes, so Pikmin latch on, Mario can stomp them and items
  work, but they walk, jump, fly, attack and die the way the original states do. Your disc's models, animations, sounds and
  particle effects are drawn on them, sized to the disc's, with death smoke and souls.
- **Every Pikmin 1 enemy with usable disc files is in:** Dwarf and Spotty Bulborbs and Bulbears, Wollywogs, the Armored Cannon
  Beetle (it fires Rolling Boulders), the Fiery Blowhog, the Swooping Snitchbug, the three Sheargrubs, the Wogpole, the
  Puffstool, the Puffy Blowhog, the Mamuta, the Smoky Progg (it also hatches from Giant Eggs, which burst when a player is
  near) and the Water Dumple. Placed in the stage rather than chosen by the director: Honeywisps (a hit drops nectar),
  waterborne enemies (the Wogpole and Water Dumple spawn in the stage's water), Fire Geysers, Pellet Posies (kill one for a
  pellet) and, after the first stage, a Pearly Clamclamp whose pearl is a ship part. On the first stage a Breadbug always
  drops a ship part.
- **The Mamuta buries.** Its punch plants a Pikmin as a flower sprout and roots a player for four seconds; a buried player
  calms it.
- **Enemy config.** Under `[Enemies]`: `FitSizes` (true), `HoneywispsPerPlayer` (1), `WaterEnemiesPerPlayer` (1),
  `PelletPosiesPerPlayer` (1), `FireGeysersPerStage` (2), `ClamclampEveryStage` (true), and a `Weight` and `Cost` for every
  kind, beside the existing `Enabled`, `BigMinStagesCleared`, `HealthScale`, `SpeedScale`, `DamageScale` and
  `CorpseCarrierScale`.
- Older extractions are topped up with the enemy files on the next launch, from your disc.
- Multiplayer: the host runs the enemies and sends named sounds and directed effects to clients (two new messages).

Headless tests (`libpikmin-teki`, the managed Ship Repair checks) pass. **None of this was played in game**: how the
bodies follow the strategies up and down (jumps, flights), the effects, sounds, hatching, the boulder and burn damage, the
placement of geysers, posies and the shell, and two-player replication are all unseen. `DOCS/pikmin-enemies.md` in the Olimar
source lists what differs from the original (no route graphs, Onions or bridges; Puffstool spores hurt rather than turn
Pikmin into Puffmin).

## 0.3.14 - 2026-10-20

Ship Repair for Mario, Pikmin enemies, the pause-menu controls window and fixes. Install both DLLs
(`OlimarTest.dll`, `pikmin.dll`; native ABI 41, Pikmin network protocol 5). Versions 0.3.12 and 0.3.13 were never
published; their changes are included here.

**Ship Repair**
- Guest characters can play Ship Repair. The new `ShipRepairApi` lands a Dolphin at the teleporter for each guest
  (Mario, from this release) and lets them hold, put and throw parts into its receiver; it is server-run, with
  messages from clients. A guest's Dolphin waits beside them.
- The Dolphin cannot fly to the teleporter until the Main Engine is fitted. Until then the engine lies near every player
  when a stage opens (one for the crew when shared).
- **Pikmin enemies.** Dwarf Bulborbs (common) and Spotty Bulborbs (rare, big) appear as monster bodies drawn from your
  disc, with director cards. Their corpses become pellets from the disc's own config, and a big one always drops a part for
  its killer. The `Enemies` config section sets `Enabled`, `SmallWeight` (6), `BigWeight` (2), `SmallCost` (25),
  `BigCost` (250), `BigMinStagesCleared` (0), `HealthScale` (1), `SpeedScale` (1.5), `DamageScale` (1) and
  `CorpseCarrierScale` (1).
- Hand delivery reaches 100 units (4 m), so a character carrying a part by hand can put it into a ship from a little away.

**Olimar and the squad**
- Fixed the stutter step in Olimar's run, a regression of 0.3.8's timed body smoothing: frames were drawn past the newest
  sim step for part of every tick and then jumped.
- The Onion's ally card has its own portrait on the back. A dormant Onion has no body to target.
- When an Olimar dies with a friend alive, his Onion sleeps and his Pikmin join the friend or walk home first.
  Olimar is invincible while plucking.
- Retired Pikmin slots are reused and replica rendering does less work; the pose budget is enforced natively (ABI 38).
- Adaptive culling applies only to the world's Pikmin view, not the lobby Olimar and his portrait; it could skip re-posing
  them while the game was slow to load.

**Interface**
- Olimar's controls are listed in the window beside RoR2's pause menu; his bottom HUD, carry gauges and Ship Repair HUD
  are hidden while the pause menu is up.
- His portrait in the character select is turned 45 degrees and a little closer, head kept in frame.

Headless native, objective and managed checks pass. None of this was played in game before release.

## 0.3.11 - 2026-10-18

- Falling off the map and the under-the-map recovery are the same shared code as Mario 0.3.6: a fall only counts below the
  stage's lowest ground, and a body that never stood safely since it was placed returns to the nearest player spawn point
  after 5 seconds of falling or inside an out-of-bounds zone.

## 0.3.10 - 2026-10-18

- Ship Repair panels are drawn under the text on the same canvas: the lobby description, leaderboard names and results are
  readable again. Artifacts are allowed in Ship Repair. A Classic run no longer shows the last Ship Repair run's results.
- RoR2's level text and experience bar are hidden with its health bar under the Pikmin row (`Look.HideRoR2HealthBar`).
- Each throw restarts Olimar's throw animation, so rapid lock-on throws animate. Locked on, any Pikmin following him can be
  thrown, however far.
- A hovering Onion's beam stretches down to the ground below it.

## 0.3.9 - 2026-10-18

Older Olimar builds refuse to connect to this one.

- Ship Repair in multiplayer: the host's objective message was 1103 bytes, over the 1100-byte limit, so it was never delivered
  and clients saw no parts. It is now compact.
- Ship Repair puts ten parts on the map each stage (was two), on top of the stage boss's part and enemy drops. Placement tries
  harder, and any enemy has a 4% chance of dropping one (still limited by the per-player drop interval).
- The Ship Repair leaderboard sits below RoR2's objective list instead of covering its text.
- Olimar can no longer fall forever: 8 seconds airborne and 40 m or more below his last footing brings him back with his squad.
- Other players' Pikmin sounds now come from where those Pikmin are; their personal sounds are no longer played in your ears.
- Pikmin whistled off a pellet they cannot lift are not auto-carried back to it for 30 seconds.
- Each throw restarts Olimar's throw animation. A hovering Onion's beam stretches down to the ground below it.
- Weak machines: far or off-screen Pikmin are re-posed less often, only while the game runs under about 28 fps. A run's slow
  stretches are logged automatically; `Debug.PerformanceLog` still logs every 10 s.
- New `Input.StickDeadzone` (default 0, no change): raise to 0.2-0.3 if a worn stick drifts Olimar or his aim.

## 0.3.8 - 2026-10-18

- A client's own Olimar no longer stutters when running: his body is drawn by sim time, so it keeps gliding through the
  frames between physics steps and through several sim ticks that land between two drawn frames on a slow machine.
- Cheaper on weak machines: no per-frame scene searches for drivers, and enemies are gathered only on steps where the sim ticks.
  RoR2's pause menu now stops the Pikmin's sounds. New opt-in `Debug.PerformanceLog` (fps, worst frame, CPU ms per part, ticks
  per step).

## 0.3.7 - 2026-10-18

- Jump-pad launches make Pikmin cry as when thrown, and the squad repeats one throw and follows Olimar after landing instead
  of walking back to the pad.
- The Onion popup is one small panel on the right with its text on top (no more dimmed glyphs).
- RoR2's health bar is hidden under the Pikmin HUD row (`Look.HideRoR2HealthBar`).
- A flying Onion lands its beam on the ground to collect pellets.

## 0.3.5 - 2026-10-18

Ship Repair and Onion UI update. Install both DLLs; all players need the same
Olimar build (native ABI 35, Pikmin network protocol 5).

- Ship Repair keeps its vanilla gameover continuation prompt and player indicators,
  displays a bubble-box parts/Pikmin/score card, and uses RoR2 text for ordinary UI
  copy. Location names use Pikmin's disc-extracted bigFont with RoR2 subtitles.
- The wrecked Dolphin emits its original smoke and electrical effects. Onion takeoff
  smoke follows the flying Onion along the ground and thins as it climbs.
- A landed Onion's beam shows direct button-glyph shortcuts: X empties Onion stock
  except one, Y stores the squad, RB heals Olimar from stock, LB whistles back
  understaffed carriers, and A sends the Onion plucker.
- The carry gauge shows carriers above the required count. Shared movement no longer
  lets grounded Olimar or Pikmin snag a flat floor during collision substeps.
- Preserve Ship Repair's Olimar-only selection, competitive scoring with end-of-run
  Pikmin bonuses, and the revised bottom HUD.

Headless native, objective and managed builds pass; in-game visual and multiplayer
validation remain pending.

## 0.3.4 - 2026-10-16

Teleporter dock and stage soundtrack preview. Install both DLLs; native ABI 33 / objective protocol 3.

- After landing and dropping off Olimar, his Onion and squad, the Dolphin takes off and relocates near the teleporter. It stays landed there for part deliveries. Multiplayer docks reserve at least 14 metres of horizontal spacing and require clear terrain, hull clearance and a carryable route to the actual intake point. If no valid dock exists, retain the safe arrival site.
- Keep docked Dolphins in place on same-stage respawns. Delay part placement until the arrival relocations finish, so hauling routes target the final docks.
- Replace Ship Repair's opening sting with looping Impact Site music on stage one. Later stages select a seeded random Pikmin stage song without consecutive repeats; late join uses the same sequence.
- Nearby RoR2 enemies drive the original Pikmin enemy-proximity music layers. Retain RoR2 teleporter boss music, pause the Pikmin song during that fight, and resume afterward. Other modes keep their soundtrack.
- Add local `ShipRepair.StageMusic`, `AdaptiveStageMusic` and `StageMusicVolume` settings. Music uses an independent native stream and RoR2 music/master volume, with pause and teardown support. Missing music assets/output retain RoR2 music.
- Verify all five extracted stage songs produce finite audible PCM, enemy proximity changes the original mix, the native music ABI accepts pause/stop and rejects invalid songs, and seeded policy yields to bosses/victory/other modes.

Automated checks and Release builds pass. Flight paths, multiplayer dock placement, in-game mix balance and boss-track transitions still need manual playtesting.

## 0.3.3 - 2026-10-15

Ship-part pickup guard preview. Install both DLLs together; native ABI 32 / objective protocol 3.

- Expose explicit ship-part classification to the host. Flying/following Onions ignore all ship parts when choosing automatic pickup targets, including loose duplicates and parts in any carry/suction state.
- Keep native ground-vacuum rejection as a second guard. Ship parts enter an Onion only through the normal Pikmin carry handoff targeting that Onion, such as intentional competitive salvage.
- Add regression checks for loose new/duplicate parts, teams targeting a Dolphin or Onion, all delivery policies, raw native classification and managed automatic-pickup filtering. Verify actual deliberate salvage still completes once.
- Document existing Pikmin regeneration: living assigned Pikmin inherit Olimar's percentage regeneration with `Items.MinionHealScale` (default 0.5), and receive healing from nearby wards. Direct healing of Olimar is not copied to them.

Build/headless checks pass; in-game validation remains pending.

## 0.3.2 - 2026-10-15

Ship Repair pacing preview. Native ABI 31 / objective protocol 3; all players need this matching build.

- Add a 30-second cooldown per player between successful ordinary enemy part drops. One player's drop never starts another player's timer. Pikmin/minion kills resolve to their owning player; unattributed kills do not drain the ordinary quota.
- Expose `[ShipRepair] EnemyPartIntervalSeconds = 30` as a host rule locked at run start. The guaranteed stage-boss reward bypasses the cooldown.
- Require 25 metres of horizontal separation from existing undelivered physical parts. Crowded kill spots use a clear validated map site; failed placement consumes neither quota nor cooldown. No delayed kill-reward queue builds up.
- Apply clear-site checks to fallback wreckage and recycled salvage, preventing those paths from making piles too.
- Add headless tests for independent player gates, exact boundaries, stage resets and sustained four-player kill bursts. Managed build and tests pass; in-game validation remains pending.

## 0.3.1 - 2026-10-15

Competitive Ship Repair preview. Install both DLLs; all players need ABI 31 / objective protocol 3.
In-game validation remains pending.

- Add `[ShipRepair] CompetitiveMode = true` as a host-owned rule locked at run start. Each player repairs their own Dolphin; first to 30 unique parts wins. Set false for shared cooperative repair.
- Carry teams use their captain's Dolphin, regardless of opponents' nearer ships. Part identities can recur for players who still need them. HUD and results show each racer's progress and the winner.
- Duplicate parts go to the carrier owner's landed Onion for twice their weight in seeds (20–100), split across the three colours. Salvage never advances the 30-part goal. If a rival still needs the part, it returns to its original map site after five seconds.
- Start with up to two shared map parts, one guaranteed stage-boss part, and seven other powerful-enemy drops per player (seven per team in cooperative mode). Stage bosses have a separate one-part quota across their group.
- After the ordinary enemy quota, powerful enemies have a 20% bonus-drop chance with no lifetime stage cap. Consumed tracking slots can be reused. Leaving for another stage remains optional.
- Add headless coverage for independent progress, secured winners, salvage, player-count scaling, replicated race state, and physical native hauling to the correct Dolphin/Onion.

## 0.3.0 - 2026-10-15

Feature preview on `feature/ship-part-mode`; automated checks pass, in-game validation pending.
Install both DLLs together. All co-op participants need this preview and their own extracted assets.

- Add Ship Repair mode to the solo extra-mode menu and multiplayer mode picker. All players choose Olimar; artifacts must be off.
- Start with a wrecked Dolphin. Recover 30 unique parts as a team; each stage offers up to seven ground parts and three powerful-enemy drops. Missed parts may return on later stages.
- Pikmin carry parts to a landed Dolphin. Use original disc weights, part models, fitting motions, progressive hull repairs, lights, sounds and particles. Every player's Dolphin reflects the shared recovered set.
- Repeat arrival on each stage, retaining the arrival music sting only on stage one. Restore fitted parts without replaying deliveries.
- Add reachable ground navigation, discovery markers, stuck-part recovery, repair timer, departure warnings and results summaries alongside the normal RoR2 report.
- At 30 deliveries, secure victory, play the complete-ending farewell music and original Pikmin/Olimar celebration motions, then launch the Dolphin. Preserve the music through results.
- Retire the old `Dolphin.ShipPartsMode` placeholder. Classic, Eclipse and Simulacrum retain normal objectives and a repaired Dolphin.

See [validation status](../docs/ShipPartMode-Status.md) for checks and the manual playtest checklist.

## 0.2.3 - 2026-10-15

Fixes 0.2.2.1, whose wait for the stage's ground could hold Olimar still for 10 seconds after he left
the drop pod. Skip 0.2.2.1.

- The wait now looks from just above his feet as well, stops the moment any part of the stage is within
  2 m of him, and gives up after 5 seconds instead of 10, so a normal stage start doesn't wait at all.

## 0.2.3 - 2026-10-15

Fixes 0.2.2.1, whose wait for the stage's ground could hold Olimar still for 10 seconds after he left
the drop pod. Skip 0.2.2.1.

- The wait now looks from just above his feet as well, stops the moment any part of the stage is within
  2 m of him, and gives up after 5 seconds instead of 10, so a normal stage start doesn't wait at all.

## 0.2.2.1 - 2026-10-15

- Olimar now waits for the stage's ground before he is placed, the way Mario does since 0.2.2. A stage's
  floor can load after the body appears, which dropped a client through the map on spawn. He holds still
  for up to 10 s until there is ground under him (the log says so), then carries on as before.

## 0.2.2 - 2026-10-15

- The Pikmin damage numbers (`Look.PikminDamageNumbers`) now apply only while you play Olimar (every
  number you see then, whoever dealt it). Other survivors keep RoR2's font; they changed for everyone
  before.

## 0.2.1 - 2026-10-15

Hotfix release shared with Mario (no change to Olimar's play). The ZIP has no `install.ps1` any more:
copy its `BepInEx` folder into the game folder.

## 0.2.0 - 2026-10-15

Install both DLLs together, and have every player in a game on this release: the native ABI and the
multiplayer snapshots changed.

### Character select
- Olimar has a new overview, and each skill now states its controls, duration, range and cooldown,
  with the Pikmin's damage per swing (Red 75% of his damage, Blue and Yellow 50%), the throw and lock-on
  ranges, the whistle's circle, the Onion's recharge and the dismiss strike's reach, damage and cooldown.

### Items
- Pikmin hits and Olimar's punch are primary damage and the dismiss strike special, so the items that
  only answer skill hits work: Breaching Fin, Luminous Shot, Infernal Mark, Nightmare Demon, Vile
  Censer, Deus Ex Machina.
- His jumps raise RoR2's jump event (Faraday Spur, Earthbound Vessel, Hex of Leaping) and landings raise
  its landing event (Mycelium Cap's spores). Jump power and acceleration reach the sim: Faraday Spur's
  higher jumps, Hex of Leaping, Hex of Acceleration.

## 0.1.0 - 2026-10-15

First modern release. Includes the character features below, adapted to DLC4 APIs and netstandard2.1.
Fixes opaque materials, survivor portraits and native audio gain before clipping. Shared native audio
defaults to -4 dB with no additional tone filter. The full vanilla sundown death bell is prepared
from the user's disc in memory and survives game-over cleanup. Install both ABI 28 DLLs together.

## Legacy 0.1.0 - 2026-10-14

First packaged release: `OlimarTest.dll` and `pikmin.dll`, with an installer and checksums.
Earlier builds were development builds installed straight from source, so everything the character
does is listed here. Most of it has been play-tested in game; the rest is listed under "Not yet
play-tested".

### Character
- Pikmin's Olimar as a survivor ("Olimar"), leading libpikmin's (`pikmin.dll`) reimplementation of
  Pikmin 1's squad written from the decompilation, in place of RoR2's character controller. He keeps
  Commando's body and HUD, at two thirds of Commando's height, and is tougher than the game's
  Olimar, as are his Pikmin.
- A squad of 10 Red, 5 Yellow and 5 Blue Pikmin that follow in formation, get whistled, thrown,
  swarm and rejoin on their own, drawn with the disc's models, textures, helmet and animations
  (materials baked from the game's own), and heard with its sounds: whistle, formation trumpet
  (with a gain setting that lifts it over RoR2 combat), carry, spit and growth sounds.
- Pad layout by button position (A throw/pluck, B jump, LB+B whistle, X lower/raise the Onion,
  RB dismiss strike, D-pad colour select and Onion menu, right stick camera, LB + right stick swarm,
  RT lock-on, R3 zoom), plus a keyboard and mouse scheme on RoR2's binds, with skill-icon glyphs and
  text for the pad buttons and vanilla skill icons. Y stays RoR2's equipment; X is RoR2's interact
  whenever it shows a prompt.
- Camera: an orbit camera that can look up like RoR2's (`Controls.LookUpDegrees`), panned with the
  right stick, with high-refresh smoothing of Olimar and the Pikmin.
- Character select: Olimar with a red, a yellow and a blue Pikmin standing in formation after the
  whistle, and a portrait rendered from his lobby model.
- Arrival: the S.S. Dolphin lands behind Olimar with its parts repaired, he beams out of its hatch
  with the ship's healing effects, the squad comes out of the Onion, and the Impact Site sting
  plays. The Onion lands beside him.

### Squad
- Follow, whistle, throw, swarm (with the disc's formation trumpet and the C-stick's swarm moved to
  LB + right stick), plucking (chained), jumping with Olimar's takeoffs and jump pads (Pikmin's own
  jump motion by default), and the dismiss strike.
- Throws reach twice as far, are steered onto the cursor, home onto a locked-on enemy's real
  hurtboxes (40 m range) and end latched there. The colour switch steps through Any (the nearest
  Pikmin) and each colour; locked on, a throw calls the nearest Pikmin of any colour from far away.
  A Pikmin called to Olimar's hand sprints to catch him when he throws on the run.
- Dismiss strike replaces the dismissal: a melee blow all round Olimar that staggers enemies,
  charges the squad at them, resets its cooldown on a kill and has its own damage setting.
- Enemy attacks shake latched Pikmin off (with two seconds' protection); hits near Pikmin hurt
  them, scaled to Olimar's health. Pikmin die, leaving ghosts.
- RoR2's freezes freeze Pikmin in an area; stuns, freezes, shocks and roots hold Olimar.

### Combat and items
- RoR2's enemies are creatures to the sim, with hurtboxes (their real collider shapes, handed over
  a tick ahead for fast fliers) as latch points. Pikmin hits are RoR2 damage from Olimar, so his
  damage stat, crits and on-hit items apply. Enemy health bars are Pikmin 1's life gauge wheel
  (`Look.PikminHealthGauges`) and RoR2's damage numbers can use Pikmin's digits.
- His moves use RoR2's skill slots (the dismiss strike is the special, with a RoR2 cooldown; the
  Onion plucker is a passive), so RoR2's items work: proc clocks, air jumps, stomps, cooldown
  items, sprint items and movement-speed items (which speed Olimar, and the squad's pace follows).
- The Onion is Olimar's minion and gets his items; jump pads, knockback and Milky Chrysalis throws
  are relayed to the squad.
- Fall damage through RoR2's own landing hook.
- Goobo Jr.'s Olimar gets a brain and is drawn in the gummy clone material.

### Pikmin economy
- Dead enemies leave numbered pellets (1, 5, 10 or 20 by size, random colour); Pikmin carry them
  to the Onion, which makes seeds (an option carries enemies' own bodies instead). Loose pellets
  are collected automatically, and drop collectors are recruited.
- Sprouts grow from leaf to bud to flower on fixed timers (faster buds), Pikmin grow after kills
  credited to them with the disc's growth sparkles, burst and sounds, and flowers wilt after five
  minutes. Every Onion starts with a Pikmin inside, and the Onion's pluckers pick planted sprouts
  after a minute.
- The squad and stock carry over to the next stage.

### Onion
- One Onion holds all three colours, with a menu (call out, put away, transfer Pikmin, Follow
  Olimar or Land Here) on the pad and the keyboard; it flies to the squad, lands, takes off, and
  can be planted. Light cone, beacon rings, suck effect and sounds from the disc.
- A hovering Onion takes deliveries; the new Pikmin stay inside as leaves. It stops 0.75 m above
  the ground over a pellet.
- Onions have health and can be healed by pellets, go dormant (drawn in their colour) when
  killed and revive on a timer, replaying their startup sound and effects; queued seeds resume
  after a revival, deliveries interrupted by a death release their teams, and Pikmin collect loose
  pellets only once an Onion has descended. A life gauge (a Pikmin wheel) floats above a wounded
  or dormant Onion, refilling with its revival timer.
- The Onion's ally card is hidden, and RoR2's interact prompt opens the Onion window.

### Not getting stuck
- Falling off the map puts Olimar and his squad back where he last stood, unhurt; Pikmin that fall
  into a void come back to their captain. Olimar's sim probes the layers RoR2's own bodies collide
  with.

### Multiplayer
- The host sends snapshots of its Pikmin world and other machines draw a replica of it, with the
  client's own Olimar shown on his locally predicted motion. A client's Olimar moves on his own
  machine and the host's captain follows his pose; Onion commands and the squad HUD work over the
  network.

### First run
- Models, animations, tuning, sounds and effects are extracted from your own Pikmin disc
  (ISO/GCM/CISO) on first launch. The build and the ZIP contain no game data.

### Settings
- Everything above has a setting in `com.libpikmin.olimartest.cfg` (look, sound, controls, combat,
  Pikmin and Onion rules, Dolphin), each with a description.

### Not yet play-tested
- Olimar beaming out of the Dolphin's hatch at the start of a run, with the squad coming out of
  the Onion, and the arrival effects.
- Onion health, dormancy and revival, the life gauge, and the hovering Onion's descent for pellets.
- Multiplayer with two players.

### Known limitations
- Multiplayer is new and untested with two players.
- No Olimar footsteps or voice, no hazard types, no ship-part repair, and enemies don't target
  Pikmin directly.
