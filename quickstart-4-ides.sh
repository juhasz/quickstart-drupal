#!/bin/bash

# Install java - 100mb
sudo apt-get -y install default-jre


# Download and install netbeans - 100mb
NETBEANS_URL="http://download.netbeans.org/netbeans/6.9/final/bundles/netbeans-6.9-ml-php-linux.sh"
sudo apt-get -y install wget
cd ~/Desktop
wget -O netbeans.sh $NETBEANS_URL
chmod +x ./netbeans.sh
zenity --info --text="The Netbeans PHP installer will start now.\n1) Accept the defaults.\n2) Uncheck 'register' on last screen."
bash ./netbeans.sh
rm netbeans.sh
cd ~


# Download and install eclipse - About 341 mb
sudo add-apt-repository ppa:yogarine/eclipse/ubuntu && sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install eclipse eclipse-pdt eclipse-plugin-cvs eclipse-subclipse


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


# Install graphics editors - weights about 54mb
sudo apt-get -y install gimp

# Install graphical version control - weighs about 83mb
sudo add-apt-repository ppa:rabbitvcs/ppa && sudo apt-get update
sudo apt-get -y install rabbitvcs-nautilus
sudo killall nautilus


