# * MidLogicHelper
function Get-FolderInfo {
    <#
    .SYNOPSIS
    Resolves folder paths, validates them, and returns an array of folder objects.

    .DESCRIPTION
    The `Get-FolderInfo` function processes an array of folder paths, resolves each path, 
    validates it, and creates folder objects containing relevant information. It performs 
    duplicate checks, null checks, and ensures that only valid folder paths are included 
    in the output.

    .PARAMETER folderPathsArray
    An array of folder paths to process. The function resolves each path, validates it, 
    and creates folder objects.

    .INPUTS
    [string[]]
    Accepts an array of folder paths as input.

    .OUTPUTS
    [PSCustomObject[]]
    Returns an array of custom folder objects containing resolved paths and validation status.
    The object `folderObj` contains the following properties
    - `Parent`: The parent folder of the input folder path.
    - `Name`: The name of the folder.
    - `Valid`: A boolean indicating whether the folder is valid.

    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$folderPathsArray
    )

    # Initialize array of objects
    $folderObjArray = @()
    
    # Initialize the previous folder path for skipping duplicates
    $previousFolderPath = $null

    # Resolve path with ecc and validation
    # Split path into parent and name
    # Store info in a folder object
    foreach ($folderPath in $folderPathsArray) {
        # Resolve with ecc
        $folderPath = Resolve-PathwErr $folderPath

        # Check duplicates and skip the second one
        # For the first folder in the array, this code should never execute
        if ($null -eq $folderPath) {
            Write-Verbose "Invalid folder due to failed path resolution."  
        }
        elseif ($previousFolderPath -eq $folderPath) {
            # If the previous folder path is the same as the current folder path
            Write-Warning "The folder '$folderPath' is the same as the previous folder."
            # add an additional false to the valid folder bool variable.
            $isFolderValid = $false
        }

        # Update the previous folder path for next step duplication
        # To be clear, when executing this program inside an actual folder or a valid
        # working directory, a duplicate should not happen thanks to Windows,
        # but there might be a chance of user error in input, so it makes sense
        # to implement this additional error checking mechanism.
        $previousFolderPath = $folderPath
        
        # Moved null detection logic here to make powershell happy
        # If null is detected in input, this only means resolution failed
        if ([string]::IsNullOrEmpty($folderPath)) {
            Write-Verbose "Invalid folder due to failed path resolution."
            $isFolderValid = $false
        }
        else {
            # Validate folder path
            $isFolderValid = Confirm-FolderPath $folderPath

            # It only make sense to execute the following when input is not null

            # Setup folder object
            $folderObj = Get-FolderParentInfo $folderPath $isFolderValid

            # Add folder object to the array for return
            $folderObjArray += $folderObj
        }              
    }

    # Checking output folder array for null to make powershell happy
    if (-not $folderObjArray -or $folderObjArray.Count -eq 0) {
        Write-Error "No valid folder can be processed."
        throw
    }

    return $folderObjArray
}