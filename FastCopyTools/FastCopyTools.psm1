# FastCopyTools.psm1

# Store successfully loaded function names
$loadedFunctions = @()

# Load all .ps1 files from Helpers folder
$helperFunctionFiles = 
Get-ChildItem -Path "$PSScriptRoot\Helpers" -Filter *.ps1 -ErrorAction Stop

foreach ($file in $helperFunctionFiles) {
    try {
        . $file.FullName
        Write-Verbose "Loaded: $($file.Name)"
        $loadedFunctions += [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    }
    catch {
        Write-Warning "Failed to load $($file.Name): $_"
    }
}

# Functions expected to be loaded and exported
$expectedFunctions = @('Get-ChildFolderPath', 'Build-FCargs')

# Check that all expected functions were actually loaded
foreach ($func in $expectedFunctions) {
    if (-not (Get-Command $func -ErrorAction SilentlyContinue)) {
        Write-Error "[FastCopyTools.psm1] Function '$func' failed to load."
        throw "Aborting module load due to missing function: $func"
    }
}

# Export only the verified functions
Export-ModuleMember -Function $expectedFunctions
