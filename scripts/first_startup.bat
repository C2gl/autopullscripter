:: first_startup.bat
:: this file is called by run.bat and will go back to it when done running 
@echo off

setlocal enabledelayedexpansion

:: Store the original script directory for logging
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"

:: script that check for existing repos.txt file

if EXIST "%~dp0..\repos.txt" (
    echo repos.txt found.
    echo %date% %time% - repos.txt found. >> "%LOG_PATH%"
) ELSE (
    echo repos.txt NOT found.
    :: Store the original script directory for logging
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"
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
        type nul > "%~dp0..\repos.txt"
        echo repos.txt file created in parent directory.
        echo %date% %time% - Empty repos.txt file created in parent directory. >> "%LOG_PATH%"
        set /p "addrepos=Do you want to add repository paths to repos.txt now? (y/n): "
        echo %date% %time% - User input: Add repositories: !addrepos! >> "%LOG_PATH%"
        if /i "!addrepos!"=="y" (
            call "%~dp0clone_repo.bat"
        ) else (
            echo Please edit the repos.txt file to add your repository paths.
            echo Run the script again after editing the repos.txt file.
            pause
            exit
        )
    ) else if "!choice!"=="2" (
        echo Starting repository scanner...
        call "%~dp0scan_repos.bat"
        :: Check if repos.txt was created and has content
        if exist "%~dp0..\repos.txt" (
            for /f %%A in ('type "%~dp0..\repos.txt" ^| find /c /v ""') do set "line_count=%%A"
            if !line_count! gtr 0 (
                echo repos.txt has been populated with !line_count! repositories.
                echo %date% %time% - repos.txt populated with !line_count! repositories via scan. >> "%LOG_PATH%"
            ) else (
                echo repos.txt exists but is empty. Please add repository paths manually.
                pause
                exit
            )
        ) else (
            echo repos.txt was not created. Exiting.
            pause
            exit
        )
    ) else if "!choice!"=="3" (
        echo Skipping creation of repos.txt file.
        echo WITHOUT repos.txt file, the script will NOT function properly. And thus close without running.
        pause
        exit
    ) else (
        echo Invalid choice. Please run the script again and select 1, 2, or 3.
        pause
        exit
    )
)

:: prompting user if they want to clone new repositories or scan for existing ones
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

if "!action_choice!"=="1" (
    echo Continuing with NORMAL MODE using repos.txt...
    call "%~dp0simple_git_pull.bat"
    echo Normal mode completed.
    pause
    exit
) else if "!action_choice!"=="2" (
    echo Starting ENHANCED CATEGORY MODE...
    echo Calling enhanced script directly...
    call "%~dp0simple_git_pull_enhanced.bat"
    echo Enhanced mode completed.
    pause
    exit
) else if "!action_choice!"=="3" (
    call "%~dp0clone_repo.bat"
) else if "!action_choice!"=="4" (
    call "%~dp0scan_repos.bat"
) else if "!action_choice!"=="5" (
    set /p "new_repos_file=Enter the name of the new repos.txt file (with .txt extension): "
    if exist "%~dp0..\!new_repos_file!" (
        echo Using repos.txt file: !new_repos_file!
        call "%~dp0simple_git_pull.bat" "!new_repos_file!"
        echo Custom file mode completed.
        pause
        exit
    ) else (
        echo The specified repos.txt file does not exist. Please check the name and try again.
        pause
        exit
    )
) else if "!action_choice!"=="6" (
    echo Exiting without any action.
    exit
) else (
    echo Invalid choice. Using NORMAL MODE...
    call "%~dp0simple_git_pull.bat"
    echo Normal mode completed (fallback).
    pause
    exit
)