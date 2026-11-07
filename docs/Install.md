# Installing Mario, Olimar and Melee

The three mods are separate. Install any one, two or all three. Each one also needs **SharedFiles**: a small
package with no code, holding the one folder all three use for your disc images and for what they extract from
them.

| Package | What it is |
| --- | --- |
| `wesleyasaurus-Mario` | Mario with FLUDD (needs a Super Mario Sunshine disc) |
| `wesleyasaurus-Olimar` | Olimar and the Pikmin (needs a Pikmin disc) |
| `wesleyasaurus-Melee` | Samus and Yoshi from Super Smash Bros. Melee (needs a Melee disc, USA revision 1.02) |
| `wesleyasaurus-SharedFiles` | `put_games_here/` for your discs and `assets/` for the extracted files |

## With r2modman (or another Thunderstore mod manager)

1. Install the mods you want. The manager installs SharedFiles and BepInEx with them.
2. Open the profile folder (r2modman: Settings, Browse profile folder), then
   `BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/`.
3. Put your own disc images there (see below), and start the game.

## By hand

1. Install BepInExPack 5.4.21 and RoR2BepInExPack into Risk of Rain 2 DLC4 (2026). The guides list the other
   dependency mods.
2. Right-click the downloaded ZIP, open Properties and tick **Unblock**. Otherwise Windows asks "These files might
   be harmful" when you copy the DLLs; OK is safe.
3. Unzip it and copy its `BepInEx` folder into your Risk of Rain 2 folder (the one with `Risk of Rain 2.exe`),
   merging with the `BepInEx` folder already there. It adds `BepInEx/plugins/wesleyasaurus-SharedFiles/` and one
   folder per mod: `wesleyasaurus-Mario`, `wesleyasaurus-Olimar` and `wesleyasaurus-Melee`, the same names a mod
   manager uses. Drop the mod folders you don't want.
4. Put your own disc images in `BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/`, and start the game.

## Your discs

`.iso`, `.gcm` or `.ciso`, under any file names, directly in `put_games_here/` or in one folder inside it. Each mod
reads the discs to find its own game. Convert `.rvz`, `.wia` or `.wbfs` to `.iso` first (Dolphin: right-click the
game, Convert File).

| Disc | Used by |
| --- | --- |
| Super Mario Sunshine (any region) | Mario (needed). Also Olimar's Pianta skin, once Mario has extracted it. |
| Pikmin (any region) | Olimar (needed) |
| Pikmin 2 (any region) | Olimar, optional: Louie, Pikmin 2's enemies, treasures and Candypop Buds |
| Super Smash Bros. Melee (USA, revision 1.02, `GALE01`) | Melee (needed). Optional for Mario (Luigi skin; punch and kick if the Melee mod is installed too) and for Olimar (Captain Pikachu skin). Other Melee versions are refused. |

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
4. **Put your disc images in `BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/`**, under any file names.
   With r2modman that is inside the profile folder (Settings, Browse profile folder).
5. **Start the game and let it extract.** Every mod extracts from your discs once more, even if you had a cache:
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
