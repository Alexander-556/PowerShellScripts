# * MidLogicHelper
function Start-TouchSequence {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Generic.List[string]]$filenameArray,

        [Parameter(Mandatory = $true)]
        [PSCustomObject]$desiredLocationObj
    )

    foreach ($filename in $filenameArray) {

        $location = $desiredLocationObj.Path

        $fileObj = 
        Get-FileObj `
            -filename $filename `
            -desiredLocation $location

        $isValidFilename = 
        Confirm-Filename `
            -filename $fileObj.Filename `
            -fileFolder $fileObj.FileFolder
        
        if (-not $isValidFilename) {
            Write-Verbose "In folder '$($fileObj.FileFolder)',"
            Write-Host "File '$($fileObj.Filename)' is invalid and will be skipped." `
                -ForegroundColor DarkYellow
            continue
        }

        # Custom logic to handle the touch behavior, similar to unix touch, but different
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
}