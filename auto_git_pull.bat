@echo off
setlocal enabledelayedexpansion

:: wait time between pulls in the loop
set "waittime=10"

:: defined paths to git repositories
set "path1=C:\Users\lieve\Documents\GitHub\blink"
set "path2=C:\Users\lieve\Documents\GitHub\core"
set "path3=C:\Users\lieve\Documents\GitHub\csm"

:: counter to tell how many pulls were done
:: the pathcounter variable is used to cycle through only the amount of paths defined
set "count=0"
set "pathcount=3"


:: working for loop
FOR /L %%A in (1,1,%pathcount%) DO (
    set /a index=%%A %% 3
    if !index! == 1 set "currentPath=!path1!"
    if !index! == 2 set "currentPath=!path2!"
    if !index! == 0 set "currentPath=!path3!"

    echo Iteration %%A
    echo Current path: !currentPath!
    cd /d "!currentPath!"
    git pull
    set /a count+=1
    timeout /t %waittime% >nul
)

echo Total pulls: %count%
