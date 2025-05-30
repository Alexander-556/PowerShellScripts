function Get-FileObj {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$filename,

        [Parameter(Mandatory = $false)]
        [string]$desiredLocation

    )

    # Normalize the filename by removing leading and trailing whitespace
    $filename = $filename.Trim()

    # If selected a desired path, use this path
    $fileFolder = $desiredLocation

    $fullPath = Join-Path -Path $fileFolder -ChildPath $filename

    # Create a PSObject to store file info
    $fileObj = [PSCustomObject]@{
        FileFolder = $fileFolder
        Filename   = $filename
        FullPath   = $fullPath
    }

    return $fileObj
}