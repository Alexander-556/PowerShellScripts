# * MidLogicHelper
function Invoke-CreationFile {
    <#
    .SYNOPSIS
    Creates a new file in the specified folder and handles file creation errors.

    .DESCRIPTION
    The `Invoke-CreationFile` function creates a new file with the specified name in 
    the given folder. It validates the input parameters and handles errors during file 
    creation. After creating the file, it prompts the user to decide whether to open the 
    file. The function uses `New-Item` to create the file and `Confirm-OpenFile` to 
    handle the file opening prompt.

    .PARAMETER filename
    The name of the file to create.

    .PARAMETER fileFolder
    The folder path where the file will be created.

    .PARAMETER fullPath
    The full path to the file, combining the folder path and filename.

    .INPUTS
    [string]
    Accepts the filename, folder path, and full path as input.

    .OUTPUTS
    None. Outputs status messages to the console.

    .NOTES
    This is a helper function that should only be called in another function. 
    This function should not be called by the user directly.

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$filename,

        [Parameter(Mandatory = $true)]
        [string]$fileFolder,

        [Parameter(Mandatory = $true)]
        [string]$fullPath
    )

    # This try block handles file creation errors
    try {
        # Create the file with the specified name
        New-Item -ItemType File -Path $fullPath -ErrorAction Stop | Out-Null

        # Notify user for file creation
        Write-Verbose "In folder '$fileFolder',"
        Write-Host "file '$filename' created successfully." `
            -ForegroundColor Green
                    
        # Prompt user to open the file or not
        $isFileOpen = Confirm-OpenFile `
            -filename $filename `
            -fileFolder $fileFolder `
            -fullPath $fullPath `
            -mode "Clean"
                    
        if ($isFileOpen) {
            Write-Verbose "In folder '$fileFolder,'"
            Write-Verbose "file '$filename' opened."
        }
    }
    catch {
        Write-Verbose "In folder '$fileFolder',"
        Write-Error "Failed to create file '$filename'. Error: $_"
    }   
}


