# Mario changelog

Modern releases target the modern/1.5.0 game branch (DLC4, Unity 2021.3.45f2), BepInEx 5.4.21.0 and RoR2BepInExPack 1.46.0. Native ABI 29 from 0.3.7; ABI 28 in 0.3.3 to 0.3.6; ABI 26 to 27 before.

Each entry lists only what changed since the previous published version. Everyone in a multiplayer game needs the same Mario build.

## 0.3.9 - 2026-10-21

One fix, to 0.3.8's lock. Install both DLLs (`MarioTest.dll`, `sms.dll`; native ABI 29, unchanged).

- **Mario is locked only in Ship Repair.** 0.3.8 locked him in every mode whenever the Olimar plugin was installed. Now the lock
  belongs to the Ship Repair mode alone: he is unlocked in every other mode, and in a Ship Repair lobby he needs the win as
  Olimar ("Repair the Dolphin in Ship Repair as Olimar."). Nothing else changed.

Headless checks pass. None of this was played in game before release.

## 0.3.8 - 2026-10-21

One change. Install both DLLs (`MarioTest.dll`, `sms.dll`; native ABI 29, unchanged).

- **Mario is a reward for Ship Repair.** He now sits after Olimar in the character select, and while the Olimar plugin is
  installed he is locked until you win Ship Repair as Olimar ("Repair the Dolphin in Ship Repair as Olimar."; the win
  unlocks him with a chat message, and every machine in a multiplayer game unlocks it for its own players). Without the Olimar
  plugin nothing could ever unlock him, so then he is available from the start.

Headless native, boundary and host checks pass. None of this was played in game before release.

## 0.3.7 - 2026-10-20

Ship Repair, a reworked corkscrew and the pause-menu controls window. Install both DLLs (`MarioTest.dll`, `sms.dll`, native ABI 29).

- **Mario plays Ship Repair.** When the Olimar plugin (this release) runs the mode, Mario gets a Dolphin
  landed at the teleporter and can carry its ship parts: B next to a part picks it up with Sunshine's own
  grab, carry pose and lift sound; the part is held in front of him; putting it down or throwing it
  into the Dolphin's receiver hands it back to the mode. The two plugins meet through the Olimar plugin's
  `ShipRepairApi` by reflection, so Mario still runs without Olimar installed (and then has no Ship Repair).
- **Corkscrew rework.** A stick circle in a plain dive is a corkscrew at the dive's own speed, once per dive. A circle
  with the Turbo held in any jump is the Turbo corkscrew: it flies 1.25 s at its own held speed past the dive's cap,
  glides and steers, and the Turbo sprays nothing in a spin. It keeps its height for as long as the stick keeps
  circling (up to 6 s), then dives. The spin and the dive throw the wet slide's spray, the drawn body is tipped and
  rolled with the spin swirl, and there is one spin call-out and then quiet.
- **Super corkscrew.** After 4 seconds a corkscrew is in flames, and its one hit is the super blow: `Damage.SuperCorkscrew`
  (20, i.e. 2000%) at the cost of `Damage.SuperCorkscrewRecoil` (4% of max health) when it bonks Mario over. A burning
  corkscrew lands in a blazing slide that keeps its flight speed and fire for 2 s and hits as a corkscrew (700%), then
  becomes the plain wet slide.
- **Rocket spin.** A stick circle during the Rocket's climb doubles the climb and sets the spin burning while it rises;
  each enemy above Mario takes `Damage.RocketSpin` (10, i.e. 1000%).
- Going out through the top of the map puts Mario back without the TOO BAD screen.
- Mario's controls are listed in the window beside RoR2's pause menu, and his portrait in the character select is turned
  45 degrees and a little closer, head kept in frame.
- Cheaper in play: the replay of other players' Marios is bounded after a stall and allocates less, and
  poses and rendering avoid per-frame allocations and hidden geometry work.

Headless native, boundary and host checks pass. None of this was played in game before release.

## 0.3.6 - 2026-10-18

- The Turbo corkscrew dive (a full stick circle out of a Turbo dash jump) plays the spin jump's pose laid flat, head first,
  spinning along his length for two turns before the plain dive. It adds a dive's speed on top of the Turbo's and hits enemies
  for `Damage.Corkscrew` (700% by default) with a harder shove.
