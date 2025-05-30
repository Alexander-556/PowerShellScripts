# Test suite for Set-TouchFile in Quick Access Mode
Describe "Set-TouchFile Function Tests for Quick Access Mode" {

    BeforeAll {
        # Dot-source the script once before all tests
        . "$PSScriptRoot\..\Set-TouchFile.ps1" -Force
    }

    It "Should create a new file when it doesn't exist" {
        # Arrange the location of test
        $testPath = "$env:TEMP\pester_testfile.txt"
        if (Test-Path $testPath) { Remove-Item $testPath -Force }

        Set-TouchFile -FullPath $testPath

        # Assert the file was created
        Test-Path $testPath | Should -BeTrue

        # Cleanup
        Remove-Item $testPath -Force
    }

    It "Should update the timestamp if file already exists in quick access mode" {
        $testPath = "$env:TEMP\pester_testfile.txt"
        New-Item -ItemType File -Path $testPath
        Set-Content -Path $testPath -Value "Initial"
        $originalTime = (Get-Item $testPath).LastWriteTime

        Start-Sleep -Seconds 1
        Set-TouchFile -FullPath $testPath
        $updatedTime = (Get-Item $testPath).LastWriteTime

        $updatedTime | Should -BeGreaterThan $originalTime

        Remove-Item $testPath -Force
    }
}
