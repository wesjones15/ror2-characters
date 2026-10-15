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
foreach ($character in @('Mario', 'Olimar')) {
    & (Join-Path $PSScriptRoot 'publish.ps1') -Character $character -Version $Version -Channel $Channel -ValidateOnly
    $package = Join-Path $PSScriptRoot "dist/$character-$Channel-$Version-win-x64"
    $manifest = Get-Content -LiteralPath (Join-Path $package 'release.json') -Raw | ConvertFrom-Json
    if ($manifest.parentCommit -ne $head -or $manifest.channel -ne $Channel) { throw "Rebuild $character from this parent commit/channel." }
    $assets += "$package.zip", "$package.zip.sha256"
    $assets += "$(Join-Path $package 'README.md')#$character-README.md"
    $assets += "$(Join-Path $package 'CHANGELOG.md')#$character-CHANGELOG.md"
    $assets += "$(Join-Path $package 'release.json')#$character-release.json"
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
}
$notes | Set-Content -LiteralPath $notesPath -Encoding UTF8
$assets += "$snapshotPath#source-commits.json"
& gh release create $tag --repo $repo --target $head --title "Mario and Olimar $Channel $Version" --notes-file $notesPath --latest=false @assets
if ($LASTEXITCODE) { throw 'Release creation failed; existing releases were not overwritten.' }
