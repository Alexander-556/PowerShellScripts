# Collection_Simple-Functions

This folder contains a set of small, self-contained PowerShell scripts and functions for learning, fun, and daily terminal utility. Each script demonstrates a specific PowerShell technique, such as ASCII art, animations, or simple string manipulation.

## Contents

- **Add-Quotes.ps1**  
  Wraps a string (such as a file path) in double quotes for safe command-line usage.

- **RenderPowerShellBanner/**  
  Functions to render PowerShell ASCII banners in various styles:
  - `Build-PowerShellBanner3D.ps1`
  - `Build-PowerShellBannerDoh.ps1`
  - `Build-PowerShellBannerSlanted.ps1`

- **ShowShapes/**  
  Visual and animated terminal functions:
  - `Show-Animation.ps1` — Displays a simple animated ASCII bunny.
  - `Show-Rectangle.ps1` — Draws a rectangle with customizable size and character.
  - `Show-SimBootLog.ps1` — Simulates a boot log with random delays.
  - `Show-Spiner.ps1` — Shows a spinning animation while scanning files.
  - `Show-Triangle.ps1` — Prints a triangle row by row with progress.

## Usage

You can dot-source any script to load its function into your session, for example:

```powershell
. Add-Quotes.ps1

Add-Quotes -path "C:\My Folder\Project".
```

define functions)
Or run scripts directly for immediate output (for scripts that do not 
Purpose
Practice PowerShell scripting and function design
Explore terminal output formatting and animation
Provide reusable snippets for larger projects
Author
Jialiang Chang

Feel free to explore, adapt, and use these scripts in your own projects!

You can further expand each section with usage examples or screenshots if desired.