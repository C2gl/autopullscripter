@ echo off
setlocal enabledelayedexpansion
:: file meant to be run by run.bat, will check if there is a log folder and create it if not
:: then it will log the current date and time to a log file 

set "logfile=log.txt"
if not exist "log" (
    mkdir "log"
    echo Log folder created."
)

:: Get date and time, remove invalid filename characters
set "dt=%date%_%time%"
set "dt=%dt:/=-%"
set "dt=%dt::=-%"
set "dt=%dt: =_%"
set "dt=%dt:.=-%"

:: Create unique logfile name
set "logfile=log_%dt%.txt"

:: Write to the unique logfile
echo %date% %time% >> "log\%logfile%"