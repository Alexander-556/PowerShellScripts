# * ValidationHelper
function Confirm-FilenameArray {
    <#
    .SYNOPSIS
    Validates an array of filenames to ensure they are suitable for processing.

    .DESCRIPTION
    The `Confirm-FilenameArray` function checks an array of filenames for null values 
    and duplicates. It ensures that the input array contains valid filenames before 
    proceeding with further operations. If invalid filenames are detected, the function 
    throws an error.

    Important Notice:
    Duplication is checked by comparing the length of the input array and the number
    of unique filenames.

    .PARAMETER filenameArray
    An array of filenames to validate. The function checks for null values and duplicates.

    .INPUTS
    [string[]]
    Accepts an array of filenames as input.

    .OUTPUTS
    None. Outputs validation messages to the console.
    
    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.
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