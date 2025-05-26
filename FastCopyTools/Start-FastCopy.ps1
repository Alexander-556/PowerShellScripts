function Start-FastCopy {
    <#
.SYNOPSIS
    Initiates a batch copy operation using FastCopy, with per-folder transfer, 
    speed control, verification, and optional delay.

.DESCRIPTION
    This function performs controlled copying of each subfolder from a specified 
    source directory to a target directory using the external FastCopy utility.
    Features include:
    - Transfer speed configuration ("full", "autoslow", "suspend", or custom 1–9)
    - Optional file verification after transfer
    - Dry run simulation with windowed FastCopy execution
    - Optional delay between subfolder copies for thermal throttling
    - Interactive confirmation via PowerShell's ShouldProcess

.PARAMETER sourceFolderPath
    The root source directory. Each immediate subfolder will be copied individually.

.PARAMETER targetFolderPath
    The root destination directory. Each subfolder will be copied as a new folder here.

.PARAMETER strMode
    Speed mode to use. Acceptable values: full, autoslow, suspend, custom.
    When 'custom' is selected, -intSpeed must be specified.

.PARAMETER intSpeed
    Custom integer transfer speed (1–9). Only required when -strMode is 'custom'.

.PARAMETER delaySeconds
    Optional delay (in seconds) to wait between copying each subfolder.

.PARAMETER verifyDigit
    1 to enable post-copy verification (default), 0 to disable.

.PARAMETER execDigit
    1 to execute FastCopy (default), 0 to simulate using /no_exec.

.OUTPUTS
    None. Writes progress and status messages to host.

.EXAMPLE
    Start-FastCopy -SourceFolder "D:\Data" -TargetFolder "G:\Backup" `
                   -Mode "custom" -Speed 5 -Delay 60 -Verify 1 -Exec 1

.NOTES
    Author: Jialiang Chang
    Version: 1.0
    Last Updated: 2025-05-24
    Dependencies: FastCopy.exe, FastCopyTools.psd1 (with Build-FCArgs, Get-ChildFolderPath)
#>


    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High',
        PositionalBinding = $false
    )]

    param(
        [Parameter(Mandatory = $true)]
        [Alias("SourceFolder")]
        [string]$sourceFolderPath,

        [Parameter(Mandatory = $true)]
        [Alias("TargetFolder")]
        [string]$targetFolderPath,

        [Parameter(Mandatory = $false)]
        [string]$FastCopyPath,

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

    # Import helper module
    Import-Module "$PSScriptRoot\FastCopyTools.psd1" -Force

    # Define action description for WhatIf/Confirm support
    $action = "Copy data from $sourceFolderPath"
    $target = "Path: $targetFolderPath"
    $config = Get-Config

    # Apply override logic
    if ($PSBoundParameters.ContainsKey("FastCopyPath")) {
        $FCPath = $fastCopyPath
        Write-Verbose "Using override FastCopy path: $FCPath"
    }
    else {
        $FCPath = $config.fastCopyPath
        Write-Verbose "Using configured FastCopy path: $FCPath"
    }

    # Only continue if confirmed via ShouldProcess (or WhatIf not used)
    if ($PSCmdlet.ShouldProcess($target, $action)) {
        Write-Host "`nExecuting copy...`n"

        # Get immediate subfolders to copy
        $subFolders = Get-ChildFolderPath -Folder $sourceFolderPath
        $totalFolderNum = $subFolders.Count

        if (-not $subFolders -or $totalFolderNum -eq 0) {
            Write-Warning "No subfolders found to copy in $sourceFolderPath!"
            return
        }

        Write-Host "Starting FastCopy for each subfolder..."
        Write-Host "In: '$sourceFolderPath'"
        Write-Host "To: '$targetFolderPath'`n"

        # Initialize copy index for progress tracking
        $index = 0

        foreach ($folder in $subFolders) {
            $index++

            $folderName = Split-Path $folder -Leaf
            $destination = Join-Path $targetFolderPath $folderName

            # Show progress bar
            Write-Progress `
                -Activity "Copying Folders" `
                -Status "Processing $index of ${totalFolderNum}: $folderName" `
                -PercentComplete (($index / $totalFolderNum) * 100)

            Write-Host "`nCopying folder '$folderName' to '$targetFolderPath'"

            # Build FastCopy arguments
            $FCargs = Build-FCArgs `
                -buildMode $strMode `
                -buildSpeed $intSpeed `
                -buildVerifyDigi $verifyDigit `
                -buildExecDigi $execDigit `
                -buildSourcePath $folder `
                -buildTargetPath $destination

            # Display command in verbose mode
            Write-Verbose "Executing FastCopy with arguments:"
            Write-Verbose "$FCPath $($FCargs -join ' ')"

            # Execute FastCopy and wait until process completes
            Start-Process -FilePath $FCPath -ArgumentList $FCargs -Wait

            Write-Host "Folder '$folderName' copy complete."

            # Optional pause before next subfolder (except after the last)
            if ($delaySeconds -gt 0 -and $folder -ne $subFolders[-1]) {
                Write-Host "Waiting $delaySeconds seconds before next copy...`n"
                Start-Sleep -Seconds $delaySeconds
            }
        }

        Write-Host "`nCopy task complete.`n"
        exit 1
    }
}