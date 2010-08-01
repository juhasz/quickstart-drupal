#!/bin/bash

cd ~

# Make quickstart a user of group www-data
sudo adduser quickstart www-data    

# ################################################################################ Basic Tools

# Configure repositories for git-core, etc - cruft?
# sudo add-apt-repository "deb http://archive.canonical.com/ubuntu/ lucid partner" 
# sudo apt-get update

# Install some dev basics
sudo apt-get -y install cvs subversion git-core bzr
sudo apt-get -y install wget curl


# ################################################################################ Drupal sites

# Create folder for websites to live in
mkdir ~/websites

echo "This is where Quickstart websites go.

Quickstart include some commandline scripts to automate site installation.

To create a site (dns, apache, code, database, and install):
This will do all the downloads and configurations

  1) Start a terminal (top left, click the black box with a >)

  2) Paste in this command (don't include the $)
    $ drush quickstart-create all --domain=newsite.dev
         or 
    $ drush qc all --domain=newsite.dev

To delete a site:
  $ drush quickstart-delete all --domain=newsite.dev
         or 
  $ drush qd all --domain=newsite.dev

For more information:
  $ drush help quickstart-create
  $ drush help quickstart-delete
  Or goto http://drupal.org/node/819398" > ~/websites/readme.txt


# ################################################################################ Drush
# Install drush
DRUSH_FILE='drush-All-versions-3.0.tar.gz'
wget http://ftp.drupal.org/files/projects/$DRUSH_FILE
tar -xzf $DRUSH_FILE
chmod u+x ~/drush/drush
sudo ln -s ~/drush/drush /usr/local/bin/drush
rm $DRUSH_FILE

# Install drush make
mkdir ~/.drush
drush dl drush_make --destination=/home/quickstart/.drush
# git clone git://git.aegirproject.org/provision ~/.drush/provision

# Install drush quickstart
ln -s ~/quickstart/drush ~/.drush/quickstart
drush quickstart-setup

# ################################################################################ Replace localhost/index.html

# Add interesting default document for localhost
sudo rm /var/www/index.html
sudo chmod 777 /var/www
cat > /var/www/index.php <<END
<html><body>
  <h1>Drupaldev Quickstart:</h1>
    <ul>
      <li><a href='http://localhost/phpmyadmin'>phpmyadmin</a> database editor</li>
      <li><a href='http://drupal.org/node/788080'>Quickstart documentation</li>
      <li><a href='http://drupal.org/node/477684'>Drush</a> command line reference</li>
      <li><a href='http://drupalmodules.com/'>DrupalModules.com</a> and <a href='http://drupal.org/project/usage'>Module Usage Statistics</a></li>
      <li><a href='http://drupal.org/project/issues?projects=3060&states=8,13,14'>Drupal Patch Queue</a> and <a href='http://drupal.org/patch/review'>Patch reviewing tips</a></li>
      <li>Configuring <a href='http://wiki.netbeans.org/HowToConfigureXDebug'>xdebug and netbeans</a></li>
      <li><a href='http://localhost:8080/solr/admin/'>Apache Solr Admin</a></li>
    </ul>
  <h1>Current phpinfo():</h1>
  <?php phpinfo(); ?>
</body></html>
END
sudo chmod 755 /var/www


# ################################################################################ Command line shortcuts (bash aliases)

# Don't sudo here...
cat > .bash_aliases <<END
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


# ################################################################################ Shared folder

# Setup shared folders between virtualbox host and virtualbox guest
# Note difference between shared and vbox-shared.  That's important.  Requires reboot
sudo sed -i 's/# By default this script does nothing./mount -t vboxsf -o uid=1000,gid=1000 shared \/mnt\/vbox-shared/g'     /etc/rc.local
sudo mkdir /mnt/vbox-shared
sudo chmod 777 /mnt/vbox-shared
cat > /mnt/vbox-shared/readme.txt <<END
If you are seeing this file, then virtualbox's shared folders are not configured correctly.

1) Power down the Quickstart virtual machine.
2) On the host computer, start the Virtualbox management UI.
3) right-click Quickstart -> settings -> shared folders -> click the folder with the green plus on the right
4) Set the "Folder Path" to a path on the host computer.  Give full read/write access.
5) Set the "Folder Name" to "shared".  no caps.  no vbox-
6) Ok -> Ok -> start Quickstart vm and this file should disappear.  
7) Test by moving a file in the host computer into the host shared folder.
END
zenity --info --text="For shared folders to work, they must be configured in host OS, and guest OS rebooted."


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

# ################################################################################ Log Files

LOGS=~/websites/logs
mkdir $LOGS

