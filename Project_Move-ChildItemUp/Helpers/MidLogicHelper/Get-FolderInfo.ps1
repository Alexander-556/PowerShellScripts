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
    [System.Collections.Generic.List[string]]
    Accepts an array of folder paths as input.

    .OUTPUTS
    [System.Collections.Generic.List[pscustomobject]]
    Returns an array of custom folder objects containing resolved paths and validation status.
    The object `folderObj` contains the following properties
    - `Parent`: The parent folder of the input folder path.
    - `Name`:   The name of the folder.

    .NOTES
    Private helper function for internal validation in the Move-ChildItemUp module.  
    Not intended for direct use by end users.

    Scope:         Private  
    Author:        Jialiang Chang  
    Version:       1.0.0  
    Last Updated:  2025-06-25
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.Collections.Generic.List[string]]$folderPathsArray
    )

    # Initialize array of objects to return
    $folderObjArray = [System.Collections.Generic.List[pscustomobject]]::new()
    
    # Initialize the seenPaths for skipping duplicates
    $seenPaths = [System.Collections.Generic.HashSet[string]]::new()

    $isFolderValid = $null

    # Start main loop
    foreach ($folderPath in $folderPathsArray) {

        # Step 0: Check for empty input
        if ([string]::IsNullOrWhiteSpace($folderPath)) {
            Write-Verbose "Empty or whitespace folder path. Skipping..."
            continue
        }

        # Step 1: Resolve the folder path for consistency
        #         when resolution failed, fall back to `$null`
        $resolvedPath = Resolve-PathwErr $folderPath

        # Step 2: Check if the resolved path is `$null`
        if ([string]::IsNullOrEmpty($resolvedPath)) {
            # If the resolved path is `$null` then the path is invalid
            Write-Warning "Path resolution failed for '$folderPath'. Skipping..."
            # Skip the path
            continue
        }

        # Step 3: Validate folder path
        #         validates the path exists and is a folder
        #         potential duplicate validation logic
        $isFolderValid = Confirm-FolderPath $resolvedPath

        # Check if the folder path is valid
        if ($isFolderValid) {
            # If the folder path is valid
            # Check for duplicate
            if ($seenPaths.Contains($resolvedPath)) {
                Write-Warning "Duplicate folder detected: '$resolvedPath'. Skipping..."
                continue
            }

            # Add the resolved path to the seen list
            [void]$seenPaths.Add($resolvedPath)

            # Setup folder object
            $folderObj = Get-FolderParentInfo $resolvedPath

            # Add folder object to the array for return
            $folderObjArray.Add($folderObj)
        }
        else {
            # If the folder path is not valid (likely a file)
            Write-Warning "The path '$folderPath' is not valid (likely a file). Skipping..."
            continue
        }
    }

    # Checking output folder array for null to make powershell happy
    if (-not $folderObjArray -or $folderObjArray.Count -eq 0) {
        Show-ErrorMsg `
            -FunctionName $MyInvocation.MyCommand.Name `
            -CustomMessage "No valid folder can be processed."
    }

    return $folderObjArray
}