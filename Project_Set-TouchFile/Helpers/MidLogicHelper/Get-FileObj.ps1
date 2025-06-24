# * MidLogicHelper
function Get-FileObj {
    <#
    .SYNOPSIS
    Creates a structured file object containing folder, filename, and full path metadata.

    .DESCRIPTION
    The Get-FileObj function generates a PowerShell custom object that represents a file's 
    location and name. It trims leading and trailing whitespace from the provided filename 
    and combines it with the specified folder path to compute the full file path.

    This helper function is used internally by the Set-TouchFile module to standardize 
    how file references are stored and passed between logic and validation layers.

    .PARAMETER filename
    The name of the file to process. Leading and trailing whitespace will be trimmed automatically.

    .PARAMETER desiredLocation
    The folder path where the file resides or will be created. If omitted, the function is expected 
    to receive a valid path from the caller. No resolution or validation is performed in this function.

    .INPUTS
    [string] Accepts a filename and optional folder path as string input.

    .OUTPUTS
    [PSCustomObject] Returns an object with the following properties:
    - `FileFolder` [string] : The folder path.
    - `Filename`   [string] : The cleaned filename.
    - `FullPath`   [string] : The combined full file path.

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