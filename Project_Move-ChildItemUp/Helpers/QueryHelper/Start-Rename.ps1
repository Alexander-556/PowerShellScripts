# * QueryHelper
function Start-Rename {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [PSCustomObject]$targetFileObj
    )

    while ($true) {
        # Prompt user for a new filename
        $newFilename = Read-Host "Enter new filename"

        # Reuse old ValidationHelpers
        # actually don't need the -fileFolder option, but it's good to have
        $isFilenameValid = Confirm-Filename `
            -filename $newFilename `
            -fileFolder $targetFileObj.Destination

        If ($isFilenameValid) {
            # If filename is valid, then update the target filename
            $targetFileObj.Filename = $newFilename
            return $targetFileObj
        }
        else {
            # If filename not valid, repeat query...
            Write-Error "Invalid filename: '$newFilename'. Please enter a new name below..."
        }                            
    }
}