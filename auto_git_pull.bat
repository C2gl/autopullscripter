@echo off
setlocal enabledelayedexpansion

:: wait time between pulls in the loop
set "waittime=10"

:: defined paths to git repositories
set "path1=C:\Users\lieve\Documents\GitHub\blink"
set "path2=C:\Users\lieve\Documents\GitHub\core"
set "path3=C:\Users\lieve\Documents\GitHub\csm"
set "path4=C:\Users\lieve\Documents\GitHub\dockge"
set "path5=C:\Users\lieve\Documents\GitHub\element-x-ios"

:: counter to tell how many pulls were done
:: the pathcounter variable is used to cycle through only the amount of paths defined
set "count=0"
set "pathcount=5"


:: working for loop
FOR /L %%A in (1,1,%pathcount%) DO (
    set /a index=%%A %% %pathcount%
    if !count! == 0 set "currentPath=!path1!"
    if !count! == 1 set "currentPath=!path2!"
    if !count! == 2 set "currentPath=!path3!"
    if !count! == 3 set "currentPath=!path4!"
    if !count! == 4 set "currentPath=!path5!"

    echo Iteration %%A
    echo Current path: !currentPath!
    cd /d "!currentPath!"
    git pull
    
    echo ----------------------------------
    echo Pull completed for !currentPath!
    echo ----------------------------------

    set /a count+=1
    timeout /t %waittime% >nul
)

echo Total pulls: %count%
pause
