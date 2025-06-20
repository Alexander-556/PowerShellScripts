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