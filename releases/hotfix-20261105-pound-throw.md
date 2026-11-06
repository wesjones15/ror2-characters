# Mid-air throw, spinning pound and Pikmin rebirth hotfix - 2026-11-05

**Mario 0.5.7, Olimar 0.5.6, Melee 0.4.13** - based on hotfix-20261105-portraits.

Mario can throw a carried friend in mid-air, ground pounds can spin and be aimed, and the flaming spins steer and hit harder. Olimar's Pikmin can sprout again after dying and the Onion plucker works from a hovering Onion. Melee fighters hold their pose when frozen.

| Mod | Version | Folder in `BepInEx/plugins` |
| --- | --- | --- |
| Mario | **0.5.7** | `MarioTest` (`MarioTest.dll`, `sms.dll`) |
| Olimar | **0.5.6** | `OlimarTest` (`OlimarTest.dll`, `pikmin.dll`) |
| Melee | **0.4.13** | `Melee` (`Samus.dll`, `ssbm.dll`) |

## Mario

- **Throw in mid-air.** B while carrying a player or object, jumping or falling, throws it instead of diving, and Mario stays in his jump.
- **Spinning ground pound.** A full stick circle during a ground pound spins it, with the spin jump's swirl: the landing reaches 2.5 times as far and does 2 times the damage (`SpinPoundRadius`, `SpinPoundDamage`).
- **The ground pound can be aimed a little** with the stick in its fall, and a burn no longer cancels it.
- **Flaming spins are steerable and hit harder.** The flaming corkscrew turns and pitches much more and keeps up at Turbo speed; the flaming Rocket spin is steered by the stick. `SuperCorkscrew` damage is 40 (was 20) and `RocketSpin` 20 (was 10) by default; an existing config file keeps its old values.
- **A Rocket spin hits each enemy once per climb**, so it can no longer wedge inside a large boss and hit it over and over.
- **Luigi without FLUDD no longer wears the pack.**
- Spray keeps up with a boosted Mario (Wax Quail); bigger kills drop a ring of coins; spectating shows the watched Mario's HUD.
- Bowser Jr. stays hidden from character select, as in 0.5.6.

## Olimar

- Dead Pikmin can sprout again as buried leaves (opt-in, 60% normally and 80% in a mass death; native ABI 63).
- The Onion plucker button works on a flying Onion, and the plucker teleports back to its captain if the Onion flies far off.
- Spectating shows the watched Olimar's bottom HUD.

## Melee

- Frozen fighters hold their pose and get the icy tint; spectating shows the watched fighter's HUD.

## Installing

- **Your settings are kept.** The ZIP contains no `BepInEx/config/*.cfg` or `gamecube_library.txt`; example copies are in `docs/examples/`.
- Install each plugin's DLL pair together (`sms.dll` is ABI 47, `pikmin.dll` ABI 63, `ssbm.dll` ABI 5).
- Everyone in a multiplayer game needs the same builds.

Validation: the three plugins build from clean clones and the shared checks pass. Not played in game: the mid-air throw, spinning and aimed pound, steerable flaming spins, the Luigi pack fix, and Pikmin rebirth.
