function Add-Quotes {
    <#
.SYNOPSIS
Wraps the given string in double quotes.

.DESCRIPTION
This function returns the input string enclosed in double quotes. 
It is most commonly used to safely quote file or folder paths 
before passing them to external tools or command-line utilities 
that require quoted arguments when spaces are present.

Typical use cases include:
- Quoting file paths with spaces for tools like FastCopy, robocopy, etc.
- Wrapping arguments passed into scripts for safe command-line evaluation

.PARAMETER path
The input string (typically a file or folder path) to be quoted.

.OUTPUTS
System.String
Returns a new string containing the quoted version of the input.

.EXAMPLE
Add-Quotes -Path C:\Users\shcjl\Downloads

Returns:
"C:\Users\shcjl\Downloads"

.EXAMPLE
Add-Quotes -Path 'C:\My Folder\Projects'

Returns:
"C:\My Folder\Projects"

.NOTES
Author: Jialiang Chang
Version: 1.0
Last Updated: 2025-05-24
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string]$path
    )

    # Return the string wrapped in literal double quotes.
    # Use backtick (`) to escape the quote symbol in PowerShell.
    process {
        "`"$path`""
    }
}