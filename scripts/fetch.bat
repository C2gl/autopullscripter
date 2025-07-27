@echo off
setlocal enabledelayedexpansion

:: Enable ANSI escape sequences for color support
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: Color codes
set "GRAY=%ESC%[90m"
set "RESET=%ESC%[0m"

:: Accept verbose parameter (default to 'n' if not provided)
set "verbose=%~1"
if "!verbose!"=="" set "verbose=n"

if /i "!verbose!"=="y" (
    echo    --- Fetching latest changes from the remote repository before pulling...
)
echo %date% %time% - Fetching latest changes for !currentPath! >> "%LOG_PATH%"

:: Capture git fetch output and exit code
git fetch > temp_fetch_output.txt 2>&1
set "fetch_exit_code=!errorlevel!"

:: Read the output for error detection
set "fetch_output="
for /f "delims=" %%i in (temp_fetch_output.txt) do (
    set "fetch_output=!fetch_output!%%i "
)

:: Check for errors (exit code or common error patterns)
set "fetch_error=false"
if !fetch_exit_code! neq 0 set "fetch_error=true"
echo !fetch_output! | findstr /i "error fatal denied permission authentication" >nul
if !errorlevel! equ 0 set "fetch_error=true"

:: Display the output to user (only in verbose mode)
if /i "!verbose!"=="y" (
    echo %GRAY%
    type temp_fetch_output.txt
    echo %RESET%
)

:: Also append complete fetch output to log file
type temp_fetch_output.txt >> "%LOG_PATH%"

if "!fetch_error!"=="true" (
    if /i "!verbose!"=="y" (
        echo ERROR ^| Git fetch failed for !currentPath!
    )
    echo %date% %time% - ERROR ^| Git fetch failed for !currentPath! - Exit code: !fetch_exit_code! >> "%LOG_PATH%"
) else (
    if /i "!verbose!"=="y" (
        echo SUCCESS ^| Fetch completed for !currentPath!
    )
    echo %date% %time% - SUCCESS ^| Fetch completed for !currentPath! >> "%LOG_PATH%"
)

:: Clean up temporary file
del temp_fetch_output.txt

if /i "!verbose!"=="y" (
    echo ----------------------------------
)