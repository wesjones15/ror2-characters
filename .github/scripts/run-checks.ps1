<#
.SYNOPSIS
  Runs the checks that need no game files and no extracted assets: the Rust suites and the listed managed checks.

.DESCRIPTION
  Asset-bound checks cannot run in CI. Rust tests that need an extracted disc cache return early when it is absent
  (a green result then means "skipped", not "verified"); the ones that fail without it are listed in
  .github/asset-bound-failures and tolerated by name. The managed checks are the explicit list in
  .github/managed-checks.txt, not every project under tests/: some need native DLL arguments (the build scripts run
  those), two need the game's real DLLs, and several no longer compile (see .github/managed-checks.md).
  In-game behaviour is tested by hand.
  Scope picks the pieces a release actually ships: Mario = libcommon + libsms + Mario, Olimar = libcommon + libpikmin
  + Olimar, Melee = libcommon + libssbm + the shared checks, All = everything.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Workspace,
    [ValidateSet('Mario', 'Olimar', 'Melee', 'All', 'None')][string]$Scope = 'All'
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
        foreach ($attempt in 1, 2) {
            $output = & cargo test --workspace --no-fail-fast --release 2>&1 | ForEach-Object { Write-Host $_; "$_" }
            $cargoExit = $LASTEXITCODE
            # No test failed by name but cargo failed: a build/link error. A file lock during linking (LNK1104) is
            # transient, so give it one more attempt; a real compile error fails again and is reported below.
            if ($cargoExit -eq 0 -or @($output | Where-Object { $_ -match '^test .+ \.\.\. FAILED$' }).Count -ne 0 -or $attempt -eq 2) { break }
            Write-Host "::warning::cargo test $core failed without a failing test (build or link error); retrying once."
        }
        $ErrorActionPreference = 'Stop'
        if ($cargoExit -ne 0) {
            # Tolerate only the tests listed as failing for lack of assets (see .github/asset-bound-failures).
            $listFile = Join-Path $PSScriptRoot "../asset-bound-failures/$core.txt"
            $allowed = if (Test-Path $listFile) { @(Get-Content $listFile | Where-Object { $_.Trim() }) } else { @() }
            $failed = @($output | ForEach-Object { if ($_ -match '^test (.+) \.\.\. FAILED$') { $Matches[1] } } | Sort-Object -Unique)
            $unexpected = @($failed | Where-Object { $_ -notin $allowed })
            if ($failed.Count -eq 0) { $failures.Add("cargo test $core (no failing test named; build or harness error)") }
            elseif ($unexpected.Count -ne 0) { $unexpected | ForEach-Object { $failures.Add("${core}: $_") } }
            else { Write-Host "::warning::${core}: $($failed.Count) asset-bound tests failed as expected without a disc cache; they are NOT verified by this run." }
        }
    } finally {
        Pop-Location
        # cargo may rewrite a tracked Cargo.lock (libcommon's committed one is a stub); package-release.ps1 refuses a dirty repository.
        & git -C (Join-Path $Workspace $core) checkout --quiet -- .
    }
    Write-Host '::endgroup::'
}

$listed = @(Get-Content (Join-Path $PSScriptRoot '../managed-checks.txt') | Where-Object { $_.Trim() -and -not $_.StartsWith('#') })
foreach ($check in $listed) {
    $repo = $check.Split('/')[0]
    if ($repo -notin $hosts) { continue }
    $csproj = Get-ChildItem -LiteralPath (Join-Path $Workspace $check) -Filter *.csproj -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $csproj) { $failures.Add("$check (listed in managed-checks.txt but not found)"); continue }
    Write-Host "::group::dotnet run $check"
    & dotnet run --project $csproj.FullName -c Release
    if ($LASTEXITCODE -ne 0) { $failures.Add($check) }
    Write-Host '::endgroup::'
}
if ($failures.Count -ne 0) { throw "Failed checks:`n  " + ($failures -join "`n  ") }
Write-Host "All $Scope checks passed (asset-bound checks skip or are tolerated without an extracted disc cache)."
