function Invoke-UpdateFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$filename,

        [Parameter(Mandatory = $true)]
        [string]$fileFolder,

        [Parameter(Mandatory = $true)]
        [string]$fullPath
    )
    
    # First update file timestamp
    # This try block checks errors in the update timestamp process
    try {
        # Update the file's last write time to the current time
        (Get-Item $fullPath).LastWriteTime = Get-Date
        # Notify the user of the update
        Write-Verbose "In folder '$fileFolder',"
        Write-Host "File '$filename' already exists, updating its timestamp." `
            -ForegroundColor Green
    }
    catch {
        # Catch if update fails
        Write-Verbose "In folder '$fileFolder',"
        Write-Warning "Failed to update timestamp for file '$filename'. Error: $_"
    }

    $fullPath = Join-Path -Path $fileFolder -ChildPath $filename
    # Then start new filename query
    $isFileOpen = Confirm-OpenFile `
        -filename $filename `
        -fileFolder $fileFolder `
        -fullPath $fullPath `
        -mode "NewName"

    if ($isFileOpen) {
        Write-Verbose "In folder '$fileFolder,'"
        Write-Verbose "file '$filename' opened."
    }
}