function Build-FCargs {

    [CmdletBinding()]
    param(
        [string]$buildMode,
        [int]$buildSpeed,
        [int]$buildVerifyDigi,
        [int]$buildExecDigi,
        [string]$buildSourcePath,
        [string]$buildTargetPath
    )

    $buildFCArgsList = @(
        "/cmd=diff",
        "/auto_close",
        "/open_window",
        "/estimate"
    )

    # Speed flag
    if ($buildMode -eq "custom") {
        $buildFCArgsList += "/speed=$buildSpeed"
    }
    else {
        $buildFCArgsList += "/speed=$buildMode"
    }

    # Verify flag
    if ($buildVerifyDigi -eq 1) {
        $buildFCArgsList += "/verify"
    }
    elseif ($buildVerifyDigi -eq 0) {
        $buildFCArgsList += "/verify=FALSE"
    }

    # Exec flag
    if ($buildExecDigi -eq 0) {
        $buildFCArgsList += "/no_exec"
    }

    # Add source and destination paths (quoted)
    $buildFCArgsList += @(
        "`"$buildSourcePath`"",
        "/to=`"$buildTargetPath`""
    )

    return $buildFCArgsList
}
