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

- **Thunderstore / r2modman:** install `wesleyasaurus-Mario`, `wesleyasaurus-Olimar` and/or `wesleyasaurus-Melee` with their declared BepInEx dependencies and play. GameCube discs and the folder-only `wesleyasaurus-SharedFiles` package are optional.
- **By hand:** the ZIP on the [releases page](https://github.com/wesjones15/ror2-characters/releases) holds all three mods and SharedFiles under `BepInEx/plugins`, plus `README.md` (install and what's new), `CHANGELOG.md`, the guides in `docs/`, and `release.json` with the SHA-256 of every file and the source commits it was built from. The Thunderstore packages are attached to the same release. Each mod also has its own release (`mario-v<version>`, `olimar-v<version>`, `melee-v<version>`, `sharedfiles-v<version>`) with a ZIP holding just that mod and SharedFiles.

## Requirements

| Requirement | Version |
| --- | --- |
| Risk of Rain 2 | **DLC4 (2026)** (the 2026 build, Unity 2021.3.45f2), Windows x64 |
| BepInEx | **5.4.21.0** |
| RoR2BepInExPack | **1.46.0** |

Other game builds are not supported. VR is not supported in these releases.

## Install

Install the mods and start the game. Without GameCube assets, Mario and Melee use colored generic shapes, Olimar keeps its existing stand-ins, FLUDD water and projectiles remain visible, and missing custom arrivals use RoR2's drop pod. Missing game audio/effects are omitted. Built-in gameplay tuning and timing are approximate.

Optionally put your own supported disc images in `BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/` to add original models, animation, sound and disc-derived data. [docs/Install.md](docs/Install.md) covers installation, optional discs, upgrades and unfinished fighters. [docs/Optional-assets.md](docs/Optional-assets.md) describes the fallback and test setting.

Each mod's guide has the details, controls and troubleshooting. **Upgrading from Samus 0.2.x:** Melee replaces it; delete `BepInEx/plugins/MeleeSamus` first (see the Melee guide).
## Your disc, not ours

The mods extract their models, textures and audio from **your own GameCube disc images** on first launch. The ZIPs contain no disc images, extracted game assets, generated music, game DLLs or dependency DLLs; only the mod DLLs, the documentation and a manifest. Please don't share extracted assets.

This is an unofficial fan project, not affiliated with Nintendo, HAL Laboratory, Hopoo Games or Gearbox.

## For maintainers

Building from source and publishing a release are covered in [docs/Development.md](docs/Development.md). The source repositories are private for now and will be made public later.

Olimar includes **Ship Repair**: recover 30 unique parts and carry them to your Dolphin near the teleporter to rebuild it (Mario can play it too, carrying parts by hand). See the [rules](docs/ShipPartMode.md) and [implementation/validation status](docs/ShipPartMode-Status.md). Its in-game visual and multiplayer validation remains pending.

## License and credits

Original contributions by **wesleyasaurus** are dedicated to the public domain under
[CC0 1.0 Universal](LICENSE), to the extent wesleyasaurus owns the relevant rights.
Attribution for those contributions is appreciated but not required. Third-party software
and original game content retain their respective rights and terms.
See [CREDITS.md](CREDITS.md) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
