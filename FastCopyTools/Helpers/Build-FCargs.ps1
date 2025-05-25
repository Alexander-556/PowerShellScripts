function Build-FCargs {
    <#
    .SYNOPSIS

    .DESCRIPTION


    .PARAMETER buildMode


    .PARAMETER buildSpeed


    .PARAMETER buildVerifyDigi


    .PARAMETER buildExecDigi


    .PARAMETER buildSourcePath


    .PARAMETER buildTargetPath

    .OUTPUTS


    .EXAMPLE


    .NOTES

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
        "/auto_close", # Automatically close FastCopy after completion
        "/open_window", # Open a visible FastCopy window
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
