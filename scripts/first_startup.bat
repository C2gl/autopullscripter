:: script that check for existing configuration files or repos.txt file

if EXIST "%~dp0repos.txt" (
    echo repos.txt found in script directory.
) ELSE (
    echo repos.txt NOT found in script directory.
)

pause