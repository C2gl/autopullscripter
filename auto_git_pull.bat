@echo off
setlocal enabledelayedexpansion

:: wait time between pulls in the loop
set "waittime=3"

:: defined paths to git repositories
set "repo[0]=C:\Users\lieve\Documents\GitHub\blink"
set "repo[1]=C:\Users\lieve\Documents\GitHub\core"
set "repo[3]=C:\Users\lieve\Documents\GitHub\csm"
set "repo[4]=C:\Users\lieve\Documents\GitHub\dockge"
set "repo[5]=C:\Users\lieve\Documents\GitHub\element-x-ios"
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
set "path16=C:\Users\lieve\Documents\GitHub\jellyfin-plugin-streamyfin"
set "path17=C:\Users\lieve\Documents\GitHub\jellyfin-web"
set "path18=C:\Users\lieve\Documents\GitHub\jellyfin-webos"
set "path19=C:\Users\lieve\Documents\GitHub\jellyseerr"
set "path20=C:\Users\lieve\Documents\GitHub\jellystat"
set "path21=C:\Users\lieve\Documents\GitHub\ladybird"
set "path22=C:\Users\lieve\Documents\GitHub\manage-my-damn-life-nextjs"
set "path23=C:\Users\lieve\Documents\GitHub\nginx-proxy-manager"
set "path24=C:\Users\lieve\Documents\GitHub\paperless-ai"
set "path25=C:\Users\lieve\Documents\GitHub\paperless-ngx"
set "path26=C:\Users\lieve\Documents\GitHub\ProxmoxVE"
set "path27=C:\Users\lieve\Documents\GitHub\spksrc"
set "path28=C:\Users\lieve\Documents\GitHub\streamyfin"
set "path29=C:\Users\lieve\Documents\GitHub\Swiftfin"
set "path30=C:\Users\lieve\Documents\GitHub\synapse"
set "path31=C:\Users\lieve\Documents\GitHub\syncthing"
set "path32=C:\Users\lieve\Documents\GitHub\tailscale"
set "path33=C:\Users\lieve\Documents\GitHub\tududi"
set "path34=C:\Users\lieve\Documents\GitHub\tuwunel"
set "path35=C:\Users\lieve\Documents\GitHub\zigbee2mqtt"

:: counter to tell how many pulls were done
:: the pathcounter variable is used to cycle through only the amount of paths defined
set "count=0"
set "pathcount=5"


:: working for loop (should be turned into a function loop)
FOR /L %%A in (1,1,%pathcount%) DO (
    set "currentPath=!repo[%%A]!"
       
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
