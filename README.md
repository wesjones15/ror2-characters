> This branch is an unreleased DLC4 migration. Existing download tags below are legacy releases; do not install those ZIPs as 2026 builds. See [migration notes](docs/Modern2026.md).

# RoR2 Characters

Mario and Olimar as playable survivors in **Risk of Rain 2**. Mario brings Super Mario Sunshine's movement and FLUDD; Olimar leads a squad of Pikmin. Each character is a separate BepInEx mod with its own releases and version numbers.

**Offline and friends-only co-op only.**

| Character | Release tag | Guide (install, controls) | Changelog |
| --- | --- | --- | --- |
| Mario | `mario-v0.2.0` | [Mario](docs/Mario.md) | [Mario](changelogs/Mario.md) |
| Olimar | `olimar-v0.1.0` | [Olimar](docs/Olimar.md) | [Olimar](changelogs/Olimar.md) |

## Download

Get the character ZIP from the [releases page](https://github.com/wesjones15/ror2-characters/releases). Pick the release by its character tag (`mario-v…` or `olimar-v…`): GitHub's single repository-wide Latest label does not identify the latest release of both characters. Each ZIP contains a README with the full guide, a changelog, a checksum manifest and an installer. Both characters can be installed together.

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
2. Unzip the character release and run its installer, pointing it at the folder that contains `BepInEx`:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\install.ps1 -InstallDir "D:\Games\Risk of Rain 2"
   ```

3. Launch the game once, set `Paths.Disc` in the character's config file to your own disc image, and launch again.

The character's README in the ZIP has the details, controls and troubleshooting.

## Your disc, not ours

Both mods extract their models, textures and audio from **your own GameCube disc image** on first launch. The ZIPs contain no disc images, extracted game assets, generated music, game DLLs or dependency DLLs; only the two mod DLLs, documentation and the installer. Please don't share extracted assets.

This is an unofficial fan project, not affiliated with Nintendo, Hopoo Games or Gearbox.

## For maintainers

Building from source, deploying and publishing releases are covered in [docs/Development.md](docs/Development.md). The source repositories are private for now and will be made public later.