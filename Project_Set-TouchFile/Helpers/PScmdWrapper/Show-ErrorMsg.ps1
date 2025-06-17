function Show-ErrorMsg {
    <#
    .SYNOPSIS
    Displays a formatted error message and throws a terminating exception.
    
    .DESCRIPTION
    Used internally by helpers to log and rethrow consistent error messages. Supports
    both catch-based and manual validation scenarios. If an exception object is not 
    provided, only the custom message is used.
    
    .PARAMETER FunctionName
    The name of the function reporting the error.

    .PARAMETER CustomMessage
    A human-readable description of what failed.

    .PARAMETER Exception
    (Optional) The original exception object. Used to append reason context.

    .EXAMPLE
    Show-ErrorMsg -FunctionName "Resolve-PathwErr" -CustomMessage "Failed to resolve path."

    .EXAMPLE
    Show-ErrorMsg -FunctionName $MyInvocation.MyCommand.Name -CustomMessage "Manual resolve failed." -Exception $_.Exception
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FunctionName,

        [Parameter(Mandatory = $true)]
        [string]$CustomMessage,

        [Parameter(Mandatory = $false)]
        [System.Exception]$Exception
    )

    $fullMessage = if ($Exception) {
        "[$FunctionName] $CustomMessage Reason: $($Exception.Message)"
    } else {
        "[$FunctionName] $CustomMessage"
    }

    throw $fullMessage
}
