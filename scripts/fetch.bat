echo    --- Fetching latest changes from the remote repository before pulling...
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

if "!fetch_error!"=="true" (
    echo ERROR ^| Git fetch failed for !currentPath!
    echo %date% %time% - ERROR ^| Git fetch failed for !currentPath! - Exit code: !fetch_exit_code! >> "%LOG_PATH%"
    echo %date% %time% - ERROR ^| Fetch output: !fetch_output! >> "%LOG_PATH%"
) else (
    echo SUCCESS ^| Fetch completed for !currentPath!
    echo %date% %time% - SUCCESS ^| Fetch completed for !currentPath! >> "%LOG_PATH%"
)

:: Display the output to user
type temp_fetch_output.txt

:: Clean up temporary file
del temp_fetch_output.txt

echo ----------------------------------