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
    [System.Collections.Generic.List[pscustomobject]]
    Accepts an array of folder objects as input.

    .OUTPUTS
    None. Outputs status messages to the console.
    
    .NOTES
    Private helper function for internal validation in the Move-ChildItemUp module.  
    Not intended for direct use by end users.

    Scope:         Private  
    Author:        Jialiang Chang  
    Version:       1.0.0  
    Last Updated:  2025-06-25
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [System.Collections.Generic.List[pscustomobject]]$folderObjArray
    )

    foreach ($folderObj in $folderObjArray) {

        # Construct full path
        $folderPath = Join-Path -Path $folderObj.Parent -ChildPath $folderObj.Name

        # Check if the folder is empty
        $childItems = Get-ChildItem -Path $folderPath -Force

        if ($childItems.Count -eq 0) {
            # Use ShouldProcess for confirmation
            if ($PSCmdlet.ShouldProcess("$folderPath", "Remove empty folder")) {
                Remove-Item -Path $folderPath -Force
                Write-Host "Removed empty folder:`n$folderPath" `
                    -ForegroundColor Red
            }
        }
        else {
            Write-Host "Skipped non-empty folder:`n$folderPath" `
            -ForegroundColor DarkYellow
            continue
        }
    }
}