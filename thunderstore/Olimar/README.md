# Olimar

Captain Olimar and his Pikmin from **Pikmin** as a Risk of Rain 2 survivor: pluck, throw, whistle and lead a squad that carries enemies home to the Onion, plus **Ship Repair**, a mode where you rebuild the Dolphin from 30 parts.

Needs your own **Pikmin** disc (any region). Optional extras:
- A **Pikmin 2** disc adds Louie, Pikmin 2's enemies, treasures and Candypop Buds.
- A **Melee** disc (USA, revision 1.02) adds the Captain Pikachu skin.
- With **wesleyasaurus-Mario** installed, a Pianta skin; Mario can also join Ship Repair.
## Setup

1. Install this mod with r2modman. It brings `wesleyasaurus-SharedFiles`.
2. In r2modman: Settings, Browse profile folder, then `BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/`.
3. Put your own disc images there (`.iso`, `.gcm` or `.ciso`, any names), and start the game. The first launch takes a minute while the mod copies its files from the disc.

**Used the GitHub ZIP before (Olimar 0.5.x)?** Delete the old `BepInEx/plugins/OlimarTest` folder from your Risk of Rain 2 folder (and `gamecube_library.txt` if you made one), so the old copy doesn't load beside this one, and move your disc images into `put_games_here`. Old disc paths and caches aren't read any more; the first launch extracts again. Full steps: [Upgrading](https://github.com/wesjones15/ror2-characters/blob/modern/1.5.0/docs/Install.md#upgrading-from-mario-05x-olimar-05x-or-melee-04x).

## Your discs, your computer

- Nothing from any game disc is included. Each mod copies what it needs from **your own** disc images on the first launch, into `wesleyasaurus-SharedFiles/assets/`. Never share that folder.
- The mods make no internet connections and start no other programs; multiplayer uses Risk of Rain 2's own connection. Each is a .NET DLL plus a native DLL (`sms.dll`, `pikmin.dll` or `ssbm.dll`) that runs the character, loaded from the mod's own folder.
- **Offline and friends-only co-op.** Don't use these mods in public lobbies.
- Unofficial fan project, not affiliated with Nintendo, HAL Laboratory, Hopoo Games or Gearbox. Source, guides and changelogs: https://github.com/wesjones15/ror2-characters