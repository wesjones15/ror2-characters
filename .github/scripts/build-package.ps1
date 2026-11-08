<#
.SYNOPSIS
  Builds the three plugins from the prepared workspace and runs package-release.ps1 on them.

.DESCRIPTION
  package-release.ps1 packages Mario, Olimar and Melee together (plus SharedFiles and the Thunderstore packages), so
  all three are built for every pipeline; each pipeline then publishes only its own files from the result.
  RoR2Dir is a reference folder made by make-reference-dir.ps1 from NuGet packages (publicized, stripped game
  libraries), so PublicizedGameLibs is set for every compile. Nothing is staged into a game folder.

  Melee is built with the same two commands its build.ps1 ends in (libssbm-ffi, then the Samus project) instead of
  calling build.ps1: that script runs cargo --offline (no registry cache on a fresh runner) and a startup check that
  loads the game's assemblies, which stripped references cannot do. Neither affects the packaged DLLs.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Workspace,
    [Parameter(Mandatory = $true)][string]$ReleaseRepo,
    [Parameter(Mandatory = $true)][string]$RoR2Dir,
    [Parameter(Mandatory = $true)][string]$PackageTag,
    [Parameter(Mandatory = $true)][string]$NotesFile,
    [Parameter(Mandatory = $true)][string]$OutDir,
    [switch]$Publicized,
    [switch]$SkipPackage   # build only (dry run); package-release.ps1 needs the pinned commits
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
function Invoke-Step([string]$Name, [scriptblock]$Block) {
    Write-Host "::group::$Name"
    & $Block
    if ($LASTEXITCODE -ne 0) { throw "$Name failed ($LASTEXITCODE)." }
    Write-Host '::endgroup::'
}
if (-not (Test-Path -LiteralPath (Join-Path $RoR2Dir 'Risk of Rain 2_Data/Managed/RoR2.dll'))) {
    throw "RoR2Dir '$RoR2Dir' has no 'Risk of Rain 2_Data/Managed/RoR2.dll'."
}
# MSBuild reads environment variables as properties, so the component build scripts pick this up unchanged.
if ($Publicized) { $env:PublicizedGameLibs = 'true' }
$ps = 'powershell'
Invoke-Step 'Build Mario (libsms + MarioTest)' { & $ps -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Workspace 'ror2-mario/build.ps1') -RoR2Dir $RoR2Dir -NoInstall }
Invoke-Step 'Build Olimar (libpikmin + OlimarTest)' { & $ps -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Workspace 'ror2-olimar/build.ps1') -RoR2Dir $RoR2Dir -NoInstall }
Invoke-Step 'Build Melee native (libssbm-ffi)' {
    Push-Location (Join-Path $Workspace 'libssbm')
    try { & cargo build -p libssbm-ffi --release } finally { Pop-Location }
}
Invoke-Step 'Build Melee plugin (Samus)' {
    & dotnet build (Join-Path $Workspace 'ror2-samus/Samus/Samus.csproj') -c Release "-p:RoR2Dir=$RoR2Dir" "-p:Ror2CommonDir=$(Join-Path $Workspace 'ror2-common')"
}
# The same no-assets gate the Mario and Olimar build scripts run against their DLLs (ror2-samus/build.ps1 runs it for ssbm.dll).
Invoke-Step 'No-assets gate (ssbm.dll)' {
    & dotnet run --project (Join-Path $Workspace 'ror2-common/tests/NoAssetsCheck') -c Release -- ssbm (Join-Path $Workspace 'libssbm/target/release/ssbm.dll')
}

if ($SkipPackage) { Write-Host 'Built all three plugins; -SkipPackage, so nothing was packaged.'; return }
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
Invoke-Step 'Package' {
    & $ps -NoProfile -ExecutionPolicy Bypass -File (Join-Path $ReleaseRepo 'package-release.ps1') `
        -Tag $PackageTag -NotesFile $NotesFile -Workspace $OutDir -SourceRoot $Workspace
}
Write-Host "Packaged into $(Join-Path $OutDir $PackageTag)*"
