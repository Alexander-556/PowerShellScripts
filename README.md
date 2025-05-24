# PowerShell Scripting Projects

This repository is a collection of powershell scripts and functions created to solve problems that are relevant to me. My main purpose for this repo is to learn powershell as a windows based automation tool to try to automate my daily routines.

## Repository Structure

```pgsql
PowerShellScripts/
├── Function_Utils/          # Shared helper functions used across projects
├── Project_Start-FastCopy/  # Modular FastCopy automation wrapper
├── Simple_Functions/        # Small reusable PowerShell utilities
├── .gitignore               # Git ignore file log
├── LICENSE                  # MIT License for reuse
└── README.md                # This file
```

## Projects & Modules

### `Project_Start-FastCopy/`

My first project is a function called Start-FastCopy, this is a wrapper around [FastCopy](https://fastcopy.jp/) for controlled, folder-by-folder file copying with:

- Adjustable speed modes (full, autoslow, suspend, or custom)
- Optional post-copy file verification
- Customizable delay between transfers
- Support for simulation (`-WhatIf`, `-Exec 0`)
- Modular helper functions and clean logging

See FastCopy Project README → `Project_Start-FastCopy/README.md` for more information

### `Function_Utils/`

This is a folder for reusable functions that serve as the foundation for my attempt at modular scripting. Examples include:

- `Get-ChildFolderPath.ps1`: Enumerates immediate subdirectories given a parent folder.

The functions are documented with full help blocks and written for clean integration in other scripts.

### `Simple_Functions/`

Smaller standalone utilities and learning demos, including:

Great for learning, experimentation, and inclusion in larger projects.

## Recommended Tools

- **PowerShell 5.1+** (Windows)
- **Visual Studio Code** with PowerShell extension
- [FastCopy](https://fastcopy.jp/) for relevant scripts
- Git for version control

## About the Author

**Jialiang Chang**  
Undergraduate student, self-learning powershell scripting language.
This repository serves as both a learning log and a utility hub for everyday scripting problems. Feel free to use my scripts if you find them useful.

## Feedback

Issues and suggestions are welcome!  
If you find these scripts useful, feel free to open an [issue](https://github.com/your-user-name/your-repo-name/issues) or submit a pull request.

## License

This repository is released under the **MIT License**.  
Feel free to use, adapt, and share — with credit where due.

****

Last updated: 2025-05-24
