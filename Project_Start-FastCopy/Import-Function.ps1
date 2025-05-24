function Import-Functions {
    <#    
.SYNOPSIS
    Imports all PowerShell function scripts from a specified folder into the current session.

.DESCRIPTION
    Import-Functions loads every `.ps1` file in the specified folder by dot-sourcing it, making all
    functions defined in those scripts available in the current PowerShell session. This is useful
    for modular script design, allowing you to separate and reuse function definitions across projects.

.PARAMETER functionFolder
    The path to the folder that contains PowerShell function scripts (`.ps1` files). This must be a
    valid and accessible directory path, otherwise an error is thrown and no scripts are loaded.

.EXAMPLE
    Import-Functions -Folder ".\functions"

    Imports all `.ps1` files in the `functions` directory relative to the current location.

.OUTPUTS
    None. This function writes progress messages to the verbose stream.

.NOTES
    Author: Alex
    Version: 1.0
    Last Updated: 2025-05-23

.LINK
    about_Scripts
    about_Functions
    https://learn.microsoft.com/powershell/
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]             # Require the folder path from the user
        [Alias("Folder")]                          # Allow user to use -Folder instead of -functionFolder
        [string]$functionFolder                    # Path to the folder containing .ps1 function scripts
    )

    # Validate that the provided folder exists
    if (-Not (Test-Path $functionFolder)) {
        # Prepare a multi-line error message for clarity and guidance
        $errMsg = @"

    [ERROR] The specified folder '$functionFolder' does not exist.

    Try:
    - Check for typos in the path.
    - Make sure the folder exists on disk.
    - Ensure the script has access permissions.
"@
        Write-Error $errMsg                       # Emit the error and exit early
        return
    }

    # Get all .ps1 files in the folder and dot-source each one into the current session
    Get-ChildItem -Path $functionFolder -Filter *.ps1 -File |
    ForEach-Object {
        Write-Verbose "Importing: $($_.Name)"  # Log which file is being imported (only visible if -Verbose is passed)
        . $_.FullName                          # Dot-source the script to import its functions
    }
}
