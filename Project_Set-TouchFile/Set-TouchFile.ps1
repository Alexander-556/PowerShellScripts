function Set-TouchFile {
    <#
    .SYNOPSIS
    #>
    
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'ByName')]
        [Alias("Filename")]
        [string[]]$filenameArray,

        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'ByName')]
        [Alias("Location")]
        [string]$desiredLocation,

        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'ByFullPath')]
        [Alias("FullPath")]
        [string]$fullInputPath
    )

    # Import helper functions
    Import-Module "$PSscriptRoot\SetTouchFileTools.psd1" -Force
    
    # Touch mode selection
    if ($PSBoundParameters.ContainsKey("fullInputPath")) {
        # In quick access mode, recurse call Set-TouchFile with provided path
        Write-Host "Enter quick access mode." `
            -ForegroundColor Green

        $fileObjQuick = Split-FilePath -inputPath $fullInputPath

        # Recurse call
        Set-TouchFile `
            -Filename $fileObjQuick.filename `
            -Location $fileObjQuick.fileFolder

        # End function after recurse call
        return
    }
    else {
        # Resolve the full path for safety
        $resolvedFullPath = Resolve-PathwErr -inputPath $desiredLocation

        # In normal mode, check validity
        # Check filename array validity
        Confirm-FilenameArray -filenameArray $filenameArray

        # Check desired folder validity only when provided
        if ($PSBoundParameters.ContainsKey("desiredLocation")) {
            Confirm-DesiredFolder -desiredLocation $resolvedFullPath
        }
    }

    # Enable processing array input of filenames
    foreach ($filename in $filenameArray) {

        $fileObj = Get-FileObj `
            -filename $filename `
            -fileFolder $fileFolder `
            -fullPath $fullPath `
            -desiredLocation $desiredLocation

        $isValidFilename = Confirm-Filename `
            -filename $fileObj.Filename `
            -fileFolder $fileObj.FileFolder
        
        if (-not $isValidFilename) {
            Write-Verbose "In folder '$($fileObj.FileFolder)',"
            Write-Warning "file '$($fileObj.Filename)' is invalid and will be skipped."
            continue
        }

        # Custom logic to handle the touch behavior, similar to unix touch, but different
        # This try block handles unexpected errors in the whole process
        try {
            # If the file is not there, create new file
            if (-not (Test-Path $fileObj.FullPath)) {
                Invoke-CreationFile `
                    -filename $fileObj.Filename`
                    -fileFolder $fileObj.FileFolder`
                    -fullPath $fileObj.FullPath
            }
            # If the file already exists, 
            else {
                Invoke-UpdateFile `
                    -filename $fileObj.Filename`
                    -fileFolder $fileObj.FileFolder`
                    -fullPath $fileObj.FullPath
            }
        }
        catch {
            Write-Error "Unexpected Error: $_"
        }
    }
    return
}