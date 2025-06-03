# * Main
function Move-ChildItemUp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$folderPath
    )

    # Before accepting pipeline input, initialize an array to collect folder paths
    begin {
        $folderPathsArray = @()
    }

    # Process pipeline input
    process {
        $folderPathsArray += $folderPath
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