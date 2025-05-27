function Test-IsNullOrWhiteSpace {
    <#
.SYNOPSIS
    Checks if a string is null, empty, or consists only of whitespace characters.

.DESCRIPTION
    The `Test-IsNullOrWhiteSpace` function evaluates the provided string and determines 
    whether it is null, an empty string, or contains only whitespace characters. 
    It returns `$true` if any of these conditions are met, otherwise `$false`.

.PARAMETER InputString
    The string to be evaluated. This parameter is mandatory and can accept null values.

.OUTPUTS
    [Boolean]
    Returns `$true` if the input string is null, empty, or whitespace; otherwise, `$false`.

.EXAMPLE
    PS> Test-IsNullOrWhiteSpace -InputString $null
    True

    PS> Test-IsNullOrWhiteSpace -InputString ""
    True

    PS> Test-IsNullOrWhiteSpace -InputString "   "
    True

    PS> Test-IsNullOrWhiteSpace -InputString "Hello"
    False

.NOTES
    Author: Jialiang Chang
    Version: 1.0
    Date: 2025-05-27
#>

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
