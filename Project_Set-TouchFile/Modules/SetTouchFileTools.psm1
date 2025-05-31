# Initialize list to track successfully loaded helper function names
$loadedFunctions = @()

# Initialize list to track expected functions, used for dynamic tracking
$expectedFunctions = @()

# Retrieve all .ps1 helper scripts in the Helpers subdirectory
# Optional: load by folder, but not very necessary
try {
    $helperFunctionFiles = Get-ChildItem -Path "$PSScriptRoot\..\Helpers" -Recurse -Filter *.ps1 -ErrorAction Stop
}
catch {
    Write-Error "Unable to find helper functions."
    throw
}

# Dot source main function
$expectedFunctions += 'Set-TouchFile'
. "$PSScriptRoot\..\Set-TouchFile.ps1" -Force
$loadedFunctions += 'Set-TouchFile'

# Dot-source each helper file and track loaded function names
foreach ($file in $helperFunctionFiles) {
    try {
        # Add this file to the expected list
        $expectedFunctions += [System.IO.Path]::GetFileNameWithoutExtension($file.Name)

        # Dot source
        . $file.FullName -Force
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
        # Error logging
        Write-Error "[SetTouchFileTools.psm1] Function '$func' failed to load."

        # Abort module loading if a critical function is missing
        throw "Aborting module load due to missing function: $func"
    }
}

# Export expected functions to consumers of this module, for convenience
# Optional: better validation
Export-ModuleMember -Function $expectedFunctions
