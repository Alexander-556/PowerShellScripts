# * QueryHelper
function Confirm-OpenFile {
    <#
    .SYNOPSIS
    Prompts the user to open a file and optionally trigger a rename workflow.

    .DESCRIPTION
    The Confirm-OpenFile function interactively prompts the user to decide whether to 
    open a specified file using the default system editor. It is typically invoked after 
    a file has been created or updated in the Set-TouchFile module.

    If the user chooses to open the file (`Y`, `y`, or presses Enter), the file is launched 
    via `Start-Process`. If the user declines (`N` or `n`), the function may optionally trigger 
    a follow-up action depending on the specified mode.

    Supported modes:
    - `Clean`   : Prompts to open the file only.
    - `NewName` : If declined, triggers the `Confirm-NewNameFile` prompt for renaming.

    .PARAMETER filename
    The name of the file to open. Used for display and error messaging.

    .PARAMETER fileFolder
    The directory containing the file. Used for context in verbose output.

    .PARAMETER fullPath
    The full path to the file, used by `Start-Process` to launch it.

    .PARAMETER mode
    The prompt behavior mode. Must be either `'Clean'` or `'NewName'`.

    .INPUTS
    [string] Accepts strings for filename, folder path, full path, and mode.

    .OUTPUTS
    [bool] Returns `$true` if the file was opened successfully, or `$false` otherwise.

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
        [string]$fullPath,

        [Parameter(Mandatory = $true)]
        [string]$mode
    )

    $validModes = @('Clean', 'NewName')
    if (-not ($validModes -contains $mode)) {
        throw "Query mode selection error, check code."
    }

    $yesKeyWords = @('Y', 'y', '')
    $nooKeyWords = @('N', 'n')

    # Prompt user to open the file or not
    Write-Host "Do you want to open the file now? (Y/N, Enter=Yes)" `
        -ForegroundColor Cyan

    # Loop for continuous prompting
    while ($true) {
        # Read user input
        $response = Read-Host "Enter your response"
        
        # Check if the user wants to open the file
        if ($yesKeyWords -contains $response) {                        
            # Open the file in the default editor
            # This try block checks error in file opening process
            try { 
                Start-Process $fullPath -ErrorAction Stop
                return $true
            }
            catch {
                Write-Warning "In folder '$fileFolder',"
                Write-Warning "failed to open file '$filename'."
                return $false
            }
        }
        elseif ($nooKeyWords -contains $response) {
            Write-Verbose "In folder '$fileFolder',"
            Write-Host "Open file '$filename' cancelled." `
                -ForegroundColor DarkYellow

            if ($mode -eq "NewName") {
                Write-Verbose "Start NewName query..."
                Confirm-NewNameFile -desiredLocation $fileFolder
            }

            return $false
        }
        else {
            Write-Warning "Invalid response. Please enter 'Y' or 'N'."
        }
    }
}