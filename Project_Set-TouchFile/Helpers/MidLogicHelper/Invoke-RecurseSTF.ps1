function Invoke-RecurseSTF {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$fullInputPath
    )

    # Step 1: Parse the input path into parent and leaf
    #         store the result in a path obj
    $fullInputPathObj = 
    Split-FilePath -inputPath $fullInputPath

    # Step 2: Feed them back into Set-TouchFile, recurse
    Set-TouchFile `
        -Filename $fullInputPathObj.Filename `
        -desiredLocation $fullInputPathObj.FileFolder

    # Step 3: after recurse call, program ends
}