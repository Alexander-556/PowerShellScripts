# * PScmdWrapper
function Resolve-PathwErr {
    <#
    .SYNOPSIS
    Resolves a folder path and handles errors gracefully.

    .DESCRIPTION
    The `Resolve-PathwErr` function attempts to resolve a given folder path using the 
    `Resolve-Path` cmdlet. If the resolution fails, it logs warnings and stops the program.
    
    Important Notice:
    If path resolution failed, the program cannot continue.

    .PARAMETER inputPath
    The folder path to resolve. This can be an absolute or relative path.

    .INPUTS
    [string]
    Accepts a single folder path as input.

    .OUTPUTS
    [string]
    Returns the resolved folder path if successful; otherwise, stops the program.
    
    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.
    
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