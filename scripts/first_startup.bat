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

:: Check for existing repos.txt file
echo %date% %time% - Checking for repos.txt file >> "%LOG_PATH%"
if EXIST "%~dp0..\repos.txt" (
    echo repos.txt found.
    echo %date% %time% - repos.txt found at: %~dp0..\repos.txt >> "%LOG_PATH%"
    
    :: Check for enhanced repos file
    if EXIST "%~dp0..\repos_enhanced.txt" (
        echo repos_enhanced.txt also found.
        echo %date% %time% - repos_enhanced.txt found at: %~dp0..\repos_enhanced.txt >> "%LOG_PATH%"
    ) else (
        echo %date% %time% - repos_enhanced.txt NOT found >> "%LOG_PATH%"
    )
    
    :: Jump to main menu since repos.txt exists
    goto :main_menu
    
) ELSE (
    echo repos.txt NOT found.
    echo %date% %time% - repos.txt NOT found, starting creation process >> "%LOG_PATH%"
    
    timeout /t 5
    echo.
    echo What would you like to do?
    echo 1. Create empty repos.txt file and add repositories manually
    echo 2. Scan a folder path for existing Git repositories
    echo 3. Exit without creating repos.txt
    echo.
    set /p "choice=Enter your choice (1/2/3): "
    echo %date% %time% - User input: repos.txt creation choice: !choice! >> "%LOG_PATH%"
    
    if "!choice!"=="1" (
        echo Creating empty repos.txt file...
        echo %date% %time% - Creating empty repos.txt file >> "%LOG_PATH%"
        type nul > "%~dp0..\repos.txt"
        echo repos.txt file created in parent directory.
        echo %date% %time% - Empty repos.txt file created successfully >> "%LOG_PATH%"
        
        set /p "addrepos=Do you want to add repository paths to repos.txt now? (y/n): "
        echo %date% %time% - User input: Add repositories: !addrepos! >> "%LOG_PATH%"
        
        if /i "!addrepos!"=="y" (
            echo %date% %time% - Calling clone_repo.bat to add repositories >> "%LOG_PATH%"
            call "%~dp0clone_repo.bat"
            echo %date% %time% - Returned from clone_repo.bat >> "%LOG_PATH%"
        ) else (
            echo Please edit the repos.txt file to add your repository paths.
            echo Run the script again after editing the repos.txt file.
            echo %date% %time% - User chose not to add repositories immediately >> "%LOG_PATH%"
            pause
            goto :eof
        )
        
    ) else if "!choice!"=="2" (
        echo Starting repository scanner...
        echo %date% %time% - Starting repository scanner >> "%LOG_PATH%"
        call "%~dp0scan_repos.bat"
        echo %date% %time% - Returned from scan_repos.bat >> "%LOG_PATH%"
        
        :: Check if repos.txt was created and has content
        if exist "%~dp0..\repos.txt" (
            for /f %%A in ('type "%~dp0..\repos.txt" ^| find /c /v ""') do set "line_count=%%A"
            if !line_count! gtr 0 (
                echo repos.txt has been populated with !line_count! repositories.
                echo %date% %time% - repos.txt populated with !line_count! repositories via scan >> "%LOG_PATH%"
            ) else (
                echo repos.txt exists but is empty. Please add repository paths manually.
                echo %date% %time% - repos.txt created but empty >> "%LOG_PATH%"
                pause
                goto :eof
            )
        ) else (
            echo repos.txt was not created. Exiting.
            echo %date% %time% - repos.txt was not created by scanner >> "%LOG_PATH%"
            pause
            goto :eof
        )
        
    ) else if "!choice!"=="3" (
        echo Skipping creation of repos.txt file.
        echo WITHOUT repos.txt file, the script will NOT function properly. And thus close without running.
        echo %date% %time% - User chose to skip repos.txt creation >> "%LOG_PATH%"
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
echo Choose execution mode:
echo 1. NORMAL MODE - Use standard repos.txt file
echo 2. ENHANCED CATEGORY MODE - Use categorized repositories
echo.
echo Additional options:
echo 3. Clone new repositories (add new remote repos)
echo 4. Scan folder for existing repositories (add local repos)
echo 5. Pull repos from a different repos.txt file (will need to provide a different name)
echo 6. Exit without any action
echo.
set /p "action_choice=What would you like to do? (1/2/3/4/5/6): "
echo %date% %time% - User input: Action choice: !action_choice! >> "%LOG_PATH%"
echo %date% %time% - DEBUG: Processing action choice: !action_choice! >> "%LOG_PATH%"

if "!action_choice!"=="1" (
    echo Continuing with NORMAL MODE using repos.txt...
    echo %date% %time% - DEBUG: Selected NORMAL MODE >> "%LOG_PATH%"
    echo %date% %time% - DEBUG: About to call simple_git_pull.bat >> "%LOG_PATH%"
    echo %date% %time% - DEBUG: Full path: %~dp0simple_git_pull.bat >> "%LOG_PATH%"
    
    call "%~dp0simple_git_pull.bat"
    set "call_result=!errorlevel!"
    
    echo %date% %time% - DEBUG: Call completed with errorlevel: !call_result! >> "%LOG_PATH%"
    echo Normal mode completed.
    pause
    goto :eof
    
) else if "!action_choice!"=="2" (
    echo Starting ENHANCED CATEGORY MODE...
    echo Calling enhanced script directly...
    echo %date% %time% - DEBUG: Selected ENHANCED CATEGORY MODE >> "%LOG_PATH%"
    echo %date% %time% - DEBUG: About to call simple_git_pull_enhanced.bat >> "%LOG_PATH%"
    echo %date% %time% - DEBUG: Full path: %~dp0simple_git_pull_enhanced.bat >> "%LOG_PATH%"
    
    call "%~dp0simple_git_pull_enhanced.bat"
    set "call_result=!errorlevel!"
    
    echo %date% %time% - DEBUG: Call completed with errorlevel: !call_result! >> "%LOG_PATH%"
    echo Enhanced mode completed.
    pause
    goto :eof
    
) else if "!action_choice!"=="3" (
    echo %date% %time% - DEBUG: Selected Clone repositories option >> "%LOG_PATH%"
    call "%~dp0clone_repo.bat"
    echo %date% %time% - DEBUG: Returned from clone_repo.bat >> "%LOG_PATH%"
    pause
    goto :eof
    
) else if "!action_choice!"=="4" (
    echo %date% %time% - DEBUG: Selected Scan repositories option >> "%LOG_PATH%"
    call "%~dp0scan_repos.bat"
    echo %date% %time% - DEBUG: Returned from scan_repos.bat >> "%LOG_PATH%"
    pause
    goto :eof
    
) else if "!action_choice!"=="5" (
    echo %date% %time% - DEBUG: Selected Custom repos file option >> "%LOG_PATH%"
    set /p "new_repos_file=Enter the name of the new repos.txt file (with .txt extension): "
    echo %date% %time% - User input: Custom repos file: !new_repos_file! >> "%LOG_PATH%"
    
    if exist "%~dp0..\!new_repos_file!" (
        echo Using repos.txt file: !new_repos_file!
        echo %date% %time% - DEBUG: Custom file exists, calling simple_git_pull.bat with: !new_repos_file! >> "%LOG_PATH%"
        call "%~dp0simple_git_pull.bat" "!new_repos_file!"
        echo %date% %time% - DEBUG: Returned from simple_git_pull.bat (custom file) >> "%LOG_PATH%"
        echo Custom file mode completed.
        pause
        goto :eof
    ) else (
        echo The specified repos.txt file does not exist. Please check the name and try again.
        echo %date% %time% - DEBUG: Custom file does not exist: !new_repos_file! >> "%LOG_PATH%"
        pause
        goto :eof
    )
    
) else if "!action_choice!"=="6" (
    echo Exiting without any action.
    echo %date% %time% - DEBUG: User selected exit option >> "%LOG_PATH%"
    goto :eof
    
) else (
    echo Invalid choice. Using NORMAL MODE...
    echo %date% %time% - DEBUG: Invalid choice, falling back to NORMAL MODE: !action_choice! >> "%LOG_PATH%"
    call "%~dp0simple_git_pull.bat"
    echo Normal mode completed (fallback).
    pause
    goto :eof
)

echo %date% %time% - End of first_startup.bat >> "%LOG_PATH%"