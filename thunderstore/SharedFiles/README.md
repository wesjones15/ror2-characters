# SharedFiles

An optional folder for the wesleyasaurus **Mario**, **Olimar** and **Melee** mods. They work without this package, discs or extracted caches. Use it to add original presentation from your own discs. It holds no code, just two folders:

- `put_games_here/`: put your own GameCube disc images here (`.iso`, `.gcm` or `.ciso`, any file names, or one folder inside). Each mod reads them to find its own game.
- `assets/`: what the mods copy from those discs on the first launch, one folder per game (`pikmin`, `sunshine`, `melee`). Files from one disc are shared, so nothing is copied twice.

With r2modman: Settings, Browse profile folder, then `BepInEx/plugins/wesleyasaurus-SharedFiles/`. `put_games_here/README.txt` lists which discs each mod uses.

Updating or reinstalling this package doesn't need your discs again, as long as the folder's contents are kept.
## Your discs, your computer

- Nothing from any game disc is included. Each mod copies what it needs from **your own** disc images on the first launch, into `wesleyasaurus-SharedFiles/assets/`. Never share that folder.
- The mods make no internet connections and start no other programs; multiplayer uses Risk of Rain 2's own connection. Each is a .NET DLL plus a native DLL (`sms.dll`, `pikmin.dll` or `ssbm.dll`) that runs the character, loaded from the mod's own folder.
- **Offline and friends-only co-op.** Don't use these mods in public lobbies.
- Unofficial fan project, not affiliated with Nintendo, HAL Laboratory, Hopoo Games or Gearbox. Source, guides and changelogs: https://github.com/wesjones15/ror2-characters
