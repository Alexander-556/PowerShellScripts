# PowerShell Scripting Projects

This repository is a collection of powershell scripts and functions created to solve problems that are relevant to me. My main purpose for this repo is to learn powershell as a windows based automation tool to try to automate my daily routines.

## Repository Structure

```pgsql
PowerShellScripts/
├── FastCopyTools/           # Modular FastCopy automation wrapper
├── Simple_Functions/        # Small reusable PowerShell utilities
├── .gitignore               # Git ignore file log
├── LICENSE                  # MIT License for reuse
└── README.md                # This file
```

## Todos and Plans

This section presents the ideas for future developments in this repo. This todo list is updated frequently as development progresses.

### Current Work in Progress

- [ ] Finalize FastCopyTools module (argument parser, logging)
- [ ] Add README examples for each function in `Simple_Functions/`

### Future Project Plans

- [ ] Automate backup of key folders using Task Scheduler + FreeFileSYnc
- [ ] Automate journal logging
  - [ ] Create a journal file daily
  - [ ] Automate git pull several times per day
  - [ ] Automate git push changes at the end of day
- [ ] Build a tool to monitor disk health status with `smartctl`.
  - [ ] Log disk status with smartctl output
  - [ ] Save key data history and create visualization
  - [ ] Alert user of key events

### Documentation & Repo Enhancements

- [ ] Add screenshots and usage demos for main tools
- [ ] Add `FastCopyTools/README` file with setup guides and usage information for the tool
- [ ] Polish this repo README
  - [ ] Finish tool setup guide

## My tools

### The Shell

- PowerShell 7.5
- Windows Terminal
- oh-my-posh
- PSfzf

### PowerShell 7.5

I work on PowerShell 7.5, available through [this link from microsoft](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5). Install available through msi installer or `winget`, which is recommended by microsoft. You can install PowerShell 7.5 through the following steps:

Search for the latest version of PowerShell with

```powershell
winget search Microsoft.PowerShell
```

Install PowerShell with

````powershell
winget install --id Microsoft.PowerShell --source winget
````

Also notice that installing PowerShell 7.5 doesn't mean it replaces PowerShell 5.1. According to this link: [Side-by-Side](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.5#using-powershell-7-side-by-side-with-windows-powershell-51), PowerShell 5, 6, and 7 install to

- Windows PowerShell 5.1: `$Env:windir\System32\WindowsPowerShell\v1.0`
- PowerShell 6.x: `$Env:ProgramFiles\PowerShell\6`
- PowerShell 7: `$Env:ProgramFiles\PowerShell\7`

This means that you can use PowerShell 5.1 and 7 at the same time, which is great for compatibility. But you should also be aware of your current working PowerShell version when you are configuring your terminal, because it's quite easy to get confused. To check your PowerShell version, use

```powershell
Get-Host
```

and look at `Version`. More detailed documentation can be found at microsoft website [Get-Host](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-host?view=powershell-7.5).

I recommend you use PowerShell 7, but you can also consult the following official articles from microsoft:

- [Differences between Windows PowerShell 5.1 and PowerShell 7.x](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/differences-from-windows-powershell?view=powershell-7.5)
- [Migrating from Windows PowerShell 5.1 to PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.5)

and make your own decisions based on your needs.

### The Terminal

