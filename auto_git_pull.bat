@echo off
setlocal enabledelayedexpansion

:: wait time between pulls in the loop
set "waittime=3"



:: user input configuration
echo you will now get asked a few configurations before the script runs
timeout /t %waittime% >nul
set /p ToFetch="Do you want to fetch the latest changes before pulling? (y/n): "


:: defined paths to git repositories
::CATEGORIES 
    :: - Jellyfin
set "repo[0]=C:\Users\lieve\Documents\GitHub\JELLY\Fladder"
set "repo[1]=C:\Users\lieve\Documents\GitHub\JELLY\jellyfin"
set "repo[2]=C:\Users\lieve\Documents\GitHub\JELLY\jellyfin-media-player"
set "repo[3]=C:\Users\lieve\Documents\GitHub\JELLY\jellyfin-plugin-streamyfin"
set "repo[4]=C:\Users\lieve\Documents\GitHub\JELLY\jellyfin-web"
set "repo[5]=C:\Users\lieve\Documents\GitHub\JELLY\jellyfin-webos"
set "repo[6]=C:\Users\lieve\Documents\GitHub\JELLY\jellyseerr"
set "repo[7]=C:\Users\lieve\Documents\GitHub\JELLY\jellystat"
set "repo[8]=C:\Users\lieve\Documents\GitHub\JELLY\streamyfin"
set "repo[9]=C:\Users\lieve\Documents\GitHub\JELLY\Swiftfin"

    :: - home assistant
set "repo[10]=C:\Users\lieve\Documents\Github\HOME_ASSISTANT\core"
set "repo[11]=C:\Users\lieve\Documents\Github\HOME_ASSISTANT\frontend" 
set "repo[12]=C:\Users\lieve\Documents\Github\HOME_ASSISTANT\supervisor"
set "repo[13]=C:\Users\lieve\Documents\Github\HOME_ASSISTANT\operating-system"

    :: - personal repositories
set "repo[14]=C:\Users\lieve\Documents\Github\personal_repos\home_server"
set "repo[15]=C:\Users\lieve\Documents\Github\personal_repos\autopullscripter"

    :: - Other
set "repo[16]=C:\Users\lieve\Documents\GitHub\blink"
set "repo[17]=C:\Users\lieve\Documents\GitHub\csm"
set "repo[18]=C:\Users\lieve\Documents\GitHub\dockge"
set "repo[19]=C:\Users\lieve\Documents\GitHub\element-x-ios"
set "repo[20]=C:\Users\lieve\Documents\GitHub\endurain"
set "repo[21]=C:\Users\lieve\Documents\GitHub\ferrishare"
set "repo[22]=C:\Users\lieve\Documents\GitHub\filebrowser"
set "repo[23]=C:\Users\lieve\Documents\GitHub\firefly-iii"
set "repo[24]=C:\Users\lieve\Documents\GitHub\grocy"
set "repo[25]=C:\Users\lieve\Documents\GitHub\immich"
set "repo[26]=C:\Users\lieve\Documents\GitHub\immich-go"
set "repo[27]=C:\Users\lieve\Documents\GitHub\ladybird"
set "repo[28]=C:\Users\lieve\Documents\GitHub\manage-my-damn-life-nextjs"
set "repo[29]=C:\Users\lieve\Documents\GitHub\nginx-proxy-manager"
set "repo[30]=C:\Users\lieve\Documents\GitHub\paperless-ai"
set "repo[31]=C:\Users\lieve\Documents\GitHub\paperless-ngx"
set "repo[32]=C:\Users\lieve\Documents\GitHub\ProxmoxVE"
set "repo[34]=C:\Users\lieve\Documents\GitHub\spksrc"
set "repo[36]=C:\Users\lieve\Documents\GitHub\synapse"
set "repo[37]=C:\Users\lieve\Documents\GitHub\syncthing"
set "repo[38]=C:\Users\lieve\Documents\GitHub\tailscale"
set "repo[39]=C:\Users\lieve\Documents\GitHub\tududi"
set "repo[40]=C:\Users\lieve\Documents\GitHub\tuwunel"
set "repo[41]=C:\Users\lieve\Documents\GitHub\zigbee2mqtt"
set "repo[42]=C:\Users\lieve\Documents\GitHub\vaultwarden"

:: counter to tell how many pulls were done
:: the pathcounter variable is used to cycle through only the amount of paths defined
set "count=0"
set "pathcount=42"


:: working for loop
FOR /L %%A in (1,1,%pathcount%) DO (
    set "currentPath=!repo[%%A]!"
       
    echo Iteration %%A
    echo Current path: !currentPath!
    cd /d "!currentPath!"
    
    if /i "!ToFetch!"=="y" (
        echo Fetching latest changes...
        git fetch origin
    ) else (
        echo Skipping fetch.
    )
    echo Pulling changes...
    git pull
    
    echo ----------------------------------
    echo Pull completed for !currentPath!
    echo ----------------------------------

    set /a count+=1
    timeout /t %waittime% >nul
)

echo Total pulls: %count%
pause
