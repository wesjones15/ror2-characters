# Hotfix: everyone sees their own skin in character select (Mario 0.4.9, Olimar 0.4.4, Melee 0.4.7)

This is release-20261029 plus the floor/fire hotfix, with one more fix, in one ZIP with all three mods, for Risk of Rain 2
**DLC4 (2026)** with BepInEx 5.4.21.0 and RoR2BepInExPack 1.46.0 already installed. Offline and friends-only co-op only.
**Everyone in a multiplayer game needs these builds.**

| Mod | Version | Folder in `BepInEx/plugins` | Native ABI | Your disc |
| --- | --- | --- | --- | --- |
| Mario | **0.4.9** | `MarioTest` (`MarioTest.dll`, `sms.dll`) | 34 | Super Mario Sunshine |
| Olimar | **0.4.4** | `OlimarTest` (`OlimarTest.dll`, `pikmin.dll`) | 52 | Pikmin |
| Melee | **0.4.7** | `Melee` (`Samus.dll`, `ssbm.dll`) | 5 | Super Smash Bros. Melee, NTSC-U rev 2 |

## What's new

- **Each player's pad shows that player's own skin.** In character select, every player's mannequin was drawn in the
  local player's pick, so a friend's Mario wore your skin. Each pad now reads the loadout of the player it belongs to.
  This covers Mario, Olimar and all eight Melee fighters.
- **In the game, another player's Mario is drawn in his own skin** (it was always plain Mario).
- The 0.4.8 Mario fixes (floor rescue, no slipping on bumps, corkscrew and burn changes) from the earlier hotfix are
  included.

## If a pad still shows the wrong skin

Open `BepInEx/LogOutput.log` after a lobby and look for lines like `Lobby pad for MarioTestBody: skin 1 (PlayerName)`.
One line appears each time a pad's skin changes. If a friend's pad names *you*, or says `no pad, local player`, the pad
did not give its owner, and the log tells me which; please send the log.

## Install

1. **Before unzipping, right-click the ZIP, choose Properties and tick Unblock** (or run `Unblock-File` on it in
   PowerShell).
2. Merge the ZIP's `BepInEx` folder into your game folder or mod manager profile. Replace each mod's DLLs together.
3. `BepInEx/config` holds each mod's default settings. Merging it **resets your settings for these mods**; to keep
   yours, skip the `config` folder.
4. The guides are in `docs/`.

## Checks and known limits

- The libcommon, libsms, libpikmin and libssbm test suites, the shared recovery checks and the three plugin builds
  pass on these sources (`release.json` pins every source commit).
- **None of this has been played in game yet.** The lobby fix assumes each character-select pad knows its player; the
  log lines above show whether it does.
- The ZIP contains no disc images, extracted game assets or game DLLs. Unofficial fan project, not affiliated with
  Nintendo, HAL Laboratory, Hopoo Games or Gearbox.
- Verify the download against the `.sha256` file on the release page.
