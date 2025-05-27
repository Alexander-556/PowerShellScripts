function Test-IsNullOrWhiteSpace {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [AllowNull()]
        [string]$InputString
    )

    # Check if null, empty, or whitespace
    if (-not $InputString -or $InputString.Trim() -eq "") {
        return $true
    }

    return $false
}
