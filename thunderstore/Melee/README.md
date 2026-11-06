# Melee

**Samus** and **Yoshi** from **Super Smash Bros. Melee** as Risk of Rain 2 survivors, with Melee's own physics, moves, hitboxes, effects and voices from your disc.

Needs your own **Super Smash Bros. Melee** disc: **USA, revision 1.02** (`GALE01`). Other versions are refused.

More fighters (Fox, Luigi, Pikachu, Captain Falcon, Link, Donkey Kong) are unfinished and hidden. To try them anyway, set `ShowUnfinished = true` in `BepInEx/config/Ror2Common.Experimental.cfg`; everyone in a multiplayer game needs the same setting.

With **wesleyasaurus-Mario** installed, Mario gets his Melee punch and kick.
## Setup

1. Install this mod with r2modman. It brings `wesleyasaurus-SharedFiles`.
2. In r2modman: Settings, Browse profile folder, then `BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/`.
3. Put your own disc images there (`.iso`, `.gcm` or `.ciso`, any names), and start the game. The first launch takes a minute while the mod copies its files from the disc.
## Your discs, your computer

- Nothing from any game disc is included. Each mod copies what it needs from **your own** disc images on the first launch, into `wesleyasaurus-SharedFiles/assets/`. Never share that folder.
- The mods make no internet connections and start no other programs; multiplayer uses Risk of Rain 2's own connection. Each is a .NET DLL plus a native DLL (`sms.dll`, `pikmin.dll` or `ssbm.dll`) that runs the character, loaded from the mod's own folder.
- **Offline and friends-only co-op.** Don't use these mods in public lobbies.
- Unofficial fan project, not affiliated with Nintendo, HAL Laboratory, Hopoo Games or Gearbox. Source, guides and changelogs: https://github.com/wesjones15/ror2-characters