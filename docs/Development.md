# Building and releasing

For maintainers. Players should use the [release ZIPs](https://github.com/wesjones15/ror2-characters/releases) and the character guides instead.

## Get the source

Only needed to build. The five source repositories are private until they are made public, so submodule checkout works only for accounts with access; everyone else should use the release ZIPs. With access, authenticate to GitHub, then:

```powershell
git clone --recurse-submodules https://github.com/wesjones15/ror2-characters.git
cd ror2-characters
```

The five Git submodules under `sources/` pin the exact source commits used together. To initialize an existing checkout, run `git submodule update --init --recursive`. To update a component, check out its desired commit and commit the updated submodule pointer here. Releases record the source commits and SHA-256 hashes in `release.json`.

## Build a character

Building requires Windows x64, Git, stable Rust with the MSVC toolchain, Visual Studio C++ Build Tools with a Windows SDK, and a .NET SDK supporting `netstandard2.0`. The build uses your local RoR2 1.2.4.4 installation and its BepInEx 5.4.21.0 reference assemblies. Install the runtime requirements in the character guide first. Players using release ZIPs do not need these build tools.

```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1 -Character Mario -Version 0.2.0 -RoR2Dir "D:\Games\Risk of Rain 2"
powershell -ExecutionPolicy Bypass -File .\build.ps1 -Character Olimar -Version 0.1.0 -RoR2Dir "D:\Games\Risk of Rain 2"
```

Outputs are `dist/Mario-0.2.0-win-x64.zip` and `dist/Olimar-0.1.0-win-x64.zip`, with unpacked copies alongside them. Building requires no Nintendo disc or extracted assets and does not install into the game. Update the character's versioned changelog before building a new version. The script refuses dirty or unpinned source checkouts and verifies the documented plugin/ABI versions against the source.

## Deploy one or both

Unzip a release, then run its `install.ps1 -InstallDir "D:\Games\Risk of Rain 2"`. Or deploy both unpacked packages with:

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy.ps1 -InstallDir "D:\Games\Risk of Rain 2" -MarioPackage .\dist\Mario-0.2.0-win-x64 -OlimarPackage .\dist\Olimar-0.1.0-win-x64
```

Use `-WhatIf` to preview installation. Deployment verifies hashes and copies only the selected character's two DLLs. It preserves your existing configuration, assets, ISO, and other mods. For a mod manager, use the active profile folder containing `BepInEx` as `-InstallDir` and launch through that profile. The target game must still be 1.2.4.4.

## Publish separate releases

Push the pinned source commits and this repository first, then:

```powershell
powershell -ExecutionPolicy Bypass -File .\publish.ps1 -Character Mario -Version 0.2.0
powershell -ExecutionPolicy Bypass -File .\publish.ps1 -Character Olimar -Version 0.1.0
```

Publishing requires an authenticated GitHub CLI, a clean committed parent repository, and a matching current build. It verifies the destination repository, package contents, hashes, and source commits before uploading. Each release has its own README and changelog on the release page, plus the ZIP, standalone README/changelog, and ZIP checksum. Use `-Draft` to create a draft. Existing tags/releases are never overwritten.
