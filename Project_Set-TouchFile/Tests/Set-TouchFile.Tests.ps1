BeforeAll {
    # Important Notice:
    # Have to include main in module for mock to work!
    # Import module with the following command
    Import-Module "$PSscriptRoot\..\SetTouchFileTools.psd1" -Force
    
    # The following dot sourcing will not work for mock due to scoping
    # Dot sourcing the script once before all tests will not work for mock
    # . "$PSScriptRoot\..\Set-TouchFile.ps1" -Force
}

# Test suite for Set-TouchFile in Normal Mode
Describe "Normal Mode Set-TouchFile for one filename" {
    Context "Specify -desiredLocation" {
        Context "-desiredLocation as absolute path" {
            It "Should create a new file when it doesn't exist" {
                # Arrange test environment
                $testPath = "$env:TEMP\pester_testfile.txt"
                if (Test-Path $testPath) { Remove-Item $testPath -Force }

                # Use the following command to mock user input, the -ModuleName flag is required
                Mock -CommandName Read-Host -MockWith { return 'n' } -ModuleName SetTouchFileTools

                # Invoke test function
                Set-TouchFile -filename "pester_testfile.txt" -desiredLocation $env:TEMP
        
                # Assert the file was created
                Test-Path $testPath | Should -BeTrue

                # Cleanup
                Remove-Item $testPath -Force
            }

            It "Should update the timestamp if file already exists" {
                # Arrange test environment
                $testPath = "$env:TEMP\pester_testfile.txt"

                # Create new file, and initialize
                New-Item -ItemType File -Path $testPath
                Set-Content -Path $testPath -Value "Initial"

                # Get original time stamp
                $originalTime = (Get-Item $testPath).LastWriteTime

                # Mock different user input with a list of commands
                # $script:var means the script scope variable
                $script:count = 0 
                $script:inputs = @('n', '')
                Mock -CommandName Read-Host -MockWith { 
                    return $inputs[$script:count++] 
                } -ModuleName SetTouchFileTools

                # Wait for time change
                Start-Sleep -Seconds 1

                # Invoke test function
                Set-TouchFile -filename "pester_testfile.txt" -desiredLocation $env:TEMP

                # Get updated time
                $updatedTime = (Get-Item $testPath).LastWriteTime

                # Check if condition is met
                $updatedTime | Should -BeGreaterThan $originalTime

                # Cleanup
                Remove-Item $testPath -Force
            }

            It "Should create a new file upon user instruction if already exists" {
                # Arrange test environment
                $testPath = "$env:TEMP\pester_testfile.txt"
                # Create new file 
                New-Item -ItemType File -Path $testPath

                $script:count = 0
                $script:inputs = @('n', 'pester_testfile2.txt', 'n')
                Mock -CommandName Read-Host -MockWith { 
                    return $inputs[$script:count++] 
                } -ModuleName SetTouchFileTools

                # Expected new file
                $testPathNew = "$env:TEMP\pester_testfile2.txt"

                # Invoke test function
                Set-TouchFile -filename "pester_testfile.txt" -desiredLocation $env:TEMP

                # Check if condition is met
                $isCreated = (Test-Path -Path $testPathNew)
                $isCreated | Should -BeTrue

                # Cleanup
                Remove-Item $testPathNew -Force
                Remove-Item $testPath -Force
            }
        }

        Context "-desiredLocation as relative path" {
            It "Should create a new file when it doesn't exist" {
                # Arrange test environment
                $testPath = "$env:TEMP\pester_testfile.txt"
                if (Test-Path $testPath) { Remove-Item $testPath -Force }

                # Use the following command to mock user input, the -ModuleName flag is required
                Mock -CommandName Read-Host -MockWith { return 'n' } -ModuleName SetTouchFileTools

                # Change working directory
                Set-Location $env:TEMP

                # Invoke test function
                Set-TouchFile -filename "pester_testfile.txt" -desiredLocation ".\"
        
                # Assert the file was created
                Test-Path $testPath | Should -BeTrue

                # Cleanup
                Remove-Item $testPath -Force
            }

            It "Should update the timestamp if file already exists" {
                # Arrange test environment
                $testPath = "$env:TEMP\pester_testfile.txt"

                # Create new file, and initialize
                New-Item -ItemType File -Path $testPath
                Set-Content -Path $testPath -Value "Initial"

                # Get original time stamp
                $originalTime = (Get-Item $testPath).LastWriteTime

                # Mock different user input with a list of commands
                # $script:var means the script scope variable
                $script:count = 0 
                $script:inputs = @('n', '')
                Mock -CommandName Read-Host -MockWith { 
                    return $inputs[$script:count++] 
                } -ModuleName SetTouchFileTools

                # Wait for time change
                Start-Sleep -Seconds 1

                # Change working directory
                Set-Location $env:TEMP

                # Invoke test function
                Set-TouchFile -filename "pester_testfile.txt" -desiredLocation ".\"

                # Get updated time
                $updatedTime = (Get-Item $testPath).LastWriteTime

                # Check if condition is met
                $updatedTime | Should -BeGreaterThan $originalTime

                # Cleanup
                Remove-Item $testPath -Force
            }

            It "Should create a new file upon user instruction if already exists" {
                # Arrange test environment
                $testPath = "$env:TEMP\pester_testfile.txt"
                # Create new file 
                New-Item -ItemType File -Path $testPath

                $script:count = 0
                $script:inputs = @('n', 'pester_testfile2.txt', 'n')
                Mock -CommandName Read-Host -MockWith { 
                    return $inputs[$script:count++] 
                } -ModuleName SetTouchFileTools

                # Expected new file
                $testPathNew = "$env:TEMP\pester_testfile2.txt"

                # Change working directory
                Set-Location $env:TEMP

                # Invoke test function
                Set-TouchFile -filename "pester_testfile.txt" -desiredLocation ".\"

                # Check if condition is met
                $isCreated = (Test-Path -Path $testPathNew)
                $isCreated | Should -BeTrue

                # Cleanup
                Remove-Item $testPathNew -Force
                Remove-Item $testPath -Force
            }
        }
    }
    
    Context "Does not specify -desiredLocation, create in working directory instead" {
        It "Should create a new file when it doesn't exist" {
            # Arrange test environment
            $testPath = "$env:TEMP\pester_testfile.txt"
            if (Test-Path $testPath) { Remove-Item $testPath -Force }

            # Change working directory
            Set-Location $env:TEMP

            Mock -CommandName Read-Host -MockWith { return 'n' } -ModuleName SetTouchFileTools

            # Invoke test function
            Set-TouchFile -filename "pester_testfile.txt"
        
            # Check if condition is met
            Test-Path $testPath | Should -BeTrue

            # Cleanup
            Remove-Item $testPath -Force
        }

        It "Should update the timestamp if file already exists" {
            # Arrange test environment
            $testPath = "$env:TEMP\pester_testfile.txt"

            # Create new file, and initialize
            New-Item -ItemType File -Path $testPath
            Set-Content -Path $testPath -Value "Initial"

            # Get original time
            $originalTime = (Get-Item $testPath).LastWriteTime

            $script:count = 0 
            $script:inputs = @('n', '')
            Mock -CommandName Read-Host -MockWith { 
                return $inputs[$script:count++] 
            } -ModuleName SetTouchFileTools

            # Wait for time to update
            Start-Sleep -Seconds 1

            # Change working directory
            Set-Location $env:TEMP

            # Invoke test function
            Set-TouchFile -filename "pester_testfile.txt"

            # Get updated time
            $updatedTime = (Get-Item $testPath).LastWriteTime

            # Check if condition is met
            $updatedTime | Should -BeGreaterThan $originalTime

            # Cleanup
            Remove-Item $testPath -Force
        }

        It "Should create a new file upon user instruction if already exists" {
            # Arrange test environment
            $testPath = "$env:TEMP\pester_testfile.txt"
            New-Item -ItemType File -Path $testPath

            $script:count = 0
            $script:inputs = @('n', 'pester_testfile2.txt', 'n')     
            Mock -CommandName Read-Host -MockWith { 
                return $inputs[$script:count++] 
            } -ModuleName SetTouchFileTools

            # Expected new file
            $testPathNew = "$env:TEMP\pester_testfile2.txt"

            # Change working directory
            Set-Location "$env:TEMP"

            # Invoke test function
            Set-TouchFile -filename "pester_testfile.txt"

            # Check if condition is met
            $isCreated = (Test-Path -Path $testPathNew)
            $isCreated | Should -BeTrue

            # Cleanup
            Remove-Item $testPathNew -Force
            Remove-Item $testPath -Force
        }
    } 
}

