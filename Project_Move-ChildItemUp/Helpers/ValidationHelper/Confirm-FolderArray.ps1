# *  ValidationHelper
function Confirm-FolderArray {
    <#
    .SYNOPSIS
    Validates an array of folder paths for null values and duplicate entries.

    .DESCRIPTION
    The `Confirm-FolderArray` function performs basic validation on an array of folder paths
    to ensure they are suitable for further processing. Specifically, it checks that the input
    is not null or empty, and that it does not contain duplicate folder paths.

    The duplicate check is performed by comparing the total number of items in the array
    to the number of unique strings. More advanced folder validation, such as resolving
    equivalent paths or case-insensitive duplicates, is handled by other functions in the module.

    .PARAMETER folderPathsArray
    An array of folder paths to validate. The function ensures the array is not empty and
    contains only unique entries.

    .INPUTS
    [System.Collections.Generic.List[string]]
    Accepts an array of folder paths as input.

    .OUTPUTS
    None. This function does not return output objects, but may write warning or verbose messages
    to the console.

    .NOTES
    Private helper function for internal validation in the Move-ChildItemUp module.  
    Not intended for direct use by end users.

    Scope:         Private  
    Author:        Jialiang Chang  
    Version:       1.0.0  
    Last Updated:  2025-06-25
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [System.Collections.Generic.List[string]]$folderPathsArray
    )

    # Checking input folder array for null
    Write-Verbose "Checking for null or empty input..."
    if (-not $folderPathsArray -or $folderPathsArray.Count -eq 0) {
        Show-ErrorMsg `
            -FunctionName $MyInvocation.MyCommand.Name
            -CustomMessage "No folders provided."
    }
    
    # Checking for duplication in a simple manner through counting
    Write-Verbose "Checking for duplicate items..."
    if ($folderPathsArray.Count -ne ($folderPathsArray | Select-Object -Unique).Count) {
        # Current behavior, function continues and warns user about the skipping
        Write-Warning "Duplicate folders detected in the input."
        Write-Warning "The duplicate folders will be skipped."
    }

    Write-Verbose "Folder path array input check passed."
}