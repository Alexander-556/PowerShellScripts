# * Main
function Move-ChildItemUp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$folderPathsArray
    )

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
    
    Write-Host "Action successful."
}