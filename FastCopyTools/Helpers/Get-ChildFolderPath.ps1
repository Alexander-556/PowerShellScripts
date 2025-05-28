function Get-ChildFolderPath {
    <#
    .SYNOPSIS

        Returns the full paths of all immediate subfolders within a specified directory.

    .DESCRIPTION

        This function checks if a given folder path exists. If valid, it retrieves the
        full path of each immediate child directory inside the specified folder. 
        It outputs only directory paths.

    .PARAMETER inputFolderPath

        The full path to the parent folder whose immediate subdirectories are to be listed.

        Alias: Folder

    .EXAMPLE

        PS> Get-ChildFolderPath -inputFolderPath "C:\Projects"

        Output:
        C:\Projects\Alpha
        C:\Projects\Beta

    .OUTPUTS

        [string[]]
        Full paths of all immediate subdirectories.

    .NOTES

        This function is a helper function for the main function Start-FastCopy, allowing
        modular retrieval of child folder paths.

        Author: Jialiang Chang
        Version: 1.0
        Date: 2025-05-27

    .LINK

        Test-Path Documentation:
        https://docs.microsoft.com/powershell/module/microsoft.powershell.management/test-path

    .LINK

        Get-ChildItem Documentation:
        https://docs.microsoft.com/powershell/module/microsoft.powershell.management/get-childitem
        
    .LINK
    
        Select-Object Documentation:
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/select-object
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("Folder")]
        [string]$inputFolderPath
    )

    # Check if the specified folder path exists
    if (-not (Test-Path $inputFolderPath)) {
        Write-Error -Message (
            "[ERROR] The specified folder '$inputFolderPath' does not exist. " +
            "Check for typos, ensure the folder exists, and verify access permissions."
        )
        return
    }

    # Get immediate child folders and return their full paths
    Get-ChildItem -Path $inputFolderPath -Directory |
    Select-Object -ExpandProperty FullName
}
