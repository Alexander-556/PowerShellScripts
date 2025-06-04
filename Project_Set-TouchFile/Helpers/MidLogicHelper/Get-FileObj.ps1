# * MidLogicHelper
function Get-FileObj {
    <#
    .SYNOPSIS
    Creates a file object containing metadata such as folder path, filename, and full path.

    .DESCRIPTION
    The `Get-FileObj` function generates a custom PowerShell object representing a file. 
    It normalizes the filename by trimming whitespace and combines it with the specified 
    folder path to create the full file path. The resulting object contains the folder path, 
    filename, and full path.

    .PARAMETER filename
    The name of the file to process. Leading and trailing whitespace will be removed.

    .PARAMETER desiredLocation
    The folder path where the file resides or will be created. If not specified, the function 
    uses the current working directory.

    .INPUTS
    [string]
    Accepts the filename and optional folder path as input.

    .OUTPUTS
    [PSCustomObject]
    Returns a custom object `fileObj` containing the following properties:
    - `FileFolder`: The folder path where the file resides.
    - `Filename`: The name of the file.
    - `FullPath`: The full path to the file.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$filename,

        [Parameter(Mandatory = $false)]
        [string]$desiredLocation

    )

    # Normalize the filename by removing leading and trailing whitespace
    $filename = $filename.Trim()

    # If selected a desired path, use this path
    $fileFolder = $desiredLocation

    $fullPath = Join-Path -Path $fileFolder -ChildPath $filename

    # Create a PSObject to store file info
    $fileObj = [PSCustomObject]@{
        FileFolder = $fileFolder
        Filename   = $filename
        FullPath   = $fullPath
    }

    return $fileObj
}