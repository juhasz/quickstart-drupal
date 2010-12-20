#!/bin/bash

#assumes ubuntu user is quickstart

MYSQL_USER=root
MYSQL_PASS=quickstart
AEGIR_LOCAL_DOMAIN=aegir.dev
AEGIR_GIT_URL="http://git.aegirproject.org/?p=provision.git;a=blob_plain;f=install.sh.txt;hb=provision-0.4-beta1"

# replace quickstart's drush with Aegir's - DELETEME?
# sudo rm /usr/local/bin/drush
# sudo mv /home/quickstart/drush /home/quickstart/drush.replaced.by.aegir.version

# add repository for postfix and git-core - DELETEME?
# sudo add-apt-repository "deb http://archive.canonical.com/ lucid partner"
# sudo aptitude update

# ###################################################### BEGIN INSTALL.txt instructions
# This is taken from http://git.aegirproject.org/?p=provision.git;a=blob;f=docs/INSTALL.txt;h=7fd286f74fa719c6d6551081dc106cecd517a903;hb=299e9b83fdc653b1152e5394799bf99a5ff238c3
# some of these steps are already covered in quickstart's install.sh, but we can still run them here...

## DNS
echo "127.0.0.1 $AEGIR_LOCAL_DOMAIN" | sudo tee -a /etc/hosts > /dev/null

## Software (Postfix)
# Set install defaults for Postfix
echo postfix       postfix/main_mailer_type   text     Local only                             | sudo debconf-set-selections
echo postfix       postfix/mailname           text     postfix_default@$AEGIR_LOCAL_DOMAIN    | sudo debconf-set-selections

# install software: 
sudo apt-get install -y apache2 php5 php5-cli php5-mysql mysql-server postfix
sudo apt-get install -y sudo rsync git unzip

# make aegir user
sudo adduser --system --group --home /var/aegir aegir
sudo adduser aegir www-data      # make aegir a user of group www-data
sudo adduser aegir apache_tools  # allow aegir to restart apache
sudo adduser aegir ssl-cert      # allow aegir to see certs (when restarting apache)

## PHP - this is set in quickstart-3-lamp.sh, and won't work if changed manually.  
sudo sed -i 's/memory_limit = 64M/memory_limit = 192M/g'            /etc/php5/apache2/php.ini /etc/php5/cli/php.ini

## Apache
sudo a2enmod rewrite
sudo ln -s /var/aegir/config/apache.conf /etc/apache2/conf.d/aegir.conf

# allow aegir to restart apache - (redundant: aegir is already in group apache_tools)
echo 'aegir ALL=NOPASSWD: /usr/sbin/apache2ctl' | sudo tee -a /etc/sudoers > /dev/null

## MySQL
# no config

## Install Script

# install files
wget -O install.sh.txt "$AEGIR_GIT_URL"
sudo su -s /bin/sh aegir -c "sh install.sh.txt $AEGIR_LOCAL_DOMAIN"
#sudo /etc/init.d/apache2 restart

# ############################################# END INSTALL.txt instructions

# fix localhost readme file
#sudo cp /home/quickstart/Desktop/websites/config/apache-sites-enabled/000-default /var/aegir/config/vhost.d/

# make run as aegir shortcut
#rm install.sh.txt
#cat > ./aegir <<END
##!/bin/bash
#sudo su -s /bin/bash aegir
#END
#chmod 755 ./aegir
#sudo mv ./aegir /var/aegir/aegir 
#sudo ln -s /var/aegir/aegir /usr/local/bin/aegir

# make drush shortcut
#sudo chmod u+x /var/aegir/drush/drush
#sudo ln -s /var/aegir/drush/drush /usr/local/bin/drush

# show some install tips
cat > aegir_manual_config.txt <<END
In the browser window, aegir is completing the installation wizard.  Follow these steps:

1) Install hostmaster profile
2) mysqli, dbname: aegir, dbuser: aegir, password: quickstart
3) whatever you want
4) warnings? http://drupal.org/node/761498
5) ok, through database server screen
6) username: aegir_root, password: quickstart
7) Features? Yummy!
8) IMPORTANT: Initialize System step requires some commands to be manually run:
  
  #this command starts a new shell as the aegir user.  Wait for the lone $
  sudo su -s /bin/sh aegir
  cd /var/aegir/hostmaster-0.4-alpha7

  #answer yes to replace crontab.  If you don't get this question, something is wrong.
  php /var/aegir/drush/drush.php --uri=http://aegir.localhost hosting-setup
  exit
9) Back in firefox, view the status of Verify aegir.localhost.  
  If it's grey, check work in 8)
  If it's red, check other steps too :-)
  If it's green, you're good to go.
  Remember it's alpha, I got alot of warnings which had to do with PHP 5.3 compatibility...
END
#gedit aegir_manual_config.txt 
#rm aegir_manual_config.txt

# change files so www-data group (apache and quickstart) can edit
#sudo chown -R aegir:www-data /var/aegir

# start web installer
firefox http://$AEGIR_LOCAL_DOMAIN &

