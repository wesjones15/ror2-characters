# Asset/session candidate - 2026-11-08

Local review candidate: Mario 0.6.3, Olimar 0.6.3 and Melee 0.5.2.

- Crossover skins follow installed mods and use each player's available local art.
  Pianta and Captain Pikachu can lead stand-in Pikmin without Pikmin 1 art.
- Optional Pikmin 2 gameplay follows a common lobby capability, locked per run.
  Mixed lobbies retain base gameplay with an explanation; incompatible late joins
  wait for a compatible run.
- Missing Sunshine art uses orange flowers, a yellow Shine/simple stage exit,
  a yellow FLUDD backpack/nozzle and generated wet ground. Existing goop supports
  default simulation/surface art; unfinished Bowser Jr. remains gated.
- Generic Pikmin enemy bodies prevent invisible missing-art enemies. Flying
  stand-in Onions hide their legs; captains ascend, hide and reappear on drop.
- Luigi's Super Scope works with native built-in support without a disc.

See [implementation and validation](../docs/Asset-session-validation.md).
All three staged builds and required no-assets gates pass. Not yet played in
RoR2; mixed-assets co-op validation is pending. Optional pre-existing jump/Louie
animation checks remain documented QA issues. No original game assets are included.
