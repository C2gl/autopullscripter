@echo off
setlocal enabledelayedexpansion

:: Enable ANSI escape sequences for color support
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: Color codes
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "LIGHT_BLUE=%ESC%[94m"
set "MAGENTA=%ESC%[95m"
set "CYAN=%ESC%[96m"
set "GRAY=%ESC%[90m"
set "RESET=%ESC%[0m"

:: Default variables 
set "waittime=1"
set "repo_file=repos_enhanced.txt"
set "count=0"
set "toFetch=n"
set "docustomcommand=n"
set "customcommand="
set "total_repos=0"
set "SUCCESS_COUNT=0"
set "ERROR_COUNT=0"
set "UPDATED_COUNT=0"
set "verbose=n"
set "use_categories=n"
set "selected_categories="
set "category_mode=y"

:: Check if a custom repos file was provided as parameter
if not "%~1"=="" (
    set "repo_file=%~dp0..\%~1"
    echo Using custom repos file: %~1
) else (
    set "repo_file=%~dp0..\repos_enhanced.txt"
    echo Using enhanced repos file: repos_enhanced.txt
)

:: Store the original script directory for logging
set "SCRIPT_DIR=%~dp0.."
set "LOG_PATH=%SCRIPT_DIR%\log\%AUTOPULL_LOGFILE%"

:: Check if we have a categorized repos file
if exist "%repo_file%" (
    echo %CYAN%Category mode: repos_enhanced.txt found!%RESET%
    set "category_mode=y"
    
    :: Show available categories
    call :show_available_categories
    
    :: Let user select categories
    call :select_categories
) else (
    echo %YELLOW%repos_enhanced.txt not found!%RESET%
    echo.
    echo This file contains your repositories organized by categories.
    echo Would you like to create it now from your existing repos.txt?
    echo.
    set /p "create_enhanced=Create repos_enhanced.txt? (y/n): "
    
    if /i "!create_enhanced!"=="y" (
        if exist "%~dp0..\repos.txt" (
            echo Creating repos_enhanced.txt from repos.txt...
            
            :: Simple copy with categories for now
            echo # Repository Categories Configuration > "%~dp0..\repos_enhanced.txt"
            echo # Auto-generated from repos.txt >> "%~dp0..\repos_enhanced.txt"
            echo # Format: [CATEGORY_NAME] followed by repository paths >> "%~dp0..\repos_enhanced.txt"
            echo. >> "%~dp0..\repos_enhanced.txt"
            echo [ALL_REPOSITORIES] >> "%~dp0..\repos_enhanced.txt"
            type "%~dp0..\repos.txt" >> "%~dp0..\repos_enhanced.txt"
            
            echo repos_enhanced.txt created successfully!
            echo You can edit this file later to organize repositories into proper categories.
            echo.
            set "repo_file=%~dp0..\repos_enhanced.txt"
            set "category_mode=y"
            set "selected_categories=ALL_REPOSITORIES"
        ) else (
            echo %RED%ERROR: repos.txt not found. Cannot create repos_enhanced.txt.%RESET%
            echo Please ensure repos.txt exists first.
            pause
            exit /b 1
        )
    ) else (
        echo %RED%Cannot proceed without repos_enhanced.txt.%RESET%
        echo Please create this file or choose normal mode instead.
        pause
        exit /b 1
    )
)

:: Count total repositories based on file type
if /i "!category_mode!"=="y" (
    call :count_categorized_repos
) else (
    call :count_simple_repos
)

echo Found !total_repos! repositories to process.

:: Ask if user wants to use default settings
echo ==================================
echo Auto Git Pull Script
echo ==================================
if /i "!category_mode!"=="y" (
    echo %CYAN%Category Mode: ENABLED%RESET%
    if not "!selected_categories!"=="" (
        echo Selected categories: %MAGENTA%!selected_categories!%RESET%
    )
    echo.
)
echo Default settings:
echo - Wait time: 1 seconds between pulls
echo - Fetch before pull: No
echo - Custom command: No
echo - verbose mode: No
echo ==================================
echo.
set /p "useDefaults=Use default settings? (y/n, default is y): "

