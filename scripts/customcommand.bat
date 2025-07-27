@echo off
setlocal enabledelayedexpansion

:: Enable ANSI escape sequences for color support
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: Color codes
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "LIGHT_BLUE=%ESC%[94m"
set "RESET=%ESC%[0m"

:: Custom command executor script
:: This script receives a custom command as a parameter and executes it
:: Parameter 1: The custom command to execute
:: Parameter 2: The current repository path (optional)
:: Parameter 3: The log filename (optional)
:: Parameter 4: Verbose mode (y/n, optional)

set "custom_cmd=%~1"
set "repo_path=%~2"
set "log_filename=%~3"
set "verbose=%~4"

:: Default verbose to 'n' if not provided
if "!verbose!"=="" set "verbose=n"

:: Check if a command was provided
if "!custom_cmd!"=="" (
    echo %RED% ERROR %RESET% ^| No custom command provided to execute.
    if /i "!verbose!"=="y" (
        echo %YELLOW%VERBOSE%RESET% ^| Custom command script called without a command parameter.
    )
    exit /b 1
)

:: Set up logging if log filename is provided
if not "!log_filename!"=="" (
    set "LOG_PATH=%~dp0..\log\!log_filename!"
) else if defined AUTOPULL_LOGFILE (
    set "LOG_PATH=%~dp0..\log\%AUTOPULL_LOGFILE%"
)

:: Verbose mode output
if /i "!verbose!"=="y" (
    echo.
    echo %LIGHT_BLUE%==== CUSTOM COMMAND EXECUTION ====%RESET%
    echo %LIGHT_BLUE%Command:%RESET% !custom_cmd!
    if not "!repo_path!"=="" (
        echo %LIGHT_BLUE%Repository:%RESET% !repo_path!
    )
    if defined LOG_PATH (
        echo %LIGHT_BLUE%Log file:%RESET% !LOG_PATH!
    )
    echo %LIGHT_BLUE%Verbose mode:%RESET% !verbose!
    echo %LIGHT_BLUE%=================================%RESET%
)

:: Log the command execution
if defined LOG_PATH (
    if not "!repo_path!"=="" (
        echo %date% %time% - Executing custom command in !repo_path!: !custom_cmd! >> "!LOG_PATH!"
    ) else (
        echo %date% %time% - Executing custom command: !custom_cmd! >> "!LOG_PATH!"
    )
    if /i "!verbose!"=="y" (
        echo %date% %time% - Custom command verbose mode: enabled >> "!LOG_PATH!"
    )
)

:: Execute the custom command
if /i "!verbose!"=="y" (
    echo %YELLOW%Executing custom command...%RESET%
    echo %LIGHT_BLUE%Command output:%RESET%
    echo ----------------------------------
)

:: Execute and capture both output and error code
%custom_cmd% 2>&1
set "cmd_exit_code=!errorlevel!"

if /i "!verbose!"=="y" (
    echo ----------------------------------
)

:: Display result and log
if !cmd_exit_code! equ 0 (
    if /i "!verbose!"=="y" (
        echo %GREEN%SUCCESS%RESET% ^| Custom command completed successfully
    ) else (
        echo %GREEN%CUSTOM COMMAND OK%RESET%
    )
    if defined LOG_PATH (
        echo %date% %time% - Custom command completed successfully with exit code: !cmd_exit_code! >> "!LOG_PATH!"
    )
) else (
    if /i "!verbose!"=="y" (
        echo %RED%ERROR%RESET% ^| Custom command failed with exit code: !cmd_exit_code!
    ) else (
        echo %RED%CUSTOM COMMAND FAILED%RESET%
    )
    if defined LOG_PATH (
        echo %date% %time% - Custom command failed with exit code: !cmd_exit_code! >> "!LOG_PATH!"
    )
)

:: Verbose mode summary
if /i "!verbose!"=="y" (
    echo.
    echo %LIGHT_BLUE%==== CUSTOM COMMAND SUMMARY ====%RESET%
    echo %LIGHT_BLUE%Exit code:%RESET% !cmd_exit_code!
    if !cmd_exit_code! equ 0 (
        echo %LIGHT_BLUE%Status:%RESET% %GREEN%Success%RESET%
    ) else (
        echo %LIGHT_BLUE%Status:%RESET% %RED%Failed%RESET%
    )
    echo %LIGHT_BLUE%=================================%RESET%
    echo.
)

:: Return the exit code
exit /b !cmd_exit_code!