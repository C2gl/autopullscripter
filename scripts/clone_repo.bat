setlocal enabledelayedexpansion

@ echo off

:: script to add a new repository URL to the variables and cloning it
echo what is the URL of the repository you want to add?
set /p "repo_url=Enter repository URL: "
set /p "path=Enter the local path where you want to clone the repository: "

:: cloning the new repository
cd /d "%path%"
git clone "%repo_url%"


:: extract repo name from URL (remove .git if present)
for %%A in ("%repo_url%") do (
    set "repo_name=%%~nA"
)
if /i "!repo_url:~-4!"==".git" (
    set "repo_name=!repo_name:~0,-4!"
)

:: add the full path to repos.txt
echo %path%\!repo_name!>>"..\..\repos.txt"