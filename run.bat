@echo off
setlocal enabledelayedexpansion

echo  starting program
echo ----------------------------------

call scripts/log.bat
call scripts/checkforupdate.bat
call scripts/first_startup.bat

echo Starting git pull process...
echo %date% %time% - Starting git pull process. >> "log\%AUTOPULL_LOGFILE%"

:: Check which mode was selected using simple file existence
if exist "scripts\use_enhanced_mode.flag" (
    echo Running ENHANCED CATEGORY MODE...
    del "scripts\use_enhanced_mode.flag" >nul 2>&1
    call scripts/simple_git_pull_enhanced.bat repos_enhanced.txt
) else if exist "scripts\use_custom_file.flag" (
    set /p custom_filename=<"scripts\use_custom_file.flag"
    del "scripts\use_custom_file.flag" >nul 2>&1
    echo Running with custom file: !custom_filename!
    call scripts/simple_git_pull.bat "!custom_filename!"
) else (
    echo Running NORMAL MODE...
    call scripts/simple_git_pull.bat
)

echo Program finished.
echo ----------------------------------
echo %date% %time% - Program finished. >> "log\%AUTOPULL_LOGFILE%"
pause