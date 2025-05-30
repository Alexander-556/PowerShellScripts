function Split-FilePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$inputPath
    )
    
    # Resolve the full path (handles relative paths)
    $resolvedFullPath = Resolve-PathwErr -inputPath $inputPath
        
    # Set folder and filenames
    $fileFolder = Split-Path -Path $resolvedFullPath -Parent
    $filename = Split-Path -Path $resolvedFullPath -Leaf

    $fileObj = [PSCustomObject]@{
        FileFolder = $fileFolder
        Filename   = $filename
    }

    return $fileObj
}