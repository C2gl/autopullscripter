@echo off
setlocal enabledelayedexpansion

:: Default variables 
set "waittime=3"
set "repo_file=repos.txt"
set "count=0"
set "toFetch=n"
set "docustomcommand=n"
set "customcommand="
set "total_repos=0"
set "SUCCESS_COUNT=0"
set "ERROR_COUNT=0"
set "verbose=n"

:: Store the original script directory for logging
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"

:: Count total repositories (excluding empty lines)
echo Counting repositories...
for /f "usebackq delims=" %%R in ("%repo_file%") do (
    set "line=%%R"
    if not "!line!"=="" (
        set /a total_repos+=1
    )
)
echo Found !total_repos! repositories to process.

:: Ask if user wants to use default settings
echo ==================================
echo Auto Git Pull Script
echo ==================================
echo Default settings:
echo - Wait time: 3 seconds between pulls
echo - Fetch before pull: No
echo - Custom command: No
echo - verbose mode: No
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
    set /p "verbose=Enable verbose mode? (y/n, default is n): "

    :: Validate and set defaults for empty inputs
    if "!waittime!"=="" set "waittime=3"
    if "!toFetch!"=="" set "toFetch=n"
    if "!docustomcommand!"=="" set "docustomcommand=n"
    if "!verbose!"=="" set "verbose=n"
    
    :: logging user input
    echo %date% %time% - Custom settings: Wait time: !waittime!, Fetch: !toFetch!, Custom command: !docustomcommand!, verbose mode : !verbose! >> "%LOG_PATH%"

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
echo - Total repositories: !total_repos!
echo.

:: loop through each repository path in the file
for /f "usebackq delims=" %%R in ("%repo_file%") do (
    set "currentPath=%%R"
    
    :: Skip empty lines
    if not "!currentPath!"=="" (
        set /a count+=1
        
        if /i "!verbose!"=="y" (
            echo.
            echo ==================================
            echo PROCESSING REPOSITORY !count!/!total_repos!
            echo ==================================
            echo Current path: !currentPath!
            
            :: Show progress bar
            call :show_progress !count! !total_repos!
        ) else (
            :: Condensed output for non-verbose mode
            for %%F in ("!currentPath!") do set "repo_name=%%~nxF"
            echo [!count!/!total_repos!] !repo_name!
            call :show_progress !count! !total_repos!
        )
    
    :: Check if path exists before trying to cd
    if exist "!currentPath!" (
        echo %date% %time% - Processing repository: !currentPath! >> "%LOG_PATH%"
        cd /d "!currentPath!"

        :: Optional fetch before pull
        if /i "!toFetch!"=="y" (
            if /i "!verbose!"=="y" (
                echo Fetching latest changes from the remote repository before pulling...
            )
            call "%~dp0fetch.bat"
            if /i "!verbose!"=="y" (
                echo Fetch completed for !currentPath!
            )
        )

        if /i "!verbose!"=="y" (
            echo Pulling changes...
        )
        
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
        
        :: Display the output to user (only in verbose mode)
        if /i "!verbose!"=="y" (
            type temp_output.txt
        )
        
        :: Also append complete git output to log file
        type temp_output.txt >> "%LOG_PATH%"
        
        if "!is_error!"=="true" (
            :: Error detected
            set /a ERROR_COUNT+=1
            if /i "!verbose!"=="y" (
                echo ERROR ^| Git pull failed for !currentPath!
            ) else (
                echo ERROR
            )
            echo %date% %time% - ERROR ^| Git pull failed for !currentPath! - Exit code: !git_exit_code! >> "%LOG_PATH%"
        ) else (
            :: Success
            set /a SUCCESS_COUNT+=1
            if /i "!verbose!"=="y" (
                echo SUCCESS ^| Pull completed for !currentPath!
            ) else (
                echo OK
            )
            echo %date% %time% - SUCCESS ^| Pull completed for !currentPath! >> "%LOG_PATH%"
        )
        
        :: Clean up temporary file
        del temp_output.txt
        
    ) else (
        set /a ERROR_COUNT+=1
        if /i "!verbose!"=="y" (
            echo ERROR ^| Path does not exist: !currentPath!
        ) else (
            echo PATH NOT FOUND
        )
        echo %date% %time% - ERROR ^| Path does not exist: !currentPath! >> "%LOG_PATH%"
    )

    :: Optional custom command execution
    if /i "!docustomcommand!"=="y" (
        if /i "!verbose!"=="y" (
            echo Running custom command: !customcommand!
        )
        echo %date% %time% - Running custom command: !customcommand! >> "%LOG_PATH%"
        !customcommand!
    )

    if /i "!verbose!"=="y" (
        echo ----------------------------------
        echo Completed repository !count!/!total_repos!: !currentPath!
        echo ----------------------------------

        if !count! lss !total_repos! (
            echo Waiting for !waittime! seconds before next pull...
            timeout /t !waittime! >nul
        )
    ) else (
        if !count! lss !total_repos! (
            timeout /t !waittime! >nul
        )
    )
    
    ) else (
        echo Skipping empty line in repos.txt
    )
)

echo.
echo ==================================
echo ALL REPOSITORIES PROCESSED!
echo ==================================
call :show_progress !total_repos! !total_repos!
echo.
echo ==================================
echo SUMMARY
echo ==================================
echo Total repositories processed: !total_repos!
echo Successful operations: !SUCCESS_COUNT!
echo Failed operations: !ERROR_COUNT!
echo ==================================
echo %date% %time% - Git pull process completed. Total: !total_repos!, Success: !SUCCESS_COUNT!, Errors: !ERROR_COUNT! >> "%LOG_PATH%"
pause

:: Function to display progress bar
:show_progress
setlocal enabledelayedexpansion
set "current=%1"
set "total=%2"
set "bar_length=20"
set "filled=0"
set "progress_bar="

:: Calculate filled portion
set /a "filled=(!current! * !bar_length!) / !total!"

:: Build progress bar
for /l %%i in (1,1,!bar_length!) do (
    if %%i leq !filled! (
        set "progress_bar=!progress_bar!#"
    ) else (
        set "progress_bar=!progress_bar!-"
    )
)

:: Display progress bar
echo Progress: [!progress_bar!] (!current!/!total!)
endlocal
goto :eof
