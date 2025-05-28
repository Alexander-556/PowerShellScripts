# PowerShell Setup

## The Shell and Terminal

- PowerShell 7.5
  - oh-my-posh
  - PSfzf
- Windows Terminal

## PowerShell 7.5

I work on PowerShell 7.5, available through [this link from microsoft](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5). You can install through msi installer or `winget` which is recommended by microsoft. You can install PowerShell 7.5 through the following steps:

As [PowerShell 5.1](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_windows_powershell_5.1?view=powershell-5.1) is built into windows, we can launch PowerShell 5.1 by first pressing `Win + R`, then type `powershell` and hit `Enter`. A terminal window should pop up. We will type the commands in the terminal window.

Search for the latest version of PowerShell with

```powershell
winget search Microsoft.PowerShell
```

Install PowerShell with

```powershell
winget install --id Microsoft.PowerShell --source winget
```

Also notice that installing PowerShell 7.5 doesn't mean it replaces PowerShell 5.1. According to this link: [Side-by-Side](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.5#using-powershell-7-side-by-side-with-windows-powershell-51), PowerShell 5, 6, and 7 install to

- Windows PowerShell 5.1: `$Env:windir\System32\WindowsPowerShell\v1.0`
- PowerShell 6.x: `$Env:ProgramFiles\PowerShell\6`
- PowerShell 7: `$Env:ProgramFiles\PowerShell\7`

This means that you can use PowerShell 5.1 and 7 at the same time, which is great for compatibility. But since installing new version of powershell doesn't replace the old one, you should be aware of the version of the PowerShell you are working with. To check your PowerShell version, use

```powershell
Get-Host
```

and look at `Version`. More detailed documentation can be found at microsoft website [Get-Host](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-host?view=powershell-7.5).

I recommend you use PowerShell 7, but you can also consult the following official articles from microsoft:

- [Differences between Windows PowerShell 5.1 and PowerShell 7.x](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/differences-from-windows-powershell?view=powershell-7.5)
- [Migrating from Windows PowerShell 5.1 to PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.5)

and make your own decisions based on your needs.

## The Terminal

I mainly work on Windows, so Windows Terminal is my first choice for a terminal, available through the [microsoft store](https://apps.microsoft.com/detail/9n0dx20hk701?hl=en-US&gl=US). Compare to default Command Prompt and Windows PowerShell console, this one is a lot more modern. Some key features include tab support, different profile in one window, etc. For more details, consult the [Windows Terminal Official Documentation](https://learn.microsoft.com/en-us/windows/terminal/).
