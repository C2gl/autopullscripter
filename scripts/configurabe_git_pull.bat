@echo off
setlocal enabledelayedexpansion

:: variables 
set "repo_file=repos.txt"
set "count=0"

:: Load config if exists
if exist "config.txt" (
    echo Loading configuration from config.txt...
    for /f "usebackq tokens=1,* delims==" %%A in ("config.txt") do (
        set "%%A=%%B"
    )
) else (
    echo No config file found, prompting for user input.
)

:: user set variables 
if not defined waittime set /p "waittime=Enter wait time between pulls (default is 3 seconds): "
if not defined toFetch set /p "toFetch=Do you want to fetch latest changes before pulling? (y/n): "
if not defined docustomcommand set /p "docustomcommand=do you want to run a custom command before pulling? (y/n): "
if /i "!docustomcommand!"=="y" (
    if not defined customcommand set /p "customcommand=Enter the custom command to run: "
)

:: loop through each repository path in the file
for /f "usebackq delims=" %%R in ("%repo_file%") do (
    echo itteration !count!
    set "currentPath=%%R"
    echo Current path: !currentPath!
    cd /d "!currentPath!"
    
    if /i "!toFetch!"=="y" (
        call "%~dp0fetch.bat"
    ) 

    if /i "!docustomcommand!"=="y" (
        echo Running custom command: !customcommand!
        !customcommand!
    )

    echo Pulling changes...
    git pull

    echo ----------------------------------
    echo Pull completed for !currentPath!
    echo ----------------------------------

    set /a count+=1
    echo Waiting for %waittime% seconds before next pull...
    timeout /t %waittime% >nul
)

echo Total pulls: %count%
pause