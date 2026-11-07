<#
.SYNOPSIS
  Runs the checks that need no game files and no extracted assets: the Rust suites and the managed check projects.

.DESCRIPTION
  Asset-bound checks cannot run in CI. Rust tests that need an extracted disc cache return early when it is absent
  (a green result then means "skipped", not "verified"), and the managed checks that need the game's own DLLs
  (SkinPresentationCheck, FireCheck) only run where RoR2Dir is supplied. In-game behaviour is tested by hand.
  Scope picks the pieces a release actually ships: Mario = libcommon + libsms + Mario, Olimar = libcommon + libpikmin
  + Olimar, Melee = libcommon + libssbm + the shared Melee checks, All = everything.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Workspace,
    [ValidateSet('Mario', 'Olimar', 'Melee', 'All', 'None')][string]$Scope = 'All',
    [string]$RoR2Dir = ''
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
if ($Scope -eq 'None') { Write-Host 'No checks requested.'; return }

$cores = @{ Mario = @('libcommon', 'libsms'); Olimar = @('libcommon', 'libpikmin'); Melee = @('libcommon', 'libssbm'); All = @('libcommon', 'libsms', 'libpikmin', 'libssbm') }[$Scope]
$hosts = @{ Mario = @('ror2-common', 'ror2-mario'); Olimar = @('ror2-common', 'ror2-olimar'); Melee = @('ror2-common'); All = @('ror2-common', 'ror2-mario', 'ror2-olimar') }[$Scope]
$failures = New-Object System.Collections.Generic.List[string]

foreach ($core in $cores) {
    Write-Host "::group::cargo test $core"
    Push-Location (Join-Path $Workspace $core)
    try {
        # No --locked: libcommon's committed Cargo.lock is a stub, so --locked would fail on a clean checkout.
        # Windows PowerShell 5.1 turns a native command's stderr (cargo's progress) into errors under 'Stop'.
        $ErrorActionPreference = 'Continue'
        $output = & cargo test --workspace --no-fail-fast --release 2>&1 | ForEach-Object { Write-Host $_; "$_" }
        $cargoExit = $LASTEXITCODE
        $ErrorActionPreference = 'Stop'
        if ($cargoExit -ne 0) {
            # Tolerate only the tests listed as failing for lack of assets (see .github/asset-bound-failures).
            $listFile = Join-Path $PSScriptRoot "../asset-bound-failures/$core.txt"
            $allowed = if (Test-Path $listFile) { @(Get-Content $listFile | Where-Object { $_.Trim() }) } else { @() }
            $failed = @($output | ForEach-Object { if ($_ -match '^test (.+) \.\.\. FAILED$') { $Matches[1] } } | Sort-Object -Unique)
            $unexpected = @($failed | Where-Object { $_ -notin $allowed })
            if ($failed.Count -eq 0) { $failures.Add("cargo test $core (no failing test named; build or harness error)") }
            elseif ($unexpected.Count -ne 0) { $unexpected | ForEach-Object { $failures.Add("$core: $_") } }
            else { Write-Host "::warning::$core: $($failed.Count) asset-bound tests failed as expected without a disc cache; they are NOT verified by this run." }
        }
    } finally { Pop-Location }
    Write-Host '::endgroup::'
}

foreach ($hostRepo in $hosts) {
    $testRoot = Join-Path $Workspace "$hostRepo/tests"
    foreach ($project in Get-ChildItem -LiteralPath $testRoot -Directory -ErrorAction SilentlyContinue) {
        $csproj = Get-ChildItem -LiteralPath $project.FullName -Filter *.csproj -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $csproj) { continue }
        $needsGame = (Get-Content -LiteralPath $csproj.FullName -Raw) -match 'RoR2Dir'
        if ($needsGame -and [string]::IsNullOrWhiteSpace($RoR2Dir)) { Write-Host "SKIP $hostRepo/$($project.Name): needs the game's DLLs (RoR2Dir)"; continue }
        # Melee-only scope skips the Mario/Olimar-specific checks; shared ror2-common checks always run.
        Write-Host "::group::dotnet run $hostRepo/tests/$($project.Name)"
        $dotnetArgs = @('run', '--project', $csproj.FullName, '-c', 'Release')
        if ($needsGame) { $dotnetArgs += "-p:RoR2Dir=$RoR2Dir" }
        & dotnet @dotnetArgs
        if ($LASTEXITCODE -ne 0) { $failures.Add("$hostRepo/tests/$($project.Name)") }
        Write-Host '::endgroup::'
    }
}
if ($failures.Count -ne 0) { throw "Failed checks:`n  " + ($failures -join "`n  ") }
Write-Host "All $Scope checks passed (asset-bound checks skip without an extracted disc cache)."
