@echo off
setlocal enabledelayedexpansion

:: Default variables 
set "waittime=3"
set "repo_file=repos.txt"
set "count=0"
set "toFetch=n"
set "docustomcommand=n"
set "customcommand="

:: Store the original script directory for logging
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"

:: Ask if user wants to use default settings
echo ==================================
echo Auto Git Pull Script
echo ==================================
echo Default settings:
echo - Wait time: 3 seconds between pulls
echo - Fetch before pull: No
echo - Custom command: No
echo ==================================
echo.
set /p "useDefaults=Use default settings? (y/n, default is y): "

:: If empty input, default to yes
if "!useDefaults!"=="" set "useDefaults=y"

if /i "!useDefaults!"=="y" (
    echo Using default settings...
    echo %date% %time% - Using default settings: Wait time: !waittime!, Fetch: !toFetch!, Custom command: !docustomcommand! >> "%LOG_PATH%"
) else (
    echo Configuring custom settings...
    
    :: Custom user input
    set /p "waittime=Enter wait time between pulls (default is 3 seconds): "
    set /p "toFetch=Do you want to fetch latest changes before pulling? (y/n): "
    set /p "docustomcommand=Do you want to run a custom command after pulling? (y/n): "
    
    :: Validate and set defaults for empty inputs
    if "!waittime!"=="" set "waittime=3"
    if "!toFetch!"=="" set "toFetch=n"
    if "!docustomcommand!"=="" set "docustomcommand=n"
    
    :: logging user input
    echo %date% %time% - Custom settings: Wait time: !waittime!, Fetch: !toFetch!, Custom command: !docustomcommand! >> "%LOG_PATH%"
    
    if /i "!docustomcommand!"=="y" (
        set /p "customcommand=Enter the custom command to run: "
    )
)

echo.
echo Starting git pull process with settings:
echo - Wait time: !waittime! seconds
echo - Fetch before pull: !toFetch!
echo - Custom command: !docustomcommand!
if /i "!docustomcommand!"=="y" echo - Command: !customcommand!
echo.

:: loop through each repository path in the file
for /f "usebackq delims=" %%R in ("%repo_file%") do (
    echo ITERATION !count!
    set "currentPath=%%R"
    echo Current path: !currentPath!
    
    :: Check if path exists before trying to cd
    if exist "!currentPath!" (
        echo %date% %time% - Processing repository: !currentPath! >> "%LOG_PATH%"
        cd /d "!currentPath!"

        :: Optional fetch before pull
        if /i "!toFetch!"=="y" (
            echo Fetching latest changes from the remote repository before pulling...
            call "%~dp0fetch.bat"
            echo Fetch completed for !currentPath!
        )

        echo Pulling changes...
        
        :: Capture git pull output and exit code
        git pull > temp_output.txt 2>&1
        set "git_exit_code=!errorlevel!"
        
        :: Read the output for error detection
        set "git_output="
        for /f "delims=" %%i in (temp_output.txt) do (
            set "git_output=!git_output!%%i "
        )
        
        :: Check for errors (exit code or common error patterns)
        set "is_error=false"
        if !git_exit_code! neq 0 set "is_error=true"
        echo !git_output! | findstr /i "error fatal denied permission authentication" >nul
        if !errorlevel! equ 0 set "is_error=true"
        
        :: Display the output to user
        type temp_output.txt
        
        :: Also append complete git output to log file
        type temp_output.txt >> "%LOG_PATH%"
        
        if "!is_error!"=="true" (
            :: Error detected
            set /a ERROR_COUNT+=1
            echo ERROR ^| Git pull failed for !currentPath!
            echo %date% %time% - ERROR ^| Git pull failed for !currentPath! - Exit code: !git_exit_code! >> "%LOG_PATH%"
        ) else (
            :: Success
            set /a SUCCESS_COUNT+=1
            echo SUCCESS ^| Pull completed for !currentPath!
            echo %date% %time% - SUCCESS ^| Pull completed for !currentPath! >> "%LOG_PATH%"
        )
        
        :: Clean up temporary file
        del temp_output.txt
        
    ) else (
        set /a ERROR_COUNT+=1
        echo ERROR ^| Path does not exist: !currentPath!
        echo %date% %time% - ERROR ^| Path does not exist: !currentPath! >> "%LOG_PATH%"
    )

    :: Optional custom command execution
    if /i "!docustomcommand!"=="y" (
        echo Running custom command: !customcommand!
        echo %date% %time% - Running custom command: !customcommand! >> "%LOG_PATH%"
        !customcommand!
    )

    echo ----------------------------------
    echo Pull completed for !currentPath!
    echo ----------------------------------

    set /a count+=1
    echo Waiting for !waittime! seconds before next pull...
    timeout /t !waittime! >nul
)

echo Total pulls: !count!
echo.
echo ==================================
echo SUMMARY
echo ==================================
echo Total repositories processed: !count!
echo Successful operations: !SUCCESS_COUNT!
echo Failed operations: !ERROR_COUNT!
echo ==================================
echo %date% %time% - Git pull process completed. Total: !count!, Success: !SUCCESS_COUNT!, Errors: !ERROR_COUNT! >> "%LOG_PATH%"
pause
