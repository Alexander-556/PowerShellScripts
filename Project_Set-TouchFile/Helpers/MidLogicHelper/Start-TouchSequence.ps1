# * MidLogicHelper
function Start-TouchSequence {
    <#
    .SYNOPSIS
    Processes a batch of filenames and performs touch operations in a specified folder.

    .DESCRIPTION
    The Start-TouchSequence function is an internal utility that serves as the core logic 
    handler for batch file creation and timestamp updates. It receives a validated list 
    of filenames and a resolved target folder, then processes each file individually.

    For each file:
    - If the file does not exist, a new empty file is created using `Invoke-CreationFile`.
    - If the file exists, its timestamp is updated using `Invoke-UpdateFile`.
    - If the filename is invalid, the file is skipped with a warning.

    This function is designed for internal use within the Set-TouchFile module 
    and is not intended to be called directly by end users.

    .PARAMETER filenameArray
    A validated list of filenames to be processed. Each file will be created or updated 
    within the target folder. Must be a System.Collections.Generic.List[string].

    .PARAMETER desiredLocationObj
    A resolved folder object containing:
    - `Path`  [string] : The directory in which to create/update the files.
    - `Valid` [bool]   : Indicates whether the folder was resolved as valid.

    This object should be obtained via Resolve-InputFolderPath or Get-LocationObj.

    .INPUTS
    [System.Collections.Generic.List[string]], [PSCustomObject]

    .OUTPUTS
    None. Performs file system operations and writes status messages to the console.

    .NOTES
    Private helper function for the Set-TouchFile module.  
    Not exposed publicly and should only be used internally.

    Scope:         Private  
    Author:        Jialiang Chang  
    Version:       1.0.0  
    Last Updated:  2025-06-24
    #>

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