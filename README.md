> Mario 0.6.0, Olimar 0.6.0 and Melee 0.5.0 for the modern/1.5.0 game compatibility branch. Legacy 0.1.0 targets RoR2 1.2.4.4. See [migration notes](docs/Modern2026.md).

# RoR2 Characters

Playable survivors in **Risk of Rain 2**: Mario brings Super Mario Sunshine's movement and FLUDD; Olimar leads a squad of Pikmin; and the Melee mod adds Super Smash Bros. Melee fighters (Samus and Yoshi; six more are unfinished and hidden). Each is a separate BepInEx mod and can be installed with the others.

**Offline and friends-only co-op only.** Melee multiplayer is new and has never been played between two machines.

| Mod | Version | Guide (install, controls) | Changelog |
| --- | --- | --- | --- |
| Mario | 0.6.0 | [Mario](docs/Mario.md) | [Mario](changelogs/Mario.md) |
| Olimar | 0.6.0 | [Olimar](docs/Olimar.md) | [Olimar](changelogs/Olimar.md) |
| Melee (Samus and Yoshi; Fox, Luigi, Pikachu, Captain Falcon, Link and Donkey Kong are hidden until finished) | 0.5.0 | [Melee](docs/Melee.md) | [Melee](changelogs/Melee.md) |

## Download

Two ways, with the same files:

- **Thunderstore / r2modman:** install `wesleyasaurus-Mario`, `wesleyasaurus-Olimar` and/or `wesleyasaurus-Melee`. Each brings `wesleyasaurus-SharedFiles` (the folder for your discs) and BepInEx with it.
- **By hand:** the ZIP on the [releases page](https://github.com/wesjones15/ror2-characters/releases) holds all three mods and SharedFiles under `BepInEx/plugins`, plus `README.md` (install and what's new), `CHANGELOG.md`, the guides in `docs/`, and `release.json` with the SHA-256 of every file and the source commits it was built from. The Thunderstore packages are attached to the same release. Each mod also has its own release (`mario-v<version>`, `olimar-v<version>`, `melee-v<version>`, `sharedfiles-v<version>`) with a ZIP holding just that mod and SharedFiles.

## Requirements

| Requirement | Version |
| --- | --- |
| Risk of Rain 2 | **DLC4 (2026)** (the 2026 build, Unity 2021.3.45f2), Windows x64 |
| BepInEx | **5.4.21.0** |
| RoR2BepInExPack | **1.46.0** |
| Mario: a Super Mario Sunshine disc image | your own `.iso`, `.gcm` or `.ciso` (any region) |
| Olimar: a Pikmin disc image | your own `.iso`, `.gcm` or `.ciso` (any region) |
| Melee: a Super Smash Bros. Melee disc image | your own USA revision 1.02 (`GALE01`) `.iso`, `.gcm` or `.ciso` |

Other game builds are not supported. VR is not supported in these releases.

## Install

Install the mods, put your own disc images in `BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/` and start the game. There are no path settings. [docs/Install.md](docs/Install.md) has the steps for r2modman and by hand, which discs add what, **how to upgrade from 0.5.x / Melee 0.4.x (the plugin folders are renamed and old disc and cache locations aren't read any more)**, and how to show the unfinished fighters.

Each mod's guide has the details, controls and troubleshooting. **Upgrading from Samus 0.2.x:** Melee replaces it; delete `BepInEx/plugins/MeleeSamus` first (see the Melee guide).
## Your disc, not ours

The mods extract their models, textures and audio from **your own GameCube disc images** on first launch. The ZIPs contain no disc images, extracted game assets, generated music, game DLLs or dependency DLLs; only the mod DLLs, the documentation and a manifest. Please don't share extracted assets.

This is an unofficial fan project, not affiliated with Nintendo, HAL Laboratory, Hopoo Games or Gearbox.

## For maintainers

Building from source and publishing a release are covered in [docs/Development.md](docs/Development.md). The source repositories are private for now and will be made public later.

Olimar includes **Ship Repair**: recover 30 unique parts and carry them to your Dolphin near the teleporter to rebuild it (Mario can play it too, carrying parts by hand). See the [rules](docs/ShipPartMode.md) and [implementation/validation status](docs/ShipPartMode-Status.md). Its in-game visual and multiplayer validation remains pending.