- The rocket or hover is spent for the whole jump: spinning out of it no longer gives a second use before he lands.
- Falling off the map ("TOO BAD" and the far-drop rescue) only counts below the stage's lowest ground. The stage's own
  out-of-bounds zones and the under-map recovery are unchanged.
- A body that never stood safely since it was placed (a crash pod that landed on a scene object and put it under the map)
  returns to the nearest player spawn point after 5 seconds of falling or inside an out-of-bounds zone.

## 0.3.5 - 2026-10-18

Mario's multiplayer frame format changed: an older Mario and this one ignore each other's frames.

- Health is 160 + 48 per level by default (was Commando's 110 + 33); `Body.MaxHealth` and `Body.HealthPerLevel` change it.
- A hit or a wall no longer takes him out of a ground pound (the hit still counts).
- A full stick circle spins him out of a rocket nozzle's thrust and climb, out of a Turbo dash once the spray is let go, and
  in any fall. The spray he still holds does not start the rocket again.
- The stick turns him in the rocket's thrust and in the climb after it, instead of only pushing him along his facing.
- A full stick circle out of a Turbo dash jump is a corkscrew dive: thrown forward head first, rolling two full turns about its
  length, then the plain dive.
- Other players' Marios replay with the wet-ground state their own machine used, so a friend's wet slide is not shown as
  fast running (for example to a dead spectator).

## 0.3.3 - 2026-10-18

Includes 0.3.2 (0.3.4 was never published).

- RoR2's pause menu stops Mario's sounds where they are.
- The replay of other players' Marios is time-budgeted instead of capped at four steps per frame, which was the client lag
  and drift. Marios slide on each other's wet spots and pick up each other's coins, and Backup Magazine starts with its charge.

## 0.3.1 - 2026-10-18

- The coin-counter and full-pressure Spray changes from the 2026-10-18 test build (`quick-20261018-animated-effects`).

## 0.3.0 - 2026-10-18

- Restore Sunshine's HUD layout: the larger Shine health meter and smaller RoR2
  damage-font health numbers, FLUDD in the corner, coin-counter paint backplates,
  and RoR2 items and cooldowns in their adjusted positions. `Hud.SunshineLayout`
  controls the arrangement.
- Remove the red game-over layer immediately before the black screen fades.
- Lunar coins play Sunshine's actual blue-coin pickup sound (`MSD_SE_SY_BLUE_COIN_GET`)
  instead of the puzzle-solved chime. The old `Hud.LunarCoinSecret` option is ignored,
  including in existing configs. `SpawnMusic.Cues` still controls playback.
- Bound remote Mario replay to four simulation steps per update after a stall while
  preserving every network frame in order. Reset replay state cleanly on a new stream.
- Avoid re-decoding the local player's echoed movement frames, reuse static coin
  geometry and effect materials, and reduce repeated coin and combat scans.
- Add opt-in ten-second CPU, frame, network backlog and correction diagnostics with
  `Debug.PerformanceLog`.

## 0.2.3 - 2026-10-15

Fixes 0.2.2 and 0.2.2.1, which held Mario still as Commando for 10 seconds after he left the drop pod
before turning him into Mario. Skip those two.

- The wait for the stage's ground (added in 0.2.2 against falling through a stage whose floor hadn't
  loaded) took a pod exit for a missing floor, because the body stands slightly sunk into it. It now
  looks from just above his feet as well, and stops waiting the moment any part of the stage is within
  2 m of him, so a normal stage start doesn't wait at all.
- When a stage really has nothing around him yet, it gives up after 5 seconds instead of 10.

## 0.2.2.1 - 2026-10-15

No change in play. The wait for the stage's ground that 0.2.2 added to Mario now lives in the shared
code, so Olimar uses it too.

## 0.2.2 - 2026-10-15

Have every player in a game on 0.2.1 or later (the network format is unchanged since 0.2.0, so a mix of
0.2.1 and 0.2.2 plays together).

