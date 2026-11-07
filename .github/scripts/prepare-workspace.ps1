<#
.SYNOPSIS
  Lays out the source workspace the build scripts expect: the eight source repositories side by side, each on
  its release branch, each at the commit this repository pins in sources/.

.DESCRIPTION
  The component build.ps1 scripts and package-release.ps1 find their siblings by relative path (..\libsms,
  ..\ror2-common, ...) and refuse to run from a detached HEAD. Submodule checkouts are detached and nested, so CI
  clones each repository into <Workspace>\<name>, checks out the pinned commit and then puts a local release branch
  on it. The pinned commit must be reachable from the published branch, so a release can only be cut from commits
  that are on GitHub.

  The workspace is reused between runs so cargo and msbuild stay incremental. Untracked files are removed but
  ignored build output (target/, dist/, bin/, obj/) is kept; package-release.ps1 still refuses a dirty repository.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Workspace,
    [Parameter(Mandatory = $true)][string]$ReleaseRepo,
    [string]$Token = '',
    [string]$Owner = 'wesjones15'
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# name -> release branch (libssbm and ror2-samus live on main; everything else on modern/1.5.0).
$sources = [ordered]@{
    'libcommon' = 'modern/1.5.0'; 'libpikmin' = 'modern/1.5.0'; 'libsms' = 'modern/1.5.0'; 'libssbm' = 'main'
    'ror2-common' = 'modern/1.5.0'; 'ror2-mario' = 'modern/1.5.0'; 'ror2-olimar' = 'modern/1.5.0'; 'ror2-samus' = 'main'
}
# The source repositories are public, so no token is needed; one is used only if given (a private fork).
$auth = @()
if ($Token) {
    $basic = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("x-access-token:$Token"))
    Write-Host "::add-mask::$basic"
    $auth = @('-c', "http.https://github.com/.extraheader=AUTHORIZATION: basic $basic")
}
function Invoke-Git([string]$Dir, [string[]]$GitArgs) {
    $all = $auth + @('-C', $Dir) + $GitArgs
    & git @all
    if ($LASTEXITCODE -ne 0) { throw "git $($GitArgs -join ' ') failed in $Dir" }
}

New-Item -ItemType Directory -Force -Path $Workspace | Out-Null
foreach ($name in $sources.Keys) {
    $branch = $sources[$name]
    $dir = Join-Path $Workspace $name
    $pin = ((& git -C $ReleaseRepo ls-tree HEAD "sources/$name") -split '\s+')[2]
    if ([string]::IsNullOrWhiteSpace($pin) -or $pin.Length -ne 40) { throw "sources/$name is not pinned in $ReleaseRepo." }
    if (-not (Test-Path (Join-Path $dir '.git'))) {
        $parent = Split-Path -Parent $dir
        & git @auth -C $parent clone --quiet "https://github.com/$Owner/$name.git" $name
        if ($LASTEXITCODE -ne 0) { throw "Cannot clone $name." }
    }
    Invoke-Git $dir @('fetch', '--quiet', '--prune', 'origin', "+refs/heads/${branch}:refs/remotes/origin/$branch")
    & git -C $dir cat-file -e "$pin^{commit}"
    if ($LASTEXITCODE -ne 0) { throw "Pinned commit $pin of $name is not on GitHub." }
    & git -C $dir merge-base --is-ancestor $pin "origin/$branch"
    if ($LASTEXITCODE -ne 0) { throw "Pinned commit $($pin.Substring(0, 7)) of $name is not on origin/$branch; push it before releasing." }
    Invoke-Git $dir @('checkout', '--quiet', '--force', '--detach', $pin)
    Invoke-Git $dir @('checkout', '--quiet', '-B', $branch, $pin)
    Invoke-Git $dir @('clean', '--quiet', '-fd')
    Write-Host ("{0,-12} {1,-13} {2}" -f $name, $branch, $pin.Substring(0, 12))
}
