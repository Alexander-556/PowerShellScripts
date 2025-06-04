# * MidLogicHelper
function Remove-EmptyFolder {
    <#
    .SYNOPSIS
    Removes empty folders from a specified array of folder objects.

    .DESCRIPTION
    The `Remove-EmptyFolder` function iterates through an array of folder objects, 
    checks if each folder is empty, and removes it if confirmed. 
    Invalid folder objects are skipped. The function uses `ShouldProcess` to 
    support confirmation prompts before removing folders.

    .PARAMETER folderObjArray
    An array of folder objects containing folder metadata, including parent folder, 
    folder name, and validity status.

    .INPUTS
    [PSCustomObject[]]
    Accepts an array of folder objects as input.

    .OUTPUTS
    None. Outputs status messages to the console.
    
    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.
    
    #>
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