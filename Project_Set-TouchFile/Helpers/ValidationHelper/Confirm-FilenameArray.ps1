# * ValidationHelper
function Confirm-FilenameArray {
    <#
    .SYNOPSIS
    Validates an array of filenames to ensure they are suitable for processing.

    .DESCRIPTION
    The Confirm-FilenameArray function validates a list of filenames prior to file creation.
    It performs two critical checks:

    1. Ensures the array is not null or empty.
    2. Detects duplicate entries by comparing the input count to the count of unique values.

    If the input fails either check, an error is thrown using the internal Show-ErrorMsg utility. 
    This helps prevent unintended behavior during touch operations.

    This function is intended for internal use only and is used by Set-TouchFile 
    to enforce input correctness before proceeding with file operations.

    .PARAMETER filenameArray
    The list of filenames to validate. Must not be null, empty, or contain duplicates.

    .INPUTS
    [string[]] Accepts an array of strings representing filenames.

    .OUTPUTS
    None. The function writes verbose output and throws terminating errors when validation fails.

    .NOTES
    Private helper function for the Set-TouchFile module.
    This function is not intended for direct use by end users.

    Scope:         Private
    Author:        Jialiang Chang
    Version:       1.0.0
    Last Updated:  2025-06-24
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Generic.List[string]]$filenameArray
    )

    Write-Verbose "Start checking input filename array..."

    Write-Verbose "Checking file input for null..."
    if (-not $filenameArray -or $filenameArray.Count -eq 0) {
        Show-ErrorMsg `
            -FunctionName $MyInvocation.MyCommand.Name `
            -CustomMessage "No filename provided. Please specify a filename."
    }

    Write-Verbose "Checking file input for duplication..."
    if ($filenameArray.Count -ne ($filenameArray | Select-Object -Unique).Count) {
        Show-ErrorMsg `
            -FunctionName $MyInvocation.MyCommand.Name `
            -CustomMessage "Duplicate filenames detected in the input."
    }

    Write-Verbose "Filename input check passed.`n"
}