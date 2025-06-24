function Confirm-NewNameFile {
    <#
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$desiredLocation
    )
    
    # Skip file creation, ask for NewName
    Write-Host "If you still want to create this file, please enter a different name below." `
        -ForegroundColor Cyan
    Write-Host "Press Enter to skip creating this file." `
        -ForegroundColor Cyan

    while ($true) {
        # Prompt user for a new filename
        $newFilename = Read-Host "Enter new filename"

        if ([string]::IsNullOrWhiteSpace($newFilename)) {
            # If empty string is received, abort action
            Write-Host "Empty string input, new file creation cancelled." `
                -ForegroundColor DarkYellow
            break
        }
        elseif (
            -not 
            (Confirm-Filename `
                -filename $newFilename `
                -fileFolder $desiredLocation
            )
        ) {
            Write-Warning "Invalid filename, please try again."
        }
        else {
            # If a string is received, start new name action 
            # Define hash table for input params
            $recurseParams = @{ Filename = $newFilename }
            if ($PSBoundParameters.ContainsKey("desiredLocation")) {
                $recurseParams.desiredLocation = $desiredLocation
            }
            
            # Recursively call the touch function with the new filename and location
            Set-TouchFile @recurseParams

            # After action complete, break out the loop
            break
        }                            
    }
}