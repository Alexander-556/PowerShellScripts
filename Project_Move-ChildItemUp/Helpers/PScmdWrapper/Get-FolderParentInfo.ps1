function Get-FolderParentInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$inputFolderPath,
        
        [Parameter(Mandatory = $true, Position = 1)]
        [bool]$isFolderValid
    )

    # Initialize two attributes with null values for ecc purposes
    $parentFolder = $null
    $folderName = $null

    try {
        if ($isFolderValid) {
            # Split the path into parent folder and folder name
            $parentFolder = Split-Path -Path $inputFolderPath -Parent
            $folderName = Split-Path -Path $inputFolderPath -Leaf
        }
        else {
            # We have moved warning to here.
            # ? Where to put the warning is the best
            Write-Warning "Path '$inputFolderPath' will be skipped."
        }
    }
    catch {
        Write-Error "`nError in splitting folder path '$inputFolderPath'."
        Write-Error "$($_.Exception.Message)"
    }
        
    # Create a PS object with Parent and Name properties
    # Store folder validity, will skip invalid folder later
    $folderObj = [PSCustomObject]@{
        Parent = $parentFolder
        Name   = $folderName
        Valid  = $isFolderValid
    }
    # Also notice that in the above code block, there is an option to also include the 
    # full path to this folder. However, I finally decided to not to add this attribute
    # because you can always assemble your own full path at any time, this prevents
    # unnecessary use of obj attributes.

    return $folderObj
}