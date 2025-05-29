<!-- prettier-ignore-start -->
<!-- markdownlint-disable-next-line MD041 -->
![HeaderGIF](./Images/WindowsTerminal_7DcFt7URrF.gif)
<!-- prettier-ignore-end -->

<!-- markdownlint-disable-next-line MD033 -->
<div align="center">

<!-- First row -->

![Status](https://img.shields.io/badge/Status-WorkInProgress-yellow) ![Type: Self-Learning](https://img.shields.io/badge/Type-Self--Learning-blueviolet) ![License: MIT](https://img.shields.io/badge/License-MIT-green.svg) ![PowerShell](https://img.shields.io/badge/Shell-PowerShell-blue) ![Platform: Windows](https://img.shields.io/badge/Platform-Windows-lightgrey)

<!-- Second row -->

![LastCommit](https://img.shields.io/github/last-commit/Alexander-556/PowerShellScripts) ![Commits](https://img.shields.io/github/commit-activity/w/Alexander-556/PowerShellScripts) ![Created](https://img.shields.io/github/created-at/Alexander-556/PowerShellScripts)

</div>

# PowerShell Scripting Projects

This repository is a collection of powershell scripts and functions created to solve problems that are relevant to me. My main purpose for this repo is to learn powershell as a windows based automation tool to try to automate my daily routines.

- [PowerShell Scripting Projects](#powershell-scripting-projects)
  - [Repository Structure](#repository-structure)
  - [Todos and Plans](#todos-and-plans)
    - [Repo Documentation Enhancements](#repo-documentation-enhancements)
    - [Project Start-FastCopy](#project-start-fastcopy)
    - [Collection of Simple Functions](#collection-of-simple-functions)
    - [Future Project Plans](#future-project-plans)
  - [Understanding the Basics: Operating System, Shell, and Terminal](#understanding-the-basics-operating-system-shell-and-terminal)
    - [What is an Operating System (OS)?](#what-is-an-operating-system-os)
    - [What is a Shell?](#what-is-a-shell)
    - [What is a Terminal?](#what-is-a-terminal)
  - [Tools Involved in Project](#tools-involved-in-project)
    - [Coding Environment](#coding-environment)
      - [PowerShell 7.5](#powershell-75)
      - [Windows Terminal](#windows-terminal)
      - [oh-my-posh](#oh-my-posh)
      - [Visual Studio Code](#visual-studio-code)
  - [Projects \& Modules](#projects--modules)
    - [Start-FastCopy – Controlled Folder-by-Folder Copying via FastCopy](#start-fastcopy--controlled-folder-by-folder-copying-via-fastcopy)
    - [Simple-Functions - Small Scripts for Terminal Fun \& Utility](#simple-functions---small-scripts-for-terminal-fun--utility)
  - [Feedback](#feedback)
  - [Author](#author)
  - [License](#license)

## Repository Structure

```pgsql
PowerShellScripts/
├── Collection_Simple-Functions/         # Small PowerShell utilities
├── Docs/                                # Setup tutorials and script documentations
├── Images/                              # Image assets
├── Project_Start-FastCopy/              # FastCopy automation wrapper for copying folder by folder
├── .gitignore                           # Git ignore file
├── LICENSE                              # MIT License
└── README.md                            # This file
```

## Todos and Plans

This section presents current work-in-progress and some ideas for future developments in this repo. This todo list is updated frequently as development progresses.

<!-- prettier-ignore-start -->
<!-- markdownlint-disable-next-line MD036 -->
_Todo Last Updated: 2025-05-28_
<!-- prettier-ignore-end -->

### Repo Documentation Enhancements

- [ ] Complete this README structure for clarity
  - [ ] Find location to add table of contents
  - [ ] Use link to documentations instead of listing the tutorials in the README
- [ ] Complete documentation for necessary tool setup
  - [ ] PowerShell Setup
  - [ ] Terminal Setup
  - [ ] oh-my-posh Setup
  - [ ] VScode setup
    - [ ] Extensions
    - [ ] Debug `launch.json` `task.json`
- [ ] Additional introduction to powershell information for information purposes
  - [ ] Introduce on shell, terminal, and OS
- [ ] Make this repo README look more attractive

### Project Start-FastCopy

- [ ] New features in Start-FastCopy
  - [x] Edit path for FastCopy executable in a config.json file, instead of using hard coded path
  - [ ] Write log files for operation, determine the location the information in the log
- [ ] Better documentation for Start-FastCopy
  - [ ] Usage tutorial and demo with screenshots in README

### Collection of Simple Functions

- [ ] Better documentation in `./Collection_SimpleFunctions`
  - [ ] Add README for folder
  - [ ] Write documentation for current functions
- [ ] More simple function ideas

### Future Project Plans

- [ ] Automate backup of key folders using Task Scheduler + FreeFileSYnc
- [ ] Automate journal logging
  - [ ] Create a journal file daily
  - [ ] Automate git pull several times per day
  - [ ] Automate git push changes at the end of day
- [ ] Build a tool to monitor disk health status with `smartctl`.
  - [ ] Log disk status with smartctl output
  - [ ] Save key data history and create visualization
  - [ ] Alert user of critical events and potential drive failure
- [ ] Disk Space Analyzer on command line

## Understanding the Basics: Operating System, Shell, and Terminal

If you are new to scripting or command-line tools, don't worry. You're not alone. Many people feel intimidated at first by all the black windows with blinking cursors. But once you understand the three core building blocks - the Operating System, Shell, and Terminal - you'll realize it's not as mysterious and deep as it looks, and you'll be ready to explore scripting step by step.

If you are already comfortable with these concepts, feel free to skip ahead to the [Tools Involved in Project](#tools-involved-in-project) section.

### What is an Operating System (OS)?

The Operating System is the brain of your computer. It manages everything - your memory, files, devices, apps, and even how you interact with the system. It's the foundation that lets all your other programs function properly.

Common desktop operating systems include:

- **Windows**
  -- This is the OS used throughout this project.
- **macOS**
  -- Found on Apple computers.
- **Linux**
  -- A family of open-source systems used on servers, embedded devices, and desktops.

The OS is always working in the background to make sure your commands and programs behave as expected.

### What is a Shell?

Humans speak in human languages. It would be great if computers could directly understand us - and while we're getting closer to that goal, we're not quite there yet. Computers still speak a different language: machine code.

Back in the day, people used things like punched cards and later assembly language to tell computers what to do. But over time, tools have been developed to make this process much easier - and that's where the Shell comes in.

A Shell is a command-line interpreter. It acts as a translator between you and the operating system. You type in commands in a language the shell understands, and it passes your instructions along to the OS.

Just like human translators specialize in different languages, different shells work with different OSes and have their own syntax and features.

Common shells include:

- On Windows:

  - **PowerShell**
    -- A modern and powerful shell designed for automation and scripting (used in this project).
  - **Command Prompt** (cmd.exe)
    -- A classic shell from MS-DOS days. Still works, but more limited in functionality.

- On Unix-like systems (e.g., Linux/macOS):
  - **sh**
    -- The first default shell on Unix systems.
  - **bash**
    -- An extension of **sh** with additional features.
  - **zsh**
    -- An enhanced shell with new features compared to **bash** and great customization through the `oh-my-zsh` framework.
  - **fish**
    -- A beginner-friendly shell with clean default user interface and smart suggestions.

### What is a Terminal?

Now that we’ve talked about the Shell and the OS, what exactly is the Terminal?

The Terminal is the application that hosts the shell — it’s the window where the conversation between you and your computer happens. You type commands into the terminal, the shell interprets them, and the OS gets the job done.

In simple terms:

- The Terminal is the environment where you type.

- The Shell is the tool that understands and runs your commands.

- The OS is what carries out the instructions.

Terminal programs on Windows include:

- **Windows Terminal**
  -- A modern, customizable terminal with tab support, _the modern all-in-one_.

- **Command Prompt**
  -- The traditional terminal that opens cmd.exe by default, _the classic choice_.

- **PowerShell Console**
  -- PowerShell's default terminal window, _a bit boring_.

In this project, I recommend you use Windows Terminal because of its customizability. It's always better to look into a modern window than the old-school black or blue ones.

## Tools Involved in Project

This section introduces the key tools used across scripts and setups in this repository. For detailed setup instructions, visit the `./Docs` folder or use the following links with arrows.

If you are new to scripting, I recommend you to go through the tutorials sequentially starting from "Install & Configure PowerShell" and follow instruction links til the end of the setup tutorial.

If you are only unsure about some of the tools, also feel free to jump around with the links to different documentations.

### Coding Environment

#### PowerShell 7.5

[PowerShell](https://learn.microsoft.com/en-us/powershell/) is a powerful cross-platform shell and scripting language developed by Microsoft, ideal for task automation and system configuration. It offers deep integration with the Windows operating system and the .NET runtime. This repository uses the latest PowerShell 7.5 on Windows.

Compare to traditional Command Prompt (cmd.exe), PowerShell includes advanced features and better syntax, with:

- Object-based output instead of plain text
- More consistent syntax and command naming
- Access to complex logic, loops, error handling, and functions
- Built-in support with `Get-Help` for working with files, processes, registry, networking, and more

PowerShell 7+ is open-source and actively maintained on the [PowerShell GitHub Repo](https://github.com/PowerShell/PowerShell/tree/master), with a strong and growing community that contributes modules, tools, and documentations. This ecosystem makes it a robust choice for both beginners and professionals.

→ [Install & Configure PowerShell](./Docs/PowerShell_Setup.md)

#### Windows Terminal

[Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/) is Microsoft’s modern terminal application that supports multiple profiles (e.g., PowerShell, Command Prompt, WSL) in a tabbed, customizable interface. It greatly improves usability over the default console, supports font ligatures, transparency, Unicode, and theme customization.

→ [Windows Terminal Setup Guide](./Docs/PowerShell_Setup.md)

#### oh-my-posh

[oh-my-posh](https://ohmyposh.dev) is a sleek and highly configurable prompt theming engine that enhances the visual appearance of your shell environment. It supports a wide range of themes and integrates with Nerd Fonts to display icons and glyphs. This tool adds both style and clarity to your command line workflows.

→ [oh-my-posh Setup Guide](./Docs/oh-my-posh_Setup.md)

#### Visual Studio Code

[Visual Studio Code](https://code.visualstudio.com) (VScode) is a popular code editor choice. It's lightweight and powerful with built-in support for PowerShell, Git, extensions, debugging and more. VScode is the primary editor used in this project for writing, testing, and managing PowerShell scripts efficiently, and the tutorials will be mainly based on VScode.

→ [Recommended VSCode Setup and Extensions](./Docs/VScode_Setup.md)

## Projects & Modules

### Start-FastCopy – Controlled Folder-by-Folder Copying via FastCopy

Project Start-FastCopy is a modular PowerShell wrapper designed to automate and control folder-level data transfers using the FastCopy free software. It provides an interface with control over speed, verification, simulation, and delay between folder transfers. This script is ideal for conducting copying multiple folders of size 50-100GB to a backup folder. Key features include:

- Automated Per-subfolder copying from source to target directory
- Set speed control with FastCopy presets at the terminal: full, autoslow, suspend, or custom (1–9)
- Post-copy file verification toggle
- Dry run simulation using FastCopy’s /no_exec
- Optional thermal throttling with adjustable delay between folders
- Path to FastCopy.exe executable configuration via config.json
- Interactive confirmation with PowerShell ShouldProcess feature

→ Check out the [Start-FastCopy README](./Project_Start-FastCopy/README.md)

### Simple-Functions - Small Scripts for Terminal Fun & Utility

The SimpleFunctions folder contains a growing collection of lightweight, self-contained PowerShell functions designed for fun, learning, and daily scripting enhancements. These scripts are ideal for exploring how to use loops, output formatting, animation tricks, and terminal interactivity in PowerShell.

Examples Include:

- `./Build-PowerShellBanner`: Renders a ASCII art of PowerShell in different fonts and a scanner-style animation
- Show-Triangle: Prints an expanding triangle row by row
- Show-Spiner: Displays a small ASCII spiner that just spins!

More fun and visual terminal scripts on the way!

While not tied to automation tasks, these functions are great for building intuition about PowerShell scripting and experimenting with creative terminal outputs.

→ Browse the [Collection_Simple-Functions README](./Collection_Simple-Functions/README.md)

## Feedback

Questions, issues, or suggestions are welcome!
If you find these scripts useful or have ideas for improvements, feel free to [open an issue](https://github.com/Alexander-556/PowerShellScripts/issues) or submit a pull request.

## Author

**Jialiang Chang** — undergraduate student, currently self-learning PowerShell scripting.  
This repository serves as both a learning log and a collection of practical scripts for everyday automation tasks.
Feel free to explore, adapt, and reuse anything that helps your workflow.

## License

This project is licensed under the [MIT License](LICENSE).  
You're free to use, modify, and share this code — just include attribution when you do.
