@ echo off
:: file meant to be run by run.bat, will check if there is a log folder and create it if not
:: then it will log the current date and time to a log file 

if not exist "log" (
    mkdir "log"
    echo Log folder created.
)

:: Get date and time, remove invalid filename characters
set "dt=%date%_%time%"
set "dt=%dt:/=-%"
set "dt=%dt::=-%"
set "dt=%dt: =_%"
set "dt=%dt:.=-%"

:: Create unique logfile name and set as environment variable
set "AUTOPULL_LOGFILE=log_%dt%.txt"

:: Initialize counters
set "SUCCESS_COUNT=0"
set "ERROR_COUNT=0"

:: Write to the unique logfile
echo %date% %time% - Session started >> "log\%AUTOPULL_LOGFILE%"