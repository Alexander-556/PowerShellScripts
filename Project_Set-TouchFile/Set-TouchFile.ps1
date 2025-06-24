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
        [Alias("n")]
        [string]$filename,

        [Parameter(
            Mandatory = $false, 
            Position = 1, 
            ParameterSetName = 'ByName')
        ]
        [Alias("l")]
        [string]$desiredLocation,

        [Parameter(
            Mandatory = $true, 
            Position = 0, 
            ParameterSetName = 'ByFullPath')
        ]
        [Alias("f")]
        [string]$fullInputPath
    )

    # * The following begin, process, and end blocks are for pipeline purposes

    # Before accepting pipeline input, initialize an array to collect filenames
    begin {
        if (-not $PSBoundParameters.ContainsKey('fullInputPath')) {
            $filenameArray = 
            New-Object System.Collections.Generic.List[string]
        }
    }

    # Process the pipeline input
    process {
        if (-not $PSBoundParameters.ContainsKey('fullInputPath')) {
            $filenameArray.Add($filename)
        }
    }

    # After collecting all pipeline input, process the array
    end {
        # General Error Handling
        # ? Unsure on what's the best way of error handling
    
        # Touch mode selection, determine by checking the input argument
        if ($PSBoundParameters.ContainsKey("fullInputPath")) {
            # If quick access mode selected
            Invoke-RecurseSTF -fullInputPath $fullInputPath
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
            if ($PSBoundParameters.ContainsKey("desiredLocation")) {
                $desiredLocationObj = Resolve-InputFolderPath `
                    -inputPath $desiredLocation
            }
            else {
                $desiredLocationObj = Get-LocationObj   
            }
                
            
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
                Write-Host "Program terminates." `
                    -ForegroundColor Red
                return
            }
        } 
        # End of end block
    }
    # End of Function
}