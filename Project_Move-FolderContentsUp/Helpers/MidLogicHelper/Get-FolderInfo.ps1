function Get-FolderInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$folderPathsArray
    )

    # Initialize array of objects
    $folderObjArray = @()

    # Resolve path with ecc and validation
    # Split path into parent and name
    # Store info in a folder object
    foreach ($folderPath in $folderPathsArray) {
        # Resolve with ecc
        $folderPath = Resolve-PathwErr $folderPath
        # Validate folder path
        $isFolderValid = Confirm-FolderPath $folderPath

        # Setup folder object
        $folderObj = Get-FolderParentInfo $folderPath $isFolderValid
        
        $folderObjArray += $folderObj
    }

    return $folderObjArray
}