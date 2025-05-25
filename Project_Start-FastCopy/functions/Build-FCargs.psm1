function Build-FCargs {
    <#
    .SYNOPSIS
        Constructs a FastCopy command argument list based on input options.

    .DESCRIPTION
        This function generates a list of arguments to be passed to the FastCopy
        executable based on input parameters such as mode, speed, verification,
        and execution flags. It also appends the quoted source and destination paths.

        This utility function is used by the main Start-FastCopy program to assemble
        per-folder copy instructions with specific operational behavior.

    .PARAMETER buildMode
        The FastCopy mode: either a named mode (e.g., "full", "autoslow", "suspend")
        or "custom" which requires a numeric speed from buildSpeed.

    .PARAMETER buildSpeed
        A numeric value (1–9) representing FastCopy’s speed level. Used only when buildMode is "custom".

    .PARAMETER buildVerifyDigi
        A digit flag: 1 enables file verification after copy, 0 disables it.

    .PARAMETER buildExecDigi
        A digit flag: 1 for actual execution, 0 for dry-run using /no_exec.

    .PARAMETER buildSourcePath
        Full path to the source folder to be copied.

    .PARAMETER buildTargetPath
        Full path to the destination folder where contents will be copied.

    .OUTPUTS
        System.String[]
        Returns an array of strings representing the FastCopy command-line arguments.

    .EXAMPLE
        Build-FCargs -buildMode "custom" -buildSpeed 5 -buildVerifyDigi 1 -buildExecDigi 1 `
                     -buildSourcePath "D:\Folder1" -buildTargetPath "G:\Backup\Folder1"

        Returns a full argument list to copy "Folder1" at speed 5 with verification.

    .NOTES
        Author: Jialiang Chang
        Version: 1.0
        Last Updated: 2025-05-24
    #>

    [CmdletBinding()]
    param(
        [string]$buildMode,
        [int]$buildSpeed,
        [int]$buildVerifyDigi,
        [int]$buildExecDigi,
        [string]$buildSourcePath,
        [string]$buildTargetPath
    )

    # Initialize base argument list with default options
    $buildFCArgsList = @(
        "/cmd=diff",        # Use differential copy
        "/auto_close",      # Automatically close FastCopy after completion
        "/open_window",     # Open a visible FastCopy window
        "/estimate"         # Estimate file size/time before execution
    )

    # Append appropriate speed option
    if ($buildMode -eq "custom") {
        $buildFCArgsList += "/speed=$buildSpeed"
    }
    else {
        $buildFCArgsList += "/speed=$buildMode"
    }

    # Append verification flag based on user input
    if ($buildVerifyDigi -eq 1) {
        $buildFCArgsList += "/verify"
    }
    elseif ($buildVerifyDigi -eq 0) {
        $buildFCArgsList += "/verify=FALSE"
    }

    # Append /no_exec if this is a dry run
    if ($buildExecDigi -eq 0) {
        $buildFCArgsList += "/no_exec"
    }

    # Append quoted source and destination paths
    $buildFCArgsList += @(
        "`"$buildSourcePath`"",
        "/to=`"$buildTargetPath`""
    )

    return $buildFCArgsList
}

Export-ModuleMember -Function Build-FCargs
