function Get-ChildFolderPath {
    <#
.SYNOPSIS

.DESCRIPTION

.PARAMETER inputFolderPath


.EXAMPLE

.OUTPUTS

.NOTES

.LINK

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
