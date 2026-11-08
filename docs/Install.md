# Installing Mario, Olimar and Melee

The three mods are separate. Install any one, two or all three and play; their declared BepInEx dependencies and the folder-only
**SharedFiles** package install with them. GameCube discs and extracted assets are optional.
Without game assets the mods use generic shapes and built-in gameplay; missing custom arrivals use RoR2 drop pods.

| Package | What it is |
| --- | --- |
| `wesleyasaurus-Mario` | Mario with FLUDD; Sunshine assets optional |
| `wesleyasaurus-Olimar` | Olimar and the Pikmin; Pikmin assets optional |
| `wesleyasaurus-Melee` | Samus and Yoshi; Melee assets optional |
| `wesleyasaurus-SharedFiles` | The `put_games_here/` and extracted-asset folders; installed with each mod, holds no code |

## With r2modman (or another Thunderstore mod manager)

1. Install the mods you want and their declared dependencies, then start the game and play.
2. Optional: to add your own discs, open the profile folder (r2modman: Settings, Browse profile folder), then
   `BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/`.
3. If you want original presentation and disc-derived tuning, put your own supported disc images there (see below) and restart.

## By hand

1. Install BepInExPack 5.4.21 and RoR2BepInExPack into Risk of Rain 2 DLC4 (2026). The guides list the other
   dependency mods.
2. Right-click the downloaded ZIP, open Properties and tick **Unblock**. Otherwise Windows asks "These files might
   be harmful" when you copy the DLLs; OK is safe.
3. Unzip it and copy its `BepInEx` folder into your Risk of Rain 2 folder (the one with `Risk of Rain 2.exe`),
   merging with the `BepInEx` folder already there. It adds `BepInEx/plugins/wesleyasaurus-SharedFiles/` and one
   folder per mod: `wesleyasaurus-Mario`, `wesleyasaurus-Olimar` and `wesleyasaurus-Melee`, the same names a mod
   manager uses. Drop the mod folders you don't want.
4. Start the game and play. Optionally put your own supported disc images in `BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/` before starting to enable their presentation/data.

## Optional discs

Crossover skin entries follow installed mods, with original/base/generic art chosen
locally. Optional Pikmin 2 gameplay is enabled only when every lobby player has
complete required P2 data, independently of P1 art. A mixed lobby explains the
disabled bonus pack; the result locks per run and incompatible late joins must
wait for a compatible new run. See [asset/session policy](Asset-session-policy-plan.md).

`.iso`, `.gcm` or `.ciso`, under any file names, directly in `put_games_here/` or in one folder inside it. Each mod
reads the discs to find its own game. Convert `.rvz`, `.wia` or `.wbfs` to `.iso` first (Dolphin: right-click the
game, Convert File).

| Disc | Used by |
| --- | --- |
| Super Mario Sunshine (any region) | Optional original Mario presentation/tuning. Also Olimar's Pianta skin, once Mario has extracted it. |
| Pikmin (any region) | Optional original Olimar/Pikmin presentation/tuning |
| Pikmin 2 (any region) | Olimar, optional: Louie, Pikmin 2's enemies, treasures and Candypop Buds |
| Super Smash Bros. Melee (USA, revision 1.02, `GALE01`) | Optional original Melee presentation/gameplay data. Also Mario's Luigi skin and borrowed punch/kick, and Olimar's Captain Pikachu skin. Unsupported versions leave the built-in path available. |

On the first launch each mod copies what it needs from your discs into `SharedFiles/assets/` (`pikmin`, `sunshine`,
`melee`), which can take a minute. Files from one disc are shared by every mod, so nothing is copied twice. After
that the discs are only read again when an update needs a file it didn't have, or changes how a file is extracted.
Without the disc, a mod keeps using the files it already has.

There are no path settings: the mods only look in `put_games_here/`. The BepInEx log says which disc a mod is
missing.

## Upgrading from Mario 0.5.x, Olimar 0.5.x or Melee 0.4.x

**Copying the new ZIP over the old install is not enough.** The plugin folders have new names, and the mods no
longer read discs or extracted files from the old places (beside each mod's DLLs, `Paths.Disc` /
`Paths.AssetsDir` in the config files, or the folder named in `gamecube_library.txt`).

1. **Move your disc images out first** if they are inside an old mod folder (for example
   `BepInEx/plugins/MarioTest/`), since the next step deletes those folders.
2. **Delete the old mod folders:** `BepInEx/plugins/MarioTest`, `BepInEx/plugins/OlimarTest` and
   `BepInEx/plugins/Melee`, and `BepInEx/plugins/gamecube_library.txt` if you made one. The mods now live in
   `wesleyasaurus-Mario`, `wesleyasaurus-Olimar` and `wesleyasaurus-Melee`. An old folder left beside a new one
   is a second copy of the same mod: BepInEx loads only one of them, and it may be the old one.
3. **Install this release**: by hand (merge the ZIP's `BepInEx` folder into the game folder) or with r2modman. If
   you switch to r2modman, delete the hand-installed folders from the game folder too, or the game started from
   Steam still loads them.
4. **Optionally put your disc images in `BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/`**, under any file names.
   With r2modman that is inside the profile folder (Settings, Browse profile folder).
5. **Start the game.** If you supplied discs, the mods may refresh their optional caches:
   extracted files are now stamped with the version of the extractor that made them, and old caches have no stamp.
   It takes a minute or two per game; the BepInEx log shows progress. Old caches (the `assets` folders that were
   inside the old mod folders, or in your `gamecube_library.txt` folder) can be deleted. Only if you no longer have
   a disc, move that game's old cache into `SharedFiles/assets/` instead (Mario's into `sunshine`, Olimar's into
   `pikmin` with its `p2` folder inside, Melee's into `melee`); without the disc, a mod keeps using the files it finds.

Your settings are kept: the config files in `BepInEx/config` keep their names, and the ZIP contains none. Their
old `[Paths]` entries are ignored; you can delete them.

**Fox, Luigi, Pikachu, Captain Falcon, Link, Donkey Kong and Bowser Jr. are hidden now** (see below). In
multiplayer everyone needs the same mods, versions and `ShowUnfinished` setting; a player whose setting differs
is refused at the lobby as an incompatible mod list.

## Unfinished content

Fox, Luigi, Pikachu, Captain Falcon, Link and Donkey Kong (Melee) and Bowser Jr. (Mario) are unfinished and hidden.
To try them anyway, set `ShowUnfinished = true` in `BepInEx/config/Ror2Common.Experimental.cfg` (created on the first
launch) and restart. In multiplayer everyone needs the same setting.

## What the mods do on your computer

- They read your disc images and write only inside `wesleyasaurus-SharedFiles/assets/` (extracted files and the
  pictures generated from them), plus their own config files in `BepInEx/config`.
- They make no internet connections and start no other programs. Multiplayer uses Risk of Rain 2's own connection.
- Each mod is a .NET DLL plus a native DLL (`sms.dll`, `pikmin.dll`, `ssbm.dll`) that runs the character. The native
  DLL is loaded from the mod's own folder.
- Nothing from any disc is included in a download. Never share your `assets` folder.
