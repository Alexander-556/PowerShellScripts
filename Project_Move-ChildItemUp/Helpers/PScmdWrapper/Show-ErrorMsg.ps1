# * PScmdWrapper
function Show-ErrorMsg {
    <#
    .SYNOPSIS
    Displays a formatted error message and throws a terminating exception.

    .DESCRIPTION
    Show-ErrorMsg is a private utility function used to throw consistent, formatted 
    terminating errors within the Set-TouchFile module. It is typically called by validation 
    and wrapper functions to report failures with meaningful context.

    It accepts the name of the calling function, a custom message, and optionally an exception 
    object. If an exception is provided, its message is appended to the output. This standardizes 
    error output across the module, especially in `try/catch` and validation scenarios.

    .PARAMETER FunctionName
    The name of the function where the error originated. This is used to prefix the final message.

    .PARAMETER CustomMessage
    A short, human-readable explanation of what failed. This should clearly state what went wrong.

    .PARAMETER Exception
    (Optional) An exception object caught via `$_.Exception`. If provided, its message will be 
    included in the error output.

    .EXAMPLE
    Show-ErrorMsg `
        -FunctionName "Resolve-PathwErr" `
        -CustomMessage "Failed to resolve path."

    Throws:  
    [Resolve-PathwErr] Failed to resolve path.

    .EXAMPLE
    Show-ErrorMsg `
        -FunctionName $MyInvocation.MyCommand.Name `
        -CustomMessage "Manual resolve failed." `
        -Exception $_.Exception

    Throws:  
    [YourFunctionName] Manual resolve failed. Reason: <Exception.Message>

    .INPUTS
    [string]
    The name of the function to display, and the custom message

    [System.Exception]
    The error exception object

    .OUTPUTS
    None. The function throws a terminating exception.

    .NOTES
    Private helper function for the Set-TouchFile module.  
    Not intended for direct use by end users.

    Scope:         Private  
    Author:        Jialiang Chang  
    Version:       1.0.0  
    Last Updated:  2025-06-24
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
    }
    else {
        "[$FunctionName] $CustomMessage"
    }

    throw $fullMessage
}
