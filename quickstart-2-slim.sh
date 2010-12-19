#!/bin/bash

# See also http://benhodge.wordpress.com/2008/02/17/cleaning-up-a-ubuntu-gnulinux-system/

# FIXME means there may be more space to save.
# Current version removes: ~800g.  With export_prep.sh: ~900g

# 0mb
sudo apt-get -y autoremove

# Cleaning utilities
sudo apt-get -y install deborphan autoclean bleachbit

# 362mb - Open office
sudo apt-get -y remove --purge openoffice.org-core openoffice.org-common openoffice.org-writer openoffice.org-calc openoffice.org-math \
     openoffice.org-impress openoffice.org-base-core openoffice.org-draw openoffice.org-emailmerge openoffice.org-gnome openoffice.org-gtk \
     openoffice.org-help-en-gb openoffice.org-help-en-us openoffice.org-l10n-en-gb openoffice.org-l10n-en-za openoffice.org-style-human \
     openoffice.org-thesaurus-en-au python-uno language-support-writing-en openoffice.org-thesaurus-en-us openoffice.org-hyphenation \
     openoffice.org-hyphenation-en-us openoffice.org-l10n-common language-support-en uno-libs3 ure
#  18mb - Games
sudo apt-get -y remove --purge quadrapassel gbrainy aisleriot gnomine gnome-mahjongg gnome-sudoku
#  12mb - Accessability
sudo apt-get -y remove --purge gnome-orca gnome-mag brltty brltty-x11 onboard                                           
#   9mb - Screen savers
sudo apt-get -y remove --purge xscreensaver-data xscreensaver-gl screensaver-default-images gnome-screensaver ubuntu-desktop
# 144mb - User guide
sudo apt-get -y remove --purge gnome-user-guide gnome-user-guide-en ubuntu-docs             
#   3mb - Bluetooth FIXME
sudo apt-get -y remove --purge gnome-bluetooth bluez bluez-alsa bluez-gstreamer bluez-cups 
#  .3mb - Skype clone FIXME (9)
sudo apt-get -y remove --purge espeak                                                 
#  23mb - Email FIXME (75)
sudo apt-get -y remove --purge evolution evolution-common evolution-data-server evolution-exchange evolution-indicator evolution-plugins evolution-webcal evolution-couchdb libevolution
#   1mb - Spam filter
sudo apt-get -y remove --purge bogofilter bogofilter-bdb bogofilter-common                  
#  63mb - Printing FIXME (98)
sudo apt-get -y remove --purge ubuntu-standard \
     cups cups-bsd cups-client cups-common \
     ghostscript ghostscript-x ghostscript-cups \
     cups-driver-gutenprint python-cups \
     system-config-printer-common system-config-printer-gnome system-config-printer-udev \
     foo2zjs foomatic-db-engine foomatic-filters \
     min12xxw openprinting-ppds pnm2ppa pxljr splix hplip-data hplip hpijs libcupsmime1 libcupsdriver1 libgutenprint2 libcupsppdc1
# 15mb - Scanner drivers
sudo apt-get -y remove --purge sane-utils simple-scan libsane libsane-hpaio
#  4mb - Shotwell photo manager
sudo apt-get -y remove --purge shotwell
#  3mb - Tomboy notepad
sudo apt-get -y remove --purge tomboy
#  28mb - Mono .net layer
sudo apt-get -y remove --purge libart2.0-cil libgconf2.0-cil libglade2.0-cil libglib2.0-cil \
  libgmime2.4-cil libgnome-vfs2.0-cil libgnome2.24-cil libgnomepanel2.24-cil libgtk2.0-cil \
  liblaunchpad-integration1.0-cil libmono-addins-gui0.2-cil libmono-addins0.2-cil libmono-cairo2.0-cil \
  libmono-corlib2.0-cil libmono-i18n-west2.0-cil libmono-posix2.0-cil \
  libmono-security2.0-cil libmono-sharpzip2.84-cil libmono-system2.0-cil \
  libndesk-dbus-glib1.0-cil libndesk-dbus1.0-cil mono-2.0-gac mono-gac mono-runtime
  # don't include ubuntu-mono, or light-themes will go too (ambiance and clearlooks)
