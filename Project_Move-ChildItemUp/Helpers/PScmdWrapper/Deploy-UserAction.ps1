# * PScmdWrapper
function Deploy-UserAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$userAction,

        [Parameter(Mandatory = $true, Position = 1)]
        [PSCustomObject]$targetFileObj,

        [Parameter(Mandatory = $true, Position = 2)]
        [PSCustomObject]$folderObj
    )

    # Execute the rename operation
    if ($userAction -eq "rename") {
        $targetFileObj = Start-Rename $targetFileObj
        return $targetFileObj
    }
}