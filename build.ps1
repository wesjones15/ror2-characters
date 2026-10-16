[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][ValidateSet('Mario', 'Olimar')][string]$Character,
    [Parameter(Mandatory = $true)][ValidatePattern('^\d+\.\d+\.\d+(\.\d+)?$')][string]$Version,
    [Parameter(Mandatory = $true)][string]$RoR2Dir
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Invoke-Checked([string]$Program, [string[]]$Arguments) {
    & $Program @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Program failed ($LASTEXITCODE)." }
}
$RoR2Dir = (Resolve-Path -LiteralPath $RoR2Dir).Path
$sources = Join-Path $PSScriptRoot 'sources'
if ($Character -eq 'Mario') {
    $native = 'libsms'; $hostRepo = 'ror2-mario'; $plugin = 'MarioTest'; $dll = 'sms.dll'; $abi = 26
} else {
    $native = 'libpikmin'; $hostRepo = 'ror2-olimar'; $plugin = 'OlimarTest'; $dll = 'pikmin.dll'; $abi = 30
}
$changelog = Get-Content -LiteralPath (Join-Path $PSScriptRoot "changelogs/$Character.md") -Raw
if ($changelog -notmatch "(?m)^## $([regex]::Escape($Version)) - ") { throw "Add a $Version entry to changelogs/$Character.md first." }
$commits = [ordered]@{}
foreach ($repo in @($native, $hostRepo, 'ror2-common')) {
    $path = Join-Path $sources $repo
    $head = (& git -C $path rev-parse HEAD)
    if ($LASTEXITCODE -ne 0) { throw "Initialize sources/$repo with git submodule update --init." }
    if (@(& git -C $path status --porcelain).Count -ne 0) { throw "Dirty source checkout: $repo" }
    $pinned = & git -C $PSScriptRoot ls-files --stage -- "sources/$repo"
    if ($pinned -notmatch "^160000 $head 0\s") { throw "Commit the selected $repo submodule pointer before building." }
    $commits[$repo] = $head
}
$sourcePlugin = Get-Content -LiteralPath (Join-Path $sources "$hostRepo/$plugin/Plugin.cs") -Raw
if ($sourcePlugin -notmatch "BepInPlugin\(Guid, `"$Character`", `"$([regex]::Escape($Version))`"\)") {
    throw 'Release version must match the BepInPlugin version in source.'
}
$nativeSource = Get-Content -LiteralPath (Join-Path $sources "$native/crates/$native-ffi/src/lib.rs") -Raw
$hostNative = Get-Content -LiteralPath (Join-Path $sources "$hostRepo/$plugin/Native.cs") -Raw
if ($nativeSource -notmatch "ABI_VERSION: u32 = $abi;" -or $hostNative -notmatch "AbiVersion = $abi;") {
    throw 'Update the release ABI and README to match the native library and host.'
}
$core = Join-Path $RoR2Dir 'BepInEx/core/BepInEx.dll'
if (-not (Test-Path -LiteralPath $core) -or [Diagnostics.FileVersionInfo]::GetVersionInfo($core).FileVersion -ne '5.4.21.0') {
    throw 'Build against the documented RoR2 DLC4 (2026) / BepInEx 5.4.21.0 installation.'
}
foreach ($reference in @('RoR2.dll', 'UnityEngine.CoreModule.dll')) {
    if (-not (Test-Path -LiteralPath (Join-Path $RoR2Dir "Risk of Rain 2_Data/Managed/$reference"))) { throw "Missing local reference: $reference" }
}
$dist = Join-Path $PSScriptRoot 'dist'
$name = "$Character-modern-$Version-win-x64"
$package = Join-Path $dist $name
$zip = "$package.zip"
if ((Test-Path -LiteralPath $package) -or (Test-Path -LiteralPath $zip)) { throw "Output already exists: $package. Move it aside before rebuilding this version." }
Push-Location (Join-Path $sources $native)
try { Invoke-Checked cargo @('build', '--locked', '--release', '--target', 'x86_64-pc-windows-msvc', '-p', "$native-ffi") }
finally { Pop-Location }
Invoke-Checked dotnet @('build', (Join-Path $sources "$hostRepo/$plugin/$plugin.csproj"), '-c', 'Release', "-p:RoR2Dir=$RoR2Dir")
$destination = Join-Path $package "BepInEx/plugins/$plugin"
New-Item -ItemType Directory -Path $destination -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $sources "$native/target/x86_64-pc-windows-msvc/release/$dll") -Destination $destination
Copy-Item -LiteralPath (Join-Path $sources "$hostRepo/$plugin/bin/Release/netstandard2.1/$plugin.dll") -Destination $destination
Copy-Item -LiteralPath (Join-Path $PSScriptRoot "docs/$Character.md") -Destination (Join-Path $package 'README.md')
Copy-Item -LiteralPath (Join-Path $PSScriptRoot "changelogs/$Character.md") -Destination (Join-Path $package 'CHANGELOG.md')
$relativePaths = @('README.md', 'CHANGELOG.md', "BepInEx/plugins/$plugin/$plugin.dll", "BepInEx/plugins/$plugin/$dll")
$files = @($relativePaths | ForEach-Object { [ordered]@{ path = $_; sha256 = (Get-FileHash -LiteralPath (Join-Path $package $_) -Algorithm SHA256).Hash.ToLowerInvariant() } })
$manifest = [ordered]@{
    schema = 1; character = $Character; version = $Version; nativeAbi = $abi
    channel = 'modern'; sourceBranch = (& git -C $PSScriptRoot branch --show-current); parentCommit = (& git -C $PSScriptRoot rev-parse HEAD)
    game = 'Risk of Rain 2'; gameVersion = 'DLC4 (2026)'; unity = '2021.3.45f2'; platform = 'win-x64'
    bepinex = '5.4.21.0'; ror2BepInExPack = '1.46.0'; sourceCommits = $commits
    toolchain = [ordered]@{ rust = (& rustc --version); dotnet = (& dotnet --version) }
    files = $files
}
$manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $package 'release.json') -Encoding UTF8
[IO.Compression.ZipFile]::CreateFromDirectory($package, $zip)
$checksum = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLowerInvariant()
"$checksum  $name.zip" | Set-Content -LiteralPath "$zip.sha256" -Encoding ASCII
Write-Host "Built $zip (only mod DLLs, documentation, and manifest)."
