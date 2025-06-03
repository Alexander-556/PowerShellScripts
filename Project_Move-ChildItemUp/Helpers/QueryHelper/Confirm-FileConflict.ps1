function Confirm-FileConflict {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [PSCustomObject]$targetFileObj,
        [Parameter(Mandatory = $true, Position = 1)]
        [PSCustomObject]$folderObj
    )

    $skipKeyWords = @('S', 's', '')
    $renameKeyWords = @('R', 'r')
    # $overwriteKeyWords = @('O', 'o')

    Write-Warning "Action needed:"
    Write-Warning "To skip this file, type 'S' or 's' or 'Enter'."
    Write-Warning "To rename this file, type 'R' or 'r'."

    # Loop for continuous prompting
    while ($true) {
        # Read user input
        $response = Read-Host "Enter your response"
        
        if ($skipKeyWords -contains $response) {                        
            Write-Host "File '$($targetFileObj.Filename)' will be skipped."
            return "skip"
        }
        elseif ($renameKeyWords -contains $response) {
            Write-Host "File '$($targetFileObj.Filename)' in '$($folderObj.Name)' will be renamed."
            return "rename"
        }
        else {
            Write-Warning "Invalid response. Please follow the instructions:"
            Write-Warning "To skip this file, type 'S' or 's' or 'Enter'."
            Write-Warning "To rename this file, type 'R' or 'r'."
        }
    }
}