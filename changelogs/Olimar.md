# Olimar changelog

Requires Risk of Rain 2 1.2.4.4, BepInEx 5.4.21.0 and RoR2BepInExPack 1.14.0. Native ABI 27.

## 0.1.0 - 2026-10-14

First packaged release: `OlimarTest.dll` and `pikmin.dll`, with an installer and checksums.
Earlier builds were development builds installed straight from source. Everything below has been
play-tested in game except the last changes before this release, listed under "Not yet play-tested".

### Character
- Pikmin's Olimar as a survivor, with a squad of 10 Red, 5 Yellow and 5 Blue Pikmin that follow in
  formation, get whistled, thrown and swarm, drawn with the disc's models and animations.
- Pad layout by button position (A throw/pluck, B jump, LB+B whistle, X Onion, RB dismiss strike,
  D-pad colour select, right stick camera, LB + right stick swarm, RT lock-on), plus a keyboard and
  mouse scheme, with skill-icon glyphs for the pad buttons.
- Character select: Olimar with a red, a yellow and a blue Pikmin, and a portrait from his model.
- S.S. Dolphin landing with Olimar beaming out beside it and the squad coming out of the Onion, and the Impact Site sting.

### Combat and items
- RoR2's enemies are creatures to the sim, with hurtboxes as latch points. Pikmin hits are RoR2
  damage from Olimar, so his damage stat, crits and on-hit items apply.
- Throws reach twice as far, steer onto the cursor, and end latched on a locked-on enemy (40 m range).
- Dismiss strike replaces the dismissal: a melee blow all round Olimar that staggers enemies,
  charges the squad at them and refunds its cooldown on a kill.
- Enemy attacks shake latched Pikmin off; hits near Pikmin hurt them, scaled to Olimar's health.
- Movement-speed items speed Olimar up, and the Onion gets his items as his minion.
- Fall damage through RoR2's own landing hook; Olimar is two thirds of Commando's height.

### Pikmin economy
- Dead enemies leave 1, 5, 10 or 20 pellets by size; Pikmin carry them to the Onion, which makes
  seeds. Sprouts grow from leaf to bud to flower, Pikmin grow after two kills, and flowers wilt after
  five minutes.
- One Onion holds all three colours, with a menu to transfer Pikmin and to Follow Olimar or Land
  Here, flight and landing animations, light cones and sounds. The Onion plucks planted sprouts
  after a minute.
- The squad and stock carry over to the next stage. Pikmin collect nearby drops and rejoin on their own.
- Jumping squad, with Pikmin copying Olimar's takeoffs and jump pads.

### Onion
- The Onion can go dormant (drawn in its colour) and be revived; its
  startup sound and effects replay, queued seeds resume, and Pikmin only collect loose pellets once
  the Onion has descended. A life gauge (a Pikmin wheel) floats above a wounded or dormant Onion,
  refilling with its revival timer. The flying Onion stops lower over a pellet.
- Captains beam out of the Dolphin's hatch; a Pikmin called to his hand sprints to catch Olimar when
  he throws on the run; Pikmin that fall into a void come back to their captain, unhurt.

### First run
- Models, animations, tuning, sounds and effects are extracted from your own Pikmin disc
  (ISO/GCM/CISO) on first launch. The build and the ZIP contain no game data.

### Not yet play-tested
- Olimar beaming out beside the Dolphin at the start of a run, with the squad coming out of the
  Onion.

### Known limitations
- Multiplayer is new and untested with two players: the host's Pikmin are shown to every player with the plugin, and a client's Olimar moves on their own machine.
- No Olimar footsteps or voice, no hazard types, no ship-part repair, and enemies don't target
  Pikmin directly.
