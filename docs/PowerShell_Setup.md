# PowerShell Setup

This guide will help you set up latest PowerShell environment on Windows.

- [PowerShell Setup](#powershell-setup)
  - [Installation of PowerShell 7.5](#installation-of-powershell-75)
  - [Config PowerShell](#config-powershell)

## Installation of PowerShell 7.5

In this repository, I work on PowerShell 7.5, available through [this link from microsoft](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5). You can install through msi installer or `winget` which is recommended by microsoft. You can install PowerShell 7.5 through the following steps using `winget`:

Since [PowerShell 5.1](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_windows_powershell_5.1?view=powershell-5.1) is built into windows, we can launch PowerShell 5.1 by first pressing `Win + R`, then type `powershell` and hit `Enter`. A terminal window should pop up. We will type the commands in the terminal window.

Before you start installing, you can check the version of PowerShell you are using by typing the following and hit `Enter`

```powershell
$Host.Version
```

For example, Windows default PowerShell 5 would may output something like:

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

Now, we can start installing PowerShell 7.5. First, search for the latest version of PowerShell with

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

Also notice that installing PowerShell 7.5 doesn't mean it replaces PowerShell 5.1. According to this link: [Side-by-Side](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.5#using-powershell-7-side-by-side-with-windows-powershell-51), PowerShell 5, 6, and 7 each install to

- Windows PowerShell 5.1: `$Env:windir\System32\WindowsPowerShell\v1.0`
- PowerShell 6.x: `$Env:ProgramFiles\PowerShell\6`
- PowerShell 7: `$Env:ProgramFiles\PowerShell\7`

This means that you can use PowerShell 5.1 and 7 at the same time, which is great for compatibility. But since installing new version of powershell doesn't replace the old one, you should always be aware of the version of the PowerShell you are working with. Again, to check your PowerShell version, use

```powershell
$host.Version
```

or use

```powershell
Get-Host
```

and look at `Version`. More detailed documentation can be found at Microsoft official documentation on [Get-Host](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-host?view=powershell-7.5).

I recommend you use PowerShell 7, but you can also consult the following official articles from microsoft:

- [Differences between Windows PowerShell 5.1 and PowerShell 7.x](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/differences-from-windows-powershell?view=powershell-7.5)
- [Migrating from Windows PowerShell 5.1 to PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.5)

and make your own decisions for which version to use based on your needs.

## Config PowerShell

The configuration of PowerShell 7.5 will continue after we setup the terminal we want to use.
