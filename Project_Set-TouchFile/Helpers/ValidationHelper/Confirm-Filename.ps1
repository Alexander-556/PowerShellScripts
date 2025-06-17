# * ValidationHelper
function Confirm-Filename {
    <#
    .SYNOPSIS
    Validates a filename to ensure it is suitable for file operations.

    .DESCRIPTION
    The `Confirm-Filename` function performs a series of checks on a specified filename 
    to ensure it is valid and suitable for file operations. It checks for duplicates, 
    empty or whitespace names, prohibited characters, reserved Windows names, leading or 
    trailing dots, and path length limits. If any validation fails, the function returns 
    `$false`. Otherwise, it returns `$true`.

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
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.

    This function can be recycled for other purposes very easily.

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

    Write-Verbose "Checking filename '$filename' for leading or trailing dots..."
    if ($filename.StartsWith('.') -or $filename.EndsWith('.')) {
        Write-Warning "Filename '$filename' cannot start or end with a dot."
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
