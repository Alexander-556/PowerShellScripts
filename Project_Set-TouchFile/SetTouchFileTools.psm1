# Initialize list to track successfully loaded helper function names
$loadedFunctions = @()

# Define required function names that must be loaded successfully
$expectedFunctions = @()


# Retrieve all .ps1 helper scripts in the Helpers subdirectory
try {
    $helperFunctionFiles = Get-ChildItem -Path "$PSScriptRoot\Helpers" -Filter *.ps1 -ErrorAction Stop
}
catch {
    Write-Error "Unable to find helper functions."
    throw
}

# Dot-source each helper file and track loaded function names
foreach ($file in $helperFunctionFiles) {
    try {
        $expectedFunctions += [System.IO.Path]::GetFileNameWithoutExtension($file.Name)

        . $file.FullName
        Write-Verbose "Loaded helper: $($file.Name)"

        # Extract base name (without extension) for function tracking
        $loadedFunctions += [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    }
    catch {
        Write-Warning "Failed to load helper function '$($file.Name)': $_"
    }
}

# Verify that each expected function was actually loaded into the session
foreach ($func in $expectedFunctions) {
    if (-not (Get-Command $func -ErrorAction SilentlyContinue)) {
        Write-Error "[SetTouchFileTools.psm1] Function '$func' failed to load."
        
        # Abort module loading if a critical function is missing
        throw "Aborting module load due to missing function: $func"
    }
}

# Export only the validated and expected functions to consumers of this module
Export-ModuleMember -Function $expectedFunctions
