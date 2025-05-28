function Build-PowerShellBannerSlanted {
    [CmdletBinding()]
    param (
        [int]$Delay = 2  # Milliseconds delay per character
    )

    $banner = @'
    ____                          _____ __         ____
   / __ \____ _      _____  _____/ ___// /_  ___  / / /
  / /_/ / __ \ | /| / / _ \/ ___/\__ \/ __ \/ _ \/ / / 
 / ____/ /_/ / |/ |/ /  __/ /   ___/ / / / /  __/ / /  
/_/    \____/|__/|__/\___/_/   /____/_/ /_/\___/_/_/   
'@ -split "`n"

    Write-Host

    foreach ($line in $banner) {
        foreach ($char in $line.ToCharArray()) {
            Write-Host -NoNewline $char
            Start-Sleep -Milliseconds $Delay
        }
        Write-Host  # Move to next line
    }

    Write-Host
}
