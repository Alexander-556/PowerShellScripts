function Confirm-FCpath {
    <#
    .SYNOPSIS

        Validates that the provided path points to a valid FastCopy executable file.

    .DESCRIPTION

        This function checks if the provided path exists, ensures that it points to a file
        (not a folder), and verifies that the file name is "FastCopy.exe". If any of these
        conditions are not met, the function throws an error with a descriptive message.

    .PARAMETER inputPath

        The full path to the FastCopy executable file that needs to be validated.

    .OUTPUTS

        None. Throws an error if the validation fails.

    .EXAMPLE

        PS> Confirm-FCpath -inputPath "C:\Tools\FastCopy\FastCopy.exe"
        Validates that the file "FastCopy.exe" exists at the specified path and is a valid 
        FastCopy executable.

    .NOTES

        This function is a helper function for the main function Start-FastCopy. For modular
        confirmation of the input FastCopy path in config file.
        
        Author: Jialiang Chang
        Version: 1.0
        Date: 2025-05-27

    .LINK

        Test-Path Documentation:
        https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/test-path?view=powershell-7.5

    .LINK

        Try-Catch-Finally Documentation:
        https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_try_catch_finally?view=powershell-7.5
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$inputPath
    )

    # Validate the FastCopyPath inside the config file
    # This function checks if the provided path is valid for FastCopy executable
    try {
        # --- Step 1: Validate that the path exists
        if (-not (Test-Path -Path $inputPath)) {
            throw "The specified FastCopy path does not exist: $inputPath"
        }

        # --- Step 2: Validate that the path leads to a file
        if (-not (Test-Path -Path $inputPath -PathType Leaf)) {
            throw "The FastCopy path is not a file (likely a folder): $inputPath"
        }

        # --- Step 3: Validate filename is correct
        $fileName = [System.IO.Path]::GetFileName($inputPath)
        if ($fileName.ToLower() -ne "fastcopy.exe") {
            throw "Invalid file name: expected 'FastCopy.exe' but got '$fileName'"
        }
    }
    catch {
        # When any error occurs, throw error and terminate the function
        throw "Invalid 'FastCopyPath': $($_.Exception.Message)"
    }
    finally {
        # This code block runs regardless of success or failure
        Write-Verbose "Validation of FastCopyPath completed."
    }
}