@echo off
setlocal enabledelayedexpansion

:: variables 
set "waittime=3"
set "repo_file=repos.txt"
set "count=0"

for /f "usebackq delims=" %%R in ("%repo_file%") do (
    echo itteration !count!
    set "currentPath=%%R"
    echo Current path: !currentPath!
    cd /d "!currentPath!"
    git pull

    echo ----------------------------------
    echo Pull completed for !currentPath!
    echo ----------------------------------

    set /a count+=1
    timeout /t %waittime% >nul
)

echo Total pulls: %count%
pause