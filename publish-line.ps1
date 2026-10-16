[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][ValidateSet('modern', 'legacy')][string]$Channel,
    [Parameter(Mandatory = $true)][ValidatePattern('^\d+\.\d+\.\d+(\.\d+)?$')][string]$Version,
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
    # The release carries the two ZIPs and nothing else; each holds its guide, changelog and manifest.
    $assets += "$package.zip"
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
$assetNames = @($assets | ForEach-Object { [IO.Path]::GetFileName($_) })
if (@($assetNames | Select-Object -Unique).Count -ne $assetNames.Count) { throw 'Release asset filenames must be unique.' }
if ($ValidateOnly) { Write-Host "Validated ${tag}: both packages and all five source pins."; return }
$remote = & git -C $PSScriptRoot ls-remote origin "refs/heads/$branch"
if ($LASTEXITCODE -or ($remote -split '\s+')[0] -ne $head) { throw "Push the parent $branch at $head first." }
$destination = & gh repo view $repo --json nameWithOwner | ConvertFrom-Json
if ($LASTEXITCODE -or $destination.nameWithOwner -ne $repo) { throw 'Wrong release destination.' }
$notesPath = Join-Path $PSScriptRoot "dist/$tag-notes.md"
function Get-Changes([string]$Character) {
    $text = Get-Content -LiteralPath (Join-Path $PSScriptRoot "changelogs/$Character.md") -Raw
    if ($text -notmatch "(?ms)^## $([regex]::Escape($Version)) - [^\r\n]*\r?\n(.*?)(?=^## |\z)") { throw "No $Version entry in changelogs/$Character.md." }
    return $Matches[1].Trim()
}
$marioChanges = Get-Changes 'Mario'
$olimarChanges = Get-Changes 'Olimar'
$notes = @"
Mario $Channel $Version and Olimar $Channel $Version for this game compatibility line.

Requires Risk of Rain 2 $game, Windows x64 and BepInEx 5.4.21.0. Download the ZIP for either character, or both. Each ZIP holds the character's two mod DLLs under BepInEx/plugins, its guide, its changelog and a checksum manifest.

## What changed

**Mario**

$marioChanges

**Olimar**

$olimarChanges

Each ZIP's CHANGELOG.md has the full history.
"@
if ($Channel -eq 'modern') {
    $notes += "`n`nMario uses ABI 26 and Olimar ABI 29. Everyone in a game needs the same release."
    $notes += @'


## Modern installation

Install [BepInExPack by bbepis](https://old.thunderstore.io/package/bbepis/BepInExPack/) and its supporting mods in your game/mod-manager profile:

- [BepInEx_GUI](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/BepInEx_GUI/)
- [FixPluginTypesSerialization](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/FixPluginTypesSerialization/)
- [RoR2BepInExPack](https://thunderstore.io/c/riskofrain2/p/RiskofThunder/RoR2BepInExPack/) (checked with 1.46.0)
- [SeekersPatcher](https://thunderstore.io/c/riskofrain2/p/pseudopulse/SeekersPatcher/)
- [MiscFixes](https://thunderstore.io/c/riskofrain2/p/score/MiscFixes/)

Unzip the character's ZIP and copy its BepInEx folder into your Risk of Rain 2 game folder (the one with Risk of Rain 2.exe), merging with the BepInEx folder already there. With a mod manager, copy it into the active profile folder and launch through that profile. It adds only the character's two DLLs; dependency mods are installed separately.

Put your own Super Mario Sunshine ISO directly beside MarioTest.dll and sms.dll in BepInEx/plugins/MarioTest/. Put your own Pikmin ISO directly beside OlimarTest.dll and pikmin.dll in BepInEx/plugins/OlimarTest/. Filenames do not matter. Launch and wait for extraction; assets are cached for future launches. To keep the ISO elsewhere, set Disc under [Paths] in the character's config to its full path and restart.

Each ZIP contains its full README with step-by-step instructions and a folder example.
'@
}
$notes | Set-Content -LiteralPath $notesPath -Encoding UTF8
& gh release create $tag --repo $repo --target $head --title "Mario and Olimar $Channel $Version" --notes-file $notesPath --latest=false @assets
if ($LASTEXITCODE) { throw 'Release creation failed; existing releases were not overwritten.' }
