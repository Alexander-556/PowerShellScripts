# * PScmdWrapper
function Resolve-InputFolderPath {
    <#    
    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.
    
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
                $childPath = $inputPath.TrimStart("\.")
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