#!/bin/bash

cd ~

# ################################################################################ Drupal sites and Drush

#create folder for websites to live in
mkdir ~/websites

# install drush
DRUSH_FILE='drush-All-versions-3.0.tar.gz'
wget http://ftp.drupal.org/files/projects/$DRUSH_FILE
tar -xzf $DRUSH_FILE
chmod u+x ~/drush/drush
sudo ln -s ~/drush/drush /usr/local/bin/drush
rm $DRUSH_FILE

# ################################################################################ Replace localhost/index.html

# add interesting default document for localhost:
sudo rm /var/www/index.html
sudo chmod 777 /var/www
cat > /var/www/index.php <<END
<html><body>
  <h1>Drupaldev Quickstart:</h1>
  <table><tr>
    <td>
      <p>Helpful Links:</p>
      <ul>
        <li><a href='http://localhost/phpmyadmin'>phpmyadmin</a> database editor</li>
        <li><a href='http://drupal.org/node/788080'>Quickstart documentation</li>
        <li><a href='http://drupal.org/node/477684'>Drush</a> command line reference</li>
        <li><a href='http://drupalmodules.com/'>DrupalModules.com</a> and <a href='http://drupal.org/project/usage'>Module Usage Statistics</a></li>
        <li><a href='http://drupal.org/project/issues?projects=3060&states=8,13,14'>Drupal Patch Queue</a> and <a href='http://drupal.org/patch/review'>Patch reviewing tips</a></li>
        <li>Configuring <a href='http://wiki.netbeans.org/HowToConfigureXDebug'>xdebug and netbeans</a></li>
      </ul>
    </td><td>
      <p>Verify phpinfo() below:</p>
      <ul>
        <li>xdebug, apc are On</li>
        <li>magic_quotes_gpc, short_open_tag are Off</li>
        <li>max_execution_time = 300s</li>
        <li>memory_limit is 64m</li>
      </ul>
    </td>
  </tr></table>
  <h1>Current phpinfo():</h1>
  <?php phpinfo(); ?>
</body></html>
END
sudo chmod 755 /var/www

# ################################################################################ Command line shortcuts (bash aliases)

#don't sudo...
cat >> .bash_profile <<END
#   svn_add_all [folder]            - recursive add folders unversioned files (espects svn:ignore and spaces in filenames)
#   svn_rid_all [folder]            - recursive svn-deletes missing files (deleted by user, but not svn-deleted)
#   svn_revert_all [folder]         - recursive revert any change in folder
#   svn_ignore [folder] [pattern]   - add pattern to folders svn:ignore property.  Use 's around wildcards.  E.g. '*' or '.*'
#   svn_ignore_edit [folder]        - edit svn:ignore property
svn_add_all    () { svn status "$1" | grep '^?' | cut -b 8- | xargs -I {} svn add "{}"; }
svn_trim_all   () { svn status "$1" | grep '^!' | cut -b 8- | xargs -I {} svn rm "{}"; }
svn_revert_all () { svn revert "$1" -R; }
svn_ignore     () { svn_prop_add ignore "$1" "$2"; }
svn_external   () { svn_prop_add external "$1" "$2"; }
svn_prop_add   () { FILE="$RANDOM.svnprop"; svn propget svn:"$1" "$2" > $FILE; echo "$3" >> $FILE;	
			sed -i '/^$/d' $FILE; # remove blank lines
			svn propset svn:"$1" "$2" -F $FILE; rm $FILE; }
svn_prop_edit  () { svn pe svn:"$2" "$1"; }
svn_svn_purge  () { find $1 -type d -name .svn -exec rm -rf {} \; ; }
svn_update     () { svn update $@ --ignore-externals; }
svn_commit     () { svn commit $@; }

# dereference links in current path.
deref () { cd $(pwd -P); }

# color ls's
alias vdir='vdir --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# throw window users a bone
alias dir='dir --color=auto'
alias copy='cp'
alias del='rm'
END

# ################################################################################ Shared folder

# setup shared folders between virtualbox host and virtualbox guest
# don't use .bash_rc, mount happens every time bash is run.
#  sudo mount -t vboxfs shared /mnt/shared
# don't use fstab, error happens during boot.
#  echo "shared /mnt/shared vboxsf uid=1000,gid=1000" | sudo tee -a /etc/fstab > /dev/null
# Can't use simple sudo because >> doesn't get sudo'd.
sudo mkdir /mnt/shared
sudo sed -i 's/# By default this script does nothing./mount.vboxsf -w shared /mnt/shared/g'     /etc/fstab
# reboot for effect

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
ln -s /mnt/shared ~/Desktop/shared
#ln -s ~/quickstart/scripts ~/Desktop/scripts

# ################################################################################ Log Files

LOGS=~/websites/logs
mkdir $LOGS

# Apache error logs are configured in the VirtualHosts section of each website (defaults from apache2.conf)
sudo touch /var/log/apache-error.log
ln -s /var/log/apache2/error.log                $LOGS/apache-error.log
# this file catches any unconfigured log info for virtualhosts
sudo touch /var/log/apache2/other_vhosts_access.log
ln -s /var/log/apache2/other_vhosts_access.log  $LOGS/apache-access.log
# php error logs are configured in php.ini  (changed in install-2-lamp.sh)
sudo touch /var/log/php-error.log
ln -s /var/log/php-error.log                    $LOGS/php-error.log
# MySQL error and slow query logs (changed in install-2-lamp.sh)
sudo touch /var/log/mysql/error.log
ln -s /var/log/mysql/error.log                  $LOGS/mysql-error.log
sudo touch /var/log/mysql/mysql-slow.log        $LOGS/mysql-slow.log


# ################################################################################ Config Files

CONFIGS=~/websites/config
mkdir $CONFIGS
ln -s /etc/apache2/apache2.conf      $CONFIGS/apache2.conf
ln -s /etc/apache2/apache2.conf      $CONFIGS/httpd.conf
ln -s /etc/apache2/apache2.conf      $CONFIGS/ports.conf
ln -s /etc/php5/apache2/php.ini      $CONFIGS/php-apache.ini
ln -s /etc/php5/cli/php.ini          $CONFIGS/php-cli.ini
ln -s /etc/mysql/my.cnf              $CONFIGS/mysql.cnf
ln -s /etc/hosts                     $CONFIGS/hosts
ln -s /etc/apache2/sites-enabled/    $CONFIGS/apache-sites-enabled

