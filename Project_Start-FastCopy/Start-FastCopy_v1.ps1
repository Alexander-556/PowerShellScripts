function Start-FastCopy {
    <#
.SYNOPSIS

.DESCRIPTION

.PARAMETER sourceFolderPath

.PARAMETER targetFolderPath

.PARAMETER strSpeed

.PARAMETER delaySeconds

.OUTPUTS

.EXAMPLE

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

        [Parameter(Mandatory = $true)]
        [Alias("Speed")]
        [string]$strSpeed, 

        [Parameter(Mandatory = $false)]
        [Alias("Delay")]
        [int]$delaySeconds = 0
    )

    $action = "Copy data from $sourceFolderPath"
    $target = "Path: $targetFolderPath"
    $FCPath = "C:\Users\shcjl\FastCopy\FastCopy.exe"

    if ($PSCmdlet.ShouldProcess($target, $action)) {
        # perform the copy
        Write-Host "Executing copy..."
    
        if (-not (Get-Command Import-Functions -ErrorAction SilentlyContinue)) {

            # Prepare a multi-line error message for clarity and guidance
            $errMsg = @"

    [ERROR] The helper function is not ready!
    Try run: . .\Import-Function.ps1
"@
            # Emit the error and exit early
            Write-Error $errMsg                       
            return
        }

        # Import the functions after checking
        Write-Host "Importing helper functions..."
        Import-Functions -Folder .\functions

        # Get subfolders to copy, this is a list/array
        $subFolders = Get-ChildFolderPath -Folder $sourceFolderPath

        if (-not $subFolders -or $subFolders.Count -eq 0) {
            Write-Warning "No subfolders found to copy in $sourceFolderPath!"
            return
        }

        foreach ($folder in $subFolders) {
            $folderName = Split-Path $folder -Leaf
            $destination = Join-Path $targetFolderPath $folderName

            Write-Host "Copying '$folderName' to '$targetFolderPath'"

            Write-Host "Starting FastCopy for each subfolder..."

            $FCargs = @(
                "/cmd=diff",
                "/auto_close",
                "/open_window",
                "/estimate",
                "/verify",
                "/no_exec",
                "/speed=$strSpeed",
                "`"$folder`"", # Source folder must be quoted
                "/to=`"$destination`""
            )


            Write-Host "$FCPath $($FCargs -join ' ')"
    
            Start-Process -FilePath $FCPath -ArgumentList $FCargs -Wait

            # Optional pause between copies
            if ($delaySeconds -gt 0 -and $folder -ne $subFolders[-1]) {
                Write-Host "Waiting $delaySeconds seconds before next copy..."
                Start-Sleep -Seconds $delaySeconds
            }
        }
    }
}