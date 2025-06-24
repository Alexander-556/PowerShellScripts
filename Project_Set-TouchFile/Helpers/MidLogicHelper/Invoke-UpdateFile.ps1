# * MidLogicHelper
function Invoke-UpdateFile {
    <#
    .SYNOPSIS
    Updates the last write timestamp of an existing file and optionally prompts the user to open or rename it.

    .DESCRIPTION
    The Invoke-UpdateFile function updates the last write time of a specified file to the current system time. 
    It is typically used when the target file already exists and does not require creation.

    The function uses `Get-Item` to retrieve the file and update its timestamp. The update process is 
    wrapped in a `try/catch` block to handle and report any exceptions.

    After the timestamp is updated, the function prompts the user (via `Confirm-OpenFile`) to optionally 
    open the file or proceed with renaming it. This interaction supports the interactive behavior of the 
    Set-TouchFile module.

    .PARAMETER filename
    The name of the file to update. This must refer to an existing file.

    .PARAMETER fileFolder
    The directory in which the file resides. Used for messaging and path reconstruction.

    .PARAMETER fullPath
    The complete path to the file, combining the filename and folder path. Used for timestamp update and user prompts.

    .INPUTS
    [string] Accepts strings for filename, folder path, and full file path.

    .OUTPUTS
    None. Performs file operations and writes status messages to the console.

    .NOTES
    Private helper function for the Set-TouchFile module.  
    Not intended for direct use by end users.

    Scope:         Private  
    Author:        Jialiang Chang  
    Version:       1.0.0  
    Last Updated:  2025-06-24
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$filename,

        [Parameter(Mandatory = $true)]
        [string]$fileFolder,

        [Parameter(Mandatory = $true)]
        [string]$fullPath
    )
    
    # First update file timestamp
    # This try block checks errors in the update timestamp process
    try {
        Write-Verbose "In folder '$fileFolder',"
        Write-Verbose "updating file '$filename' timestamp."

        # Update the file's last write time to the current time
        (Get-Item $fullPath).LastWriteTime = Get-Date

        # Notify the user of the update
        Write-Host "File '$filename' timestamp updated." `
            -ForegroundColor Green
    }
    catch {
        # Catch if update fails
        Show-ErrorMsg `
            -FunctionName $MyInvocation.MyCommand.Name `
            -CustomMessage "In folder '$fileFolder', failed to update timestamp for file '$filename'." `
            -Exception $_.Exception
    }

    $fullPath = Join-Path -Path $fileFolder -ChildPath $filename
    
    # Then start new filename query
    $isFileOpen = Confirm-OpenFile `
        -filename $filename `
        -fileFolder $fileFolder `
        -fullPath $fullPath `
        -mode "NewName"

    if ($isFileOpen) {
        Write-Verbose "In folder '$fileFolder,'"
        Write-Host "File '$filename' opened." `
            -ForegroundColor Green
    }
}