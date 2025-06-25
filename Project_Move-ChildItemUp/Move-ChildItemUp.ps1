# * Main
function Move-ChildItemUp {
    <#
    .SYNOPSIS
    Moves the contents of specified folders up one level and cleans up empty folders.

    .DESCRIPTION
    The `Move-ChildItemUp` function takes one or more folder paths as input, validates
    them to ensure they exists and are folders, and moves the contents of each folder up
    one level. After moving the contents,
    it removes any empty folders left behind. This function also accepts pipeline input.

    .PARAMETER folderPath
    Specifies the path(s) of the folder(s) whose contents need to be moved up one level.
    This parameter accepts pipeline input.

    .INPUTS
    [string] Accepts folder paths as pipeline input. Absolute and relative paths both acceptable.

    .OUTPUTS
    None. This function performs file operations and outputs status messages to the console.

    .EXAMPLE
    Move-ChildItemUp "C:\Parent\Test"

    Moves the contents of `C:\Parent\Test` up one level to `C:\Parent`, then removes the empty folder.

    .EXAMPLE
    "C:\Folder1", "C:\Folder2" | Move-ChildItemUp
    Moves the contents of `C:\Folder1` and `C:\Folder2` up one level and removes the empty folders.

    .EXAMPLE
    Get-ChildItem ./ -Directory | Move-ChildItemUp

    A very typical and useful case. Moves the contents of all folders in the current
    working directory up one level.

    .NOTES
    This is the main public function in the Move-ChildItemUp utility.
    To use this function, import the module `MoveChildItemUp.psd1`
    to ensure all dependencies are loaded.

    To create a convenient alias, run:
    Set-Alias -Name ungroup -Value Move-ChildItemUp

    Scope:         Public
    Author:        Jialiang Chang
    Version:       1.0.0
    Last Updated:  2025-06-25
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$folderPath
    )

    # Before accepting pipeline input, initialize an array to collect folder paths
    begin {
        $folderPathsArray = 
        [System.Collections.Generic.List[string]]::new()
    }

    # Process pipeline input
    process {
        $folderPathsArray.Add($folderPath)
    }

    # After collecting all pipeline input, process the array
    end {
        Write-Host "Program starts..." -ForegroundColor Green

        # Step 1:
        # Validate input array only, not the path
        Confirm-FolderArray $folderPathsArray

        # Step 2:
        # Assemble the folder object array for ease of process
        $folderObjArray = Get-FolderInfo $folderPathsArray

        # Step 3:
        # Do the actual moving
        Move-FolderContents $folderObjArray

        # Step 4: Clean up empty folder only
        # Remove-Item -Path $source -Recurse -Force
        Remove-EmptyFolder $folderObjArray

        Write-Host "Program complete." -ForegroundColor Green
    }
}
