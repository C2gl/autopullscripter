@echo off
setlocal enabledelayedexpansion

:: wait time between pulls in the loop
set "waittime=3"

:: defined paths to git repositories
::CATEGORIES 
    :: - Jellyfin
set "path10=C:\Users\lieve\Documents\GitHub\Fladder"
set "path14=C:\Users\lieve\Documents\GitHub\jellyfin"
set "path15=C:\Users\lieve\Documents\GitHub\jellyfin-media-player"
set "path16=C:\Users\lieve\Documents\GitHub\jellyfin-plugin-streamyfin"
set "path17=C:\Users\lieve\Documents\GitHub\jellyfin-web"
set "path18=C:\Users\lieve\Documents\GitHub\jellyfin-webos"
set "path19=C:\Users\lieve\Documents\GitHub\jellyseerr"
set "path20=C:\Users\lieve\Documents\GitHub\jellystat"
set "path28=C:\Users\lieve\Documents\GitHub\streamyfin"
set "path29=C:\Users\lieve\Documents\GitHub\Swiftfin"

    :: - home assistant
set "path2=C:\Users\lieve\Documents\Github\HOME_ASSISTANT\core"
set "path36=C:\Users\lieve\Documents\Github\HOME_ASSISTANT\frontend" 
set "path37=C:\Users\lieve\Documents\Github\HOME_ASSISTANT\supervisor"
set "path38=C:\Users\lieve\Documents\Github\HOME_ASSISTANT\operating system"

    :: - personal repositories
set "path39=C:\Users\lieve\Documents\Github\personal_repos\home_server"

    :: - Other
set "path1=C:\Users\lieve\Documents\GitHub\blink"
set "path3=C:\Users\lieve\Documents\GitHub\csm"
set "path4=C:\Users\lieve\Documents\GitHub\dockge"
set "path5=C:\Users\lieve\Documents\GitHub\element-x-ios"
set "path6=C:\Users\lieve\Documents\GitHub\endurain"
set "path7=C:\Users\lieve\Documents\GitHub\ferrishare"
set "path8=C:\Users\lieve\Documents\GitHub\filebrowser"
set "path9=C:\Users\lieve\Documents\GitHub\firefly-iii"
set "path11=C:\Users\lieve\Documents\GitHub\grocy"
set "path12=C:\Users\lieve\Documents\GitHub\immich"
set "path13=C:\Users\lieve\Documents\GitHub\immich-go"
set "path21=C:\Users\lieve\Documents\GitHub\ladybird"
set "path22=C:\Users\lieve\Documents\GitHub\manage-my-damn-life-nextjs"
set "path23=C:\Users\lieve\Documents\GitHub\nginx-proxy-manager"
set "path24=C:\Users\lieve\Documents\GitHub\paperless-ai"
set "path25=C:\Users\lieve\Documents\GitHub\paperless-ngx"
set "path26=C:\Users\lieve\Documents\GitHub\ProxmoxVE"
set "path27=C:\Users\lieve\Documents\GitHub\spksrc"
set "path30=C:\Users\lieve\Documents\GitHub\synapse"
set "path31=C:\Users\lieve\Documents\GitHub\syncthing"
set "path32=C:\Users\lieve\Documents\GitHub\tailscale"
set "path33=C:\Users\lieve\Documents\GitHub\tududi"
set "path34=C:\Users\lieve\Documents\GitHub\tuwunel"
set "path35=C:\Users\lieve\Documents\GitHub\zigbee2mqtt"

:: counter to tell how many pulls were done
:: the pathcounter variable is used to cycle through only the amount of paths defined
set "count=0"
set "pathcount=38"


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
    if !count! == 15 set "currentPath=!path16!"
    if !count! == 16 set "currentPath=!path17!"
    if !count! == 17 set "currentPath=!path18!"
    if !count! == 18 set "currentPath=!path19!"    
    if !count! == 19 set "currentPath=!path20!"
    if !count! == 20 set "currentPath=!path21!"
    if !count! == 21 set "currentPath=!path22!"
    if !count! == 22 set "currentPath=!path23!"
    if !count! == 23 set "currentPath=!path24!"    
    if !count! == 24 set "currentPath=!path25!"
    if !count! == 25 set "currentPath=!path26!"
    if !count! == 26 set "currentPath=!path27!"
    if !count! == 27 set "currentPath=!path28!"
    if !count! == 28 set "currentPath=!path29!"    
    if !count! == 29 set "currentPath=!path30!"
    if !count! == 30 set "currentPath=!path31!"
    if !count! == 31 set "currentPath=!path32!"
    if !count! == 32 set "currentPath=!path33!"
    if !count! == 33 set "currentPath=!path34!"    
    if !count! == 34 set "currentPath=!path35!"
    if !count! == 35 set "currentPath=!path36!"
    if !count! == 36 set "currentPath=!path37!"
    if !count! == 37 set "currentPath=!path38!"
    if !count! == 38 set "currentPath=!path39!"

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
