function Confirm-FilenameArray {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$filenameArray
    )

    Write-Verbose "Checking file input for null..."
    if (-not $filenameArray -or $filenameArray.Count -eq 0) {
        Write-Error "No filename provided. Please specify a filename."
        throw
    }

    Write-Verbose "Checking file input for duplication..."
    if ($filenameArray.Count -ne ($filenameArray | Select-Object -Unique).Count) {
        Write-Error "Duplicate filenames detected in the input."
        throw
    }

    Write-Verbose "Filename input check passed."
}