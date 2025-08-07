:: scan_repos.bat
:: Script to scan a given folder path for Git repositories and populate repos_enhanced.txt
@echo off
setlocal enabledelayedexpansion

:: Initialize logging
echo %date% %time% - Repository scanner started >> "%LOG_PATH%"

:: Enable error handling
set "error_occurred=false"

:: Store the original script directory for logging
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"

echo.
echo ===== Auto Repository Scanner =====
echo This will scan a folder path for Git repositories and add them to repos_enhanced.txt
echo.
echo %date% %time% - Repository scanner UI displayed >> "%LOG_PATH%"

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
    echo %date% %time% - Path validation failed - directory does not exist >> "%LOG_PATH%"
    echo.
    echo Please check:
    echo - The path is correct
    echo - You have permission to access the folder
    echo - The folder exists
    echo %date% %time% - Displaying path validation help to user >> "%LOG_PATH%"
    pause
    echo %date% %time% - Repository scanner exited due to invalid path >> "%LOG_PATH%"
    exit /b 1
)

echo.
echo Path validated successfully: !scan_path!
echo Scanning folder: !scan_path!
echo Looking for Git repositories...
echo %date% %time% - Path validation successful: !scan_path! >> "%LOG_PATH%"
echo %date% %time% - Starting repository scan in: !scan_path! >> "%LOG_PATH%"

:: Counter for found repositories
set "repo_count=0"
set "added_count=0"

:: Create temporary file to store found repos
set "temp_repos=%TEMP%\found_repos_%RANDOM%.txt"
if exist "!temp_repos!" del "!temp_repos!"
echo %date% %time% - Created temporary file for repository collection: !temp_repos! >> "%LOG_PATH%"

echo Searching for Git repositories...
echo This may take a moment...
echo %date% %time% - Beginning scan for .git directories >> "%LOG_PATH%"

:: First, scan the root directory
if exist "!scan_path!\.git" (
    echo Checking repository: !scan_path!
    echo %date% %time% - Found .git folder in root directory: !scan_path! >> "%LOG_PATH%"
    
    :: Check if this repo is already in repos_enhanced.txt
    set "already_exists=false"
    if exist "%~dp0..\repos_enhanced.txt" (
        findstr /i /c:"!scan_path!" "%~dp0..\repos_enhanced.txt" >nul 2>&1
        if !errorlevel! equ 0 (
            set "already_exists=true"
            echo Repository already exists in repos_enhanced.txt: !scan_path!
            echo %date% %time% - Repository already exists in repos_enhanced.txt: !scan_path! >> "%LOG_PATH%"
        )
    )
    
    if "!already_exists!"=="false" (
        echo Found new repository: !scan_path!
        echo !scan_path! >> "!temp_repos!"
        set /a repo_count+=1
        echo %date% %time% - Added new repository to scan results: !scan_path! >> "%LOG_PATH%"
    )
)

:: Then scan subdirectories
echo %date% %time% - Starting subdirectory scan >> "%LOG_PATH%"
pushd "!scan_path!" 2>nul
if !errorlevel! equ 0 (
    echo %date% %time% - Successfully changed to scan directory >> "%LOG_PATH%"
    for /d %%d in (*) do (
        if exist "%%d\.git" (
            set "repo_path=!scan_path!\%%d"
            echo Checking repository: !repo_path!
            echo %date% %time% - Found .git folder in subdirectory: !repo_path! >> "%LOG_PATH%"
            
            :: Check if this repo is already in repos_enhanced.txt
            set "already_exists=false"
            if exist "%~dp0..\repos_enhanced.txt" (
                findstr /i /c:"!repo_path!" "%~dp0..\repos_enhanced.txt" >nul 2>&1
                if !errorlevel! equ 0 (
                    set "already_exists=true"
                    echo Repository already exists in repos_enhanced.txt: !repo_path!
                    echo %date% %time% - Repository already exists in repos_enhanced.txt: !repo_path! >> "%LOG_PATH%"
                )
            )
            
            if "!already_exists!"=="false" (
                echo Found new repository: !repo_path!
                echo !repo_path! >> "!temp_repos!"
                set /a repo_count+=1
                echo %date% %time% - Added new repository to scan results: !repo_path! >> "%LOG_PATH%"
            )
        )
        
        :: Scan one level deeper
        if exist "%%d" (
            pushd "%%d" 2>nul
            if !errorlevel! equ 0 (
                echo %date% %time% - Scanning deeper in directory: %%d >> "%LOG_PATH%"
                for /d %%e in (*) do (
                    if exist "%%e\.git" (
                        set "repo_path=!scan_path!\%%d\%%e"
                        echo Checking repository: !repo_path!
                        echo %date% %time% - Found .git folder in nested directory: !repo_path! >> "%LOG_PATH%"
                        
                        :: Check if this repo is already in repos_enhanced.txt
                        set "already_exists=false"
                        if exist "%~dp0..\repos_enhanced.txt" (
                            findstr /i /c:"!repo_path!" "%~dp0..\repos_enhanced.txt" >nul 2>&1
                            if !errorlevel! equ 0 (
                                set "already_exists=true"
                                echo Repository already exists in repos_enhanced.txt: !repo_path!
                                echo %date% %time% - Repository already exists in repos_enhanced.txt: !repo_path! >> "%LOG_PATH%"
                            )
                        )
                        
                        if "!already_exists!"=="false" (
                            echo Found new repository: !repo_path!
                            echo !repo_path! >> "!temp_repos!"
                            set /a repo_count+=1
                            echo %date% %time% - Added new repository to scan results: !repo_path! >> "%LOG_PATH%"
                        )
                    )
                )
                popd
            )
        )
    )
    popd
    echo %date% %time% - Completed subdirectory scan >> "%LOG_PATH%"
) else (
    echo ERROR: Cannot access directory !scan_path!
    echo Please check the path and try again.
    echo %date% %time% - ERROR: Cannot access directory for scanning: !scan_path! >> "%LOG_PATH%"
    pause
    echo %date% %time% - Repository scanner exited due to directory access error >> "%LOG_PATH%"
    exit /b 1
)

