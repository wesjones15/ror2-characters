# Melee portraits hotfix - 2026-11-05

**Mario 0.5.6, Olimar 0.5.5, Melee 0.4.12** - based on release-20261105.

A small hotfix: Melee's generated skill portraits are kept and shown in the menus, Bowser Jr. (Shadow Mario) is hidden
from character select for now, and updating no longer overwrites your settings.

| Mod | Version | Folder in `BepInEx/plugins` |
| --- | --- | --- |
| Mario | **0.5.6** | `MarioTest` (`MarioTest.dll`, `sms.dll`) |
| Olimar | **0.5.5** | `OlimarTest` (`OlimarTest.dll`, `pikmin.dll`) |
| Melee | **0.4.12** | `Melee` (`Samus.dll`, `ssbm.dll`) |

## Melee

- Generated skill portraits are stored beside the installed plugin and are no longer replaced by vanilla fallback icons.
- Melee menus refresh when locally cached skill art arrives after they open.

## Mario

- Bowser Jr. (Shadow Mario) is hidden from character select for this release; nothing else about Mario changes.
- Rebuilt with the shared skill-icon fix. Install `MarioTest.dll` and `sms.dll` together (native ABI 47).

## Olimar

- Rebuilt with the shared skill-icon fix; no behavior changes (native ABI 62).

## Installing

- **Your settings are kept.** The ZIP no longer contains `BepInEx/config/*.cfg` or `BepInEx/plugins/gamecube_library.txt`, so merging it into your game folder cannot reset your settings or your GameCube library path. Example copies of those files are in `docs/examples/`; copy one only for first-time setup.
- Everyone in a multiplayer game needs the same builds.

Validation: the three plugins build from clean clones, and the shared checks for portraits, skill cards, skill icons and Melee character select pass. This was not played in game.
