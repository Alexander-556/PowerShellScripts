# * ValidationHelper
function Confirm-DesiredFolder {
    <#
    .SYNOPSIS
    Validates a folder path to ensure it is suitable for file operations.

    .DESCRIPTION
    The Confirm-DesiredFolder function performs comprehensive validation on a user-specified 
    folder path. It checks for:

    - Null or whitespace-only values
    - Empty or invalid path segments
    - Invalid syntax
    - Network paths (e.g., UNC paths like \\server\share)
    - Disk space availability (requires at least 1 MB free)

    If any check fails, the function throws a terminating error using the internal Show-ErrorMsg utility. 
    This validation helps prevent issues during file creation or touch operations.

    This function is designed for internal use within the Set-TouchFile module and is 
    not intended for direct invocation by end users.

    .PARAMETER desiredLocation
    The folder path to validate. May be absolute or relative. The path will be trimmed 
    and parsed to ensure it conforms to the required structure and rules.

    .INPUTS
    [string] Accepts a single string representing a folder path.

    .OUTPUTS
    None. This function writes verbose output and throws errors when validation fails.

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
        [string]$desiredLocation
    )

    Write-Verbose "Start checking input folder validity..."
    Write-Verbose "Input path: '$desiredLocation'"

    # When location is empty, cannot proceed
    if ([string]::IsNullOrWhiteSpace($desiredLocation)) {
        # Handle paths that are empty or contain only whitespace
        Show-ErrorMsg `
            -FunctionName $MyInvocation.MyCommand.Name `
            -CustomMessage "File location path cannot be empty or white space."
    }
    else {
        # Trim end slashes to allow trailing slashes
        $desiredLocation = $desiredLocation.TrimEnd('\', '/')
        # Split the path into components and check for invalid segments
        $pathSegments = $desiredLocation -split '[\\/]'  # Split on '\' or '/'
        foreach ($segment in $pathSegments) {
            if ([string]::IsNullOrWhiteSpace($segment)) {
                Show-ErrorMsg `
                    -FunctionName $MyInvocation.MyCommand.Name `
                    -CustomMessage "One or more File location path segment contains white space only."
            }
        }
    }

    # When syntax is not valid, cannot proceed
    if (-not (Test-Path -Path $desiredLocation -IsValid)) {
        Show-ErrorMsg `
            -FunctionName $MyInvocation.MyCommand.Name `
            -CustomMessage "The specified path syntax is not valid."
    }

    # When input folder path is not a folder, cannot proceed
    # if (-not (Test-Path $desiredLocation -PathType Container)) {
    #     Write-Error "The specified folder does not exist or is not a directory."
    #     throw
    # }

    # When input folder is Windows protected folder, cannot proceed
    # $protectedFolders = @(
    #     [Environment]::GetFolderPath('Windows'),
    #     [Environment]::GetFolderPath('ProgramFiles'),
    #     [Environment]::GetFolderPath('ProgramFilesX86'),
    #     [Environment]::GetFolderPath('System'),
    #     [Environment]::GetFolderPath('SystemX86'),
    #     [Environment]::GetFolderPath('UserProfile')
    # )

    # if ($protectedFolders -contains (Resolve-Path $desiredLocation).Path) {
    #     Write-Error "Cannot create files in protected or system folders."
    #     throw
    # }
    
    # When input folder is network path, cannot proceed
    if ($desiredLocation -like '\\*') {
        Show-ErrorMsg `
            -FunctionName $MyInvocation.MyCommand.Name `
            -CustomMessage "The desired folder is a network path, currently not supported."
    }

    # # When input folder is a symbolic link or junction, cannot proceed
    # $item = Get-Item $desiredLocation
    # if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
    #     Write-Warning "The target folder is a symbolic link or junction."
    # }

    # When the target disk doesn't have enough space, cannot proceed
    $drive = Get-PSDrive -Name ([System.IO.Path]::GetPathRoot($desiredLocation) -replace '[:\\]', '')
    if ($drive.Free -lt 1MB) {
        Show-ErrorMsg `
            -FunctionName $MyInvocation.MyCommand.Name `
            -CustomMessage "Not enough disk space in the desired location."
    }

    # This check cannot be enforced
    # Write-Verbose "Checking folder '$desiredLocation' for read only..."
    # try {
    #     $tempFile = [System.IO.Path]::Combine($desiredLocation, [System.IO.Path]::GetRandomFileName())
        
    #     New-Item -Path $tempFile -ItemType File -Force -ErrorAction Stop | Remove-Item
    # }
    # catch {
    #     Write-Error "Unable to write files to '$desiredLocation'."
    #     throw
    # }
    
    Write-Verbose "Input folder check passed.`n"
}