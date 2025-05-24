function Start-FastCopy {
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

    if (-not (Get-Command Import-Functions -ErrorAction SilentlyContinue)) {

        # Prepare a multi-line error message for clarity and guidance
        $errMsg = @"

    [ERROR] The helper function is not ready!
    Try run: . .\Import-Function.ps1
"@
        Write-Error $errMsg                       # Emit the error and exit early
        return
    }

    # Ensure support functions are available after checking
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
            "/speed=$strSpeed",
            "`"$folder`"", # Source folder must be quoted
            "/to=`"$destination`""
        )

        Write-Host "C:\Users\shcjl\FastCopy\FastCopy.exe $FCargs"
    
        Start-Process -FilePath "C:\Users\shcjl\FastCopy\FastCopy.exe" -ArgumentList $FCargs -Wait

        # Optional pause between copies
        if ($delaySeconds -gt 0 -and $folder -ne $subFolders[-1]) {
            Write-Host "Waiting $delaySeconds seconds before next copy..."
            Start-Sleep -Seconds $delaySeconds
        }
    }
}