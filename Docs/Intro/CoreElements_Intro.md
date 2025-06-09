# Understanding the Command Line: Operating System, Shell, and Terminal

If you have ever felt confused by words like "shell", "terminal", or even "operating system", you are not alone. These terms get thrown around a lot, but they are actually not that complicated once you break them down. In this guide, I will walk you through what each of these core elements means and how they work together to let you communicate with your computer. Understanding these basics will make everything about scripting and using this project a lot less intimidating.

---

- [Understanding the Command Line: Operating System, Shell, and Terminal](#understanding-the-command-line-operating-system-shell-and-terminal)
  - [What is an Operating System (OS)?](#what-is-an-operating-system-os)
  - [What is a Shell?](#what-is-a-shell)
  - [What is a Terminal?](#what-is-a-terminal)
  - [Feedbacks](#feedbacks)

## What is an Operating System (OS)?

The Operating System is the brain of your computer. It manages everything - your memory, files, devices, apps, and even how you interact with the system. It's the foundation that lets all your other programs function properly.

Common desktop operating systems include:

- **Windows**
  -- This is the OS used throughout this project.
- **macOS**
  -- Found on Apple computers.
- **Linux**
  -- A family of open-source systems used on servers, embedded devices, and desktops.

The OS is always working in the background to make sure your commands and programs behave as expected.

## What is a Shell?

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

## What is a Terminal?

Now that we have talked about the Shell and the OS, what exactly is the Terminal?

The Terminal is the application that hosts the shell - it’s the window where the conversation between you and your computer happens. You type commands into the terminal, the shell interprets them, and the OS gets the job done.

In simple terms:

- The Terminal is the environment where you type.

- The Shell is the tool that understands and runs your commands.

- The OS is what carries out the instructions.

By default, Windows is shipped with conhost.exe, short for Console Host. This application is the default terminal application built into Windows that hosts command-line shells like Command Prompt and PowerShell, providing a basic interface for executing commands. First appeared in Windows 7, this terminal is super old, and in [this article](https://learn.microsoft.com/en-us/windows/console/definitions), Microsoft says that even though "conhost.exe will continue to be responsible for API call servicing and translation," "the user-interface components are intended to be delegated through a pseudoconsole to a terminal."

Anyway, my point is that if you want to do some proper scripting and interaction with the terminal, conhost.exe is not recommended. There are a lot more other options that are far better than conhost.exe, here is an incomplete list just for example:

- [Hyper](https://hyper.is)
- [ConEmu](https://conemu.github.io)
- [Cmder](https://cmder.app)
- [ConsoleZ](https://github.com/cbucher/console)
- [FluentTerminal](https://github.com/felixse/FluentTerminal)
- [Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/)

In this project, I am using Windows Terminal, and I recommend you to use it too, because of its simplicity and functionality. If you don't like it, feel free to try the other listed terminals above. Or explore on your own. But, the default conhost.exe is not a great option anymore. It's always better to look into a modern window than the old-school black or blue ones.

---

Now that you have learned the basics about the operating system, shell, and terminal. For more advanced information on related concepts, you can also visit Scott Hanselman's article: [What's the difference between a console, a terminal, and a shell?](https://www.hanselman.com/blog/whats-the-difference-between-a-console-a-terminal-and-a-shell)

You are ready to move on and start using the tools in this project. Don’t worry if you are still new. Each tool comes with step-by-step setup guides to help you get started. You can use the following link to head back to the main README.

👉 [Continue from where you left](../../README.md#understanding-the-command-line)

---

## Feedbacks

If you found something confusing, unclear, or even just a bit off, feel free to [open an issue](https://github.com/Alexander-556/PowerShellScripts/issues/new). Whether it's a small question or a big suggestion, your feedback helps me improve these articles for everyone. And I’m still learning too, and I really appreciate every opportunity to make things better.
