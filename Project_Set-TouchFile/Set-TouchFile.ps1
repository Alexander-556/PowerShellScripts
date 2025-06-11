# * Main
function Set-TouchFile {
    <#
    .SYNOPSIS
    #>
    
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'ByName', ValueFromPipeline = $true)]
        [Alias("Filename")]
        [string]$filename,

        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'ByName')]
        [Alias("Location")]
        [string]$desiredLocation,

        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'ByFullPath')]
        [Alias("FullPath")]
        [string]$fullInputPath
    )

    # Before accepting pipeline input, initialize an array to collect filenames
    begin {
        $filenameArray = New-Object System.Collections.Generic.List[string]
    }

    # Process the pipeline input
    process {
        $filenameArray.Add($filename)
    }

    # After collecting all pipeline input, process the array
    end {
        try {
            # Touch mode selection
            if ($PSBoundParameters.ContainsKey("fullInputPath")) {
                # If quick access mode selected

                # Step 1: parse the input path into parent and leaf
                #         store the result in a path obj
                $fullInputPathObj = Split-FilePath `
                    -inputPath $fullInputPath

                # Step 2: feed them back into Set-TouchFile, recurse
                Set-TouchFile `
                    -Filename $fullInputPathObj.FileFolder`
                    -Location $fullInputPathObj.Filename
                    
                # Step 3: after recurse call, program ends
                return
            }
            else {
                # If normal mode selected

                # check validity of 
                # input filename array, this should remain the same
                Confirm-FilenameArray `
                    -filenameArray $filenameArray

                

                # desiredLocation
                Confirm-DesiredFolder `
                    -desiredLocation $desiredLocation

                # query on d


                
            } 
        }
        catch {
            # Improved error handling
            Write-Error "Unexpected Error"
            Write-Error "$($_.Exception.Message)"
            Write-Error "Action unsuccessful. Please check the input and try again."
        }

        
        # ! Previous Code

            # In normal mode, check filename array validity
            Confirm-FilenameArray -filenameArray $filenameArray

            # Check desired folder validity only when provided
            if ($PSBoundParameters.ContainsKey("desiredLocation")) {            
                # Resolve the full path for safety
                $resolvedFullPath = Resolve-PathwErr -inputPath $desiredLocation
                Confirm-DesiredFolder -desiredLocation $resolvedFullPath
            }
        }

    

        # Enable processing array input of filenames
        foreach ($filename in $filenameArray) {
        
            $location = if ($PSBoundParameters.ContainsKey("desiredLocation")) {
                $desiredLocation
            }
            else {
                (Get-Location).Path
            }

            $fileObj = Get-FileObj `
                -filename $filename `
                -desiredLocation $location

            $isValidFilename = Confirm-Filename `
                -filename $fileObj.Filename `
                -fileFolder $fileObj.FileFolder
        
            if (-not $isValidFilename) {
                Write-Verbose "In folder '$($fileObj.FileFolder)',"
                Write-Warning "file '$($fileObj.Filename)' is invalid and will be skipped."
                continue
            }

            # Custom logic to handle the touch behavior, similar to unix touch, but different
            # This try block handles unexpected errors in the whole process
            try {
                # If the file is not there, create new file
                if (-not (Test-Path $fileObj.FullPath)) {
                    Invoke-CreationFile `
                        -filename $fileObj.Filename`
                        -fileFolder $fileObj.FileFolder`
                        -fullPath $fileObj.FullPath
                }
                # If the file already exists, 
                else {
                    Invoke-UpdateFile `
                        -filename $fileObj.Filename`
                        -fileFolder $fileObj.FileFolder`
                        -fullPath $fileObj.FullPath
                }
            }
            catch {
                Write-Error "Unexpected Error: $_"
            }
        }
    
        # Return for recursion
        return
    }

}
    