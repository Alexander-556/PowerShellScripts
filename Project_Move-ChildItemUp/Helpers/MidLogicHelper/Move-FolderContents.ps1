# * MidLogicHelper
function Move-FolderContents {
    <#
    .SYNOPSIS
    Moves the contents of specified folders to their parent folders and handles conflicts.

    .DESCRIPTION
    The `Move-FolderContents` function processes an array of folder objects, 
    validates their contents,     and moves files from each folder to its parent folder. 
    It handles file name conflicts by prompting the user for actions such as skipping and
    renaming. In the future more features will be added. Invalid folders are skipped.

    .PARAMETER folderObjArray
    An array of folder objects containing folder metadata, including parent folder, folder name, 
    and validity status.

    .INPUTS
    [System.Collections.Generic.List[pscustomobject]]
    Accepts an array of folder objects as input.

    .OUTPUTS
    None. Outputs status messages to the console.
    
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
        [System.Collections.Generic.List[pscustomobject]]$folderObjArray
    )

    # Start moving files in a folder
    Write-Bounds `
        -FunctionName $MyInvocation.MyCommand.Name `
        -Mode "Enter"
    
    Write-Host "File moving starts..." -ForegroundColor Cyan
    foreach ($folderObj in $folderObjArray) {
        
        # Construct full path
        Write-Verbose "Constructing full path..."
        $folderFullPath = Join-Path -Path $folderObj.Parent -ChildPath $folderObj.Name
        
        # Create an array of fileObj
        Write-Verbose "Obtaining all available files in the folder..."
        $fileObjArray = Get-ChildItem -Path $folderFullPath -Force

        # Start actually moving the files
        Write-Verbose "Start moving loop..."
        foreach ($fileObj in $fileObjArray) {

            Write-Verbose "Setup move target..."

            # Set targetFileObj
            $targetFileObj = [PSCustomObject]@{
                Filename    = $fileObj.Name
                Destination = $folderObj.Parent
            }

            # Create a targetFilePath for validating changes before moving
            $targetFilePath = Join-Path `
                -Path $targetFileObj.Destination `
                -ChildPath $targetFileObj.Filename

            Write-Verbose "Check for filename conflicts..."

            # Handle filename conflicts inside the parent folder
            if (Test-Path $targetFilePath) {
                Write-Warning "Conflict detected: '$($targetFileObj.Filename)' already exists in `n$($targetFileObj.Destination)."

                # Prompt user for response: skip, rename, (overwrite)...
                $userAction = 
                Confirm-FileConflict $targetFileObj $folderObj

                # Handles skipping
                if ($userAction -eq "skip") {
                    # For simplicity, the continue is called here
                    # If future more options that requires continue comes, 
                    # consider change this to a bool condition.
                    Write-Verbose "File skipped."
                    continue
                }
                
                # This line carries out the user action, 
                # right now there is only one, but if there are more in the future
                # consider adding here.
                $targetFileObj = 
                Deploy-UserAction $userAction $targetFileObj $folderObj
            }
            
            # Define moving source and target paths
            # Notice that this code already deals with renames because of the following
            # explanations provided
            $sourceFilePath = $fileObj.FullName
            $destinationFilePath = Join-Path `
                -Path $targetFileObj.Destination `
                -ChildPath $targetFileObj.Filename

            # ! Notice:
            # moving a file to a destination with a new filename renames the file
            # try to do error catching
            
            # Move the file, ensuring paths with spaces are handled correctly
            try {
                Move-Item -LiteralPath "$sourceFilePath" -Destination "$destinationFilePath"
                Write-Verbose "Moved file '$sourceFilePath' to `n'$destinationFilePath'."
            }
            catch {
                Write-Warning "Failed to move file '$sourceFilePath' to '$destinationFilePath'. Error: $($_.Exception.Message)"
                continue
            }
        }
    }
    
    Write-Bounds `
        -FunctionName $MyInvocation.MyCommand.Name `
        -Mode "Exit"
}