:: Check if any new repositories were found
echo %date% %time% - Scan completed. Found !repo_count! new repositories >> "%LOG_PATH%"
if !repo_count! equ 0 (
    echo.
    echo No new Git repositories found in the specified path.
    if exist "%~dp0..\repos_enhanced.txt" (
        echo All repositories in this path may already be in repos_enhanced.txt
        echo %date% %time% - No new repositories found - all may already exist in repos_enhanced.txt >> "%LOG_PATH%"
    ) else (
        echo No .git folders found in the specified path.
        echo Make sure the path contains Git repositories.
        echo %date% %time% - No .git folders found in scan path >> "%LOG_PATH%"
    )
    echo %date% %time% - No new repositories found in scan path >> "%LOG_PATH%"
    pause
    echo %date% %time% - Repository scanner completed with no new repositories >> "%LOG_PATH%"
    exit /b 0
)

:: Display found repositories and ask for confirmation
echo.
echo Found !repo_count! new Git repositories:
echo ----------------------------------------
if exist "!temp_repos!" (
    type "!temp_repos!"
    echo %date% %time% - Displayed !repo_count! repositories to user for confirmation >> "%LOG_PATH%"
) else (
    echo No repositories to display (temp file not found)
    echo %date% %time% - ERROR: Temporary file not found when displaying results >> "%LOG_PATH%"
)
echo ----------------------------------------
echo.

set /p "confirm=Do you want to add all !repo_count! repositories to repos_enhanced.txt? (y/n): "
echo %date% %time% - User input: Add !repo_count! repositories: !confirm! >> "%LOG_PATH%"

if /i "!confirm!"=="y" (
    echo.
    echo Adding repositories to repos_enhanced.txt...
    echo %date% %time% - User confirmed addition of repositories to repos_enhanced.txt >> "%LOG_PATH%"
    
    :: Create repos_enhanced.txt if it doesn't exist
    if not exist "%~dp0..\repos_enhanced.txt" (
        echo Creating new repos_enhanced.txt file...
        echo # Repository Categories Configuration > "%~dp0..\repos_enhanced.txt"
        echo # Format: [CATEGORY_NAME] followed by repository paths >> "%~dp0..\repos_enhanced.txt"
        echo # Empty lines and lines starting with # are ignored >> "%~dp0..\repos_enhanced.txt"
        echo. >> "%~dp0..\repos_enhanced.txt"
        echo [SCANNED_REPOSITORIES] >> "%~dp0..\repos_enhanced.txt"
        echo %date% %time% - Created new repos_enhanced.txt file >> "%LOG_PATH%"
    ) else (
        :: Add a new category for scanned repos
        echo. >> "%~dp0..\repos_enhanced.txt"
        echo [SCANNED_REPOSITORIES_!date:~-4!_!time:~0,2!!time:~3,2!] >> "%~dp0..\repos_enhanced.txt"
    )
    
    :: Add found repositories to repos_enhanced.txt
    if exist "!temp_repos!" (
        for /f "usebackq delims=" %%a in ("!temp_repos!") do (
            echo %%a >> "%~dp0..\repos_enhanced.txt"
            echo Added: %%a
            echo %date% %time% - Added repository to repos_enhanced.txt: %%a >> "%LOG_PATH%"
            set /a added_count+=1
        )
    )
    
    echo.
    echo Successfully added !added_count! repositories to repos_enhanced.txt
    echo %date% %time% - Successfully added !added_count! repositories from scan to repos_enhanced.txt >> "%LOG_PATH%"
) else (
    echo Skipping addition of repositories to repos_enhanced.txt
    echo %date% %time% - User declined to add scanned repositories >> "%LOG_PATH%"
)

:: Clean up temporary file
if exist "!temp_repos!" del "!temp_repos!"
echo %date% %time% - Cleaned up temporary file: !temp_repos! >> "%LOG_PATH%"

echo.
echo Repository scan completed.
echo Press any key to return to the main script...
echo %date% %time% - Repository scanner completed successfully >> "%LOG_PATH%"
pause >nul
