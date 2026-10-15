# DLC4 migration (2026-10-14)

Target: the local `2026 Mod Stuff/RiskOfRain2_DLC4` installation. Its UnityPlayer reports **2021.3.45f2**; RoR2 references .NET Standard 2.1. Installed RoR2BepInExPack reports **1.46.0**. The nearby Enforcer 3.11.9 source was used as a migration reference, not as a binary dependency.

## Branches and implementation

`modern/2026` starts from `master` in ror2-common, ror2-mario and ror2-olimar, and from `main` in libsms, libpikmin and ror2-characters. Existing legacy branches remain available. Nothing was published or installed into the game.

1. Retarget both managed plugins to netstandard2.1 and the DLC4 managed assemblies. Local build scripts now default both compilation and deployment to the DLC4 folder. `-NoInstall` builds local artifacts only.
2. Update shared skills to `OnFixedUpdate(GenericSkill, float)`, implement `ShouldProximityHighlight`, and retain damage as `DamageTypeCombo`. Existing native attacks still use their original flags and unspecified source; no new skill attribution is invented.
3. Adapt Mario's local and remote fall damage, and Olimar's landing damage, to `CharacterMotor.HitGroundInfo`. Supply velocity, feet position, owner and effect validity. Adapt Olimar's elite burn to the hurt-box/proc-chain overload.
4. Move the minion hit-direction IL hook from TakeDamage to its private TakeDamageProcess implementation and match the captured damageInfo. Update the five-argument glyph hook and private refresh call. Verify reflection hook signatures against the actual installed assembly.
5. Use effective item counts, the replacement death-proc event, and explicit equipment-copy/money overloads. Require the installed RoR2BepInExPack version through BepInDependency.
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

Compilation and IL inspection do not prove in-game compatibility. Neither character has been launched in DLC4 during this task. Check startup logs, survivor selection and display models; spawn and transition stages; controller glyphs; Mario movement, FLUDD, ground pound, fall damage and lives; Olimar Onion interaction, Pikmin damage/directions, elite burns and revival; item cooldowns/healing; sound and music across consecutive runs; host/client damage and stage transitions. Test both plugins together. In particular verify prefab/resource names, model setup and runtime detour installation in the game logs.

Local test artifacts are in the sibling `ror2-mario/dist/MarioTest` and `ror2-olimar/dist/OlimarTest` folders. These developer folders may contain generated local audio and asset pointers; they are not distributable release ZIPs. The release packager includes only its explicit file allowlist.
