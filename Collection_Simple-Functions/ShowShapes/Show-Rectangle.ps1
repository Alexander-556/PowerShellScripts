function Show-Rectangle {
    [CmdletBinding()]
    param (
        [int]$Width = 20,
        [int]$Height = 10,
        [string]$Char = "░",
        [int]$Delay = 10  # milliseconds per character
    )

    for ($y = 0; $y -lt $Height; $y++) {

        for ($x = 0; $x -lt $Width; $x++) {

            Write-Host -NoNewline $Char
            Start-Sleep -Milliseconds $Delay
        }
        Write-Host  # go to next line
    }
}
