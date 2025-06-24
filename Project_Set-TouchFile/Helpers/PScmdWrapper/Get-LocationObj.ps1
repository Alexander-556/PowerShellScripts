# * PScmdWrapper
function Get-LocationObj {
    <#
    .SYNOPSIS
    Returns the current working directory wrapped in a standardized object.

    .DESCRIPTION
    The Get-LocationObj function retrieves the current working directory and returns it 
    as a custom object with two properties:
    - `Path`  : The current directory path as a string.
    - `Valid` : Always `$true`, indicating the path exists and is ready for use.

    This wrapper function provides a consistent return structure that matches 
    the output of other path resolution functions (such as Resolve-InputFolderPath), 
    making it easier to process location data uniformly within the Set-TouchFile module.

    .PARAMETER None
    This function takes no parameters.

    .INPUTS
    None. This function does not accept pipeline input.

    .OUTPUTS
    [PSCustomObject] An object with:
    - `Path`  [string] : Current working directory
    - `Valid` [bool]   : Always `$true`

    .NOTES
    Private helper function for the Set-TouchFile module.
    This function is not intended to be called directly by end users.

    Scope:         Private  
    Author:        Jialiang Chang  
    Version:       1.0.0  
    Last Updated:  2025-06-24
    #>

    [CmdletBinding()]
    
    [PSCustomObject]$desiredLocationObj = @{
        Path  = (Get-Location).Path
        Valid = $true
    }

    return $desiredLocationObj
}