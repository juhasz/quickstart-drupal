#!/bin/bash

DRUSH_VERSION="7.x-4.4"
DRUSH_MAKE_VERSION="6.x-2.2"

cd ~

# ################################################################################ Configure phpmyadmin

# show hex data on detail pages.
echo "
# Show 1000 rows instead of 30 by default
\$cfg['MaxRows'] = 1000;
# Show BLOB data as a string not hex.
\$cfg['DisplayBinaryAsHex'] = false;
# Show BLOB data in row detail pages.
\$cfg['ProtectBinary'] = false;
# Show BLOB data on table browse pages.  Hack to hardcode all requests.
\$_REQUEST['display_blob'] = true;
" | sudo tee -a /etc/phpmyadmin/config.inc.php

# never log me out!
echo "
/*
* Prevent timeout for a year at a time.
* (seconds * minutes * hours * days * weeks)
*/
\$cfg['LoginCookieValidity'] = 60*60*24*7*52;
ini_set('session.gc_maxlifetime', \$cfg['LoginCookieValidity']);
" | sudo tee -a /etc/phpmyadmin/config.inc.php


# ################################################################################ user management
# Make quickstart a user of group www-data
sudo adduser quickstart www-data    
# Make quickstart a user of group root to edit config files
sudo adduser quickstart root    


# ################################################################################ Drupal sites
# Create folder for websites to live in
mkdir ~/websites

echo "This is where Quickstart websites go.

Quickstart includes some command line scripts to automate site creation.

