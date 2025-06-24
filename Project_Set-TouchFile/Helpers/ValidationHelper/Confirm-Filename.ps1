# * ValidationHelper
function Confirm-Filename {
    <#
    .SYNOPSIS
    Validates a filename to ensure it complies with Windows file system rules.

    .DESCRIPTION
    The Confirm-Filename function performs a comprehensive series of checks on a given filename 
    to ensure it is valid for file creation or update operations. The checks include:

    - Empty or whitespace-only names
    - Presence of invalid characters (`< > : " / \ | ? *`)
    - Reserved Windows device names (e.g., CON, NUL, COM1)
    - Trailing dots
    - Path length limits (max 260 characters)
    - Optional existence check (used to detect duplicates)

    This function returns `$true` if the filename passes all checks, or `$false` if any condition fails. 
    Warnings are written to the host for any validation failure, but the function does not throw errors.

    .PARAMETER filename
    The name of the file to validate. Leading and trailing whitespace should be trimmed prior to this check.
    Used in all validation steps.

    .PARAMETER fileFolder
    The folder where the file resides or will be created. Combined with the filename to form a full path 
    used for duplicate and length checks.

    .INPUTS
    [string] Accepts the filename and folder path as input strings.

    .OUTPUTS
    [bool] Returns `$true` if the filename is valid; otherwise, returns `$false`.

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
        [string]$fileFolder
    )

    $isValidFilename = $true

    Write-Verbose "In folder '$fileFolder',"
    Write-Verbose "for file '$filename',"
    Write-Verbose "checking for filename validity..."

    # Try to find duplicates, if there is, that is fine
    Write-Verbose "Checking filename '$filename' for duplicates..."
    $fullPath = Join-Path -Path $fileFolder -ChildPath $filename
    if (Test-Path -Path $fullPath) {
        Write-Host "File '$filename' already exists at" `
            -ForegroundColor DarkYellow
        Write-Host "location '$filefolder'." `
            -ForegroundColor DarkYellow
        $isValidFilename = $true
    }

    # Ensure each filename is not null or empty
    Write-Verbose "Checking filename '$filename' for empty or white space..."
    if ([string]::IsNullOrWhiteSpace($filename)) {
        Write-Warning "Filename cannot be empty or whitespace."
        $isValidFilename = $false
    }
        
    # Ensure each filename is valid under Windows rules
    Write-Verbose "Checking filename '$filename' for prohibited characters..."
    if ($filename -match '[<>:"/\\|?*]') {
        Write-Warning "Invalid filename '$filename'."
        Write-Warning "It contains characters that are not allowed in Windows."
        $isValidFilename = $false
    }

    Write-Verbose "Checking filename '$filename' for reserved Windows names..."
    $reserved = @('CON', 'PRN', 'AUX', 'NUL', 'COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', 'COM7', 'COM8', 'COM9', 'LPT1', 'LPT2', 'LPT3', 'LPT4', 'LPT5', 'LPT6', 'LPT7', 'LPT8', 'LPT9')
    if ($reserved -contains ($filename.Split('.')[0].ToUpper())) {
        Write-Warning "Filename '$filename' is a reserved Windows name."
        $isValidFilename = $false
    }

    Write-Verbose "Checking filename '$filename' for trailing dots..."
    if ($filename.EndsWith('.')) {
        Write-Warning "Filename '$filename' cannot end with a dot."
        $isValidFilename = $false
    }

    Write-Verbose "Checking length of path to the file:"
    Write-Verbose "'$fullPath'"
    if ($fullPath.Length -gt 260) {
        Write-Warning "The path '$fullPath' exceeds the maximum allowed length."
        $isValidFilename = $false
    }
    
    Write-Verbose "Filename check passed.`n"
    return $isValidFilename
}
