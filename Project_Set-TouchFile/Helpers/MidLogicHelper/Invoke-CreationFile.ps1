function Invoke-CreationFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$filename,

        [Parameter(Mandatory = $true)]
        [string]$fileFolder,

        [Parameter(Mandatory = $true)]
        [string]$fullPath
    )

    # This try block handles file creation errors
    try {
        # Create the file with the specified name
        New-Item -ItemType File -Path $fullPath -ErrorAction Stop | Out-Null

        # Notify user for file creation
        Write-Verbose "In folder '$fileFolder',"
        Write-Host "file '$filename' created successfully." `
            -ForegroundColor Green
                    
        # Prompt user to open the file or not
        $isFileOpen = Confirm-OpenFile `
            -filename $filename `
            -fileFolder $fileFolder `
            -fullPath $fullPath `
            -mode "Clean"
                    
        if ($isFileOpen) {
            Write-Verbose "In folder '$fileFolder,'"
            Write-Verbose "file '$filename' opened."
        }
    }
    catch {
        Write-Verbose "In folder '$fileFolder',"
        Write-Error "Failed to create file '$filename'. Error: $_"
    }   
}


