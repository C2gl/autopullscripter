:: scan_repos.bat
:: Script to scan a given folder path for Git repositories and populate repos.txt
@echo off
setlocal enabledelayedexpansion

:: Enable error handling
set "error_occurred=false"

:: Store the original script directory for logging
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"

echo.
echo ===== Auto Repository Scanner =====
echo This will scan a folder path for Git repositories and add them to repos.txt
echo.

:: Get the folder path from user
set /p "scan_path=Enter the folder path to scan for repositories: "

:: Remove quotes if present
set "scan_path=!scan_path:"=!"

echo Debug: Entered path is: "!scan_path!"
echo %date% %time% - User input: Scan path: !scan_path! >> "%LOG_PATH%"

:: Validate the path exists
if not exist "!scan_path!" (
    echo ERROR: The specified path does not exist: !scan_path!
    echo %date% %time% - ERROR: Invalid scan path: !scan_path! >> "%LOG_PATH%"
    echo.
    echo Please check:
    echo - The path is correct
    echo - You have permission to access the folder
    echo - The folder exists
    pause
    exit /b 1
)

echo.
echo Path validated successfully: !scan_path!
echo Scanning folder: !scan_path!
echo Looking for Git repositories...
echo %date% %time% - Starting repository scan in: !scan_path! >> "%LOG_PATH%"

:: Counter for found repositories
set "repo_count=0"
set "added_count=0"

:: Create temporary file to store found repos
set "temp_repos=%TEMP%\found_repos_%RANDOM%.txt"
if exist "!temp_repos!" del "!temp_repos!"

echo Searching for Git repositories...
echo This may take a moment...

:: First, scan the root directory
if exist "!scan_path!\.git" (
    echo Checking repository: !scan_path!
    
    :: Check if this repo is already in repos.txt
    set "already_exists=false"
    if exist "%~dp0..\repos.txt" (
        findstr /i /c:"!scan_path!" "%~dp0..\repos.txt" >nul 2>&1
        if !errorlevel! equ 0 (
            set "already_exists=true"
            echo Repository already exists in repos.txt: !scan_path!
        )
    )
    
    if "!already_exists!"=="false" (
        echo Found new repository: !scan_path!
        echo !scan_path! >> "!temp_repos!"
        set /a repo_count+=1
    )
)

:: Then scan subdirectories
pushd "!scan_path!" 2>nul
if !errorlevel! equ 0 (
    for /d %%d in (*) do (
        if exist "%%d\.git" (
            set "repo_path=!scan_path!\%%d"
            echo Checking repository: !repo_path!
            
            :: Check if this repo is already in repos.txt
            set "already_exists=false"
            if exist "%~dp0..\repos.txt" (
                findstr /i /c:"!repo_path!" "%~dp0..\repos.txt" >nul 2>&1
                if !errorlevel! equ 0 (
                    set "already_exists=true"
                    echo Repository already exists in repos.txt: !repo_path!
                )
            )
            
            if "!already_exists!"=="false" (
                echo Found new repository: !repo_path!
                echo !repo_path! >> "!temp_repos!"
                set /a repo_count+=1
            )
        )
        
        :: Scan one level deeper
        if exist "%%d" (
            pushd "%%d" 2>nul
            if !errorlevel! equ 0 (
                for /d %%e in (*) do (
                    if exist "%%e\.git" (
                        set "repo_path=!scan_path!\%%d\%%e"
                        echo Checking repository: !repo_path!
                        
                        :: Check if this repo is already in repos.txt
                        set "already_exists=false"
                        if exist "%~dp0..\repos.txt" (
                            findstr /i /c:"!repo_path!" "%~dp0..\repos.txt" >nul 2>&1
                            if !errorlevel! equ 0 (
                                set "already_exists=true"
                                echo Repository already exists in repos.txt: !repo_path!
                            )
                        )
                        
                        if "!already_exists!"=="false" (
                            echo Found new repository: !repo_path!
                            echo !repo_path! >> "!temp_repos!"
                            set /a repo_count+=1
                        )
                    )
                )
                popd
            )
        )
    )
    popd
) else (
    echo ERROR: Cannot access directory !scan_path!
    echo Please check the path and try again.
    pause
    exit /b 1
)

:: Check if any new repositories were found
if !repo_count! equ 0 (
    echo.
    echo No new Git repositories found in the specified path.
    if exist "%~dp0..\repos.txt" (
        echo All repositories in this path may already be in repos.txt
    ) else (
        echo No .git folders found in the specified path.
        echo Make sure the path contains Git repositories.
    )
    echo %date% %time% - No new repositories found in scan path >> "%LOG_PATH%"
    pause
    exit /b 0
)

:: Display found repositories and ask for confirmation
echo.
echo Found !repo_count! new Git repositories:
echo ----------------------------------------
if exist "!temp_repos!" (
    type "!temp_repos!"
) else (
    echo No repositories to display (temp file not found)
)
echo ----------------------------------------
echo.

set /p "confirm=Do you want to add all !repo_count! repositories to repos.txt? (y/n): "
echo %date% %time% - User input: Add !repo_count! repositories: !confirm! >> "%LOG_PATH%"

if /i "!confirm!"=="y" (
    echo.
    echo Adding repositories to repos.txt...
    
    :: Create repos.txt if it doesn't exist
    if not exist "%~dp0..\repos.txt" (
        echo Creating new repos.txt file...
        type nul > "%~dp0..\repos.txt"
        echo %date% %time% - Created new repos.txt file >> "%LOG_PATH%"
    )
    
    :: Add found repositories to repos.txt
    if exist "!temp_repos!" (
        for /f "usebackq delims=" %%a in ("!temp_repos!") do (
            echo %%a >> "%~dp0..\repos.txt"
            echo Added: %%a
            set /a added_count+=1
        )
    )
    
    echo.
    echo Successfully added !added_count! repositories to repos.txt
    echo %date% %time% - Added !added_count! repositories from scan to repos.txt >> "%LOG_PATH%"
) else (
    echo Skipping addition of repositories to repos.txt
    echo %date% %time% - User declined to add scanned repositories >> "%LOG_PATH%"
)

:: Clean up temporary file
if exist "!temp_repos!" del "!temp_repos!"

echo.
echo Repository scan completed.
echo Press any key to return to the main script...
pause >nul
