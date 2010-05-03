#!/bin/bash

# see also http://benhodge.wordpress.com/2008/02/17/cleaning-up-a-ubuntu-gnulinux-system/

echo "*** Run as root ***"

#Starting size:
df -h -T > size_start.txt
aptitude update   		# update my database of newest packages
aptitude -y install localepurge # package to delete unnecessary translations.  Select en and en_us packages to keep them.
aptitude -y install deborphan # package to find orphan packages
# 329mb - Open office
aptitude remove --purge openoffice.org-core openoffice.org-common openoffice.org-writer openoffice.org-calc openoffice.org-math openoffice.org-impress openoffice.org-base-core openoffice.org-draw openoffice.org-emailmerge   openoffice.org-gnome openoffice.org-gtk openoffice.org-help-en-gb openoffice.org-help-en-us openoffice.org-l10n-en-gb openoffice.org-l10n-en-za openoffice.org-style-human openoffice.org-thesaurus-en-au python-uno language-support-writing-en openoffice.org-thesaurus-en-us openoffice.org-hyphenation openoffice.org-hyphenation-en-us openoffice.org-l10n-common language-support-translations-en language-support-en thunderbird-locale-en-gb uno-libs3 ure
#  47mb - games
aptitude remove --purge gnome-games gnome-games-data libggz2 libggzcore9 libggzmod4 ggzcore-bin
#  17mb - accessability
aptitude remove --purge gnome-orca gnome-mag brltty brltty-x11 onboard                                           
#  10mb - screen savers
aptitude remove --purge xscreensaver-data xscreensaver-gl screensaver-default-images gnome-screensaver ubuntu-desktop
#  11mb - cd creator
aptitude remove --purge brasero wodim libbrasero-media0 cdparanoia                   
#  28mb - help files
aptitude remove --purge gimp-help-common gimp-help-en                                
#  68mb - user guide
aptitude remove --purge gnome-user-guide gnome-user-guide-en ubuntu-docs             
#   9mb - user guide
aptitude remove --purge man-db manpages yelp info evolution-documentation-en ubuntu-standard 
#   4mb - bluetooth
aptitude remove --purge bluez-gnome bluez bluetooth bluez-utils bluez-alsa bluez-gstreamer bluez-cups libmbca0 
#  16mb - skype clone
aptitude remove --purge espeak ekiga                                                 
#  55mb - email
aptitude remove --purge evolution evolution-common evolution-data-server evolution-exchange evolution-indicator evolution-plugins evolution-webcal
#  10mb - spam filter
aptitude remove --purge bogofilter bogofilter-bdb bogofilter-common                  
#   5mb - palm pilot
aptitude remove --purge gnome-pilot gnome-pilot-conduits  libpisock9 libpisync1 libgnome-pilot2                           
#  14mb - video player
aptitude remove --purge totem totem-mozilla totem-common totem-gstreamer totem-plugins 
#  76mb - printing
aptitude remove --purge cups cups-bsd cups-client cups-common cupsddk cupsddk-drivers foo2zjs foomatic-db foomatic-db-engine foomatic-filters ghostscript ghostscript-x groff-base  cups-driver-gutenprint hal-cups-utils hplip hpijs foomatic-db-hpijs openprinting-ppds pnm2ppa pxljr splix hplip-data system-config-printer-common system-config-printer-gnome python-cups min12xxw  
#   5mb - scanner drivers
aptitude remove --purge xsane sane-utils xsane-common                                
#  .5mb - understand raw camera images
aptitude remove --purge dcraw                                                        
#  30mb - mono .net layer
aptitude remove --purge mono-runtime f-spot libgconf2.24-cil libmono-addins0.2-cil libmono2.0-cil mono-2.0-gac tomboy libgnome2.24-cil libmono-addins-gui0.2-cil libmono-system-web2.0-cil mono-2.0-runtime mono-gac libflickrnet2.1.5-cil libgnomepanel2.24-cil 
#  26mb - Fancy GUI Compiz
aptitude remove --purge compiz compiz-core compiz-gnome compiz-plugins compiz-wrapper compiz-fusion-plugins-extra compiz-fusion-plugins-main compizconfig-backend-gconf libcompizconfig0 libdecoration0 
#  11mb - example videos and stuff
aptitude remove --purge example-content                                              
#  13mb - pgp GUI - keep for communicating with hosting companies silly!
#aptitude remove --purge seahorse seahorse-plugins                                   
#  15mb - Audio player
aptitude remove --purge rhythmbox                                                    
#   4mb - Video drivers
aptitude remove --purge nvidia-common rss-glx                                        
#   3mb - Math app - linear programming
aptitude remove --purge libgsl0ldbl lp-solve                                         
#  93mb - Headers for Programming linux - need these for VBox Extensions
#aptitude remove --purge linux-headers-2.6.28-11 linux-headers-2.6.28-11-generic linux-headers-generic linux-libc-dev libc6-dev 
#  30mb - bittorrent client
aptitude remove --purge transmission-common transmission-gtk                         
#  31mb - Instant Messaging 
aptitude remove --purge pidgin pidgin-data  libpurple0 pidgin-otr pidgin-libnotify nautilus-sendto 
#  39mb - OpenGL
aptitude remove --purge mesa-utils libglu1-mesa libgl1-mesa-dri libgl1-mesa-glx libvisual-0.4-plugins x11-utils xorg libglew1.5 libglitz-glx1 
#  46mb - Graphics editing.  would be nice to keep.
aptitude remove --purge gimp gimp-help-en gimp-data gimp-help-common 
#  12mb - Laptop stuff
aptitude remove --purge gnome-power-manager wireless-tools libiw29 
#  11mb - Desktop theming
aptitude remove --purge tangerine-icon-theme gnome-accessibility-themes gnome-themes-selected usplash-theme-ubuntu gnome-themes-ubuntu ubuntu-sounds gnome-cards-data 
#  60mb - Asian fonts
aptitude remove --purge ttf-arphic-uming ttf-indic-fonts-core ttf-lao ttf-sazanami-gothic ttf-sazanami-mincho ttf-thai-tlwg ttf-unfonts-core # Thai/korean/chinese/indian/lao fonts
#   9mb - Video Drivers
aptitude remove --purge xserver-xorg-video-all xserver-xorg-video-apm xserver-xorg-video-ark xserver-xorg-video-ati xserver-xorg-video-chips xserver-xorg-video-cirrus xserver-xorg-video-geode xserver-xorg-video-i128 xserver-xorg-video-i740 xserver-xorg-video-intel xserver-xorg-video-mach64 xserver-xorg-video-mga xserver-xorg-video-neomagic xserver-xorg-video-nv xserver-xorg-video-openchrome xserver-xorg-video-r128 xserver-xorg-video-radeon xserver-xorg-video-rendition xserver-xorg-video-s3 xserver-xorg-video-s3virge xserver-xorg-video-savage xserver-xorg-video-siliconmotion xserver-xorg-video-sis xserver-xorg-video-sisusb xserver-xorg-video-tdfx xserver-xorg-video-trident xserver-xorg-video-tseng xserver-xorg-video-v4l xserver-xorg-video-vmware xserver-xorg-video-voodoo #video drivers
#   4mb - VNC
aptitude remove --purge vinagre libgtk-vnc-1.0-0
#   4mb - Doc utils
aptitude remove --purge gnome-doc-utils

