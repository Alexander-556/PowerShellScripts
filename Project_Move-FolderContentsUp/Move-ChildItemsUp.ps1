function Move-ChildItemsUp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$folderPathsArray
    )

    # Validate input array
    Confirm-FolderArray $folderPathsArray

    # Use assemble folder object array
    $folderObjArray = Get-FolderInfo $folderPathsArray

    # Do the actual moving
    Move-FolderContents $folderObjArray

    # Step 3: Optional cleanup
    # Remove-Item -Path $source -Recurse -Force
    
    Write-Host "Successfully flattened $source into $parent"
}