#!/bin/bash

# See also http://benhodge.wordpress.com/2008/02/17/cleaning-up-a-ubuntu-gnulinux-system/

# FIXME means there may be more space to save.
# Current version removes: ~800g.  With export_prep.sh: ~900g

# 0mb
sudo apt-get -yq autoremove

# 305mb - Libre Office
sudo apt-get -yq remove --purge libreoffice-core libreoffice-common libreoffice-writer libreoffice-help-en-us \
       libreoffice-help-en-gb  libreoffice-draw libreoffice-l10n-en-gb libreoffice-l10n-en-za libreoffice-style-human \
       libreoffice-base-core  libreoffice-impress libreoffice-math libreoffice-gtk libreoffice-l10n-common libreoffice-gnome \
       libreoffice-emailmerge 
sudo apt-get -yq remove --purge language-support-writing-en language-support-en uno-libs3 ure
#  18mb - Games
sudo apt-get -yq remove --purge gbrainy aisleriot gnomine gnome-mahjongg gnome-sudoku
#  12mb - Accessability
sudo apt-get -yq remove --purge gnome-orca gnome-mag brltty brltty-x11 onboard                                           
#   9mb - Screen savers
sudo apt-get -yq remove --purge xscreensaver-data xscreensaver-gl screensaver-default-images gnome-screensaver ubuntu-desktop
# 144mb - User guide
sudo apt-get -yq remove --purge gnome-user-guide gnome-user-guide-en ubuntu-docs             
#   3mb - Bluetooth FIXME
sudo apt-get -yq remove --purge gnome-bluetooth bluez bluez-alsa bluez-gstreamer bluez-cups 
#  .3mb - Skype clone FIXME (9)
sudo apt-get -yq remove --purge espeak                                                 
#  23mb - Email FIXME (75)
sudo apt-get -yq remove --purge evolution evolution-common evolution-data-server evolution-exchange evolution-indicator evolution-plugins evolution-webcal libevolution
#   1mb - Spam filter
sudo apt-get -yq remove --purge bogofilter bogofilter-bdb bogofilter-common                  
#  63mb - Printing FIXME (98)
sudo apt-get -yq remove --purge ubuntu-standard \
     cups cups-bsd cups-client cups-common \
     ghostscript ghostscript-x ghostscript-cups \
     cups-driver-gutenprint python-cups \
     system-config-printer-common system-config-printer-gnome system-config-printer-udev \
     foo2zjs foomatic-db-engine foomatic-filters \
     min12xxw openprinting-ppds pnm2ppa pxljr splix hplip-data hplip hpijs libcupsmime1 libcupsdriver1 libgutenprint2 libcupsppdc1
# 15mb - Scanner drivers
sudo apt-get -yq remove --purge sane-utils simple-scan libsane libsane-hpaio
#  4mb - Shotwell photo manager
sudo apt-get -yq remove --purge shotwell
#  3mb - Tomboy notepad
sudo apt-get -yq remove --purge tomboy
#  28mb - Mono .net layer
sudo apt-get -yq remove --purge libart2.0-cil libgconf2.0-cil libglade2.0-cil libglib2.0-cil \
  libgmime2.4-cil libgnome-vfs2.0-cil libgnome2.24-cil libgtk2.0-cil \
  liblaunchpad-integration1.0-cil libmono-addins-gui0.2-cil libmono-addins0.2-cil libmono-cairo2.0-cil \
  libmono-corlib2.0-cil libmono-i18n-west2.0-cil libmono-posix2.0-cil \
  libmono-security2.0-cil libmono-sharpzip2.84-cil libmono-system2.0-cil \
  libndesk-dbus-glib1.0-cil libndesk-dbus1.0-cil mono-2.0-gac mono-gac mono-runtime
  # don't include ubuntu-mono, or light-themes will go too (ambiance and clearlooks)
