#!/bin/bash

# ################################################################################ Hudson

# README:
#
# This script will install Aegir (a hosting management platform) on aegir.dev
#
HELP="

Aegir Installation complete.  Check output for install errors

Aegir is a hosting management platform.  Aegir is running at http://aegir.dev

********************** READ THIS: **********************

To restart Aegir:  sudo /etc/init.d/apache2 restart

To admin Aegir: http://aegir.dev/

For details on using Aegir, see here: http://aegirproject.org/

NOTE: ABOVE IS A PASSWORD RESET URL.  USE IT TO LOGIN INITIALLY.

NOTE 2: If you lost your password reset url, get a new one for user 'admin' and 
        check the ~/websites/log/mail folder for a password reset email.

You are now logged in as the aegir user.

********************** TO FINISH, run these commands: **********************
drush dl --destination=/var/aegir/.drush provision-6.x
drush hostmaster-install
exit
# reboot 
********************** TO FINISH, run these commands: **********************
"

MYSQL_USER=root
MYSQL_PASS=quickstart
AEGIR_LOCAL_DOMAIN=aegir.dev
AEGIR_GIT_URL="http://git.aegirproject.org/?p=provision.git;a=blob_plain;f=install.sh.txt;hb=provision-0.4-beta1"

# FROM: http://community.aegirproject.org/node/389

# 2. Install system requirements
echo postfix       postfix/main_mailer_type   text     Local only                             | sudo debconf-set-selections
echo postfix       postfix/mailname           text     postfix_default@$AEGIR_LOCAL_DOMAIN    | sudo debconf-set-selections
sudo apt-get -y install apache2 php5 php5-cli php5-gd php5-mysql postfix sudo rsync git-core unzip

# 3.1.1. Apache configuration
sudo a2enmod rewrite
sudo ln -s /var/aegir/config/apache.conf /etc/apache2/conf.d/aegir.conf

# 3.2. DNS configuration
echo "127.0.0.1 $AEGIR_LOCAL_DOMAIN" | sudo tee -a /etc/hosts > /dev/null

# 3.3. PHP configuration
## This is set in quickstart-3-lamp.sh
sudo sed -i 's/memory_limit = 64M/memory_limit = 192M/g'            /etc/php5/apache2/php.ini /etc/php5/cli/php.ini

# 3.4. Database configuration
sudo apt-get install mysql-server
sudo sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/g'            /etc/mysql/my.cnf
sudo /etc/init.d/mysql restart

# 3.5. Create the Aegir user
sudo adduser --system --group --home /var/aegir aegir
sudo adduser aegir www-data    #make aegir a user of group www-data
sudo adduser aegir ssl-cert    #allow aegir to see certs (when restarting apache)

# 3.6. Sudo configuration
echo "aegir ALL=NOPASSWD: /usr/sbin/apache2ctl" | sudo tee -a /etc/sudoers > /dev/null

# 5. Install Aegir components

echo "$HELP"

# 4. Stop! Now become the Aegir user!
sudo su -s /bin/bash aegir

