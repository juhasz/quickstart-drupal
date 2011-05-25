#!/bin/bash

NETBEANS_URL="http://download.netbeans.org/netbeans/7.0/final/bundles/netbeans-7.0-ml-php-linux.sh"
if [ `uname -p` == "x86_64" ] 
then
  ECLIPSE_URL="http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/helios/SR2/eclipse-php-helios-SR2-linux-gtk-x86_64.tar.gz"
else
  ECLIPSE_URL="http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/helios/SR2/eclipse-php-helios-SR2-linux-gtk.tar.gz"
fi
echo "*** ECLIPSE URL: $ECLIPSE_URL"

cd ~

## Install java - 100mb
sudo apt-get -yq install default-jre


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
sudo apt-get -yq install gedit-plugins

# gnome terminal
gconftool-2 -s /apps/gnome-terminal/profiles/Default/scrollback_unlimited --type=bool true

# Install graphical version control - weighs about 58mb
# sudo add-apt-repository ppa:rabbitvcs/ppa && sudo apt-get update # ppa not working 2011-05-25
sudo apt-get -yq install rabbitvcs-nautilus
sudo killall nautilus

# Install graphics editors - weights about 25mb
sudo apt-get -yq install gimp


## GUI IDE's

# Download and install eclipse - 167mb
wget -nv -O eclipse.tar.gz $ECLIPSE_URL
tar -xvf eclipse.tar.gz
sudo ln -s /home/quickstart/eclipse/eclipse /usr/bin/eclipse 
rm eclipse.tar.gz
# PPA's are a good idea, but about 458mb!
#sudo add-apt-repository ppa:yogarine/eclipse/ubuntu && sudo apt-get update
#sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq install eclipse eclipse-pdt eclipse-plugin-cvs eclipse-subclipse

# Download and install netbeans - 122mb
wget -nv -O netbeans.sh $NETBEANS_URL
chmod +x ./netbeans.sh
bash ./netbeans.sh --silent
rm netbeans.sh

