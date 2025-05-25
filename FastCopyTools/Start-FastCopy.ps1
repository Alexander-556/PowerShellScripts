# Import the module from a relative path
Import-Module -Name "$PSScriptRoot\FastCopyTools\FastCopyTools.psd1" -Force

# Now call Start-FastCopy which depends on the helper functions
Start-FastCopy -SourceFolder "D:\Data" -TargetFolder "G:\Backup" -Mode "full"
