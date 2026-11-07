<#
.SYNOPSIS
  Assembles one combined GitHub release (Mario, Olimar and Melee) from the built source repositories.

.DESCRIPTION
  Build first (each repository's build.ps1; Melee: ror2-samus\build.ps1). This script copies the built DLLs,
  the guides and the changelog sections of the versions being released into <Workspace>\<Tag>\, writes
  release.json (versions, source commits, SHA-256 of every file), zips it with forward-slash entry names and
  writes <Tag>.zip.sha256. That ZIP is the manual install: the three plugin folders plus
  BepInEx/plugins/wesleyasaurus-SharedFiles (ror2-common/sharedfiles).

  It also writes one Thunderstore package per mod into <Workspace>\<Tag>-thunderstore\ (thunderstore\packages.json:
  wesleyasaurus-SharedFiles, -Mario, -Olimar, -Melee). Each is flat (manifest.json, README.md, icon.png and the files
  at the root): r2modman installs it into BepInEx/plugins/<namespace>-<name>/, the same folder name the manual ZIP
  uses for SharedFiles. It never pushes, tags or publishes: that is left to `gh release create` and the Thunderstore
  upload page.

  And one manual ZIP per mod into <Workspace>\<Tag>-mods\ (<Mod>-<version>.zip + .sha256 + <Mod>-CHANGELOG.md), for
  the per-mod GitHub releases: that mod's folder, SharedFiles, its guide and Install.md.

  Works in Windows PowerShell 5.1.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\package-release.ps1 -Tag release-20261020 -NotesFile .\releases\release-20261020.md
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]*$')][string]$Tag,
    [Parameter(Mandatory = $true)][string]$NotesFile,
    [string]$Workspace = '',
    [string]$SourceRoot = '',
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
if ([string]::IsNullOrWhiteSpace($SourceRoot)) { $SourceRoot = $Workspace }
$SourceRoot = [IO.Path]::GetFullPath($SourceRoot)
$out = Join-Path $Workspace $Tag
$zip = "$out.zip"
$thunderOut = "$out-thunderstore"
$modsOut = "$out-mods"
foreach ($path in @($out, $zip, "$zip.sha256", $thunderOut, $modsOut)) {
    if (Test-Path -LiteralPath $path) { throw "Refusing to overwrite $path." }
}
$notes = (Resolve-Path -LiteralPath $NotesFile).Path

# --- Source repositories: commits and cleanliness ----------------------------------------------------------------
$sources = [ordered]@{}
foreach ($name in @('libcommon', 'ror2-common', 'ror2-mario', 'ror2-olimar', 'ror2-samus', 'libsms', 'libpikmin', 'libssbm')) {
    $dir = Join-Path $SourceRoot $name
    $expectedBranch = if ($name -in @('libssbm', 'ror2-samus')) { 'main' } else { 'modern/1.5.0' }
    $actualBranch = (& git -C $dir branch --show-current).Trim()
    if ($LASTEXITCODE -ne 0 -or $actualBranch -ne $expectedBranch) {
        throw "Refusing to package $name from '$actualBranch'; expected '$expectedBranch'."
    }
    $commit = (& git -C $dir rev-parse HEAD).Trim()
    if ($LASTEXITCODE) { throw "Cannot read the revision of $name." }
    $dirty = @(& git -C $dir status --porcelain).Count -ne 0
    if ($dirty -and -not $AllowDirty) { throw "$name has uncommitted changes; commit them before releasing (or pass -AllowDirty)." }
    $pin = & git -C $PSScriptRoot ls-files --stage -- "sources/$name"
    if ($pin -notmatch "^160000 $commit 0\s") { throw "Pin sources/$name to $commit before packaging." }
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
    Mario  = Get-PluginVersion (Join-Path $SourceRoot 'ror2-mario\MarioTest\Plugin.cs') 'Mario'
    Olimar = Get-PluginVersion (Join-Path $SourceRoot 'ror2-olimar\OlimarTest\Plugin.cs') 'Olimar'
    Melee  = Get-PluginVersion (Join-Path $SourceRoot 'ror2-samus\Samus\Plugin.cs') 'Melee'
}

