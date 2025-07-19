echo    --- Fetching latest changes from the remote repository before pulling...
echo %date% %time% - Fetching latest changes for !currentPath! >> "%LOG_PATH%"

:: Capture git fetch output to a temporary file, then display and log it
git fetch > temp_fetch_output.txt 2>&1

:: Display the output to user
type temp_fetch_output.txt

:: Also append to log file
type temp_fetch_output.txt >> "%LOG_PATH%"

:: Clean up temporary file
del temp_fetch_output.txt

echo    --- Fetch completed for !currentPath!
echo %date% %time% - Fetch completed for !currentPath! >> "%LOG_PATH%"
echo ----------------------------------