BeforeAll {
    # Have to include main in module for mock to work!
    Import-Module "$PSscriptRoot\..\SetTouchFileTools.psd1" -Force
    
    # The following dot sourcing will not work for mock!!!
    # Dot-source the script once before all tests
    # . "$PSScriptRoot\..\Set-TouchFile.ps1" -Force
}

# Test suite for Set-TouchFile in Normal Mode
Describe "Function Test: Set-TouchFile Function Tests for Normal Mode" {
    Context "Specify -desiredLocation" {
        It "Should create a new file when it doesn't exist" {
            # Arrange the location of test
            $testPath = "$env:TEMP\pester_testfile.txt"
            if (Test-Path $testPath) { Remove-Item $testPath -Force }

            # The -ModuleName flag is required!
            Mock -CommandName Read-Host -MockWith { return 'n' } -ModuleName SetTouchFileTools

            Set-TouchFile -filename "pester_testfile.txt" -desiredLocation $env:TEMP
        
            # Assert the file was created
            Test-Path $testPath | Should -BeTrue

            # Cleanup
            Remove-Item $testPath -Force
        }

        It "Should update the timestamp if file already exists" {
            $testPath = "$env:TEMP\pester_testfile.txt"
            New-Item -ItemType File -Path $testPath
            Set-Content -Path $testPath -Value "Initial"
            $originalTime = (Get-Item $testPath).LastWriteTime

            # Example of mocking a list of commands
            $script:count = 0 
            $script:inputs = @('n', '')
        
            # The -ModuleName flag is required!
            Mock -CommandName Read-Host -MockWith { 
                return $inputs[$script:count++] 
            } -ModuleName SetTouchFileTools

            Start-Sleep -Seconds 1
            Set-TouchFile -filename "pester_testfile.txt" -desiredLocation $env:TEMP
            $updatedTime = (Get-Item $testPath).LastWriteTime

            $updatedTime | Should -BeGreaterThan $originalTime

            Remove-Item $testPath -Force
        }

        It "Should create a new file upon user instruction if already exists" {
            $testPath = "$env:TEMP\pester_testfile.txt"
            New-Item -ItemType File -Path $testPath

            # Example of mocking a list of commands
            # $script:var means the script scope variable
            $script:count = 0
            $script:inputs = @('n', 'pester_testfile2.txt', 'n')
        
            # The -ModuleName flag is required!
            Mock -CommandName Read-Host -MockWith { 
                return $inputs[$script:count++] 
            } -ModuleName SetTouchFileTools

            $testPathNew = "$env:TEMP\pester_testfile2.txt"

            Set-TouchFile -filename "pester_testfile.txt" -desiredLocation $env:TEMP

            $isCreated = (Test-Path -Path $testPathNew)
            $isCreated | Should -BeTrue

            Remove-Item $testPathNew -Force
            Remove-Item $testPath -Force
        }
    }
    
    Context "Does not specify -desiredLocation, create in working directory instead" {
        It "Should create a new file when it doesn't exist" {
            # Arrange the location of test
            $testPath = "D:\Test\pester_testfile.txt"
            if (Test-Path $testPath) { Remove-Item $testPath -Force }

            # Change working directory
            Set-Location "D:\Test"

            # The -ModuleName flag is required!
            Mock -CommandName Read-Host -MockWith { return 'n' } -ModuleName SetTouchFileTools

            Set-TouchFile -filename "pester_testfile.txt"
        
            # Assert the file was created
            Test-Path $testPath | Should -BeTrue

            # Cleanup
            Remove-Item $testPath -Force
        }

        It "Should update the timestamp if file already exists" {
            # Arrange the location of test
            $testPath = "D:\Test\pester_testfile.txt"

            New-Item -ItemType File -Path $testPath
            Set-Content -Path $testPath -Value "Initial"

            $originalTime = (Get-Item $testPath).LastWriteTime

            # Example of mocking a list of commands
            $script:count = 0 
            $script:inputs = @('n', '')
        
            # The -ModuleName flag is required!
            Mock -CommandName Read-Host -MockWith { 
                return $inputs[$script:count++] 
            } -ModuleName SetTouchFileTools

            Start-Sleep -Seconds 1

            # Change working directory
            Set-Location "D:\Test"

            Set-TouchFile -filename "pester_testfile.txt"

            $updatedTime = (Get-Item $testPath).LastWriteTime

            $updatedTime | Should -BeGreaterThan $originalTime

            Remove-Item $testPath -Force
        }

        It "Should create a new file upon user instruction if already exists" {
            # Arrange the location of test
            $testPath = "D:\Test\pester_testfile.txt"

            New-Item -ItemType File -Path $testPath

            # Example of mocking a list of commands
            # $script:var means the script scope variable
            $script:count = 0
            $script:inputs = @('n', 'pester_testfile2.txt', 'n')
        
            # The -ModuleName flag is required!
            Mock -CommandName Read-Host -MockWith { 
                return $inputs[$script:count++] 
            } -ModuleName SetTouchFileTools

            $testPathNew = "D:\Test\pester_testfile2.txt"

            # Change working directory
            Set-Location "D:\Test"

            Set-TouchFile -filename "pester_testfile.txt"

            $isCreated = (Test-Path -Path $testPathNew)
            $isCreated | Should -BeTrue

            Remove-Item $testPathNew -Force
            Remove-Item $testPath -Force
        }
    } 
}

