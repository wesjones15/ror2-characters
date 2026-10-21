# Melee changelog

Modern releases target the modern/1.5.0 game branch (DLC4, Unity 2021.3.45f2), BepInEx 5.4.21.0 and RoR2BepInExPack 1.46.0. Native ABI 5 (libssbm).

Samus was released alone as 0.2.14 through 0.2.17. 0.3.0 replaces that plugin with one Melee plugin that holds every fighter.

## 0.3.2 - 2026-10-21

**Multiplayer.** Install `Samus.dll` and `ssbm.dll` (native ABI 5, new exports for recording and replaying a sim). Everyone in a
game needs this build and, for each Melee fighter they play or see, that fighter's disc assets extracted on their own machine.
**Never played between two machines**: the recording and replay are tested for all eight fighters, the network messages are not.

- **A client can play any Melee fighter.** Until now a Melee fighter chosen by a client fell back to Commando. The client's
  machine runs its fighter's real simulation, so it plays without lag, and its attacks land through the host.
- **Other players see the fighter.** Each other machine runs a copy of the owner's simulation from the calls the owner recorded
  (about 20 messages a second): the same model, animations, sounds (fading with distance), effects, KO and recovery. A player
  without the mod sees a Commando; a different build is refused with one line in the log.
- **Hits land as the player's.** A client's hits go to the host, which deals them as that player's: their damage stat, crits,
  on-hit items and kill credit. So do grabs and throws, Yoshi's egg, Donkey Kong's bury and slap, Luigi's Cyclone pull, Fox's
  Reflector turning enemy shots, and the invulnerability after a KO.
- The attack code of all eight fighters now asks "does this machine own the fighter?" instead of "is this the host?", so every
  fighter works the same way.

Known: shots and other move objects (Fox's lasers, Link's arrows, boomerang and bombs, Samus's shots, Yoshi's eggs and stars,
Pikachu's Thunder, Luigi's fireballs) are drawn only on the machine that fired them, though their damage is real; hit sparks
and explosions likewise; a shield's meter is each machine's own; a late joiner sees a fighter from the next batch of calls.

## 0.3.1 - 2026-10-21

Every fighter's specials finished as the disc's own move chains, a jab 3 and rapid jab, voices, hit sparks, glows and more
effects. Install `Samus.dll` and `ssbm.dll` (native ABI 5). Config entries added: `Sim.SpeedScale` and `Visuals.RimLight`.
**Samus, Fox and Luigi are the most complete. Pikachu, Captain Falcon, Link, Yoshi and Donkey Kong are still a first
pass, and none of this was played in game before release.**

**All fighters**
- **Jab 3 and the rapid jab.** Jab, jab, jab again (Luigi, Captain Falcon and Link have a third jab) inside each jab's combo window.
  Every press and every release of A counts toward the rapid jab; once the move allows it (Fox's second jab, Captain
  Falcon's third, Link's second) enough taps start it, and it goes round again at each beat only while you keep tapping.
  A held button is one jab. Yoshi and Donkey Kong stop at jab 2; Pikachu plays his one jab again.
