BeforeAll {
    # !Important Notice:
    # Have to include main in module for mock to work!
    # Import module with the following command
    Import-Module "$PSscriptRoot\..\Modules\SetTouchFileTools.psd1" -Force
    
    # The following dot sourcing will not work for mock due to scoping
    # Dot sourcing the script once before all tests will not work for mock
    # . "$PSScriptRoot\..\Set-TouchFile.ps1" -Force

    # Initialize test location and file path
    $script:testLocation = "TestDrive:\"
    $script:testFile = "TestDrive:\pester_testFile.txt"
}

# !This test does not work
Describe "Set-TouchFile in Normal Mode" {
    Context "-desiredLocation specified" {
        It "Should create a file" {
            Write-Host "$script:testFile"
            # Use the following command to mock user input, the -ModuleName flag is required
            Mock -CommandName Read-Host -MockWith { return 'n' } -ModuleName SetTouchFileTools
            
            # Invoke test function
            Set-TouchFile -filename "pester_testFile.txt" -desiredLocation $script:testLocation

            # Assert the file was created
            Test-Path $script:testFile | Should -BeTrue
        }
    }
}