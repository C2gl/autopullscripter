@echo off
setlocal enabledelayedexpansion

echo  starting program
echo ----------------------------------

call scripts/log.bat
call scripts/first_startup.bat

set /p "auto=Do you want to run default configurations? (y/n): "

if /i "%auto%"=="y" (
    echo Running default configurations...
    echo %date% %time% - User chose to run default configurations. >> "log\%AUTOPULL_LOGFILE%"
    call scripts/auto_git_pull.bat

) else (
    echo Skipping default configurations.
    echo %date% %time% - User chose custom configurations. >> "log\%AUTOPULL_LOGFILE%"
    call scripts/configurabe_git_pull.bat
)

echo Program finished.
echo ----------------------------------
if defined SUCCESS_COUNT if defined ERROR_COUNT (
    echo.
    echo ==================================
    echo FINAL SUMMARY
    echo ==================================
    echo Total successful operations: %SUCCESS_COUNT%
    echo Total failed operations: %ERROR_COUNT%
    echo ==================================
)
echo %date% %time% - Program finished. >> "log\%AUTOPULL_LOGFILE%"
pause