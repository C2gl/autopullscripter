setlocal enabledelayedexpansion

@ echo off

:: Store the original script directory for logging
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"

:: script to add a new repository URL to the variables and cloning it
echo What is the URL of the repository you want to add?
set /p "repo_url=Enter repository URL: "
set /p "path=Enter the local path where you want to clone the repository: "
set /p "category=Enter category name for this repository (or press Enter for 'CLONED_REPOSITORIES'): "
if "!category!"=="" set "category=CLONED_REPOSITORIES"
set /p "toadd=Do you want to add the new repository path to repos_enhanced.txt? (y/n): "


:: check if the user wants to add the new repository path to repos_enhanced.txt
if /i "!toadd!"=="y" (
    echo Adding new repository path to repos_enhanced.txt under category: !category!...

) else (
    echo Skipping addition of new repository path to repos_enhanced.txt.
    exit /b
)
:: extract repo name from URL (remove .git if present)
for %%A in ("%repo_url%") do (
    set "repo_name=%%~nA"
)

:: Create repos_enhanced.txt if it doesn't exist
if not exist "%~dp0..\repos_enhanced.txt" (
    echo # Repository Categories Configuration > "%~dp0..\repos_enhanced.txt"
    echo # Format: [CATEGORY_NAME] followed by repository paths >> "%~dp0..\repos_enhanced.txt"
    echo # Empty lines and lines starting with # are ignored >> "%~dp0..\repos_enhanced.txt"
    echo. >> "%~dp0..\repos_enhanced.txt"
)

:: Check if category already exists
set "category_exists=false"
findstr /i /c:"[!category!]" "%~dp0..\repos_enhanced.txt" >nul 2>&1
if !errorlevel! equ 0 set "category_exists=true"

:: Add category and repository path
if "!category_exists!"=="false" (
    echo. >> "%~dp0..\repos_enhanced.txt"
    echo [!category!] >> "%~dp0..\repos_enhanced.txt"
)

:: add the full path to repos_enhanced.txt
echo !path!\!repo_name! >> "%~dp0..\repos_enhanced.txt"

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
echo New repository path added to repos_enhanced.txt under category [!category!]: !path!\!repo_name!
pause