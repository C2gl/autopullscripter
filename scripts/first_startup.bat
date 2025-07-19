:: first_startup.bat
:: this fie is called by run.bat and will go back to it when done running 
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
    echo Would you like for the script to create a new repos.txt file?
    set /p "create=Do you want to create a new repos.txt file? (y/n): "
    echo %date% %time% - User input: Create repos.txt: !create! >> "%LOG_PATH%"
    if /i "!create!"=="y" (
        echo Creating repos.txt file...
        type nul > "%~dp0..\repos.txt"
        echo repos.txt file created in parent directory.
        echo %date% %time% - repos.txt file created in parent directory. >> "%LOG_PATH%"
        set /p "addrepos=Do you want to add repository paths to repos.txt now? (y/n): "
        echo %date% %time% - User input: Add repositories: !addrepos! >> "%LOG_PATH%"
        if /i "!addrepos!"=="y" (
            call "%~dp0clone_repo.bat"
            call run.bat

        )
        echo Please edit the repos.txt file to add your repository URLs.
        echo Run the script again after editing the repos.txt file.
        pause
        exit
    ) else (
        echo Skipping creation of repos.txt file.
        echo WITHOUT repos.txt file, the script will NOT function properly. And thus close without running.
        pause
        exit
    )
)

:: prompting user if they want to clone new repositories
set /p "clonenew=Do you want to clone new repositories? (y/n): "
echo %date% %time% - User input: Clone new repositories: !clonenew! >> "%LOG_PATH%"

if /i "!clonenew!"=="y" (
    call "%~dp0clone_repo.bat"
)