:: If empty input, default to yes
if "!useDefaults!"=="" set "useDefaults=y"

if /i "!useDefaults!"=="y" (
    echo Using default settings...
    echo %date% %time% - Using default settings: Wait time: !waittime!, Fetch: !toFetch!, Custom command: !docustomcommand!, Category mode: !category_mode! >> "%LOG_PATH%"
) else (
    echo Configuring custom settings...
    
    :: Custom user input
    set /p "waittime=Enter wait time between pulls (default is 3 seconds): "
    set /p "toFetch=Do you want to fetch latest changes before pulling? (y/n): "
    set /p "docustomcommand=Do you want to run a custom command after pulling? (y/n): "
    set /p "verbose=Enable verbose mode? (y/n, default is n): "

    :: Validate and set defaults for empty inputs
    if "!waittime!"=="" set "waittime=1"
    if "!toFetch!"=="" set "toFetch=n"
    if "!docustomcommand!"=="" set "docustomcommand=n"
    if "!verbose!"=="" set "verbose=n"
    
    :: logging user input
    echo %date% %time% - Custom settings: Wait time: !waittime!, Fetch: !toFetch!, Custom command: !docustomcommand!, verbose mode : !verbose!, Category mode: !category_mode! >> "%LOG_PATH%"

    if /i "!docustomcommand!"=="y" (
        set /p "customcommand=Enter the custom command to run: "
    )
)

echo.
echo Starting git pull process with settings:
echo - Wait time: !waittime! seconds
echo - Fetch before pull: !toFetch!
echo - Custom command: !docustomcommand!
if /i "!docustomcommand!"=="y" echo - Command: !customcommand!
echo - Total repositories: !total_repos!
if /i "!category_mode!"=="y" echo - Category mode: %CYAN%ENABLED%RESET%
echo.

:: Ensure counters are properly initialized before the loop
set "SUCCESS_COUNT=0"
set "ERROR_COUNT=0"
set "UPDATED_COUNT=0"

:: Process repositories based on mode
if /i "!category_mode!"=="y" (
    call :process_categorized_repos
) else (
    call :process_simple_repos
)

echo.
echo ==================================
echo ALL REPOSITORIES PROCESSED!
echo ==================================
call :show_progress !total_repos! !total_repos!
echo.
echo ==================================
echo SUMMARY
echo ==================================
echo Total repositories processed: !total_repos!
echo Successful operations: !SUCCESS_COUNT!
echo Repositories updated: !UPDATED_COUNT!
echo Failed operations: !ERROR_COUNT!
echo ==================================
echo %date% %time% - Git pull process completed. Total: !total_repos!, Success: !SUCCESS_COUNT!, Updated: !UPDATED_COUNT!, Errors: !ERROR_COUNT! >> "%LOG_PATH%"
pause

exit /b

:: Function to show available categories
:show_available_categories
echo.
echo %CYAN%Available Categories:%RESET%
echo ==================================
for /f "usebackq delims=" %%L in ("%repo_file%") do (
    set "line=%%L"
    if not "!line!"=="" (
        if "!line:~0,1!"=="[" (
            set "category=!line:~1,-1!"
            echo - %MAGENTA%!category!%RESET%
        )
    )
)
echo ==================================
goto :eof

:: Function to select categories
:select_categories
echo.
echo Category Selection Options:
echo 1. Process ALL categories
echo 2. Select specific categories
echo 3. Skip category selection (use all repos)
echo.
set /p "selection=Choose option (1-3, default is 1): "

if "!selection!"=="" set "selection=1"

