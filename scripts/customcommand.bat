@echo off
setlocal enabledelayedexpansion

:: Custom command executor script
:: This script receives a custom command as a parameter and executes it
:: Parameter 1: The custom command to execute
:: Parameter 2: The current repository path (optional)
:: Parameter 3: The log filename (optional)

set "custom_cmd=%~1"
set "repo_path=%~2"
set "log_filename=%~3"

:: Check if a command was provided
if "!custom_cmd!"=="" (
    echo No custom command provided to execute.
    exit /b 1
)

:: Set up logging if log filename is provided
if not "!log_filename!"=="" (
    set "LOG_PATH=%~dp0..\log\!log_filename!"
) else if defined AUTOPULL_LOGFILE (
    set "LOG_PATH=%~dp0..\log\%AUTOPULL_LOGFILE%"
)

:: Log the command execution
if defined LOG_PATH (
    if not "!repo_path!"=="" (
        echo %date% %time% - Executing custom command in !repo_path!: !custom_cmd! >> "!LOG_PATH!"
    ) else (
        echo %date% %time% - Executing custom command: !custom_cmd! >> "!LOG_PATH!"
    )
)

:: Execute the custom command
echo Executing: !custom_cmd!
%custom_cmd%

:: Capture the exit code
set "cmd_exit_code=!errorlevel!"

:: Log the result
if defined LOG_PATH (
    if !cmd_exit_code! equ 0 (
        echo %date% %time% - Custom command completed successfully >> "!LOG_PATH!"
    ) else (
        echo %date% %time% - Custom command failed with exit code: !cmd_exit_code! >> "!LOG_PATH!"
    )
)

:: Return the exit code
exit /b !cmd_exit_code!