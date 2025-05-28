function Show-Spiner {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Alias("Folder")]
        [string]$inputFolderPath
    )

    $spinner = "|/-\"
    $files = Get-ChildItem -Path $inputFolderPath -Recurse

    Write-Host "Start Scanning"
    
    $i = 0

    foreach ($file in $files) {
        $spin = $spinner[$i % $spinner.Length]
        Write-Host "`r$spin Scanning: $($file.Name)   " -NoNewline
        Start-Sleep -Milliseconds 50
        
        $i++
    }
    Write-Host "`nScan complete."

}
