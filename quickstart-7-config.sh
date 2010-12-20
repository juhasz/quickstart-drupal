#!/bin/bash

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
" | sudo tee /etc/apt/apt.conf.d/10periodic

# setup icons on top of screen
sudo apt-get -y install netspeed
# created with: gconftool-2 --dump /apps/panel > my-panel-setup.entries
gconftool-2 --load ~/quickstart/config/my-panel-setup.entries
killall gnome-panel

# final size
df -h -T > ~/quickstart/quickstart-size-end.txt

