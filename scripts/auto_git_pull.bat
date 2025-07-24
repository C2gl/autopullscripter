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
        
        :: First display git pull with colors to terminal
        echo %date% %time% - Starting git pull for !currentPath! >> "%LOG_PATH%"
        git -c color.ui=always pull
        set "git_exit_code=!errorlevel!"
        
        :: Capture git pull output for error detection (without colors for parsing)
        git pull > temp_output.txt 2>&1
        
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
        
        :: Append git output to log file (without colors for clean logs)
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

    echo ----------------------------------
    echo Pull completed for !currentPath!
    echo ----------------------------------

    set /a count+=1
    timeout /t %waittime% >nul
)

echo Total pulls: %count%
echo.
echo ==================================
echo SUMMARY
echo ==================================
echo Total repositories processed: %count%
echo Successful operations: %SUCCESS_COUNT%
echo Failed operations: %ERROR_COUNT%
echo ==================================
echo %date% %time% - Auto git pull process completed. Total: %count%, Success: %SUCCESS_COUNT%, Errors: %ERROR_COUNT% >> "%LOG_PATH%"
pause