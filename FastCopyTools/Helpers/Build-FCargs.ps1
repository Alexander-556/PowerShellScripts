function Build-FCargs {
    <#
.SYNOPSIS
    Constructs a list of FastCopy command-line arguments based on user-defined options.

.DESCRIPTION
    As a part of the modular functions that belongs to Start-FastCopy function,
    this function generates a dynamic argument array for FastCopy execution. Takes in
    given input parameters, and outputs a formatted array of command-line arguments. All
    the input parameters are given by the Start-FastCopy function, with a build prefix to 
    indicate they are for building FastCopy arguments.

    This function should not be called directly, but rather used within the
    Start-FastCopy.ps1 script to prepare the FastCopy command-line arguments.
    
.PARAMETER buildSourcePath
    The root source directory. Each immediate subfolder will be copied individually.

.PARAMETER buildTargetPath
    The root destination directory. Each subfolder will be copied as a new folder here.

.PARAMETER buildMode
    Speed mode to use. Acceptable values: full, autoslow, suspend, custom.
    When 'custom' is selected, -intSpeed must be specified.

.PARAMETER buildSpeed
    Custom integer transfer speed (1–9). Only required when -strMode is 'custom'.

.PARAMETER buildVerifyDigi
    1 to enable post-copy verification (default), 0 to disable.

.PARAMETER buildExecDigi
    1 to execute FastCopy (default), 0 to simulate using /no_exec.

.OUTPUTS
    [string[]] A list of FastCopy-compatible arguments.

.EXAMPLE
    PS> Build-FCargs -buildSourcePath "C:\Source" -buildTargetPath "D:\Backup" `
                    -buildMode "custom" -buildSpeed 5 -buildVerifyDigi 1 -buildExecDigi 1
    
    Constructs arguments for a custom-speed copy with verification enabled and normal 
    execution.

.NOTES
    Author: Jialiang Chang
    Version: 1.0
    Date: 2025-05-27
#>

    [CmdletBinding()]
    param(
        [string]$buildSourcePath,
        [string]$buildTargetPath,
        [string]$buildMode,
        [int]$buildSpeed,
        [int]$buildVerifyDigi,
        [int]$buildExecDigi
    )

    # Initialize base argument list with default options
    $buildFCArgsList = @(
        "/cmd=diff", # Use differential copy
        "/auto_close", # Close FastCopy automatically after completion
        "/open_window", # Open FastCopy UI window
        "/estimate"         # Estimate size/time before execution
    )

    # Append appropriate speed option
    if ($buildMode -eq "custom") {
        $buildFCArgsList += "/speed=$buildSpeed"
    }
    else {
        $buildFCArgsList += "/speed=$buildMode"
    }

    # Add verification switch
    if ($buildVerifyDigi -eq 1) {
        $buildFCArgsList += "/verify"
    }
    elseif ($buildVerifyDigi -eq 0) {
        $buildFCArgsList += "/verify=FALSE"
    }

    # Add dry-run flag if applicable
    if ($buildExecDigi -eq 0) {
        $buildFCArgsList += "/no_exec"
    }

    # Append source and destination paths (quoted)
    $buildFCArgsList += @(
        "`"$buildSourcePath`"",
        "/to=`"$buildTargetPath`""
    )

    return $buildFCArgsList
}