#   8mb - Fancy GUI Compiz (FIXME 15)
sudo apt-get -yq remove --purge compiz compiz-core compiz-gnome compiz-plugins compizconfig-backend-gconf libcompizconfig0 libdecoration0 
#   6mb - Example videos and stuff
sudo apt-get -yq remove --purge example-content
#  43mb - Video drivers
sudo apt-get -yq remove --purge nvidia-common libgl1-mesa-dri                                       
#   8mb - Video Drivers
sudo apt-get -yq remove --purge xserver-xorg-video-all xserver-xorg-video-apm xserver-xorg-video-ark xserver-xorg-video-ati xserver-xorg-video-chips xserver-xorg-video-cirrus xserver-xorg-video-geode xserver-xorg-video-i128 xserver-xorg-video-i740 xserver-xorg-video-intel xserver-xorg-video-mach64 xserver-xorg-video-mga xserver-xorg-video-neomagic xserver-xorg-video-nv xserver-xorg-video-openchrome xserver-xorg-video-r128 xserver-xorg-video-radeon xserver-xorg-video-rendition xserver-xorg-video-s3 xserver-xorg-video-s3virge xserver-xorg-video-savage xserver-xorg-video-siliconmotion xserver-xorg-video-sis xserver-xorg-video-sisusb xserver-xorg-video-tdfx xserver-xorg-video-trident xserver-xorg-video-tseng xserver-xorg-video-vmware xserver-xorg-video-voodoo
#  .7mb - Math app - linear programming
sudo apt-get -yq remove --purge lp-solve
#   1mb - Bittorrent client
sudo apt-get -yq remove --purge transmission-common transmission-gtk                         
#  13mb - Instant Messaging 
sudo apt-get -yq remove --purge empathy empathy-common nautilus-sendto-empathy nautilus-sendto telepathy-haze nautilus-sendto-empathy libpurple0 libpurple-bin libtelepathy-farsight0
#   5mb - Laptop stuff
sudo apt-get -yq remove --purge gnome-power-manager wireless-tools 
#   6mb - Desktop theming
sudo apt-get -yq remove --purge gnome-accessibility-themes ubuntu-sounds gnome-games-common 
#   3mb - VNC
sudo apt-get -yq remove --purge vinagre libgtk-vnc-1.0-0 vino
#   3mb - Chat client
sudo apt-get -yq remove --purge gwibber gwibber-service telepathy-gabble libtelepathy-glib0
#   2mb - video editor
sudo apt-get -yq remove --purge pitivi
#   5mb - Etc
sudo apt-get -yq remove --purge usb-creator-gtk checkbox-gtk ubuntuone-client-gnome jockey-gtk computer-janitor-gtk
#   2mb - Etc Etc
sudo apt-get -yq remove --purge xserver-xorg-input-all xserver-xorg-input-synaptics xserver-xorg-input-wacom #touchpad .5mb
sudo apt-get -yq remove --purge nvidia-96-modaliases nvidia-173-modaliases # graphics card detection .1mb
sudo apt-get -yq remove --purge eog #graphic viewer 1.6mb

# 0mb
sudo apt-get -yq autoremove
# Clean out downloaded packages
sudo apt-get -yq clean

# What's installed: look in file whats_installed.txt
for pkg in `dpkg --list | awk '/ii/ {print $2}'`; do echo -e "`dpkg --status $pkg | grep Installed-Size | awk '{print $2}'` \t\t $pkg" >> pkgs.tmp; done; sort -rg pkgs.tmp > ~/quickstart/quickstart-slim-package-list.txt; rm -f pkgs.tmp;
echo "------------  -------------------" >> ~/quickstart/quickstart-slim-package-list.txt
echo "size(kb)         packagename" >> ~/quickstart/quickstart-slim-package-list.txt

# Ending size
df -h -T > ~/quickstart/quickstart-size-slim.txt

# 3.0gb -> 2.2gb

# To "unslim" try this (untested, and written for 9.04):
#   sudo apt-get -yq install ubuntu-desktop ubuntu-standard 
#   sudo apt-get -yq install xserver-xorg-input-all xserver-xorg-video-all nvidia-common
#   sudo apt-get -yq install ubuntu-restricted-extras
