function Confirm-NewFileFolder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$inputPath
    )

    $yesKeyWords = @('Y', 'y', '')
    $nooKeyWords = @('N', 'n')

    # Ask user whether to create the folder
    Write-Host "Do you want to create your specified folder? (Y/N, Enter=Yes)" `
        -ForegroundColor Yellow
    Write-Host "`nPath '$inputPath'"

    # Loop for continuous prompting
    while ($true) {
        # Read user input
        $response = Read-Host "Enter your response"
        
        # Check if the user wants to open the file
        if ($yesKeyWords -contains $response) {
            
            New-Item -Path $inputPath -ItemType Directory -Force
            Write-Verbose "New folder created"
            return $true
        }
        elseif ($nooKeyWords -contains $response) {
            Write-Host "Create a new folder cancelled, program will terminate."
            return $false
        }
        else {
            Write-Warning "Invalid response. Please enter 'Y' or 'N'."
        }
    }
}