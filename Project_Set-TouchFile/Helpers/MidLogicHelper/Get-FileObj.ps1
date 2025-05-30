function Get-FileObj {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$filename,

        [Parameter(Mandatory = $true)]
        [string]$fileFolder,

        [Parameter(Mandatory = $true)]
        [string]$fullPath,

        [Parameter(Mandatory = $false)]
        [string]$desiredLocation

    )

    # Normalize the filename by removing leading and trailing whitespace
    $filename = $filename.Trim()

    # Construct file full path and filename for further use
    if (-not [string]::IsNullOrWhiteSpace($desiredLocation)) {                 
        # If selected a desired path, use this path
        $fileFolder = $desiredLocation
    }
    else {
        # If nothing specified, use current working directory
        $fileFolder = Get-Location
    }

    $fullPath = Join-Path -Path $fileFolder -ChildPath $filename

    # Create a PSObject to store file info
    $fileObj = [PSCustomObject]@{
        FileFolder = $fileFolder
        Filename   = $filename
        FullPath   = $fullPath
    }

    return $fileObj
}