# Start-FastCopy

A PowerShell utility that wraps [FastCopy](https://fastcopy.jp/) to enable safe, customizable, and modular folder-by-folder copying. Designed for use cases that require throttled backups, optional file verification, and flexible delay between transfers — all with proper PowerShell support for `-WhatIf`, `-Confirm`, and input validation.

---

## Features

- Folder-by-folder copy using FastCopy
- Adjustable speed: full, autoslow, suspend, or custom integer speed (1–9)
- Optional file verification per transfer
- Configurable delay between folder copies (to prevent overheating)
- Simulation mode using `-WhatIf` or `-Exec 0`
- Built-in progress tracking
- Modular function loading and safe input validation

---

## Usage

```powershell
Start-FastCopy -SourceFolder "D:\Data" `
               -TargetFolder "G:\Backup" `
               -Mode "custom" `
               -Speed 5 `
               -Delay 60 `
               -Verify 1 `
               -Exec 1
```

## Parameters

| Parameter       | Description                                                           |
| --------------- | --------------------------------------------------------------------- |
| `-SourceFolder` | The root folder whose immediate subfolders will be copied.            |
| `-TargetFolder` | Destination folder where each subfolder will be copied into.          |
| `-Mode`         | Speed mode: `"full"`, `"autoslow"`, `"suspend"`, or `"custom"`        |
| `-Speed`        | Integer (1–9) used **only** when `-Mode` is `"custom"`                |
| `-Delay`        | Seconds to wait between each folder copy. Default is `0`.             |
| `-Verify`       | `1` = verify copied files (default); `0` = skip verification          |
| `-Exec`         | `1` = perform actual copy; `0` = simulate using FastCopy's `/no_exec` |

## Examples

### Basic Full-Speed Copy

````powershell
Start-FastCopy -SourceFolder "D:\Photos" -TargetFolder "G:\Backup" -Mode "full"
````

### AutoSlow with Delay

````powershell
Start-FastCopy -SourceFolder "D:\Media" -TargetFolder "G:\Backup" -Mode "autoslow" -Delay 120
````

### Dry Run (No Files Will Be Written)

````powershell
Start-FastCopy -SourceFolder "D:\Projects" -TargetFolder "G:\Backup" -Exec 0 -Verify 0
````

## Folder Structure

````pgsql
Start-FastCopy/
├── Start-FastCopy.ps1         # Main function
├── functions/                 # Contains helper .ps1 files (e.g., Get-ChildFolderPath)
├── README.md                  # This file
├── Import-Function.ps1        # Function loader script
└── .gitignore                 # Recommended exclusions
````

## Requirements

PowerShell 5.1+ (Windows only)

FastCopy installed and accessible at a fixed path (edit $FCPath in script if needed)

## Customization Ideas

Add logging to file

Create GUI frontend with Out-GridView

Wrap in .psm1 module for use as a PowerShell toolset

Schedule as a weekly backup job using Task Scheduler

## Author

Jialiang Chang
Created as a modular and educational PowerShell scripting project.
Last Updated: 2025-05-24

## License

MIT License — free to use, adapt, and distribute.
