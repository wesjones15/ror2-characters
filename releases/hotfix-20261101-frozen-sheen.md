# Frozen sheen and Pikmin 2 bodies hotfix - 2026-11-01

**Mario 0.5.4, Olimar 0.5.3, Melee 0.4.10** - based on hotfix-20261101-pikmin-colours.

A small hotfix for what was played after the last build: frozen characters now read as frozen, a Shine Get cannot be
interrupted, FLUDD can pump out of long falls, and Purple and White Pikmin load their Pikmin 2 bodies even without
Louie's cache.

## Mario

- **Every Mario pales when frozen.** RoR2's `FrozenState` (a Glacial elite's death blast) now gives Mario, and every
  skin, the same icy sheen a frozen Pikmin gets, instead of only holding his input.
- **A Shine Get cannot be interrupted.** Touching the Shine grants hidden invincibility at once (the server grants it
  for a client's Mario too), so a hit can no longer cut the pickup or the pose short; if the pose is lost anyway, the
  demo ends instead of playing beside an idle Mario.
- **FLUDD can pump out of a long fall.** Hover and Rocket work during RoR2's long drops instead of waiting for the
  flail to end.
- **Water runs at one pace.** The wet slide's spray, the runoff drips and the other nozzles use the Spray's 1.4 speed;
  Yoshi's juice keeps its own rate.
- Install the updated `MarioTest.dll` and `sms.dll` together: this build is native ABI 43.

## Olimar

- **Olimar and every skin pale when frozen.** RoR2's `FrozenState` now gives the drawn captain the same icy sheen a
  frozen Pikmin gets, including Pianta, Louie and Captain Pikachu.
- **Purple and White Pikmin load without Louie's cache.** Their Pikmin 2 bodies are read from the shared P2 asset
  folder too, and an Onion takes all five colours whenever those bodies load.
- **Pikmin 2 props stay put.** The Iridescent Flint Beetle and Pellet Posy are drawn at the strategy's position
  instead of bobbing with the borrowed body's foot.
- Olimar's native ABI, Pikmin protocol and snapshot format are unchanged from 0.5.2.

## Melee

Melee 0.4.10 is unchanged; the DLLs are the same build as the previous release.

## In all three

- Everyone in a multiplayer game needs the same Mario build; the Olimar build must still match on every machine.
- Frozen characters now use the shared `ModelView` sheen, so Mario and Olimar look the same as frozen Pikmin.

Validation: the libsms suite (including the new long-fall and water-pacing tests), the libpikmin suite, `MpCheck`, the
Olimar blast/melee check and the three plugin builds pass. Not yet played in a two-player game.

---

# Pikmin colours and Onion quality-of-life hotfix - 2026-11-01

**Mario 0.5.3, Olimar 0.5.2, Melee 0.4.10** - based on hotfix-20261101-nozzle-switch-sound.

This hotfix is mostly about the squad: every Pikmin colour now has its Pikmin 2 job, the squad is less likely to be
wiped by one swing, the Onion can be called over to heal, and jump pads work the same from a client as from the host.
Mario's buried flower enemies now appear for every player, and Melee's character portraits are framed on the face.

## Mario

- **A buried sambo's flower now shows for every player.** While a flower tower or a sambo head is under the ground, the
  plain flower that marks the spot is drawn on every machine, not just the host's, and any Mario can spray it open.
- **Jump pads keep their full arc more reliably.** The shared air-control marker RoR2 clears on the first movement hit
  is latched for a moment, so a pad's gravity and flight are not lost between reads.
- **No empty pickup square.** With `Look.ItemDisplays` off, RoR2's new-item highlight no longer draws a square around a
  display that is hidden on our bodies.

## Olimar

- **Every colour has its job.** Yellow hits airborne and Mechanical enemies for 1.5x. White applies RoR2 poison, and
  repeated White hits extend it instead of multiplying its damage. Purple takes 30% less hit damage. Red is immune to
  fire blasts and fire trails such as elite trails and Fiery Bulborb breath. Blue takes 40% less damage in stage water,
  and one thrown out of water keeps a 1.5x hit bonus for 5 s.
- **The squad survives a swarm.** An enemy melee swing catches at most the two nearest Pikmin (four for champions and
  elites), each for twice the swing's damage, and a Pikmin that lands a hit is immune to other swipes for 0.3 s.
  Pikmin regenerate 4% of their max health a second, 12% a second after 6 s without one hurt, plus a share of Olimar's
  regeneration (Cautious Slug, Titanic Knurl, level), doubled by Rejuvenation Rack.
- **Jump pads work from a client.** The pad's own throw now reaches the host's simulation, so a client Olimar's squad
  gets the same launch and arc as the host's instead of only following his pose.
- **The Onion can heal him.** RT + RB (keyboard: hold Z, tap F) calls the Onion to heal from its stored Pikmin and stays
  low over him; RT + LT still calls it to board. A called Onion tracks him while he moves, and a rescue or heal visit no
  longer leaves the Onion menu open afterwards.
- **Onion Ride fixes.** He drops out of the Onion's bottom when a ride ends, keeps his heading through a moving pickup,
  lets the Onion take the stick on the boarding step, and the beam is centred over him.
- **Candypop Buds** now offer White and Purple reliably alongside the Pikmin 1 colours.
- **Carrying and the flying Onion look right.** Pikmin face the carried object's centre, a pellet being sucked rides the
  Onion's beam when the Onion moves, and climbers use the leg the Onion actually draws, including a leaning or flying
  Onion.
- **Gait and throw animation.** The captain's gait loops inside the clip's own loop keys, keeps its place across clip
  changes and no longer flickers at low stick speeds; a locked-on rapid throw now catches a sprinting captain.
- **Stage cards in Pikmin lettering.** Every stage opens with the five-second DAY card in the Pikmin 2 lettering and
  RoR2's stock stage card is hidden.
- **Dolphin landing effects.** The touchdown cloud stops growing, the takeoff smoke is capped, and landing dust clears
  within a second.
- **Skill bar.** The two-button chord glyphs are scaled down so they no longer overlap the next icon, and Onion Ride's
  description is shorter.
- **Multiplayer build check.** A host and client whose Pikmin snapshot formats differ are now refused with one log line
  instead of silently drawing no Pikmin. Install the same Olimar build on every machine.

## Melee

- **Head-and-shoulders portraits for all eight fighters.** The crop is a fraction of each fighter's height, so Samus's
  cannon, DK's arms or a spread idle pose cannot zoom the body out; Pikachu, Yoshi and DK get a taller crop for their
  larger heads. The new framing has its own cache revision, so Mario's and Olimar's portraits are untouched.

## In all three

- **Everyone in a multiplayer game needs these builds.** Olimar's snapshot format changed, so the plugin now compares it
  as well as the ABI and protocol and logs a mismatch instead of running with no Pikmin on screen.
- **Item displays.** With item displays off, the floating new-item highlight no longer boxes an invisible display.
- **Jump pads.** The shared pad marker is latched, so a pad flight is not mistaken for ordinary knockback.

Validation: the libpikmin suite (including the snapshot round-trip), the three plugin builds, the managed/native startup
checks and the shared checks pass. Not yet played in a two-player game.

---

# Nozzle switch sound hotfix - 2026-11-01

**Mario 0.5.2, Olimar 0.5.1, Melee 0.4.9** - based on hotfix-20261101-portraits.

- Restores Sunshine's original nozzle-change sounds when tapping RB / Special to switch between Spray and the selected alternate. The two directions use the source game's distinct selection cues.
- The radial menu keeps its separate new-nozzle pickup sound and sparkle. State refreshes, late joins and unchanged selections do not replay a switch.
- Install the updated MarioTest.dll and sms.dll together. All portrait-cache and skin UI changes from the previous hotfix are included; Olimar and Melee binaries are unchanged.

Validation: source IDs 0x0812 / 0x0811 resolve and produce audible PCM through the shared scene-audio path. Nozzle scenarios, native boundary checks, the managed/native startup check and network replay checks pass. Not yet played in RoR2.

Keywords: 0.5.3, 0.5.2, 0.4.10, Pikmin colours, Purple, White, Yellow, Red, Blue, Onion, jump pad, portraits, multiplayer.

---

# Portrait and skin UI hotfix - 2026-11-01

**Mario 0.5.1, Olimar 0.5.1, Melee 0.4.9** - based on release-20261031.

- Generated character, skin and skill portraits now persist across launches. Only missing or invalid pictures regenerate; routine mod releases keep the cache unless the portrait revision changes.
- Melee character portraits use the existing character-select idle pose with the shared 45-degree-left framing. Original CSS pictures remain fallbacks.
- Mario and Olimar's character-select names and character-containing skill pictures follow the selected skin. The same pictures appear in the HUD cooldown slots. Mario's skins remain Luigi, Il Piantissimo and Yoshi; Olimar's remain Louie, Pianta and Captain Pikachu when their assets are available.
- Air Pump, Onion Ride and the sprout passive retain their shared artwork. Overview <!> notes have blank lines between them.
- Staging and packaging now reject feature-branch sources; this hotfix uses modern/main sources and retains the previous release's native DLLs.

The first launch can hitch while missing pictures generate. Later launches load the saved pictures without portrait camera rendering. Builds, cache/UI/API checks and native boundaries are verified; this hotfix has not yet been played in RoR2.

---

# Mario 0.5.0, Olimar 0.5.0 and Melee 0.4.8

One ZIP with all three mods, for Risk of Rain 2 **DLC4 (2026)** with BepInEx 5.4.21.0 and RoR2BepInExPack
1.46.0 already installed. Offline and friends-only co-op only.
**Everyone in a multiplayer game needs these builds.**

| Mod | Version | Folder in `BepInEx/plugins` | Your disc |
| --- | --- | --- | --- |
| Mario | **0.5.0** | `MarioTest` (`MarioTest.dll`, `sms.dll`) | Super Mario Sunshine |
| Olimar | **0.5.0** | `OlimarTest` (`OlimarTest.dll`, `pikmin.dll`) | Pikmin (and Pikmin 2 for its content) |
| Melee | **0.4.8** | `Melee` (`Samus.dll`, `ssbm.dll`) | Super Smash Bros. Melee, NTSC-U rev 2 |

This release is about playing with other people and about the worlds around you: Mario can pick up and
throw his friends, Sunshine's flowers are back on the stages, Olimar has a new controller layout and a
flyable Onion, and a client's character no longer spawns under the map.

## Mario

### 0.5.0 (new in this release)

- **Carry and throw your friends.** B next to a teammate on your team lifts him like fruit; B puts him
  down, and running and pressing B throws him on Sunshine's arc. A carried player breaks free with his
  own A and Mario stumbles. `Carry.CarryTeammates` picks who can be lifted: 0 nobody, 1 (the default)
  Olimar, the Melee fighters and other Marios, 2 any player. A carried Mario flails in the fire-hop pose
  (no yell, flames or damage), and thrown or dropped players take no fall damage for 8 s.
- **Carry Pikmin pellets.** With the Olimar plugin running a Pikmin world, B also lifts any loose pellet.
  Throw one into the Dolphin's receiver to deliver a ship part, and anything you put down becomes a loose
  pellet again.
- **Sunshine's flowers turn up on stages.** About two stages in three get a set: a ring of 4 to 8 flowers
  that pays a coin per flower when you spray them all open (2.5 s before the open ones wilt), a lone
  flower worth a coin, a ring of hopping flower enemies, or a flower tower that bursts out of the ground
  and bites. A stomp or pound kills a flower enemy (5 coins for a tower, 2 for a head), water freezes a
  tower, and each bloom, bite and death plays the disc's own pollen and dust. `[Flowers]` sets how often
  they appear and how hard they bite (10% of Mario's health and a knockdown by default). The host owns
  them and every player sees them, but only a Mario wakes them.
- **The nozzle wheel slides out of the tank.** Hold RB (Special) for half a second and the wheel grows
  from the nozzle head above FLUDD's water tank. Segments read Hover, Rocket, No FLUDD, Turbo clockwise;
  choosing Hover, Rocket or Turbo fits it at once (even from Spray, and from No FLUDD it gives FLUDD
  back), and only the wheel's choice plays Sunshine's pickup sparkle and sounds while the quick RB tap
  stays silent. After a choice or a cancel the wheel stays shut until RB is released.
- **Coins behave like Sunshine's.** Yellow coins lie for 30 s (`Coins.Seconds`) and blink over their last
  3 s, pop up and bounce on a fixed path, the counters stack blue above yellow as in the game, and lunar
  coins show as Sunshine's blue coin lying on the ground (`Hud.LunarCoinBlueCoin`). Teammates pick your
  coins up for the same heal and gold (`Coins.TeammatesCollect`).
- **FLUDD's water turns back shots.** `Fludd.SprayDeflects` (on) makes airborne droplets a shield: an
  enemy projectile that flies through them is turned back at whoever fired it, and enemy bullets and
  laser blasts stop at the water.
- **The entrance hands straight over to the player camera.** Control starts from the intro's own shot -
  position, look, distance and field of view carry over with no reframe - and the shot aims through the
  landing point, so Mario is centred from the first frame. The gate's image fades in over 0.8 s and out
  over about 1.7 s (Sunshine's pace) instead of snapping, and Mario now leaves the statue where its exit
  animation stopped instead of snapping back to the pod's old point.
- **The Turbo corkscrew goes on as long as you keep circling the stick** (the 6 s cap is gone), and both
  corkscrews steer with the camera: tilting it up or down from the start of the roll changes the flight
  angle by 35% of the change, up to 15 degrees.
- **Water hits flash and sound.** FLUDD's water on an enemy shows Sunshine's yellow hit marker and plays
  its enemy-water-hit sound (`Look.Effects` turns it off); other players see and hear it on a remote
  Mario without the damage counting twice.
- **Items on Mario:** `Look.ItemDisplays` (off) draws RoR2's cosmetic items - glasses, syringes, crowns
  and the rest - on whichever body he is wearing, and reattaches them when he starts driving again.
- **Mario's fire cries finish** before movement and landing voices cut in, and the Shine Sprite's gold
  body now reads as gold instead of white.
- **Fixed:** a client's Mario starts at his stage spawn instead of falling under the map from stage 2;
  floor recovery no longer pulls him back mid-slide on long descents; the floating item-pickup icon is
  no longer empty; and character-select pads find their player in more cases.

## Olimar

### 0.5.0 (new in this release)

- **A new controller layout.** LT locks on (LT + RB cycles targets, LT + A throws rapidly at the locked
  one), RT is the alternate-command modifier (RT + B whistle, RT + right stick swarm, RT + X dumps a
  flying Onion, RT + Y fills it), LB recentres the camera, and holding X for 0.6 s raises or lowers the
  Onion. The old double-tap X dump and the RT top-down view are gone; RB still strikes.
- **Onion Ride.** Stand in an Onion's beam and press LT to board it, or hold RT and tap LT to call it to
  you from anywhere and board. Fly at twice your walking speed (click the stick to boost for 2 s) with
  up to 5 s of grace then 10 s, and leave with A, B, X or Y. The Pikmin that went aboard come out a
  third down each leg, the 30 s recharge starts when the ride ends, and the Onion takes the damage while
  Olimar is safe inside. Boarding plays his lift into the pod, and clients can ride too.
- **The squad can be targeted now.** Three or more Pikmin standing together on the ground are something
  monsters can see and aim at, so enemies go for the squad, not only Olimar.
- **Pikmin take the hits themselves.** A monster's swipe hurts every Pikmin inside the actual swing, and
  an enemy explosion damages each Pikmin in it once, even when RoR2's own hit landed on something else.
- **Stranded Pikmin come back.** Pikmin wedged below a cliff are put back at their slot, a whistle brings
  a grounded Pikmin that is far above or below the cursor back to it, and an Onion's death with a living
  teammate calls every living Pikmin home before it goes dormant.
- **Flying Onion fixes.** Pikmin climb the legs the flying Onion actually has; filling a flying Onion
  keeps it at its height instead of bringing it down; taking off or landing mid-fill keeps every job;
  and a raised Onion folds its legs before it lifts.
- **New Pikmin 1 life on the maps.** Pellet Posies grow from seedling to flower and release their pellet
  (2 per living Olimar in ordinary runs, 6 per player in Ship Repair), an Iridescent Flint Beetle scuttles
  around now and then (land a Pikmin on it to flip it over for pellets and nectar), and nectar puddles
  bloom any flowerless Pikmin that drinks from them. `Enemies.*` sets how many appear.
- **Pikmin 2 in Ship Repair.** Its enemies play their source effects, four Pikmin 2 stage themes join the
  music rotation, and guests can take, carry and throw any pellet anywhere, not only ship parts.
- **Stage cards in Pikmin 2's lettering.** Every stage opens with a five-second "DAY N" card drawn in the
  big orange area-name letters from Pikmin 2, and Ship Repair's location banner uses the same lettering.
- **Plucks use the game's own clips**, with dirt, debris and three sound cues, and the HUD's changing
  digits expand or shrink the way Pikmin's do.
- **The Dolphin crashes in properly:** impact effects and a dust cloud on the first landing, a light beam
  as Olimar leaves it, a puff when a part arrives, and sparks from three points on the wreck.
- **Looks:** the Onion's take-off dust and landing smoke are the grey-blue the game authored (they were
  nearly black), and a flying Onion leans into its travel.
- **Olimar no longer stutters** against the camera: his drawn model sits at the same smoothed position the
  camera follows, and `Look.ItemDisplays` (off) puts RoR2's cosmetic items on that body.
- **Fixes:** Olimar appears in character select and loads reliably again (two startup faults), a client's
  Olimar starts at his stage spawn, corpse pellets follow the enemy's real size (1, 5, 10 or 20 rather
  than promoted by health or elite status), jump pads keep the pad's full speed and arc, and the strike
  charge is one second and ends when he walks. Other players' Pikmin move on a steady clock on a client
  instead of jumping with each network update.

## Melee

**Samus, Fox, Luigi and Yoshi are the most complete fighters.** Pikachu, Captain Falcon, Link and Donkey
Kong are still in progress.

### 0.4.8 (new in this release)

- **Items on the fighters.** `Visuals.ItemDisplays` (off) draws RoR2's cosmetic item displays - glasses,
  syringes, crowns and the rest - on the fighters' animated bodies instead of hiding them with Commando.
  With them on, a fighter's KO corpse is his own: the hidden Commando body no longer reappears.
- **A client's fighter starts at its stage spawn** instead of falling under the map at stage starts from
  stage 2, or being rescued to a distant spot on the Moon.
- **Other players' fighters move smoothly.** A shadow fighter now replays one step per physics step and
  is drawn between its last two steps, instead of moving three steps every third step (a jerky 20 Hz).
- **A client's extra A attack no longer makes the host throw an error.**
- **Character-select pads find their player in more cases**, so a pad shows its own costume instead of
  falling back to the local pick.
- **Fixed:** fall recovery no longer pulls a fighter back while he slides downhill past a prop edge, and
  the floating item-pickup icon is no longer empty.

## In all three

- **A client's character starts at its stage spawn.** Before, a client's body was left part-way through
  its network blend toward the spawn, and a native sim that started there fell under the map at every
  stage start from stage 2 (the out-of-bounds rescue then put the player somewhere else entirely).
- **Optional item displays.** `ItemDisplays` under `Look` (Mario, Olimar) or `Visuals` (Melee) draws
  RoR2's cosmetic items on the drawn body. Off by default.
- **The world pickup icon shows the item again.** A tier-coloured pickup notification's floating icon
  came up empty; it now binds the item's own icon.
- **Sliding past a prop edge no longer triggers fall recovery.** The shared detector rechecks a floor
  under the body's current position each step instead of keeping the old height.
- **Character-select pads find their player in more cases**, including pads whose controller sits on a
  child or neighbour object.

## Install

1. **Before unzipping, right-click the ZIP, choose Properties and tick Unblock** (or run `Unblock-File`
   on it in PowerShell).
2. Merge the ZIP's `BepInEx` folder into your game folder or mod manager profile. Replace each mod's two
   DLLs together.
3. `BepInEx/config` holds each mod's default settings. Merging it **resets your settings for these
   mods**; to keep yours, skip the `config` folder.
4. The guides are in `docs/`. Olimar's controls changed: read `docs/Olimar.md` before playing him.

## Checks and known limits

- The libcommon, libsms, libpikmin and libssbm test suites, the shared recovery and camera checks, the
  Melee boundary checks and the three plugin builds pass on these sources (`release.json` pins every
  source commit).
- **None of this has been played in game yet.** Multiplayer changes have not been run on two machines.
- The ZIP contains no disc images, extracted game assets or game DLLs. Unofficial fan project, not
  affiliated with Nintendo, HAL Laboratory, Hopoo Games or Gearbox.
- Verify the download against the `.sha256` file on the release page.

