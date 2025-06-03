# * MidLogicHelper
function Remove-EmptyFolder {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Low'
    )]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [PSCustomObject[]]$folderObjArray
    )

    foreach ($folderObj in $folderObjArray) {

        $folderPath = Join-Path -Path $folderObj.Parent -ChildPath $folderObj.Name

        If (-not $folderObj.Valid) {
            Write-Host "Skipped invalid folder: $folderPath)"
            continue
        }

        # Check if the folder is empty
        $childItems = Get-ChildItem -Path $folderPath -Force

        if ($childItems.Count -eq 0) {
            # Use ShouldProcess for confirmation
            if ($PSCmdlet.ShouldProcess("$folderPath", "Remove empty folder")) {
                Remove-Item -Path $folderPath -Force
                Write-Host "Removed empty folder: $folderPath"
            }
        }
        else {
            Write-Host "Skipped non-empty folder: $folderPath"
            continue
        }
    }
}