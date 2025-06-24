# * MidLogicHelper
function Invoke-CreationFile {
    <#
    .SYNOPSIS
    Creates a new file in the specified folder and optionally prompts the user to open it.

    .DESCRIPTION
    The Invoke-CreationFile function is responsible for safely creating a new file at the 
    specified location. It uses the full path to perform file creation via `New-Item` and 
    wraps the operation in a `try/catch` block to handle and report any errors.

    After a successful file creation, the user is prompted (via `Confirm-OpenFile`) to 
    decide whether to open the file. If the user agrees, the file is opened using the default 
    system editor.

    This function is intended for internal use in the Set-TouchFile module and is not 
    meant to be called directly by end users.

    .PARAMETER filename
    The name of the file to create. This should not contain invalid characters and must be a valid filename.

    .PARAMETER fileFolder
    The folder in which the file should be created. This should be a valid and accessible directory path.

    .PARAMETER fullPath
    The full resolved path to the file, combining the folder and filename. Used for both file creation and open-file prompt.

    .INPUTS
    [string] Accepts strings representing filename, folder path, and full path.

    .OUTPUTS
    None. Performs file creation and writes status messages to the console.

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
        [string]$filename,

        [Parameter(Mandatory = $true)]
        [string]$fileFolder,

        [Parameter(Mandatory = $true)]
        [string]$fullPath
    )

    # This try block handles file creation errors
    try {
        # Create the file with the specified name
        New-Item -ItemType File -Path $fullPath -ErrorAction Stop | Out-Null

        # Notify user for file creation
        Write-Verbose "In folder '$fileFolder',"
        Write-Host "file '$filename' created successfully." `
            -ForegroundColor Green
                    
        # Prompt user to open the file or not
        $isFileOpen = Confirm-OpenFile `
            -filename $filename `
            -fileFolder $fileFolder `
            -fullPath $fullPath `
            -mode "Clean"
                    
        if ($isFileOpen) {
            Write-Verbose "In folder '$fileFolder,'"
            Write-Host "File '$filename' opened." `
                -ForegroundColor Green
        }
    }
    catch {
        Show-ErrorMsg `
            -FunctionName $MyInvocation.MyCommand.Name `
            -CustomMessage "In folder '$fileFolder', failed to create file '$filename'." `
            -Exception $_.Exception
    }   
}