if "!selection!"=="1" (
    set "selected_categories=ALL"
    echo Selected: ALL categories
) else if "!selection!"=="2" (
    echo.
    echo Enter category names separated by spaces.
    echo Example: JELLYFIN_ECOSYSTEM HOME_ASSISTANT_CORE
    echo Available categories:
    for /f "usebackq delims=" %%L in ("%repo_file%") do (
        set "line=%%L"
        if not "!line!"=="" (
            if "!line:~0,1!"=="[" (
                set "category=!line:~1,-1!"
                echo   !category!
            )
        )
    )
    echo.
    set /p "selected_categories=Enter categories: "
    
    if "!selected_categories!"=="" (
        echo No categories selected, using ALL.
        set "selected_categories=ALL"
    )
) else (
    set "category_mode=n"
    set "repo_file=%~dp0..\repos.txt"
    echo Switched back to simple mode.
)
goto :eof

:: Function to count repositories in categorized file
:count_categorized_repos
set "total_repos=0"
set "in_selected_category=false"

for /f "usebackq delims=" %%L in ("%repo_file%") do (
    set "line=%%L"
    if not "!line!"=="" (
        if "!line:~0,1!"=="[" (
            :: Category header
            set "category=!line:~1,-1!"
            if "!selected_categories!"=="ALL" (
                set "in_selected_category=true"
            ) else (
                set "in_selected_category=false"
                echo !selected_categories! | findstr /i "!category!" >nul
                if !errorlevel! equ 0 set "in_selected_category=true"
            )
        ) else if "!line:~0,1!" neq "#" (
            :: Repository path (not a comment)
            if "!in_selected_category!"=="true" (
                set /a total_repos+=1
            )
        )
    )
)
goto :eof

:: Function to count repositories in simple file
:count_simple_repos
echo Counting repositories...
for /f "usebackq delims=" %%R in ("%repo_file%") do (
    set "line=%%R"
    if not "!line!"=="" (
        set /a total_repos+=1
    )
)
goto :eof

:: Function to process categorized repositories
:process_categorized_repos
set "current_category="
set "in_selected_category=false"
set "category_count=0"
set "category_success=0"
set "category_errors=0"

for /f "usebackq delims=" %%L in ("%repo_file%") do (
    set "line=%%L"
    if not "!line!"=="" (
        if "!line:~0,1!"=="[" (
            :: New category header
            if not "!current_category!"=="" (
                :: Show previous category summary
                call :show_category_summary
            )
            
            set "current_category=!line:~1,-1!"
            set "category_count=0"
            set "category_success=0"
            set "category_errors=0"
            
            if "!selected_categories!"=="ALL" (
                set "in_selected_category=true"
            ) else (
                set "in_selected_category=false"
                echo !selected_categories! | findstr /i "!current_category!" >nul
                if !errorlevel! equ 0 set "in_selected_category=true"
            )
            
            if "!in_selected_category!"=="true" (
                echo.
                echo %CYAN%==== CATEGORY: !current_category! ====%RESET%
            )
        ) else if "!line:~0,1!" neq "#" (
            :: Repository path (not a comment)
            if "!in_selected_category!"=="true" (
                set "currentPath=!line!"
                call :process_single_repo
            )
        )
    )
)

:: Show final category summary
if not "!current_category!"=="" (
    call :show_category_summary
)
goto :eof

:: Function to process simple repositories
:process_simple_repos
for /f "usebackq delims=" %%R in ("%repo_file%") do (
    set "currentPath=%%R"
    
    :: Skip empty lines
    if not "!currentPath!"=="" (
        call :process_single_repo
    ) else (
        echo Skipping empty line in repos.txt
    )
)
goto :eof

:: Function to process a single repository
:process_single_repo
set /a count+=1
set /a category_count+=1

if /i "!verbose!"=="y" (
    echo.
    echo ==================================
    echo PROCESSING REPOSITORY !count!/!total_repos!
    echo ==================================
    echo Current path: %LIGHT_BLUE%!currentPath!%RESET%
    
    :: Show progress bar
    call :show_progress !count! !total_repos!
) else (
    :: Condensed output for non-verbose mode
    for %%F in ("!currentPath!") do set "repo_name=%%~nxF"
    echo [!count!/!total_repos!] %LIGHT_BLUE%!repo_name!%RESET%
    call :show_progress !count! !total_repos!
)

