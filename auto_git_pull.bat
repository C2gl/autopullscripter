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
set "path6=C:\Users\lieve\Documents\GitHub\endurain"
set "path7=C:\Users\lieve\Documents\GitHub\ferrishare"
set "path8=C:\Users\lieve\Documents\GitHub\filebrowser"
set "path9=C:\Users\lieve\Documents\GitHub\firefly-iii"
set "path10=C:\Users\lieve\Documents\GitHub\Fladder"
set "path11=C:\Users\lieve\Documents\GitHub\grocy"
set "path12=C:\Users\lieve\Documents\GitHub\immich"
set "path13=C:\Users\lieve\Documents\GitHub\immich-go"
set "path14=C:\Users\lieve\Documents\GitHub\jellyfin"
set "path15=C:\Users\lieve\Documents\GitHub\jellyfin-media-player"

:: counter to tell how many pulls were done
:: the pathcounter variable is used to cycle through only the amount of paths defined
set "count=0"
set "pathcount=15"


:: working for loop
FOR /L %%A in (1,1,%pathcount%) DO (
    set /a index=%%A %% %pathcount%
    if !count! == 0 set "currentPath=!path1!"
    if !count! == 1 set "currentPath=!path2!"
    if !count! == 2 set "currentPath=!path3!"
    if !count! == 3 set "currentPath=!path4!"
    if !count! == 4 set "currentPath=!path5!"
    if !count! == 5 set "currentPath=!path6!"
    if !count! == 6 set "currentPath=!path7!"
    if !count! == 7 set "currentPath=!path8!"
    if !count! == 8 set "currentPath=!path9!"
    if !count! == 9 set "currentPath=!path10!"
    if !count! == 10 set "currentPath=!path11!"
    if !count! == 11 set "currentPath=!path12!"
    if !count! == 12 set "currentPath=!path13!"
    if !count! == 13 set "currentPath=!path14!"    
    if !count! == 14 set "currentPath=!path15!"
    

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
