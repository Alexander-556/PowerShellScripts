function Invoke-AutoComplete {
    [CmdletBinding()]
    param(
        $commandName,         # Name of the command being completed
        $parameterName,       # Name of the parameter being completed
        $wordToComplete,      # The partial input typed by the user
        $commandAst,          # Abstract Syntax Tree of the command line (not used here)
        $fakeBoundParameters  # Simulated bound parameters (not used here)
    )

    # Determine the base path to search from
    # If the input ends with a slash, treat it as a folder; otherwise, extract its parent folder
    $base = 
    if ($wordToComplete -match '[\\/]+$') {
        $wordToComplete
    }
    else {
        Split-Path $wordToComplete -Parent
    }

    # If the base path doesn't exist, default to the current directory
    if (-not (Test-Path $base)) {
        $base = '.'
    }

    # Determine if the input is relative (no drive/root specified)
    $inputIsRelative = -not [System.IO.Path]::IsPathRooted($wordToComplete)

    # Store current session path to compute relative completions later
    $sessionPath = (Get-Location).Path

    # Enumerate items under the base path
    Get-ChildItem -Path $base -ErrorAction SilentlyContinue |
    Where-Object {
        # Filter to include only directories that match the trailing name part
        $_.PSIsContainer -and $_.Name -like "$($wordToComplete | Split-Path -Leaf)*"
    } |
    ForEach-Object {
        $fullPath = $_.FullName

        # Sanity check: Make sure this path still exists
        if (-not (Test-Path $fullPath)) {
            return
        }

        # Determine the final path to show in auto-complete
        # If input was relative, output a relative path; else use full path
        $completionPath = 
        if ($inputIsRelative) {
            [System.IO.Path]::GetRelativePath($sessionPath, $fullPath)
        }
        else {
            $fullPath
        }

        # Return the completion result: what to insert, what to display, and a tooltip
        [System.Management.Automation.CompletionResult]::new(
            $completionPath,   # Inserted text
            $_.Name,           # Display label
            'ParameterValue',  # Result type (we're completing a param)
            $completionPath    # Tooltip shown on hover
        )
    }
}
