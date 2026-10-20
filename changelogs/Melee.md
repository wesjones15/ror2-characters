# Melee changelog

Modern releases target the modern/1.5.0 game branch (DLC4, Unity 2021.3.45f2), BepInEx 5.4.21.0 and RoR2BepInExPack 1.46.0. Native ABI 5 (libssbm).

Samus was released alone as 0.2.14 through 0.2.17. 0.3.0 replaces that plugin with one Melee plugin that holds every fighter.

## 0.3.0 - 2026-10-20

A single **Melee** plugin with eight survivors. Install `Samus.dll` and `ssbm.dll` (native ABI 5) from one ZIP.
Only Samus had been played in game before this release; the seven new fighters are covered by headless tests against the
disc and native-boundary checks, not by a playtest.

**Upgrading from Samus 0.2.x: read this first.** The plugin has a new identity.

- The plugin GUID is now `com.libssbm.melee` (was `com.libssbm.samus`) and its folder is `BepInEx/plugins/Melee`
  (was `MeleeSamus`). The config file is `BepInEx/config/com.libssbm.melee.cfg`; set `Paths.Disc` again there.
- Delete `BepInEx/plugins/MeleeSamus/` and `BepInEx/config/com.libssbm.samus.cfg`. Both plugins would register Samus.
- The extracted cache lived in `MeleeSamus/assets`. Move it to `Melee/assets`, or set `Paths.AssetsDir`; otherwise the
  first launch extracts again from your disc. Fox, Luigi, Pikachu and the rest are extracted on that first launch either way.
- Costume unlocks and loadout choices are kept under the same content names (`MeleeSamus*`).

**New fighters** (each with his disc costumes, CSS portrait, announcer call and intro, pause-menu controls window, KO, and
the five-skill layout RT / LT / RB / LB / B; the skin unlocks follow stages 1, 2, 3... as that fighter):
- **Fox** (4 costumes): Blaster (spammable), Fox Illusion, Fire Fox (launches along the camera aim), and a Reflector that
  is a frame-1 area burst with damage and outward knockback around Fox.
- **Luigi** (4): bouncing Fireball (spammable, a despawn puff when it expires, it dies on walls and ceilings), Green
  Missile charged from 250% to 1600%, Super Jump Punch and Luigi Cyclone.
- **Pikachu** (4): see below.
- **Captain Falcon** (6): Falcon Punch, Raptor Boost, Falcon Dive and Falcon Kick with the disc's hitboxes.
- **Link** (5): Hero's Bow (hold to draw, charge scales damage and speed), Boomerang, Spin Attack and Bomb. The arrow,
  boomerang and bomb speeds are prototype values.
- **Yoshi** (6): Egg Lay (tongue grab), Egg Roll, Egg Throw (lobs an egg and hops) and Yoshi Bomb.
- **Donkey Kong** (5): Giant Punch, Headbutt, Spinning Kong and Hand Slap.

**Pikachu** (RT Thunder Shock, LT A, **RB Thunder**, LB Quick Attack, B Skull Bash):
- *Thunder Shock* is shot along the crosshair and bounces and reflects off surfaces, ending after ten ground bounces, like
  Luigi's Fireball (10% in flight, 6% after its first bounce).
- *Quick Attack* homes on the same lock-on Olimar and Mario use (the nearest enemy to the camera, preferring ones in front, up
  to `Combat.LockRangeMetres`, 25 m) and arrives in the source's two zips whatever the distance. Without a target it
  zips along the stick and camera, and a second zip needs a turn of at least 38 degrees or another LB press. Zips never
  rubber-band: Pikachu keeps the ground he covers.
- *Skull Bash* charges while B is held (up to 90 frames), lunges with damage and distance that grow with the charge, and
  stops on what it hits.
- *Thunder* drops a cloud and four bolt segments on Pikachu; the bolt shocks the column, and the strike (17%) electrifies the
  area around him.

**All fighters**
- Shared systems: per-fighter skill layouts and button remapping, fighter-selected select-screen intros, the GAME! banner
  with the extracted model and voice at the end of a run, the shared KO and recovery sequence, the pause-menu controls
  window, and a shared hit tracker and bouncing-shot component.
- Melee A attacks stagger a non-boss enemy for `Combat.StaggerDuration` (0.25 s, refreshed per hit; bosses and elites are exempt).
- `Combat.Armor` (default 20) sets the base armor of every Melee survivor.
- Dash attack and dash grab keep the ground their animation covers, with no snap-back at the end.
- Native: libssbm ABI 5 carries the fighter kind through every export; new exports for a lock-on target, hit notification and
  projectile reflection (used by Pikachu).

**Samus**
- Character select plays the announcer's name call, then the Screw Attack as her intro; the call plays to its end.
- The up special (Screw Attack) makes her invulnerable from launch until she lands or starts another attack.
- GAME! at the end of a run is drawn with the extracted model and voice.

Headless libssbm, native-boundary and host checks pass on all fighters. None of this was played in game before release.
