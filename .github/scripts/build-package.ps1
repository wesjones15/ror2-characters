<#
.SYNOPSIS
  Builds the three plugins from the prepared workspace and runs package-release.ps1 on them.

.DESCRIPTION
  package-release.ps1 packages Mario, Olimar and Melee together (plus SharedFiles and the Thunderstore packages), so
  all three are built for every pipeline; each pipeline then publishes only its own files from the result. The plugins
  compile against the game's own DLLs, so RoR2Dir must point at a DLC4 (2026) install or reference folder on this
  machine. Nothing is staged into a game folder.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Workspace,
    [Parameter(Mandatory = $true)][string]$ReleaseRepo,
    [Parameter(Mandatory = $true)][string]$RoR2Dir,
    [Parameter(Mandatory = $true)][string]$PackageTag,
    [Parameter(Mandatory = $true)][string]$NotesFile,
    [Parameter(Mandatory = $true)][string]$OutDir
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
    throw "RoR2Dir '$RoR2Dir' has no 'Risk of Rain 2_Data/Managed/RoR2.dll'. Set the ROR2_REFERENCE_DIR repository variable to a DLC4 (2026) install on the runner."
}
$ps = 'powershell'
Invoke-Step 'Build Mario (libsms + MarioTest)' { & $ps -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Workspace 'ror2-mario/build.ps1') -RoR2Dir $RoR2Dir -NoInstall }
Invoke-Step 'Build Olimar (libpikmin + OlimarTest)' { & $ps -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Workspace 'ror2-olimar/build.ps1') -RoR2Dir $RoR2Dir -NoInstall }
# -SkipTests: the Rust and managed checks already ran in the check step; Melee's own suite is asset-bound.
Invoke-Step 'Build Melee (libssbm + Samus)' { & $ps -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Workspace 'ror2-samus/build.ps1') -RoR2Dir $RoR2Dir -SkipTests }

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
Invoke-Step 'Package' {
    & $ps -NoProfile -ExecutionPolicy Bypass -File (Join-Path $ReleaseRepo 'package-release.ps1') `
        -Tag $PackageTag -NotesFile $NotesFile -Workspace $OutDir -SourceRoot $Workspace
}
Write-Host "Packaged into $(Join-Path $OutDir $PackageTag)*"
