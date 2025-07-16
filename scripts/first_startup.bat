:: first_startup.bat
:: this fie is called by run.bat and will go back to it when done running 
@echo off

setlocal enabledelayedexpansion

:: script that check for existing repos.txt file

if EXIST "%~dp0..\repos.txt" (
    echo repos.txt found.
) ELSE (
    echo repos.txt NOT found.
    timeout /t 5
    echo would you like for the script to create a new repos.txt file?
    set /p "create=Do you want to create a new repos.txt file? (y/n): "
    if /i "!create!"=="y" (
        echo Creating repos.txt file...
        type nul > "%~dp0..\repos.txt"
        echo repos.txt file created in parent directory.
        echo Please edit the repos.txt file to add your repository URLs.
        echo Run the script again after editing the repos.txt file.
        pause
        exit
    ) else (
        echo Skipping creation of repos.txt file.
        echo WITHOUT repos.txt file, the script will NOT function properly. and thus close without running.
        pause
        exit
    )
)

:: prompting user if they want to clone new repositories
set /p "clonenew=Do you want to clone new repositories? (y/n): "

if /i "!clonenew!"=="y" (
    call "%~dp0clone_repo.bat"
)
pause