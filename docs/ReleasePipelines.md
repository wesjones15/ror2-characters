# Release pipelines (GitHub Actions)

Five manual workflows, all on the `modern/1.5.0` branch. Each builds from the commits pinned in `sources/`, waits for a
human to approve in the `release` environment, then creates one GitHub release.

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

## One-time setup

1. **Runner.** The plugins compile against the game's own DLLs, which cannot be on GitHub's runners, so the build job
   runs on a self-hosted Windows runner with the labels `self-hosted`, `windows`, `ror2-release` (override with the
   `RELEASE_RUNNER_LABELS` variable, a JSON array). It needs Git, stable Rust (MSVC), the .NET SDK, Windows PowerShell 5.1.
2. **Variables** (Settings, Actions): `ROR2_REFERENCE_DIR` = a DLC4 (2026) install or reference folder on the runner.
   Optional `RELEASE_WORKSPACE` = where the runner keeps its source checkouts (default `%USERPROFILE%\ror2-release-workspace`).
3. **Secret** `SOURCES_TOKEN`: a fine-grained token with read access to the eight source repositories (not needed once
   they are public).
4. **Environment** `release` with yourself as required reviewer. The publish job runs on a GitHub-hosted runner.
5. **Default branch.** GitHub only offers manual workflows that exist on the default branch (`main`). Either make
   `modern/1.5.0` the default branch or copy `.github/` to `main`.
6. **Security.** This repository is public. The workflows have no pull-request triggers and the self-hosted runner must
   stay that way. Set Settings, Actions, "Fork pull request workflows" to require approval.

## What CI checks, and what it cannot

Before building, each pipeline runs the Rust suites of the cores it ships and the managed check projects under
`ror2-common/tests`, `ror2-mario/tests` and `ror2-olimar/tests` (SkinPresentationCheck and FireCheck run only because
the runner has the game DLLs). Nothing here needs a disc image or extracted assets, so asset-dependent checks cannot be
verified in CI:

- Most Rust tests that need an extracted disc cache return early when it is absent, so they pass without checking anything.
- 34 `libsms` tests fail without the cache. They are listed in `.github/asset-bound-failures/libsms.txt`; CI tolerates
  exactly those and fails on any other failure.
- In-game behaviour is tested by hand, as before.

## Known limits

- `package-release.ps1` packages Mario, Olimar and Melee together, so every pipeline builds all three and publishes
  only its own files. A `-Only` option on that script would let one mod's release ignore the others.
- `libcommon`'s committed `Cargo.lock` is a 7-line stub, so `cargo --locked` fails on a clean checkout and CI runs
  without it. Commit the real lock file to fix that.
