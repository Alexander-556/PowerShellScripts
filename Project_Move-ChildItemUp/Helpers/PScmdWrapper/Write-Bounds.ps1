function Write-Bounds {
    param(
        [string]$FunctionName,
        
        [ValidateSet('Enter', 'Exit')]
        [string]$Mode
    )

    $prefix = if ($Mode -eq 'Enter') { 'ENTER' } else { 'EXIT ' }
    Write-Verbose "[==== ${prefix}: $FunctionName ====]"
}