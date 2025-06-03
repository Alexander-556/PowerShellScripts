# * PScmdWrapper
function Resolve-PathwErr {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$inputFolderPath
    )

    try {
        $inputFolderPath = Resolve-Path -Path $inputFolderPath
        return $inputFolderPath
    }
    catch {
        Write-Error "Resolve path '$inputFolderPath' failed!"
        return $null
    }
}