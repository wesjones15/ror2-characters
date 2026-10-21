# Hotfix: Mario 0.3.9 and Melee 0.3.2 (Risk of Rain 2 DLC4)

A hotfix to release-20261021, in one ZIP with all three mods, for Risk of Rain 2 **DLC4 (2026)** with BepInEx 5.4.21.0 and
RoR2BepInExPack 1.46.0 already installed. Offline and friends-only co-op only. Everyone in a multiplayer game needs the same
builds.

| Mod | Version | Folder in `BepInEx/plugins` | Native ABI | Your disc |
| --- | --- | --- | --- | --- |
| Mario | 0.3.9 | `MarioTest` (`MarioTest.dll`, `sms.dll`) | 29 | Super Mario Sunshine |
| Olimar | 0.3.15 (unchanged) | `OlimarTest` (`OlimarTest.dll`, `pikmin.dll`) | 44 | Pikmin |
| Melee | 0.3.2 | `Melee` (`Samus.dll`, `ssbm.dll`); five of its eight fighters are a first pass | 5 | Super Smash Bros. Melee, NTSC-U rev 2 |

> **Melee is not finished.** **Samus, Fox and Luigi** are the most complete. **Pikachu, Captain Falcon, Link, Yoshi and Donkey Kong are a first pass: they are not complete and not ready.** Their attacks still have to be finished and tuned, and other per-character details are missing or rough, so expect wrong, missing or placeholder moves, hitboxes, effects and numbers.

## Install

1. **Before unzipping, right-click the ZIP, choose Properties and tick Unblock** (or run `Unblock-File` on it in PowerShell),
   so Windows does not warn about the DLLs.
2. Merge the ZIP's `BepInEx` folder into your game folder (the one with `Risk of Rain 2.exe`), or into your mod manager's
   profile. Replace both DLLs of a mod you already have. Configs and extracted caches are unchanged from release-20261021.
3. The guides are in `docs/`: `Mario.md`, `Olimar.md` and `Melee.md`.

## What's new

Only the changes since release-20261021 (Mario 0.3.8, Olimar 0.3.15, Melee 0.3.1); see `CHANGELOG.md`.

**Melee 0.3.2: multiplayer.** A client can now play any Melee fighter (it used to fall back to Commando), and the other players
see it. A player's machine runs their fighter, so it plays without lag; the others run a copy from the calls it recorded
(model, animations, sounds, effects). Their hits land through the host as theirs, with their damage stat, crits, items and kill
credit, as do grabs, Yoshi's egg, Donkey Kong's bury and slap, Luigi's Cyclone pull and Fox's Reflector. **Everyone needs this
Melee build and each fighter's disc assets on their own machine.** Not yet: shots and other move objects (lasers, arrows,
bombs, eggs, Thunder) are drawn only on the machine that fired them, though their damage is real.

**Mario 0.3.9:** the Ship Repair lock that 0.3.8 put on Mario applies only in Ship Repair now; he is unlocked in every other
mode.

## Checks and known limits

- The libsms, libpikmin and libssbm test suites, the managed Mario, Olimar and shared-code checks, and Melee's native-boundary
  checks (including the multiplayer replay for all eight fighters) pass on these sources (`release.json` pins every source commit).
- **None of this was played in game before release, and Melee multiplayer has never been run between two machines.** The
  network messages that carry the fighter, its hits and its holds are untested outside the code. If it misbehaves, send both
  players' `BepInEx/LogOutput.log`.
- The ZIP contains no disc images, extracted game assets, generated audio, game DLLs or dependency DLLs. Unofficial fan project,
  not affiliated with Nintendo, HAL Laboratory, Hopoo Games or Gearbox. Do not share your extracted `assets/` folders.
- Verify the download against the `.sha256` file on the release page; `release.json` lists the SHA-256 of every file inside.
