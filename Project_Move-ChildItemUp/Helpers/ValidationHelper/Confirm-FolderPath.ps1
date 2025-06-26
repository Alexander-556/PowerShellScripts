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
    Private helper function for internal validation in the Move-ChildItemUp module.  
    Not intended for direct use by end users.

    Scope:         Private  
    Author:        Jialiang Chang  
    Version:       1.0.0  
    Last Updated:  2025-06-25
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$inputFolderPath
    )

    Write-Bounds `
        -FunctionName $MyInvocation.MyCommand.Name `
        -Mode "Enter"
    Write-Verbose "Validating folder path '$inputFolderPath'..."

    $isFolderValid = $true

    # Suppress intermediate output to avoid leaking into the pipeline
    if (-not (Test-Path -Path $inputFolderPath -ErrorAction SilentlyContinue)) {
        Write-Warning "Folder '$inputFolderPath' does not exist!"
        $isFolderValid = $false
    }

    if (-not (Test-Path -Path $inputFolderPath -PathType Container -ErrorAction SilentlyContinue)) {
        Write-Warning "Path '$inputFolderPath' is not a folder, likely a file!"
        $isFolderValid = $false
    }

    Write-Verbose "Validation complete."
    Write-Bounds `
        -FunctionName $MyInvocation.MyCommand.Name `
        -Mode "Exit"

    return $isFolderValid
}