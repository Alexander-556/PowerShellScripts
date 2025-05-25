function Get-ChildFolderPath {
    <#
.SYNOPSIS
    Retrieves the full paths of all subdirectories directly under a specified folder.

.DESCRIPTION
    Get-ChildFolderPath lists the absolute paths (via the FullName property) of all
    immediate subdirectories contained within the provided root folder path. It does
    not include nested subdirectories (non-recursive).

.PARAMETER inputFolderPath
    The root directory from which immediate subfolder paths are listed. The path must
    exist and point to a valid folder. If the folder does not exist, an error message
    is displayed and the function exits.

.EXAMPLE
    Get-ChildFolderPath -Folder "C:\Users\Alex\Documents"

    Output:
    C:\Users\Alex\Documents\Photos
    C:\Users\Alex\Documents\Notes
    C:\Users\Alex\Documents\Projects

.OUTPUTS
    System.String
    A list of full path strings, one per subdirectory directly under the specified folder.

.NOTES
    Author: Alex
    Version: 0.0
    Last Updated: 2025-05-23

.LINK
    Get-ChildItem
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("Folder")]
        [string]$inputFolderPath
    )

    if (-Not (Test-Path $inputFolderPath)) {
        Write-Error "`n
        [ERROR] The specified folder '$inputFolderPath' does not exist.
        Try:
        - Check for typos in the path.
        - Make sure the folder exists on disk.
        - Ensure the script has access permissions.`n"
        return
    }

    Get-ChildItem -Path $inputFolderPath -Directory |
    Select-Object -ExpandProperty FullName
}

Export-ModuleMember -Function Get-ChildFolderPath
