# * QueryHelper
function Confirm-FileConflict {
    <#
    .SYNOPSIS
    Prompts the user to resolve file conflicts during a file move operation.

    .DESCRIPTION
    The `Confirm-FileConflict` function handles file conflict resolution by prompting the user 
    to choose an action for the conflicting file. Supported actions include skipping the file 
    or renaming it. The function continuously prompts the user until a valid response is provided.

    .PARAMETER targetFileObj
    A custom object representing the file involved in the conflict. Contains metadata such as 
    filename and destination path. This is the default output object of the Cmdlet
    Get-ChildItem.

    .PARAMETER folderObj
    A custom object representing the folder containing the file. Contains metadata such as 
    parent folder, folder name, and folder validity.

    .INPUTS
    [PSCustomObject]
    Accepts the target file object and folder object as input.

    .OUTPUTS
    [string]
    Returns the user-selected action (`skip` or `rename`).

    .NOTES
    Private helper function for internal validation in the Move-ChildItemUp module.  
    Not intended for direct use by end users.

    Scope:         Private  
    Author:        Jialiang Chang  
    Version:       1.0.0  
    Last Updated:  2025-06-25
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [PSCustomObject]$targetFileObj,
        [Parameter(Mandatory = $true, Position = 1)]
        [PSCustomObject]$folderObj
    )

    Write-Bounds `
        -FunctionName $MyInvocation.MyCommand.Name `
        -Mode "Enter"
    Write-Verbose "Checking user response..."

    $skipKeyWords = @('S', 's', '')
    $renameKeyWords = @('R', 'r')
    # $overwriteKeyWords = @('O', 'o')

    Write-Host "To skip this file, type " -NoNewline -ForegroundColor Cyan
    Write-Host "'S'" -NoNewline -ForegroundColor Cyan
    Write-Host ", 's', or press Enter." -ForegroundColor Cyan

    Write-Host "To rename this file, type " -NoNewline -ForegroundColor Cyan
    Write-Host "'R'" -NoNewline -ForegroundColor Cyan
    Write-Host " or 'r'." -ForegroundColor Cyan


    # Loop for continuous prompting
    while ($true) {
        # Read user input
        $response = Read-Host "Enter your response"
        
        if ($skipKeyWords -contains $response) {                        
            Write-Host "File '$($targetFileObj.Filename)' will be skipped." `
                -ForegroundColor Green

            Write-Verbose "User action confirmed."
            Write-Bounds `
                -FunctionName $MyInvocation.MyCommand.Name `
                -Mode "Exit"
                
            return "skip"
        }
        elseif ($renameKeyWords -contains $response) {
            Write-Host "File '$($targetFileObj.Filename)' in '$($folderObj.Name)' will be renamed." `
                -ForegroundColor Green

            Write-Verbose "User action confirmed."
            Write-Bounds `
                -FunctionName $MyInvocation.MyCommand.Name `
                -Mode "Exit"

            return "rename"
        }
        else {
            Write-Warning "Invalid response. Please follow the instructions below:"
            Write-Host "To skip this file, type " -NoNewline -ForegroundColor DarkYellow
            Write-Host "'S'" -NoNewline -ForegroundColor DarkYellow
            Write-Host ", 's', or press Enter." -ForegroundColor DarkYellow

            Write-Host "To rename this file, type " -NoNewline -ForegroundColor DarkYellow
            Write-Host "'R'" -NoNewline -ForegroundColor DarkYellow
            Write-Host " or 'r'." -ForegroundColor DarkYellow
        }
    }
}