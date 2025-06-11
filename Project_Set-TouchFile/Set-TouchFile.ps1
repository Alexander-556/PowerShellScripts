# * Main
function Set-TouchFile {
    <#
    .SYNOPSIS
    #>
    
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(
            Mandatory = $true, 
            Position = 0, 
            ParameterSetName = 'ByName', 
            ValueFromPipeline = $true)
        ]
        [string]$filename,

        [Parameter(
            Mandatory = $false, 
            Position = 1, 
            ParameterSetName = 'ByName')
        ]
        [Alias("Location")]
        [string]$desiredLocation,

        [Parameter(
            Mandatory = $true, 
            Position = 0, 
            ParameterSetName = 'ByFullPath')
        ]
        [Alias("FullPath")]
        [string]$fullInputPath
    )

    # * The following begin, process, and end blocks are for pipeline purposes

    # Before accepting pipeline input, initialize an array to collect filenames
    begin {
        $filenameArray = 
        New-Object System.Collections.Generic.List[string]
    }

    # Process the pipeline input
    process {
        $filenameArray.Add($filename)
    }

    # After collecting all pipeline input, process the array
    end {
        # General Error Handling
        try {
            # Touch mode selection, determine by checking the input argument
            if ($PSBoundParameters.ContainsKey("fullInputPath")) {
                # If quick access mode selected

                # Step 1: Parse the input path into parent and leaf
                #         store the result in a path obj
                $fullInputPathObj = 
                Split-FilePath -inputPath $fullInputPath

                # Step 2: Feed them back into Set-TouchFile, recurse
                Set-TouchFile `
                    -Filename $fullInputPathObj.Filename `
                    -Location $fullInputPathObj.FileFolder
                    
                # Step 3: after recurse call, program ends
                return
            }
            else {
                # If normal mode selected

                # * Preprocessing

                # Step 1: Check validity of input filename array
                Confirm-FilenameArray `
                    -filenameArray $filenameArray
                
                # Step 2: Resolve the input folder path regardless of path validity
                # This is used for implementation of creating new folder feature
                $desiredLocationObj = 
                Resolve-InputFolderPath `
                    -inputPath $desiredLocation

                # Step 3: Check validity of the resolved desired folder
                Confirm-DesiredFolder `
                    -desiredLocation $desiredLocationObj.Path

                # Initialize a bool variable that determines whether program continues
                $programCont = $null

                # Check if the path exists or not
                if ($desiredLocationObj.Valid) {
                    # If the path already exists, no extra action needed, 
                    # program proceed
                    $programCont = $true
                }
                else {
                    # If the path doesn't exist, prompt user on whether to create
                    # the specified path
                    $programCont = Confirm-NewFileFolder `
                        -inputPath $desiredLocationObj.Path
                }

                # * Main Logic Process

                # Check if the program can proceed or not
                if ($programCont) {
                    # If program can proceed, then execute touch logic
                    Start-TouchSequence `
                        -filenameArray $filenameArray `
                        -desiredLocationObj $desiredLocationObj
                }
                else {
                    # If program cannot proceed, program terminates
                    Write-Host "Program terminates."
                    return
                }
            } 
            # End of try block
        }
        catch {
            # Improved error handling
            Write-Error "Unexpected Error"
            Write-Error "$($_.Exception.Message)"
            Write-Error "Action unsuccessful. Please check the input and try again."

            # End of catch block
        }
    
        # End of end block
    }

    # End of Function
}
    