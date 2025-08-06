setlocal enabledelayedexpansion

@ echo off

:: Store the original script directory for logging
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"

:: script to add a new repository URL to the variables and cloning it
echo what is the URL of the repository you want to add?
set /p "repo_url=Enter repository URL: "
set /p "path=Enter the local path where you want to clone the repository: "
set /p "toadd=Do you want to add the new repository path to repos.txt? (y/n): "


:: check if the user wants to add the new repository path to repos.txt
if /i "!toadd!"=="y" (
    echo Adding new repository path to repos.txt...

) else (
    echo Skipping addition of new repository path to repos.txt.
    exit /b
)
:: extract repo name from URL (remove .git if present)
for %%A in ("%repo_url%") do (
    set "repo_name=%%~nA"
)

:: add the full path to repos.txt
echo !path!\!repo_name! >> "%~dp0..\repos.txt"

:: cloning the new repository
cd /d "!path!"
echo Directory does not exist. Creating directory...
echo Creating directory: !path!\!repo_name!
mkdir "!repo_name!"
echo Directory created: !path!\!repo_name!
cd /d "!path!\!repo_name!"
echo Initializing git repository...

REM Add Git to PATH for this script session
set "PATH=%PATH%;C:\Program Files\Git\bin"
echo Cloning repository: !repo_url! to !path!\!repo_name!

git clone "!repo_url!"

echo Repository cloned successfully to !path!\!repo_name!
echo New repository path added to repos.txt: !path!\!repo_name!
pause