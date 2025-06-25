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
    [string] Accepts a single folder path as input.

    .OUTPUTS
    [string] Returns the resolved folder path if successful; otherwise, returns `$null`.
    
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
    
    Write-Verbose "Resolving path for '$inputFolderPath'."

    # Catch any error during Resolve-Path operation
    try {
        $outputPath = (Resolve-Path -Path $inputFolderPath -ErrorAction Stop).Path
        Write-Verbose "Resolve operation successful for '$inputFolderPath',"
        Write-Verbose "Output path: '$outputPath'."
    }
    catch {
        $outputPath = $null
    }
    
    return $outputPath
}