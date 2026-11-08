# Mario 0.6.2, Olimar 0.6.2 and Melee 0.5.1 — candidate

Changes since the previous release:

- GameCube discs and extracted assets are optional. Mario has a red stand-in and
  blue FLUDD water, Olimar retains its existing stand-ins, and Melee fighters and
  projectiles use generic models when game assets are missing.
- Built-in gameplay profiles run without asset files. Missing original sounds,
  music and decorative effects are omitted; missing custom arrivals use RoR2's
  normal drop pod. Mario's coin gameplay and all 30 Ship Repair objectives also
  have fallbacks.
- Shared primitive displays/materials/pooling reduce duplicated fallback code.
  Mandatory C# no-assets checks run against the real native DLLs before staging.
- SharedFiles is an optional convenience package rather than a required character
  dependency. Original presentation and disc-derived data remain available from
  the player's own supported discs/caches. No game assets are included.

The fallback's tuning and move timing are authored approximations. This is a
candidate for manual testing: **not yet played in RoR2**. Clean-profile drop-pod,
full skill/progression, stage-transition and co-op acceptance checks remain pending.
An additional optional Louie anchor check fails against both this candidate and
the previous release DLL with the same cache; see `docs/Optional-assets-validation.md`.
