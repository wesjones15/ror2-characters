[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)][string]$InstallDir,
    [string]$MarioPackage,
    [string]$OlimarPackage
)
$ErrorActionPreference = 'Stop'
if (-not $MarioPackage -and -not $OlimarPackage) { throw 'Supply -MarioPackage, -OlimarPackage, or both (unpacked release folders).' }
foreach ($selection in @(@{ Name = 'Mario'; Path = $MarioPackage }, @{ Name = 'Olimar'; Path = $OlimarPackage })) {
    if (-not $selection.Path) { continue }
    $path = (Resolve-Path -LiteralPath $selection.Path).Path
    $manifest = Get-Content -LiteralPath (Join-Path $path 'release.json') -Raw | ConvertFrom-Json
    if ($manifest.character -ne $selection.Name) { throw "Wrong character in $path" }
    & (Join-Path $path 'install.ps1') -InstallDir $InstallDir -WhatIf:$WhatIfPreference
}
