function Show-Triangle {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [int]$Height = 20,

        [Parameter(Mandatory = $false)]
        [string]$Char = "#",

        [Parameter(Mandatory = $false)]
        [int]$Delay = 500
    )

    for ($i = 1; $i -le $Height; $i++) {

        $line = $Char * (2 * $i - 1)
        $space = " " * ($Height - $i)

        Write-Host "$space$line"

        Write-Progress `
            -Activity "Drawing Triangle" `
            -Status "Processing Row $i of $Height" `
            -PercentComplete (($i / $Height) * 100)

        Start-Sleep -Milliseconds $Delay

    }

    Write-Progress -Completed -Activity "Drawing Triangle"

    Write-Host "Here's your triangle!" -ForegroundColor Cyan
}
