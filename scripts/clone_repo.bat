setlocal enabledelayedexpansion

@ echo off

:: script to add a new repository URL to the variables and cloning it
echo what is the URL of the repository you want to add?
set /p "repo_url=Enter repository URL: "
set /p "path=Enter the local path where you want to clone the repository: "

:: cloning the new repository
cd /d "%path%"
git clone "%repo_url%"
