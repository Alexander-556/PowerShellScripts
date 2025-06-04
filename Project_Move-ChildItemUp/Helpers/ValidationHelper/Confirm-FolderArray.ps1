# *  ValidationHelper
function Confirm-FolderArray {
    <#
    .SYNOPSIS
    Validates an array of folder paths to ensure they are suitable for processing.

    .DESCRIPTION
    The `Confirm-FolderArray` function checks an array of folder paths for null values and
    duplicates. This function performs a very simple check on the input file array. 
    Duplicate check work by compare length of array and the number of unique strings.
    More detailed checks for duplicate is in another function.

    .PARAMETER folderPathsArray
    An array of folder paths to validate. The function checks for null values and duplicates.

    .INPUTS
    [string[]]
    Accepts an array of folder paths as input.

    .OUTPUTS
    None. Outputs validation messages to the console.

    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$folderPathsArray
    )

    # Checking input folder array for null
    if (-not $folderPathsArray -or $folderPathsArray.Count -eq 0) {
        Write-Error "No folders provided."
        throw
    }

    # Todo: Improve duplicate folders error handling, COMPLETED
    # Late in other functions implement a checking mechanism and store the names 
    # of invalid folder in the folderObj
    
    # Checking for duplication in a simple manner through counting
    if ($folderPathsArray.Count -ne ($folderPathsArray | Select-Object -Unique).Count) {
        # Current behavior, function continues and warns user about the skipping
        Write-Warning "Duplicate folders detected in the input."
        Write-Verbose "Will skip the duplicate folders."
    }

    Write-Verbose "Folder path array input check passed."
}