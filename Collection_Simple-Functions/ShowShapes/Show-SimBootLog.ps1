$lines = @(
    "Loading modules...",
    "Initializing user profile...",
    "Applying prompt theme...",
    "Checking disk space...",
    "Mounting backup target...",
    "Ready."
)
foreach ($line in $lines) {
    Write-Host "[✔] $line"
    Start-Sleep -Milliseconds (Get-Random -Minimum 100 -Maximum 400)
}
