# Windows Package Manager (Winget) Setup Guide

- [Windows Package Manager (Winget) Setup Guide](#windows-package-manager-winget-setup-guide)
  - [What is Winget?](#what-is-winget)
  - [Install Winget](#install-winget)
    - [Method 1: Download from Microsoft](#method-1-download-from-microsoft)
    - [Method 2: Download from GitHub](#method-2-download-from-github)

In this guide, you will learn some basic facts about the Windows Package Manager (Winget) and follow the steps to install winget on your computer.

## What is Winget?

Winget, short for Windows Package Manager, is a command-line tool designed to simplify software installation and management on Windows. If you are familiar with Linux systems, `winget` is similar to `apt-get` on Debian or `Pacman` on Arch Linux. Winget allows users to search, install, upgrade, and remove applications directly from the terminal.

However, winget is much less used on Windows compared to package managers on Linux because Windows users traditionally rely on graphical installers (msi) and app stores for software management. Despite this, winget provides a powerful alternative for automating software installation and updates, especially for people who prefer command-line tools. In our repository, since we are working with PowerShell, it's natural for us to use winget in our context.

## Install Winget

Winget is part of the Microsoft Store "App Installer" package. You can install the "App Installer" package in three different ways.

### Method 1: Download from Microsoft

You can download the Microsoft Store installer via [Microsoft Official Winget Documentation](https://learn.microsoft.com/en-us/windows/msix/app-installer/install-update-app-installer). Click on the link, and click the button "Download the Installer for the Latest version of App Installer."

![Winget MS Official](./../../Images/ScreenShots/2025-05-31%2016.57.56%20learn.microsoft.com%200e3130442853.jpg)

After you clicked on this link, your browser should initiate a download of a file with ".msixbundle" extension name. When download is complete, navigate to the browser download folder, and double click this ".msixbundle" file. A dialogue window will pop up, and by clicking "Install" button in the pop up window, winget should be installed on your computer.

### Method 2: Download from GitHub

You can also download the installer from GitHub via [Winget GitHub Repository](https://github.com/microsoft/winget-cli). Click on the GitHub link and find the latest release:

![Winget GitHub](./../../Images/ScreenShots/2025-05-31%2016.57.29%20github.com%2075d72213ed61.jpg)

Then in the "Assets", find the ".msixbundle" file, and click on it:

![Winget GitHub Assets](./../../Images/ScreenShots/2025-05-31%2017.02.17%20github.com%20261fee5a56ea.jpg)

Similar to the previous method, your browser should initiate a download. When the download is complete, navigate to the browser download folder and double click this ".msixbundle" file. A dialogue window will pop up, and by clicking "Install" button in the pop up window, winget should be installed on your computer.

---

Now, you should have completed installation of winget. Verify that installation has completed by typing into your terminal:

```powershell
winget --Version
```

If there are no errors and a version number shows up on your terminal. Your winget installation has succeeded, and you can continue [PowerShell Setup](./PowerShell_Setup.md#installation-command).
