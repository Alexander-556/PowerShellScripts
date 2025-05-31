# PowerShell Setup

- [PowerShell Setup](#powershell-setup)
  - [Installation of PowerShell 7.5](#installation-of-powershell-75)
    - [Verify Winget command](#verify-winget-command)
    - [Installation Command](#installation-command)
  - [Things to Keep in Mind](#things-to-keep-in-mind)
    - [Verify Your PowerShell Version](#verify-your-powershell-version)
      - [PowerShell 5.1 and 7.5 Compatibility](#powershell-51-and-75-compatibility)
      - [Check PowerShell Version](#check-powershell-version)
      - [Launch Your Desired PowerShell Version](#launch-your-desired-powershell-version)
  - [PowerShell Configurations](#powershell-configurations)

This guide will help you set up latest PowerShell environment on Windows. If you would like to learn more about PowerShell before installation, please click the link and visit [A Brief Introduction on PowerShell](./PowerShell_Intro.md).

## Installation of PowerShell 7.5

In this repository, I work on PowerShell 7.5, available through [this link from microsoft](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5). You can install through msi installer or `winget`, the Windows Package Manager. Microsoft recommends installing PowerShell 7.5 using `winget`, here's how:

### Verify Winget command

Since `winget` is a command-line tool, we need to launch [PowerShell 5.1](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_windows_powershell_5.1?view=powershell-5.1) first. This shell is built into windows, and we can launch it by first pressing `Win + R`, then type `powershell` and hit `Enter`. A terminal window should pop up. We will type the commands in the terminal window.

Check if your computer has `winget` by typing

```powershell
winget --Version
```

If the terminal says:

```powershell
winget: The term 'winget' is not recognized as a name of a cmdlet, function, script file, or executable program.
Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
```

then this means you need to install `winget`. Please go to this [Winget Installation Guide](Winget_Setup.md) for more details.

If your terminal displays a version number like

```powershell
> winget --version
v1.10.390
```

then you are all set with `winget` and ready to install PowerShell 7.5.

### Installation Command

First, search for the latest version of PowerShell with

```powershell
winget search Microsoft.PowerShell
```

You would see the following output as of May 29th, 2025:

```powershell
Name               Id                           Version Source
---------------------------------------------------------------
PowerShell         Microsoft.PowerShell         7.5.1.0 winget
PowerShell Preview Microsoft.PowerShell.Preview 7.6.0.4 winget
```

Then install PowerShell 7.5.1, the stable version, with

```powershell
winget install --id Microsoft.PowerShell --source winget
```

By this step, PowerShell 7.5 should be installed on your computer and ready to use.

## Things to Keep in Mind

### Verify Your PowerShell Version

#### PowerShell 5.1 and 7.5 Compatibility

According to [this documentation from Microsoft](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.5#using-powershell-7-side-by-side-with-windows-powershell-51), Installing PowerShell 7.5 doesn't mean it replaces PowerShell 5.1., PowerShell 5, 6, and 7 each installs to

- Windows PowerShell 5.1: `$Env:windir\System32\WindowsPowerShell\v1.0`
- PowerShell 6.x: `$Env:ProgramFiles\PowerShell\6`
- PowerShell 7: `$Env:ProgramFiles\PowerShell\7`

This means that you can use PowerShell 5.1 and 7 at the same time, which is great for compatibility. I recommend you use PowerShell 7, but you can also consult the following official articles from microsoft:

- [Differences between Windows PowerShell 5.1 and PowerShell 7.x](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/differences-from-windows-powershell?view=powershell-7.5)
- [Migrating from Windows PowerShell 5.1 to PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.5)

and make your own decisions for which version to use based on your needs.

#### Check PowerShell Version

Since installing new version of powershell doesn't replace the old one, you should always be aware of the version of the PowerShell you are working with. To check your PowerShell version, use

```powershell
$Host.Version
```

Windows default PowerShell 5 would may output something like:

```powershell
Major  Minor  Build  Revision
-----  -----  -----  --------
5      1      22621  4391
```

If you have the PowerShell 7.5 installed, you would see something like:

```powershell
Major  Minor  Build  Revision
-----  -----  -----  --------
7      5      1      -1
```

Note that if you see "-1" in your version data, don't panic, and there is nothing wrong. According to [Microsoft Documentation for .NET System.Version Class](https://learn.microsoft.com/en-us/dotnet/fundamentals/runtime-libraries/system-version), "-1" just means this value has not been explicitly set.

#### Launch Your Desired PowerShell Version

If you just successfully installed PowerShell 7.5, but you didn't see the correct version number. It's possible that you are using the PowerShell 5.1 terminal. By default, it can be very confusing sometimes. Here is a way to make sure you are using the correct version of powershell.

Press `Win + R` to invoke the Windows Run menu.

- Type "powershell" if you want to run PowerShell 5.1
- Type "pwsh" if you want to run PowerShell 7.5

This works because according to [this documentation](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/differences-from-windows-powershell?view=powershell-7.5#renamed-powershellexe-to-pwshexe), compared to version 5.1, Microsoft renamed PowerShell 7.5 executable from `powershell.exe` to `pwsh.exe` for clear distinction.

## PowerShell Configurations

To config PowerShell, you need to edit the profile file. You can do this by typing:

```powershell
notepad $PROFILE
```

The configuration of PowerShell 7.5 will continue after we setup the terminal we want to use.