:: Check if path exists before trying to cd
if exist "!currentPath!" (
    echo %date% %time% - Processing repository: !currentPath! >> "%LOG_PATH%"
    cd /d "!currentPath!"

    :: Optional fetch before pull
    if /i "!toFetch!"=="y" (
        if /i "!verbose!"=="y" (
            echo Fetching latest changes from the remote repository before pulling...
        )
        call "%~dp0fetch.bat" "!verbose!"
        if /i "!verbose!"=="y" (
            echo Fetch completed for !currentPath!
        )
    )

    if /i "!verbose!"=="y" (
        echo Pulling changes...
    )
    
    :: Capture git pull output and exit code
    git pull > temp_output.txt 2>&1
    set "git_exit_code=!errorlevel!"
    
    :: Check for errors and status using the temp file directly (safer than building a variable)
    set "is_error=false"
    set "is_up_to_date=false"
    set "has_changes=false"
    
    if !git_exit_code! neq 0 set "is_error=true"
    
    :: Only check for actual error messages, not words that might appear in branch names
    findstr /i /c:"error:" /c:"fatal:" /c:"denied" /c:"permission denied" /c:"authentication failed" temp_output.txt >nul 2>&1
    if !errorlevel! equ 0 set "is_error=true"
    
    :: Check if changes were pulled - prioritize this check before "already up to date"
    :: This fixes false negatives when git shows both remote updates AND "already up to date"
    findstr /i "fast-forward" temp_output.txt >nul 2>&1
    if !errorlevel! equ 0 set "has_changes=true"
    
    if "!has_changes!"=="false" (
        findstr /i "updating" temp_output.txt >nul 2>&1
        if !errorlevel! equ 0 set "has_changes=true"
    )
    
    if "!has_changes!"=="false" (
        findstr /i "files changed" temp_output.txt >nul 2>&1
        if !errorlevel! equ 0 set "has_changes=true"
    )
    
    if "!has_changes!"=="false" (
        findstr /i "insertions" temp_output.txt >nul 2>&1
        if !errorlevel! equ 0 set "has_changes=true"
    )
    
    if "!has_changes!"=="false" (
        findstr /i "deletions" temp_output.txt >nul 2>&1
        if !errorlevel! equ 0 set "has_changes=true"
    )
    
    :: Additional change detection patterns for better accuracy
    if "!has_changes!"=="false" (
        findstr /i "merge" temp_output.txt >nul 2>&1
        if !errorlevel! equ 0 set "has_changes=true"
    )
    
    if "!has_changes!"=="false" (
        findstr /i "create mode" temp_output.txt >nul 2>&1
        if !errorlevel! equ 0 set "has_changes=true"
    )
    
    if "!has_changes!"=="false" (
        findstr /i "delete mode" temp_output.txt >nul 2>&1
        if !errorlevel! equ 0 set "has_changes=true"
    )
    
    :: Check if already up to date (only after checking for changes)
    findstr /i "already up" temp_output.txt | findstr /i "to date" >nul 2>&1
    if !errorlevel! equ 0 set "is_up_to_date=true"
    
    :: Display the output to user (only in verbose mode)
    if /i "!verbose!"=="y" (
        echo %GRAY%
        type temp_output.txt
        echo %RESET%
    )
    
    :: Also append complete git output to log file
    type temp_output.txt >> "%LOG_PATH%"
    
    if "!is_error!"=="true" (
        :: Error detected
        set /a ERROR_COUNT+=1
        set /a category_errors+=1
        if /i "!verbose!"=="y" (
            echo %RED%ERROR%RESET% ^| Git pull failed for !currentPath!
        ) else (
            echo %RED%ERROR%RESET%
        )
        echo %date% %time% - ERROR ^| Git pull failed for !currentPath! - Exit code: !git_exit_code! >> "%LOG_PATH%"
    ) else if "!has_changes!"=="true" (
        :: Changes were pulled - prioritize this over "already up to date"
        set /a SUCCESS_COUNT+=1
        set /a UPDATED_COUNT+=1
        set /a category_success+=1
        if /i "!verbose!"=="y" (
            echo %GREEN%OK - PULLED NEW CHANGES%RESET% ^| Changes pulled for !currentPath!
        ) else (
            echo %GREEN%OK - PULLED NEW CHANGES%RESET%
        )
        echo %date% %time% - OK - PULLED NEW CHANGES ^| Changes pulled for !currentPath! >> "%LOG_PATH%"
    ) else if "!is_up_to_date!"=="true" (
        :: Already up to date (only if no changes detected)
        set /a SUCCESS_COUNT+=1
        set /a category_success+=1
        if /i "!verbose!"=="y" (
            echo %YELLOW%OK - ALREADY UP TO DATE%RESET% ^| No changes for !currentPath!
        ) else (
            echo %YELLOW%OK - ALREADY UP TO DATE%RESET%
        )
        echo %date% %time% - OK - ALREADY UP TO DATE ^| No changes for !currentPath! >> "%LOG_PATH%"
    ) else (
        :: Generic success (fallback)
        set /a SUCCESS_COUNT+=1
        set /a category_success+=1
        if /i "!verbose!"=="y" (
            echo %GREEN%OK%RESET% ^| Pull completed for !currentPath!
        ) else (
            echo %GREEN%OK%RESET%
        )
        echo %date% %time% - OK ^| Pull completed for !currentPath! >> "%LOG_PATH%"
    )
    
    :: Clean up temporary file
    del temp_output.txt
    
) else (
    set /a ERROR_COUNT+=1
    set /a category_errors+=1
    if /i "!verbose!"=="y" (
        echo %RED%ERROR%RESET% ^| Path does not exist: !currentPath!
    ) else (
        echo %RED%PATH NOT FOUND%RESET%
    )
    echo %date% %time% - ERROR ^| Path does not exist: !currentPath! >> "%LOG_PATH%"
)

