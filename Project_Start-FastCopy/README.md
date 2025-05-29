# Project Start-FastCopy

A modular PowerShell tool for controlled, per-folder copying using the FastCopy utility. This project provides a robust wrapper around FastCopy, enabling advanced automation, speed control, verification, and safe configuration for large-scale folder transfers.

---

## Features

- **Per-Subfolder Copying:**  
  Copies each immediate subfolder from a source directory to a target directory, one at a time.

- **Speed Control:**  
  Supports FastCopy's speed modes: `full`, `autoslow`, `suspend`, or a custom speed (1–9).

- **Verification:**  
  Optionally enable or disable post-copy file verification.

- **Dry Run Simulation:**  
  Use FastCopy's `/no_exec` for safe simulation before actual copying.

- **Thermal Throttling:**  
  Optional delay between subfolder copies to prevent overheating or throttling.

- **Interactive Confirmation:**  
  Integrates PowerShell's `ShouldProcess` for `-WhatIf` and `-Confirm` support.

- **Configurable FastCopy Path:**  
  Stores the FastCopy executable path in a `config.json` file for easy updates—no need to edit scripts.

- **Modular Helpers:**  
  All logic is split into reusable helper functions for maintainability and testing.

---

## Folder Structure

```
Project_Start-FastCopy/
│
├── config.json                # Stores the FastCopy.exe path
├── FastCopyTools.psd1         # Module manifest
├── FastCopyTools.psm1         # Module loader for helper functions
├── Start-FastCopy.ps1         # Main entry point function
├── Helpers/                   # Helper functions
│   ├── Build-FCargs.ps1
│   ├── Confirm-FCpath.ps1
│   ├── Get-ChildFolderPath.ps1
│   ├── Get-Config.ps1
│   └── Test-IsNullOrWhiteSpace.ps1
```

---

## Quick Start

1. **Configure FastCopy Path**

   Edit `config.json` and set the path to your `FastCopy.exe`:

   ```json
   {
     "FastCopyPath": "C:\\Path\\To\\FastCopy.exe"
   }
   ```

2. **Import the Module**

   ```powershell
   Import-Module "$PWD/FastCopyTools.psd1" -Force
   ```

3. **Run the Main Function**

   ```powershell
   .\Start-FastCopy.ps1 -SourceFolder "D:\Data" -TargetFolder "G:\Backup" -Mode "custom" -Speed 5 -Delay 60 -Verify 1 -Exec 1
   ```

   Use `-WhatIf` or `-Confirm` for safe testing.

---

## Example Usage

```powershell
Start-FastCopy -SourceFolder "D:\Data" -TargetFolder "G:\Backup" `
               -Mode "autoslow" -Verify 1 -Exec 1
```

- **Custom Speed Example:**

  ```powershell
  Start-FastCopy -SourceFolder "D:\Data" -TargetFolder "G:\Backup" `
                 -Mode "custom" -Speed 3 -Delay 30 -Verify 0 -Exec 1
  ```

- **Dry Run Example:**

  ```powershell
  Start-FastCopy -SourceFolder "D:\Data" -TargetFolder "G:\Backup" `
                 -Mode "full" -Exec 0
  ```

---

## Helper Functions

- **Get-Config:** Reads and validates the config file.
- **Confirm-FCpath:** Ensures the FastCopy path is valid.
- **Get-ChildFolderPath:** Lists immediate subfolders for batch processing.
- **Build-FCargs:** Constructs FastCopy command-line arguments.
- **Test-IsNullOrWhiteSpace:** Utility for string validation.

All helpers are loaded automatically via the module.

---

## Requirements

- [PowerShell 7+](https://learn.microsoft.com/en-us/powershell/)
- [FastCopy](https://fastcopy.jp/) (Windows)
- Windows OS

---

## License

MIT License Jialiang Chang

---

## Author

Jialiang Chang  
For questions or suggestions, please open an issue or pull request.
