[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)][string]$InstallDir,
    [string]$MarioPackage,
    [string]$OlimarPackage
)
$ErrorActionPreference = 'Stop'
if (-not $MarioPackage -and -not $OlimarPackage) { throw 'Supply -MarioPackage, -OlimarPackage, or both (unpacked release folders).' }
$target = Join-Path (Resolve-Path -LiteralPath $InstallDir).Path 'BepInEx'
if (-not (Test-Path -LiteralPath $target -PathType Container)) { throw "$InstallDir has no BepInEx folder; install BepInEx first." }
foreach ($selection in @(@{ Name = 'Mario'; Path = $MarioPackage }, @{ Name = 'Olimar'; Path = $OlimarPackage })) {
    if (-not $selection.Path) { continue }
    $path = (Resolve-Path -LiteralPath $selection.Path).Path
    $manifest = Get-Content -LiteralPath (Join-Path $path 'release.json') -Raw | ConvertFrom-Json
    if ($manifest.character -ne $selection.Name) { throw "Wrong character in $path" }
    # What the ZIP asks of a user: its BepInEx folder, merged into the game's.
    if ($PSCmdlet.ShouldProcess($InstallDir, "Copy $($selection.Name)'s BepInEx folder")) {
        Copy-Item -Path (Join-Path $path 'BepInEx/*') -Destination $target -Recurse -Force
    }
}
