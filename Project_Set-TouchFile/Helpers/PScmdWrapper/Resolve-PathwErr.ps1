function Resolve-PathwErr {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$inputPath
    )

    # Catch any error during Resolve-Path operation
    try {
        Write-Verbose "Resolving path for '$inputPath'."
        $outputPath = (Resolve-Path -Path $inputPath -ErrorAction Stop).Path
        Write-Verbose "Resolve-Path operation successful for '$inputPath',"
        Write-Verbose "output path: '$outputPath'."
        return $outputPath
    }
    catch {
        Write-Warning "Error in Resolve-Path operation for '$inputPath'. Error: $_"
        throw
    }
}