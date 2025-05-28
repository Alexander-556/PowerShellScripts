$frames = @(
@"
  (\_/)
 ( •_•)
/>🌼  Hello
"@,
@"
  (\_/)
 ( •_•)
/>🌸  from
"@,
@"
  (\_/)
 ( •_•)
/>🌻  PowerShell!
"@
)

foreach ($frame in $frames) {
    Clear-Host
    Write-Host $frame -ForegroundColor Cyan
    Start-Sleep -Milliseconds 600
}
