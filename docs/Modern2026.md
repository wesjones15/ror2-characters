# DLC4 migration (2026-10-14)

Target: the local `2026 Mod Stuff/RiskOfRain2_DLC4` installation. Its UnityPlayer reports **2021.3.45f2**; RoR2 references .NET Standard 2.1. Installed RoR2BepInExPack reports **1.46.0**. The nearby Enforcer 3.11.9 source was used as a migration reference, not as a binary dependency.

## Branches and implementation

`modern/2026` starts from `master` in ror2-common, ror2-mario and ror2-olimar, and from `main` in libsms, libpikmin and ror2-characters. Existing legacy branches remain available. The initial migration built local artifacts only; the runtime follow-up below installs developer builds into the local DLC4 game. Nothing has been published.

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

- Plugin discovery follow-up: the migration's hard pack dependency (Mario `895365f`, Olimar `af63438`) caused BepInEx to skip both characters when it discovered only those two plugins. The current pack DLL has the correct GUID/version. Its creation time from the local package copy was 11:58:48 PM, after the failed log's 11:58:15 PM last write; the pre-copy directory listing contained only character files. The cause of the earlier working pack copy's absence is unknown. Raw cache strings were misleading: the valid cache header had two entries, with old pack bytes beyond them. Both character dependencies are now optional load ordering; the local pack was copied into the active installation. No deployment step removes pack files, and all pack file hashes were verified unchanged across the final character-DLL deployment.

Both developer builds were rebuilt and installed into the local DLC4 game. Source changes and source pins are committed on `modern/2026`. Restart to load the latest DLLs. The next launch must confirm both characters register, lobby/game models are opaque, portraits appear, and FLUDD sounds right at the restored levels; the reported sustained whine has not been confirmed resolved in-game by the agent.
