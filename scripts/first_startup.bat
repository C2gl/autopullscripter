:: script that check for existing configuration files or repos.txt file

if EXIST "%~dp0..\repos.txt" (
    echo repos.txt found.
) ELSE (
    echo repos.txt NOT found.
    timeout /t 5
    echo would you like for the script to create a new repos.txt file?
    set /p "create=Do you want to create a new repos.txt file? (y/n): "
    if /i "%create%"=="y" (
        echo Creating repos.txt file...
        echo # Add your repository URLs here, one per line > "%~dp0..\repos.txt"
        echo repos.txt file created in parent directory.
    ) else (
        echo Skipping creation of repos.txt file.
    )
)

pause