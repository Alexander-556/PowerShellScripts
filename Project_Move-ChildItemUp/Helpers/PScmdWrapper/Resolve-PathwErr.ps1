# * PScmdWrapper
function Resolve-PathwErr {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$inputFolderPath
    )

    
    $inputFolderPathResolved = Resolve-Path -Path $inputFolderPath -ErrorAction SilentlyContinue
    if ($null -eq $inputFolderPathResolved) {
        Write-Warning "Resolve path '$inputFolderPath' failed."
        Write-Warning "The folder will be skipped."
    }
    return $inputFolderPathResolved
    
}