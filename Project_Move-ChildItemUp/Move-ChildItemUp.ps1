# * Main
function Move-ChildItemUp {
    <#
    .SYNOPSIS
    Moves the contents of specified folders up one level and cleans up empty folders.

    .DESCRIPTION
    The `Move-ChildItemUp` function takes one or more folder paths as input, validates 
    them, and moves the contents of each folder up one level. After moving the contents, 
    it removes any empty folders left behind. This function also accepts pipeline input.

    .PARAMETER folderPath
    Specifies the path(s) of the folder(s) whose contents need to be moved up one level. 
    This parameter accepts pipeline input.

    .INPUTS
    [string]
    Accepts folder paths as pipeline input. Absolute and relative paths both acceptable.

    .OUTPUTS
    None. Outputs status messages to the console.

    .EXAMPLE
    Move-ChildItemUp "C:\Test"
    Moves the contents of `C:\Test` up one level to "C:\" and removes the empty folder.

    .EXAMPLE
    "C:\Folder1", "C:\Folder2" | Move-ChildItemUp
    Moves the contents of `C:\Folder1` and `C:\Folder2` up one level and removes the empty folders.

    .EXAMPLE
    Get-ChildItem ./ -Directory | Move-ChildItemUp
    A very typical and useful case. Moves the contents of all folders in the current 
    working directory up one level. 

    .NOTES
    This is the main function. User should call this function. An alias is recommended.

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$folderPath
    )

    # Before accepting pipeline input, initialize an array to collect folder paths
    begin {
        $folderPathsArray = New-Object System.Collections.Generic.List[string]
    }

    # Process pipeline input
    process {
        $folderPathsArray.Add($folderPath)
    }

    # After collecting all pipeline input, process the array
    end {
        try {
            Write-Host "Program starts..." -ForegroundColor Cyan

            # Step 1: 
            # Validate input array only, not the path
            Confirm-FolderArray $folderPathsArray

            # Step 2:
            # Assemble the folder object array for ease of process
            $folderObjArray = Get-FolderInfo $folderPathsArray

            # Step 3:
            # Do the actual moving
            # ? Confusing name but not sure how to avoid
            Move-FolderContents $folderObjArray

            # Step 4: Clean up empty folder only
            # Remove-Item -Path $source -Recurse -Force
            Remove-EmptyFolder $folderObjArray
    
            Write-Host "Program complete." -ForegroundColor Green
        }
        catch {
            # Improved error handling
            Write-Error "Unexpected Error"
            Write-Error "$($_.Exception.Message)"
            Write-Error "Action unsuccessful. Please check the input and try again."
        }
    }
}
