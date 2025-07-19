@echo off
setlocal enabledelayedexpansion

:: variables 
set "waittime=3"
set "repo_file=repos.txt"
set "count=0"

:: Store the original script directory for logging
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"

:: loop through each repository path in the file
for /f "usebackq delims=" %%R in ("%repo_file%") do (
    echo ITTERATION !count!
    set "currentPath=%%R"
    echo Current path: !currentPath!
    
    :: Check if path exists before trying to cd
    if exist "!currentPath!" (
        echo %date% %time% - Processing repository: !currentPath! >> "%LOG_PATH%"
        cd /d "!currentPath!"
        
        echo Pulling changes...
        
        :: Capture git pull output to a temporary file, then display and log it
        git pull > temp_output.txt 2>&1
        
        :: Display the output to user
        type temp_output.txt
        
        :: Also append to log file
        type temp_output.txt >> "%LOG_PATH%"
        
        :: Clean up temporary file
        del temp_output.txt
        
        echo %date% %time% - Pull completed for !currentPath! >> "%LOG_PATH%"
    ) else (
        echo ERROR: Path does not exist: !currentPath!
        echo %date% %time% - ERROR: Path does not exist: !currentPath! >> "%LOG_PATH%"
    )

    echo ----------------------------------
    echo Pull completed for !currentPath!
    echo ----------------------------------

    set /a count+=1
    timeout /t %waittime% >nul
)

echo Total pulls: %count%
echo %date% %time% - Auto git pull process completed. Total pulls: %count% >> "%LOG_PATH%"
pause