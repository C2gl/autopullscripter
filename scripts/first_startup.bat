:: first_startup.bat
:: This file is called by run.bat and will go back to it when done running 
@echo off

setlocal enabledelayedexpansion

:: Store the original script directory for logging
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"

echo %date% %time% - Starting first_startup.bat >> "%LOG_PATH%"
echo %date% %time% - Script directory: %SCRIPT_DIR% >> "%LOG_PATH%"
echo %date% %time% - Log path: %LOG_PATH% >> "%LOG_PATH%"

:: Check for existing repos_enhanced.txt file
echo %date% %time% - Checking for repos_enhanced.txt file >> "%LOG_PATH%"
if EXIST "%~dp0..\repos_enhanced.txt" (
    echo repos_enhanced.txt found.
    echo %date% %time% - repos_enhanced.txt found at: %~dp0..\repos_enhanced.txt >> "%LOG_PATH%"
    
    :: Jump to main menu since repos_enhanced.txt exists
    goto :main_menu
    
) ELSE (
    echo repos_enhanced.txt NOT found.
    echo %date% %time% - repos_enhanced.txt NOT found, starting creation process >> "%LOG_PATH%"
    
    timeout /t 3
    echo.
    echo What would you like to do?
    echo 1. Create empty repos_enhanced.txt file and add repositories manually
    echo 2. Scan a folder path for existing Git repositories
    echo 3. Exit without creating repos_enhanced.txt
    echo.
    set /p "choice=Enter your choice (1/2/3): "
    echo %date% %time% - User input: repos_enhanced.txt creation choice: !choice! >> "%LOG_PATH%"
    
    if "!choice!"=="1" (
        echo Creating empty repos_enhanced.txt file...
        echo %date% %time% - Creating empty repos_enhanced.txt file >> "%LOG_PATH%"
        
        echo # Repository Categories Configuration > "%~dp0..\repos_enhanced.txt"
        echo # Format: [CATEGORY_NAME] followed by repository paths >> "%~dp0..\repos_enhanced.txt"
        echo # Empty lines and lines starting with # are ignored >> "%~dp0..\repos_enhanced.txt"
        echo. >> "%~dp0..\repos_enhanced.txt"
        echo # Example: >> "%~dp0..\repos_enhanced.txt"
        echo # [MY_PROJECTS] >> "%~dp0..\repos_enhanced.txt"
        echo # C:\path\to\my\repository >> "%~dp0..\repos_enhanced.txt"
        echo. >> "%~dp0..\repos_enhanced.txt"
        
        echo repos_enhanced.txt file created in parent directory.
        echo %date% %time% - Empty repos_enhanced.txt file created successfully >> "%LOG_PATH%"
        
        set /p "addrepos=Do you want to add repository paths to repos_enhanced.txt now? (y/n): "
        echo %date% %time% - User input: Add repositories: !addrepos! >> "%LOG_PATH%"
        
        if /i "!addrepos!"=="y" (
            echo %date% %time% - Calling clone_repo.bat to add repositories >> "%LOG_PATH%"
            call "%~dp0clone_repo.bat"
            echo %date% %time% - Returned from clone_repo.bat >> "%LOG_PATH%"
        ) else (
            echo Please edit the repos_enhanced.txt file to add your repository paths.
            echo Run the script again after editing the repos_enhanced.txt file.
            echo %date% %time% - User chose not to add repositories immediately >> "%LOG_PATH%"
            pause
            goto :eof
        )
        
    ) else if "!choice!"=="2" (
        echo Starting repository scanner...
        echo %date% %time% - Starting repository scanner >> "%LOG_PATH%"
        call "%~dp0scan_repos.bat"
        echo %date% %time% - Returned from scan_repos.bat >> "%LOG_PATH%"
        
        :: Check if repos_enhanced.txt was created and has content
        if exist "%~dp0..\repos_enhanced.txt" (
            for /f %%A in ('type "%~dp0..\repos_enhanced.txt" ^| find /c /v ""') do set "line_count=%%A"
            if !line_count! gtr 5 (
                echo repos_enhanced.txt has been populated with repositories.
                echo %date% %time% - repos_enhanced.txt populated with repositories via scan >> "%LOG_PATH%"
            ) else (
                echo repos_enhanced.txt exists but may be empty. Please add repository paths manually.
                echo %date% %time% - repos_enhanced.txt created but may be empty >> "%LOG_PATH%"
                pause
                goto :eof
            )
        ) else (
            echo repos_enhanced.txt was not created. Exiting.
            echo %date% %time% - repos_enhanced.txt was not created by scanner >> "%LOG_PATH%"
            pause
            goto :eof
        )
        
    ) else if "!choice!"=="3" (
        echo Skipping creation of repos_enhanced.txt file.
        echo WITHOUT repos_enhanced.txt file, the script will NOT function properly. And thus close without running.
        echo %date% %time% - User chose to skip repos_enhanced.txt creation >> "%LOG_PATH%"
        pause
        goto :eof
        
    ) else (
        echo Invalid choice. Please run the script again and select 1, 2, or 3.
        echo %date% %time% - Invalid choice entered: !choice! >> "%LOG_PATH%"
        pause
        goto :eof
    )
)

