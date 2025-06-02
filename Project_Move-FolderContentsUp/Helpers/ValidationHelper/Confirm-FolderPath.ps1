function Confirm-FolderPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$inputFolderPath
    )

    $isFolderValid = $true

    if ($null -eq $inputFolderPath) {
        Write-Warning "Path resolution failed!"
        $isFolderValid = $false
    }

    if (-not (Test-Path -Path $inputFolderPath)) {
        Write-Warning "Folder '$inputFolderPath' does not exist!"
        $isFolderValid = $false
    }
    elseif (-not (Test-Path -Path $inputFolderPath -PathType Container)) {
        Write-Warning "Path '$inputFolderPath' is not a folder, likely a file!"
        $isFolderValid = $false
    }

    if (-not $isFolderValid) {
        Write-Warning "The above path will be skipped."
    }

    return $isFolderValid
}