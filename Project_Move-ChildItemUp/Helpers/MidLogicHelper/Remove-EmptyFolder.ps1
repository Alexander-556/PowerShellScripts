# * MidLogicHelper
function Remove-EmptyFolder {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [PSCustomObject[]]$folderObjArray
    )

    foreach ($folderObj in $folderObjArray) {
        
        If (-not $folderObj.Valid) {
            Write-Verbose "Skipping removal of an invalid entry..."
            continue
        }

        $folderPath = Join-Path -Path $folderObj.Parent -ChildPath $folderObj.Name

        # Check if the folder is empty
        $childItems = Get-ChildItem -Path $folderPath -Force

        if ($childItems.Count -eq 0) {
            # Use ShouldProcess for confirmation
            if ($PSCmdlet.ShouldProcess("$folderPath", "Remove empty folder")) {
                Remove-Item -Path $folderPath -Force
                Write-Host "Removed empty folder:`n$folderPath" -ForegroundColor Red
            }
        }
        else {
            Write-Host "Skipped non-empty folder:`n$folderPath" -ForegroundColor Magenta
            continue
        }
    }
}