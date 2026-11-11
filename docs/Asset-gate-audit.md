# Remaining asset gates and mixed-disc play

Source audit, 2026-11-08. This records current explicit host gates; it is not an
in-game multiplayer certification. No remaining gameplay gates were removed for
this audit. "Needs a disc" below means the extracted local cache from that game;
the image does not need to remain installed after extraction.

## Already available without discs

- Base Mario/FLUDD, Olimar/Pikmin and the eight Melee survivors start with stand-ins.
- Sunshine Mario's Luigi skin and Olimar's Louie skin remain registered without
  their optional artwork, with their existing unlock requirements.
- Mario's Il Piantissimo and Yoshi costumes are already registered independently
  of disc availability. This does not refer to Olimar's separate Pianta costume.
- Louie's starting Purple/White squad is no longer gated on Pikmin 2 artwork.
- Ship Repair no longer launches without the Pikmin and Pikmin 2 discs (from Olimar 0.8.0, on every machine); its generic part definitions stay in the code for other uses.
- Coins retain their gameplay with generic yellow shapes. Ordinary RoR2 teleporter
  interaction remains available without the optional Shine sequence.
- Missing arrival artwork uses the stock pod; missing music, voices and decorative
  effects are skipped. Generated portraits/stand-ins cover the survivor overview.

## Gameplay and costume gates still present

| Feature | Optional game/cache | Current result without it | Source |
| --- | --- | --- | --- |
| Olimar's Pianta skin | Sunshine | Omitted from the skin list | `ror2-olimar/OlimarTest/OlimarSkin.cs`, `Register`, line 294 |
| Captain Pikachu costume and Ice Climber squad presentation | Melee | Costume omitted; those models unavailable | Same registration and `PreparePikachu` |
| Candypop Buds, including Purple/White conversion and optional Queen/Pop variants | Pikmin 2 enemy/bud assets, plus a working base Pikmin view | No buds placed; placement depends on successfully loading their models | `PikminWorld.Bulbs.cs`, `LoadBulbsInto` / `PlaceBulbs`, lines 22–63 |
| Onion acceptance of Purple/White Pikmin | Pikmin 2 Pikmin-model readiness | Onion is initialized with only the three base colors despite core support for five | `PikminWorld.cs`, `PlaceOnions`, line 762 |
| Pikmin enemies and encounters: Bulborbs, bosses, Posies, Honeywisps, Breadbugs, beetles, geysers, gas pipes, Clamclamps, etc. | Relevant Pikmin/Pikmin 2 enemy tuning/model caches | Kinds with no loaded info do not spawn or start their strategies; base `TekiCatalog` loading also waits on Pikmin assets | `TekiNative.cs`, `TekiCatalog.Ready/Load`; `TekiBodies.cs:202`; `TekiSpawner.cs:42`; `TekiAi.cs:84` |
| Ship Repair treasures and treasure scoring opportunities | Pikmin 2 treasure table | No table means no treasures placed. Existing remote treasure presentation can use plain pellets when models are absent | `ShipRepairSession.Treasure.cs`, `TreasureTable` / `PlaceTreasures`, lines 111–130 |
| Sunshine flower rings, lone flowers, hopping heads and buried flower towers, including their coins/bites | Sunshine | The world does not step or accept local spray/stomp handling without base assets; not merely a missing flower renderer | `ror2-mario/MarioTest/MarioFlowers.cs:146,208` |
| Shine Sprite teleporter pickup/pose/camera sequence | Sunshine | Cannot start because it requires the Shine view. Normal teleporter use still works | `MarioShine.cs:113,193` |
| Mario's contextual Melee A attacks with No FLUDD | Melee Mario files, Melee plugin/native library, Sunshine skeleton | Native combat setup currently also requires the retargeting pose/skeleton; no built-in equivalent on that path. A legacy reflection provider is attempted separately | `MarioMelee.cs`, `Load`, lines 85–117; `MarioMeleeAttack.cs` |
| Sunshine Luigi's secret Egg Lay move | Melee plugin and its Yoshi asset readiness | Returns before starting the move | `ror2-common/src/EggLay.cs:58`; `MarioDriver.cs:912` |
| Melee Luigi's Super Scope alternative | Melee `ItCo.dat` | Scope is not equipped; fireball remains. Combat also refuses the beam. Native generic item/beam support exists underneath this host gate | `ror2-common/src/MeleeScopeBeam.cs:45`; `ror2-samus/Samus/Luigi/LuigiDriver.cs:135`; `LuigiCombat.cs:47` |
| Experimental Bowser Jr. form and goop/paint world | Sunshine | Form view fails; goop world stops stepping. Survivor registration itself is controlled by ShowUnfinished, not the disc | `KoopaJr.cs:272`; `KoopaJrGoop.cs:230`; `Plugin.cs:892` |

