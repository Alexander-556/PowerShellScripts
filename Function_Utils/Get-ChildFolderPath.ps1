function Get-ChildFolderPath {
    <#
.SYNOPSIS
Returns the full paths of all immediate one level subfolders under a given folder.

.DESCRIPTION
This function lists the full directory paths (FullName property) of all 
subfolders located directly inside the specified folder. It does not recurse 
into nested directories. The returned paths are plain, unquoted strings. 
If used in command-line contexts or passed to external tools, users are 
responsible for adding quotes where necessary (e.g., if paths contain spaces).

Typical use cases include:
- Preparing folders for automated backup
- Iterating through project folders for deployment

.PARAMETER inputFolderPath
This is the root folder whose subdirectories you want to list. This must be an 
existing path, otherwise an error will be thrown.

.OUTPUTS
System.String
Returns one or more unquoted folder path strings (full paths).

.EXAMPLE
> Get-ChildFolderPath -Folder "C:\Users\shcjl\Downloads"

Returns the full paths of all immediate subfolders in the Downloads directory:
C:\Users\shcjl\Downloads\Music
C:\Users\shcjl\Downloads\Documents
C:\Users\shcjl\Downloads\Compressed
...

Typical use case:
Use this to list all immediate subdirectories in your Documents folder when preparing 
for batch operations like backup, archiving, or syncing.

.NOTES
Author: Jialiang Chang
Version: 1.0
Last Updated: 2025-05-24
#>

    param (
        [Parameter(Mandatory = $true)]
        [Alias("Folder")]
        [string]$inputFolderPath
    )

    # Validate input path; throw error if folder doesn't exist
    if (-Not (Test-Path $inputFolderPath)) {
        $errMsg = 
        @"  

    [ERROR] The specified folder '$inputFolderPath' does not exist.
    Please try:
    - Check for typos in the path.
    - Make sure the folder exists on disk.
    - Ensure the script has access permissions.
"@
        Write-Error $errMsg
        return
    }

    # Get immediate subfolders and return their full paths without quotes
    Get-ChildItem -Path $inputFolderPath -Directory |
    Select-Object -ExpandProperty FullName
}