# Moon gravity and Samus missile lock-on hotfix - 2026-11-05

**Mario 0.5.8, Olimar 0.5.7, Melee 0.4.14** - based on hotfix-20261105-pound-throw.

Mario, Olimar and the Melee fighters now follow RoR2's lower moon gravity, and Samus's homing missile locks the enemy nearest your crosshair.

| Mod | Version | Folder in `BepInEx/plugins` |
| --- | --- | --- |
| Mario | **0.5.8** | `MarioTest` (`MarioTest.dll`, `sms.dll`) |
| Olimar | **0.5.7** | `OlimarTest` (`OlimarTest.dll`, `pikmin.dll`) |
| Melee | **0.4.14** | `Melee` (`Samus.dll`, `ssbm.dll`) |

## Moon gravity (all three)

- On the moon (Commencement), where RoR2 lowers gravity, Mario, Olimar and the Pikmin, and every Melee fighter now jump higher and fall slower, with the same take-off speed. Every other stage is unchanged.
- Mario's own air movement, Olimar's jumps, throws and falls, and the Melee fighters' fall gravity use the stage's gravity. Pad flights keep the gravity the pad gave them. Enemies, Melee projectile shots, Mario's goop critters and water drops are not affected.
- Native ABIs changed (Mario 48, Olimar 64, Melee 6) and Mario's network protocol is now 13: install each plugin's DLL pair together, and everyone in a multiplayer game needs the same builds.

## Melee

- **Samus's homing missile locks the enemy nearest your crosshair**, measured from the camera. Its 120 m lock range let distance outweigh the crosshair; now distance only breaks ties. Mario's and Olimar's lock-on are unchanged.

## Installing

- **Your settings are kept.** The ZIP contains no `BepInEx/config/*.cfg` or `gamecube_library.txt`; example copies are in `docs/examples/`.
- Everyone in a multiplayer game needs the same builds.

Validation: the three plugins build from clean clones and the shared checks pass. Not played in game: moon gravity (all three characters) and the missile lock-on.
