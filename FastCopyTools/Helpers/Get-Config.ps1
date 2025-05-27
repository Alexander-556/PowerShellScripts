function Get-Config {
    <#
.SYNOPSIS
    Reads and validates the configuration file for FastCopyTools.

.DESCRIPTION
    This function reads a JSON configuration file, validates its contents, and ensures that 
    the required `FastCopyPath` property is present and points to a valid FastCopy executable. 
    If the configuration file does not exist, a default configuration file is created with 
    an empty `FastCopyPath` property, prompting the user to update it.

.PARAMETER configFilePath
    The full path to the configuration file. If not specified, the default path is 
    "..\config.json" relative to the script's directory.

.OUTPUTS
    [PSCustomObject] - Returns the configuration as a PowerShell object if validation succeeds.

.EXAMPLE
    PS> Get-Config
    Reads the default configuration file, validates its contents, and returns the configuration object.

.EXAMPLE
    PS> Get-Config -configFilePath "C:\MyConfig\config.json"
    Reads the specified configuration file, validates its contents, and returns the configuration object.

.NOTES
    If the configuration file is missing, a new one is created with default values. 
    The user must update the `FastCopyPath` property in the generated file before running the script again.

.LINK
    Join-Path Documentation:
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/join-path?view=powershell-7.5

.LINK
    Test-Path Documentation:
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/test-path?view=powershell-7.5

.LINK
    Get-Content Documentation:
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content?view=powershell-7.5

.LINK
    ConvertFrom-Json Documentation:
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-json?view=powershell-7.5

.LINK ConvertTo-Json Documentation:
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertto-json?view=powershell-7.5

.LINK
    Try-Catch-Finally Documentation:
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_try_catch_finally?view=powershell-7.5

#>

    [CmdletBinding()]
    param(
        [string]$configFilePath = (Join-Path -Path $PSScriptRoot -ChildPath "..\config.json")
    )
    
    # Start reading the configuration file
    try {
        # Test if config file path exists
        # Notice that this only checks if the file exists, not the directory
        if (-not (Test-Path -Path $configFilePath)) {
            # If config file path does not exist, throw error and catch in catch block
            throw [System.IO.FileNotFoundException]::new("Configuration file not found at: $configFilePath")
        }

        # Read config file and store json as pscustomobject
        $raw = Get-Content -Path $configFilePath -Raw
        $config = $raw | ConvertFrom-Json

        # Validate JSON structure
        # If not valid JSON structure, throw error and catch in catch block
        if (-not $config -or -not $config.PSObject.Properties.Match("FastCopyPath")) {
            throw "Invalid configuration file structure. 'FastCopyPath' property is missing."
        }

        # Validate value is not null/empty/whitespace
        if (Test-IsNullOrWhiteSpace $config.FastCopyPath) {
            throw "Missing or empty 'FastCopyPath' in config file: $configFilePath"
        }

        # Validate FastCopyPath structure
        Confirm-FCpath -inputPath $config.FastCopyPath

        # Return the validated configuration
        Write-Verbose "Configuration loaded successfully from: $configFilePath"
        return $config
    }
    # If config file does not exist, create a new one
    catch [System.IO.FileNotFoundException] {
        Write-Warning "Config file not found. Creating a new one at: $configFilePath"

        # Create a default configuration with an empty FastCopyPath
        $defaultConfig = @{
            # This is a hashtable
            # Do not need quotes around property names in hashtable
            FastCopyPath = ""
        } | ConvertTo-Json -Depth 2

        try {
            # Ensure the directory exists before writing the file
            # The previous Test-Path only checks if the file exists, not the directory
            $configDirectory = [System.IO.Path]::GetDirectoryName($configFilePath)
            if (-not (Test-Path -Path $configDirectory)) {
                New-Item -ItemType Directory -Path $configDirectory -Force | Out-Null
            }

            # Write the default configuration to the specified file path
            # If error occurs, catch in catch block
            $defaultConfig | Out-File -FilePath $configFilePath -Encoding UTF8 -Force
            Write-Host "A new config file has been generated at: $configFilePath"
            Write-Host "Please open the file and fill in the missing 'FastCopyPath' before running again"
        }
        catch {
            # Catch error during file creation
            Write-Error "Failed to create new config file: $($_.Exception.Message)"
            throw "Cannot proceed: Config file missing and default could not be created."
        }

        # This throw is to make sure that the function does not work on a default config file
        # and that the user is aware that they need to update the config file
        throw "Cannot proceed: Config file missing and default could not be used until updated."
    }
    # Catch the invalid JSON structure or empty file error
    catch [System.Management.Automation.PSInvalidOperationException] {
        Write-Error "The configuration file is empty or contains invalid JSON: $configFilePath"
        throw
    }
    # Catch permission errors
    catch [System.UnauthorizedAccessException] {
        Write-Error "Permission denied: $($_.Exception.Message)"
        throw
    }
    # Catch any other unexpected errors
    catch {
        Write-Error "Unexpected error: $($_.Exception.Message)"
        throw
    }
}
