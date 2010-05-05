#!/bin/bash

#assumes ubuntu user is quickstart

MYSQL_USER=root
MYSQL_PASS=quickstart
AEGIR_LOCAL_DOMAIN=aegir.localhost
AEGIR_GIT_URL="http://git.aegirproject.org/?p=provision.git;a=blob_plain;f=install.sh.txt;hb=provision-0.4-alpha7"

# replace quickstart's drush with Aegir's
sudo rm /usr/local/bin/drush
sudo mv /home/quickstart/drush /home/quickstart/drush.replaced.by.aegir.version

# add repository for postfix and git-core
sudo add-apt-repository "deb http://archive.canonical.com/ lucid partner"
sudo aptitude update

# ###################################################### BEGIN INSTALL.txt instructions
# This is taken from http://git.aegirproject.org/?p=provision.git;a=blob_plain;f=INSTALL.txt;hb=b602a8b520c590a2826cc0a35fde52180a14e952
# some of these steps are already covered in quickstart's install.sh, but we can still run them here...

zenity --info --text="Local only = no email out.  Internet = depends on config."

# install software: 
sudo apt-get install -y apache2 php5 php5-cli php5-mysql mysql-server postfix
sudo apt-get install -y sudo git-core unzip

# make aegir user
sudo adduser --system --group --home /var/aegir aegir
sudo adduser aegir www-data    #make aegir a user of group www-data

# configure apache
sudo a2enmod rewrite
sudo ln -s /var/aegir/config/apache.conf /etc/apache2/conf.d/aegir.conf

# allow aegir to restart apache
echo 'aegir ALL=NOPASSWD: /usr/sbin/apache2ctl' | sudo tee -a /etc/sudoers > /dev/null

# bootstrap a database for aegir
mysql --user=$MYSQL_USER --password=$MYSQL_PASS <<END
  CREATE DATABASE aegir;
  GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, \
    CREATE TEMPORARY TABLES, LOCK TABLES ON aegir.* TO \
    'aegir'@'localhost' IDENTIFIED BY '$MYSQL_PASS';
  GRANT ALL PRIVILEGES ON *.* TO 'aegir_root'@'localhost' IDENTIFIED \
    BY '$MYSQL_PASS' WITH GRANT OPTION;
END

# configure dns
echo "127.0.0.1 $AEGIR_LOCAL_DOMAIN" | sudo tee -a /etc/hosts > /dev/null

# install files
wget -O install.sh.txt "$AEGIR_GIT_URL"
sudo su -s /bin/sh aegir -c "sh install.sh.txt $AEGIR_LOCAL_DOMAIN"
sudo /etc/init.d/apache2 restart

# ############################################# END INSTALL.txt instructions

# make run as aegir shortcut
rm install.sh.txt
cat > ./aegir <<END
#!/bin/bash
sudo su -s /bin/sh aegir -c "$*"
END
chmod 755 ./aegir
sudo mv ./aegir /var/aegir/aegir 
sudo ln -s /var/aegir/aegir /usr/local/bin/aegir

# make drush shortcut
sudo chmod u+x /var/aegir/drush/drush
sudo ln -s /var/aegir/drush/drush /usr/local/bin/drush

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

# continue install
firefox http://$AEGIR_LOCAL_DOMAIN &

