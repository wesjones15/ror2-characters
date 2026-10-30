# Hotfix: Mario 0.4.8 (fall-through-floor rescue, no slipping on bumps, corkscrew and burn fixes)

This is release-20261029 with five Mario fixes, in one ZIP with all three mods, for Risk of Rain 2 **DLC4 (2026)** with
BepInEx 5.4.21.0 and RoR2BepInExPack 1.46.0 already installed. Offline and friends-only co-op only. **Everyone in a
multiplayer game needs this Mario build.** Olimar and Melee are the same versions as release-20261029.

| Mod | Version | Folder in `BepInEx/plugins` | Native ABI | Your disc |
| --- | --- | --- | --- | --- |
| Mario | **0.4.8** | `MarioTest` (`MarioTest.dll`, `sms.dll`) | 34 | Super Mario Sunshine |
| Olimar | 0.4.3 | `OlimarTest` (`OlimarTest.dll`, `pikmin.dll`) | unchanged | Pikmin |
| Melee | 0.4.6 | `Melee` (`Samus.dll`, `ssbm.dll`) | unchanged | Super Smash Bros. Melee, NTSC-U rev 2 |

## What's new in Mario 0.4.8

- **Falling through the floor brings Mario back.** If the floor lets him through, he goes back to where he last stood
  as soon as he's fully under it, unhurt and with no "TOO BAD!". Before, a sealed room under the floor (Abandoned
  Aqueduct's secret room) counted as ground: he landed inside and was trapped there. Look for `Mario fell through the
  floor` in `BepInEx/LogOutput.log`.
- **The Turbo corkscrew catches fire after 1 second** of circling (was 4 s), and its one hit is the super blow.
- **Catching fire throws Mario less often.** After one burn reaction, burns in the next 15 seconds only hurt. Change
  the gap with `Knockdown.BurnPanicCooldown`.
- **No more slipping on small bumps.** Lumpy ground (Wetland Aspect's roots, rocks and mud) no longer slips Mario
  over on every little lip. Real steep slopes still slip him.
- **The dive corkscrew keeps going** as long as you keep circling the stick (a stick circle in a plain B dive). Only
  the Turbo corkscrew still stops at 6 s.

## Install

1. **Before unzipping, right-click the ZIP, choose Properties and tick Unblock** (or run `Unblock-File` on it in
   PowerShell).
2. Merge the ZIP's `BepInEx` folder into your game folder or mod manager profile. Replace both Mario DLLs together.
3. `BepInEx/config` holds each mod's default settings. Merging it **resets your settings for these mods**; to keep
   yours, skip the `config` folder. The new `BurnPanicCooldown` setting appears in your own config on first launch.
4. The guides are in `docs/`.

## Checks and known limits

- The libcommon, libsms, libpikmin and libssbm test suites, the shared recovery checks and the three plugin builds
  pass on these sources (`release.json` pins every source commit).
- **None of these fixes has been played in game yet.** The floor rescue was tested headless; the fall that showed the
  bug happened to player 2's Mario in multiplayer.
- The ZIP contains no disc images, extracted game assets or game DLLs. Unofficial fan project, not affiliated with
  Nintendo, HAL Laboratory, Hopoo Games or Gearbox.
- Verify the download against the `.sha256` file on the release page.
