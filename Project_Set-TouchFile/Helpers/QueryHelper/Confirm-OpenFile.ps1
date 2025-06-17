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
        throw "Query mode selection error, check code."
    }

    $yesKeyWords = @('Y', 'y', '')
    $nooKeyWords = @('N', 'n')

    # Prompt user to open the file or not
    Write-Host "Do you want to open the file now? (Y/N, Enter=Yes)" `
        -ForegroundColor Cyan

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
                Write-Warning "In folder '$fileFolder',"
                Write-Warning "failed to open file '$filename'."
                return $false
            }
        }
        elseif ($nooKeyWords -contains $response) {
            Write-Verbose "In folder '$fileFolder',"
            Write-Host "Open file '$filename' cancelled." `
                -ForegroundColor DarkYellow

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