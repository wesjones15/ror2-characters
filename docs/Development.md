# Building and releasing

For maintainers. Players should use the [release ZIPs](https://github.com/wesjones15/ror2-characters/releases) and the character guides instead.

## Get the source

Only needed to build. The five source repositories are private until they are made public, so submodule checkout works only for accounts with access; everyone else should use the release ZIPs. With access, authenticate to GitHub, then:

```powershell
git clone --branch modern/1.5.0 --recurse-submodules https://github.com/wesjones15/ror2-characters.git
cd ror2-characters
```

The five Git submodules under `sources/` pin the exact source commits used together. To initialize an existing checkout, run `git submodule update --init --recursive`. To update a component, check out its desired commit and commit the updated submodule pointer here. Releases record the source commits and SHA-256 hashes in `release.json`.

## Build the mods

Building requires Windows x64, Git, stable Rust with the MSVC toolchain, Visual Studio C++ Build Tools with a Windows SDK, and a .NET SDK supporting `netstandard2.1`. The build uses your local RoR2 DLC4 (2026) installation and its BepInEx 5.4.21.0 reference assemblies (the workspace copy `2026 Mod Stuff\RiskOfRain2_DLC4` by default). Building needs no Nintendo disc or extracted assets and does not install into a live game folder.

Work happens in the source repositories next to this one, on `modern/1.5.0` (Melee: `main`). Each has its own build script:

```powershell
# Mario: builds sms.dll and MarioTest.dll into ror2-mario\dist\MarioTest
powershell -ExecutionPolicy Bypass -File ..\ror2-mario\build.ps1 -NoInstall
# Olimar: builds pikmin.dll and OlimarTest.dll into ror2-olimar\dist\OlimarTest
powershell -ExecutionPolicy Bypass -File ..\ror2-olimar\build.ps1 -NoInstall
# Melee: runs the libssbm tests and the C# checks, builds Samus.dll and ssbm.dll, and with -Deploy stages them
powershell -ExecutionPolicy Bypass -File ..\ror2-samus\build.ps1 -Deploy
```

`-Deploy` (and Olimar's default install) stage the DLLs under the workspace's `target\BepInEx\plugins\<Plugin>\`; copy them from there into the game by hand. Nothing is ever deployed into a live game folder.

Run each library's tests before a release: `cargo test --workspace --offline --no-fail-fast` in `libsms`, `libpikmin` and `libssbm`, and the check projects under `ror2-common\tests`, `ror2-mario\tests` and `ror2-olimar\tests` (`dotnet run --project <dir> -c Release`). Some extractor tests write to `%TEMP%`; if that location is read-only for your shell, set `TEMP` and `TMP` to a folder inside the repository first.

## Prepare a release

Releases are made on GitHub directly, from the release worktree of this repository (`release-worktrees\modern\ror2-characters` on `modern/1.5.0`).

1. Bump each plugin's `BepInPlugin` version in its repository (`ror2-mario\MarioTest\Plugin.cs`, `ror2-olimar\OlimarTest\Plugin.cs`, `ror2-samus\Samus\Plugin.cs`) and commit. Every source repository must be clean and committed.
2. Add the new version's entry to `changelogs\Mario.md`, `Olimar.md` and `Melee.md`. An entry lists only what changed since that mod's previous published version.
3. Update the guides in `docs\` and the table in `README.md`, and write the release notes in `releases\<tag>.md` (they become the package's `README.md` and the release body).
4. Build everything as above, then package:

```powershell
powershell -ExecutionPolicy Bypass -File .\package-release.ps1 -Tag release-20261021 -NotesFile .\releases\release-20261021.md
```

This writes `<workspace>\<tag>\` (the three plugin folders, `docs\`, `README.md`, `CHANGELOG.md`, `release.json`) and `<tag>.zip` with its `.sha256`. `release.json` records every file's SHA-256, the plugin versions and the commit of each source repository. The script refuses to run on a dirty source repository, refuses to overwrite an existing package, and checks that the package holds only the approved files (no disc data, no `assets_dir.txt`). It works in Windows PowerShell 5.1 and never pushes or publishes.

5. Pin the sources in this repository (`git -C sources/<name> fetch ..\..\<name> modern/1.5.0`, check out the released commit, `git add sources`), and commit the docs and pins.

## Publish

Publishing is a deliberate, separate step. Push the source repositories (`ror2-common`, `ror2-mario`, `ror2-olimar`, `libsms`, `libpikmin`, and `ror2-samus` / `libssbm` for Melee) and this repository's `modern/1.5.0`, then:

```powershell
gh release create release-20261021 .\release-20261021.zip .\release-20261021.zip.sha256 --repo wesjones15/ror2-characters --target modern/1.5.0 --title "Mario 0.3.8, Olimar 0.3.15, Melee 0.3.1 (RoR2 DLC4 (2026))" --notes-file releases\release-20261021.md
```

Add `--draft` to look at it on GitHub first. Existing tags and releases are never overwritten.

Branch names express game compatibility, not mod versions: modern source branches are `modern/1.5.0`; legacy branches are `legacy/1.2.4.4`, frozen at 0.1.0.

## Older scripts

`build.ps1`, `deploy.ps1`, `publish.ps1` and `publish-line.ps1` in this repository are the first release flow (per-character ZIPs under `dist\`, one tag per character). They are not used for current releases and are kept for the 0.1.0 to 0.3.x history.
