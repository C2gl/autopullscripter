@echo off
setlocal enabledelayedexpansion

set "waittime=10"

set "path1=C:\Users\lieve\Documents\GitHub\blink"
set "path2=C:\Users\lieve\Documents\GitHub\core"
set "path3=C:\Users\lieve\Documents\GitHub\csm"

set "count=0"
set "pathcount=3"

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
