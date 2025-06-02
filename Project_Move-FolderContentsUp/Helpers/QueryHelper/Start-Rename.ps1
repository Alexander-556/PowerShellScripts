function Start-Rename {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [PSCustomObject]$targetFileObj
    )

    while ($true) {
        # Prompt user for a new filename
        $newFilename = Read-Host "Enter new filename"

        $isFilenameValid = Confirm-Filename `
            -filename $newFilename `
            -fileFolder $targetFileObj.Destination

        If ($isFilenameValid) {
            $targetFileObj.Filename = $newFilename
            return $targetFileObj
        }
        else {
            Write-Error "Invalid filename: '$newFilename'. Please enter a new name below..."
        }                            
    }
}