function Confirm-SFCArgs {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER sourceFolderPath
    The root source directory. Each immediate subfolder will be copied individually.

    .PARAMETER targetFolderPath
    The root destination directory. Each subfolder will be copied as a new folder here.

    .PARAMETER fastCopyPath
    Optional override of the default and configured path to FastCopy.exe executable,
    useful when using portable FastCopy.exe.

    .PARAMETER strMode
    Speed mode to use. Acceptable values: full, autoslow, suspend, custom.
    When 'custom' is selected, -intSpeed must be specified.

    .PARAMETER intSpeed
    Custom integer transfer speed (1–9). Only required when -strMode is 'custom'.

    .PARAMETER delaySeconds
    Optional delay (in seconds) to wait between copying each subfolder.

    .PARAMETER Verify
    Specifies whether to enable file verification after the copy operation. 
    When this switch is present, verification will be performed to ensure 
    the integrity of the copied files. Omit this switch to skip verification.

    .PARAMETER Exec
    Specifies whether to execute the copy operation. 
    When this switch is present, the copy operation will be performed. 
    Omit this switch to simulate the operation without actually copying files 
    (useful for testing or dry runs).

    .INPUTS
    Accepts parameters for source and target folder paths, FastCopy executable path,
    mode, speed, delay, verification, and execution flags. For details, check the 
    parameter descriptions.
        
    .OUTPUTS
    

    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$sourceFolderPath,

        [Parameter(Mandatory = $true)]
        [string]$targetFolderPath,

        [Parameter(Mandatory = $false)]
        [string]$fastCopyPath,

        [Parameter(Mandatory = $false)]
        [string]$strMode = "full", 
        
        [Parameter(Mandatory = $false)]
        [int]$intSpeed = 0, 

        [Parameter(Mandatory = $false)]
        [int]$delaySeconds = 0,

        [Parameter(Mandatory = $false)]
        [int]$verifyDigit = 1,

        [Parameter(Mandatory = $false)]
        [int]$execDigit = 1
    )

    # Normalize user input for consistent validation (case-insensitive)
    $strMode = $strMode.ToLower()

    # Validate selected mode against supported options
    $validModes = @("full", "autoslow", "suspend", "custom")
    $isModeValid = $validModes -contains $strMode

    if (-not $isModeValid) {
        Write-Error "Your mode selection '$strMode' is invalid."
        Write-Error "Please select from: $($validModes -join ', ')."
        throw
    }

    # Prevent usage of -Speed unless mode is 'custom'
    if ($strMode -ne "custom" -and $intSpeed -ne 0) {
        Write-Error "The -Speed parameter is only allowed when -Mode is 'custom'."
        throw
    }

    # Enforce -Speed validation if custom mode is selected
    if ($strMode -eq "custom") {
        if (-not $PSBoundParameters.ContainsKey("intSpeed")) {
            Write-Error "When -Mode is 'custom', the -Speed parameter is required."
            throw
        }
        if ($intSpeed -lt 1 -or $intSpeed -gt 9) {
            Write-Error "Speed value '$intSpeed' is invalid. Use an integer between 1 and 9."
            throw
        }
    }
}