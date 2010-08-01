#!/bin/bash

# See here for list of browsers and rendering engines http://en.wikipedia.org/wiki/List_of_web_browsers

# Install firefox browser (gecko)
sudo apt-get -y install firefox flashplugin-nonfree

wget http://www.michaelcole.com/sites/default/files/Quickstart.fbu
mv Quickstart.fbu profileFx3{default}.fbu
firefox -CreateProfile temp
zenity --info --text="Firefox will start.  Install the FEBE backup extension.  THEN CLOSE FIREFOX."
firefox -P temp https://addons.mozilla.org/en-US/firefox/downloads/latest/2109/addon-2109-latest.xpi?src=addondetail
zenity --info --text="Firefox will start.  Tools -> FEBE -> Restore profile.  Click 'default' in list.  'Select backup' profile in the list.  Choose file: ~/quickstart/profileFx3{default}.fbu.  Start profile restore.  THEN CLOSE FIREFOX"
firefox -P temp
zenity --info --text="Firefox profile manager will start.  Delete temp profile. THEN CLOSE FIREFOX."
firefox -ProfileManager

# Install chrome browser (Webkit (fork of KHTML/Konquerer).  Used by Safari)
sudo apt-get -y install chromium-browser flashplugin-nonfree
sudo ln -s /usr/lib/flashplugin-installer/libflashplayer.so /usr/lib/chromium-browser/plugins/

