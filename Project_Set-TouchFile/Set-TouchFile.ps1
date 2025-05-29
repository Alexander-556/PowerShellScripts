function Set-TouchFile {
    <#
    .SYNOPSIS
    #>
    
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'ByName')]
        [Alias("Filename")]
        [string[]]$filenameArray,

        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'ByName')]
        [Alias("Location")]
        [string]$desiredLocation,

        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'ByFullPath')]
        [Alias("FullPath")]
        [string]$fullInputPath
    )

    Import-Module "$PSscriptRoot\SetTouchFileTools.psd1" -Force
    
    if ($PSBoundParameters.ContainsKey("fullInputPath")) {
        # In quick access mode, recurse call Set-TouchFile
        Write-Host "Enter quick access mode." `
            -ForegroundColor Green
        
        # Set folder and filenames
        $fileFolder = Split-Path -Path $fullInputPath -Parent
        $filename = Split-Path -Path $fullInputPath -Leaf

        # Recurse
        Set-TouchFile -Filename $filename -Location $fileFolder
        return
    }
    else {
        # In normal mode, check validity
        Confirm-FilenameArray -filenameArray $filenameArray
        Confirm-DesiredFolder -desiredLocation $desiredLocation
    }

    # Enable processing array input of filenames
    foreach ($filename in $filenameArray) {

        # Normalize the filename by removing leading and trailing whitespace
        $filename = $filename.Trim()

        # Construct the full path for the file to check path
        if ($PSBoundParameters.ContainsKey("desiredLocation")) {                 
            # If selected a desired path, use this path
            $fileFolder = $desiredLocation
            $fullPath = Join-Path -Path $desiredLocation -ChildPath $filename
        }
        else {
            $fileFolder = Get-Location
            $fullPath = Join-Path -Path (Get-Location) -ChildPath $filename
        }

        $isValidFilename = Confirm-Filename `
            -filename $filename `
            -fileFolder $fileFolder
        
        if (-not $isValidFilename) {
            Write-Verbose "In folder '$fileFolder',"
            Write-Warning "file '$filename' is invalid and will be skipped."
            continue
        }

        # Custom logic to handle the filename, similar to unix touch, but different
        # This try block handles unexpected errors
        try {
            # If the file is not there, create new file
            if (-not (Test-Path $fullPath)) {
                # This try block handles file creation errors
                try {
                    # Create the file with the specified name
                    New-Item -ItemType File -Path $fullPath -ErrorAction Stop | Out-Null

                    # Notify user for file creation
                    Write-Verbose "In folder '$fileFolder',"
                    Write-Host "file '$filename' created successfully." `
                        -ForegroundColor Green
                    
                    # Prompt user to open the file or not
                    Confirm-OpenFile `
                        -filename $filename `
                        -fileFolder $fileFolder `
                        -fullPath $fullPath `
                        -mode "Clean"
                }
                catch {
                    Write-Verbose "In folder '$fileFolder',"
                    Write-Error "Failed to create file '$filename'. Error: $_"
                }   
            }
            # If the file already exists, 
            else {
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

                Confirm-OpenFile `
                    -filename $filename `
                    -fileFolder $fileFolder `
                    -mode "NewName"
            }
        }
        catch {
            Write-Error "Unexpected Error: $_"
        }
    }
}