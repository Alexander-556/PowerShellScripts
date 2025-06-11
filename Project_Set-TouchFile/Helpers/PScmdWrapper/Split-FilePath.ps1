# * PScmdWrapper
function Split-FilePath {
    <#
    .SYNOPSIS
    Splits a file path into its folder path and filename.

    .DESCRIPTION
    The `Split-FilePath` function processes a given file path and splits it into its 
    folder path and filename. If the input path is valid, it resolves the full path 
    using `Resolve-PathwErr`. For invalid paths, it attempts to resolve the parent 
    folder and combines it with the filename to construct the full path. The function 
    returns a custom object containing the folder path and filename.

    .PARAMETER inputPath
    The file path to process. This can be an absolute or relative path.

    .INPUTS
    [string]
    Accepts a single file path as input.

    .OUTPUTS
    [PSCustomObject]
    Returns a custom object containing the following properties:
    - `FileFolder`: The folder path where the file resides.
    - `Filename`: The name of the file.

    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$inputPath
    )

    $inputPathObj = [PSCustomObject]@{
        FileFolder = $null
        Filename   = $null
    }

    # Check user input
    # Optional: Separate this into a different validation helper
    #           just in case if we have a lot of checks
    if ((Test-Path -Path $inputPath -PathType Container)) {
        # if the user typed a folder path in quick access mode, 
        # program should stop
        # Optional: prompt user for new filename input
        Write-Error "In quick access mode, a file path is expected."
        Write-Error "However, path '$inputPath' is a folder path."
        throw
    }

    $inputPathObj.FileFolder = Split-Path -Path $inputPath -Parent
    $inputPathObj.Filename = Split-Path -Path $inputPath -Leaf

    return $inputPathObj
}