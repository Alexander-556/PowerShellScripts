function Get-ChildFolderPath {
    <#
    .SYNOPSIS
    Returns the full paths of all immediate one level subfolders under a given folder.

    .DESCRIPTION
    This function lists the full directory paths (FullName property) of all 
    subfolders located directly inside the specified folder. It does not recurse 
    into nested directories.

    .PARAMETER inputFolderPath
    This is the root folder whose subdirectories you want to list. This must be an 
    existing path, otherwise an error will be thrown.

    .EXAMPLE
    Get-ChildFolderPath -Folder "C:\Users\Alex\Documents"

    Returns the full paths of all immediate subfolders in the Documents directory.

    .NOTES
    Author: Alex
    Version: 0.0
    Last Updated: 2025-05-23
    #>

    param (
        [Parameter(Mandatory = $true)]
        [Alias("Folder")]
        [string]$inputFolderPath
    )

    if (-Not (Test-Path $inputFolderPath)) {
        $errMsg = @"
        
    [ERROR] The specified folder '$inputFolderPath' does not exist.
    
    Try:
    - Check for typos in the path.
    - Make sure the folder exists on disk.
    - Ensure the script has access permissions.
"@
        Write-Error $errMsg
        return
    }

    Get-ChildItem -Path $inputFolderPath -Directory |
    Select-Object -ExpandProperty FullName
}