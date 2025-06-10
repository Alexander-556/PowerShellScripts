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
    - Setup FastCopy executable path in a config file instead of digging inside the code

    .PARAMETER sourceFolderPath
    The root source directory. Each immediate subfolder will be copied individually.
    Alias: SourceFolder

    .PARAMETER targetFolderPath
    The root destination directory. Each subfolder will be copied as a new folder here.
    Alias: TargetFolder

    .PARAMETER fastCopyPath
    Optional override of the default and configured path to FastCopy.exe executable,
    useful when using portable FastCopy.exe.

    .PARAMETER strMode
    Speed mode to use. Acceptable values: full, autoslow, suspend, custom.
    When 'custom' is selected, -intSpeed must be specified.
    Alias: Mode

    .PARAMETER intSpeed
    Custom integer transfer speed (1–9). Only required when -strMode is 'custom'.
    Alias: Speed

    .PARAMETER delaySeconds
    Optional delay (in seconds) to wait between copying each subfolder.
    Alias: Delay

    .PARAMETER verifyDigit
    1 to enable post-copy verification (default), 0 to disable.
    Alias: Verify

    .PARAMETER execDigit
    1 to execute FastCopy (default), 0 to simulate using /no_exec.
    Alias: Exec

    .INPUTS
    Accepts parameters for source and target folder paths, FastCopy executable path,
    mode, speed, delay, verification, and execution flags. For details, check the 
    parameter descriptions.
        
    .OUTPUTS
    None. Writes progress and status messages to host.

    .EXAMPLE
    Start-FastCopy -SourceFolder "D:\Data" -TargetFolder "G:\Backup" `
        -Mode "custom" -Speed 5 -Delay 60 -Verify 1 -Exec 1

    .NOTES
    This function is the main function for the FastCopyTools module.
    Users should dot source this script to load the module and its dependencies.

    Author: Jialiang Chang
    Version: 1.0
    Date: 2025-05-27

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

    Confirm-SFCArgs `
        -sourceFolderPath $sourceFolderPath `
        -targetFolderPath $targetFolderPath `
        -fastCopyPath $fastCopyPath `
        -strMode $strMode `
        -intSpeed $intSpeed `
        -delaySeconds $delaySeconds `
        -verifyDigit $verifyDigit `
        -execDigit $execDigit

    # Define action description for WhatIf/Confirm support
    $action = "Copy data from $sourceFolderPath"
    $target = "Path: $targetFolderPath"
    $config = Get-Config

    # Apply override logic
    if ($PSBoundParameters.ContainsKey("fastCopyPath")) {
        Confirm-FCpath -inputPath $fastCopyPath
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
    }
}