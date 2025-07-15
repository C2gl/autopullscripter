@echo off
setlocal enabledelayedexpansion

echo  starting program
echo ----------------------------------

set /p "auto=Do you want to run default configurations? (y/n): "

if /i "%auto%"=="y" (
    echo Running default configurations...
    call auto_git_pull.bat
    
) else (
    echo Skipping default configurations.
)

call auto_git_pull.bat
