# * ValidationHelper
function Confirm-DesiredFolder {
    <#
    .SYNOPSIS
    Validates a folder path to ensure it is suitable for file operations.

    .DESCRIPTION
    The `Confirm-DesiredFolder` function performs a series of checks on a specified folder
    path to ensure it is valid and suitable for file operations. It checks for empty or 
    whitespace paths, folder existence, protected system folders, network paths, 
    symbolic links, disk space, and write permissions. If any validation fails, 
    the function throws an error, and the program will stop.

    .PARAMETER desiredLocation
    The folder path to validate. This can be an absolute or relative path.

    .INPUTS
    [string]
    Accepts a single folder path as input.

    .OUTPUTS
    None. Outputs validation messages to the console.

    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$desiredLocation
    )

    Write-Verbose "Checking folder '$desiredLocation' for empty or whitespace..."
    if ([string]::IsNullOrWhiteSpace($desiredLocation)) {
        Write-Error "File location path cannot be empty or whitespace."
        throw
    }

    Write-Verbose "Checking folder '$desiredLocation' validity..."
    if (-not (Test-Path $desiredLocation -PathType Container -IsValid)) {
        Write-Error "The specified folder path is not valid."
        throw
    }

    Write-Verbose "Checking folder '$desiredLocation' for folder property..."
    if (-not (Test-Path $desiredLocation -PathType Container)) {
        Write-Error "The specified folder does not exist or is not a directory."
        throw
    }

    Write-Verbose "Checking folder '$desiredLocation'for Windows protected folders..."
    $protectedFolders = @(
        [Environment]::GetFolderPath('Windows'),
        [Environment]::GetFolderPath('ProgramFiles'),
        [Environment]::GetFolderPath('ProgramFilesX86'),
        [Environment]::GetFolderPath('System'),
        [Environment]::GetFolderPath('SystemX86'),
        [Environment]::GetFolderPath('UserProfile')
    )
    if ($protectedFolders -contains (Resolve-Path $desiredLocation).Path) {
        Write-Error "Cannot create files in protected or system folders."
        throw
    }
    
    Write-Verbose "Checking folder '$desiredLocation' for network paths..."
    if ($desiredLocation -like '\\*') {
        Write-Error"The desired folder is a network path, currently not supported."
        throw
    }

    Write-Verbose "Checking folder '$desiredLocation' for symbolic links and junctions..."
    $item = Get-Item $desiredLocation
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        Write-Warning "The target folder is a symbolic link or junction."
    }

    Write-Verbose "Checking folder '$desiredLocation' for remaining disk space..."
    $drive = Get-PSDrive -Name ([System.IO.Path]::GetPathRoot($desiredLocation) -replace '[:\\]', '')
    if ($drive.Free -lt 1MB) {
        Write-Error "Not enough disk space in the desired location."
        throw
    }

    Write-Verbose "Checking folder '$desiredLocation' for read only..."
    try {
        $tempFile = [System.IO.Path]::Combine($desiredLocation, [System.IO.Path]::GetRandomFileName())
        
        New-Item -Path $tempFile -ItemType File -Force -ErrorAction Stop | Remove-Item
    }
    catch {
        Write-Error "Unable to write files to '$desiredLocation'."
        throw
    }
    
    Write-Verbose "Desired folder check passed."
}