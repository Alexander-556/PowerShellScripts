function Confirm-NewNameFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$desiredLocation
    )
    
    # Skip file creation, ask for NewName
    Write-Host "File creation skipped." `
        -ForegroundColor Green
    Write-Host "If you still want to create this file, enter a different name below." `
        -ForegroundColor Green

    while ($true) {
        # Prompt user for a new filename
        $newFilename = Read-Host "Enter new filename"

        if ([string]::IsNullOrWhiteSpace($newFilename)) {
            # If empty string is received, abort action
            Write-Warning "Empty string input, new name cancelled."
            break
        }
        else {
            # If a string is received, start new name action 
            # Define hash table for input params
            $recurseParams = @{ Filename = $newFilename }
            if ($PSBoundParameters.ContainsKey("desiredLocation")) {
                $recurseParams.Location = $desiredLocation
            }
            
            # Recursively call the touch function with the new filename and location
            Set-TouchFile @recurseParams

            # After action complete, break out the loop
            break
        }                            
    }
}