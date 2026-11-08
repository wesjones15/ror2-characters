<#
.SYNOPSIS
  Creates a reference folder in the layout the build scripts take as -RoR2Dir, from NuGet packages.

.DESCRIPTION
  <OutDir>\Risk of Rain 2_Data\Managed  the game's assemblies (RiskOfRain2.GameLibs) and UnityEngine.* (UnityEngine.Modules)
  <OutDir>\BepInEx\core                  BepInEx.dll, Mono.Cecil, MonoMod.*
  These are publicized, stripped reference assemblies: enough to compile the plugins, not to run them. Builds against
  them must set PublicizedGameLibs=true (see ror2-common/build/RoR2References.targets).
#>
[CmdletBinding()]
param([Parameter(Mandatory = $true)][string]$OutDir)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$work = Join-Path ([IO.Path]::GetTempPath()) ("refgen-" + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $work | Out-Null
try {
    # Build a copy in the temp folder so obj/ and bin/ (which hold absolute local paths) never appear in the repository.
    $projectDir = Join-Path $work 'project'
    New-Item -ItemType Directory -Path $projectDir | Out-Null
    Copy-Item (Join-Path $PSScriptRoot '../reference-assemblies/RefGen.csproj'), (Join-Path $PSScriptRoot '../reference-assemblies/nuget.config') $projectDir
    $buildOut = Join-Path $work 'out'
    & dotnet build (Join-Path $projectDir 'RefGen.csproj') -c Release -o $buildOut --nologo -v quiet
    if ($LASTEXITCODE -ne 0) { throw 'Restoring the reference assemblies from NuGet failed.' }
    $managed = Join-Path $OutDir 'Risk of Rain 2_Data/Managed'
    $core = Join-Path $OutDir 'BepInEx/core'
    New-Item -ItemType Directory -Force -Path $managed, $core | Out-Null
    foreach ($dll in Get-ChildItem -LiteralPath $buildOut -Filter *.dll) {
        if ($dll.Name -eq 'RefGen.dll') { continue }
        $dest = if ($dll.Name -match '^(BepInEx\.dll|0Harmony.*\.dll|Mono\.Cecil.*\.dll|MonoMod.*\.dll)$') { $core } else { $managed }
        Copy-Item -LiteralPath $dll.FullName -Destination $dest -Force
    }
    foreach ($need in @('Risk of Rain 2_Data/Managed/RoR2.dll', 'Risk of Rain 2_Data/Managed/UnityEngine.CoreModule.dll', 'BepInEx/core/BepInEx.dll', 'BepInEx/core/Mono.Cecil.dll', 'BepInEx/core/MonoMod.Utils.dll', 'BepInEx/core/MonoMod.RuntimeDetour.dll')) {
        if (-not (Test-Path -LiteralPath (Join-Path $OutDir $need))) { throw "Reference folder is missing $need." }
    }
    Write-Host ("Reference folder: {0} game/Unity DLLs, {1} BepInEx DLLs" -f @(Get-ChildItem $managed -Filter *.dll).Count, @(Get-ChildItem $core -Filter *.dll).Count)
} finally { Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue }
