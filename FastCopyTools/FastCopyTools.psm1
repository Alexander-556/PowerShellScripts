# FastCopyTools.psm1

# Load public functions from the Public folder
Get-ChildItem -Path "$PSScriptRoot\Public" -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}

# Export only the functions meant for public use
Export-ModuleMember -Function Get-ChildFolderPath, Build-FCargs