:: Optional custom command execution
if /i "!docustomcommand!"=="y" (
    if /i "!verbose!"=="y" (
        echo.
        echo %YELLOW%Running custom command:%RESET% !customcommand!
    )
    :: Pass the custom command, current repository path, log file, and verbose mode to the custom command script
    call "%~dp0customcommand.bat" "!customcommand!" "!currentPath!" "%AUTOPULL_LOGFILE%" "!verbose!"
)

if /i "!verbose!"=="y" (
    echo ----------------------------------
    echo Completed repository !count!/!total_repos!: !currentPath!
    echo ----------------------------------

    if !count! lss !total_repos! (
        echo Waiting for !waittime! seconds before next pull...
        timeout /t !waittime! >nul
    )
) else (
    if !count! lss !total_repos! (
        timeout /t !waittime! >nul
    )
)
goto :eof

:: Function to show category summary
:show_category_summary
if "!in_selected_category!"=="true" (
    echo.
    echo %CYAN%--- Category "!current_category!" Complete ---%RESET%
    echo Processed: !category_count! repositories
    echo Successful: !category_success!
    echo Errors: !category_errors!
    echo %CYAN%--------------------------------%RESET%
)
goto :eof

:: Function to display progress bar
:show_progress
setlocal enabledelayedexpansion
set "current=%1"
set "total=%2"
set "bar_length=20"
set "filled=0"
set "progress_bar="

:: Calculate filled portion
set /a "filled=(!current! * !bar_length!) / !total!"

:: Build progress bar
for /l %%i in (1,1,!bar_length!) do (
    if %%i leq !filled! (
        set "progress_bar=!progress_bar!#"
    ) else (
        set "progress_bar=!progress_bar!-"
    )
)

:: calculate percentage
set /a "percentage=(!current! * 100) / !total!"

:: Display progress bar
echo Progress: [!progress_bar!] !percentage!%% complete
endlocal
goto :eof