The Onion gate deserves particular attention now that Louie can start with Purple
and White Pikmin without Pikmin 2: starting squad support and Onion acceptance
currently make different availability decisions.

## Presentation-only gates

Original body/article/item models, animations, rendered skill cards, source HUD
art/digits, source portraits, game voices/music, Melee particle/model effects,
Mario's heat haze/screen overlays, the optional blue-lunar-coin appearance, custom
arrivals and native death/end-game presentations still depend on their respective
game files. These should remain local choices: generic geometry or standard RoR2
UI/pods where useful, silence/omission for optional decoration. An item being
drawn differently should not disable its gameplay.

## Confirmed mixed-disc hazards

1. **Pikmin enemies can be invisible.** `TekiBody.LateUpdate` always hides the
   borrowed RoR2 renderer (`TekiBody.cs:152–157`). A no-assets client has no native
   enemy model/stand-in to replace it. Host-spawned enemies therefore need a
   guaranteed local fallback before this combination is safe.
2. **Olimar skin indices differ.** Registration filters Pianta/Pikachu by local
   caches. With both caches the list is Olimar, Louie, Pianta, Pikachu. Without
   Sunshine but with Melee it is Olimar, Louie, Pikachu. Index 2 can consequently
   mean Pianta on one machine and Pikachu on another. Always register stable skin
   entries/IDs; resolve original art versus stand-in after selection.
3. **Host disc ownership changes world content.** Enemy, bud, treasure and flower
   placement still depend on the host's files. A client owning the disc does not
   supply that feature to a host that lacks it. Some client gameplay paths also
   stop at local asset checks (notably the flower/goop mirrors).
4. **Same packets do not guarantee identical replays.** Mario and Melee replay
   recorded simulation calls into local simulations. Those simulations can use
   different tuning/action clocks/hitbox data with and without caches. Mario's
   current code-only run/jump, slide/pound and four-nozzle reference checks match
   their tested traces, but that is not proof of all moves or of mixed-profile
   replay. Melee's built-in combat profile is still approximate. Olimar receives
   host snapshots, which avoids that particular input-replay assumption for its
   swarm but does not solve the rendering/content gates above.

The wire protocols check mod/native ABI and protocol versions, not which disc
images are owned. Rendering is intended to use the receiving machine's local
assets. The remaining gates mean the complete mixed-disc experience is not yet
verified or guaranteed. Everyone must also use matching ShowUnfinished/roster
settings; those are separate from disc availability.

## Proposed order for making discs presentation-only

1. Guarantee enemy/world-object fallback rendering and stable skin IDs first.
2. Remove model readiness from Onion colors, bud placement and selected weapons;
   retain gameplay checks for actual ability/charge/authority requirements.
3. Supply code-defined behavior/metadata for enemies, treasures, flowers, goop and
   the Melee Mario attack path so absent artwork cannot remove world content.
4. Use one shared gameplay profile or sufficient authoritative state for replay;
   keep optional models/animation/audio from determining gameplay on a replica.
5. Validate both directions (assets host/no-assets client and the reverse), mixed
   game-cache combinations, stage transitions, skin selection, interactions,
   attacks, deaths/revives and late join in a private test session.

This audit recommends changing those policies, but does not silently remove them.
