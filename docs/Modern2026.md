# DLC4 migration (2026-10-14)

Target: the local `2026 Mod Stuff/RiskOfRain2_DLC4` installation. Its UnityPlayer reports **2021.3.45f2**; RoR2 references .NET Standard 2.1. Installed RoR2BepInExPack reports **1.46.0**. The nearby Enforcer 3.11.9 source was used as a migration reference, not as a binary dependency.

## Branches and implementation

`modern/1.5.0` starts from `master` in ror2-common, ror2-mario and ror2-olimar, and from `main` in libsms, libpikmin and ror2-characters. Existing legacy branches remain available. The initial migration built local artifacts only; the runtime follow-up below installs developer builds into the local DLC4 game. Nothing has been published.

1. Retarget both managed plugins to netstandard2.1 and the DLC4 managed assemblies. Local build scripts now default both compilation and deployment to the DLC4 folder. `-NoInstall` builds local artifacts only.
2. Update shared skills to `OnFixedUpdate(GenericSkill, float)`, implement `ShouldProximityHighlight`, and retain damage as `DamageTypeCombo`. Existing native attacks still use their original flags and unspecified source; no new skill attribution is invented.
3. Adapt Mario's local and remote fall damage, and Olimar's landing damage, to `CharacterMotor.HitGroundInfo`. Supply velocity, feet position, owner and effect validity. Adapt Olimar's elite burn to the hurt-box/proc-chain overload.
4. Move the minion hit-direction IL hook from TakeDamage to its private TakeDamageProcess implementation and match the captured damageInfo. Update the five-argument glyph hook and private refresh call. Verify reflection hook signatures against the actual installed assembly.
5. Use effective item counts, the replacement death-proc event, and explicit equipment-copy/money overloads. Load after RoR2BepInExPack when present through a soft BepInDependency; neither character calls its APIs.
6. Update release metadata, framework output paths and source pins for the modern branch. Existing version tags/downloads are legacy; bump plugin/changelog versions before publishing any modern release.

## Enforcer differences that do not apply

These plugins already register `IContentPackProvider` coroutines; they do not detour BodyCatalog.Init or content-pack initialization. They have no R2API unlockable/achievement registration, skin extras or custom Wwise banks to port. Their audio is supplied by their native libraries/Unity audio. They use no R2API dependency. Do not copy Enforcer's R2API package list or sound-bank workflow into these projects.

The Rust libraries do not reference RoR2 or Unity assemblies. Their existing FFI builds work unchanged; this migration requires no native ABI change.

## Validation

- Both managed Release builds succeed against the DLC4 directory.
- Both native Release builds and character `build.ps1 -NoInstall` workflows succeed.
- Shared MpCheck, RunAudioCheck and UnstuckCheck pass; Mario NetCheck, FallDamageCheck and UnstuckCheck pass. The shared unstuck harness needed stand-ins for its existing map-zone dependencies; these tests do not simulate Unity collision.
- `ror2-common/tests/CheckModernApi.ps1 -RoR2Dir <DLC4 folder>` checks runtime hook signatures and the unique minion hit-direction IL sequence without loading Unity.

Remaining warnings include pre-existing unused fields and an architecture mismatch: the supplied BepInEx 5.4.21.0 assembly has Cecil `Required32Bit` set. Verify/replace the BepInEx installation with the correct Windows x64 distribution before runtime testing. Dependencies were not overwritten by this migration.

## Runtime acceptance still required

Compilation and IL inspection do not prove in-game compatibility. The initial migration was not launched by the agent. The user's subsequent runtime test found the presentation issues recorded below. Check startup logs, survivor selection and display models; spawn and transition stages; controller glyphs; Mario movement, FLUDD, ground pound, fall damage and lives; Olimar Onion interaction, Pikmin damage/directions, elite burns and revival; item cooldowns/healing; sound and music across consecutive runs; host/client damage and stage transitions. Test both plugins together. In particular verify prefab/resource names, model setup and runtime detour installation in the game logs.

Local test artifacts are in the sibling `ror2-mario/dist/MarioTest` and `ror2-olimar/dist/OlimarTest` folders. These developer folders may contain generated local audio and asset pointers; they are not distributable release ZIPs. The release packager includes only its explicit file allowlist.

## Runtime presentation follow-up (2026-10-14)

