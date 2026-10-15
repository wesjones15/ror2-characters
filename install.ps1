# Included in each extracted character release. Does not download or install dependencies.
[CmdletBinding(SupportsShouldProcess = $true)]
param([Parameter(Mandatory = $true)][string]$InstallDir)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$manifest = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'release.json') -Raw | ConvertFrom-Json
switch ($manifest.character) {
    'Mario' { $folder = 'MarioTest'; $dlls = @('MarioTest.dll', 'sms.dll') }
    'Olimar' { $folder = 'OlimarTest'; $dlls = @('OlimarTest.dll', 'pikmin.dll') }
    default { throw 'Unknown character in release.json.' }
}
$expected = @('README.md', 'CHANGELOG.md', 'install.ps1') + @($dlls | ForEach-Object { "BepInEx/plugins/$folder/$_" })
$actual = @($manifest.files | ForEach-Object { $_.path })
if (@(Compare-Object $expected $actual).Count -ne 0 -or $actual.Count -ne $expected.Count) {
    throw 'Release manifest contains unexpected or missing files.'
}
foreach ($file in $manifest.files) {
    $path = Join-Path $PSScriptRoot $file.path
    if (-not (Test-Path -LiteralPath $path -PathType Leaf) -or
        (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash -ne $file.sha256) {
        throw "Missing or modified package file: $($file.path)"
    }
}
$InstallDir = [IO.Path]::GetFullPath($InstallDir)
$core = Join-Path $InstallDir 'BepInEx/core/BepInEx.dll'
if (-not (Test-Path -LiteralPath $core -PathType Leaf)) {
    throw 'Install BepInEx 5.4.21.0 first; see README.md. InstallDir must contain BepInEx/core/BepInEx.dll.'
}
$bepVersion = [Diagnostics.FileVersionInfo]::GetVersionInfo($core).FileVersion
if ($bepVersion -ne '5.4.21.0') { throw "This release targets BepInEx 5.4.21.0; found $bepVersion." }
$target = Join-Path $InstallDir "BepInEx/plugins/$folder"
if ($PSCmdlet.ShouldProcess($target, "Install $($manifest.character) $($manifest.version) (two verified DLLs)")) {
    New-Item -ItemType Directory -Path $target -Force | Out-Null
    foreach ($dll in $dlls) {
        Copy-Item -LiteralPath (Join-Path $PSScriptRoot "BepInEx/plugins/$folder/$dll") -Destination (Join-Path $target $dll) -Force
    }
    Write-Host "Installed $($manifest.character) into $target. Follow README.md to configure your disc image."
}
