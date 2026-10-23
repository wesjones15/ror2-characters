> Modern 0.3.3 for the modern/1.5.0 game compatibility line (native ABI 5). An offline prototype: only Samus plays as intended; the other seven fighters have known broken moves (see Status).

# Super Smash Bros. Melee for Risk of Rain 2

Version 0.3.2 (modern). One plugin, **Melee**, adds eight survivors from *Super Smash Bros. Melee*:
**Samus, Fox, Luigi, Pikachu, Captain Falcon, Link, Yoshi and Donkey Kong**. They use Commando's body and HUD, but are
moved and drawn by `ssbm.dll` (libssbm, a reimplementation of Melee's fighter physics, moves, hitboxes, effects and sound)
with the disc's own models, animations, effects and voices.

**Offline play only.** Do not run this online.

## Status

**Melee is not finished.** The whole roster was played for the first time on 2026-10-22. Only **Samus** plays as intended
(one known issue: her side-B missile's trail ends before the missile does). The other seven fighters have broken or missing
moves, listed below. Melee 0.3.3 fixes some of what that play-test found (chained attacks dealing no damage, Fox's Blaster
and Yoshi's egg dealing no damage, GAME!, Thunder Jolt, Donkey Kong's idle and walk), but **those fixes have not been played
in game yet**. Earlier notes called Fox and Luigi "most complete"; the play-test showed that was wrong.

Known broken, from that play-test:

- **Everyone except Samus:** the Z grab does not catch enemies, and close-range repeat attacks do not stunlock.
- **Fox:** Fire Fox's flame stays after the move, and in testing it had no fire, knockback or stagger. Blaster shots are
  drawn as white boxes, and the Blaster does not fire while moving. No KO light when he is knocked out.
- **Luigi:** extra Cyclone presses queue up and then do nothing. Super Jump Punch (up-B) does not start on the ground.
- **Captain Falcon:** Falcon Kick's fire is not on his leg and flickers. Falcon Punch has no forward drive. Raptor Boost
  (up-B) is weak. His character-select move has no sound.
- **Link:** the boomerang is drawn vertical. The bow is invisible and fires a bomb instead of an arrow. He cannot jump while
  drawing. The hookshot has no model. The bomb uses the wrong model and can only be pulled out or dropped, not thrown.
- **Pikachu:** Quick Attack has no effect and zips once when there is no target. The Thunder Jolt bolt does not animate.
  Thunder has no sound, leaves square artifacts, and its bolt has a black outline.
- **Yoshi:** the tongue looks short and does not catch or eat enemies, so Egg Lay never happens. Egg Roll's egg is not
  drawn, the roll cannot be cancelled, and its damage felt negligible.
- **Donkey Kong:** his tie goes through his head. The grab does not pick enemies up or carry them. Spinning Kong does not
  keep him in the air (and on the select screen it neither spins nor plays sound). Headbutt buries instead of stunning.
  Giant Punch's effects fly off and linger. His health is low for his size.

## Requirements and dependency mods

- Risk of Rain 2 **modern/1.5.0 (DLC4, Unity 2021.3.45f2)**, Windows x64.
- [BepInExPack by bbepis](https://old.thunderstore.io/package/bbepis/BepInExPack/), with BepInEx 5.4.21.0 and the supporting mods below. The ZIP does not include or install these.
- Your own **Super Smash Bros. Melee** GameCube disc image: **NTSC-U revision 2** (`GALE01`, version 1.02) as `.iso`, `.gcm` or `.ciso`. Other revisions and regions are refused. No game data is included.

| Dependency | Purpose |
| --- | --- |
| [BepInEx_GUI](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/BepInEx_GUI/) | Loader/logging interface. |
| [FixPluginTypesSerialization](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/FixPluginTypesSerialization/) | Unity serialization support for plugin types. |
| [RoR2BepInExPack](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/RoR2BepInExPack/) | RoR2 compatibility fixes; this release was checked with 1.46.0. |
| [SeekersPatcher](https://thunderstore.io/c/riskofrain2/p/pseudopulse/SeekersPatcher/) | Compatibility redirects for game updates. |
| [MiscFixes](https://thunderstore.io/c/riskofrain2/p/score/MiscFixes/) | Fixes for game bugs and mod compatibility. |

## Install

1. Install BepInExPack and the five dependencies above, as for Mario and Olimar.
2. **If you have a Samus release (0.2.x) installed, remove it first.** Delete `BepInEx/plugins/MeleeSamus/` and
   `BepInEx/config/com.libssbm.samus.cfg`. This release is a different plugin (`com.libssbm.melee`, folder `Melee`),
   and the two cannot run together: both would register Samus.
3. Unzip the release ZIP (**hotfix-20261021-melee-multiplayer.zip**). It holds Mario, Olimar and Melee, each in its own folder under
   `BepInEx/plugins`; copy the `Melee` folder (`Samus.dll` and `ssbm.dll`) into the same place in your game folder, or your
   mod manager's profile. Install the two DLLs together.
4. Launch once to create `BepInEx/config/com.libssbm.melee.cfg`, quit, and set `Paths.Disc` to the full path of your disc image:

   ```ini
   [Paths]
   Disc = D:\GameCube\Super Smash Bros. Melee (USA) (En,Ja) (Rev 2).ciso
   ```

   With `Paths.Disc` empty the plugin looks for an `.iso`, `.gcm` or `.ciso` **whose filename contains "Melee"** beside
   its DLLs, in nearby parent folders and their `iso backups` folders, and in the `SSBM_DISC` environment variable.
5. Launch the game and let first-run extraction finish (a worker thread; the survivors are listed but wait for it).
   The cache is built in `BepInEx/plugins/Melee/assets/` and reused afterwards. Set `Paths.AssetsDir` to keep it
   elsewhere, for example to reuse the cache a Samus 0.2.x install built in `plugins/MeleeSamus/assets` (move it, or point
   `Paths.AssetsDir` at it). Each fighter extracts its own files; one failing does not disable the others.

The native ABI must match: install `Samus.dll` and `ssbm.dll` from one ZIP. This release uses ABI 5.

## Controls

The same five-skill layout for every fighter. Pad buttons are read by position, so your RoR2 binds do not change them.

| Input | Gamepad | Keyboard and mouse |
| --- | --- | --- |
| Move | left stick | RoR2 movement |
| Jump (A, then double jump) | A | Jump |
| Sprint | left stick click | Sprint |
| Neutral special | RT | Primary |
| Contextual A attack | LT (stick direction picks the attack; a flick and hold charges a smash) | Secondary |
| Side special | RB | Utility |
| Up special | LB | Special |
| Down special, or Shield / Air Feint | B | C |
| Grab (Samus: tether) | X, unless a RoR2 interact prompt is up | Interact |

- **Jab combo and rapid jab.** Tap LT to jab, and tap again inside the combo window for jab 2 (and jab 3 for Luigi,
  Captain Falcon and Link). Fox, Captain Falcon and Link also have a **rapid jab**: every press and release of LT counts, and enough
  taps at the right moment start it; keep tapping to keep it going. A held button is a single jab.
- **Camera as direction.** With the stick held, camera pitch picks up attacks (20 degrees above level) and down attacks
  (50 degrees below) for LT.
- **Shield / Air Feint.** Choose it in the fifth loadout row to replace B's down special with a ground shield and one
  evade per airtime.
- **Pikachu's layout is shuffled**: RB is Thunder (his down special), LB is Quick Attack, and B is Skull Bash.
- The controls window beside RoR2's pause menu lists the current fighter's buttons.

## The fighters

All of these are adaptations to a 3D, health-and-items game: cooldowns, damage coefficients and some travel distances are
RoR2 choices. Moves, hitboxes, animations and effects come from the disc.

| Fighter | RT | RB | LB | B |
| --- | --- | --- | --- | --- |
| **Samus** | Charge Shot (tap again to fire, jump to store) | Missile; a quick direction fires a Super Missile | Screw Attack | Bomb |
| **Fox** | Blaster | Fox Illusion | Fire Fox | Reflector (area burst) |
| **Luigi** | Fireball (bounces) | Green Missile (hold to charge) | Super Jump Punch | Luigi Cyclone |
| **Pikachu** (first pass) | Thunder Shock | **Thunder** | Quick Attack | Skull Bash (hold to charge) |
| **Captain Falcon** (first pass) | Falcon Punch | Raptor Boost | Falcon Dive | Falcon Kick |
| **Link** (first pass) | Hero's Bow (hold to draw) | Boomerang | Spin Attack | Bomb |
| **Yoshi** (first pass) | Egg Lay (tongue grab) | Egg Roll | Egg Throw | Yoshi Bomb |
| **Donkey Kong** (first pass) | Giant Punch | Headbutt | Spinning Kong | Hand Slap |

Samus keeps her grapple (X: tether to enemies, pull a boss toward her, pummel and throw a captured enemy) and
stored Charge Shot.

**Pikachu in detail** (first pass)
- *Thunder Shock* leaves along your crosshair (40 degrees down when you aim level), then crawls along the floor, walls
  and ceilings it touches until it hits an enemy (200 m or 10 s at most): 10% in flight, less once it has touched a surface.
- *Skull Bash*: hold B to charge up to 90 frames, release to lunge; damage runs from 4% and distance grows with the charge. It
  stops on whatever it hits.
- *Quick Attack*: two zips. It homes on your **lock-on**, the enemy nearest where the camera points (preferring ones in front,
  like Olimar and Mario's lock-on), within `Combat.LockRangeMetres` (25 m), and arrives within those two zips even if far.
  With no enemy it zips along the stick and camera pitch (or straight along the camera with no stick); turn the stick at least
  38 degrees, or press LB again, for the second zip.
- *Thunder*: a cloud and bolt come down on Pikachu; the bolt shocks enemies in its column, then the strike electrifies
  everything around him (17%).

## Multiplayer

Melee works in offline, friends-only co-op. **Everyone who plays or sees a Melee fighter needs the same Melee release**
(`Samus.dll` and `ssbm.dll` from one ZIP) **and that fighter's disc assets extracted on their own machine**; a player
without the mod sees a Commando, and a different build is refused with one line in the log.

- A player's machine runs their fighter, so they play without lag. The other players' machines run a copy of it from the calls
  it recorded: the same model, animations, sounds (they fade with distance), effects, KO and recovery.
- Their hits land through the host as that player's: their damage stat, crits, on-hit items and kill credit. So do grabs,
  Yoshi's egg, Donkey Kong's bury and slap, Luigi's Cyclone pull, Fox's Reflector and the invulnerability after a KO.
- **Not yet:** shots and other move objects (Fox's lasers, Link's arrows, boomerang and bombs, Samus's shots, Yoshi's eggs and
  stars, Pikachu's Thunder) are drawn only on the machine that fired them, though their damage is real. A shield's meter is
  each machine's own.
- **It has never been played between two machines.** The recording and replay are tested for all eight fighters; the network
  messages are not. If something is wrong, send both players' `BepInEx/LogOutput.log`.

## Costumes

Each fighter has his disc costumes (Samus 5, Fox 4, Luigi 4, Pikachu 4, Captain Falcon 6, Link 5, Yoshi 6, Donkey Kong 5).
The first is available; the others unlock permanently after you complete the teleporter event of stage 1, 2, 3 and so on as
that fighter. Pick them in the loadout's skin row.

## In a run

- You arrive as a figure on Melee's entry platform and transform. Falling off the map plays the Melee KO and returns you as a
  figurine on safe ground, then flashes invulnerable; it never adds stocks.
- A knockdown rejects further hits through get-up and for a second afterwards; RoR2 stun extends this.
- Character select plays the fighter's announcer call and an intro move, then idles. Death plays the fighter's fall and the
  Melee KO; at the end of a run the **GAME!** banner and voice play.
- Melee A attacks stagger a non-boss enemy for `Combat.StaggerDuration` (0.25 s).

## Configuration

`BepInEx/config/com.libssbm.melee.cfg`: `Paths.AssetsDir`, `Paths.Disc`, `Sim.MetresPerUnit` (0.1: world metres per Melee unit;
movement, reach and model share it), `Sim.JumpScale`, `Sim.SpeedScale` (1.37: walk and run speed), `Visuals.RimLight` (the glow some moves give), `Combat.Armor` (20), `Combat.StaggerDuration`,
`Combat.LockRangeMetres` (Pikachu's lock-on), Samus's `Combat.MissileRangeMetres`, `Combat.MissileDamageScale` and
`Combat.ChargeShotHitboxScale`, `Controls.HoldCharge` (Samus: hold and release to fire, instead of tap to start and tap again to fire) and
`Debug.LogEffects`.
Each entry has a description in the file.

## Troubleshooting

Check `BepInEx/LogOutput.log`. A healthy start shows `Melee 0.3.2 registered` early and, after the game loads,
`Melee 0.3.2 / libssbm ABI 5 loaded` then `Melee assets extracted from your disc` the first time.

- *A fighter looks like Commando*: its assets are missing or extraction failed; read the log, check `Paths.Disc`, restart.
- *Two Samus entries / duplicate registration*: the old `MeleeSamus` plugin is still installed; delete it.
- *ABI mismatch error*: you mixed DLLs from different releases. Reinstall both from one ZIP.
- *Wrong game version*: only DLC4 (2026) is supported.

## Known limitations

- See Status above for the moves known to be broken. Only Samus plays as intended.
- Multiplayer is new and has never been played between two machines (see Multiplayer above). Shots and other move objects are drawn only on the machine that fired them.
- Link's arrow, boomerang and bomb speeds, and some travel scales, are prototype values; shield tilt, powershield reflection,
  hitlag and percent-based knockback are not implemented.
- Pikachu: the Quick Attack's body tilt and Skull Bash's wall rebound are not done, and the particles for the Thunder
  Shock's contact and fizzle are best guesses.
- Voices: smash grunts, hurt cries and the KO voice play. A hurt cry depends on how much of your health the hit took (the
  original uses knockback): a twentieth for a light cry, a fifth for a heavy one. The ledge, tech, item and star-KO voices are
  not played because the port has no such states.
- The angled tilts and smashes and Link's second smash hit are unreachable.
- Yoshi's egg and Link's bomb explosions still use RoR2's effects. The rim glow follows the silhouette, not the light.
- VR is not supported.

## Legal

This is an unofficial fan project, not affiliated with Nintendo, HAL Laboratory, Hopoo Games or Gearbox. The package contains
no game assets. All models, textures and audio are extracted on your machine from a disc you own, and are never uploaded or
redistributed. Do not share your extracted `assets/` folder.
