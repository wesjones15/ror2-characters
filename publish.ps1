[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][ValidateSet('Mario', 'Olimar')][string]$Character,
    [Parameter(Mandatory = $true)][ValidatePattern('^\d+\.\d+\.\d+$')][string]$Version,
    [switch]$Draft,
    [switch]$ValidateOnly
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Add-Type -AssemblyName System.IO.Compression.FileSystem
$repo = 'wesjones15/ror2-characters'
$tag = "$($Character.ToLowerInvariant())-v$Version"
$package = Join-Path $PSScriptRoot "dist/$Character-$Version-win-x64"
$zip = "$package.zip"
$manifest = Get-Content -LiteralPath (Join-Path $package 'release.json') -Raw | ConvertFrom-Json
if ($manifest.character -ne $Character -or $manifest.version -ne $Version) { throw 'Package identity mismatch.' }
if ($Character -eq 'Mario') { $plugin = 'MarioTest'; $dll = 'sms.dll' } else { $plugin = 'OlimarTest'; $dll = 'pikmin.dll' }
$allowed = @('README.md', 'CHANGELOG.md', 'install.ps1', 'release.json', "BepInEx/plugins/$plugin/$plugin.dll", "BepInEx/plugins/$plugin/$dll")
if (@(Compare-Object @($allowed | Where-Object { $_ -ne 'release.json' }) @($manifest.files | ForEach-Object { $_.path })).Count -ne 0 -or $manifest.files.Count -ne 5) {
    throw 'Manifest must list exactly the approved two DLLs, README, changelog, and installer.'
}
foreach ($file in $manifest.files) {
    if ((Get-FileHash -LiteralPath (Join-Path $package $file.path) -Algorithm SHA256).Hash -ne $file.sha256) { throw "Modified file: $($file.path)" }
}
if (@(& git -C $PSScriptRoot status --porcelain --ignore-submodules=none).Count -ne 0) { throw 'Commit the parent repository and its submodule pointers before publishing.' }
foreach ($source in $manifest.sourceCommits.PSObject.Properties) {
    $head = & git -C (Join-Path $PSScriptRoot "sources/$($source.Name)") rev-parse HEAD
    if ($head -ne $source.Value) { throw "Rebuild after changing $($source.Name)." }
}
foreach ($pair in @(@('README.md', "docs/$Character.md"), @('CHANGELOG.md', "changelogs/$Character.md"), @('install.ps1', 'install.ps1'))) {
    if ((Get-FileHash -LiteralPath (Join-Path $package $pair[0])).Hash -ne (Get-FileHash -LiteralPath (Join-Path $PSScriptRoot $pair[1])).Hash) { throw "Rebuild after changing $($pair[1])." }
}
$archive = [IO.Compression.ZipFile]::OpenRead($zip)
try {
    $entries = @($archive.Entries | Where-Object { $_.Name })
    $names = @($entries | ForEach-Object { $_.FullName.Replace('\', '/') })
    if ($entries.Count -ne $allowed.Count -or @(Compare-Object $allowed $names).Count -ne 0) { throw 'ZIP contains unexpected or missing files; upload refused.' }
    foreach ($entry in $entries) {
        $stream = $entry.Open(); $sha = [Security.Cryptography.SHA256]::Create()
        try { $hash = ([BitConverter]::ToString($sha.ComputeHash($stream))).Replace('-', '').ToLowerInvariant() }
        finally { $stream.Dispose(); $sha.Dispose() }
        $relative = $entry.FullName.Replace('\', '/')
        if ($hash -ne (Get-FileHash -LiteralPath (Join-Path $package $relative) -Algorithm SHA256).Hash.ToLowerInvariant()) { throw "ZIP differs from verified package: $relative" }
    }
} finally { $archive.Dispose() }
$checksum = (Get-Content -LiteralPath "$zip.sha256" -Raw).Trim().Split(' ')[0]
if ($checksum -ne (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLowerInvariant()) { throw 'ZIP checksum mismatch.' }
if ($ValidateOnly) { Write-Host "Validated ${tag}: package allowlist, hashes, docs, and pinned source commits."; return }
$destination = & gh repo view $repo --json nameWithOwner,isPrivate | ConvertFrom-Json
if ($LASTEXITCODE -ne 0 -or $destination.nameWithOwner -ne $repo) { throw "Destination must be the $repo repository." }
# The repository is public, so everything uploaded below is world-readable (draft releases excepted).
if (-not $destination.isPrivate -and -not $Draft) { Write-Host "Publishing $tag publicly to $repo." }
$head = & git -C $PSScriptRoot rev-parse HEAD
$remoteHead = & git -C $PSScriptRoot ls-remote origin refs/heads/main
if ($LASTEXITCODE -ne 0 -or ($remoteHead -split '\s+')[0] -ne $head) { throw 'Push the parent main branch before publishing.' }
$notes = (Get-Content -LiteralPath (Join-Path $package 'README.md') -Raw) + "`n`n---`n`n" + (Get-Content -LiteralPath (Join-Path $package 'CHANGELOG.md') -Raw)
$notesPath = Join-Path $PSScriptRoot "dist/$tag-notes.md"
$notes | Set-Content -LiteralPath $notesPath -Encoding UTF8
$arguments = @('release', 'create', $tag, '--repo', $repo, '--target', $head, '--title', "$Character $Version (RoR2 1.2.4.4)", '--notes-file', $notesPath, '--latest=false', $zip, "$zip.sha256", "$(Join-Path $package 'README.md')#README.md", "$(Join-Path $package 'CHANGELOG.md')#CHANGELOG.md")
if ($Draft) { $arguments += '--draft' }
& gh @arguments
if ($LASTEXITCODE -ne 0) { throw 'GitHub release creation failed; no existing release was overwritten.' }
