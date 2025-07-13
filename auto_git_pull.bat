@echo off
setlocal enabledelayedexpansion

:: variables 
set "waittime=3"        :: seconds to wait between pulls
set "repo_file=repos.txt" :: file containing paths to git repositories
set "count=0" :: counter for number of pulls

for /f "usebackq delims=" %%R in ("%repo_file%") do (
    echo itteration %count%
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