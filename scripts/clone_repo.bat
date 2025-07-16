setlocal enabledelayedexpansion

@ echo off

:: script to add a new repository URL to the variables and cloning it
echo what is the URL of the repository you want to add?
set /p "repo_url=Enter repository URL: "
set /p "path=Enter the local path where you want to clone the repository: "
set /p "toadd=Do you want to add the new repository path to repos.txt? (y/n): "

:: cloning the new repository
cd /d "!path!"
git clone "!repo_url!"

:: check if the user wants to add the new repository path to repos.txt
if /i "!toadd!"=="y" (
    echo Adding new repository path to repos.txt...

) else (
    echo Skipping addition of new repository path to repos.txt.
    exit /b
)
:: extract repo name from URL (remove .git if present)
for %%A in ("%repo_url%") do (
    set "repo_name=%%~nA"
)
if /i "!repo_url:~-4!"==".git" (
    set "repo_name=!repo_name:~0,-4!"
)

:: add the full path to repos.txt
echo !path!\!repo_name! > "%~dp0..\repos.txt"