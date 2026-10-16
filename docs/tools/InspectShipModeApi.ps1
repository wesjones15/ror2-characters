param([Parameter(Mandatory = $true)][string]$RoR2Dir)
$ErrorActionPreference = 'Stop'

# Read metadata only; never load the game or Unity runtime for execution.
Add-Type -Path (Join-Path $RoR2Dir 'BepInEx/core/Mono.Cecil.dll')
$shipAssembly = [Mono.Cecil.AssemblyDefinition]::ReadAssembly(
    (Join-Path $RoR2Dir 'Risk of Rain 2_Data/Managed/RoR2.dll'))
try {
    $shipTypes = @(
        'RoR2.GameModeCatalog', 'RoR2.Run', 'RoR2.RunReport',
        'RoR2.GameEndingDef', 'RoR2.ContentManagement.ContentPack'
    )
    $shipFields = 'gameModePrefabs|gameEndingDefs|userPickable|nameToken|gameModeIndex|statSheet|isWin|runStopwatchValue|playerInfos'
    $shipMethods = 'get_gameModeCount|GetGameModePrefabComponent|add_getAdditionalEntries|get_spawnWithPod|BeginGameOver|GetRunStopwatch|GetEffectiveRunStopwatch|Generate'
    foreach ($shipName in $shipTypes) {
        $shipType = $shipAssembly.MainModule.Types | Where-Object FullName -eq $shipName
        if (-not $shipType) { throw "Missing type: $shipName" }
        Write-Output "TYPE $shipName"
        foreach ($shipField in $shipType.Fields | Where-Object Name -match $shipFields) {
            Write-Output "  FIELD $($shipField.FullName)"
        }
        foreach ($shipMethod in $shipType.Methods | Where-Object Name -match $shipMethods) {
            Write-Output "  METHOD $($shipMethod.FullName) public=$($shipMethod.IsPublic)"
            if ($shipMethod.Name -in @('get_spawnWithPod', 'add_getAdditionalEntries')) {
                foreach ($shipInstruction in $shipMethod.Body.Instructions) {
                    Write-Output "    $shipInstruction"
                }
            }
        }
        foreach ($shipNested in $shipType.NestedTypes | Where-Object Name -eq 'PlayerInfo') {
            foreach ($shipField in $shipNested.Fields | Where-Object Name -eq 'statSheet') {
                Write-Output "  FIELD $($shipField.FullName)"
            }
        }
    }
} finally {
    $shipAssembly.Dispose()
}
