function Import-Function {
    <#
.SYNOPSIS
    Imports all PowerShell function scripts from a specified folder into the current session.

.DESCRIPTION
    Dot-sources all `.ps1` files from a specified folder and makes the defined functions
    available in the current session. Performs post-import checks to ensure essential 
    functions were loaded.

.PARAMETER functionFolder
    Path to the folder containing `.ps1` function files.

.EXAMPLE
    Import-Functions -Folder ".\functions"

.OUTPUTS
    None

.NOTES
    Author: Alex
    Version: 1.1
    Last Updated: 2025-05-24
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("Folder")]
        [string]$functionFolder
    )

    # Validate folder path
    if (-not (Test-Path $functionFolder)) {

        Write-Error "`n
        [ERROR] The specified folder '$functionFolder' does not exist.`n
        Try:
        - Check for typos in the path.
        - Make sure the folder exists on disk.
        - Ensure the script has access permissions.`n"

        return
    }

    # Dot-source all .ps1 files in the folder
    $functionName = 
    Get-ChildItem -Path $functionFolder -Filter *.ps1 | 
    select-object -ExpandProperty BaseName

    Write-Verbose "Function list $functionName"

    foreach ($func in $functionName) {
        $scriptPath = Join-Path -Path $functionFolder -ChildPath "$func.ps1"
        Write-Verbose "Importing: $func"
        Write-Verbose "Resolved path: $scriptPath"

        try {
            . $scriptPath
            Write-Host "Import $func successful"
        }
        catch {
            Write-Warning "Failed to import $func from $scriptPath"
            continue
        }

        if (-not (Get-Command $func -ErrorAction SilentlyContinue)) {
            Write-Error "[ERROR] Required function '$func' was not loaded."
            Write-Error "Check: `"$scriptPath`""
            return
        }
    }
}