- Solid models: both plugins logged `HGStandard not found; using Standard`. DLC4's Commando prefab can be available before its addressed renderer materials. Load `RoR2/Base/Shaders/HGStandard.shader` directly before constructing native model materials. Its key and opaque deferred depth-writing pass were verified in the installed catalog/bundle. Particle and glass materials retain their existing shaders.
- Portraits: DLC4 names every layer from 8 through 31, so the old unused-layer search always failed. Use the game's `ManualRender` layer and explicitly select deferred rendering for the offscreen camera. The distant stage and short clip range isolate the portrait. Empty/black images stay queued and retry every two seconds; a portrait that finishes while character select is open refreshes its existing grid icon too.
- Sound: Unity audio remains disabled in DLC4, as expected for Wwise. The mods' CPAL and Windows PCM output paths did not change in the migration. An isolated held hover loop renders finite PCM with zero clipped samples at 32 and 48 kHz (peaks 0.795 and 0.815). A fuller 48 kHz simulation, including jump animation and water/splashes, reproduced 39 clipped samples on hover activation. The callback previously applied host volume after DSP saturation, making existing distortion quieter. Apply host gain inside the mixer before saturation, including streamed audio, and stop multiplying it a second time in the callback. At the restored gain the full spray/hover mixes have zero clipped samples (peaks 0.147 and 0.261). Ground splashes also respect the original sound-set limit of one start per 30 Hz water frame. All 64 audio/presentation tests pass; the audible device test remains opt-in. This does not prove real-time playback under game load or resolve the reported sustained whine by ear.
- Volume: the DLC4 log reported a missing `Config/config.cfg` and an arrival sting at gain 1.00. The legacy game saved master 44.63511, SFX 48.15751 and music 53.03468: its mod SFX gain was approximately 0.215. Restore these local preferences rather than reducing every mod's default gain. DLC4's new `parent_volume_music` is the unscaled music slider; `volume_music` returns the effective value after master is applied. Shared sting playback now uses that effective value directly.

- Plugin discovery follow-up: the installed `BepInEx.Preloader.dll` has `AssemblyPatcher.CleanUpOldRoR2Bep`, which recursively deletes the exact `BepInEx/plugins/RoR2BepInExPack` folder before discovery. The runtime log confirmed this deletion. The agent initially restored the pack into that obsolete folder name, causing it to be deleted again on the next launch; immediate post-deploy hash checks did not catch this startup cleanup. Restore the five package files under `BepInEx/plugins/RiskofThunder-RoR2BepInExPack` instead. This includes `Newtonsoft.Json.dll` version 12.0.0.0, also required by the installed BepInEx core. Neither preloader nor core was modified. The pack GUID/version already matched; this was a folder-name collision, not a version mismatch or proven cache corruption. The hard dependencies added by Mario `895365f` and Olimar `af63438` are now optional load ordering because the character plugins call no pack APIs.

Both developer builds were rebuilt and installed into the local DLC4 game. Source changes and source pins are committed on `modern/1.5.0`. Restart to load the latest DLLs. The next launch must confirm both characters register, lobby/game models are opaque, portraits appear, and FLUDD sounds right at the restored levels; the reported sustained whine has not been confirmed resolved in-game by the agent.

The following startup was verified from the live log: three plugins loaded, including RoR2BepInExPack 1.46.0; both Mario and Olimar registered; both selected `Hopoo Games/Deferred/Standard`; both portrait renders completed with the empty-image check in place. All five pack files survived startup with hashes matching the local package. Visual confirmation of the grid/models and listening confirmation of FLUDD remain user acceptance checks.

The user subsequently confirmed the icons and solid character textures are correct. The first sound pass was insufficient: the user still reported distortion/whine and excessively crisp, uncomfortable sound. Further headless testing found SE leaf tracks had outer parameter switches disabled, so their authored volume/pitch and host FLUDD gain were ignored. Enable JAI's volume, pitch, pan and effect layers when applying per-sound parameters. The isolated hover peak changed from 0.815 to 0.537, and a waveform test verifies the independent FLUDD gain now scales its output without changing pitch.

Both host plugins now default `Sound.HighCutHz` to 4500 (stereo Butterworth low-pass; 0 bypasses it). Mario also defaults `Sound.FluddVolume` to 0.35, independent of his voice. Standalone native viewers retain their original unfiltered/default gain behavior. The filter is verified at 32/48 kHz to preserve the 1 kHz voice band, attenuate 8/12 kHz content, preserve stereo isolation, and bypass exactly when disabled. SMS audio/presentation tests pass (66 total, one device test ignored); Pikmin's filter test also passes. These softer profiles were built, committed and installed with matching DLL hashes; all five pack files were preserved. Their subjective in-game sound still requires acceptance, without asking the user to repeat uncomfortable listening at a high level.

## First modern release (2026-10-15)

Mario modern 0.1.0 and Olimar modern 0.1.0 share the modern-v0.1.0 release.
The mod version starts at 0.1.0 for each character; modern/1.5.0 names the game compatibility branch.
The release tag pins the parent commit, whose five submodule entries pin every source commit.
All six repositories retain legacy/1.2.4.4 for the 2023 build. The parent's deploy.ps1 and
install.ps1 are unchanged from that legacy snapshot; build.ps1 and publish.ps1 were adapted.

The temporary low-pass filters and FLUDD-only attenuation described above were removed.
All native audio now uses one shared Ror2Common.Audio.cfg Output.GainDb setting, default -4 dB.
Olimar's full vanilla sundown bell is prepared from the user's disc in memory and survives
game-over presentation cleanup. Olimar uses ABI 28; Mario remains ABI 24.
Startup, shaders and portraits have been checked. Full multiplayer and final sound listening
acceptance remain manual. No disc files, extracted assets or generated audio ship in the packages.

## Second modern release (2026-10-15)

Mario modern 0.2.0 and Olimar modern 0.2.0 share the modern-v0.2.0 release. Mario uses libsms ABI 26
and Olimar libpikmin ABI 29; the multiplayer frame protocol and Olimar's snapshots changed, so every
player needs the same release. New: the Shine Sprite as Mario's teleporter trigger, rewritten
character select text for both, and the skill-sourced hit, jump event and jump power items.
