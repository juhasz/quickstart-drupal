#!/bin/bash

cd ~

## Install java - 100mb
sudo apt-get -y install default-jre


## Basic editors

# Config gedit-2
gconftool-2 -s /apps/gedit-2/preferences/editor/auto_indent/auto_indent --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/bracket_matching/bracket_matching --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/line_numbers/display_line_numbers --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/current_line/highlight_current_line --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/right_margin/display_right_margin --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/wrap_mode/wrap_mode --type=string GTK_WRAP_NONE
gconftool-2 -s /apps/gedit-2/preferences/editor/tabs/insert_spaces --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/tabs/tabs_size --type=integer 2
gconftool-2 -s /apps/gedit-2/preferences/editor/save/auto_save --type=bool true
sudo apt-get -y install gedit-plugins

# gnome terminal
gconftool-2 -s /apps/gnome-terminal/profiles/Default/scrollback_unlimited --type=bool true

# Install graphical version control - weighs about 58mb
sudo add-apt-repository ppa:rabbitvcs/ppa && sudo apt-get update
sudo apt-get -y install rabbitvcs-nautilus
sudo killall nautilus

# Install graphics editors - weights about 25mb
sudo apt-get -y install gimp


## GUI IDE's

# Download and install eclipse - 167mb
ECLIPSE_URL="http://mirrors.ibiblio.org/pub/mirrors/eclipse/technology/epp/downloads/release/helios/SR1/eclipse-php-helios-SR1-linux-gtk.tar.gz"
wget -O eclipse.tar.gz $ECLIPSE_URL
tar -xvf eclipse.tar.gz
sudo ln -s /home/quickstart/eclipse/eclipse /usr/bin/eclipse 
rm eclipse.tar.gz
# PPA's are a good idea, but about 458mb!
#sudo add-apt-repository ppa:yogarine/eclipse/ubuntu && sudo apt-get update
#sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install eclipse eclipse-pdt eclipse-plugin-cvs eclipse-subclipse

# Download and install netbeans - 122mb
# do this last - it has a GUI :-)
NETBEANS_URL="http://download.netbeans.org/netbeans/6.9.1/final/bundles/netbeans-6.9.1-ml-php-linux.sh"
wget -O netbeans.sh $NETBEANS_URL
chmod +x ./netbeans.sh
bash ./netbeans.sh --silent
rm netbeans.sh

