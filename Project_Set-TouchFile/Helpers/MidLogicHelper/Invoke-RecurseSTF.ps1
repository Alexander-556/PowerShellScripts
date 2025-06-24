# * MidLogicHelper
function Invoke-RecurseSTF {
    <#
    .SYNOPSIS
    Helper function for internal recursive dispatch within Set-TouchFile.

    .DESCRIPTION
    The Invoke-RecurseSTF function is an internal utility used by Set-TouchFile 
    to support full-path mode. It parses the full input path into its directory 
    and filename components using Split-FilePath, then recursively calls 
    Set-TouchFile with these parts.

    This function is **not intended for direct use** by end users.

    .PARAMETER fullInputPath
    The full absolute path to a file (including filename). 
    This will be split into directory and filename for recursive re-entry into Set-TouchFile.

    .INPUTS
    [string] The function accepts a single string as input.

    .OUTPUTS
    None. Calls Set-TouchFile internally.

    .NOTES
    Private helper function for the Set-TouchFile module.
    Not exposed publicly and should only be used internally.

    Scope:         Private
    Author:        Jialiang Chang
    Version:       1.0.0
    Last Updated:  2025-06-24
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$fullInputPath
    )

    # Step 1: Parse the input path into parent and leaf
    #         store the result in a path obj
    $fullInputPathObj = 
    Split-FilePath -inputPath $fullInputPath

    # Step 2: Feed them back into Set-TouchFile, recurse
    Set-TouchFile `
        -Filename $fullInputPathObj.Filename `
        -desiredLocation $fullInputPathObj.FileFolder

    # Step 3: after recurse call, program ends
}