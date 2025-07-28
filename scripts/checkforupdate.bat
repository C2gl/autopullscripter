@echo off
setlocal enabledelayedexpansion

:: GitHub Update Checker for AutoPullScripter
:: This script checks if the current version matches the latest GitHub release

:: Enable ANSI escape sequences for color support
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: Color codes
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "RESET=%ESC%[0m"

:: Configuration
set "GITHUB_REPO=C2gl/autopullscripter"
set "CURRENT_VERSION=v0.3.1"
set "TEMP_FILE=%temp%\github_latest_release.json"

:: Set up logging path
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"

echo Checking for updates...
echo Current version: %CURRENT_VERSION%
echo %date% %time% - Update checker started - Current version: %CURRENT_VERSION% >> "%LOG_PATH%"

:: Check if curl is available (Windows 10+ usually has it)
where curl >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Warning: curl not found. Cannot check for updates.
    echo Please visit https://github.com/%GITHUB_REPO%/releases to check manually.
    echo %date% %time% - ERROR: curl not found, cannot check for updates >> "%LOG_PATH%"
    goto :end
)

:: Fetch latest release information from GitHub API
echo Fetching latest release information...
echo %date% %time% - Fetching latest release from GitHub API: %GITHUB_REPO% >> "%LOG_PATH%"
curl -s "https://api.github.com/repos/%GITHUB_REPO%/releases/latest" > "%TEMP_FILE%" 2>nul

if %ERRORLEVEL% neq 0 (
    echo Error: Could not fetch release information from GitHub.
    echo Please check your internet connection or visit:
    echo https://github.com/%GITHUB_REPO%/releases
    echo %date% %time% - ERROR: Failed to fetch release information from GitHub API >> "%LOG_PATH%"
    goto :cleanup
)

:: Extract version tag from JSON response
:: This uses a simple findstr approach since Windows batch doesn't have native JSON parsing
for /f "tokens=2 delims=:," %%a in ('findstr /i "tag_name" "%TEMP_FILE%"') do (
    set "LATEST_VERSION=%%a"
    :: Remove quotes and spaces
    set "LATEST_VERSION=!LATEST_VERSION:"=!"
    set "LATEST_VERSION=!LATEST_VERSION: =!"
)

if "%LATEST_VERSION%"=="" (
    echo Error: Could not parse version information from GitHub response.
    echo %date% %time% - ERROR: Could not parse version information from GitHub API response >> "%LOG_PATH%"
    goto :cleanup
)

echo Latest version: %LATEST_VERSION%
echo %date% %time% - Successfully retrieved latest version: %LATEST_VERSION% >> "%LOG_PATH%"
echo.

:: Compare versions
if "%CURRENT_VERSION%"=="%LATEST_VERSION%" (
    :: Success message with green color
    echo.
    echo %GREEN%[+] You are running the latest version^^!%RESET%
    echo %date% %time% - OK: Running latest version %CURRENT_VERSION% >> "%LOG_PATH%"
) else (
    :: Update available message with red color
    echo.
    echo %RED%[^^!] Update available^^!%RESET%
    echo.
    echo Your version: %CURRENT_VERSION%
    echo Latest version: %LATEST_VERSION%
    echo.
    echo Download the latest version from:
    echo https://github.com/%GITHUB_REPO%/releases/latest
    echo %date% %time% - UPDATE AVAILABLE: Current %CURRENT_VERSION% vs Latest %LATEST_VERSION% >> "%LOG_PATH%"
    echo.
    
    :: Ask if user wants to open the releases page
    set /p "OPEN_PAGE=Would you like to open the releases page? (y/n): "
    if /i "!OPEN_PAGE!"=="y" (
        start "" "https://github.com/%GITHUB_REPO%/releases/latest"
        echo %date% %time% - User opened releases page in browser >> "%LOG_PATH%"
    ) else (
        echo %date% %time% - User declined to open releases page >> "%LOG_PATH%"
    )
)

:cleanup
if exist "%TEMP_FILE%" del "%TEMP_FILE%" >nul 2>&1
echo %date% %time% - Update checker completed >> "%LOG_PATH%"

:end
echo.