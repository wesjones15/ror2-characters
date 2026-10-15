# Mario changelog

Modern releases target the modern/1.5.0 game branch (DLC4, Unity 2021.3.45f2), BepInEx 5.4.21.0 and RoR2BepInExPack 1.46.0. Native ABI 26.

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
