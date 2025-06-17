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
        -ForegroundColor Cyan
    Write-Host "Resolved Path '$inputPath'"

    # Loop for continuous prompting
    while ($true) {
        # Read user input
        $response = Read-Host "Enter your response"
        
        # Check if the user wants to create the folder
        if ($yesKeyWords -contains $response) {
            Write-Verbose "For path '$inputPath',"
            Write-Verbose "New folder creation in progress..."

            New-Item -Path $inputPath -ItemType Directory -Force
            Write-Verbose "New folder has been created at the specified location above."
            return $true
        }
        elseif ($nooKeyWords -contains $response) {
            Write-Verbose "For path '$inputPath',"
            
            Write-Host "New folder creation cancelled, program will terminate."
            return $false
        }
        else {
            Write-Warning "Invalid response. Please enter 'Y' or 'N'."
        }
    }
}