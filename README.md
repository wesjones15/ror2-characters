> Modern 0.2.3 for the modern/1.5.0 game compatibility branch. Legacy 0.1.0 targets RoR2 1.2.4.4. See [migration notes](docs/Modern2026.md).

# RoR2 Characters

Mario and Olimar as playable survivors in **Risk of Rain 2**. Mario brings Super Mario Sunshine's movement and FLUDD; Olimar leads a squad of Pikmin. Each character is a separate BepInEx mod. Both start at 0.1.0 in each compatibility line: modern and legacy.

**Offline and friends-only co-op only.**

| Character | Release tag | Guide (install, controls) | Changelog |
| --- | --- | --- | --- |
| Mario | `modern-v0.2.3` | [Mario](docs/Mario.md) | [Mario](changelogs/Mario.md) |
| Olimar | `modern-v0.2.3` | [Olimar](docs/Olimar.md) | [Olimar](changelogs/Olimar.md) |

## Download

Get the character ZIP from the [releases page](https://github.com/wesjones15/ror2-characters/releases). Pick the release by its character tag (`mario-v…` or `olimar-v…`): GitHub's single repository-wide Latest label does not identify the latest release of both characters. Each ZIP contains a README with the full guide, a changelog and a checksum manifest, and the `BepInEx` folder to install. Both characters can be installed together.

## Requirements

| Requirement | Version |
| --- | --- |
| Risk of Rain 2 | **DLC4 (2026)** (the 2026 build, Unity 2021.3.45f2), Windows x64 |
| BepInEx | **5.4.21.0** |
| RoR2BepInExPack | **1.46.0** |
| Mario: a Super Mario Sunshine disc image | your own `.iso`, `.gcm` or `.ciso` (any region) |
| Olimar: a Pikmin disc image | your own `.iso`, `.gcm` or `.ciso` |

Other game builds are not supported. VR is not supported in these releases.

## Install

1. Install BepInEx 5.4.21.0 and RoR2BepInExPack 1.46.0 into Risk of Rain 2 DLC4 (2026).
2. Unzip the character release and copy its `BepInEx` folder into your Risk of Rain 2 game folder (the one with `Risk of Rain 2.exe`), merging with the `BepInEx` folder already there. With a mod manager, copy it into the active profile folder instead.

3. Launch the game once, set `Paths.Disc` in the character's config file to your own disc image, and launch again.

The character's README in the ZIP has the details, controls and troubleshooting.

## Your disc, not ours

Both mods extract their models, textures and audio from **your own GameCube disc image** on first launch. The ZIPs contain no disc images, extracted game assets, generated music, game DLLs or dependency DLLs; only the two mod DLLs, the documentation and a manifest. Please don't share extracted assets.

This is an unofficial fan project, not affiliated with Nintendo, Hopoo Games or Gearbox.

## For maintainers

Building from source, deploying and publishing releases are covered in [docs/Development.md](docs/Development.md). The source repositories are private for now and will be made public later.

The `feature/ship-part-mode` branch contains the Olimar 0.3.2 **Ship Repair preview**:
recover 30 unique parts and carry them to the Dolphin to rebuild it. See the
[rules](docs/ShipPartMode.md) and [implementation/validation status](docs/ShipPartMode-Status.md).
This preview is built locally; the published stable release remains 0.2.3.
