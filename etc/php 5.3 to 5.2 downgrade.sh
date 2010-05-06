#!/bin/bash

# Quickstart comes with php 5.2, so this script isn't necessary...

# Posted in: http://community.livejournal.com/ru_ubuntu/433187.html
# by Ruben Barkow (rubo77) http://www.entikey.z11.de/

# Originally Posted by Bachstelze http://ubuntuforums.org/showthread.php?p=9080474#post9080474
# OK, here's how to do the Apt magic to get PHP packages from the karmic repositories:

if [ "$(whoami &2>/dev/null)" != "root" ] && [ "$(id -un &2>/dev/null)" != "root" ] ; then
echo " You must be root to run this script.

Run: sudo bash $0
"
exit 1
fi
echo " OK";


# finish all apt-problems:
apt-get -f install

# remove all your existing PHP packages. You can list them with dpkg -l| grep php
PHPLIST=$(for i in $(dpkg -l | grep php|awk '{ print $2 }' ); do echo $i; done)
echo === These packages will be removed: $PHPLIST
aptitude remove --purge $PHPLIST

#Create a file each in /etc/apt/preferences.d like this (call it for example /etc/apt/preferences.d/php5.2);
#
#Package: php5
#Pin: release a=karmic
#Pin-Priority: 991
#
#The big problem is that wildcards don't work, so you will need one such stanza for each PHP package you want to pull from karmic:

echo ''>/etc/apt/preferences.d/php5.2
for i in $PHPLIST ; do echo "Package: $i
Pin: release a=karmic
Pin-Priority: 991
">>/etc/apt/preferences.d/php5.2; done

# duplicate your existing sources.list replacing lucid with karmic and save it in sources.list.d:
#sed s/lucid/karmic/g /etc/apt/sources.list | sudo tee /etc/apt/sources.list.d/karmic.list

# better exactly only the needed sources, cause otherwise you can get a cachsize problem:
echo "# needed sources vor php5.2:
deb http://de.archive.ubuntu.com/ubuntu/ karmic main restricted
deb-src http://de.archive.ubuntu.com/ubuntu/ karmic main restricted

deb http://de.archive.ubuntu.com/ubuntu/ karmic-updates main restricted
deb-src http://de.archive.ubuntu.com/ubuntu/ karmic-updates main restricted

deb http://de.archive.ubuntu.com/ubuntu/ karmic universe
deb-src http://de.archive.ubuntu.com/ubuntu/ karmic universe
deb http://de.archive.ubuntu.com/ubuntu/ karmic-updates universe
deb-src http://de.archive.ubuntu.com/ubuntu/ karmic-updates universe

deb http://de.archive.ubuntu.com/ubuntu/ karmic multiverse
deb-src http://de.archive.ubuntu.com/ubuntu/ karmic multiverse
deb http://de.archive.ubuntu.com/ubuntu/ karmic-updates multiverse
deb-src http://de.archive.ubuntu.com/ubuntu/ karmic-updates multiverse

deb http://security.ubuntu.com/ubuntu karmic-security main restricted
deb-src http://security.ubuntu.com/ubuntu karmic-security main restricted
deb http://security.ubuntu.com/ubuntu karmic-security universe
deb-src http://security.ubuntu.com/ubuntu karmic-security universe
deb http://security.ubuntu.com/ubuntu karmic-security multiverse
deb-src http://security.ubuntu.com/ubuntu karmic-security multiverse
" >> /etc/apt/sources.list.d/karmic.list

aptitude update

apache2ctl restart

echo install new from karmic:
aptitude -t karmic install $PHPLIST

# at the end retry the modul libapache2-mod-php5 in case it didn't work the first time:
aptitude -t karmic install libapache2-mod-php5

apache2ctl restart

