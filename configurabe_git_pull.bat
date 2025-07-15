@echo off
setlocal enabledelayedexpansion

:: variables 
set "waittime=3"
set "repo_file=repos.txt"
set "count=0"

:: user set variables 
set /p "waittime=Enter wait time between pulls (default is 3 seconds): "

for /f "usebackq delims=" %%R in ("%repo_file%") do (
    echo itteration !count!
    set "currentPath=%%R"
    echo Current path: !currentPath!
    cd /d "!currentPath!"
    
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