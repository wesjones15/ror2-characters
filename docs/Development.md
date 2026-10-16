# Building and releasing

For maintainers. Players should use the [release ZIPs](https://github.com/wesjones15/ror2-characters/releases) and the character guides instead.

## Get the source

Only needed to build. The five source repositories are private until they are made public, so submodule checkout works only for accounts with access; everyone else should use the release ZIPs. With access, authenticate to GitHub, then:

```powershell
git clone --branch modern/1.5.0 --recurse-submodules https://github.com/wesjones15/ror2-characters.git
cd ror2-characters
```

The five Git submodules under `sources/` pin the exact source commits used together. To initialize an existing checkout, run `git submodule update --init --recursive`. To update a component, check out its desired commit and commit the updated submodule pointer here. Releases record the source commits and SHA-256 hashes in `release.json`.

## Build a character

Building requires Windows x64, Git, stable Rust with the MSVC toolchain, Visual Studio C++ Build Tools with a Windows SDK, and a .NET SDK supporting `netstandard2.1`. The build uses your local RoR2 DLC4 (2026) installation and its BepInEx 5.4.21.0 reference assemblies. Install the runtime requirements in the character guide first. Players using release ZIPs do not need these build tools.

For the local DLC4 loader, install the RoR2BepInExPack files together under `BepInEx/plugins/RiskofThunder-RoR2BepInExPack`. Its preloader deletes the obsolete exact folder `BepInEx/plugins/RoR2BepInExPack` at startup, including any dependencies stored there. Keep `Newtonsoft.Json.dll`, `GameAssetPaths.bin`, and `lrapi_returns.json` with the pack DLL. Verify the startup log actually loads the pack and both characters; file presence before launch alone does not prove the loader keeps them.

```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1 -Character Mario -Version 0.2.2 -RoR2Dir "D:\Games\Risk of Rain 2"
powershell -ExecutionPolicy Bypass -File .\build.ps1 -Character Olimar -Version 0.2.2 -RoR2Dir "D:\Games\Risk of Rain 2"
```

Outputs are `dist/Mario-modern-0.2.2-win-x64.zip` and `dist/Olimar-modern-0.2.2-win-x64.zip`, with unpacked copies alongside them. Building requires no Nintendo disc or extracted assets and does not install into the game. Update the character's versioned changelog before building a new version. The script refuses dirty or unpinned source checkouts and verifies the documented plugin/ABI versions against the source.

## Deploy one or both

A user unzips a release and copies its `BepInEx` folder into the game folder. To do the same from the unpacked packages:

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy.ps1 -InstallDir "D:\Games\Risk of Rain 2" -MarioPackage .\dist\Mario-modern-0.2.2-win-x64 -OlimarPackage .\dist\Olimar-modern-0.2.2-win-x64
```

Use `-WhatIf` to preview installation. Deployment copies the selected packages' `BepInEx` folders into the game's, and so only their two DLLs. It preserves your existing configuration, assets, ISO, and other mods. For a mod manager, use the active profile folder containing `BepInEx` as `-InstallDir` and launch through that profile. The target game must still be DLC4 (2026).

## Publish the compatibility line

Push the pinned source commits and this repository first, then:

```powershell
powershell -ExecutionPolicy Bypass -File .\publish-line.ps1 -Channel modern -Version 0.2.2
```

Publishing requires an authenticated GitHub CLI, a clean committed parent repository, and matching current builds. It verifies both packages, their hashes, all five source pins and the remote compatibility branches. The combined release includes both ZIPs, guides, changelogs, checksums and source manifests. Existing tags/releases are never overwritten.

Both characters start at version 0.1.0 in each game compatibility line. Modern source branches
are modern/1.5.0; legacy branches are legacy/1.2.4.4. The combined release tags are modern-v0.1.0
and legacy-v0.1.0. A tag pins the parent commit, which pins all five source submodules. The release
also attaches the exact source-commit manifest. Branch names express game compatibility, not
character mod versions. deploy.ps1 copies the packages' BepInEx folders (install.ps1 was dropped in 0.2.1).
Use publish-line.ps1 -ValidateOnly to check both packages before publishing.
