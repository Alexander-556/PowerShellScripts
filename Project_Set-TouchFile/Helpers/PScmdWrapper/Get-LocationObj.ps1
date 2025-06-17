function Get-LocationObj {
    [CmdletBinding()]
    
    [PSCustomObject]$desiredLocationObj = @{
        Path  = (Get-Location).Path
        Valid = $true
    }

    return $desiredLocationObj
}