@echo off
setlocal enabledelayedexpansion

echo  starting program
echo ----------------------------------

call scripts/log.bat
call scripts/checkforupdate.bat
call scripts/first_startup.bat

echo Starting git pull process...
echo %date% %time% - Starting git pull process. >> "log\%AUTOPULL_LOGFILE%"
call scripts/simple_git_pull.bat

echo Program finished.
echo ----------------------------------
echo %date% %time% - Program finished. >> "log\%AUTOPULL_LOGFILE%"
pause