aptitude remove --purge libgpod-common #ipod .4mb
aptitude remove --purge xserver-xorg-input-all xserver-xorg-input-synaptics xserver-xorg-input-wacom #touchpad .5mb
aptitude remove --purge nvidia-96-modaliases nvidia-71-modaliases nvidia-180-modaliases nvidia-173-modaliases # graphics card detection .3mb
aptitude remove --purge eog #graphic viewer

# multi-media
aptitude remove --purge gstreamer0.10-plugins-good gstreamer0.10-alsa gstreamer0.10-x gnome-media #4mb
aptitude remove --purge libpt2.6.1 libpt2.6.1-plugins-alsa libpt2.6.1-plugins-v4l2 libv4l-0 libopal3.6.1 #video4linux stuff 4mb
aptitude remove --purge gstreamer0.10-schroedinger libschroedinger-1.0-0 #video codec .5mb
aptitude remove --purge libiec61883-0 #codec stuff .1mb
aptitude remove --purge libavc1394-0 libraw1394-8 #firewire driver .2mb

#pulse audio 
aptitude remove --purge libpulsecore9 libshout3 pulseaudio pulseaudio-esound-compat pulseaudio-module-gconf pulseaudio-module-hal  pulseaudio-module-x11 libspeex1 libspeexdsp1 #audio codec
aptitude remove --purge tsclient libasound2-plugins rdesktop libsamplerate0 #audio rate conversion  3mb
aptitude remove --purge libwavpack1 # audio codec
aptitude remove --purge alsa-base alsa-utils esound-clients libespeak1 espeak-data libpulse-browse0 linux-sound-base pulseaudio-utils libgnome-speech7 #more audio
aptitude remove --purge libvisual-0.4-0  gstreamer0.10-plugins-base # audio playback visualization 2mb
aptitude remove --purge libtag1c2a #mp3 tags .5mb

# finish up
aptitude clean # clean up aptitude files
aptitude -y safe-upgrade  # upgrade whats left
# 104mb - Remove orphan packages - do a couple times
deborphan	--guess-all # display them to user
deborphan --guess-all | xargs sudo apt-get -y remove --purge   
deborphan	--guess-all # display them to user
deborphan --guess-all | xargs sudo apt-get -y remove --purge   
deborphan	--guess-all # display them to user
deborphan --guess-all | xargs sudo apt-get -y remove --purge   
deborphan	--guess-all # display them to user
deborphan --guess-all | xargs sudo apt-get -y remove --purge   

#What's installed: look in file whats_installed.txt
for pkg in `dpkg --list | awk '/ii/ {print $2}'`; do echo -e "`dpkg --status $pkg | grep Installed-Size | awk '{print $2}'` \t\t $pkg" >> pkgs.tmp; done; sort -rg pkgs.tmp > whats_installed.txt; rm -f pkgs.tmp;

# clean out downloaded packages
aptitude clean

# clean up apt cache
rm /var/lib/apt/lists/*   # 44mb -> 12mb compressed

#Ending size
df -h -T > size_end.txt

#2.2gb -> 1.1gb

# to put it all back (not thoroughly checked):
#aptitude install ubuntu-desktop ubuntu-standard 
# re-add drivers
#aptitude install xserver-xorg-input-all xserver-xorg-video-all nvidia-common
# to add a little more:
#aptitude install ubuntu-restricted-extras