# Apache error logs are configured in the VirtualHosts section of each website (default from apache2.conf)
sudo touch     /var/log/apache2/error.log
sudo chmod g+w /var/log/apache2/error.log
ln -s          /var/log/apache2/error.log                $LOGS/apache-error.log
# This file catches any unconfigured log info for virtualhosts (default from apache2.conf)
sudo touch     /var/log/apache2/other_vhosts_access.log
sudo chmod g+w /var/log/apache2/other_vhosts_access.log
ln -s          /var/log/apache2/other_vhosts_access.log  $LOGS/apache-access.log
# php error logs are configured in php.ini  (changed in install-3-lamp.sh)
sudo touch     /var/log/php-error.log
sudo chmod g+w /var/log/php-error.log
ln -s          /var/log/php-error.log                    $LOGS/php-error.log
# MySQL error and slow query logs (changed in install-2-lamp.sh)
sudo touch     /var/log/mysql/error.log
sudo chmod g+w /var/log/mysql/error.log
ln -s          /var/log/mysql/error.log                  $LOGS/mysql-error.log
sudo touch     /var/log/mysql/mysql-slow.log
sudo chmod g+w /var/log/mysql/mysql-slow.log
ln -s          /var/log/mysql/mysql-slow.log             $LOGS/mysql-slow.log


# ################################################################################ Config Files

# Make quickstart a user of group root to edit config files
sudo adduser quickstart root    
CONFIGS=~/websites/config
mkdir $CONFIGS
sudo chmod -R g+w /etc/apache2
ln -s /etc/apache2/apache2.conf      $CONFIGS/apache2.conf
ln -s /etc/apache2/httpd.conf        $CONFIGS/httpd.conf
ln -s /etc/apache2/ports.conf        $CONFIGS/ports.conf
ln -s /etc/apache2/sites-enabled/    $CONFIGS/apache-sites-enabled
sudo chmod -R g+w /etc/php5
ln -s /etc/php5/apache2/php.ini      $CONFIGS/php-apache.ini
ln -s /etc/php5/cli/php.ini          $CONFIGS/php-cli.ini
sudo chmod -R g+w /etc/mysql
ln -s /etc/mysql/my.cnf              $CONFIGS/mysql.cnf
sudo chmod g+w /etc/hosts
ln -s /etc/hosts                     $CONFIGS/hosts

cd ~
df -h -T > ~/quickstart/quickstart-size-end.txt


# ################################################################################ Email catcher

# Configure email collector
mkdir /home/quickstart/websites/logs/mail
chmod 666 /home/quickstart/websites/logs/mail
chmod +x /home/quickstart/quickstart/sendmail.php
sudo sed -i 's/;sendmail_path =/sendmail_path=\/home\/quickstart\/quickstart\/sendmail.php/g' /etc/php5/apache2/php.ini /etc/php5/cli/php.ini


# ################################################################################ Debugger, Profiler, and webgrind

# Get xdebug 2.1
cd ~
mkdir temp
cd temp
wget http://www.xdebug.com/files/xdebug-2.1.0.tgz
tar -xvzf xdebug-2.1.0.tgz
cd xdebug-2.1.0
phpize5
./configure
make
sudo cp modules/xdebug.so /usr/lib/php5/20090626+lfs/
cd ..
rm -rf temp

# Configure xdebug
mkdir /home/quickstart/websites/logs/profiler
echo "xdebug.remote_enable=on
xdebug.remote_handler=dbgp
xdebug.remote_host=localhost
xdebug.remote_port=9000
xdebug.profiler_enable=0
xdebug.profiler_enable_trigger=1
xdebug.profiler_output_dir=/home/quickstart/websites/logs/profiler
" | sudo tee /etc/php5/conf.d/xdebug.ini > /dev/null


# Install a web-based profile viewer
cd ~/quickstart/websites/logs/profiler

wget -O webgrind.zip http://webgrind.googlecode.com/files/webgrind-release-1.0.zip
unzip webgrind.zip
mv webgrind/* .
rmdir webgrind
rm webgrind.zip

# Setup Web server
echo "127.0.0.1 webgrind" | sudo tee -a /etc/hosts
echo "<VirtualHost *:80>
	DocumentRoot /home/quickstart/websites/logs/profiler/
	<Directory /home/quickstart/websites/logs/profiler/>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
		Order allow,deny
		allow from all
	</Directory>
</VirtualHost>" | sudo tee /etc/apache2/sites-enabled/000-default


# ################################################################################ Restart apache
echo "quickstart ALL=NOPASSWD: /usr/sbin/apache2ctl" | sudo tee -a /etc/sudoers > /dev/null
sudo apache2ctl restart


# ################################################################################ Make example.dev
cd ~/websites
drush quickstart-create all --domain=example.dev