:main_menu
echo %date% %time% - Entering main menu >> "%LOG_PATH%"
echo.
echo ===== AutoPull Scripter - Enhanced Mode =====
echo.
echo Choose what you'd like to do:
echo 1. Pull repositories (Enhanced Category Mode)
echo 2. Clone new repositories (add new remote repos)
echo 3. Scan folder for existing repositories (add local repos)  
echo 4. Pull repos from a different enhanced repos file
echo 5. Exit without any action
echo.
set /p "action_choice=What would you like to do? (1/2/3/4/5): "
echo %date% %time% - User input: Action choice: !action_choice! >> "%LOG_PATH%"
echo %date% %time% - DEBUG: Processing action choice: !action_choice! >> "%LOG_PATH%"

if "!action_choice!"=="1" (
    echo Starting Enhanced Category Mode...
    echo %date% %time% - DEBUG: Selected Enhanced Category Mode >> "%LOG_PATH%"
    echo %date% %time% - DEBUG: About to call simple_git_pull_enhanced.bat >> "%LOG_PATH%"
    echo %date% %time% - DEBUG: Full path: %~dp0simple_git_pull_enhanced.bat >> "%LOG_PATH%"
    
    call "%~dp0simple_git_pull_enhanced.bat"
    set "call_result=!errorlevel!"
    
    echo %date% %time% - DEBUG: Call completed with errorlevel: !call_result! >> "%LOG_PATH%"
    echo Enhanced mode completed.
    pause
    goto :eof
    
) else if "!action_choice!"=="2" (
    echo %date% %time% - DEBUG: Selected Clone repositories option >> "%LOG_PATH%"
    call "%~dp0clone_repo.bat"
    echo %date% %time% - DEBUG: Returned from clone_repo.bat >> "%LOG_PATH%"
    pause
    goto :eof
    
) else if "!action_choice!"=="3" (
    echo %date% %time% - DEBUG: Selected Scan repositories option >> "%LOG_PATH%"
    call "%~dp0scan_repos.bat"
    echo %date% %time% - DEBUG: Returned from scan_repos.bat >> "%LOG_PATH%"
    pause
    goto :eof
    
) else if "!action_choice!"=="4" (
    echo %date% %time% - DEBUG: Selected Custom enhanced repos file option >> "%LOG_PATH%"
    set /p "new_repos_file=Enter the name of the enhanced repos file (with .txt extension): "
    echo %date% %time% - User input: Custom enhanced repos file: !new_repos_file! >> "%LOG_PATH%"
    
    if exist "%~dp0..\!new_repos_file!" (
        echo Using enhanced repos file: !new_repos_file!
        echo %date% %time% - DEBUG: Custom file exists, calling simple_git_pull_enhanced.bat with: !new_repos_file! >> "%LOG_PATH%"
        call "%~dp0simple_git_pull_enhanced.bat" "!new_repos_file!"
        echo %date% %time% - DEBUG: Returned from simple_git_pull_enhanced.bat (custom file) >> "%LOG_PATH%"
        echo Custom enhanced file mode completed.
        pause
        goto :eof
    ) else (
        echo The specified enhanced repos file does not exist. Please check the name and try again.
        echo %date% %time% - DEBUG: Custom enhanced file does not exist: !new_repos_file! >> "%LOG_PATH%"
        pause
        goto :eof
    )
    
) else if "!action_choice!"=="5" (
    echo Exiting without any action.
    echo %date% %time% - DEBUG: User selected exit option >> "%LOG_PATH%"
    goto :eof
    
) else (
    echo Invalid choice. Starting Enhanced Category Mode...
    echo %date% %time% - DEBUG: Invalid choice, falling back to Enhanced Category Mode: !action_choice! >> "%LOG_PATH%"
    call "%~dp0simple_git_pull_enhanced.bat"
    echo Enhanced mode completed (fallback).
    pause
    goto :eof
)

echo %date% %time% - End of first_startup.bat >> "%LOG_PATH%"