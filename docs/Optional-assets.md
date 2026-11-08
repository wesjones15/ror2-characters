# Optional game assets

Install any of the character mods with its declared RoR2/BepInEx dependencies and
play. No GameCube disc, extracted cache, asset pack, converter or setup executable
is required. SharedFiles is an optional folder convenience package.

Without those assets:

- Mario uses a red shape, blue FLUDD water and yellow coin shapes. The water still
  comes from the gameplay simulation and uses the normal damage/resource path.
- Olimar keeps the existing Pikmin/Onion/pellet stand-ins, with a generic captain
  and generic carry definitions for all 30 Ship Repair objectives.
- Melee uses colored fighters, generic projectiles and held objects, and authored
  fallback attack/tuning data through the same Rust simulations and combat adapters.
- Missing custom arrival assets use RoR2's standard drop pod and normal exit flow.
- Missing original music, voices, sounds and decorative effects are omitted.
  RoR2's normal world/item audio remains available.

Built-in tuning, attack clocks, anchors and volumes are approximations. Providing
your own supported discs/caches enables original presentation and disc-derived
data. No extracted game content is included in the downloads.

Crossover skin entries depend on installed mods: Pianta needs Mario + Olimar,
Captain Pikachu needs Melee + Olimar, and Sunshine Luigi needs Mario + Melee.
Their earned unlocks stay the same. Each machine independently uses original
skin art, available base-character art or shapes; captain art can load without
Pikmin army art. Overview notes identify missing local presentation.

Pikmin 2 bonus gameplay uses the common supported lobby capability, independent
of Pikmin 1 art. All players need the complete required P2 data to enable Purple/
White starting squads, Onion acceptance, buds, P2 enemies and treasures. A mixed
lobby can play the base game together and shows a disc-folder explanation.
Capabilities lock at run start. Incompatible late joins are explained and
disconnected after three seconds; start a compatible new run to play together.

Sunshine flowers use orange shapes when missing; the Shine uses a yellow sphere
and a simple ordinary teleporter transition. The generated FLUDD backpack/nozzle
follows the gameplay emitter, and generated wet patches follow native water
drying. Existing procedural goop rules/surfaces remain separate from water.

To deliberately use the built-in path even with local discs/caches, start once,
set `BuiltinOnly = true` under `[Assets]` in
`BepInEx/config/Ror2Common.Assets.cfg`, then restart. This is useful for checking
a release candidate. The normal setting is automatic (`false`).

Manual acceptance: from a fresh disposable profile without discs/caches or
SharedFiles, select each offered character, exit the pod, move, use each skill,
kill an enemy, interact/use equipment, die/revive, change stages and return to the
lobby. Repeat with all three mods together. Manual RoR2 and mixed-asset co-op
validation are pending; passing builds/headless checks do not establish them.
