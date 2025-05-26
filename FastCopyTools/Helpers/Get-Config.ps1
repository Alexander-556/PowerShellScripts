function Get-Config {

    param(
        [Parameter(Mandatory = $false)]
        [string]$ConfigPath = "$PSScriptRoot\config.json"
    )

    if (-not (Test-Path $ConfigPath)) {
        throw "Configuration file not found: $ConfigPath"
    }

    return Get-Content $ConfigPath -Raw | ConvertFrom-Json
}
