> Mario 0.4.6, Olimar 0.4.2 and Melee 0.4.4 for the modern/1.5.0 game compatibility branch. Legacy 0.1.0 targets RoR2 1.2.4.4. See [migration notes](docs/Modern2026.md).

# RoR2 Characters

Playable survivors in **Risk of Rain 2**: Mario brings Super Mario Sunshine's movement and FLUDD; Olimar leads a squad of Pikmin; and the Melee mod adds eight Super Smash Bros. Melee fighters (Samus, Fox, Luigi, Pikachu, Captain Falcon, Link, Yoshi and Donkey Kong). Each is a separate BepInEx mod and can be installed with the others.

**Offline and friends-only co-op only.** Melee multiplayer is new and has never been played between two machines.

| Mod | Version | Guide (install, controls) | Changelog |
| --- | --- | --- | --- |
| Mario | 0.4.6 | [Mario](docs/Mario.md) | [Mario](changelogs/Mario.md) |
| Olimar | 0.4.2 | [Olimar](docs/Olimar.md) | [Olimar](changelogs/Olimar.md) |
| Melee (Samus, Fox, Luigi and Yoshi are the most complete; Pikachu, Captain Falcon, Link and Donkey Kong are still in progress) | 0.4.4 | [Melee](docs/Melee.md) | [Melee](changelogs/Melee.md) |

## Download

Get the ZIP from the [releases page](https://github.com/wesjones15/ror2-characters/releases). A release holds all three mods, each in its own folder under `BepInEx/plugins`, plus `README.md` (install and what's new), `CHANGELOG.md`, the guides in `docs/`, and `release.json` with the SHA-256 of every file and the source commits it was built from. The latest release is the one marked Latest; earlier ones (such as the per-character `modern-mario-v0.3.0` releases and the hotfix releases) stay available.

## Requirements

| Requirement | Version |
| --- | --- |
| Risk of Rain 2 | **DLC4 (2026)** (the 2026 build, Unity 2021.3.45f2), Windows x64 |
| BepInEx | **5.4.21.0** |
| RoR2BepInExPack | **1.46.0** |
| Mario: a Super Mario Sunshine disc image | your own `.iso`, `.gcm` or `.ciso` (any region) |
| Olimar: a Pikmin disc image | your own `.iso`, `.gcm` or `.ciso` |
| Melee: a Super Smash Bros. Melee disc image | your own NTSC-U revision 2 (`GALE01`) `.iso`, `.gcm` or `.ciso` |

Other game builds are not supported. VR is not supported in these releases.

## Install

1. Install BepInEx 5.4.21.0 and RoR2BepInExPack 1.46.0 into Risk of Rain 2 DLC4 (2026).
2. Right-click the downloaded ZIP, open Properties and tick **Unblock** (otherwise Windows asks "These files might be harmful" when you copy the DLLs; OK is safe). Unzip the release and copy the folders you want from its `BepInEx/plugins` into your Risk of Rain 2 game folder (the one with `Risk of Rain 2.exe`), merging with the `BepInEx` folder already there. With a mod manager, copy them into the active profile folder instead.
3. Launch the game once, set `Paths.Disc` in each mod's config file to your own disc image, and launch again.

Each mod's guide has the details, controls and troubleshooting. **Upgrading from Samus 0.2.x:** Melee replaces it; delete `BepInEx/plugins/MeleeSamus` first (see the Melee guide).

## Your disc, not ours

The mods extract their models, textures and audio from **your own GameCube disc images** on first launch. The ZIPs contain no disc images, extracted game assets, generated music, game DLLs or dependency DLLs; only the mod DLLs, the documentation and a manifest. Please don't share extracted assets.

This is an unofficial fan project, not affiliated with Nintendo, HAL Laboratory, Hopoo Games or Gearbox.

## For maintainers

Building from source and publishing a release are covered in [docs/Development.md](docs/Development.md). The source repositories are private for now and will be made public later.

Olimar includes **Ship Repair**: recover 30 unique parts and carry them to your Dolphin near the teleporter to rebuild it (Mario can play it too, carrying parts by hand). See the [rules](docs/ShipPartMode.md) and [implementation/validation status](docs/ShipPartMode-Status.md). Its in-game visual and multiplayer validation remains pending.
