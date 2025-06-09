# A Brief Introduction to PowerShell

This document is my attempt at providing a comprehensive introduction to PowerShell to beginners. The document mainly introduces PowerShell's key features and advantages to provide reasons to try out PowerShell. Explanations of some basic scripting and programming concepts are also included. If you found the explanation of any of the concepts confusing, or some key concepts are missing in this document. Please [leave an issue](https://github.com/Alexander-556/PowerShellScripts/issues/new), and I will try my best to produce a clear explanation.

---

- [A Brief Introduction to PowerShell](#a-brief-introduction-to-powershell)
  - [What is PowerShell?](#what-is-powershell)
  - [PowerShell vs. Command Prompt: Key Differences](#powershell-vs-command-prompt-key-differences)
    - [Object-based input/output](#object-based-inputoutput)
    - [Modern scripting capabilities](#modern-scripting-capabilities)
    - [Standardized command naming and built-in help](#standardized-command-naming-and-built-in-help)
  - [Core Concepts](#core-concepts)
    - [General Scripting Concepts](#general-scripting-concepts)
      - [Cmdlets](#cmdlets)
      - [Functions](#functions)
      - [Modules](#modules)
    - [Pipelines](#pipelines)
    - [General Programming Concepts](#general-programming-concepts)
      - [Variables](#variables)
      - [Control Flow](#control-flow)
    - [PowerShell-Specific Concepts](#powershell-specific-concepts)
      - [Get-Help and Verb-Noun Naming Convention](#get-help-and-verb-noun-naming-convention)
      - [Error Handling](#error-handling)
  - [Cmdlets to try](#cmdlets-to-try)
    - [Basic Cmdlets](#basic-cmdlets)
    - [File Operation](#file-operation)
    - [Pipeline Practice](#pipeline-practice)
  - [Feedbacks](#feedbacks)

## What is PowerShell?

[PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.5) is a powerful automation platform developed by Microsoft. It combines a shell with a robust scripting language, all built on the .NET runtime. In our case, PowerShell allows us to automate tasks and solve everyday Windows annoyances with ease, thanks to its deep integration with the operating system.

## PowerShell vs. Command Prompt: Key Differences

Most Windows users are more familiar with the Command Prompt (cmd.exe), the black box that handles basic commands like `dir`, `copy`, `ping`, or `ipconfig`. Its history goes all the way back to the MS-DOS days. While CMD has served well for decades, it's showing its age in today’s more complex computing environment. PowerShell, on the other hand, is a modern, more powerful tool designed to meet today’s automation needs.

Here are some key advantages of PowerShell over Command Prompt:

### Object-based input/output

PowerShell doesn't just deal with plain text. It works with structured objects, which means the output from one command can be passed to another with full access to properties and values. This feature allows for superior coding flexibility.

### Modern scripting capabilities

PowerShell supports variables, conditional logic, loops, functions, modules, and robust error handling, all the tools you will need and everything you would expect from a full scripting language.

### Standardized command naming and built-in help

PowerShell uses a consistent [Verb-Noun format](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-7.5) like `Get-Process` or `Set-TimeZone`. This makes it easier to guess, discover, and remember commands. Plus, the [Get-Help](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/02-help-system?view=powershell-7.5) command provides detailed syntax, parameter explanations, and usage examples right from the terminal.

---

Combined with PowerShell's native integration into Windows, we can write scripts that easily interact with files, scheduled tasks, system settings, event logs, services, and even the registry. This opens up a wide range of possibilities for system automation and customization.

I hope the above paragraphs have given you enough reasons to at least give PowerShell a try. In the following sections, we’ll go over some of PowerShell’s core concepts, the building blocks that will help you become confident with this tool.

If you're ever curious to explore further, Microsoft has an excellent, beginner-friendly documentation site here:
👉 [Microsoft PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/scripting/how-to-use-docs?view=powershell-7.5)

## Core Concepts

Just like other scripting and programming languages, PowerShell has its own set of fundamental concepts. These can be grouped into three main categories:

### General Scripting Concepts

These are the basics you'll encounter early on when using PowerShell as a shell or scripting tool:

#### Cmdlets

Pronounced "command-lets", these are the building blocks of PowerShell. Each cmdlet is a small, single-function command written in the Verb-Noun format (e.g., `Get-Process`, `Set-Date`). Cmdlets are designed to do one thing well and can be easily combined with others.

For more details, on Cmdlets, go visit Microsoft's official documentation on:
👉 [Introduction of Cmdlets](https://learn.microsoft.com/en-us/powershell/scripting/powershell-commands?view=powershell-7.5)
👉 [Detailed Overview of Cmdlets](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-overview?view=powershell-7.5)

#### Functions

PowerShell lets you define your own functions to group reusable blocks of code under a custom name. This is especially helpful when you want to make your code modular by encapsulate logic that you might use multiple times throughout a script. Functions are written using the `function` keyword and can accept parameters just like cmdlets.

As you grow more comfortable with scripting, writing your own functions becomes second nature and gives your scripts more structure and clarity. For more detailed information on functions, check out the following links to Microsoft's official PowerShell documentations:
👉 [About Functions](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.5)
👉 [About Advanced Functions](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced?view=powershell-7.5)

#### Modules

Modules are collections of PowerShell tools grouped together to make them easier to use and reuse. You can think of a module as a toolbox that adds new capabilities to your PowerShell environment.

PowerShell includes many built-in modules, and you can also download more from the internet or create your own later on. Modules are useful because they help organize code, avoid duplication, and make your scripts more powerful without writing everything from scratch.

More details on modules can be found at Microsoft's official documentation:
👉 [About Modules](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_modules?view=powershell-7.5)

### Pipelines

Similar to Unix-like shells (like Bash or Zsh), PowerShell also supports the use of pipelines using the `|` operator. This operator lets you pass the output of one command directly into another, making it possible to chain commands together in a clean and readable way.

The pipeline is especially handy when writing compact, powerful one-liners, allowing you to filter, sort, and transform data step by step, all in a single command.

👉 [About Pipelines](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pipelines?view=powershell-7.5)

### General Programming Concepts

In addition, PowerShell isn't just a command-line shell. It's a scripting language, and it supports many features common to other programming languages:

#### Variables

You can store values in variables using the \$ sign (e.g., $value = 1). Variables can hold strings, numbers, arrays, and objects. Typically, scripting language don't require a type declaration when you initialize the variable, and the type is usually determined during the interpretation of the code.

#### Control Flow

PowerShell gives you access to if statements, loops (for, foreach, while), and switch cases. These are all the control flow tools you would expect from a programming language.

Check out PowerShell's key words with the following link:
👉 [About Keywords](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_keywords?view=powershell-7.5)

### PowerShell-Specific Concepts

These are features that make PowerShell especially well-suited for automation in the Windows environment:

#### Get-Help and Verb-Noun Naming Convention

One of the most beginner-friendly features of PowerShell is its built-in help system. If you're ever unsure what a command does or how to use it, just run:

```powershell
Get-Help Get-Process
```

This above command will show you a detailed explanation of the `Get-Process` cmdlet, including its description, parameters, and usage examples. You can also use these helpful flags:

```powershell
Get-Help Get-Process -Examples # Show examples
Get-Help Get-Process -Detailed # Show some detailed information
Get-Help Get-Process -Online   # Open the official docs in your browser
```

Further, as we discussed earlier, the Verb-Noun naming convention in PowerShell is very helpful in understanding Cmdlets and makes searching for them vey easy. For example

`Get-Process` retrieves information about running processes

`Set-Location` sets the working directory for the shell

`Start-Services` starts a Windows service

`Remove-Item` deletes a file or folder

`New-Item` creates a file or folder

This naming system is not only intuitive, but also makes commands easier to guess and search for. If you want to explore more verbs you can use, run:

```powershell
Get-Verb
```

or visit the [Microsoft Approved Verbs Documentation](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-7.5).

#### Error Handling

Since we are usually directly communicating with the Windows Operating System, proper error handling becomes very important to us. When writing automation scripts, we don't want fatal errors to come uncaught, and we also don't want a stream of "Unexpected Error" during debugging. That could be a nightmare. Luckily, PowerShell provides structured error handling using try, catch, and finally blocks. You run code that might go wrong in the try block. If some error occurred in the try block, code in the catch block will execute. Code in Finally block will always execute regardless of the error state. This allows you to build robust scripts that can customize error message and handle unexpected problems without crashing.

While just reading about these features could be boring. I suggest you to try these `try`, `catch`, and `finally` code blocks when you are comfortable with scripting. Just explore their behavior and you will see the value of these seemingly simple code blocks.

## Cmdlets to try

_Work in Progress..._

To give you a helpful start in using PowerShell, here are some example cmdlets that you can easily try after you set up your PowerShell environment

### Basic Cmdlets

```powershell
Get-Date
```

Displays the current date and time.

```powershell
Get-Process
```

Lists all currently running processes.

```powershell
Set-Location C:\Users
```

Navigates to a different folder (like cd in CMD or Bash).

### File Operation

### Pipeline Practice

---

## Feedbacks

If you found something confusing, unclear, or even just a bit off, feel free to [open an issue](https://github.com/Alexander-556/PowerShellScripts/issues/new). Whether it's a small question or a big suggestion, your feedback helps me improve these articles for everyone. And I’m still learning too, and I really appreciate every opportunity to make things better.
