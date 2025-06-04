# * QueryHelper
function Start-Rename {
    <#
    .SYNOPSIS
    Prompts the user to rename a file and validates the new filename.

    .DESCRIPTION
    The `Start-Rename` function allows the user to specify a new filename for a file during 
    a conflict resolution process. It validates the new filename using the `Confirm-Filename`
    helper function and updates the target file object with the new name if valid. The function 
    continuously prompts the user until a valid filename is provided.

    .PARAMETER targetFileObj
    A custom object representing the file to be renamed. Contains metadata such as filename 
    and destination path.

    .INPUTS
    [PSCustomObject]
    Accepts the target file object as input.

    .OUTPUTS
    [PSCustomObject]
    Returns the updated target file object with the new filename.

    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.

    #>
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