# Release pipelines (GitHub Actions)

Five manual workflows, all on the `modern/1.5.0` branch. Each builds from the commits pinned in `sources/` on a
GitHub-hosted Windows runner, waits for a human to approve in the `release` environment, then creates one GitHub release.

| Workflow | Release tag | Assets |
|---|---|---|
| Release Mario | `mario-v<version>` | `Mario-<v>.zip` + `.sha256`, `Mario-CHANGELOG.md`, `wesleyasaurus-Mario-<v>.zip` (Thunderstore) |
| Release Olimar | `olimar-v<version>` | same, for Olimar |
| Release Melee | `melee-v<version>` | same, for Melee |
| Release SharedFiles | `sharedfiles-v<version>` | `wesleyasaurus-SharedFiles-<v>.zip` |
| Release Bundle | tag you enter (`release-YYYYMMDD`) | `<tag>.zip` + `.sha256`, `CHANGELOG.md`, the Mario, Olimar and Melee Thunderstore zips. Not the SharedFiles zip. |

Versions come from the plugin attributes and `thunderstore/packages.json`, as in `package-release.ps1`. Inputs: a notes
file in this repository (required), a title (optional), and `draft` (on by default). Existing tags and releases are
never overwritten.

```powershell
gh workflow run "Release Mario" --ref modern/1.5.0 -f notes_file=releases/mario-v0.6.1.md
```

## How it builds without the game installed

Nothing from the game or BepInEx is committed. `.github/reference-assemblies/RefGen.csproj` lists NuGet packages
(`RiskOfRain2.GameLibs`, `UnityEngine.Modules`, `BepInEx.BaseLib`, `MonoMod.*`, `Mono.Cecil`, from nuget.org and
nuget.bepinex.dev), and `.github/scripts/make-reference-dir.ps1` restores them and lays them out like the game folder
that the build scripts take as `-RoR2Dir`. Those assemblies are publicized and stripped: enough to compile, not to run.

Because they are publicized, a few members that are `protected` in the real `RoR2.dll` are `public` there, and C#
refuses an override that narrows them. The three affected overrides are wrapped in `#if PUBLICIZED_GAME_LIBS`; the
workflows build with `PublicizedGameLibs=true`, which defines it (`ror2-common/build/RoR2References.targets`). Local builds
against your real game folder are unchanged. If a new override trips the same error, wrap it the same way.

A CI-built DLL therefore differs from a local one in those three accessibility modifiers (a `public` override of a
`protected` virtual loads and behaves the same), in the compiler, SDK and Rust versions, and by one MonoMod revision
number in a reference. Test the first CI-built release in game as usual.

## One-time setup

1. **Environment** `release` (Settings, Environments) with yourself as required reviewer. Without it the publish job
   runs unattended.
2. **Default branch.** GitHub only offers manual workflows that exist on the default branch (`main`). Either make
   `modern/1.5.0` the default branch or copy `.github/` to `main`.
3. **Fork pull requests.** The workflows have no pull-request triggers. Settings, Actions, "Fork pull request workflows":
   require approval.
4. The source repositories must stay public (the build clones them without a token).

## What CI checks, and what it cannot

Before building, each pipeline runs the Rust suites of the cores it ships and the managed check projects under
`ror2-common/tests`, `ror2-mario/tests` and `ror2-olimar/tests`. It has no game files, no disc images and no extracted
assets, so these cannot be verified in CI:

- Most Rust tests that need an extracted disc cache return early when it is absent, so they pass without checking anything.
- 34 `libsms` tests fail without the cache. They are listed in `.github/asset-bound-failures/libsms.txt`; CI tolerates
  exactly those and fails on any other failure.
- `SkinPresentationCheck` and `FireCheck` need the game's real DLLs, and the stripped references cannot run, so CI skips them.
- Melee's `build.ps1` startup check loads the game's assemblies, so CI builds Melee with the same two commands without it.
- In-game behaviour is tested by hand, as before.

## Known limits

- The pins in `sources/` are what gets released. They must include the `PUBLICIZED_GAME_LIBS` commits in `ror2-common`,
  `ror2-mario` and `ror2-olimar`, and every pinned commit must already be on GitHub.
- `package-release.ps1` packages Mario, Olimar and Melee together, so every pipeline builds all three and publishes
  only its own files. A `-Only` option on that script would let one mod's release ignore the others.
- `libcommon`'s committed `Cargo.lock` is a 7-line stub, so `cargo --locked` fails on a clean checkout and CI runs
  without it. Commit the real lock file to fix that.
- `-p:RoR2Dir` for `build.ps1` in this repository (the character builds) still expects a real game folder.