# --- Built files: plugin folder -> (source file) ------------------------------------------------------------------
$payload = @(
    @{ To = 'BepInEx/plugins/wesleyasaurus-Mario/MarioTest.dll'; From = 'ror2-mario\dist\MarioTest\MarioTest.dll' },
    @{ To = 'BepInEx/plugins/wesleyasaurus-Mario/sms.dll'; From = 'ror2-mario\dist\MarioTest\sms.dll' },
    @{ To = 'BepInEx/plugins/wesleyasaurus-Olimar/OlimarTest.dll'; From = 'ror2-olimar\dist\OlimarTest\OlimarTest.dll' },
    @{ To = 'BepInEx/plugins/wesleyasaurus-Olimar/pikmin.dll'; From = 'ror2-olimar\dist\OlimarTest\pikmin.dll' },
    @{ To = 'BepInEx/plugins/wesleyasaurus-Melee/Samus.dll'; From = 'ror2-samus\Samus\bin\Release\netstandard2.1\Samus.dll' },
    @{ To = 'BepInEx/plugins/wesleyasaurus-Melee/ssbm.dll'; From = 'libssbm\target\release\ssbm.dll' },
    # The shared disc/asset folder every mod reads (ror2-common SharedFiles): two placeholder READMEs, no code.
    @{ To = 'BepInEx/plugins/wesleyasaurus-SharedFiles/put_games_here/README.txt'; From = 'ror2-common\sharedfiles\put_games_here\README.txt' },
    @{ To = 'BepInEx/plugins/wesleyasaurus-SharedFiles/assets/README.txt'; From = 'ror2-common\sharedfiles\assets\README.txt' }
)
$docs = @(
    @{ To = 'docs/Mario.md'; From = 'docs\Mario.md' },
    @{ To = 'docs/Olimar.md'; From = 'docs\Olimar.md' },
    @{ To = 'docs/Melee.md'; From = 'docs\Melee.md' },
    @{ To = 'docs/Install.md'; From = 'docs\Install.md' },
    # Ship examples away from the live paths so merging BepInEx preserves players' settings and disc locations.
    @{ To = 'docs/examples/com.libpikmin.olimartest.cfg'; From = 'config\com.libpikmin.olimartest.cfg' },
    @{ To = 'docs/examples/com.libsms.mariotest.cfg'; From = 'config\com.libsms.mariotest.cfg' },
    @{ To = 'docs/examples/com.libssbm.melee.cfg'; From = 'config\com.libssbm.melee.cfg' }
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
    $candidate = if ($item.To.StartsWith('docs/')) { Join-Path $PSScriptRoot $item.From } else { Join-Path $SourceRoot $item.From }
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
if ($actual -match '^BepInEx/(config/|plugins/gamecube_library\.txt$)') { throw 'Package would replace player settings.' }
if ($actual -match '^BepInEx/plugins/wesleyasaurus-SharedFiles/assets/(?!README\.txt$)') { throw 'Package would put files in the extracted-assets folder.' }
$diff = @(Compare-Object ($expected | Sort-Object) ($actual | Sort-Object))
if ($diff.Count -ne 0) { throw "Package contents differ from the allowlist: $($diff | Out-String)" }
$stillMarked = @(Get-ChildItem -LiteralPath $out -Recurse -File | Where-Object { Get-Item -LiteralPath $_.FullName -Stream Zone.Identifier -ErrorAction SilentlyContinue })
if ($stillMarked.Count -ne 0) { throw 'Packaged files still carry a web-download mark.' }
foreach ($bad in @('assets_dir.txt', '.iso', '.ciso', '.gcm', '.wav', '.ssm', '.sem', '.dat')) {
    if ($actual | Where-Object { $_.EndsWith($bad, [StringComparison]::OrdinalIgnoreCase) }) { throw "Package contains $bad data." }
}

# --- Guard: the native DLLs must not need the Visual C++ Redistributable ------------------------------------------
# A player without it gets "module not found" (Win32 error 126) loading the DLL, and the plugin then registers
# nothing (no character, no mode, "incompatible mods" in multiplayer). The cores link the C runtime statically
# (.cargo/config.toml in each core); this reads each DLL's import table and refuses a package that still imports it.
function Get-PeImports([string]$path) {
    $b = [IO.File]::ReadAllBytes($path)
    $pe = [BitConverter]::ToInt32($b, 0x3c)
    $sections = [BitConverter]::ToUInt16($b, $pe + 6)
    $opt = $pe + 24
    $dir = $opt + $(if ([BitConverter]::ToUInt16($b, $opt) -eq 0x20b) { 112 } else { 96 })
    $importRva = [BitConverter]::ToUInt32($b, $dir + 8)
    $table = $opt + [BitConverter]::ToUInt16($b, $pe + 20)
    $map = @(for ($i = 0; $i -lt $sections; $i++) {
        $s = $table + $i * 40
        [pscustomobject]@{ Va = [BitConverter]::ToUInt32($b, $s + 12); Size = [Math]::Max([BitConverter]::ToUInt32($b, $s + 8), [BitConverter]::ToUInt32($b, $s + 16)); Raw = [BitConverter]::ToUInt32($b, $s + 20) }
    })
    function ToOffset([uint32]$rva) { foreach ($s in $map) { if ($rva -ge $s.Va -and $rva -lt $s.Va + $s.Size) { return [int]($rva - $s.Va + $s.Raw) } } return 0 }
    $names = @()
    $at = ToOffset $importRva
    while ($at -ne 0) {
        $nameRva = [BitConverter]::ToUInt32($b, $at + 12)
        if ($nameRva -eq 0) { break }
        $n = ToOffset $nameRva
        $e = $n; while ($b[$e] -ne 0) { $e++ }
        $names += [Text.Encoding]::ASCII.GetString($b, $n, $e - $n).ToLowerInvariant()
        $at += 20
    }
    return $names
}
foreach ($dll in @($actual | Where-Object { $_.EndsWith('/pikmin.dll') -or $_.EndsWith('/sms.dll') -or $_.EndsWith('/ssbm.dll') })) {
    $imports = Get-PeImports (Join-Path $out ($dll -replace '/', '\'))
    if ($imports.Count -eq 0) { throw "Could not read the import table of $dll." }
    $runtime = @($imports | Where-Object { $_ -match '^(vcruntime|msvcp|concrt|ucrtbase)' -or $_ -match '^api-ms-win-crt-' })
    if ($runtime.Count -ne 0) { throw "$dll needs the Visual C++ runtime ($($runtime -join ', ')); build it with the core's .cargo/config.toml (crt-static)." }
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

# --- Thunderstore: one flat package per mod, plus SharedFiles -------------------------------------------------------
# Same built files as the manual ZIP (copied from $out, so every guard above already applies to them).
$thunder = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'thunderstore\packages.json') -Raw | ConvertFrom-Json
New-Item -ItemType Directory -Path $thunderOut | Out-Null
$thunderZips = @()
foreach ($pkg in $thunder.packages) {
    if ($pkg.name -notmatch '^[A-Za-z0-9_]+$') { throw "Thunderstore package name '$($pkg.name)' may only use letters, digits and _." }
    # "version" wins when set: a Thunderstore-only re-upload (new page text, same DLLs) needs a new version number.
    $version = if ($pkg.PSObject.Properties['version']) { $pkg.version } elseif ($pkg.PSObject.Properties['plugin']) { $versions[$pkg.plugin] } else { throw "No version for $($pkg.name)." }
    if ($version -notmatch '^\d+\.\d+\.\d+$') { throw "Thunderstore version '$version' of $($pkg.name) must be Major.Minor.Patch." }
    if ($pkg.description.Length -gt 250) { throw "Thunderstore description of $($pkg.name) is over 250 characters." }
    $assets = Join-Path $PSScriptRoot "thunderstore\$($pkg.name)"
    foreach ($need in @('README.md', 'icon.png')) {
        if (-not (Test-Path -LiteralPath (Join-Path $assets $need))) { throw "Missing thunderstore\$($pkg.name)\$need." }
    }
    # Thunderstore requires a 256x256 PNG icon.
    Add-Type -AssemblyName System.Drawing
    $icon = [Drawing.Image]::FromFile((Join-Path $assets 'icon.png'))
    try { if ($icon.Width -ne 256 -or $icon.Height -ne 256) { throw "thunderstore\$($pkg.name)\icon.png must be 256x256." } } finally { $icon.Dispose() }
    $deps = @()
    if ($pkg.name -ne 'SharedFiles') { $deps += $thunder.common_dependencies }
    $deps += @($pkg.dependencies)
    $manifestJson = [ordered]@{
        name = $pkg.name; version_number = $version; website_url = $thunder.website_url
        description = $pkg.description; dependencies = @($deps)
    } | ConvertTo-Json -Depth 4
    $entries = [ordered]@{
        'manifest.json' = (New-Object Text.UTF8Encoding($false)).GetBytes($manifestJson)
        'README.md'     = [IO.File]::ReadAllBytes((Join-Path $assets 'README.md'))
        'icon.png'      = [IO.File]::ReadAllBytes((Join-Path $assets 'icon.png'))
    }
    foreach ($file in $pkg.files) {
        # Every payload file must be one the manual ZIP already holds (and so has passed its guards).
        $match = @($payload | Where-Object { $_.From -eq ($file.from -replace '/', '\') })
        if ($match.Count -ne 1) { throw "Thunderstore file $($file.from) is not in the manual payload." }
        $entries[$file.to] = [IO.File]::ReadAllBytes((Join-Path $out ($match[0].To -replace '/', '\')))
    }
    foreach ($name in $entries.Keys) {
        foreach ($bad in @('assets_dir.txt', '.iso', '.ciso', '.gcm', '.wav', '.ssm', '.sem', '.dat', '.cfg')) {
            if ($name.EndsWith($bad, [StringComparison]::OrdinalIgnoreCase)) { throw "Thunderstore package $($pkg.name) contains $bad." }
        }
        if ($name -match '^(BepInEx|config)/') { throw "Thunderstore package $($pkg.name) must be flat; $name is not." }
    }
    $tzip = Join-Path $thunderOut ("{0}-{1}-{2}.zip" -f $thunder.namespace, $pkg.name, $version)
    $archive = [IO.Compression.ZipFile]::Open($tzip, [IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($name in $entries.Keys) {
            $stream = $archive.CreateEntry($name, [IO.Compression.CompressionLevel]::Optimal).Open()
            try { $stream.Write($entries[$name], 0, $entries[$name].Length) } finally { $stream.Dispose() }
        }
    } finally { $archive.Dispose() }
    $thunderZips += $tzip
}

# --- One manual ZIP per mod (for the per-mod GitHub releases) ------------------------------------------------------
# Each holds that mod's plugin folder, SharedFiles, its guide, Install.md, its example config, README.md (the release
# notes) and CHANGELOG.md (that mod's section only). Built from the files already in $out, so the guards above apply.
New-Item -ItemType Directory -Path $modsOut | Out-Null
$modZips = @()
$modExamples = @{ Mario = 'com.libsms.mariotest.cfg'; Olimar = 'com.libpikmin.olimartest.cfg'; Melee = 'com.libssbm.melee.cfg' }
foreach ($mod in @('Mario', 'Olimar', 'Melee')) {
    $prefix = "BepInEx/plugins/wesleyasaurus-$mod/"
    $pick = @($actual | Where-Object {
        $_.StartsWith($prefix) -or $_.StartsWith('BepInEx/plugins/wesleyasaurus-SharedFiles/') -or
        $_ -eq "docs/$mod.md" -or $_ -eq 'docs/Install.md' -or $_ -eq "docs/examples/$($modExamples[$mod])" -or $_ -eq 'README.md'
    })
    if (-not ($pick | Where-Object { $_.StartsWith($prefix) })) { throw "No plugin files for $mod." }
    $modChangelog = "# $mod changelog`n`nWhat changed since the previous published $mod version.`n`n" + (Get-ChangelogSection $mod $versions[$mod]) + "`n"
    $mzip = Join-Path $modsOut ("{0}-{1}.zip" -f $mod, $versions[$mod])
    $archive = [IO.Compression.ZipFile]::Open($mzip, [IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($rel in ($pick | Sort-Object)) {
            $stream = $archive.CreateEntry($rel, [IO.Compression.CompressionLevel]::Optimal).Open()
            try { $bytes = [IO.File]::ReadAllBytes((Join-Path $out ($rel -replace '/', '\'))); $stream.Write($bytes, 0, $bytes.Length) } finally { $stream.Dispose() }
        }
        $stream = $archive.CreateEntry('CHANGELOG.md', [IO.Compression.CompressionLevel]::Optimal).Open()
        try { $bytes = (New-Object Text.UTF8Encoding($false)).GetBytes($modChangelog); $stream.Write($bytes, 0, $bytes.Length) } finally { $stream.Dispose() }
    } finally { $archive.Dispose() }
    [IO.File]::WriteAllText((Join-Path $modsOut "$mod-CHANGELOG.md"), $modChangelog, (New-Object Text.UTF8Encoding($false)))
    $sum = (Get-FileHash -LiteralPath $mzip -Algorithm SHA256).Hash.ToLowerInvariant()
    [IO.File]::WriteAllText("$mzip.sha256", "$sum  $(Split-Path -Leaf $mzip)`n", (New-Object Text.ASCIIEncoding))
    $modZips += "$mzip ($sum)"
}

Write-Host "Packaged $Tag"
Write-Host ("  Mario {0}, Olimar {1}, Melee {2}" -f $versions.Mario, $versions.Olimar, $versions.Melee)
Write-Host "  $out"
Write-Host "  $zip ($checksum)"
foreach ($tzip in $thunderZips) { Write-Host "  Thunderstore: $tzip" }
foreach ($mzip in $modZips) { Write-Host "  Per mod: $mzip" }
