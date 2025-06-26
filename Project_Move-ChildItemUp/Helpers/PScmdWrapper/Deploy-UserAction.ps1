# * PScmdWrapper
function Deploy-UserAction {
    <#
    .SYNOPSIS
    Executes user-specified actions on a file during a file conflict resolution process.

    .DESCRIPTION
    The `Deploy-UserAction` function processes a user-specified action (`rename`, `skip`, 
    etc.) for a file during a conflict resolution scenario. It modifies the target file 
    object based on the action provided. Currently, it only supports renaming files using 
    the `Start-Rename` function.

    .PARAMETER userAction
    Specifies the action to perform on the file. Supported actions include `rename` and others 
    (to be implemented in the future).

    .PARAMETER targetFileObj
    A custom object representing the file to be processed. Contains metadata such as filename 
    and destination path. This is the default output object of PowerShell builtin Cmdlet
    Get-ChildItem.

    .PARAMETER folderObj
    A custom object representing the folder containing the file. Contains metadata such as 
    parent folder, folder name, and folder validity.

    .INPUTS
    [string]
    Accepts the user action as input.

    [PSCustomObject]
    Accepts the target file object and folder object as input.

    .OUTPUTS
    [PSCustomObject]
    Returns the modified target file object after applying the user action.

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
        [string]$userAction,

        [Parameter(Mandatory = $true, Position = 1)]
        [PSCustomObject]$targetFileObj,

        [Parameter(Mandatory = $true, Position = 2)]
        [PSCustomObject]$folderObj
    )
    
    Write-Bounds `
        -FunctionName $MyInvocation.MyCommand.Name `
        -Mode "Enter"
    Write-Verbose "Carrying out user action..."

    # Execute the rename operation
    if ($userAction -eq "rename") {
        $targetFileObj = Start-Rename $targetFileObj
        return $targetFileObj
    }

    Write-Verbose "User action completed."
    Write-Bounds `
        -FunctionName $MyInvocation.MyCommand.Name `
        -Mode "Exit"
}