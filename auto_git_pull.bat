set "waittime=10" # the waitime between libraries pulls

cd C:\Users\lieve\Documents\Github\Blink
git pull
timeout /t %waittime%

cd core
git pull
cd ..
timeout /t %waittime%

cd csm
git pull
cd ..
timeout /t %waittime%

cd ferrishare
git pull
cd ..
timeout /t %waittime%

cd firefly-iii
git pull
cd ..
timeout /t %waittime%

cd Fladder
git pull
cd ..
timeout /t %waittime%

cd home_server
git pull
cd ..
timeout /t %waittime%

cd immich
git pull
cd ..
timeout /t %waittime%

cd jellyfin
git pull
cd ..
timeout /t %waittime%

cd jellyfin-media-player
git pull
cd ..
timeout /t %waittime%

cd jellyfin-plugin-streamyfin
git pull
cd ..
timeout /t %waittime%

cd jellyfin-web
git pull
cd ..
timeout /t %waittime%

cd jellyfin-webos
git pull
cd ..
timeout /t %waittime%

cd jellystat
git pull
cd ..
timeout /t %waittime%

cd ladybird
git pull
cd ..
timeout /t %waittime%

cd ProxmoxVE
git pull
cd ..
timeout /t %waittime%

cd spksrc
git pull
cd ..
timeout /t %waittime%

cd streamyfin
git pull
cd ..
timeout /t %waittime%

cd streamystats
git pull
cd ..
timeout /t %waittime%

cd Swiftfin
git pull
cd ..
timeout /t %waittime%

cd syncthing
git pull
cd ..
timeout /t %waittime%

cd tailscale
git pull
cd ..
timeout /t %waittime%

cd tuwunel
git pull
cd ..
timeout /t %waittime%

cd zigbee2mqtt
git pull
cd ..
timeout /t %waittime%

cd grocy
git pull
cd ..
timeout /t %waittime%

cd paperless-ngx
git pull
cd ..
timeout /t %waittime%

cd manage-my-damn-life-nextjs
git pull
cd ..
timeout /t %waittime%

cd dockge
git pull
cd ..
timeout /t %waittime%


cd synapse
git pull
cd ..
timeout /t %waittime%

cd element-x-ios
git pull
cd ..
timeout /t %waittime%

cd nginx-proxy-manager
git pull
cd ..
timeout /t %waittime%

cd jellyseerr
git pull
cd ..
timeout /t %waittime%

cd filebrowser
git pull
cd ..
timeout /t %waittime%

cd paperless-ai
git pull
cd ..
timeout /t %waittime%

cd tududi
git pull
cd ..
timeout /t %waittime%

cd endurain
git pull
cd ..
timeout /t %waittime%

timeout /t -1