#   8mb - Fancy GUI Compiz (FIXME 15)
sudo apt-get -y remove --purge compiz compiz-core compiz-gnome compiz-plugins compiz-fusion-plugins-main compizconfig-backend-gconf libcompizconfig0 libdecoration0 
#   6mb - Example videos and stuff
sudo apt-get -y remove --purge example-content
#  43mb - Video drivers
sudo apt-get -y remove --purge nvidia-common libgl1-mesa-dri                                       
#   8mb - Video Drivers
sudo apt-get -y remove --purge xserver-xorg-video-all xserver-xorg-video-apm xserver-xorg-video-ark xserver-xorg-video-ati xserver-xorg-video-chips xserver-xorg-video-cirrus xserver-xorg-video-geode xserver-xorg-video-i128 xserver-xorg-video-i740 xserver-xorg-video-intel xserver-xorg-video-mach64 xserver-xorg-video-mga xserver-xorg-video-neomagic xserver-xorg-video-nv xserver-xorg-video-openchrome xserver-xorg-video-r128 xserver-xorg-video-radeon xserver-xorg-video-rendition xserver-xorg-video-s3 xserver-xorg-video-s3virge xserver-xorg-video-savage xserver-xorg-video-siliconmotion xserver-xorg-video-sis xserver-xorg-video-sisusb xserver-xorg-video-tdfx xserver-xorg-video-trident xserver-xorg-video-tseng xserver-xorg-video-vmware xserver-xorg-video-voodoo
#  .7mb - Math app - linear programming
sudo apt-get -y remove --purge lp-solve
#   1mb - Bittorrent client
sudo apt-get -y remove --purge transmission-common transmission-gtk                         
#  13mb - Instant Messaging 
sudo apt-get -y remove --purge empathy empathy-common nautilus-sendto-empathy nautilus-sendto telepathy-haze nautilus-sendto-empathy libpurple0 libpurple-bin libtelepathy-farsight0
#   5mb - Laptop stuff
sudo apt-get -y remove --purge gnome-power-manager wireless-tools 
#   6mb - Desktop theming
sudo apt-get -y remove --purge gnome-accessibility-themes ubuntu-sounds gnome-games-common 
#   3mb - VNC
sudo apt-get -y remove --purge vinagre libgtk-vnc-1.0-0 vino
#   3mb - Chat client
sudo apt-get -y remove --purge gwibber gwibber-service telepathy-gabble libtelepathy-glib0
#   2mb - video editor
sudo apt-get -y remove --purge pitivi
#   5mb - Etc
sudo apt-get -y remove --purge usb-creator-gtk checkbox-gtk ubuntuone-client-gnome jockey-gtk byobu computer-janitor-gtk gnome-dictionary
#   2mb - Etc Etc
sudo apt-get -y remove --purge xserver-xorg-input-all xserver-xorg-input-synaptics xserver-xorg-input-wacom #touchpad .5mb
sudo apt-get -y remove --purge nvidia-96-modaliases nvidia-180-modaliases nvidia-173-modaliases # graphics card detection .1mb
sudo apt-get -y remove --purge eog #graphic viewer 1.6mb

# This is a hack, no way to "undo", not a good idea for non-english speakers.
#sudo apt-get -y install localepurge # package to delete unnecessary translations.  Select en and en_us packages to keep them.

# Other opportunities FIXME
#   9mb - User guide - for 9mb, not worth it.
#sudo apt-get -y remove --purge man-db manpages yelp info evolution-documentation-en ubuntu-standard 
#  39mb - OpenGL
#sudo apt-get -y remove --purge mesa-utils libglu1-mesa libgl1-mesa-dri libgl1-mesa-glx libvisual-0.4-plugins x11-utils xorg libglew1.5 libglitz-glx1 
#  13mb - Pgp GUI - keep for communicating with hosting companies silly!
#sudo apt-get -y remove --purge seahorse seahorse-plugins                                   
#  93mb - Headers for Programming linux - need these for VBox Extensions
#sudo apt-get -y remove --purge linux-headers-2.6.28-11 linux-headers-2.6.28-11-generic linux-headers-generic linux-libc-dev libc6-dev 
#  60mb - Asian fonts - leave in for international
#sudo apt-get -y remove --purge ttf-arphic-uming ttf-indic-fonts-core ttf-lao ttf-sazanami-gothic ttf-sazanami-mincho ttf-thai-tlwg ttf-unfonts-core # Thai/korean/chinese/indian/lao fonts
#   4mb - Doc utils
#sudo apt-get -y remove --purge gnome-doc-utils


