> **Folder disappearing on launch?** BepInEx removes `BepInEx/plugins/RoR2BepInExPack` (case-insensitive) as obsolete. Rename it before launching, or restore the complete dependency package if already deleted, under `BepInEx/plugins/RiskofThunder-RoR2BepInExPack`. Include its supporting DLLs, including `Newtonsoft.Json.dll`. The native-runtime hotfix does not repair this folder. [Full repair instructions](https://github.com/wesjones15/ror2-characters/blob/modern/1.5.0/docs/FixStartup.md).

# Hotfix: nothing extra to install (Mario 0.3.10, Olimar 0.3.17, Melee 0.3.3; Risk of Rain 2 DLC4)

This is release-20261022 with one fix, in one ZIP with all three mods, for Risk of Rain 2 **DLC4 (2026)** with BepInEx
5.4.21.0 and RoR2BepInExPack 1.46.0 already installed. Offline and friends-only co-op only. Everyone in a multiplayer game
needs the same builds. The code, the versions and the network protocol are the same as release-20261022, so a player on that
release can still join a player on this one.

| Mod | Version | Folder in `BepInEx/plugins` | Native ABI | Your disc |
| --- | --- | --- | --- | --- |
| Mario | 0.3.10 | `MarioTest` (`MarioTest.dll`, `sms.dll`) | 29 | Super Mario Sunshine |
| Olimar | 0.3.17 | `OlimarTest` (`OlimarTest.dll`, `pikmin.dll`) | 44 | Pikmin |
| Melee | 0.3.3 | `Melee` (`Samus.dll`, `ssbm.dll`); only Samus plays as intended | 5 | Super Smash Bros. Melee, NTSC-U rev 2 |

## The fix

**The native DLLs (`pikmin.dll`, `sms.dll`, `ssbm.dll`) carry their own C runtime now.** Before, they needed Microsoft's Visual C++
2015-2022 Redistributable on the player's PC. A player without it saw nothing from the mod: Olimar's DLL failed to load
(Win32 error 126), so the Olimar plugin stopped before it registered Olimar, Ship Repair or its entry in the multiplayer mod
list, and joining a host who had them failed with **"incompatible mods: com.libpikmin.olimartest;ship-repair-abi40-v9-guests"**.
Mario's and Melee's DLLs had the same dependency. With this ZIP a player needs only the game, BepInEx, the pack and, to play a
character, that game's disc (below).

## What you still need

- Risk of Rain 2 **DLC4 (2026)**, BepInEx 5.4.21.0 and RoR2BepInExPack 1.46.0, on 64-bit Windows 10 or 11.
- For each mod you want to play, **your own disc image** of its game (the table). They are not in the ZIP and never will be:
  on the first run each mod extracts what it needs from your disc into its own asset folder (`Paths.Disc` in its config). A
  player who only joins a game does not need a disc for a character they do not play, but does need the same mod build so the
  mod list matches.

## Install

1. **Before unzipping, right-click the ZIP, choose Properties and tick Unblock** (or run `Unblock-File` on it in PowerShell),
   so Windows does not warn about the DLLs.
2. Merge the ZIP's `BepInEx` folder into your game folder (the one with `Risk of Rain 2.exe`), or into your mod manager's
   profile. Replace both DLLs of each mod.
3. `BepInEx/config` holds each mod's settings at the defaults. Merging it **resets your settings for these three mods**,
   including `Paths.Disc` and `AssetsDir` if you set them (re-enter those afterwards). To keep your own settings, skip the
   `config` folder.
4. The guides are in `docs/`: `Mario.md`, `Olimar.md` and `Melee.md`.
5. If a mod does not appear, open `BepInEx/LogOutput.log` and search for its name: a native load failure is logged there.

## Everything from release-20261022 is included

Only the DLL fix is new here (details of the rest are in `CHANGELOG.md`):

**Melee 0.3.3** (unplayed): chained attacks no longer hit for nothing; Fox's Blaster and Yoshi's Egg Throw deal damage (a tap
always fires, holding fires 6 shots a second); GAME! plays for every fighter; Thunder Jolt aims at the crosshair and bounces;
Donkey Kong idles and walks in his own pose; one short pause-menu page per fighter; a `Debug/Diagnostics` setting logs
`[MeleeDiag]` lines. **Mario 0.3.10:** Mario leads the character select except in Ship Repair; the Shine Sprite hangs above
his head; FLUDD aims toward the camera when the target is behind him. **Olimar 0.3.17:** Pikmin that fall off the map come
back to their captain unharmed; the select order above.

> **Melee status, honestly.** The whole Melee roster was played for the first time on 2026-10-22. **Only Samus plays as
> intended.** Fox, Luigi, Pikachu, Captain Falcon, Link, Yoshi and Donkey Kong all have broken or missing moves (list
> below). **None of the Melee fixes in this ZIP has been played yet.**

## Melee: known broken

From the 2026-10-22 play-test, still open:

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

## Checks and known limits

- The libpikmin, libsms and libssbm test suites and Melee's native-boundary checks pass on these sources (`release.json` pins
  every source commit). libsms passes except one stale test that still expects the L-camera crouch Mario 0.3.10 removed on
  purpose.
- Packaging now reads each native DLL's import table and refuses a ZIP whose DLL still needs the Visual C++ runtime.
- **The DLL fix was verified by reading the DLLs' imports (they now import only Windows system DLLs), not on a PC that lacks
  the runtime.** None of this release's gameplay changes was played in game before release, and Melee multiplayer has never
  been played between two machines.
- The ZIP contains no disc images, extracted game assets, generated audio, game DLLs or dependency DLLs. Unofficial fan
  project, not affiliated with Nintendo, HAL Laboratory, Hopoo Games or Gearbox. Do not share your extracted `assets/`
  folders.
- Verify the download against the `.sha256` file on the release page; `release.json` lists the SHA-256 of every file inside.