- Lunar coins lying in the world show as Sunshine's spinning blue coin, for the Mario player only
  (`Hud.LunarCoinBlueCoin` turns it off). RoR2's own model is hidden on your machine; the pickup itself
  is unchanged for everyone.
- Mario waits for the stage's ground before he starts moving. A stage's floor can load after the body
  appears, which dropped a client through the map on spawn. He holds still for up to 10 s until there
  is ground under him (the log says so), then carries on as before.

## 0.2.1 - 2026-10-15

Hotfix.

- Mario's voice, footsteps and FLUDD (and the coin and hover sounds) came out of the right ear only,
  the lobby "wahoo" included: the left output was never connected for sounds routed through the game's
  surround mixer. They play in both ears now, so everything is a little louder (`Output.GainDb` in
  `Ror2Common.Audio.cfg` lowers it). The cached jingles (arrival, "Too Bad!", game over, the coin
  chimes and the Shine Get fanfare) were right-ear only too and are rendered again on the next launch.
- The ZIP has no `install.ps1` any more: copy its `BepInEx` folder into the game folder.

## 0.2.0 - 2026-10-15

Install both DLLs together, and have every player in a game on this release: the multiplayer frames
and the native ABI changed.

### Shine Get
- A charged teleporter shows a Shine Sprite from your disc above its middle, humming, for the Mario
  player only. Touching it (walking or jumping into it, no button) is Sunshine's Shine Get: Mario lands
  and holds it over his head, the camera flies the disc's own path, the Shine's glow and the Shine Get
  fanfare play, and "SHINE!" flies in. The stage ends about 6.3 s later for everyone, as if Mario had
  used the teleporter: the stage the run was going to, a Lunar Seer's choice if one was made, or on the
  last stage before the moon, the moon rather than the loop. Other players see Mario in the pose.
- New settings: `Shine.Enabled`, `Shine.Height`, `Shine.TouchRadius`, `Shine.Seconds`, `Shine.Camera`.
  The Shine, its clips and the camera path are fetched from your disc with the wipe pictures.

### Lunar coins
- A lunar coin plays Sunshine's "puzzle solved" chime instead of the blue coin's jingle, which sounded
  like a save (`Hud.LunarCoinSecret` turns it back).

### Character select
- Mario has a new overview, and each skill now states its controls, duration, range and cooldown
  (the Spray burst, hover and rocket times, the Turbo's speed, the Air Pump's recharge, the Ground
  Pound's damage, radius and recharge, the Wet Slide's glide).

### Items
- Hits carry the skill they came from (FLUDD's water and stomps are the primary, ground pounds the
  utility, the dive and belly slide the special), so the items that only answer skill hits work:
  Breaching Fin, Luminous Shot, Infernal Mark, Nightmare Demon, Vile Censer, Deus Ex Machina.
