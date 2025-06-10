function Confirm-SFCArgs {
    
        [CmdletBinding()]

    param(
        [Parameter(Mandatory = $true)]
        [Alias("SourceFolder")]
        [string]$sourceFolderPath,

        [Parameter(Mandatory = $true)]
        [Alias("TargetFolder")]
        [string]$targetFolderPath,

        [Parameter(Mandatory = $false)]
        [string]$fastCopyPath,

        [Parameter(Mandatory = $false)]
        [Alias("Mode")]
        [string]$strMode = "full", 
        
        [Parameter(Mandatory = $false)]
        [Alias("Speed")]
        [int]$intSpeed, 

        [Parameter(Mandatory = $false)]
        [Alias("Delay")]
        [int]$delaySeconds = 0,

        [Parameter(Mandatory = $false)]
        [Alias("Verify")]
        [int]$verifyDigit = 1,

        [Parameter(Mandatory = $false)]
        [Alias("Exec")]
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
        return
    }

    # Prevent usage of -Speed unless mode is 'custom'
    if ($strMode -ne "custom" -and $PSBoundParameters.ContainsKey("intSpeed")) {
        Write-Error "The -Speed parameter is only allowed when -Mode is 'custom'."
        return
    }

    # Enforce -Speed validation if custom mode is selected
    if ($strMode -eq "custom") {
        if (-not $PSBoundParameters.ContainsKey("intSpeed")) {
            Write-Error "When -Mode is 'custom', the -Speed parameter is required."
            return
        }
        if ($intSpeed -lt 1 -or $intSpeed -gt 9) {
            Write-Error "Speed value '$intSpeed' is invalid. Use an integer between 1 and 9."
            return
        }
    }

    # Validate verification flag
    if ($verifyDigit -ne 0 -and $verifyDigit -ne 1) {
        Write-Error "Invalid verification option: use 1 (enable) or 0 (disable)."
        return
    }

    # Validate execution flag
    if ($execDigit -ne 0 -and $execDigit -ne 1) {
        Write-Error "Invalid execution option: use 1 (run) or 0 (simulate)."
        return
    }


}