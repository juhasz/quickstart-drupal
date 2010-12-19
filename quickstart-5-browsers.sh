#!/bin/bash

# See here for list of browsers and rendering engines http://en.wikipedia.org/wiki/List_of_web_browsers

# Install firefox browser (gecko)
sudo apt-get -y install firefox flashplugin-nonfree

wget http://www.michaelcole.com/sites/default/files/Quickstart.fbu
mv Quickstart.fbu profileFx3{default}.fbu
zenity --info --text="Firefox will start.\n1) Wait for browser to load (firefox is creating Default User).\n2) THEN CLOSE FIREFOX."
firefox
firefox -CreateProfile temp
zenity --info --text="Firefox will start.\n1) Install the FEBE backup extension.\n2) THEN CLOSE FIREFOX."
firefox -P temp https://addons.mozilla.org/en-US/firefox/downloads/latest/2109/addon-2109-latest.xpi?src=addondetail
zenity --info --text="Firefox will start.\n1) Tools -> FEBE -> Restore profile.\n2) Click 'Default User' in list (create if it's not there).\n3) 'Select local backup' in the list.\n4) Choose file: ~/profileFx3{default}.fbu.\n5) Start profile restore.\n6) THEN CLOSE FIREFOX"
firefox -P temp
zenity --info --text="Firefox profile manager will start.\n1) Delete temp profile.\n2) THEN CLOSE FIREFOX."
firefox -ProfileManager
rm profileFx3{default}.fbu

# Install chrome browser (Webkit - fork of KHTML/Konquerer, also used by Safari)
sudo apt-get -y install chromium-browser flashplugin-nonfree
sudo ln -s /usr/lib/flashplugin-installer/libflashplayer.so /usr/lib/chromium-browser/plugins/

