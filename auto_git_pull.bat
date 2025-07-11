@echo off
setlocal enabledelayedexpansion

:: wait time between pulls in the loop
set "waittime=3"

:: defined paths to git repositories (array like structure)
set "repo[0]=C:\Users\lieve\Documents\GitHub\blink"
set "repo[1]=C:\Users\lieve\Documents\GitHub\core"
set "repo[3]=C:\Users\lieve\Documents\GitHub\csm"
set "repo[4]=C:\Users\lieve\Documents\GitHub\dockge"
set "repo[5]=C:\Users\lieve\Documents\GitHub\element-x-ios"
set "repo[6]=C:\Users\lieve\Documents\GitHub\endurain"
set "repo[7]=C:\Users\lieve\Documents\GitHub\ferrishare"
set "repo[8]=C:\Users\lieve\Documents\GitHub\filebrowser"
set "repo[9]=C:\Users\lieve\Documents\GitHub\firefly-iii"
set "repo[10]=C:\Users\lieve\Documents\GitHub\Fladder"
set "repo[11]=C:\Users\lieve\Documents\GitHub\grocy"
set "repo[12]=C:\Users\lieve\Documents\GitHub\immich"
set "repo[13]=C:\Users\lieve\Documents\GitHub\immich-go"
set "repo[14]=C:\Users\lieve\Documents\GitHub\jellyfin"
set "repo[15]=C:\Users\lieve\Documents\GitHub\jellyfin-media-player"
set "repo[16]=C:\Users\lieve\Documents\GitHub\jellyfin-plugin-streamyfin"
set "repo[17]=C:\Users\lieve\Documents\GitHub\jellyfin-web"
set "repo[18]=C:\Users\lieve\Documents\GitHub\jellyfin-webos"
set "repo[19]=C:\Users\lieve\Documents\GitHub\jellyseerr"
set "repo[20]=C:\Users\lieve\Documents\GitHub\jellystat"
set "repo[21]=C:\Users\lieve\Documents\GitHub\ladybird"
set "repo[22]=C:\Users\lieve\Documents\GitHub\manage-my-damn-life-nextjs"
set "repo[23]=C:\Users\lieve\Documents\GitHub\nginx-proxy-manager"
set "repo[24]=C:\Users\lieve\Documents\GitHub\paperless-ai"
set "repo[25]=C:\Users\lieve\Documents\GitHub\paperless-ngx"
set "repo[26]=C:\Users\lieve\Documents\GitHub\ProxmoxVE"
set "repo[27]=C:\Users\lieve\Documents\GitHub\spksrc"
set "repo[28]=C:\Users\lieve\Documents\GitHub\streamyfin"
set "repo[29]=C:\Users\lieve\Documents\GitHub\Swiftfin"
set "repo[30]=C:\Users\lieve\Documents\GitHub\synapse"
set "repo[31]=C:\Users\lieve\Documents\GitHub\syncthing"
set "repo[32]=C:\Users\lieve\Documents\GitHub\tailscale"
set "repo[33]=C:\Users\lieve\Documents\GitHub\tududi"
set "repo[34]=C:\Users\lieve\Documents\GitHub\tuwunel"
set "repo[35]=C:\Users\lieve\Documents\GitHub\zigbee2mqtt"

:: counter to tell how many pulls were done
:: the pathcounter variable is used to cycle through only the amount of paths defined
set "count=0"
set "pathcount=35"


:: working for loop
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
