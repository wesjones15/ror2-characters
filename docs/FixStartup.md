# Fix: RoR2BepInExPack disappears when launching through Steam

BepInEx's preloader cleanup removes the obsolete folder named
`BepInEx/plugins/RoR2BepInExPack` before plugin discovery. Windows folder names
are case-insensitive: `Ror2BepInExPack` is also removed. Reinstalling into that
same folder repeats the problem.

1. Before launching, rename the existing dependency folder to
   `BepInEx/plugins/RiskofThunder-RoR2BepInExPack`.
2. If it has already disappeared, download the
   [RoR2BepInExPack dependency package](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/RoR2BepInExPack/)
   again and restore its complete plugin contents into that new folder, including
   its supporting DLLs such as `Newtonsoft.Json.dll`. Do not copy just the main DLL
   or create another nested `RoR2BepInExPack` directory at the plugins root.
3. Launch through Steam as usual. Check `BepInEx/LogOutput.log` for
   `Loading [RoR2BepInExPack` and the Mario, Olimar and Melee loading entries.
   Confirm the renamed folder remains present.

This repairs the dependency location; it does not require replacing character
DLLs or changing the multiplayer compatibility marker. The separate native-runtime
hotfix does not repair this folder. If characters remain absent after this repair,
use the startup errors in `BepInEx/LogOutput.log` to identify the remaining failure.

This exact preloader cleanup and successful startup with the renamed folder were
previously recorded in `docs/Modern2026.md`. The friend's installation has not been
tested remotely.
