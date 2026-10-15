> Modern 0.2.0 for the modern/1.5.0 game compatibility branch. See Known limitations for remaining manual validation.

# Mario for Risk of Rain 2

Version 0.2.0 (modern). A survivor called **Mario**: Super Mario Sunshine's movement, FLUDD and
sounds in Risk of Rain 2. He uses Commando's body and HUD but is moved by `sms.dll` (libsms,
a reimplementation of Sunshine's Mario) and drawn and heard as the disc's Mario.

**Offline and friends-only co-op only.** Do not run this online.

## Requirements and dependency mods

- Risk of Rain 2 **modern/1.5.0 (DLC4, Unity 2021.3.45f2)**, Windows x64.
- [BepInExPack by bbepis](https://old.thunderstore.io/package/bbepis/BepInExPack/), with BepInEx 5.4.21.0 and its supporting mods below. The character ZIP does not include or install these dependencies.
- Your own **Super Mario Sunshine** GameCube disc image (`.iso`, `.gcm` or `.ciso`). RVZ/WIA/WBFS must be converted to ISO first. No game data is included in this release.

Install the BepInExPack dependency set for the modern game:

| Dependency | Purpose |
| --- | --- |
| [BepInEx_GUI](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/BepInEx_GUI/) | Loader/logging interface. |
| [FixPluginTypesSerialization](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/FixPluginTypesSerialization/) | Unity serialization support for plugin types. |
| [RoR2BepInExPack](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/RoR2BepInExPack/) | RoR2 compatibility fixes; this release was checked with 1.46.0. |
| [SeekersPatcher](https://thunderstore.io/c/riskofrain2/p/pseudopulse/SeekersPatcher/) | Compatibility redirects for game updates. |
| [MiscFixes](https://thunderstore.io/c/riskofrain2/p/score/MiscFixes/) | Fixes for game bugs and mod compatibility. |

## Install

1. Install **BepInExPack and all five dependencies** using your Risk of Rain 2 mod manager. Confirm they are enabled in the same profile you will use for Mario. For a manual install, download BepInExPack from the link above and copy the contents of its inner `BepInExPack` directory into the game directory, with `winhttp.dll` beside the game executable. Download the five dependency packages separately and merge their included folders into that installation, preserving `BepInEx/plugins`, `BepInEx/patchers` and `BepInEx/config`; follow each package's own instructions. Copy complete package contents, including supporting files.
2. Unzip **Mario-modern-0.2.0-win-x64.zip**. Run the included installer, pointing it at the folder containing `BepInEx`:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\install.ps1 -InstallDir "D:\Games\Risk of Rain 2"
   ```

   With a mod manager, use its active profile directory as `-InstallDir` and launch the game through that profile. Add `-WhatIf` to preview. The installer checks hashes and copies the two mod DLLs; it preserves existing configs, assets, disc images and other mods.
3. Put your own **Super Mario Sunshine ISO beside the two character DLLs**, directly in `BepInEx/plugins/MarioTest/`:

   ```text
   BepInEx/
     plugins/
       MarioTest/
         MarioTest.dll
         sms.dll
         Super Mario Sunshine.iso
   ```

   The ISO filename does not matter. Keep it in this character folder, rather than the game root or the `assets` subfolder. The plugin searches beside its DLLs automatically. Mario and the other character use separate folders and can be installed together.
4. Launch the game and let first-run extraction finish. The plugin creates `assets/` beside its DLLs by default and reuses that cache on later launches.
5. To keep the ISO elsewhere, launch once to create the config, quit, and edit `BepInEx/config/com.libsms.mariotest.cfg`. Under `[Paths]`, set `Disc` to its full path, then launch again:

   ```ini
   [Paths]
   Disc = D:\GameCube\Super Mario Sunshine.iso
   ```

Install `MarioTest.dll` and `sms.dll` together. The native ABI must match; this release uses ABI 26.

## First run

The plugin builds its asset cache from your disc: models, animation, tuning, sounds, HUD and
particle effects, the Shine Sprite and its Shine Get camera, plus the arrival, "Too Bad!", game over, blue coin, "secret" chime and Shine Get fanfare jingles (in
`assets/ror2_audio/`) and the pictures of the game over wipe (`assets/wipe/`). The cache is
reused on later launches without the disc. A cache made by an older version gets the jingles
and the wipe pictures added when the disc is found (`Paths.Disc`); without them the game over
screen is simply not shown. By default it is the `assets/` folder next to the
plugin; `Paths.AssetsDir`, then `assets_dir.txt` beside the plugin, then `SMS_ASSETS`, override that.

- Mario stays registered while extraction runs, but his sim, model and coins wait for the
  complete cache. If extraction fails or there is no disc, he plays as Commando and the log
  says what to fix.
- If you pick Mario on the character select screen before extraction finishes, select another
  survivor and then Mario again to refresh his lobby display.
- An incomplete cache from an older version is repaired automatically.

## Controls

Mario has two input layouts, picked automatically by whichever device you used last: a
**gamepad** layout (Sunshine's, by button position) and a **keyboard and mouse** layout (your
RoR2 binds). VR is not supported in this release. Movement is always RoR2's own (the stick or WASD, relative
to the camera); libsms turns it into Sunshine's walk, run and slide.

### Gamepad

Buttons are read by their position on an Xbox-style pad through Rewired's gamepad template, so
**your RoR2 binds don't change them**. The pad must be the last device you touched.

| Button | Sunshine | Does |
| --- | --- | --- |
| Left stick | stick | walk, run |
| A | A | jump; wall kick against a wall |
| B | B | dive in the air; punch on the ground |
| Right trigger (RT) | R | spray FLUDD. Analog: a light pull is a short splash just ahead, a half pull sprays on the move, pulling all the way in plants Mario and sprays |
| Left trigger (LT) | L | ground pound in the air; crouch on the ground. While held, FLUDD points where the camera looks (`Controls.CameraAim`) |
| Left bumper (LB), held | | lock onto an enemy and aim FLUDD at it, on the ground or in the air. Mario doesn't crouch for it |
| Right bumper (RB) | X | switch nozzle: Spray, Hover, Rocket, Turbo. With LB held it steps to the next lock-on target instead |
| Right stick (while RB is pressed with LB held) | | picks the direction to cycle the lock-on (right if centred) |
| D-pad down | | refill FLUDD's tank (`Fludd.DpadRefill`) |
| X | | RoR2's interact (Mario uses it for nothing else) |
| Y | | RoR2's equipment |
| RoR2's sprint bind | | sprint, for sprint items (adds no speed of its own) |

Notes:

- **Spray trigger**: the trigger's travel is curved (`Controls.TriggerCurve`, default 2) so the
  light zone is easier to hold. Sunshine's light zone is the first tenth of a GameCube trigger.
- **Lock-on** picks the enemy nearest where the camera points, within `Controls.LockRange`
  (60 m) and in line of sight, and keeps it until you let go of LB. While locked, RT's full pull
  doesn't plant him, so you can spray on the move.
- **Camera aim** (LT held): FLUDD follows the camera's pitch, and a crouching Mario turns with
  the camera while the stick side-steps. A lock-on, if LB is also held, takes over.
- Pressing X or Y never also triggers a Mario move.
- The HUD's skill icons show these buttons: RT for FLUDD and the Air Pump, LT for the Ground
  Pound, B for the Wet Slide.

### Keyboard and mouse

Your RoR2 binds stand in, since a keyboard has no spare buttons:

| RoR2 action (default key) | Does |
| --- | --- |
| Move (WASD) | walk, run |
| Jump (Space) | A: jump, wall kick |
| Primary skill (left mouse) | spray. A tap is a light splash just ahead; held longer than `Controls.LightTapSeconds` (0.2 s) it sprays at full |
| Sprint (your bind) | plant Mario and spray at full; also RoR2's sprint for sprint items |
| Secondary skill (right mouse) | B: dive, punch |
| Utility skill (your bind) | L: crouch, ground pound in the air, FLUDD aimed by the camera, **and** the lock-on |
| Special skill (R) | switch nozzle. While the utility key is held, cycles the lock-on target instead |

Because the utility key is both L and the lock-on: a fresh press in the air still ground pounds,
but Mario doesn't crouch while locked. The keys shown are RoR2's usual defaults, so check your own
binds in RoR2's settings.

### Related settings

In `BepInEx/config/com.libsms.mariotest.cfg`:

| Setting | Default | Effect |
| --- | --- | --- |
| `Controls.LockOn` | on | the lock-on (LB or the utility key) |
| `Controls.LockRange` | 60 | lock-on reach in metres |
| `Controls.CameraAim` | on | LT points FLUDD where the camera looks |
| `Controls.TriggerCurve` | 2 | spray trigger travel curve; 1 is linear |
| `Controls.LightTapSeconds` | 0.2 | keyboard tap length that counts as a light splash; 0 means always full |
| `Fludd.DpadRefill` | on | D-pad down fills the tank |
| `Fludd.SprayBursts` | on | Sunshine's burst-based spray |
| `Shine.Enabled` | on | the Shine Sprite over a charged teleporter |
| `Shine.Height`, `Shine.TouchRadius` | 1.6, 1.5 | metres the Shine hangs above the teleporter, and how near you touch it from |
| `Shine.Seconds` | 6.3 | seconds from the pose to the stage ending |
| `Shine.Camera` | on | fly the camera along Sunshine's Shine Get path |
| `Hud.LunarCoinSecret` | on | lunar coins play the "puzzle solved" chime, not the blue coin jingle |
| `Hud.CoinCounters` | on | Sunshine's coin counters in place of RoR2's gold and lunar coins |
| `Hud.CoinX`, `Hud.CoinY`, `Hud.CoinScale` | -1, -1, 0.4 | where the counters sit (negative: where RoR2's own are) and their size |
| `Coins.Gold` | 1 | RoR2 gold each yellow coin is worth |
| `Hud.ScreenEffects` | on | the "TOO BAD!" and game over screens |
| `Hud.ScreenSpeed` | 1.25 | their pace against the game's own |
| `Hud.TooBadDrop` | 20 | metres below his last footing at which a fall starts "TOO BAD!" |
| `Hud.LivesScale` | 0.7 | size of the "MARIO x N" banner |
| `SpawnMusic.Cues` | on | the blue coin jingle (and other extra cues) |

### Not supported yet

- Rebinding Mario's moves to other buttons. The gamepad layout is fixed by position.

## Playing Mario

- **Spray** works as in Sunshine: a light press drops a short splash just ahead, which a belly
  slide can glide over; a full press sprays at full reach for about five seconds, then fades.
- **FLUDD's tank** empties as you spray and refills while you hold spray standing in water,
  with D-pad down, and on each new stage.
- **Wet slide**: a belly slide glides only over wet ground (FLUDD's water leaves wet patches,
  and shallow water counts). It lasts up to 1.5 s, with no charges, and cooldown reduction and
  Lysate Cell lengthen it.
- **Ground pound** hits hard and sends a shock wave on landing. Stomps bounce higher in a
  chain, as in Sunshine.
- **Life meter**: Sunshine's sun replaces RoR2's health bar (the numbers stay). Eight rays show
  his health, and the shield's rays follow in cyan. While locked on, the sun turns on the enemy
  as a marker showing its health.
- **Shine Sprite**: when a teleporter has charged (its boss dead) a Shine from the disc rises above its
  middle and hums, for the Mario player only. Touch it, by walking or jumping into it, for Sunshine's Shine
  Get: Mario lands and holds it over his head, the camera flies the disc's own path, the fanfare plays and
  "SHINE!" flies in. About `Shine.Seconds` (6.3) later the stage ends for everyone, as if Mario had used the
  teleporter: to the stage the run was going to, to a Lunar Seer's choice if one was made, or, on the last
  stage before the moon, to the moon instead of the loop. The other portals are never taken. Other players
  see Mario in the pose but not the Shine, and RoR2's own interaction with the teleporter still works.
- **Coins**: enemies Mario kills drop a yellow coin; touching it restores one life-meter
  segment (an eighth of full health) and is worth `Coins.Gold` (1) RoR2 gold. Coins expire after
  60 seconds.
- **Coin counters**: Sunshine's counters, drawn from the disc's HUD pictures, replace RoR2's: the
  yellow coin shows your gold, the blue coin your lunar coins (once you have one), each where
  RoR2's own counter was, which hides. Picking up a lunar coin plays Sunshine's "puzzle solved" chime
  (`Hud.LunarCoinSecret`; off for the blue coin's own jingle).
  The counters take up to seven digits (the game's own stop at three).
- **Items**: RoR2's items work through Mario's moves, using the skill slots (FLUDD is the
  primary, extra mid-air FLUDD the secondary, full ground pounds the utility, wet slides the
  special). Movement-speed items speed him up, and jump pads, knockback and stuns work.
- **Hits and falls**: a powerful hit (a quarter of max health and shield) knocks him down
  without stunning him. Fall damage applies only beyond 40 body heights; ground pounds are
  always safe and a dive landing protects far more.
- **Dying** plays Sunshine's fall and its **game over** song, with its game over screen: the
  "TOO BAD!" letters drop in and bounce, then the screen goes black with the letters "GAME OVER"
  cut out of it (the scene showing through), and a red box comes in behind them. With an extra
  life in hand (Dio's Best Friend, a Pluripotent Larva) a death is a miss instead: the "Too Bad!"
  jingle and letters, and Sunshine's "MARIO x N" lives banner sliding in and counting down as
  RoR2 uses the life. No extra life, no banner.
- **Falling off the map** plays "TOO BAD!" and its jingle as soon as Mario is 20 m below where
  he last stood with no ground under him for a long way (`Hud.TooBadDrop`), and he is put back
  where he last stood, unhurt, a little later, when the stage's kill zone takes him (or he is
  150 m down). He cannot be hurt while the screen is black. A long drop onto lower ground, as on
  a tall stage, is not a fall off the map.
- **Walls**: if the sim lets him through a wall (a hit's knock-back against one, a corner), he is
  put back where he stood (`Mario put back` in the log).
- **Unstuck**: if Mario stays wedged in place for three seconds while fallen, sliding or
  falling, he is moved to safe ground (`Mario unstuck after 3 seconds` in the log).
- **Character select**: Mario jumps on the spot with a "wahoo".
- **Arrival**: about 2.5 seconds of Delfino Plaza play once per run as he leaves the pod.

## Configuration

`BepInEx/config/com.libsms.mariotest.cfg`. The main sections are `Look.*` (model, height,
effects, smoke speed, water tint), `Sound.*`, `SpawnMusic.*`, `Sim.*` (jump, stomp and speed
rules), `Fludd.*`, `Controls.*` (camera aim, lock range, trigger curve), `Hud.*`, `Damage.*`,
`Items.*`, `FallDamage.*`, `Knockdown.*`, `Paths.*` and `Debug.*`. Each entry has a
description in the file.

## Troubleshooting

Check `BepInEx/LogOutput.log`. A healthy start shows `libsms ABI 26`, `Mario is 1.xx m tall`,
`Mario registered`, and in a run `Mario's sim started` and `Mario's view: ...`.

- *Mario looks like Commando*: extraction hasn't finished or failed; read the log. Check
  `Paths.Disc`, then restart.
- *ABI mismatch error*: you have mixed DLLs from different releases. Reinstall both from one ZIP.
- *Wrong game version*: only DLC4 (2026) is supported.

## Known limitations

- VR is not supported in this release.
- Multiplayer is new and not yet tested with two players: other players with the plugin and the disc
  assets see Mario, his FLUDD water and his coins, and a client's hits, falls and blasts are sent to
  the host. Players without the plugin see Commando.
- Yoshi is not implemented.
- The skill icons are Commando's, with Mario's buttons shown as glyphs.
- Goobo Jr.'s Mario clone is drawn in the gummy material, not a Shadow Mario skin.

## Legal

This is an unofficial fan project, not affiliated with Nintendo, Hopoo Games or Gearbox. The
package contains no game assets. All models, textures and audio are extracted on your machine
from a disc you own, and are never uploaded or redistributed. Do not share your extracted
`assets/` folder.

## Shared native audio

Both characters read BepInEx/config/Ror2Common.Audio.cfg, Output.GainDb, default -4 dB.
Restart after editing. Master and SFX/music settings also apply. No additional tone filter is enabled.
