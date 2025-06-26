# * ValidationHelper
function Confirm-Filename {
    <#
    .SYNOPSIS
    Validates a filename to ensure it is suitable for file operations.

    .DESCRIPTION
    The `Confirm-Filename` function performs a series of checks on a specified filename 
    to ensure it is valid and suitable for file operations. It checks for duplicates, 
    empty or whitespace names, prohibited characters, reserved Windows names, leading or 
    trailing dots, and path length limits. If any validation fails, the function 
    returns `$false`. Otherwise, it returns `$true`.

    .PARAMETER filename
    The name of the file to validate. Leading and trailing whitespace will be removed.

    .PARAMETER fileFolder
    The folder path where the file resides or will be created. Used to check for duplicate filenames.

    .INPUTS
    [string]
    Accepts the filename and folder path as input.

    .OUTPUTS
    [bool]
    Returns `$true` if the filename is valid; otherwise, returns `$false`.

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
        [Parameter(Mandatory = $true)]
        [string]$filename,

        [Parameter(Mandatory = $true)]
        [string]$fileFolder
    )

    Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
    Write-Verbose "Start checking for filename..."

    # Ensure the new filename doesn't crash with existing file
    Write-Verbose "Checking filename '$filename' for duplicates..."
    $fullPath = Join-Path -Path $fileFolder -ChildPath $filename
    if (Test-Path -Path $fullPath) {
        Write-Warning "Your provided filename '$filename' already exists in '$filefolder'."
        return $false
    }

    # Ensure each filename is not null or empty
    Write-Verbose "Checking filename '$filename' for empty or white space..."
    if ([string]::IsNullOrWhiteSpace($filename)) {
        Write-Error "Filename cannot be empty or whitespace."
        return $false
    }
        
    # Ensure each filename is valid under Windows rules
    Write-Verbose "Checking filename '$filename for prohibited characters...'"
    if ($filename -match '[<>:"/\\|?*]') {
        Write-Error "Invalid filename '$filename'."
        Write-Error "It contains characters that are not allowed in Windows."
        return $false
    }

    Write-Verbose "Checking filename '$filename' for reserved Windows names..."
    $reserved = @('CON', 'PRN', 'AUX', 'NUL', 'COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', 'COM7', 'COM8', 'COM9', 'LPT1', 'LPT2', 'LPT3', 'LPT4', 'LPT5', 'LPT6', 'LPT7', 'LPT8', 'LPT9')
    if ($reserved -contains ($filename.Split('.')[0].ToUpper())) {
        Write-Error "Filename '$filename' is a reserved Windows name."
        return $false
    }

    Write-Verbose "Checking filename '$filename' for leading or trailing dots..."
    if ($filename.StartsWith('.') -or $filename.EndsWith('.')) {
        Write-Error "Filename '$filename' cannot start or end with a dot."
        return $false
    }

    Write-Verbose "Checking length of path to the file: '$fullPath'..."
    if ($fullPath.Length -gt 260) {
        Write-Error "The path '$fullPath' exceeds the maximum allowed length."
        return $false
    }
    
    Write-Verbose "File '$filename' in folder '$fileFolder' check passed."
    Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
    return $true
}
