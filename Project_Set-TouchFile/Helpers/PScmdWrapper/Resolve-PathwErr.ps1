# * PScmdWrapper
function Resolve-PathwErr {
    <#
    .SYNOPSIS
    Resolves a folder path using Resolve-Path and handles errors gracefully.

    .DESCRIPTION
    The Resolve-PathwErr function is a private wrapper around the built-in `Resolve-Path` cmdlet. 
    It attempts to resolve a given folder path to its full canonical form. If the resolution 
    succeeds, the resolved path is returned. If it fails, the function throws a terminating error 
    using the internal `Show-ErrorMsg` utility and halts execution.

    This function improves error transparency and unifies error handling within the Set-TouchFile module.

    .PARAMETER inputPath
    The raw folder path to resolve. This can be an absolute or relative path.

    .INPUTS
    [string] Accepts a single string representing the folder path.

    .OUTPUTS
    [string] Returns the resolved folder path as a string if successful.

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

    Write-Verbose "Resolving path for '$inputPath'."

    # Catch any error during Resolve-Path operation
    try {
        $outputPath = (Resolve-Path -Path $inputPath -ErrorAction Stop).Path
        Write-Verbose "Resolve operation successful for '$inputPath',"
        Write-Verbose "output path: '$outputPath'.`n"
        return $outputPath
    }
    catch {
        Show-ErrorMsg `
            -FunctionName $MyInvocation.MyCommand.Name `
            -CustomMessage "Failed to resolve input path '$inputPath'." `
            -Exception $_.Exception
    }
}