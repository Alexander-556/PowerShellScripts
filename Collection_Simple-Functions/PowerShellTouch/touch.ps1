function touch {
    <#
    .SYNOPSIS
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$filename
    )
    
    # Pre-Check input validity
    if (-not $filename -or $filename.Count -eq 0) {
        Write-Error "No filename provided. Please specify a filename." -ForegroundColor Red
        return
    }

    # Enable processing array input of filenames
    foreach ($file in $filename) {
        # Ensure the filename is valid under Windows rules
        if ($file -match '[<>:"/\\|?*]') {
            Write-Error "Invalid filename '$file'. It contains characters that are not allowed." -ForegroundColor Red
            return
        }

        # Ensure each filename is not null or empty
        if ([string]::IsNullOrWhiteSpace($file)) {
            Write-Error "Filename cannot be empty or whitespace." -ForegroundColor Red
            return
        }

        # Normalize the filename by removing leading and trailing whitespace
        $file = $file.Trim()

        # Construct the full path for the file to check path
        $Path = Join-Path -Path (Get-Location) -ChildPath $file



        # Custom logic to handle the filename, similar to unix touch, but different
        try {
            # If the file is not there, create new file
            if (-not (Test-Path $filename)) {
                # Create the file with the specified name

                # Catch errors in file creation
                try {
                    New-Item -ItemType File -Path $Path -ErrorAction Stop | Out-Null

                    # After successful creation, notify the user
                    Write-Host "File '$filename' created successfully." -ForegroundColor Green
                    # Prompt user to open the file or not
                    Write-Host "Do you want to open the file now? (Y/N)" -ForegroundColor Yellow

                    # Read user input
                    $response = Read-Host "Enter your response"

                    # Check if the user wants to open the file
                    if ($response -eq 'Y' -or $response -eq 'y') {
                        # Open the file in the default editor
                        try { Start-Process $filename -ErrorAction Stop }
                        catch {
                            Write-Error "Failed to open file '$filename'. Error: $_" -ForegroundColor Red
                            return
                        }
                    }
                }
                catch {
                    Write-Error "Failed to create file '$filename'. Error: $_" -ForegroundColor Red
                    return
                }   
            }
            # If the file already exists, 
            else {
                # First update file timestamp
                try {
                    # Update the file's last write time to the current time
                    (Get-Item $filename).LastWriteTime = Get-Date

                    # Notify the user of the update
                    Write-Host "File '$filename' already exists. Timestamp updated." -ForegroundColor Green
                }
                catch {
                    Write-Error "Failed to update timestamp for file '$filename'. Error: $_" -ForegroundColor Red
                    return
                }
                # Prompt user for confirmation to open the file
                Write-Host "Do you want to open '$filename'? (Y/N)" -ForegroundColor Yellow

                # Read user input
                $response = Read-Host
                if ($response -eq 'Y' -or $response -eq 'y') {
                    # Open the file in the default editor
                    try { Start-Process $filename -ErrorAction Stop }
                    catch {
                        Write-Error "Failed to open file '$filename'. Error: $_" -ForegroundColor Red
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
                        # Recursively call the touch function with the new filename
                        touch -filename $newFilename
                    }
                }
                else {
                    Write-Error "Invalid response. Please enter 'Y' or 'N'." -ForegroundColor Red
                }
            
            }

 
        }
        catch {
            
        }
    }
}