# Test suite for Set-TouchFile in Quick Access Mode
Describe "Function Test: Set-TouchFile Function Tests for Quick Access Mode" {
    Context "Test absolute location" {
        It "Should create a new file when it doesn't exist" {
            # Arrange the location of test
            $testPath = "$env:TEMP\pester_testfile.txt"
            if (Test-Path $testPath) { Remove-Item $testPath -Force }

            # The -ModuleName flag is required!
            Mock -CommandName Read-Host -MockWith { return 'n' } -ModuleName SetTouchFileTools

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

            # Example of mocking a list of commands
            $script:count = 0 
            $script:inputs = @('n', '')
        
            # The -ModuleName flag is required!
            Mock -CommandName Read-Host -MockWith { 
                return $inputs[$script:count++] 
            } -ModuleName SetTouchFileTools

            Start-Sleep -Seconds 1
            Set-TouchFile -FullPath $testPath
            $updatedTime = (Get-Item $testPath).LastWriteTime

            $updatedTime | Should -BeGreaterThan $originalTime

            Remove-Item $testPath -Force
        }
    }

    Context "Test relative location, this is more commonly used" {
        It "Should create a new file when it doesn't exist" {
            # Arrange the location of test
            $testPath = "D:\Test\pester_testfile.txt"
            $testPathRelative = ".\Test\pester_testfile.txt"

            if (Test-Path $testPath) { Remove-Item $testPath -Force }

            # The -ModuleName flag is required!
            Mock -CommandName Read-Host -MockWith { return 'n' } -ModuleName SetTouchFileTools
            
            # Change working directory
            Set-Location "D:\"

            Set-TouchFile -FullPath $testPathRelative

            # Assert the file was created
            Test-Path $testPath | Should -BeTrue

            # Cleanup
            Remove-Item $testPath -Force
        }

        It "Should update the timestamp if file already exists in quick access mode" {

            $testPath = "D:\Test\pester_testfile.txt"
            $testPathRelative = ".\Test\pester_testfile.txt"

            New-Item -ItemType File -Path $testPath

            Set-Content -Path $testPath -Value "Initial"
            $originalTime = (Get-Item $testPath).LastWriteTime

            # Example of mocking a list of commands
            $script:count = 0 
            $script:inputs = @('n', '')
        
            # The -ModuleName flag is required!
            Mock -CommandName Read-Host -MockWith { 
                return $inputs[$script:count++] 
            } -ModuleName SetTouchFileTools

            Start-Sleep -Seconds 1

            # Change working directory
            Set-Location "D:\"

            Set-TouchFile -FullPath $testPathRelative

            $updatedTime = (Get-Item $testPath).LastWriteTime

            $updatedTime | Should -BeGreaterThan $originalTime

            Remove-Item $testPath -Force
        }
    }
}
