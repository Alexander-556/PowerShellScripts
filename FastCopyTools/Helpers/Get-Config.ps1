function Get-Config {
    [CmdletBinding()]
    param(
        [string]$ConfigPath = (Join-Path $PSScriptRoot "..\config.json")
    )

    try {
        if (-not (Test-Path $ConfigPath)) {
            throw [System.IO.FileNotFoundException]::new("Configuration file not found at: $ConfigPath")
        }

        $raw = Get-Content $ConfigPath -Raw
        $config = $raw | ConvertFrom-Json

        # --- Step 1: Validate value is not null/empty/whitespace
        if (Test-IsNullOrWhiteSpace $config.FastCopyPath) {
            throw "Missing or empty 'FastCopyPath' in config file: $ConfigPath"
        }

        # --- Step 2: Validate FastCopyPath structure
        try {
            $fcPath = $config.FastCopyPath

            if (-not (Test-Path $fcPath)) {
                throw "The specified FastCopy path does not exist: $fcPath"
            }

            if (-not (Test-Path $fcPath -PathType Leaf)) {
                throw "The FastCopy path is not a file (likely a folder): $fcPath"
            }

            $fileName = [System.IO.Path]::GetFileName($fcPath)
            if ($fileName.ToLower() -ne "fastcopy.exe") {
                throw "Invalid file name: expected 'FastCopy.exe' but got '$fileName'"
            }
        }
        catch {
            throw "Invalid 'FastCopyPath' in config: $($_.Exception.Message)"
        }

        return $config
    }
    catch [System.IO.FileNotFoundException] {
        Write-Warning "Config file not found. Creating a new one at: $ConfigPath"

        $defaultConfig = @{
            FastCopyPath = ""
        } | ConvertTo-Json -Depth 2

        try {
            $defaultConfig | Out-File -FilePath $ConfigPath -Encoding UTF8 -Force
            Write-Host "`nA new config file has been generated:"
            Write-Host "`t$ConfigPath"
            Write-Host "`nPlease open the file and fill in the missing 'FastCopyPath' before running the script again."
        }
        catch {
            Write-Error "Failed to create new config file: $($_.Exception.Message)"
        }

        throw "Cannot proceed: Config file missing and default could not be used until updated."
    }
    catch [System.UnauthorizedAccessException] {
        Write-Error "Permission denied: $($_.Exception.Message)"
        throw
    }
    catch {
        Write-Error "Unexpected error: $($_.Exception.Message)"
        throw
    }
}
