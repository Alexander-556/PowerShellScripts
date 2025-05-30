function Confirm-Filename {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$filename,

        [Parameter(Mandatory = $true)]
        [string]$fileFolder
    )

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

    $fullPath = Join-Path $fileFolder $filename
    Write-Verbose "Checking length of path to the file: '$fullPath'..."
    if ($fullPath.Length -gt 260) {
        Write-Error "The path '$fullPath' exceeds the maximum allowed length."
        return $false
    }
    
    Write-Verbose "File '$filename' in folder '$fileFolder' check passed."
    return $true
}