To create a site (dns, apache, code, database, and install):

  1) Start a terminal (top left icon, click the black box with a [>_] )

  2) Paste in this command (don't include the $)
    $ drush quickstart-create --domain=newsite.dev
         or 
    $ drush qc --domain=newsite.dev

To delete a site:
  $ drush quickstart-delete --domain=newsite.dev
         or 
  $ drush qd --domain=newsite.dev

For more information:
  $ drush help quickstart-create
  $ drush help quickstart-delete
  Or goto http://drupal.org/node/819398" > ~/websites/README.txt


# ################################################################################ Drush
# Install drush

git clone http://git.drupal.org/project/drush.git
cd ~/drush
git checkout $DRUSH_VERSION

chmod u+x ~/drush/drush
sudo ln -s ~/drush/drush /usr/local/bin/drush

# Install drush make and drush site-install6
mkdir ~/.drush
cd ~/.drush
git clone http://git.drupal.org/project/drush_make.git
cd drush_make
git checkout $DRUSH_MAKE_VERSION
cd ~

# Install drush quickstart
ln -s ~/quickstart/drush ~/.drush/quickstart
cp ~/quickstart/make_templates/*.make ~/websites

# ################################################################################ Replace localhost/index.html
# Add interesting default document for localhost
sudo rm /var/www/index.html
sudo chmod 777 /var/www
cp ~/quickstart/config/index.php /var/www/index.php
sudo chmod 755 /var/www/index.php


# ################################################################################ Command line shortcuts (bash aliases)

# Don't sudo here...
cat > ~/.bash_aliases <<END
#   svn_add_all [folder]            - recursive add folders unversioned files (espects svn:ignore and spaces in filenames)
#   svn_rid_all [folder]            - recursive svn-deletes missing files (deleted by user, but not svn-deleted)
#   svn_revert_all [folder]         - recursive revert any change in folder
#   svn_ignore [folder] [pattern]   - add pattern to folders svn:ignore property.  Use 's around wildcards.  E.g. '*' or '.*'
#   svn_ignore_edit [folder]        - edit svn:ignore property
svn_add_all    () { svn status "\$1" | grep '^?' | cut -b 8- | xargs -I {} svn add "{}"; }
svn_trim_all   () { svn status "\$1" | grep '^!' | cut -b 8- | xargs -I {} svn rm "{}"; }
svn_revert_all () { svn revert "\$1" -R; }
svn_ignore     () { svn_prop_add ignore "\$1" "\$2"; }
svn_external   () { svn_prop_add external "\$1" "\$2"; }
svn_prop_add   () { FILE="\$RANDOM.svnprop"; svn propget svn:"\$1" "\$2" > \$FILE; echo "\$3" >> \$FILE;	
			sed -i '/^\$/d' \$FILE; # remove blank lines
			svn propset svn:"\$1" "\$2" -F $FILE; rm $FILE; }
svn_prop_edit  () { svn pe svn:"\$2" "\$1"; }
svn_svn_purge  () { find \$1 -type d -name .svn -exec rm -rf {} \; ; }
svn_update     () { svn update \$@ --ignore-externals; }
svn_commit     () { svn commit \$@; }

# dereference links in current path.
deref () { cd \$(pwd -P); }

# color ls's
alias vdir='vdir --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# search in files and directories
search () { grep -rHinC0 "\$*" .; }

# throw windows users a bone
alias dir='dir --color=auto'
alias copy='cp'
alias del='rm'
END


# ################################################################################ Desktop shortcuts

cat > ~/Desktop/README.desktop <<END
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Link
URL=http://localhost
Name=README
Icon=/usr/share/pixmaps/firefox.png
END

cat > ~/Desktop/gnome-terminal.desktop <<END
#!/usr/bin/env xdg-open
[Desktop Entry]
Name=Terminal
Comment=Use the command line
TryExec=gnome-terminal
Exec=gnome-terminal
Icon=utilities-terminal
Type=Application
X-GNOME-DocPath=gnome-terminal/index.html
X-GNOME-Bugzilla-Bugzilla=GNOME
X-GNOME-Bugzilla-Product=gnome-terminal
X-GNOME-Bugzilla-Component=BugBuddyBugs
X-GNOME-Bugzilla-Version=2.29.6
Categories=GNOME;GTK;Utility;TerminalEmulator;
StartupNotify=true
OnlyShowIn=GNOME;
X-Ubuntu-Gettext-Domain=gnome-terminal
END
chmod 755 ~/Desktop/gnome-terminal.desktop

ln -s ~/websites ~/Desktop/websites
ln -s /mnt/vbox-shared ~/Desktop/vbox-shared



# ################################################################################ Email catcher

# Configure email collector
mkdir /home/quickstart/websites/logs/mail
chmod -R 777 /home/quickstart/websites/logs/mail
sudo sed -i 's/;sendmail_path =/sendmail_path=\/home\/quickstart\/quickstart\/config\/sendmail.php/g' /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
chmod +x /home/quickstart/quickstart/config/sendmail.php 



# ################################################################################ XDebug Debugger/Profiler

# Configure xdebug - installed 2.1 from apt
mkdir /home/quickstart/websites/logs/profiler
echo "
xdebug.remote_enable=on
xdebug.remote_handler=dbgp
xdebug.remote_host=localhost
xdebug.remote_port=9000
xdebug.profiler_enable=0
xdebug.profiler_enable_trigger=1
xdebug.profiler_output_dir=/home/quickstart/websites/logs/profiler
" | sudo tee -a /etc/php5/conf.d/xdebug.ini > /dev/null


# ################################################################################ Install a web-based profile viewer
cd ~/websites/logs/profiler

wget -nv -O webgrind.zip http://webgrind.googlecode.com/files/webgrind-release-1.0.zip
unzip webgrind.zip
rm webgrind.zip

# Setup Web server
echo "127.0.0.1 webgrind

" | sudo tee -a /etc/hosts > /dev/null

echo "Alias /profiler /home/quickstart/websites/logs/profiler/webgrind

<Directory /home/quickstart/websites/logs/profiler/webgrind>
  Allow from All
</Directory>
" | sudo tee /etc/apache2/conf.d/webgrind > /dev/null

chmod -R 777 /home/quickstart/websites/logs/profiler


# ################################################################################ XHProf profiler (Devel Module)
# Adapted from: http://techportal.ibuildings.com/2009/12/01/profiling-with-xhprof/

# supporting packages
sudo apt-get -yq install graphviz

# get it
cd ~
wget -nv http://pecl.php.net/get/xhprof-0.9.2.tgz
tar xvf xhprof-0.9.2.tgz
mv xhprof-0.9.2 /home/quickstart/websites/logs/xhprof
rm xhprof-0.9.2.tgz
rm package.xml

# build and install it
cd /home/quickstart/websites/logs/xhprof/extension/
phpize
./configure
make
sudo make install

# configure php
echo "
[xhprof]
extension=xhprof.so
xhprof.output_dir=\"/home/quickstart/websites/logs/xhprof\"
" | sudo tee /etc/php5/conf.d/xhprof.ini > /dev/null
 
# configure apache
echo "Alias /xhprof /home/quickstart/websites/logs/xhprof/xhprof_html

<Directory /home/quickstart/websites/logs/profiler/xhprof/xhprof_html>
  Allow from All
</Directory>
" | sudo tee /etc/apache2/conf.d/xhprof > /dev/null

chmod -R 777 /home/quickstart/websites/logs/xhprof


# ################################################################################ Restart apache
sudo apache2ctl restart


# ################################################################################ Squid caching of ftp.drupal.org

cd ~
sudo apt-get update

# Install caching proxy server
sudo apt-get -y install squid3

echo "http_proxy=\"http://localhost:3128\"" | sudo tee -a /etc/environment > /dev/null

echo "
# fix for git 417 errors
ignore_expect_100 on

# Quickstart
acl drushservers dstdomain ftp.drupal.org
cache allow drushservers
cache deny all

# don't wait to finish requests before shutting down.  Do it now!
shutdown_lifetime 0 seconds 
" | sudo tee -a /etc/squid3/squid.conf

echo "*** REBOOT TO TAKE EFFECT ***"

