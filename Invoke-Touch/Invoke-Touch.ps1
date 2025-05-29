function Invoke-Touch {
    <#
    .SYNOPSIS
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$filenameArray,

        [Parameter(Mandatory = $false)]
        [Alias("Location")]
        [string]$desiredLocation
    )
    
    # Pre-Check input validity
    if (-not $filenameArray -or $filenameArray.Count -eq 0) {
        Write-Error "No filename provided. Please specify a filename."
        return
    }

    # Enable processing array input of filenames
    foreach ($filename in $filenameArray) {
        # Ensure each filename is not null or empty
        if ([string]::IsNullOrWhiteSpace($filename)) {
            Write-Error "Filename cannot be empty or whitespace."
            return
        }

        # Ensure the filename is valid under Windows rules
        if ($filename -match '[<>:"/\\|?*]') {
            Write-Error "Invalid filename '$filename'. It contains characters that are not allowed."
            return
        }

        # Normalize the filename by removing leading and trailing whitespace
        $filename = $filename.Trim()

        # Construct the full path for the file to check path
        if ($PSBoundParameters.ContainsKey("desiredLocation")) {
            
            # Check if input path is valid
            if (-not (Test-Path($desiredLocation))) {
                Write-Error "The path provided '$desiredLocation' does not exist"
                return
            }
            
            # If selected a desired path, use this path
            $fileFolder = $desiredLocation
            $fullPath = Join-Path -Path "$desiredLocation" -ChildPath $filename
        }
        else {
            $fileFolder = Get-Location
            $fullPath = Join-Path -Path (Get-Location) -ChildPath $filename
        }

        # Custom logic to handle the filename, similar to unix touch, but different
        try {
            # If the file is not there, create new file
            if (-not (Test-Path $fullPath)) {
                # Create the file with the specified name
                try {
                    New-Item -ItemType File -Path $fullPath -ErrorAction Stop | Out-Null

                    # After successful creation, notify the user
                    Write-Host "In folder '$fileFolder', file '$filename' created successfully." -ForegroundColor Green
                    # Prompt user to open the file or not
                    Write-Host "Do you want to open the file now? (Y/N)" -ForegroundColor Yellow

                    # Read user input
                    $response = Read-Host "Enter your response: "

                    # Check if the user wants to open the file
                    if ($response -eq 'Y' -or $response -eq 'y') {
                        # Open the file in the default editor
                        try { Start-Process $fullPath -ErrorAction Stop }
                        catch {
                            Write-Error "In folder '$fileFolder', failed to open file '$filename'. Error: $_"
                            return
                        }
                    }
                }
                catch {
                    Write-Error "In folder '$fileFolder', failed to create file '$filename'. Error: $_"
                    return
                }   
            }
            # If the file already exists, 
            else {
                # First update file timestamp
                try {
                    # Update the file's last write time to the current time
                    (Get-Item $fullPath).LastWriteTime = Get-Date

                    # Notify the user of the update
                    Write-Host "In folder '$fileFolder', file '$filename' already exists. Updating its timestamp." -ForegroundColor Green
                }
                catch {
                    Write-Error "In folder '$fileFolder', failed to update timestamp for file '$filename'. Error: $_"
                    return
                }
                # Prompt user for confirmation to open the file
                Write-Host "In folder '$fileFolder', do you want to open '$filename'? (Y/N)" -ForegroundColor Yellow

                # Read user input
                $response = Read-Host "Enter your response: "
                if ($response -eq 'Y' -or $response -eq 'y') {
                    # Open the file in the default editor
                    try { Start-Process $fullPath -ErrorAction Stop }
                    catch {
                        Write-Error "In folder '$fileFolder', failed to open file '$filename'. Error: $_"
                        return
                    }
                }
                elseif ($response -eq 'N' -or $response -eq 'n') {
                    # Skip file creation, ask for rename
                    Write-Host "File creation skipped." -ForegroundColor Green
                    Write-Host "If you still want to create this file, enter a different name below:" -ForegroundColor Green

                    # Prompt user for a new filename
                    $newFilename = Read-Host "Enter new filename"

                    if ($newFilename) {
                        # Recursively call the touch function with the new filename and location
                        if ($PSBoundParameters.ContainsKey("desiredLocation")) {
                            Invoke-Touch -filenameArray $newFilename -desiredLocation $desiredLocation
                        }
                        else {
                            Invoke-Touch -filenameArray $newFilename
                        }
                    }
                }
                else {
                    Write-Error "Invalid response. Please enter 'Y' or 'N'."
                }
            
            }

 
        }
        catch {
            Write-Error "Unexpected Error: $_"
            throw
        }
    }
}