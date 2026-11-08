# Mod presence, local presentation and optional session content

Proposed policy following the 2026-11-08 asset-gate audit. This is a design and
implementation plan, not a claim that the new capability negotiation or fallback
renderers are already implemented. Normal multiplayer requires the same mod
versions, mod set and content-affecting settings.

## Three independent decisions

| Decision | Input | Effect |
| --- | --- | --- |
| Register crossover content | Installed mod set | Determines which skin/ability entries exist, identically for matching clients |
| Draw a registered feature | Each client's usable local presentation assets | Chooses original art, base-character art, or procedural stand-ins independently per component |
| Enable optional shared gameplay | Host-negotiated session capabilities | Determines whether a bonus feature participates in the shared world; assets must not make clients disagree |

Use stable native skin IDs and an explicit loadout-index mapping. Filter by mod
presence, never by local disc/cache presence. Existing earned unlock keys remain.

## Crossover registration

| Content | Mods that expose it | Local asset requirement for original art |
| --- | --- | --- |
| Olimar Pianta | Olimar + Mario | Sunshine Pianta assets |
| Captain Pikachu / Ice Climber presentation | Olimar + Melee | Corresponding Melee character assets |
| Sunshine Luigi | Mario + Melee | Melee Luigi assets |
| Mario's Piantissimo and Yoshi | Mario | Corresponding Sunshine assets |
| Louie | Olimar | Pikmin 2 Louie assets; no separate Pikmin 2 mod is required |

Louie's cosmetic selection is independent of whether the session enables Pikmin 2
bonus gameplay. His current earned unlock stays; shared Purple/White availability,
Onion acceptance, buds, enemies and treasures follow one consistent session policy.

## Independent captain and army rendering

For Pianta, select the best available local captain rendering while preserving the
selected skin identity and gameplay:

| Local assets | Captain | Army |
| --- | --- | --- |
| Sunshine + Pikmin | Pianta | Pikmin models |
| Pikmin only | Olimar model | Pikmin models |
| Sunshine only | Pianta | Procedural Pikmin |
| Neither | Procedural captain | Procedural Pikmin |

Apply the same principle to Captain Pikachu with Melee replacing Sunshine.
Objects need independent fallback choices: captain, army, Onion, enemies, pickups
and effects should not share an all-or-nothing `AssetsReady` decision.

Currently `PikminModels.Create` opens a Pikmin base view before appending alternate
captain models, and `OlimarDisplay.Create` requires base Pikmin assets. Therefore
the Sunshine-only Pianta case needs a standalone alternate-captain renderer/view;
changing `OlimarSkin.Register` alone is insufficient. Reuse existing native asset
loaders, animation/anchor contracts and shared model/primitive rendering.

Overview notes should describe the local fallback actually used: e.g. Pianta's
Sunshine art is missing and Olimar is being displayed, or Pikmin army art is missing
and the army uses stand-ins. Separate lobby text explains disabled session bonuses.

## Pikmin 2 bonus session policy

Recommended initial policy: enable the optional Pikmin 2 gameplay pack only if the
host and every connected client report the required Pikmin 2 runtime data ready.
In solo play, the local capability alone decides. Pikmin 1 art presence is not an
additional requirement. A player may have Pikmin 2 presentation with base Pikmin
stand-ins.

Implement a reusable capability exchange in `ror2-common`, using existing custom
message transport. Advertise versioned capability/readiness bits, not disc paths,
filenames or contents. The host computes the common supported set, broadcasts
the result, and all gameplay/spawn/command checks consume that same set. Readiness
means usable extracted data, not merely finding an image file. Pending extraction
is a loading state; intentionally disabled optional assets are unavailable.

Negotiate in the lobby, update when clients join/leave, and lock the result when
the run launches. Register network content independently of the result so catalogs
remain identical. Disabling a pack changes spawning/availability, not prefab IDs.

Suggested lobby message:

> You can play together. Pikmin 2 bonus content is disabled because a player is
> missing the required assets. Put a Pikmin 2 disc image in
> BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/ and restart to enable it.

Do not silently remove live enemies, change carried Pikmin colors or invalidate
objectives when a client joins during a run. Until every P2 object has a safe
no-assets representation, a late join incompatible with the locked feature set
must wait for a compatible new run, with an explicit explanation. Seamless late
join requires additional fallback support; it cannot be promised by negotiation
alone. This limitation does not prevent playing together from a mixed-assets lobby.

