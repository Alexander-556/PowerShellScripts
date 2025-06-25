# * Main
function Set-TouchFile {
    <#
    .SYNOPSIS
    Creates one or more empty files in a specified or current directory.

    .DESCRIPTION
    The Set-TouchFile function simulates the Unix `touch` command in PowerShell.
    Compared to its Unix counterpart, this function offers greater interactivity, 
    clearer user prompts, and more verbose output to support learning and transparency.

    Its primary purpose is to quickly generate empty files by specifying individual 
    filenames (with an optional target directory), or by supplying a full file path directly. 
    If the file already exists, its timestamp will be updated.

    This function supports pipeline input, batch processing, and smart folder resolution. 
    If the target directory does not exist, the user is prompted to create it.

    .PARAMETER filename
    The name of the file to create. 
    
    Accepts pipeline input and supports multiple values.
    Used with the 'ByName' parameter set.

    Alias: 
    -n (n for name)

    .PARAMETER desiredLocation
    Optional. The folder where the file(s) will be created. 

    If omitted, the current working directory is used. 
    Used with the 'ByName' parameter set.

    Alias:
    -l (l for location)

    .PARAMETER fullInputPath
    A full path to the file (including the filename) to create. 

    Automatically handles recursive file creation if intermediate folders do not exist. 
    Used with the 'ByFullPath' parameter set.

    Alias:
    -f (f for full path)

    Notice:
    1. User must specify the -f option if one wants to use the full path as input.
    2. When using the full path mode, only one file input is expected.
    3. Do not combine this with -filename or -desiredLocation.

    .INPUTS
    [string] Accepts string input from the pipeline for all the parameters.

    .OUTPUTS
    None. This function performs file system operations and writes status messages to the host.

    .EXAMPLE
    Set-TouchFile -filename "example.txt"
    Set-TouchFile -n "example.txt"
    Set-TouchFile "example.txt"

    The above three commands are equivalent.
    Creates an empty file named 'example.txt' in the current directory.

    .EXAMPLE
    "foo.txt", "bar.txt" | Set-TouchFile -desiredLocation "D:\Temp\TouchTest"
    "foo.txt", "bar.txt" | Set-TouchFile -l "D:\Temp\TouchTest"

    The above two commands are equivalent.
    Creates two files 'foo.txt' and 'bar.txt' in the folder 'D:\Temp\TouchTest'. 
    Prompts the user to create the folder if it doesn't exist.

    .EXAMPLE
    Set-TouchFile -n "example.txt" -l "D:\Test"
    Set-TouchFile "example.txt" "D:\Test"

    The above two commands are equivalent.
    Creates the file 'example.txt' in the folder 'D:\Temp'.
    Prompts the user to create the folder if it doesn't exist.

    Notice:
    The default positional binding has filename at 0 and location at 1.
    
    .EXAMPLE
    Set-TouchFile -fullInputPath "D:\Projects\TodoList\README.md"
    Set-TouchFile -f "D:\Projects\TodoList\README.md"

    The above two commands are equivalent.
    Creates a single file at the full path. 
    If any intermediate folders do not exist, the user is prompted to create them.

    .NOTES
    This is the main public function in the Set-TouchFile utility.
    To use this function, import the module `SetTouchFileTools.psd1`
    to ensure all dependencies are loaded.

    To create a convenient alias similar to Unix, run:
    Set-Alias -Name touch -Value Set-TouchFile

    Scope:         Public
    Author:        Jialiang Chang
    Version:       1.0.0
    Last Updated:  2025-06-25
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

    # ! Main Logic:
    # Main function logic:
    # For a given location and For each input file
    #     Check if the location path exists
    #         If exists
    #             Proceed
    #         If does not exist
    #             Prompt user to create the folder
    #     Check if file exists
    #         If exists
    #             Update file time stamp
    #             Prompt user to open the file
    #             Prompt user to re-enter the filename
    #             Program Stop
    #         If does not exist
    #             Creates the file
    #             Prompt user to open the file
    #             Program Stop

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