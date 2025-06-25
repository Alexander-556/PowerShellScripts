# * ValidationHelper
function Confirm-FolderPath {
    <#
    .SYNOPSIS
    Validates whether a given path is a valid folder.

    .DESCRIPTION
    The `Confirm-FolderPath` function checks if the specified path exists and whether it 
    is a folder. If the path does not exist or is not a folder, it logs warnings and 
    returns `$false`. Otherwise, it returns `$true`.

    .PARAMETER inputFolderPath
    The path to validate. This can be an absolute or relative path.

    .INPUTS
    [string]
    Accepts a single folder path as input.

    .OUTPUTS
    [bool]
    Returns `$true` if the path is a valid folder; otherwise, returns `$false`.
    
    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$inputFolderPath
    )

    # Initialize bool variable for ecc
    $isFolderValid = $true

    # Test the actual path
    if (-not (Test-Path -Path $inputFolderPath)) {
        Write-Warning "Folder '$inputFolderPath' does not exist!"
        $isFolderValid = $false
    }
    elseif (-not (Test-Path -Path $inputFolderPath -PathType Container)) {
        Write-Warning "Path '$inputFolderPath' is not a folder, likely a file!"
        $isFolderValid = $false
    }
    
    return $isFolderValid
}