#!/bin/bash
set -e

NEKORAY_URL="https://api.github.com/repos/MatsuriDayo/nekoray/releases/latest"
NEKORAY_FILE_NAME="NekoRay"
NEKORAY_DESKTOPFILE="$HOME/.local/share/applications/nekoray.desktop"
NEKORAY_CONFIG_DIR="$HOME/.config/nekoray"
WGET_TIMEOUT="15"
ULKA_CONFIG_URL="https://github.com/UlkaVPN/nekoray-setup/releases/latest/download/config.zip"

# Just for fun
# Source: https://patorjk.com/software/taag/#p=display&v=1&f=ANSI%20Shadow&t=NekoRay%20Installer
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo -e "\n${GREEN}
 __   __     ______     __  __     ______     ______     ______     __  __    
/\ "-.\ \   /\  ___\   /\ \/ /    /\  __ \   /\  == \   /\  __ \   /\ \_\ \   
\ \ \-.  \  \ \  __\   \ \  _"-.  \ \ \/\ \  \ \  __<   \ \  __ \  \ \____ \  
 \ \_\\"\_\  \ \_____\  \ \_\ \_\  \ \_____\  \ \_\ \_\  \ \_\ \_\  \/\_____\ 
  \/_/ \/_/   \/_____/   \/_/\/_/   \/_____/   \/_/ /_/   \/_/\/_/   \/_____/ 
                                                                              
 __  __     __         __  __     ______     __   __   ______   __   __       
/\ \/\ \   /\ \       /\ \/ /    /\  __ \   /\ \ / /  /\  == \ /\ "-.\ \      
\ \ \_\ \  \ \ \____  \ \  _"-.  \ \  __ \  \ \ \'/   \ \  _-/ \ \ \-.  \     
 \ \_____\  \ \_____\  \ \_\ \_\  \ \_\ \_\  \ \__|    \ \_\    \ \_\\"\_\    
  \/_____/   \/_____/   \/_/\/_/   \/_/\/_/   \/_/      \/_/     \/_/ \/_/    
                                                                              
${NC}\n"

# Check if installed or not
if [ -d "$HOME/$NEKORAY_FILE_NAME" ]; then
  echo -e "You already have this software installed in $HOME/$NEKORAY_FILE_NAME.\nPlease take a backup and delete it and run this script again!"
  exit
fi

# Download NekoRay and move to current user home 
if ! command -v unzip &> /dev/null
then
    echo -e "unzip is not installed.\nInstall unzip in your system.\nFor example: sudo apt install unzip"
    exit
fi
if ! command -v wget &> /dev/null
then
    echo -e "wget is not installed.\nInstall wget in your system.\nFor example: sudo apt install wget"
    exit
fi
wget --timeout=$WGET_TIMEOUT -q -O- $NEKORAY_URL \
 | grep -E "browser_download_url.*linux64" \
 | cut -d : -f 2,3 \
 | tr -d \" \
 | wget --timeout=$WGET_TIMEOUT -q --show-progress --progress=bar:force -O /tmp/nekoray.zip -i -
unzip /tmp/nekoray.zip -d $HOME/$NEKORAY_FILE_NAME && rm /tmp/nekoray.zip

# Create Desktop icon for current user
[ -e $NEKORAY_DESKTOPFILE ] && rm $NEKORAY_DESKTOPFILE

cat <<EOT >> $NEKORAY_DESKTOPFILE 
[Desktop Entry]
Name=NekoRay
Comment=NekoRay
Exec=$HOME/$NEKORAY_FILE_NAME/nekoray/nekoray
Icon=$HOME/$NEKORAY_FILE_NAME/nekoray/nekoray.png
Terminal=false
StartupWMClass=NekoRay,nekoray,Nekoray,nekoRay
Type=Application
Categories=Network
EOT

# Permissions
chown $USER:$USER $HOME/$NEKORAY_FILE_NAME/ -R
chmod +x $HOME/$NEKORAY_FILE_NAME/nekoray/nekoray -R

# Nekoray UlkaVPN settings
echo "Configuring UlkaVPN..."

# Download and extract configuration files
if [ ! -d "$NEKORAY_CONFIG_DIR" ]; then
    echo "Creating configuration directory at $NEKORAY_CONFIG_DIR..."
    mkdir -p "$NEKORAY_CONFIG_DIR"
fi

echo "Downloading UlkaVPN configuration files..."
wget --timeout=$WGET_TIMEOUT -q -O /tmp/config.zip "$ULKA_CONFIG_URL"
unzip -o /tmp/config.zip -d "$NEKORAY_CONFIG_DIR" && rm /tmp/config.zip

# Done
echo -e "\nDone, type 'NekoRay' in your desktop!"
