#!/bin/bash

# See here for list of browsers and rendering engines http://en.wikipedia.org/wiki/List_of_web_browsers

# install firefox browser (gecko)
sudo aptitude -y install firefox flashplugin-nonfree

# install chrome browser (Webkit (fork of KHTML/Konquerer).  Used by Safari)
sudo aptitude -y install chromium-browser flashplugin-nonfree
sudo ln -s /usr/lib/flashplugin-installer/libflashplayer.so /usr/lib/chromium-browser/plugins/

# install opera browser (presto)
# FIXME: This doesn't work.
# deb http://deb.opera.com/opera/ stable non-free
# wget -O - http://deb.opera.com/archive.key | sudo apt-key add -
# sudo apt-get install debian-archive-keyring
# sudo aptitude update
# sudo aptitude -y install opera

# install IE using wine (trident)
# http://www.tatanka.com.br/ies4linux/page/Beta
# this doesn't work anymore, but might in future.

