# * QueryHelper
function Confirm-FileConflict {
    <#
    .SYNOPSIS
    Prompts the user to resolve file conflicts during a file move operation.

    .DESCRIPTION
    The `Confirm-FileConflict` function handles file conflict resolution by prompting the user 
    to choose an action for the conflicting file. Supported actions include skipping the file 
    or renaming it. The function continuously prompts the user until a valid response is provided.

    .PARAMETER targetFileObj
    A custom object representing the file involved in the conflict. Contains metadata such as 
    filename and destination path. This is the default output object of the Cmdlet
    Get-ChildItem.

    .PARAMETER folderObj
    A custom object representing the folder containing the file. Contains metadata such as 
    parent folder, folder name, and folder validity.

    .INPUTS
    [PSCustomObject]
    Accepts the target file object and folder object as input.

    .OUTPUTS
    [string]
    Returns the user-selected action (`skip` or `rename`).

    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [PSCustomObject]$targetFileObj,
        [Parameter(Mandatory = $true, Position = 1)]
        [PSCustomObject]$folderObj
    )

    $skipKeyWords = @('S', 's', '')
    $renameKeyWords = @('R', 'r')
    # $overwriteKeyWords = @('O', 'o')

    Write-Warning "To skip this file, type 'S' or 's' or 'Enter'."
    Write-Warning "To rename this file, type 'R' or 'r'."

    # Loop for continuous prompting
    while ($true) {
        # Read user input
        $response = Read-Host "Enter your response"
        
        if ($skipKeyWords -contains $response) {                        
            Write-Host "File '$($targetFileObj.Filename)' will be skipped."
            return "skip"
        }
        elseif ($renameKeyWords -contains $response) {
            Write-Host "File '$($targetFileObj.Filename)' in '$($folderObj.Name)' will be renamed."
            return "rename"
        }
        else {
            Write-Warning "Invalid response. Please follow the instructions:"
            Write-Warning "To skip this file, type 'S' or 's' or 'Enter'."
            Write-Warning "To rename this file, type 'R' or 'r'.`n"
        }
    }
}