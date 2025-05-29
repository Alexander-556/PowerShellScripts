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
    
    if ($PSBoundParameters.ContainsKey("fullInputPath")) {
        Write-Host "Enter quick access mode." `
            -ForegroundColor Green
        $fileFolder = Split-Path -Path $fullInputPath -Parent
        $filename = Split-Path -Path $fullInputPath -Leaf
        Invoke-Touch -Filename $filename -Location $fileFolder
        return
    }

    # Pre-Check input validity
    if (-not $filenameArray -or $filenameArray.Count -eq 0) {
        Write-Error "No filename provided. Please specify a filename."
        throw
    }

    $yesKeyWords = @('Y', 'y', '')
    $nooKeyWords = @('N', 'n')

    # Enable processing array input of filenames
    foreach ($filename in $filenameArray) {
        # Ensure each filename is not null or empty
        if ([string]::IsNullOrWhiteSpace($filename)) {
            Write-Error "Filename cannot be empty or whitespace."
            continue
        }
        # Ensure each filename is valid under Windows rules
        if ($filename -match '[<>:"/\\|?*]') {
            Write-Error "Invalid filename '$filename'."
            Write-Error "It contains characters that are not allowed in Windows."
            continue
        }

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

        if (-not (Test-Path $fileFolder)) {
            Write-Error "The folder for the provided full path '$fileFolder' does not exist."
            throw
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
                    Write-Host "Do you want to open the file now? (Y/N, Enter=Yes)" `
                        -ForegroundColor Yellow

                    # Loop for continuous prompting
                    while ($true) {
                        # Read user input
                        $response = Read-Host "Enter your response"
                        # Check if the user wants to open the file
                        if ($yesKeyWords -contains $response) {                        
                            # Open the file in the default editor
                            # This try block checks error in file opening process
                            try { Start-Process $fullPath -ErrorAction Stop }
                            catch {
                                Write-Verbose "In folder '$fileFolder',"
                                Write-Warning "Failed to open file '$filename'. Error: $_"
                            }
                            break
                        }
                        elseif ($nooKeyWords -contains $response) {
                            Write-Verbose "In folder '$fileFolder',"
                            Write-Host "Open file '$filename' cancelled." `
                                -ForegroundColor Yellow
                            break
                        }
                        else {
                            Write-Warning "Invalid response. Please enter 'Y' or 'N'."
                        }
                    }
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

                # Prompt user for confirmation to open the file
                Write-Verbose "In folder '$fileFolder',"
                Write-Host "Do you want to open '$filename'? (Y/N, Enter=Yes)" `
                    -ForegroundColor Yellow

                # Loop for continuous prompting
                while ($true) {
                    # Read user input
                    $response = Read-Host "Enter your response"

                    if ($yesKeyWords -contains $response) {
                        # Open the file in the default editor
                        # This try block checks error in file opening process
                        try { Start-Process $fullPath -ErrorAction Stop }
                        catch {
                            Write-Verbose "In folder '$fileFolder',"
                            Write-Warning "Failed to open file '$filename'. Error: $_"
                        }
                        break
                    }
                    elseif ($nooKeyWords -contains $response) {
                        # Skip file creation, ask for rename
                        Write-Host "File creation skipped." `
                            -ForegroundColor Green
                        Write-Host "If you still want to create this file, enter a different name below:" `
                            -ForegroundColor Green

                        while ($true) {
                            # Prompt user for a new filename
                            $newFilename = Read-Host "Enter new filename"

                            if ([string]::IsNullOrWhiteSpace($newFilename)) {
                                Write-Warning "Empty string input, rename cancelled."
                                break
                            }
                            else {
                                # Recursively call the touch function with the new filename and location
                                if ($PSBoundParameters.ContainsKey("desiredLocation")) {
                                    Invoke-Touch -Filename $newFilename -Location $desiredLocation
                                    break
                                }
                                else {
                                    Invoke-Touch -Filename $newFilename
                                    break
                                }
                                break
                            }                            
                        }
                    }
                    else {
                        Write-Error "Invalid response. Please enter 'Y' or 'N'."
                    }
                    
                    break
                }
            }
        }
        catch {
            Write-Error "Unexpected Error: $_"
        }
    }
}