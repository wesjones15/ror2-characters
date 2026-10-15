[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][ValidateSet('modern', 'legacy')][string]$Channel,
    [Parameter(Mandatory = $true)][ValidatePattern('^\d+\.\d+\.\d+$')][string]$Version,
    [switch]$ValidateOnly
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$repo = 'wesjones15/ror2-characters'
$tag = "$Channel-v$Version"
$branch = if ($Channel -eq 'modern') { 'modern/1.5.0' } else { 'legacy/1.2.4.4' }
$game = if ($Channel -eq 'modern') { 'DLC4 / modern/1.5.0' } else { '1.2.4.4 (2023)' }
$head = & git -C $PSScriptRoot rev-parse HEAD
if ($LASTEXITCODE) { throw 'Cannot resolve parent commit.' }
if ((& git -C $PSScriptRoot branch --show-current) -ne $branch) { throw "Check out $branch before publishing." }
$sources = [ordered]@{}
$assets = @()
$uploadDir = Join-Path $PSScriptRoot "dist/$tag-assets"
New-Item -ItemType Directory -Path $uploadDir -Force | Out-Null
foreach ($character in @('Mario', 'Olimar')) {
    & (Join-Path $PSScriptRoot 'publish.ps1') -Character $character -Version $Version -Channel $Channel -ValidateOnly
    $package = Join-Path $PSScriptRoot "dist/$character-$Channel-$Version-win-x64"
    $manifest = Get-Content -LiteralPath (Join-Path $package 'release.json') -Raw | ConvertFrom-Json
    if ($manifest.parentCommit -ne $head -or $manifest.channel -ne $Channel) { throw "Rebuild $character from this parent commit/channel." }
    $assets += "$package.zip", "$package.zip.sha256"
    foreach ($document in @('README.md', 'CHANGELOG.md', 'release.json')) {
        $uploadPath = Join-Path $uploadDir "$character-$document"
        Copy-Item -LiteralPath (Join-Path $package $document) -Destination $uploadPath -Force
        $assets += $uploadPath
    }
}
foreach ($source in @('libpikmin', 'libsms', 'ror2-common', 'ror2-mario', 'ror2-olimar')) {
    $path = Join-Path $PSScriptRoot "sources/$source"
    $sha = & git -C $path rev-parse HEAD
    $pin = & git -C $PSScriptRoot ls-files --stage -- "sources/$source"
    if ($pin -notmatch "^160000 $sha 0\s") { throw "Unpinned source: $source" }
    $sources[$source] = $sha
    if (-not $ValidateOnly) {
        $remote = & git -C $path ls-remote origin "refs/heads/$branch"
        if ($LASTEXITCODE -or ($remote -split '\s+')[0] -ne $sha) { throw "Push $source $branch at $sha first." }
    }
}
$snapshotPath = Join-Path $PSScriptRoot "dist/$tag-sources.json"
[ordered]@{ schema = 1; channel = $Channel; version = $Version; branch = $branch; parentCommit = $head; sourceCommits = $sources } |
    ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $snapshotPath -Encoding UTF8
$sourceUpload = Join-Path $uploadDir 'source-commits.json'
Copy-Item -LiteralPath $snapshotPath -Destination $sourceUpload -Force
$assets += $sourceUpload
$assetNames = @($assets | ForEach-Object { [IO.Path]::GetFileName($_) })
if (@($assetNames | Select-Object -Unique).Count -ne $assetNames.Count) { throw 'Release asset filenames must be unique.' }
if ($ValidateOnly) { Write-Host "Validated ${tag}: both packages and all five source pins."; return }
$remote = & git -C $PSScriptRoot ls-remote origin "refs/heads/$branch"
if ($LASTEXITCODE -or ($remote -split '\s+')[0] -ne $head) { throw "Push the parent $branch at $head first." }
$destination = & gh repo view $repo --json nameWithOwner | ConvertFrom-Json
if ($LASTEXITCODE -or $destination.nameWithOwner -ne $repo) { throw 'Wrong release destination.' }
$notesPath = Join-Path $PSScriptRoot "dist/$tag-notes.md"
$notes = @"
Mario $Channel $Version and Olimar $Channel $Version are the first releases for this game compatibility line.

Requires Risk of Rain 2 $game, Windows x64 and BepInEx 5.4.21.0. Download the ZIP for either character, or both. Each package contains its installer, guide, changelog, two mod DLLs and a checksum manifest.

The tag pins parent commit $head. That commit pins all five source repositories; the attached sources manifest records their full commit IDs. The branch is $branch. Character versions start at 0.1.0 independently in each compatibility line.

Models, textures, sounds and tuning are extracted from your own GameCube disc. No disc images, extracted assets, generated audio, game binaries or dependency DLLs are included. Offline and friends-only co-op; two-player multiplayer remains unverified. Read the included character guide for requirements and known limitations.
"@
if ($Channel -eq 'modern') {
    $notes += "`n`nIncludes DLC4 API support, material/portrait fixes, shared native output gain (default -4 dB), and Olimar's full vanilla sundown death bell surviving game-over cleanup. Mario uses ABI 24; Olimar uses ABI 28. Final sound listening and full gameplay acceptance remain manual."
    $notes += @'


## Modern installation

Install [BepInExPack by bbepis](https://old.thunderstore.io/package/bbepis/BepInExPack/) and its supporting mods in your game/mod-manager profile:

- [BepInEx_GUI](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/BepInEx_GUI/)
- [FixPluginTypesSerialization](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/FixPluginTypesSerialization/)
- [RoR2BepInExPack](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/RoR2BepInExPack/) (checked with 1.46.0)
- [SeekersPatcher](https://thunderstore.io/c/riskofrain2/p/pseudopulse/SeekersPatcher/)
- [MiscFixes](https://thunderstore.io/c/riskofrain2/p/score/MiscFixes/)

Unzip the character's modern ZIP and run its included install.ps1 with -InstallDir pointing at the folder containing BepInEx. For a mod manager, use the active profile folder and launch through that profile. The character installer copies its two verified DLLs; dependency mods are installed separately.

Put your own Super Mario Sunshine ISO directly beside MarioTest.dll and sms.dll in BepInEx/plugins/MarioTest/. Put your own Pikmin ISO directly beside OlimarTest.dll and pikmin.dll in BepInEx/plugins/OlimarTest/. Filenames do not matter. Launch and wait for extraction; assets are cached for future launches. To keep the ISO elsewhere, set Disc under [Paths] in the character's config to its full path and restart.

Each ZIP contains its full README with step-by-step manual/profile instructions and a folder example. The same guides are attached separately as Mario-README.md and Olimar-README.md.
'@
}
$notes | Set-Content -LiteralPath $notesPath -Encoding UTF8
& gh release create $tag --repo $repo --target $head --title "Mario and Olimar $Channel $Version" --notes-file $notesPath --latest=false @assets
if ($LASTEXITCODE) { throw 'Release creation failed; existing releases were not overwritten.' }
