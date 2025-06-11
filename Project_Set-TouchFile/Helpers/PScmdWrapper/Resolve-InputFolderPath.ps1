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
    if (Test-Path -Path $inputPath) {
        # If valid, then use built-in tools to resolve
        try {
            $desiredLocationObj.Valid = $true
            $desiredLocationObj.Path = Resolve-PathwErr -inputPath $inputPath  
        }
        catch {
            Write-Error "Error in Resolve-Path operation for '$inputPath'. Error: $_"
            throw
        }
    }
    else {
        $desiredLocationObj.Valid = $false

        if (Split-Path -Path $inputPath -IsAbsolute) {
            # If the path is absolute, no need to resolve
            $desiredLocationObj.Path = $inputPath
        }
        else {
            # If the path is relative, manually resolve\
            $childPath = $inputPath.TrimStart("\.")

            $scriptPath = (Get-Location).Path

            $desiredLocationObj.Path = Join-Path `
                -Path $scriptPath -ChildPath $childPath
        }
    }

    return $desiredLocationObj
}