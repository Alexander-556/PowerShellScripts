# * MidLogicHelper
function Move-FolderContents {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [PScustomObject[]]$folderObjArray
    )

    # Start moving files in a folder
    Write-Host "`nFile moving starts..."
    foreach ($folderObj in $folderObjArray) {

        # If the folder was marked invalid, skip this folder
        if (-not $folderObj.Valid) {
            Write-Warning "Skipped a folder."
            continue
        }
        
        # Create an array of fileObj
        $fileObjArray = Get-ChildItem -Path $folderObj.Parent -Force

        # Start actually moving the files
        foreach ($fileObj in $fileObjArray) {

            # Set targetFileObj
            $targetFileObj = [PSCustomObject]@{
                Filename    = $fileObj.Name
                Destination = $folderObj.Parent
            }

            # Create a targetFilePath for validating changes before moving
            $targetFilePath = Join-Path `
                -Path $targetFileObj.Destination `
                -ChildPath $targetFileObj.Filename

            # Handle file name conflicts
            if (Test-Path $targetFilePath) {
                Write-Warning "Conflict detected: '$($targetFileObj.Filename)' already exists in $($targetFileObj.Destination)."

                # Prompt user for response: skip, rename, (overwrite)...
                $userAction = Confirm-FileConflict $targetFileObj $folderObj

                # Handles skipping
                if ($userAction -eq "skip") {
                    # For simplicity, the continue is called here
                    # If future more options that requires continue comes, 
                    # consider change this to a bool condition.
                    continue
                }
                
                # This line carries out the user action, 
                # right now there is only one, but if there are more in the future
                # consider adding here.
                $targetFileObj = Deploy-UserAction $userAction $targetFileObj $folderObj
            }
            
            # Define moving source and target paths
            $sourceFilePath = $fileObj.FullName
            $destinationFilePath = Join-Path `
                -Path $targetFileObj.Destination -ChildPath $targetFileObj.Filename
            
            # ! Notice:
            # moving a file to a destination with a new filename renames the file
            Move-Item -Path $sourceFilePath -Destination $destinationFilePath
            Write-Verbose "Moved file '$sourceFilePath' to new path '$destinationFilePath'."
        }
    }
}