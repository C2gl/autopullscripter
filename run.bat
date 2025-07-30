@echo off
setlocal enabledelayedexpansion

echo  starting program
echo ----------------------------------

call scripts/log.bat
call scripts/checkforupdate.bat
call scripts/first_startup.bat

echo Starting git pull process...
echo %date% %time% - Starting git pull process. >> "log\%AUTOPULL_LOGFILE%"

:: Check which mode was selected
if exist "scripts\mode_selection.tmp" (
    set /p mode_choice=<"scripts\mode_selection.tmp"
    del "scripts\mode_selection.tmp" >nul 2>&1
    
    if "!mode_choice!"=="enhanced" (
        echo Running ENHANCED CATEGORY MODE...
        call scripts/simple_git_pull_enhanced.bat repos_enhanced.txt
    ) else (
        :: Check for custom file
        if exist "scripts\custom_file.tmp" (
            set /p custom_file=<"scripts\custom_file.tmp"
            del "scripts\custom_file.tmp" >nul 2>&1
            for /f "tokens=2 delims=:" %%a in ("!custom_file!") do set "filename=%%a"
            echo Running with custom file: !filename!
            call scripts/simple_git_pull.bat "!filename!"
        ) else (
            echo Running NORMAL MODE...
            call scripts/simple_git_pull.bat
        )
    )
) else (
    :: Fallback to normal mode
    echo Running NORMAL MODE (fallback)...
    call scripts/simple_git_pull.bat
)

echo Program finished.
echo ----------------------------------
echo %date% %time% - Program finished. >> "log\%AUTOPULL_LOGFILE%"
pause