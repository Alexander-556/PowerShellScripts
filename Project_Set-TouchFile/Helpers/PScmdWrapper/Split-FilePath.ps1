function Split-FilePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$inputPath
    )
    
    if ((Test-Path $inputPath)) {
        # Resolve the full path (handles relative paths)
        $outputPath = Resolve-PathwErr -inputPath $inputPath
    }
    else {
        $creationFolder = Split-Path -Path $inputPath -Parent
        $resolvedCreationFolder = Resolve-PathwErr -inputPath $creationFolder

        $creationFilename = Split-Path -Path $inputPath -Leaf
        $outputPath = Join-Path -Path $resolvedCreationFolder -ChildPath $creationFilename
    }

    # Set folder and filenames
    $fileFolder = Split-Path -Path $outputPath -Parent
    $filename = Split-Path -Path $outputPath -Leaf

    $fileObj = [PSCustomObject]@{
        FileFolder = $fileFolder
        Filename   = $filename
    }

    return $fileObj
}