# Test suite for Set-TouchFile in Quick Access Mode
Describe "Quick Access Mode Set-TouchFile for one filename" {
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

Describe "Normal Mode Set-TouchFile for an array of filename" {
    Context "Specify -desiredLocation" {
        Context "-desiredLocation as absolute path" {
            It "Should create a new file when it doesn't exist" {
                # List test filenames
                $filenames = @(
                    "pester_file1.txt", "pester_file2.txt", "pester_file3.txt",
                    "pester_file4.txt", "pester_file5.txt", "pester_file6.txt"
                )

                # Assemble testPaths
                $testPaths = $filenames | ForEach-Object { Join-Path -Path $env:TEMP -ChildPath $_ }

                # Ensure clean state
                foreach ($path in $testPaths) {
                    if (Test-Path $path) { Remove-Item $path -Force }
                }

                # Use the following command to mock user input, the -ModuleName flag is required
                Mock -CommandName Read-Host -MockWith { return 'n' } -ModuleName SetTouchFileTools

                # Invoke test function
                Set-TouchFile -filename $filenames -desiredLocation $env:TEMP
        
                # Assert all files created
                foreach ($path in $testPaths) {
                    Test-Path $path | Should -BeTrue
                }

                # Cleanup
                foreach ($path in $testPaths) {
                    Remove-Item $path -Force
                }
            }
        }
    }

    #         It "Should update the timestamp if file already exists" {

    #         }

    #         It "Should create a new file upon user instruction if already exists" {

    #         }
    #     }

    #     Context "-desiredLocation as relative path" {
    #         It "Should create a new file when it doesn't exist" {

    #         }

    #         It "Should update the timestamp if file already exists" {

    #         }

    #         It "Should create a new file upon user instruction if already exists" {

    #         }
    #     }
    # }
    
    # Context "Does not specify -desiredLocation, create in working directory instead" {
    #     It "Should create a new file when it doesn't exist" {

    #     }

    #     It "Should update the timestamp if file already exists" {

    #     }

    #     It "Should create a new file upon user instruction if already exists" {

    #     }
    # } 
}
