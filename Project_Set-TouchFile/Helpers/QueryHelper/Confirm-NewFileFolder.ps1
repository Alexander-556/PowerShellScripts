# * QueryHelper
function Confirm-NewFileFolder {
    <#
    .SYNOPSIS
    Prompts the user to confirm folder creation for a specified path.

    .DESCRIPTION
    The Confirm-NewFileFolder function interactively prompts the user to decide 
    whether to create a specified folder that does not currently exist. 

    If the user responds with 'Y', 'y', or presses Enter, the folder is created at the given path.  
    If the user responds with 'N' or 'n', the operation is cancelled and the function returns `$false`.  
    Any other input will trigger a warning and reprompt the user.

    This function is intended for internal use in user-facing workflows that 
    involve conditional folder creation, such as in the Set-TouchFile module.

    .PARAMETER inputPath
    The full path to the folder that may need to be created. Must be a string representing 
    a valid filesystem path.

    .INPUTS
    [string] Accepts a string representing a folder path.

    .OUTPUTS
    [bool] Returns `$true` if the folder was created, or `$false` if the operation 
    was cancelled by the user.

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
        [string]$inputPath
    )

    $yesKeyWords = @('Y', 'y', '')
    $nooKeyWords = @('N', 'n')

    # Ask user whether to create the folder
    Write-Host "Do you want to create your specified folder? (Y/N, Enter=Yes)" `
        -ForegroundColor Cyan
    Write-Host "Resolved Path '$inputPath'"

    # Loop for continuous prompting
    while ($true) {
        # Read user input
        $response = Read-Host "Enter your response"
        
        # Check if the user wants to create the folder
        if ($yesKeyWords -contains $response) {
            Write-Verbose "For path '$inputPath',"
            Write-Verbose "New folder creation in progress..."

            New-Item -Path $inputPath -ItemType Directory -Force
            Write-Verbose "New folder has been created at the specified location above."
            return $true
        }
        elseif ($nooKeyWords -contains $response) {
            Write-Verbose "For path '$inputPath',"
            
            Write-Host "New folder creation cancelled, program will terminate."
            return $false
        }
        else {
            Write-Warning "Invalid response. Please enter 'Y' or 'N'."
        }
    }
}