The alternative future policy is enabling host-supported P2 content for everyone
with complete generic representations/gameplay metadata on clients. That would
remove the all-clients-data requirement, but needs more work than negotiating a
common pack. Do not mix the two policies accidentally per feature.

## Sunshine parity additions

These are base-mod features with procedural presentation, not session-wide disc
requirements:

- Flowers and hopping flower creatures: short orange cylinders. Tall flower
  creatures: a stack of orange cylinders, following the existing authoritative
  flower-world state. Keep hiding/burrowing, positions, collision, coins, damage,
  spray and stomp interactions identical. Move the simulation and client-mirror
  readiness checks away from `Plugin.AssetsReady`; absent art must not stop them.
- Shine: yellow sphere above the charged teleporter with the existing pickup
  interaction. Without presentation assets, use a bounded simple transition and
  normal teleporter activation; skip original animation, camera path and fanfare.
  Retain the current route choice and multiplayer request/authority rules.
- Wet ground: native `WaterManager.wet_patches` already provides sampled terrain
  geometry and drying lifetime. `WaterLook` turns it into dark overlay quads;
  `MarioWater` currently reuses the disc's drop-mask texture. Supply a generated
  soft mask and expose wetness without needing a full Mario view. The current
  `MarioShapes` path only copies airborne water particles, so it does not yet
  render these wet-ground patches.
- Goop: reuse the surface-drawing infrastructure with separate authoritative goop
  data, colors, lifetime and rules. Water wetness and harmful/slippery goop are
  distinct simulation systems. Where a terrain overlay is unsuitable, use shallow
  non-colliding cylinders. Rendering creates no new collision/hazard rules.
- Bowser Jr.: keep ShowUnfinished/release availability unchanged. His eventual
  no-assets form can be a cylinder with the same goop fallback. The current goop
  world loads disc data, so removing its rendering gate alone will not provide a
  usable default simulation.
- FLUDD: add a yellow backpack cylinder to procedural Mario/Luigi and a nozzle
  marker. Use the emitter position/direction used by the actual water simulation.
  Asset-backed views currently supply animated skeleton emitters; the no-view path
  uses analytic fallback offsets. A common emitter contract/calculation is needed
  for genuine origin parity. Do not move only the drawn stream or change its hit
  origin to make the backpack look connected.

All new procedural visuals require the existing viewer-first proof, captures and
boundary checks before host presentation changes. Original asset IDs do not apply
to deliberately authored primitives. No original asset guessing is required.

## No-FLUDD Melee Mario attacks

Keep the proposed per-attacker bonus requirement: the actor needs the Melee plugin
and the Sunshine/Melee data used for combat/retargeting. Receivers do not need that
presentation to observe damage. `MarioMelee.Damage` already routes hits through
`MarioCombat.MeleeHit` / `MarioNet.OnCombat`, which applies them on the server
without loading the attack's animation there. Recorded Melee move/frame operations
are a separate presentation path.

For a receiver missing either art set, preserve the attacker's damage and selected
move, render their normal model/stand-in without a retargeted animation (or a later
simple punch cue), and omit missing sounds. Do not disable the shared attack because
a spectator/target lacks art. Verify this direction explicitly; the current network
path is supporting evidence, not an in-game test result.

## Implementation order and acceptance

1. Register crossover entries by mod presence, preserve IDs/unlocks, and split
   captain/army presentation. Test all four asset combinations above.
2. Add shared capability exchange and a lobby summary for the optional P2 pack;
   consume one session flag for related gameplay, including Onion color support.
3. Add asset-free flower and Shine parity, yellow FLUDD backpack/muzzle alignment,
   and shared generated wet/goop surface rendering. Retain current release gates
   for unfinished Bowser Jr.
4. Verify missing-asset receivers still accept No-FLUDD hits, and add safe enemy
   presentation so the known invisible-Pikmin-enemy case is eliminated.
5. Validate mixed clients with each host direction, asymmetric per-game caches,
   solo bonus content, lobby joins/leaves, locked-run late joins, stage changes,
   deaths/revives, skin identity and progression. Matching packet versions alone
   do not prove replay parity: local tuning/clocks must also agree or authoritative
   state must correct them without depending on optional animation data.
