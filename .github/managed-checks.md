# Managed checks CI runs

`managed-checks.txt` is the explicit list `scripts/run-checks.ps1` runs (`dotnet run`, one project per line). Checks not
on it, and why:

| Check | Why CI does not run it |
|---|---|
| `NoAssetsCheck`, `PortraitCheck` (Mario, Olimar), `IncomingBlastCheck` | take native DLL paths as arguments; the host `build.ps1` scripts run them against the built DLLs (`NoAssetsCheck` for all three mods, run in CI by the build step) |
| `SkinPresentationCheck`, `FireCheck` | compile against the game's real DLLs and run its code; the stripped NuGet references cannot |

A new check project under `tests/` is not picked up until it is added to the list. A check that stops compiling
(its `.csproj` or stubs missing something a refactor added) fails the run: fix it rather than removing it from the list.
