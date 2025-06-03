# *  ValidationHelper
function Confirm-FolderArray {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$folderPathsArray
    )

    Write-Verbose "Checking input folders for null..."
    if (-not $folderPathsArray -or $folderPathsArray.Count -eq 0) {
        Write-Error "No folders provided."
        throw
    }

    # Todo: Improve duplicate folders error handling
    # Late in other functions implement a checking mechanism and store the names 
    # of invalid folder in the folderObj
    Write-Verbose "Checking input folders for duplication..."
    if ($folderPathsArray.Count -ne ($folderPathsArray | Select-Object -Unique).Count) {
        # Current behavior, function stops when duplicate folders detected
        Write-Error "Duplicate folders detected in the input."
        throw
    }

    Write-Verbose "Folder path array input check passed."
}