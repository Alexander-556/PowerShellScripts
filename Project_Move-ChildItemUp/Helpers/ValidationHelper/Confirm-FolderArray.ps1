# *  ValidationHelper
function Confirm-FolderArray {
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