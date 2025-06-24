# * PScmdWrapper
function Resolve-InputFolderPath {
    <#
    .SYNOPSIS
    Resolves a user-supplied input path and returns a standardized object describing its validity.

    .DESCRIPTION
    The Resolve-InputFolderPath function is a private helper designed to validate and resolve 
    user-provided folder paths. If the input path exists, it uses `Resolve-PathwErr`
    for accurate resolution. If the path does not exist, it attempts to interpret whether 
    the path is absolute or relative, and then manually constructs the full path string accordingly.

    This function is intended to support interactive folder creation in Set-TouchFile by 
    returning a standardized object that includes:
    - `Path`  : The resolved or interpreted folder path
    - `Valid` : A Boolean indicating whether the original path existed

    .PARAMETER inputPath
    The raw folder path provided by the user. This can be either absolute or relative. 
    The function resolves it into a full path and determines whether the original path exists.

    .INPUTS
    [string] Accepts a single string representing a folder path.

    .OUTPUTS
    [PSCustomObject] Returns an object with two properties:
    - `Path`  [string] : The resolved or interpreted full path
    - `Valid` [bool]   : Indicates whether the original path exists

    .NOTES
    Private helper function for the Set-TouchFile module.
    This function is not intended to be called directly by end users.

    Scope:         Private  
    Author:        Jialiang Chang  
    Version:       1.0.0  
    Last Updated:  2025-06-24
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$inputPath
    )

    [PSCustomObject]$desiredLocationObj = @{
        Path  = $null
        Valid = $null
    }

    # Check if input path is valid or not
    Write-Verbose "Checking input path validity..."
    if (Test-Path -Path $inputPath) {
        # If valid, then use built-in tools to resolve 
        Write-Verbose "Valid Raw Path: '$inputPath'"
        Write-Verbose "Built-in resolve in progress..."
        $desiredLocationObj.Valid = $true
        $desiredLocationObj.Path = Resolve-PathwErr -inputPath $inputPath
    }
    else {
        # If not valid, then use my manual resolution code
        Write-Verbose "Invalid Raw Path: '$inputPath'"
        Write-Verbose "Manual resolve in progress..."

        # Set the valid property to false
        $desiredLocationObj.Valid = $false
        # Write a general warning
        Write-Warning "Your raw input path '$inputPath' does not exist."

        # Now check if the input path is relative or not
        if (Split-Path -Path $inputPath -IsAbsolute) {
            Write-Verbose "Your path is absolute."

            # If the path is absolute, no need to resolve
            $desiredLocationObj.Path = $inputPath

            Write-Verbose "No need to resolve.`n"
        }
        else {
            Write-Verbose "Your path is relative."
            try {
                # If the path is relative, manually resolve
                $childPath = $inputPath.TrimStart(".")
                $scriptPath = (Get-Location).Path
                $desiredLocationObj.Path = 
                Join-Path `
                    -Path $scriptPath `
                    -ChildPath $childPath
                Write-Verbose "Manual path resolve successful.`n"
            }
            catch {
                Show-ErrorMsg `
                    -FunctionName $MyInvocation.MyCommand.Name `
                    -CustomMessage "Manual path resolve failed for '$inputPath'." `
                    -Exception $_.Exception
            }
        }
        
    }

    return $desiredLocationObj
}