- His jumps raise RoR2's jump event (Faraday Spur, Earthbound Vessel, Hex of Leaping) and landings
  raise its landing event (Mycelium Cap's spores). Jump power scales his jumps and acceleration his
  running (Faraday Spur, Hex of Leaping, Hex of Acceleration).

## 0.1.0 - 2026-10-15

First modern release. Includes the character features below, adapted to DLC4 APIs and netstandard2.1.
Fixes opaque materials, survivor portraits and native audio gain before clipping. Shared native audio
defaults to -4 dB; the temporary tone filters and separate FLUDD attenuation are removed.
The earlier legacy package used 0.2.0; modern releases start at 0.1.0.

## Legacy 0.2.0 - 2026-10-14

First packaged release: `MarioTest.dll` and `sms.dll`, with an installer and checksums. Earlier
builds were development builds installed straight from source, so everything the character does is
listed here.

### Character
- Super Mario Sunshine's Mario as a survivor ("Mario"), moved by libsms (`sms.dll`, a
  reimplementation of Sunshine's Mario written from the decompilation) in place of RoR2's
  character controller. He keeps Commando's body, hurtboxes and HUD, at Commando's height.
- Drawn with the disc's own model, animations, face textures, eyes and blinks, and heard with its
  voice, footsteps, FLUDD and movement sounds, all taken from your own disc. Smoothed between sim
  steps so high-refresh displays and the camera see no jitter; the camera follows a pivot of its own.
- Character select: Mario's model and portrait (rendered from his lobby model), a jump on the spot
  with a "wahoo".
- Skills use vanilla icons (FLUDD, extra mid-air FLUDD, Ground Pound, Wet Slide) and skill-icon
  glyphs and text name the pad buttons Mario reads.
- Pad layout by button position (A jump, B dive/punch, RT spray, LT ground pound, LB lock-on,
  RB nozzle, D-pad down refill; X and Y stay RoR2's interact and equipment) and a keyboard and
  mouse layout on RoR2's binds, picked by whichever device you used last. Analog spray trigger
  with a curve, light presses and full presses.

### Movement
- Sunshine's ground movement (walk, run, turns, slopes and slipping, crouch), the single, double
  and triple jump chain (a forgiving chain window and a higher jump, tunable), the spin jump, dive
  and belly slide, the ground pound and the super pound (with its flames and blast), wall slide
  and wall kick, ledge hang, shimmy and climb-up, and bump knock-downs, all from the decompiled
  game, with the disc's tuning in place of the code defaults (the sim runs at Sunshine's 120 Hz).
- Hopoo Feather mid-air jumps cancel a dive in flight; jump pads throw Mario along RoR2's own
  ballistics; short hop, stomp bounce, rocket height and the other jump rules are settings.
- Move-speed items speed him up.

### FLUDD
- Spray, Hover, Rocket and Turbo nozzles, the nozzle swap with its animation and sounds, FLUDD
  and the nozzle drawn from the disc's model with the pumping arm, handles and Mario's head
  tipping back while rocketing; the water drawn as the game does it (its particles and two-pass
  look, refracting through RoR2's distortion with a faint tint, depth-tested against the scene).
- Spray bursts (a light press for a short splash just ahead, a full press for full reach), with
  burst damage tuned (`Damage.BurstMultiplier`).
- The water gauge on screen; the tank refills from RoR2 and shallow water, with D-pad down, and
  on each new stage; "empty" puff and "full" chime; unlimited-water option.
- Wet ground: FLUDD's water leaves drying wet patches (a light burst wets six circles forward
  from his feet) and shallow water counts. Wet belly slides glide over wet ground for 1.5 s with
  no charges, with side waves of spray, a faint pale tint and scene refraction.
- Lock-on with LB (a keyboard's utility key): FLUDD tracks the enemy on the ground or in the air,
  its head swivels to point at it, RB steps to the next target (60 m range); L-camera aim points
  FLUDD where the camera looks.
- The nozzles' effects: smoke on each muzzle while water leaves, the Rocket's launch burst and
  exhaust that follows the muzzle, the Hover's start voice, and the Turbo's dash cone and water boost.

### Effects and sound
- Sunshine's own particle effects, run as the game's particle system runs them, on every move:
  walk and landing dust, bump stars (orange and pink as in the game), smears, the spin jump's
  swirl, belly-slide spray, stomp bursts, wall-slide and wall-kick dust and the super pound's
  flames; ground pound smoke keeps its birth height, and the smoke speed is a setting.
- The disc's sounds on a device of their own: voices, footsteps, FLUDD, coin pickup, with a
  volume setting that also follows RoR2's master volume.
- Delfino Plaza sting as he leaves the pod on a run's first stage; on death the game over song,
  with the "Too Bad!" jingle for a miss, and the blue coin jingle (see below). Audio is released
  at game over and between runs.

### Combat and items
- Stomps, ground pounds (with a shock wave), dives, punches and FLUDD water hit as RoR2 damage from
  Mario, so his damage stat, crits and on-hit items apply. Pound damage scales with the drop.
- His moves use RoR2's skill slots (FLUDD primary, extra mid-air FLUDD secondary, full-strength
  ground pounds utility, wet slides special), so cooldowns and charges, Backup Magazine,
  Hardlight Afterburner and Lysate Cell work; cooldown items stretch hover time, spray time, rocket
  height, Turbo speed and the wet slide. Healing and Bandolier refill the tank. Sprint items work
  on RoR2's sprint button. See `ITEMS.md` in the source for every rule.
- Jump pads, knockback, Milky Chrysalis throws, stuns, freezes, shocks and roots work on him.
- Powerful hits (a quarter of max health and shield) knock him down without stunning him.
  Height-based fall damage, with ground pound and dive protection.
- Goobo Jr.'s clone gets a Mario brain and is drawn in the gummy clone material.

### HUD
- Sunshine's life meter (the Shine Sprite sun) replaces RoR2's health bar (the numbers stay):
  eight rays of health and the shield's rays in cyan. A lock-on marker (the sun alone, turning)
  floats on the target and can show its health.
- The water tank gauge, and Sunshine's coin counters (below).

### Coins and counters
- Yellow coins drop from enemies he kills, spin, and restore one life-meter segment on touch, with
  the game's pickup sound and sparks. Each is also worth 1 RoR2 gold (`Coins.Gold`).
- Sunshine's yellow and blue coin counters, drawn from the disc's HUD pictures, replace RoR2's gold
  and lunar coin counters (which hide), up to seven digits, each where RoR2's own was. A lunar
  coin picked up plays Sunshine's blue coin jingle.

### Losing
- Dying with no extra life plays the game over song and Sunshine's game over screen: the
  "TOO BAD!" letters drop in and settle, then the screen goes black with "GAME OVER" cut out of it
  (spinning in, pulling back and bouncing) and a red box coming in behind.
- With Dio's Best Friend or a Pluripotent Larva a death is a miss instead: the "Too Bad!" jingle,
  the letters, and Sunshine's "MARIO x N" lives banner counting the life down. No banner without
  an extra life.
- Falling off the map starts "TOO BAD!" and its jingle early (20 m below where he last stood over
  a void; `Hud.TooBadDrop`), and he is put back where he last stood, unhurt, a little later, when
  the stage's kill zone (or a 150 m drop) takes him; a drop onto lower ground, as on a tall stage,
  is not a fall off the map. He can't be hit while the screen is black.
- The screens are drawn smoothly between the game's 30 frames a second at `Hud.ScreenSpeed`.
- Falling for good in a death plays Sunshine's fall ("down" voices), which plays out after RoR2
  removes the body.

### Not getting stuck
- Mario probes the layers RoR2's own bodies collide with. A missing floor reads as a floor far
  below, so gaps in a map are not invisible walls.
- Wall guard: a step that crosses a wall, or ends inside one, is undone (more strictly for a few
  seconds after a hit or launch).
- Automatic unstuck recovery after three seconds wedged in place, and the fall-off-the-map return
  (above).

### Multiplayer
- Other players with the plugin and the disc assets see Mario move, with his water, coins and
  effects (their machine replays his sim calls on a shadow sim); a client's hits, falls, Shuriken
  pulse and blasts land on the host; healing and Bandolier refill a client's tank through the
  host; coins drop and spin on every machine. Players without the plugin see Commando.

### First run
- Models, animation, tuning, sounds, HUD and effects are extracted from your own Sunshine disc
  (ISO/GCM/CISO, any region; a USA and a European disc are tested) on first launch, together
  with the generated arrival, "Too Bad!", game over and blue coin jingles and the game over wipe's
  pictures. Incomplete caches are repaired, and a cache without the jingles or the wipe pictures
  gets them when the disc is found. The build and the ZIP contain no game data.

### Settings
- Everything above has a setting in `com.libsms.mariotest.cfg` (look, sound, sim rules, FLUDD,
  controls, HUD, coins, damage, items, fall damage, knockdown, paths), each with a description.

### Not yet play-tested
- First-run extraction from a disc, including the generated jingles and cache repair.
- The coin counters (positions over RoR2's HUD, hiding RoR2's own), the blue coin jingle, and the
  "TOO BAD!" and game over screens: the early cue on a fall, the lives banner with an extra life,
  and the screens' pace.
- The wall guard (putting him back from inside a wall), and FLUDD wet patches darkening the ground.
- Multiplayer with two players.

### Known limitations
- No Yoshi. VR is not supported. Skill icons are vanilla ones, with Mario's buttons as glyphs.
- Goobo Jr.'s clone is drawn in the gummy material, not a Shadow Mario skin.
