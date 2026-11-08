# Managed checks CI runs

`managed-checks.txt` is the explicit list `scripts/run-checks.ps1` runs (`dotnet run`, one project per line). Checks not
on it, and why (as of the 2026-11-07 optional-assets candidate):

| Check | Why CI does not run it |
|---|---|
| `NoAssetsCheck`, `PortraitCheck` (Mario, Olimar), `IncomingBlastCheck` | take native DLL paths as arguments; the host `build.ps1` scripts run them against the built DLLs (`NoAssetsCheck` for all three mods, run in CI by the build step) |
| `SkinPresentationCheck`, `FireCheck` | compile against the game's real DLLs and run its code; the stripped NuGet references cannot |
| `ExperimentalCheck`, `CoinCheck`, `PresentationCheck`, `OnionMenuCheck` | do not compile after the optional-assets refactor: their `.csproj` files do not include the new source files they now depend on (`OptionalAssets.cs`, `PrimitiveShapes.cs`, ...). Fix the project files, then add them here |

A new check project under `tests/` is not picked up until it is added to the list.