I mainly work on Windows, so Windows Terminal is my first choice for a terminal, available through the [microsoft store](https://apps.microsoft.com/detail/9n0dx20hk701?hl=en-US&gl=US). Compare to default Command Prompt and Windows PowerShell console, this one is a lot more modern. Some key features include tab support, different profile in one window, etc. For more details, consult the [Windows Terminal Official Documentation](https://learn.microsoft.com/en-us/windows/terminal/).

#### Personalization with `oh-my-posh`

For me, in order to fully engage myself with a shell through a terminal, customizing the terminal is a must. Luckily, there are quite a lot of native and third-party customizing options. Windows Terminal itself supports customizing color profile and many different appearance options. But for me, the default PowerShell appearance is just too boring, so I installed a prompt theme engine, [oh-my-posh](https://ohmyposh.dev). You can find the official documentation for downloading and configuring via the link, and the following is a summary of the setup process for Windows platform only.

##### Installation

You can install oh-my-posh via **winget**:

```powershell
winget install JanDeDobbeleer.OhMyPosh -s winget
```

where `-s winget` restricts the source of app package to winget, avoiding ambiguity with similarly named packages in other sources. Click the link for more information on [winget install command](https://learn.microsoft.com/en-us/windows/package-manager/winget/install). After winget installation, you can check if `oh-my-posh` is installed correctly by typing `oh-my-posh` into your terminal and hit `Enter`. If `oh-my-posh` is installed correctly, you should see the following output:

````powershell
oh-my-posh is a cross platform tool to render your prompt.
It can use the same configuration everywhere to offer a consistent
experience, regardless of where you are. For a detailed guide
on getting started, have a look at the docs at https://ohmyposh.dev

Usage:
  oh-my-posh [flags]
  oh-my-posh [command]

Available Commands:
  cache       Interact with the oh-my-posh cache
  config      Interact with the config
  debug       Print the prompt in debug mode
  disable     Disable a feature
  enable      Enable a feature
  font        Manage fonts
  get         Get a value from oh-my-posh
  help        Help about any command
  init        Initialize your shell and config
  notice      Print the upgrade notice when a new version is available.
  print       Print the prompt/context
  toggle      Toggle a segment on/off
  upgrade     Upgrade when a new version is available.
  version     Print the version

Flags:
  -c, --config string   config file path
  -h, --help            help for oh-my-posh
  -i, --init            init
  -s, --shell string    shell
      --version         print the version number and exit

Use "oh-my-posh [command] --help" for more information about a command.
````

If you receive a "'oh-my-posh' is not recognized as an internal or external command" error, it likely means that the folder containing the `oh-my-posh.exe` binary was not added to your system's `PATH` environment variable.

By default, oh-my-posh is installed to

````path
C:\Users\<YourUsername>\AppData\Local\Programs\oh-my-posh\bin
````

To use `oh-my-posh` from any terminal window, add this folder to the system `PATH`. Here's how

1. Press `Win + I` to open windows settings
2. Click "System" on the left column
3. Scroll down on the right and click "About"
4. Under "Related Settings," click "Advanced System Settings"
5. The "System Properties" window will pop up, in which, find "Environment Variables" button and click it
6. Then, under "System Variables" select "Path" and click the "Edit" button
7. Now you have entered the edit variables page, click "New" on the right to create a new entry
8. Paste your `oh-my-posh` binary path `C:\Users\<YourUsername>\AppData\Local\Programs\oh-my-posh\bin` into the entry and hit `Enter`
(Replace \<YourUsername\> with your actual Windows username)
9. Now you have added a new `Path` environment variable to your system
10. Save your settings by clicking "OK" on each settings window
11. Close and restart your terminal to load new environment variable
12. Check again by running command `oh-my-posh`

For more information about environment variables and the `PATH` mechanism, check out this helpful explanation: [StackExchange website](https://superuser.com/questions/284342/what-are-path-and-other-environment-variables-and-how-can-i-set-or-use-them).

##### Fonts

oh-my-posh themes often require a Nerd Font to render glyphs and icons properly. By default, oh-my-posh official documentation recommends installation of their recommended Meslo Nerd font through

```powershell
oh-my-posh font install meslo
```

but if this doesn't work for you, you can manually go to [Nerd Fonts](https://www.nerdfonts.com), and download MesloLG Nerd Font.

1. Locate Meslo in the list and download the MesloLG NF complete font zip
2. Extract the zip
3. Install the font by:
   1. Selecting every .ttf file that contains the name "MesloLGMNerdFont"
   2. Right click
   3. Selecting Install for all users (recommended for system-wide use and compatibility with all terminal profiles)

After the font is installed, you need to configure Windows Terminal to use it as the default font:

1. Launch Windows Terminal
2. Open the settings by pressing `Ctrl + ,` or using the dropdown arrow in the tab bar → Settings
3. In the Settings UI, go to Profiles > Defaults
4. Select the Appearance tab
5. Find "Font face" and enter: "MesloLGM Nerd Font"
6. Click save (bottom right corner)

Note: If Windows Terminal cannot find the font, it will silently fall back to the default one. So if nothing changed after you changed the settings, check if the font is installed and whether the "Font Face" settings entry is correct.

Once this is set, any oh-my-posh theme that relies on Nerd Fonts will display correctly across PowerShell and other shells running in Windows Terminal.

##### Configuring Your PowerShell Profile

#### Useful Utilities

##### PSfzf

### Code Editing and Version Control

- Visual Studio Code
- Git

### Other Relevant Tools

- [FastCopy](https://fastcopy.jp/) for relevant scripts

## Projects & Modules

### `Project_Start-FastCopy/`

My first project is a function called Start-FastCopy, this is a wrapper around [FastCopy](https://fastcopy.jp/) for controlled, folder-by-folder file copying with:

- Adjustable speed modes (full, autoslow, suspend, or custom)
- Optional post-copy file verification
- Customizable delay between transfers
- Support for simulation (`-WhatIf`, `-Exec 0`)
- Modular helper functions and clean logging

See FastCopy Project README → `Project_Start-FastCopy/README.md` for more information

### `Simple_Functions/`

Smaller standalone utilities and learning demos, including:

Great for learning, experimentation, and inclusion in larger projects.

## Feedback

Issues and suggestions are welcome!  
If you find these scripts useful, feel free to open an [issue](https://github.com/your-user-name/your-repo-name/issues) or submit a pull request.

## Author

Jialiang Chang, undergraduate student. Currently self-learning powershell scripting language.
This repository serves as both a learning log and a utility hub for everyday scripting problems. Feel free to use my scripts if you find them useful.

## License

This repository is released under the **MIT License**.  
Feel free to use, adapt, and share — with credit where due.

---

Last updated: 2025-05-24
