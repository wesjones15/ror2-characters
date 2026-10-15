# Mario changelog

Requires Risk of Rain 2 1.2.4.4, BepInEx 5.4.21.0 and RoR2BepInExPack 1.14.0. Native ABI 24.

## 0.2.0 - 2026-10-14

First packaged release: `MarioTest.dll` and `sms.dll`, with an installer and checksums. Earlier
builds were development builds installed straight from source.

### Character
- Super Mario Sunshine's Mario as a survivor, moved by libsms in place of RoR2's character
  controller, drawn with the disc's own model and heard with its voice, footsteps and FLUDD sounds.
- Pad layout by button position (A jump, B dive/punch, RT spray, LT ground pound, LB lock-on,
  RB nozzle, D-pad down refill), with skill-icon glyphs and text for those buttons.
- Character select: Mario's model and portrait, a jump on the spot with a "wahoo".
- Delfino Plaza sting as he leaves the pod on a run's first stage; Sunshine's fall animation and
  its game over song when he dies.

### FLUDD
- Spray, Hover, Rocket and Turbo nozzles; spray bursts (a light press for a short splash, a full
  press for full reach); the water gauge on screen; refills from RoR2 water, D-pad down and each new stage.
- Water refracts through RoR2's distortion with a faint tint, and leaves wet patches on the ground.
- Wet belly slides glide over wet ground for up to 1.5 s with no charges.
- Lock-on with LB: FLUDD tracks the enemy, RB steps to the next target (60 m range).

### Combat and items
- Stomps, ground pounds (with shock wave), dives and FLUDD water hit as RoR2 damage from Mario,
  so his damage stat, crits and on-hit items apply. Pound damage scales with the drop.
- RoR2's items work through Mario's moves, using the skill slots; movement-speed items speed him up.
- Jump pads, knockback and Milky Chrysalis throws, stuns and roots, and sprint items work.
- Sunshine's life meter replaces RoR2's health bar, with a lock-on marker on the target.
- Yellow coins drop from enemies he kills, restore one meter segment and are worth 1 RoR2 gold
  (`Coins.Gold`).
- Powerful hits knock him down without stunning him. Height-based fall damage, with ground pound
  and dive protection.
- Automatic unstuck recovery after three seconds wedged in place.
- Goobo Jr.'s clone gets a Mario brain and is drawn in the gummy clone material.

### Coin counters
- Sunshine's yellow and blue coin counters, drawn from the disc's HUD pictures, replace RoR2's gold
  and lunar coin counters (which hide): up to seven digits, each where RoR2's own was. A lunar
  coin picked up plays Sunshine's blue coin jingle.

### Losing
- Dying with no extra life plays the game over song and Sunshine's game over screen: the
  "TOO BAD!" letters, then black with "GAME OVER" cut out of it and a red box behind. With Dio's
  Best Friend or a Pluripotent Larva it is a miss instead ("Too Bad!" jingle and letters) with the
  "MARIO x N" lives banner counting the life down; without one the banner never shows.
- Falling off the map starts "TOO BAD!" and its jingle early (20 m down over a void), and he is
  put back where he last stood, unhurt, when the stage's kill zone takes him. A long drop onto
  lower ground (tall stages) is not a fall off the map. Drawn smoothly between the game's 30
  frames a second (`Hud.ScreenSpeed`).
- Walls: a step that crosses a wall or ends inside one is undone, more strictly for a while after
  a hit or launch.

### First run
- Models, animation, tuning, sounds, HUD and effects are extracted from your own Sunshine disc
  (ISO/GCM/CISO, any region) on first launch, together with the generated arrival, "Too Bad!", game
  over and blue coin jingles and the game over wipe's pictures. Incomplete caches are repaired, and
  a cache without the jingles or the wipe pictures gets them when the disc is found. The build and
  the ZIP contain no game data.

### Not yet play-tested
- The coin counters (positions over RoR2's HUD, hiding RoR2's own), the blue coin jingle, and the
  "TOO BAD!" and game over screens, including the early cue on a fall, the lives banner with an
  extra life, and the screens' pace.
- The wall guard (putting him back from inside a wall).
- First-run extraction from a disc, including the generated arrival and death jingles and cache repair.
- FLUDD wet patches darkening the ground, and wet slides lasting a set time on wet ground in place of charges.
- Yellow coins (pickup sound and sparkles), and no coins dropping for kills that aren't Mario's.

### Known limitations
- Multiplayer is new and untested with two players: other players with the plugin see Mario, his water and his coins, and a client's hits are sent to the host.
- No Yoshi. Skill icons are Commando's, with Mario's buttons as glyphs.
