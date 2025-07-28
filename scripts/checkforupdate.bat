@echo off
setlocal enabledelayedexpansion

:: GitHub Update Checker for AutoPullScripter
:: This script checks if the current version matches the latest GitHub release

:: Configuration
set "GITHUB_REPO=C2gl/autopullscripter"
set "CURRENT_VERSION=v0.3.1"
set "TEMP_FILE=%temp%\github_latest_release.json"

echo Checking for updates...
echo Current version: %CURRENT_VERSION%

:: Check if curl is available (Windows 10+ usually has it)
where curl >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Warning: curl not found. Cannot check for updates.
    echo Please visit https://github.com/%GITHUB_REPO%/releases to check manually.
    goto :end
)

:: Fetch latest release information from GitHub API
echo Fetching latest release information...
curl -s "https://api.github.com/repos/%GITHUB_REPO%/releases/latest" > "%TEMP_FILE%" 2>nul

if %ERRORLEVEL% neq 0 (
    echo Error: Could not fetch release information from GitHub.
    echo Please check your internet connection or visit:
    echo https://github.com/%GITHUB_REPO%/releases
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
    goto :cleanup
)

echo Latest version: %LATEST_VERSION%
echo.

:: Compare versions
if "%CURRENT_VERSION%"=="%LATEST_VERSION%" (
    :: Green color for success message
    echo [92m[+] You are running the latest version![0m
) else (
    :: Red color for update available
    echo [91m[!] Update available![0m
    echo.
    echo Your version: %CURRENT_VERSION%
    echo Latest version: %LATEST_VERSION%
    echo.
    echo Download the latest version from:
    echo https://github.com/%GITHUB_REPO%/releases/latest
    echo.
    
    :: Ask if user wants to open the releases page
    set /p "OPEN_PAGE=Would you like to open the releases page? (y/n): "
    if /i "!OPEN_PAGE!"=="y" (
        start "" "https://github.com/%GITHUB_REPO%/releases/latest"
    )
)

:cleanup
if exist "%TEMP_FILE%" del "%TEMP_FILE%" >nul 2>&1

:end
echo.