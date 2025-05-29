function Confirm-DesiredFolder {
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
    $drive = Get-PSDrive -Name ([System.IO.Path]::GetPathRoot($desiredLocation).TrimEnd('\'))
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