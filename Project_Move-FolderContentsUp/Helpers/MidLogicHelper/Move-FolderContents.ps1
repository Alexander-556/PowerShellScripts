# * MidLogicHelper
function Move-FolderContents {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [PScustomObject[]]$folderObjArray
    )

    Write-Host "`nFile moving starts..."

    foreach ($folderObj in $folderObjArray) {

        if (-not $folderObj.Valid) {
            Write-Warning "Skipped a folder."
            continue
        }
        
        $fileObjArray = Get-ChildItem -Path $folderObj.Parent -Force

        foreach ($fileObj in $fileObjArray) {

            $targetFileObj = [PSCustomObject]@{
                Filename    = $fileObj.Name
                Destination = $folderObj.Parent
            }

            $targetFilePath = Join-Path `
                -Path $targetFileObj.Destination `
                -ChildPath $targetFileObj.Filename

            # * Handle name conflicts
            # * First determine user action

            if (Test-Path $targetFilePath) {
                Write-Warning "Conflict detected: '$($targetFileObj.Filename)' already exists in $($targetFileObj.Destination)."

                # You could skip, overwrite, or rename here
                $userAction = Confirm-FileConflict $targetFileObj $folderObj

                if ($userAction -eq "skip") {
                    continue
                }

                $targetFileObj = Deploy-UserAction $userAction $targetFileObj $folderObj
            }
            

            # * Finally moved the file
            $sourceFilePath = $fileObj.FullName
            $destinationFilePath = Join-Path `
                -Path $targetFileObj.Destination -ChildPath $targetFileObj.Filename
            
            Move-Item -Path $sourceFilePath -Destination $destinationFilePath
            Write-Verbose "Moved file '$sourceFilePath' to new path '$destinationFilePath'."
        }
    }
}