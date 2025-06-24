# * PScmdWrapper
function Split-FilePath {
    <#
    .SYNOPSIS
    Splits a file path into its directory (parent folder) and filename components.

    .DESCRIPTION
    The Split-FilePath function takes a file path as input and splits it into two parts:
    - `FileFolder`: The parent directory of the file.
    - `Filename`:   The name of the file, including its extension.

    This function does not perform validation or resolve the physical path on disk. It uses 
    `Split-Path` to perform basic parsing of the input path. The resulting values are returned 
    as a custom PowerShell object with clearly named properties.

    This helper function is typically used internally in the Set-TouchFile module for parsing 
    user-supplied paths into structured components.

    .PARAMETER inputPath
    The full file path to process. Can be absolute or relative. This value is parsed but not 
    validated or resolved.

    .INPUTS
    [string] Accepts a single string representing a file path.

    .OUTPUTS
    [PSCustomObject] Returns an object with the following properties:
    - `FileFolder` [string] : The folder path (parent directory).
    - `Filename`   [string] : The file name extracted from the path.

    .NOTES
    Private helper function for the Set-TouchFile module.  
    Not intended for direct use by end users.

    Scope:         Private  
    Author:        Jialiang Chang  
    Version:       1.0.0  
    Last Updated:  2025-06-24
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

    $inputPathObj.FileFolder = Split-Path -Path $inputPath -Parent
    $inputPathObj.Filename = Split-Path -Path $inputPath -Leaf

    return $inputPathObj
}