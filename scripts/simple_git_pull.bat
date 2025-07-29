@echo off
setlocal enabledelayedexpansion

:: Enable ANSI escape sequences for color support
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: Color codes
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "LIGHT_BLUE=%ESC%[94m"
set "GRAY=%ESC%[90m"
set "RESET=%ESC%[0m"

:: Default variables 
set "waittime=1"
set "repo_file=repos.txt"
set "count=0"
set "toFetch=n"
set "docustomcommand=n"
set "customcommand="
set "total_repos=0"
set "SUCCESS_COUNT=0"
set "ERROR_COUNT=0"
set "UPDATED_COUNT=0"
set "verbose=n"

:: Check if a custom repos file was provided as parameter
if not "%~1"=="" (
    set "repo_file=%~dp0..\%~1"
    echo Using custom repos file: %~1
) else (
    set "repo_file=%~dp0..\repos.txt"
    echo Using default repos file: repos.txt
)

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
echo - Wait time: 1 seconds between pulls
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
    if "!waittime!"=="" set "waittime=1"
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

:: Ensure counters are properly initialized before the loop
set "SUCCESS_COUNT=0"
set "ERROR_COUNT=0"
set "UPDATED_COUNT=0"

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
            echo Current path: %LIGHT_BLUE%!currentPath!%RESET%
            
            :: Show progress bar
            call :show_progress !count! !total_repos!
        ) else (
            :: Condensed output for non-verbose mode
            for %%F in ("!currentPath!") do set "repo_name=%%~nxF"
            echo [!count!/!total_repos!] %LIGHT_BLUE%!repo_name!%RESET%
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
            call "%~dp0fetch.bat" "!verbose!"
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
        
        :: Check for errors and status using the temp file directly (safer than building a variable)
        set "is_error=false"
        set "is_up_to_date=false"
        set "has_changes=false"
        
        if !git_exit_code! neq 0 set "is_error=true"
        findstr /i "error fatal denied permission authentication" temp_output.txt >nul 2>&1
        if !errorlevel! equ 0 set "is_error=true"
        
        :: Check if already up to date
        findstr /i "already up" temp_output.txt | findstr /i "to date" >nul 2>&1
        if !errorlevel! equ 0 set "is_up_to_date=true"
        
        :: Check if changes were pulled (common indicators)
        findstr /i "fast-forward updating" temp_output.txt >nul 2>&1
        if !errorlevel! equ 0 set "has_changes=true"
        if "!has_changes!"=="false" (
            findstr /i "files changed" temp_output.txt >nul 2>&1
            if !errorlevel! equ 0 set "has_changes=true"
        )
        if "!has_changes!"=="false" (
            findstr /i "insertions" temp_output.txt >nul 2>&1
            if !errorlevel! equ 0 set "has_changes=true"
        )
        if "!has_changes!"=="false" (
            findstr /i "deletions" temp_output.txt >nul 2>&1
            if !errorlevel! equ 0 set "has_changes=true"
        )
        
        :: Display the output to user (only in verbose mode)
        if /i "!verbose!"=="y" (
            echo %GRAY%
            type temp_output.txt
            echo %RESET%
        )
        
        :: Also append complete git output to log file
        type temp_output.txt >> "%LOG_PATH%"
        
        if "!is_error!"=="true" (
            :: Error detected
            set /a ERROR_COUNT+=1
            if /i "!verbose!"=="y" (
                echo %RED%ERROR%RESET% ^| Git pull failed for !currentPath!
            ) else (
                echo %RED%ERROR%RESET%
            )
            echo %date% %time% - ERROR ^| Git pull failed for !currentPath! - Exit code: !git_exit_code! >> "%LOG_PATH%"
        ) else if "!is_up_to_date!"=="true" (
            :: Already up to date
            set /a SUCCESS_COUNT+=1
            if /i "!verbose!"=="y" (
                echo %YELLOW%OK - ALREADY UP TO DATE%RESET% ^| No changes for !currentPath!
            ) else (
                echo %YELLOW%OK - ALREADY UP TO DATE%RESET%
            )
            echo %date% %time% - OK - ALREADY UP TO DATE ^| No changes for !currentPath! >> "%LOG_PATH%"
        ) else if "!has_changes!"=="true" (
            :: Changes were pulled
            set /a SUCCESS_COUNT+=1
            set /a UPDATED_COUNT+=1
            if /i "!verbose!"=="y" (
                echo %GREEN%OK - PULLED NEW CHANGES%RESET% ^| Changes pulled for !currentPath!
            ) else (
                echo %GREEN%OK - PULLED NEW CHANGES%RESET%
            )
            echo %date% %time% - OK - PULLED NEW CHANGES ^| Changes pulled for !currentPath! >> "%LOG_PATH%"
        ) else (
            :: Generic success (fallback)
            set /a SUCCESS_COUNT+=1
            if /i "!verbose!"=="y" (
                echo %GREEN%OK%RESET% ^| Pull completed for !currentPath!
            ) else (
                echo %GREEN%OK%RESET%
            )
            echo %date% %time% - OK ^| Pull completed for !currentPath! >> "%LOG_PATH%"
        )
        
        :: Clean up temporary file
        del temp_output.txt
        
    ) else (
        set /a ERROR_COUNT+=1
        if /i "!verbose!"=="y" (
            echo %RED%ERROR%RESET% ^| Path does not exist: !currentPath!
        ) else (
            echo %RED%PATH NOT FOUND%RESET%
        )
        echo %date% %time% - ERROR ^| Path does not exist: !currentPath! >> "%LOG_PATH%"
    )

    :: Optional custom command execution
    if /i "!docustomcommand!"=="y" (
        if /i "!verbose!"=="y" (
            echo.
            echo %YELLOW%Running custom command:%RESET% !customcommand!
        )
        :: Pass the custom command, current repository path, log file, and verbose mode to the custom command script
        call "%~dp0customcommand.bat" "!customcommand!" "!currentPath!" "%AUTOPULL_LOGFILE%" "!verbose!"
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
echo Repositories updated: !UPDATED_COUNT!
echo Failed operations: !ERROR_COUNT!
echo ==================================
echo %date% %time% - Git pull process completed. Total: !total_repos!, Success: !SUCCESS_COUNT!, Updated: !UPDATED_COUNT!, Errors: !ERROR_COUNT! >> "%LOG_PATH%"
pause

exit /b

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

:: calculate percentage
set /a "percentage=(!current! * 100) / !total!"

:: Display progress bar
echo Progress: [!progress_bar!] !percentage!%% complete
endlocal
goto :eof
