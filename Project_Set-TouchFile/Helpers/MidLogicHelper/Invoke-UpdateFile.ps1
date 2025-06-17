# * MidLogicHelper
function Invoke-UpdateFile {
    <#
    .SYNOPSIS
    Updates the timestamp of an existing file and prompts the user for further actions.

    .DESCRIPTION
    The `Invoke-UpdateFile` function updates the last write time of an existing file to 
    the current time.  It validates the input parameters and handles errors during the 
    timestamp update process. After updating the file, it prompts the user to decide 
    whether to open the file or perform additional actions. The function uses `Get-Item`
    to update the timestamp and `Confirm-OpenFile` to handle the file opening prompt.

    .PARAMETER filename
    The name of the file to update.

    .PARAMETER fileFolder
    The folder path where the file resides.

    .PARAMETER fullPath
    The full path to the file, combining the folder path and filename.

    .INPUTS
    [string]
    Accepts the filename, folder path, and full path as input.

    .OUTPUTS
    None. Outputs status messages to the console.

    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.

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