# * ValidationHelper
function Confirm-FolderPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$inputFolderPath
    )

    # Initialize bool variable for ecc
    $isFolderValid = $true

    # Test the actual path
    if (-not (Test-Path -Path $inputFolderPath)) {
        Write-Warning "Folder '$inputFolderPath' does not exist!"
        $isFolderValid = $false
    }
    elseif (-not (Test-Path -Path $inputFolderPath -PathType Container)) {
        Write-Warning "Path '$inputFolderPath' is not a folder, likely a file!"
        $isFolderValid = $false
    }

    # * Let's put this warning elsewhere
    # if (-not $isFolderValid) {
    #     Write-Warning "The above path will be skipped."
    # }
    
    return $isFolderValid
}