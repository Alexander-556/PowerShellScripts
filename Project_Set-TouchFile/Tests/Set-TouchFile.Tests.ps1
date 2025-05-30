# Import the module
Import-Module "$PSScriptRoot\..\SetTouchFileTools.psd1" -Force

# Define the test suite
Describe "Set-TouchFile Function Tests" {

    It "Should create a new file when it doesn't exist" {
        $testPath = "$env:TEMP\pester_testfile.txt"
        if (Test-Path $testPath) { Remove-Item $testPath -Force }

        Set-TouchFile -filename "pester_testfile.txt" -desiredLocation $env:TEMP

        # Assert the file was created
        Test-Path $testPath | Should -BeTrue

        # Cleanup
        Remove-Item $testPath -Force
    }

    It "Should update the timestamp if file already exists" {
        $testPath = "$env:TEMP\pester_testfile.txt"
        Set-Content -Path $testPath -Value "Initial"
        $originalTime = (Get-Item $testPath).LastWriteTime

        Start-Sleep -Seconds 1
        Set-TouchFile -filename "pester_testfile.txt" -desiredLocation $env:TEMP
        $updatedTime = (Get-Item $testPath).LastWriteTime

        $updatedTime | Should -BeGreaterThan $originalTime

        Remove-Item $testPath -Force
    }

}
