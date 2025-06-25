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

    .INPUTS
    [string[]]
    Accepts a folder path as input.

    .OUTPUTS
    [PSCustomObject]
    Returns a custom object `folderObj` with the following properties:
    - `Parent`: The parent folder of the input folder path.
    - `Name`: The name of the folder.

    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$inputFolderPath
    )

    # Initialize two attributes with null values for ecc purposes
    $parentFolder = $null
    $folderName = $null

    try {
        # Split the path into parent folder and folder name
        $parentFolder = Split-Path -Path $inputFolderPath -Parent
        $folderName = Split-Path -Path $inputFolderPath -Leaf
    }
    catch {
        Show-ErrorMsg `
            -FunctionName $MyInvocation.MyCommand.Name
            -CustomMessage "`nError in splitting folder path '$inputFolderPath'."
            -Exception $_.Exception
    }
        
    # Create a PS object with Parent and Name properties
    $folderObj = [PSCustomObject]@{
        Parent = $parentFolder
        Name   = $folderName
    }
    # Also notice that in the above code block, there is an option to also include the 
    # full path to this folder. However, I finally decided to not to add this attribute
    # because you can always assemble your own full path at any time, this prevents
    # unnecessary use of obj attributes.

    return $folderObj
}