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
            Write-Warning "Folder path '$inputFolderPath' will be skipped."
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

    return $folderObj
}