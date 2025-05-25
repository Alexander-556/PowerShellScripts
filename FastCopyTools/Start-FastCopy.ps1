function Start-FastCopy {
    <#
.SYNOPSIS
    Initiates a controlled batch folder copy using FastCopy with verification, 
    speed control, and optional delay between transfers.

.DESCRIPTION
    This function performs a folder-by-folder copy from a specified source 
    directory to a target directory using the external FastCopy utility. It supports:
    - Adjustable speed modes (full, autoslow, suspend, or custom integer speeds)
    - Optional post-copy verification
    - Optional execution simulation (dry run)
    - Delays between folder transfers to throttle the copying speed

    This function checks for required helper functions before running and supports
    PowerShell's -WhatIf and -Confirm for safe simulation.

.PARAMETER sourceFolderPath
    The root folder whose immediate subfolders will be copied individually to the destination.

.PARAMETER targetFolderPath
    The target directory where each source subfolder will be copied as a separate subdirectory.

.PARAMETER strMode
    The copy speed mode to use. Valid values: full, autoslow, suspend, or custom.
    If "custom" is selected, -Speed becomes mandatory.

.PARAMETER intSpeed
    The numeric speed value (1–9) used only when -Mode is "custom".

.PARAMETER delaySeconds
    Optional delay in seconds between each folder copy. Useful for cooling drives in
    between transfers of single subfolders.

.PARAMETER verifyDigit
    Set to 1 to enable verification (default), 0 to skip it.

.PARAMETER execDigit
    Set to 1 to perform actual execution (default), 0 to simulate only. 
    When simulating, FastCopy windows will be created for each subfolder transfer. 

.OUTPUTS
    None. Writes progress, warnings, and status messages to the host.

.EXAMPLE
    Start-FastCopy -SourceFolder "D:\Data" -TargetFolder "G:\Backup" -Mode "custom" -Speed 5 -Delay 60 -Verify 1 -Exec 1

    This copies each subfolder from D:\Data to G:\Backup using FastCopy at speed 5,
    verifying each transfer and waiting 60 seconds between folders.

.NOTES
    Author: Jialiang Chang
    Version: 1.0
    Last Updated: 2025-05-24
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

    # Normalize mode input for consistent validation
    $strMode = $strMode.ToLower()

    # Validate that selected mode is in allowed list
    $validModes = @("full", "autoslow", "suspend", "custom")
    $isModeValid = $validModes -contains $strMode

    # Exit if mode is not valid
    if (-not $isModeValid) {
        Write-Error "Your mode selection '$strMode' is invalid."
        Write-Error "Please select from {$($validModes -join ', ')}."
        return
    }

    # Prevent use of -Speed if mode is not custom
    if ($strMode -ne "custom" -and $PSBoundParameters.ContainsKey("intSpeed")) {
        Write-Error "The -Speed parameter is only allowed when -Mode is 'custom'."
        return
    }

    # Enforce speed validation when mode is 'custom'
    if ($strMode -eq "custom") {
        # Enforce -Speed in custom mode
        if (-not $PSBoundParameters.ContainsKey("intSpeed")) {
            Write-Error "When -Mode is 'custom', the -Speed parameter is required."
            Write-Error "Please select an integer between 1 and 9."
            return
        }

        # Enforce integer range for speed integer
        if ($intSpeed -lt 1 -or $intSpeed -gt 9) {
            Write-Error "Your speed selection '$intSpeed' is invalid."
            Write-Error "Please select an integer between 1 and 9."
            return
        }
    }

    # Validate verifyDigit
    if ($verifyDigit -ne 0 -and $verifyDigit -ne 1) {
        Write-Error "Ambiguous verify instructions: use 0 (off) or 1 (on)."
        return
    }

    # Validate execDigit
    if ($execDigit -ne 0 -and $execDigit -ne 1) {
        Write-Error "Ambiguous execution instructions: use 0 (simulate) or 1 (execute)."
        return
    }

    # Import the FastCopyTools module
    Import-Module "$PSScriptRoot\FastCopyTools.psd1" -Force

    # Program Starts

    ## Alias for confirmation
    $action = "Copy data from $sourceFolderPath"
    $target = "Path: $targetFolderPath"

    ## Fixed FastCopy path, adjustable
    $FCPath = "C:\Users\shcjl\FastCopy\FastCopy.exe"

    ## Confirmation and simulate condition
    if ($PSCmdlet.ShouldProcess($target, $action)) {
        # If confirmed, perform the copy
        Write-Host "`nExecuting copy...`n"

        ## Retrieve subfolders to process
        $subFolders = Get-ChildFolderPath -Folder $sourceFolderPath
        $totalFolderNum = $subFolders.Count
        
        ## If the folder is empty, abort the program
        if (-not $subFolders -or $totalFolderNum -eq 0) {
            Write-Warning "No subfolders found to copy in $sourceFolderPath!"
            return
        }

        ## If all ecc passed, start copy
        Write-Host "Starting FastCopy for each subfolder..."
        Write-Host "In: '$sourceFolderPath'"
        Write-Host "To: '$targetFolderPath'`n"


        ## Main loop for copying each subfolder

        ### Create index for progress bar
        $index = 0
        ### Loop starts
        foreach ($folder in $subFolders) {
            # Bump the index
            $index++

            # Parse folderName and destination
            $folderName = Split-Path $folder -Leaf
            $destination = Join-Path $targetFolderPath $folderName

            # Progress bar implementation
            Write-Progress `
                -Activity "Copying Folders" `
                -Status "Processing $index of ${totalFolderNum}: $folderName" `
                -PercentComplete (($index / $totalFolderNum) * 100)

            Write-Host "`nCopying folder '$folderName' to '$targetFolderPath'"
            
            # Build shared arguments
            $FCargs = Build-FCArgs `
                -buildMode $strMode `
                -buildSpeed $intSpeed `
                -buildVerifyDigi $verifyDigit `
                -buildExecDigi $execDigit `
                -buildSourcePath $folder `
                -buildTargetPath $destination
            
            # Debug message showing each command line
            Write-Verbose "Executing..."
            Write-Verbose "$FCPath $($FCargs -join ' ')"
            
            # Invoke FastCopy main program, next loop will start after current copy
            Start-Process -FilePath $FCPath -ArgumentList $FCargs -Wait

            Write-Host "Folder $folderName copy complete."

            # Optional pause between copies
            if ($delaySeconds -gt 0 -and $folder -ne $subFolders[-1]) {
                Write-Host "Waiting $delaySeconds seconds before next copy...`n"
                Start-Sleep -Seconds $delaySeconds
            }
        }
    }
}