- **Voices.** Smash attacks grunt (one of the fighter's smash voices, picked at random), a hit that costs a fifth of your health
  or more plays a heavy hurt cry (a twentieth, a light one; Samus has none, Falcon and Donkey Kong no light one, as on the
  disc) with the common hit sounds, and the blast-zone KO plays the fighter's KO voice. Jump voices were already in.
- **Effects and presentation.** Hit sparks for every fighter's hits and shots; effects now load for Captain Falcon, Link
  and Donkey Kong, play the special-move cues and follow the joint they are bound to; Link's sword trail; faces that
  change with the animation (Fox's and Yoshi's eyes also react to knockback); colour glows and flashes (Fire Fox,
  Falcon Punch, electric flashes, Donkey Kong's punch charge, Yoshi's roll and more); and a rim glow that Luigi's fireball
  launch and Captain Falcon's smash attacks give (a Fresnel-emission approximation; `Visuals.RimLight` turns it off).
- Attacks that repeat (Blaster, Fireball, Thunder Shock, the bow, Falcon Punch, Egg Lay and Throw, Giant Punch, Hand Slap)
  have no cooldown, and a neutral special plays its clips once instead of twice.
- Grab: every fighter but Samus (who keeps her tether) has a generic enemy grab with hold, pummel and four throws.
- The controls window is generated from each fighter's real skills. Walking keeps its cycle in the legs under a mobile
  attack for every fighter. Models are scaled by the disc's own size factor (Luigi and Link grow, Samus and Pikachu shrink).
- `Sim.SpeedScale` (1.37) lifts the slowest walker, Captain Falcon, to Commando's walk speed and keeps the relative speeds.
- Shots share one surface-contact budget and despawn at 200 m. Select-screen position of Pikachu no longer collides with
  Captain Falcon's.

**Fox**: the Blaster has its gun model; the Reflector reflects enemy projectiles while it is held, stuns bosses, can be
cancelled by a jump and has no recharge; the Fire Fox select-screen intro.
**Luigi**: Green Missile charges, can misfire and flies; Super Jump Punch follows the clip's own motion and ends in the
special fall and landing lag; Luigi Cyclone hits repeatedly, pulls enemies in and rises with air taps; coins are gold; each
special's force is its own.
**Pikachu**: Thunder Shock leaves 40 degrees down and crawls along floors, walls and ceilings (200 m or 10 s at most) until it
hits something; Thunder stuns bosses and plays its bolt animation. Forward smash works again.
**Captain Falcon**: Raptor Boost follows the clip's motion, with an uppercut or a spike on contact; Falcon Dive catches
enemies (bosses too) and explodes and rebounds; Falcon Kick travels; the specials hit harder; Falcon Punch has its flame.
**Link**: the bow charges for damage and speed, the boomerang flies out and returns, the bomb is carried, thrown or dropped
and used to bomb-jump; the forward tilt and smash work again.
**Yoshi**: the flutter jump with armor and its feather effect; Egg Lay swallows enemies (bosses too, bigger than a large
enemy but not boss-sized), Egg Roll steers, Egg Throw lobs arced eggs, and the Yoshi Bomb throws stars.
**Donkey Kong**: Giant Punch stores its swings, Headbutt buries, Spinning Kong steers, and Hand Slap goes on without limit with
shockwaves and a stunlock that holds bosses.

Known: the ledge teeter, tech, ledge-grab, item-pickup and star-KO voices are not played (the port has no such states);
Yoshi's egg and Link's bomb explosions still use RoR2 effects; angled tilts and smashes and Link's second smash hit are
unreachable; the rim glow follows the silhouette, not the light's direction; the hurt-voice thresholds are a health
fraction (the original uses knockback), so they will need tuning in play. Headless tests against the disc and the native
boundary pass; see `docs/Melee.md`.

## 0.3.0 - 2026-10-20

A single **Melee** plugin with eight survivors. Install `Samus.dll` and `ssbm.dll` (native ABI 5) from one ZIP.
**Samus, Fox and Luigi are the most complete. Pikachu, Captain Falcon, Link, Yoshi and Donkey Kong are a first pass: not
complete and not ready.** Their attacks still need to be finished and tuned, and other per-character details are missing or
rough. They are covered by headless tests against the disc and native-boundary checks, not by a playtest.

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
- **Pikachu** (4, first pass): see below.
- **Captain Falcon** (6, first pass): Falcon Punch, Raptor Boost, Falcon Dive and Falcon Kick with the disc's hitboxes.
- **Link** (5, first pass): Hero's Bow (hold to draw, charge scales damage and speed), Boomerang, Spin Attack and Bomb. The arrow,
  boomerang and bomb speeds are prototype values.
- **Yoshi** (6, first pass): Egg Lay (tongue grab), Egg Roll, Egg Throw (lobs an egg and hops) and Yoshi Bomb.
- **Donkey Kong** (5, first pass): Giant Punch, Headbutt, Spinning Kong and Hand Slap.

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
