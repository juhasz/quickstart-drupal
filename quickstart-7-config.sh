#!/bin/bash

# Remove fancy high-falutin new 3d-glasses scrollbars.  In my day we just had arrow keys!
sudo apt-get -y remove overlay-scrollbar liboverlay-scrollbar-0.1-0

# Change default theme
gconftool-2 -s /apps/metacity/general/theme --type=string Radiance
gconftool-2 -s /desktop/gnome/interface/gtk_theme --type=string Radiance
gconftool-2 -s /desktop/gnome/interface/icon_theme --type=string ubuntu-mono-light

# automatic updates.  apply security.  download updates
echo "
APT::Periodic::Enable \"1\";
APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::AutocleanInterval \"5\";
APT::Periodic::Unattended-Upgrade \"1\";
" | sudo tee /etc/apt/apt.conf.d/10periodic > /dev/null

# setup icons on top of screen
sudo apt-get -yq install netspeed
echo "#!/usr/bin/env xdg-open

[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=/home/quickstart/eclipse/icon.xpm
Name[en_US]=Eclipse
Exec=/home/quickstart/eclipse/eclipse
Comment[en_US]=IDE
Name=Eclipse
Comment=IDE
Icon=/home/quickstart/eclipse/icon.xpm
" | tee /home/quickstart/.gnome2/panel2.d/default/launchers/eclipse.desktop > /dev/null
# created with: gconftool-2 --dump /apps/panel > my-panel-setup.entries
gconftool-2 --load ~/quickstart/config/my-panel-setup.entries
#killall gnome-panel  #this not working for some reason.  Just did a reboot after this script

# final size
df -h -T > ~/quickstart/quickstart-size-end.txt

# If the world was built by designers, it would be gorgeous, and noone could do anything.  Make windows edges dragable for resizing.
sudo cp ~/quickstart/config/radiance-metacity-theme-1.xml /usr/share/themes/Radiance/metacity-1/metacity-theme-1.xml

# get rid of subversion commit keyring.  Store passwords plain on disk
sudo sed -i 's/# password-stores = gnome-keyring,kwallet/password-stores = /g' ~/.subversion/config
sudo sed -i 's/# store-plaintext-passwords = no/store-plaintext-passwords = yes/g' ~/.subversion/servers

