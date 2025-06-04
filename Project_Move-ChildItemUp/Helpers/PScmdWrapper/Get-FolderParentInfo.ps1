# * PScmdWrapper
function Get-FolderParentInfo {
    <#
    .SYNOPSIS
    Splits a folder path into its parent folder and folder name, and returns a folder object.

    .DESCRIPTION
    The `Get-FolderParentInfo` function takes a folder path and a validity flag as input. 
    If the folder is valid, it splits the path into its parent folder and folder name. 
    It then creates and returns a custom PowerShell object containing the parent folder, 
    folder name, and validity status. If the folder is invalid, it logs a warning and 
    skips processing.

    .PARAMETER inputFolderPath
    The folder path to process. This can be an absolute or relative path.

    .PARAMETER isFolderValid
    A boolean flag indicating whether the folder path is valid. If `$false`, the function 
    skips processing and logs a warning.

    .INPUTS
    [string[]]
    Accepts a folder path as input.

    [bool]
    Accepts a validity flag as input.

    .OUTPUTS
    [PSCustomObject]
    Returns a custom object `folderObj` with the following properties:
    - `Parent`: The parent folder of the input folder path.
    - `Name`: The name of the folder.
    - `Valid`: A boolean indicating whether the folder is valid.

    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.

    #>
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