# Multi-media Players
#  7mb - Music player cd creator 
# sudo apt-get -y remove --purge rhythmbox brasero wodim libbrasero-media0 cdparanoia rhythmbox-plugins rhythmbox-ubuntuone-music-store rhythmbox-plugin-cdrecorder
#  5mb - Video player 
# sudo apt-get -y remove --purge totem totem-mozilla totem-common totem-gstreamer totem-plugins 

# Multi-media 
#sudo apt-get -y remove --purge gstreamer0.10-plugins-good gstreamer0.10-alsa gstreamer0.10-x gnome-media #4mb
#sudo apt-get -y remove --purge libpt2.6.1 libpt2.6.1-plugins-alsa libpt2.6.1-plugins-v4l2 libv4l-0 libopal3.6.1 #video4linux stuff 4mb
#sudo apt-get -y remove --purge gstreamer0.10-schroedinger libschroedinger-1.0-0 #video codec .5mb
#sudo apt-get -y remove --purge libiec61883-0 #codec stuff .1mb
#sudo apt-get -y remove --purge libavc1394-0 libraw1394-8 #firewire driver .2mb

# Pulse audio
#sudo apt-get -y remove --purge libpulsecore9 libshout3 pulseaudio pulseaudio-esound-compat pulseaudio-module-gconf pulseaudio-module-hal  pulseaudio-module-x11 libspeex1 libspeexdsp1 #audio codec
#sudo apt-get -y remove --purge tsclient libasound2-plugins rdesktop libsamplerate0 #audio rate conversion  3mb
#sudo apt-get -y remove --purge libwavpack1 # audio codec
#sudo apt-get -y remove --purge alsa-base alsa-utils esound-clients libespeak1 espeak-data libpulse-browse0 linux-sound-base pulseaudio-utils libgnome-speech7 #more audio
#sudo apt-get -y remove --purge libvisual-0.4-0  gstreamer0.10-plugins-base # audio playback visualization 2mb
#sudo apt-get -y remove --purge libtag1c2a #mp3 tags .5mb

# 0mb
sudo apt-get -y autoremove
# 32mb - Remove orphan packages - do a couple times
sudo deborphan --guess-all # display them to user
sudo deborphan --guess-all | xargs sudo apt-get -y remove --purge   
sudo deborphan --guess-all # display them to user
sudo deborphan --guess-all | xargs sudo apt-get -y remove --purge   
sudo deborphan --guess-all # display them to user
sudo deborphan --guess-all | xargs sudo apt-get -y remove --purge   
sudo deborphan --guess-all # display them to user
sudo deborphan --guess-all | xargs sudo apt-get -y remove --purge   
# Clean out downloaded packages
sudo apt-get -y clean

# What's installed: look in file whats_installed.txt
for pkg in `dpkg --list | awk '/ii/ {print $2}'`; do echo -e "`dpkg --status $pkg | grep Installed-Size | awk '{print $2}'` \t\t $pkg" >> pkgs.tmp; done; sort -rg pkgs.tmp > ~/quickstart/whats_installed.txt; rm -f pkgs.tmp;
echo "------------  -------------------" >> ~/quickstart/whats_installed.txt
echo "size(kb)         packagename" >> ~/quickstart/whats_installed.txt

# Ending size
df -h -T > ~/quickstart/quickstart-size-slim.txt

# 3.0gb -> 2.2gb

# To "unslim" try this (untested, and written for 9.04):
#   sudo apt-get -y install ubuntu-desktop ubuntu-standard 
#   sudo apt-get -y install xserver-xorg-input-all xserver-xorg-video-all nvidia-common
#   sudo apt-get -y install ubuntu-restricted-extras
