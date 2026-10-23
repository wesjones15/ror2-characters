<#
.SYNOPSIS
  Assembles one combined GitHub release (Mario, Olimar and Melee) from the built source repositories.

.DESCRIPTION
  Build first (each repository's build.ps1; Melee: ror2-samus\build.ps1). This script copies the built DLLs,
  the guides and the changelog sections of the versions being released into <Workspace>\<Tag>\, writes
  release.json (versions, source commits, SHA-256 of every file), zips it with forward-slash entry names and
  writes <Tag>.zip.sha256. It never pushes, tags or publishes: that is left to `gh release create`.

  Works in Windows PowerShell 5.1.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\package-release.ps1 -Tag release-20261020 -NotesFile .\releases\release-20261020.md
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]*$')][string]$Tag,
    [Parameter(Mandatory = $true)][string]$NotesFile,
    [string]$Workspace = '',
    [switch]$AllowDirty
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

# --- Locate the workspace (the folder holding libssbm, ror2-mario, ...) -------------------------------------------
if ([string]::IsNullOrWhiteSpace($Workspace)) {
    $probe = $PSScriptRoot
    while ($probe -and -not ((Test-Path (Join-Path $probe 'libssbm')) -and (Test-Path (Join-Path $probe 'ror2-mario')))) {
        $probe = Split-Path -Parent $probe
    }
    if (-not $probe) { throw 'Cannot find the workspace; pass -Workspace.' }
    $Workspace = $probe
}
$Workspace = [IO.Path]::GetFullPath($Workspace)
$out = Join-Path $Workspace $Tag
$zip = "$out.zip"
foreach ($path in @($out, $zip, "$zip.sha256")) {
    if (Test-Path -LiteralPath $path) { throw "Refusing to overwrite $path." }
}
$notes = (Resolve-Path -LiteralPath $NotesFile).Path

# --- Source repositories: commits and cleanliness ----------------------------------------------------------------
$sources = [ordered]@{}
foreach ($name in @('ror2-common', 'ror2-mario', 'ror2-olimar', 'ror2-samus', 'libsms', 'libpikmin', 'libssbm')) {
    $dir = Join-Path $Workspace $name
    $commit = (& git -C $dir rev-parse HEAD).Trim()
    if ($LASTEXITCODE) { throw "Cannot read the revision of $name." }
    $dirty = @(& git -C $dir status --porcelain).Count -ne 0
    if ($dirty -and -not $AllowDirty) { throw "$name has uncommitted changes; commit them before releasing (or pass -AllowDirty)." }
    $sources[$name] = [ordered]@{ commit = $commit; dirty = $dirty }
}
$parent = (& git -C $PSScriptRoot rev-parse HEAD).Trim()

# --- Versions, read from the plugin attributes --------------------------------------------------------------------
function Get-PluginVersion([string]$file, [string]$display) {
    $text = [IO.File]::ReadAllText($file)
    $m = [regex]::Match($text, 'BepInPlugin\([^,]+,\s*"' + [regex]::Escape($display) + '"\s*,\s*"([0-9.]+)"\)')
    if (-not $m.Success) { throw "No BepInPlugin version for $display in $file." }
    return $m.Groups[1].Value
}
$versions = [ordered]@{
    Mario  = Get-PluginVersion (Join-Path $Workspace 'ror2-mario\MarioTest\Plugin.cs') 'Mario'
    Olimar = Get-PluginVersion (Join-Path $Workspace 'ror2-olimar\OlimarTest\Plugin.cs') 'Olimar'
    Melee  = Get-PluginVersion (Join-Path $Workspace 'ror2-samus\Samus\Plugin.cs') 'Melee'
}

# --- Built files: plugin folder -> (source file) ------------------------------------------------------------------
$payload = @(
    @{ To = 'BepInEx/plugins/MarioTest/MarioTest.dll'; From = 'ror2-mario\dist\MarioTest\MarioTest.dll' },
    @{ To = 'BepInEx/plugins/MarioTest/sms.dll'; From = 'ror2-mario\dist\MarioTest\sms.dll' },
    @{ To = 'BepInEx/plugins/OlimarTest/OlimarTest.dll'; From = 'ror2-olimar\dist\OlimarTest\OlimarTest.dll' },
    @{ To = 'BepInEx/plugins/OlimarTest/pikmin.dll'; From = 'ror2-olimar\dist\OlimarTest\pikmin.dll' },
    @{ To = 'BepInEx/plugins/Melee/Samus.dll'; From = 'ror2-samus\Samus\bin\Release\netstandard2.1\Samus.dll' },
    @{ To = 'BepInEx/plugins/Melee/ssbm.dll'; From = 'libssbm\target\release\ssbm.dll' }
)
$docs = @(
    @{ To = 'docs/Mario.md'; From = 'docs\Mario.md' },
    @{ To = 'docs/Olimar.md'; From = 'docs\Olimar.md' },
    @{ To = 'docs/Melee.md'; From = 'docs\Melee.md' },
    # Each plugin's settings at this release's defaults (generated from its Config.Bind calls). Replacing an
    # older file resets every setting, including Paths; BepInEx adds any key the file leaves out at its default.
    @{ To = 'BepInEx/config/com.libpikmin.olimartest.cfg'; From = 'config\com.libpikmin.olimartest.cfg' },
    @{ To = 'BepInEx/config/com.libsms.mariotest.cfg'; From = 'config\com.libsms.mariotest.cfg' },
    @{ To = 'BepInEx/config/com.libssbm.melee.cfg'; From = 'config\com.libssbm.melee.cfg' }
)

