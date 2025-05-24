function Start-FastCopy {
    <#
.SYNOPSIS
Initiates a controlled batch folder copy using FastCopy with verification, 
speed control, and delay between transfers.

.DESCRIPTION
This function performs a high-assurance, folder-by-folder copy from a specified source 
directory to a target directory using the external tool FastCopy. It supports optional 
throttling via speed flags, file verification, and delays between transfers to prevent 
drive overheating or saturation.

The function verifies that necessary helper functions are available before execution. 
It supports `-WhatIf` and `-Confirm` to simulate and control execution safely.

.PARAMETER sourceFolderPath
The root folder whose immediate subfolders will be copied. Each subfolder is copied 
individually to the destination path.

.PARAMETER targetFolderPath
The destination root folder where subfolders will be replicated. Each source subfolder 
will be copied as a subdirectory under this path.

.PARAMETER strSpeed
The speed mode passed to FastCopy. Acceptable values are tool-defined 
(e.g., Full, DiffHD, etc.).

.PARAMETER delaySeconds
Optional. The delay in seconds to wait between copying each subfolder. Default is 0.

.OUTPUTS
None. This function writes progress and status messages to the host. 
Copies are initiated using Start-Process.

.EXAMPLE
Start-FastCopy -SourceFolder "D:\Data" -TargetFolder "G:\Backup" -Speed "Full" -Delay 60

Initiates a backup of each subfolder from D:\Data to G:\Backup using FastCopy in Full 
speed, waiting 60 seconds between copies.

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
        [Alias("Speed")]
        [string]$strSpeed = "Full", 

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

    $action = "Copy data from $sourceFolderPath"
    $target = "Path: $targetFolderPath"
    $FCPath = "C:\Users\shcjl\FastCopy\FastCopy.exe"

    if ($PSCmdlet.ShouldProcess($target, $action)) {
        # If confirmed, perform the copy
        Write-Host "Executing copy..."
    
        # Check if dependent functions are loaded
        if (-not (Get-Command Import-Functions -ErrorAction SilentlyContinue)) {

            # If not loaded, print error message and exit
            $errMsg = @"

    [ERROR] The helper function is not ready!
    Try run: . .\Import-Function.ps1
"@
            # Emit the error and exit early
            Write-Error $errMsg                       
            return
        }

        # Import the helper functions
        Write-Host "Importing helper functions..."
        Import-Functions -Folder .\functions

        # Check if Get-ChildFolderPath is available
        if (-not (Get-Command Get-ChildFolderPath -ErrorAction SilentlyContinue)) {

            # If not loaded, print error message and exit
            $errMsg = @"

    [ERROR] The helper function import unsuccessful!
    Try check: .\Import-Function.ps1
"@
            # Emit the error and exit early
            Write-Error $errMsg                       
            return
        }

        # Retrieve subfolders to process
        $subFolders = Get-ChildFolderPath -Folder $sourceFolderPath

        $index = 0
        $totalFolderNum = $subFolders.Count

        # If the folder is empty, abort the program
        if (-not $subFolders -or $subFolders.Count -eq 0) {
            Write-Warning "No subfolders found to copy in $sourceFolderPath!"
            return
        }

        # If all ecc passed, start copy
        Write-Host "Starting FastCopy for each subfolder..."

        # Main loop for copying each subfolder
        foreach ($folder in $subFolders) {
            $index++

            # Parse folderName and destination
            $folderName = Split-Path $folder -Leaf
            $destination = Join-Path $targetFolderPath $folderName

            # User message displaying current action
            Write-Host "Copying '$folderName' to '$targetFolderPath'"

            Write-Progress `
            -Activity "Copying Folders" `
            -Status "Processing $index of ${totalFolderNum} : $folderName" `
            -PercentComplete (($index / $totalFolderNum) * 100)
            
            # Build shared arguments
            $FCargs = @(
                "/cmd=diff",
                "/auto_close",
                "/open_window",
                "/estimate",
                "/speed=$strSpeed"
            )

            # Conditionally add verification flag
            if ($verifyDigit -eq 1) {
                $FCargs += "/verify"
            }
            elseif ($verifyDigit -eq 0) {
                $FCargs += "/verify=FALSE"
            }

            # Conditionally add execution flag
            if ($execDigit -eq 0) {
                $FCargs += "/no_exec"
            }
            elseif ($execDigit -eq 1) {
                # Normal execution; no flag needed
            }

            # Add source and destination paths
            $FCargs += @(
                "`"$folder`"",
                "/to=`"$destination`""
            )
            
            # Debug message showing each command line
            Write-Verbose "Executing..."
            Write-Verbose "$FCPath $($FCargs -join ' ')"
            
            # Invoke FastCopy main program, next loop will start after current copy
            Start-Process -FilePath $FCPath -ArgumentList $FCargs -Wait

            # Optional pause between copies
            if ($delaySeconds -gt 0 -and $folder -ne $subFolders[-1]) {
                Write-Host "Waiting $delaySeconds seconds before next copy..."
                Start-Sleep -Seconds $delaySeconds
            }
        }
    }
}