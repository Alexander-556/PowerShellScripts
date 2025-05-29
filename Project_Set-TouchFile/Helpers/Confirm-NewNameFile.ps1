function Confirm-NewNameFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$desiredLocation
    )
    
    # Skip file creation, ask for NewName
    Write-Host "File creation skipped." `
        -ForegroundColor Green
    Write-Host "If you still want to create this file, enter a different name below:" `
        -ForegroundColor Green

    while ($true) {
        # Prompt user for a new filename
        $newFilename = Read-Host "Enter new filename"

        if ([string]::IsNullOrWhiteSpace($newFilename)) {
            Write-Warning "Empty string input, new name cancelled."
            break
        }
        else {
            $recurseParams = @{ Filename = $newFilename }
            
            if ($PSBoundParameters.ContainsKey("desiredLocation")) {
                $recurseParams.Location = $desiredLocation
            }
            
            # Recursively call the touch function with the new filename and location

            Set-TouchFile @recurseParams

            break
        }                            
    }
}