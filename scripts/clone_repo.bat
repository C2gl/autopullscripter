setlocal enabledelayedexpansion

@ echo off

:: script to add a new repository URL to the repos.txt file
echo what is the URL of the repository you want to add?
set /p "repo_url=Enter repository URL: "