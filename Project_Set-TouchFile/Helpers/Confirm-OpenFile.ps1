function Confirm-OpenFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$filename,

        [Parameter(Mandatory = $true)]
        [string]$fileFolder,

        [Parameter(Mandatory = $true)]
        [string]$fullPath,

        [Parameter(Mandatory = $true)]
        [string]$mode
    )

    $validModes = @('Clean', 'NewName')
    if (-not ($validModes -contains $mode)) {
        Write-Error "Query mode selection error, check code."
        throw
    }

    $yesKeyWords = @('Y', 'y', '')
    $nooKeyWords = @('N', 'n')


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
            try { 
                Start-Process $fullPath -ErrorAction Stop 
                return $true
            }
            catch {
                Write-Verbose "In folder '$fileFolder',"
                Write-Warning "Failed to open file '$filename'. Error: $_"
                return $false
            }
        }
        elseif ($nooKeyWords -contains $response) {
            Write-Verbose "In folder '$fileFolder',"
            Write-Host "Open file '$filename' cancelled." `
                -ForegroundColor Yellow

            if ($mode -eq "NewName") {
                Write-Verbose "Start NewName query..."
                Confirm-NewNameFile -desiredLocation $fileFolder
            }

            return $false
        }
        else {
            Write-Warning "Invalid response. Please enter 'Y' or 'N'."
        }
    }
}