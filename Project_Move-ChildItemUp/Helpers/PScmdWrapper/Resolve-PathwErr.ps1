# * PScmdWrapper
function Resolve-PathwErr {
    <#
    .SYNOPSIS
    Resolves a folder path and handles errors gracefully.

    .DESCRIPTION
    The `Resolve-PathwErr` function attempts to resolve a given folder path using the 
    `Resolve-Path` cmdlet. If the resolution fails, it logs warnings and skips the invalid path.
    
    Important Notice:
    If path resolution failed, $null will be assigned to the output.

    .PARAMETER inputFolderPath
    The folder path to resolve. This can be an absolute or relative path.

    .INPUTS
    [string]
    Accepts a single folder path as input.

    .OUTPUTS
    [string]
    Returns the resolved folder path if successful; otherwise, returns `$null`.
    
    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$inputFolderPath
    )

    
    $inputFolderPathResolved = Resolve-Path -Path $inputFolderPath -ErrorAction SilentlyContinue
    if ($null -eq $inputFolderPathResolved) {
        Write-Warning "Resolve path '$inputFolderPath' failed."
        Write-Warning "The folder will be skipped."
    }
    return $inputFolderPathResolved
    
}