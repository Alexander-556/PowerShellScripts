function Move-FolderContentsUp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$inputFolderPath
    )

    try {
        # Step 1: Resolve and validate
        $source = Resolve-Path -Path $SourceFolderPath
        if (-not (Test-Path -Path $source -PathType Container)) {
            throw "Source folder does not exist or is not a directory: $SourceFolderPath"
        }

        $parent = Split-Path -Path $source -Parent

        # Step 2: Move files and folders
        Get-ChildItem -Path $source -Force | ForEach-Object {
            $target = Join-Path -Path $parent -ChildPath $_.Name

            # Optional: handle name conflicts
            if (Test-Path $target) {
                Write-Warning "Conflict detected: $($_.Name) already exists in $parent"
                # You could skip, overwrite, or rename here
            }
            else {
                Move-Item -Path $_.FullName -Destination $parent
            }
        }

        # Step 3: Optional cleanup
        # Remove-Item -Path $source -Recurse -Force
        Write-Host "✅ Successfully flattened $source into $parent"

    }
    catch {
        Write-Error "❌ Error: $($_.Exception.Message)"
    }

}