# --- The changelog sections of the versions being released -------------------------------------------------------
function Get-ChangelogSection([string]$name, [string]$version) {
    $lines = [IO.File]::ReadAllLines((Join-Path $PSScriptRoot "changelogs\$name.md"))
    $start = -1
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match ('^## ' + [regex]::Escape($version) + ' - ')) { $start = $i; break }
    }
    if ($start -lt 0) { throw "changelogs\$name.md has no entry for $version." }
    $end = $lines.Length
    for ($i = $start + 1; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match '^## ') { $end = $i; break }
    }
    return ($lines[$start..($end - 1)] -join "`n").TrimEnd()
}
$changelog = "# Changelog`n`nEach section lists what changed since that character's previous published version.`n"
foreach ($pair in @(@('Mario', 'Mario'), @('Olimar', 'Olimar'), @('Melee', 'Melee'))) {
    $section = Get-ChangelogSection $pair[0] $versions[$pair[1]]
    $changelog += "`n# $($pair[0])`n`n" + $section + "`n"
}

# --- Assemble ---------------------------------------------------------------------------------------------------
New-Item -ItemType Directory -Path $out | Out-Null
$files = New-Object System.Collections.Generic.List[string]
foreach ($item in $payload + $docs) {
    $candidate = if ([IO.Path]::IsPathRooted($item.From)) { $item.From } elseif ($item.To.StartsWith('docs/') -or $item.To.StartsWith('BepInEx/config/')) { Join-Path $PSScriptRoot $item.From } else { Join-Path $Workspace $item.From }
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) { throw "Missing build output: $candidate" }
    $target = Join-Path $out ($item.To -replace '/', '\')
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
    Copy-Item -LiteralPath $candidate -Destination $target
    $files.Add($item.To)
}
# A file that came from a download or an archive extracted from one carries a Zone.Identifier stream, and Windows
# then asks "These files might be harmful" when the folder is copied into a game install. Build outputs should
# not have one; clear it on the staged copies (never on the sources) and say so, so the cause gets fixed.
$marked = @(Get-ChildItem -LiteralPath $out -Recurse -File | Where-Object { Get-Item -LiteralPath $_.FullName -Stream Zone.Identifier -ErrorAction SilentlyContinue })
foreach ($file in $marked) {
    Write-Warning ("{0} carried a web-download mark (Zone.Identifier); cleared it on the packaged copy. Check where that build output came from." -f $file.FullName.Substring($out.Length + 1))
    Unblock-File -LiteralPath $file.FullName
}
[IO.File]::WriteAllText((Join-Path $out 'README.md'), [IO.File]::ReadAllText($notes), (New-Object Text.UTF8Encoding($false)))
[IO.File]::WriteAllText((Join-Path $out 'CHANGELOG.md'), $changelog, (New-Object Text.UTF8Encoding($false)))
$files.Add('README.md'); $files.Add('CHANGELOG.md')

$entries = @()
foreach ($rel in $files) {
    $entries += [ordered]@{ path = $rel; sha256 = (Get-FileHash -LiteralPath (Join-Path $out ($rel -replace '/', '\')) -Algorithm SHA256).Hash.ToLowerInvariant() }
}
$manifest = [ordered]@{
    tag = $Tag; game = 'Risk of Rain 2'; gameVersion = 'DLC4 (2026)'; unity = '2021.3.45f2'; platform = 'win-x64'
    versions = $versions; releaseRepoCommit = $parent; sources = $sources; files = $entries
}
$manifestText = $manifest | ConvertTo-Json -Depth 8
[IO.File]::WriteAllText((Join-Path $out 'release.json'), $manifestText, (New-Object Text.UTF8Encoding($false)))

# --- Guard: only the approved files, no game data or local path hints ---------------------------------------------
$expected = @($files) + @('release.json')
$actual = @(Get-ChildItem -LiteralPath $out -File -Recurse | ForEach-Object { $_.FullName.Substring($out.Length + 1).Replace('\', '/') })
$diff = @(Compare-Object ($expected | Sort-Object) ($actual | Sort-Object))
if ($diff.Count -ne 0) { throw "Package contents differ from the allowlist: $($diff | Out-String)" }
$stillMarked = @(Get-ChildItem -LiteralPath $out -Recurse -File | Where-Object { Get-Item -LiteralPath $_.FullName -Stream Zone.Identifier -ErrorAction SilentlyContinue })
if ($stillMarked.Count -ne 0) { throw 'Packaged files still carry a web-download mark.' }
foreach ($bad in @('assets_dir.txt', '.iso', '.ciso', '.gcm', '.wav', '.ssm', '.sem', '.dat')) {
    if ($actual | Where-Object { $_.EndsWith($bad, [StringComparison]::OrdinalIgnoreCase) }) { throw "Package contains $bad data." }
}

# --- Zip with forward-slash entry names (Compress-Archive in 5.1 writes backslashes) ------------------------------
$archive = [IO.Compression.ZipFile]::Open($zip, [IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($rel in ($actual | Sort-Object)) {
        $entry = $archive.CreateEntry($rel, [IO.Compression.CompressionLevel]::Optimal)
        $stream = $entry.Open()
        try {
            $bytes = [IO.File]::ReadAllBytes((Join-Path $out ($rel -replace '/', '\')))
            $stream.Write($bytes, 0, $bytes.Length)
        } finally { $stream.Dispose() }
    }
} finally { $archive.Dispose() }
$checksum = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLowerInvariant()
[IO.File]::WriteAllText("$zip.sha256", "$checksum  $Tag.zip`n", (New-Object Text.ASCIIEncoding))

Write-Host "Packaged $Tag"
Write-Host ("  Mario {0}, Olimar {1}, Melee {2}" -f $versions.Mario, $versions.Olimar, $versions.Melee)
Write-Host "  $out"
Write-Host "  $zip ($checksum)"
