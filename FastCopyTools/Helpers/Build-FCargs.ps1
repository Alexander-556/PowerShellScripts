function Build-FCargs {
    <#
    .SYNOPSIS
        Constructs a list of FastCopy command-line arguments based on user-defined options.

    .DESCRIPTION
        This function generates a dynamic argument array for FastCopy execution. It supports
        setting custom or preset transfer speeds, enabling or disabling verification, specifying
        dry-run execution, and quoting source and destination paths for safety. The final output
        is an array of command-line arguments ready to be passed to FastCopy.

    .PARAMETER buildMode
        Transfer speed preset or "custom" for user-defined speed (e.g., "autoslow", "auto", "custom").

    .PARAMETER buildSpeed
        Speed value to use when buildMode is "custom". Ignored otherwise.

    .PARAMETER buildVerifyDigi
        Use 1 to enable file verification after copy, 0 to disable it.

    .PARAMETER buildExecDigi
        Use 0 to add /no_exec for dry run. Use 1 for normal execution.

    .PARAMETER buildSourcePath
        Full path to the source directory (quoted in output).

    .PARAMETER buildTargetPath
        Full path to the target directory (quoted in output).

    .OUTPUTS
        [string[]] A list of FastCopy-compatible arguments.

    .EXAMPLE
        PS> Build-FCargs -buildMode "auto" -buildVerifyDigi 1 -buildExecDigi 1 `
                         -buildSourcePath "C:\Source" -buildTargetPath "D:\Backup"

    .NOTES
        Author: Jialiang Chang
        Version: 1.0
        Date: 2025-05-24
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
