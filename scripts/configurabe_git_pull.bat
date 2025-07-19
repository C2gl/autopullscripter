@echo off
setlocal enabledelayedexpansion

:: variables 
set "waittime=3"
set "repo_file=repos.txt"
set "count=0"

:: Store the original script directory for logging
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"

:: user set variables 
set /p "waittime=Enter wait time between pulls (default is 3 seconds): "
set /p "toFetch=Do you want to fetch latest changes before pulling? (y/n): "
set /p "docustomcommand=Do you want to run a custom command before pulling? (y/n): "

if /i "!docustomcommand!"=="y" (
    set /p "customcommand=Enter the custom command to run: "
)


:: loop through each repository path in the file
for /f "usebackq delims=" %%R in ("%repo_file%") do (
    echo ITTERATION !count!
    set "currentPath=%%R"
    echo Current path: !currentPath!
    
    :: Check if path exists before trying to cd
    if exist "!currentPath!" (
        echo %date% %time% - Processing repository: !currentPath! >> "%LOG_PATH%"
        cd /d "!currentPath!"

        if /i "!toFetch!"=="y" (
            echo Fetching latest changes from the remote repository before pulling...
            call "%~dp0fetch.bat"
            echo Fetch completed for !currentPath!
        )

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