# oh-my-posh Setup Guide

This guide provides a detailed walkthrough for setting up and customizing `oh-my-posh` on Windows, transforming the default PowerShell terminal into a visually appealing and personalized workspace. It covers installation via winget, configuring the `PATH` environment variable, installing Nerd Fonts for proper theme rendering, and modifying the PowerShell profile to enable `oh-my-posh`. Additionally, it explains how to change themes using the built-in theme gallery and provides troubleshooting tips for common issues. By following this guide, you can create a much more engaging and functional terminal experience.

---

- [oh-my-posh Setup Guide](#oh-my-posh-setup-guide)
  - [Personalization with oh-my-posh](#personalization-with-oh-my-posh)
    - [Installation](#installation)
      - [Environment Variable](#environment-variable)
    - [Fonts](#fonts)
    - [Configuring Your PowerShell Profile with oh-my-posh](#configuring-your-powershell-profile-with-oh-my-posh)
      - [IMPORTANT TROUBLESHOOT NOTICE](#important-troubleshoot-notice)
        - [Method 1: Set-ExecutionPolicy](#method-1-set-executionpolicy)
        - [Method 2: Sign your scripts](#method-2-sign-your-scripts)
    - [Change Your oh-my-posh Theme](#change-your-oh-my-posh-theme)

## Personalization with oh-my-posh

For me, in order to fully engage myself with a shell through a terminal, customizing the terminal is a must. Luckily, there are quite a lot of native and third-party customizing options. Windows Terminal itself supports customizing color profile and many different appearance options. But for me, the default PowerShell appearance is just too boring, so I installed a prompt theme engine, [oh-my-posh](https://ohmyposh.dev). You can find the official documentation for downloading and configuring via the link, and the following is a summary of the setup process for Windows platform only.

### Installation

Following the [official documentation on installation](https://ohmyposh.dev/docs/installation/windows), you can install `oh-my-posh` and a package of builtin themes via winget:

```powershell
winget install JanDeDobbeleer.OhMyPosh -s winget
```

where `-s winget` restricts the source of app package to winget, avoiding ambiguity with similarly named packages in other sources. Click the link for more information on [winget install command](https://learn.microsoft.com/en-us/windows/package-manager/winget/install). After winget installation, you can check if `oh-my-posh` is installed correctly by typing in your terminal

```powershell
oh-my-posh
```

and hit `Enter`. If `oh-my-posh` is installed correctly, you should see the following output:

```powershell
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
```

If you receive an error saying:

```powershell
oh-my-posh: The term 'oh-my-posh' is not recognized as a name of a cmdlet, function, script file, or executable program.
Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
```

it likely means that the folder containing the `oh-my-posh.exe` binary was not added to your system's `PATH` environment variable.

#### Environment Variable

By default, `oh-my-posh` is installed to

```path
C:\Users\<YourUsername>\AppData\Local\Programs\oh-my-posh\bin
```

To use `oh-my-posh` from any terminal window, add this folder to the system `PATH`. Here's how

1. Press `Win + I` to open windows settings
2. Click "System" on the left column
3. Scroll down on the right and click "About"
4. Under "Related Settings," click "Advanced System Settings"
5. The "System Properties" window will pop up, in which, find "Environment Variables" button and click it
6. Then, under "System Variables" select "Path" and click the "Edit" button
7. Now you have entered the edit variables page, click "New" on the right to create a new entry
8. Paste your `oh-my-posh` binary path `C:\Users\<YourUsername>\AppData\Local\Programs\oh-my-posh\bin` into the entry and hit `Enter`
   (Replace <YourUsername\> with your actual Windows username)
9. Now you have added a new `Path` environment variable to your system
10. Save your settings by clicking "OK" on each settings window
11. Close and restart your terminal to load new environment variable
12. Check again by running command `oh-my-posh`

For more information about environment variables and the `PATH` mechanism, check out this helpful explanation: [SuperUser](https://superuser.com/questions/284342/what-are-path-and-other-environment-variables-and-how-can-i-set-or-use-them). If you came from [PowerShell Setup Guide](./PowerShell_Setup.md#how-to-configure-powershell) to take a look at how to configure the environment variable, feel free to use the link to go back.

### Fonts

`oh-my-posh` themes often require a Nerd Font to render glyphs and icons properly. By default, `oh-my-posh` [official documentation on fonts](https://ohmyposh.dev/docs/installation/fonts) recommends installation of their recommended Meslo Nerd font through

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
2. Open the settings by pressing `Ctrl + ,` or using the dropdown arrow in the tab bar then go to Settings
3. In the Settings UI, go to Profiles > Defaults
4. Select the Appearance tab
5. Find "Font Face" and enter: "MesloLGM Nerd Font"
6. Click save (bottom right corner)

Note: If Windows Terminal cannot find the font, it will silently fall back to the default one. So if nothing changed after you changed the settings, check if the font is installed and whether the "Font Face" settings entry is correct. The entry has to be verbatim.

Once this is set, any `oh-my-posh` theme that relies on Nerd Fonts will display correctly across PowerShell and other shells running in Windows Terminal.

### Configuring Your PowerShell Profile with oh-my-posh

Now, `oh-my-posh` is almost ready, but your terminal window is still in its default shape. To enable `oh-my-posh` appearance, you can follow `oh-my-posh` [official documentation on prompt](https://ohmyposh.dev/docs/installation/prompt). Here is a summary for your convenience.

To enable `oh-my-posh` appearance, you need to change your default PowerShell profile, which you can find by typing this into your terminal:

```powershell
notepad $PROFILE
```

This above command line will open PowerShell default profile with notepad as we discussed earlier. If this doesn't work, please reference additional troubleshooting instruction in the [official documentation on prompt](https://ohmyposh.dev/docs/installation/prompt).

If you are able to open the default profile, add the following as the last line to your PowerShell profile script:

```powershell
oh-my-posh init pwsh | Invoke-Expression
```

After you add the line, save the file, and then use

```powershell
. $PROFILE
```

to reload the profile for the changes to take effect. Now, you should be able to see that your terminal has a different appearance, which is the default `oh-my-posh` theme.

#### IMPORTANT TROUBLESHOOT NOTICE

When running scripts, you might encounter an error saying that your scripts cannot be executed because of the execution policy, an error message that might look like this:

```powershell
File C:\example.ps1 cannot be loaded because the execution of scripts is disabled on this system. Please see "get-help about_signing" for more details.
At line:1 char:13
+ .\example.ps1 <<<<
+ CategoryInfo : NotSpecified: (:) [], PSSecurityException
+ FullyQualifiedErrorId : RuntimeException
```

This error is caused by the PowerShell execution policy. It only allows trusted (signed) scripts to be executed for security. There are two ways to bypass this error.

##### Method 1: Set-ExecutionPolicy

You can start Windows PowerShell with the "Run as Administrator" option, and then run the following command in your PowerShell:

```powershell
Get-ExecutionPolicy
```

This command will tell you which execution policy you are on. If you have the above error, you might see the output:

```powershell
> Get-ExecutionPolicy
Restricted
```

To change the policy, run the following command:

```powershell
Set-ExecutionPolicy remotesigned
```

You have to run PowerShell as an admin because only members of the Administrators group on the computer can change the execution policy. This command will allow running unsigned scripts that you write on your local computer and signed scripts from Internet, and the command will change the policy permanently. For more details on execution policies on PowerShell, check out Microsoft's official documentation and the SuperUser discussion thread.
👉 [About Execution Policies](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.5#restricted)
👉 [SuperUser Discussion](https://superuser.com/questions/106360/how-to-enable-execution-of-powershell-scripts)

##### Method 2: Sign your scripts

Typically, the above commands should solve your problems. So, I might not dig too deep on how to sign your scripts. But if you want to take a step further and do that, please use the following link to Microsoft's official documentation:
👉 [About Signing](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_signing?view=powershell-7.5)

### Change Your oh-my-posh Theme

The theme previews are available through this link to the [Theme Gallery](https://ohmyposh.dev/docs/themes). Choose your favorite theme and take note of its name.

To change your theme, you need to modify your profile file. Open the file again by

```powershell
notepad $PROFILE
```

Your current `oh-my-posh` config line should look like:

```powershell
oh-my-posh init pwsh | Invoke-Expression
```

Now, use the `--config` option of `oh-my-posh` to change the theme, here's the command

```powershell
oh-my-posh init pwsh --config <PathToThemeFile> | Invoke-Expression
```

The location of builtin themes is

```path
C:\Users\<YourUsername>\AppData\Local\Programs\oh-my-posh\themes
```

Go to this folder, find the file of your favorite theme, for example, mine is

```path
probua.minimal.omp.json
```

Click on the file to choose it, then press `Ctrl + Shift + C` (default key binding to copy the path to the chosen file). In the command

```powershell
oh-my-posh init pwsh --config <PathToThemeFile> | Invoke-Expression
```

replace <PathToThemeFile\> with your path. For example, my command will be

```powershell
oh-my-posh init pwsh --config C:\Users\user\AppData\Local\Programs\oh-my-posh\themes\probua.minimal.omp.json | Invoke-Expression
```

Save this in your profile, and then use

```powershell
. $PROFILE
```

to reload. The terminal should display your chosen theme by this step.

---

This is the end of `oh-my-posh` basic setup and configuration. By now, you should already have a pretty good looking terminal window. Instead of looking into a boring black window, you can now customize the window that you are probably going to stare for hours. Hope you had fun during the setup process.

If you want to create some PowerShell tools like me, you can go visit my [VScode setup guide](./VScode_Setup.md) to check out some recommended extensions, settings, testing, and debug settings.
