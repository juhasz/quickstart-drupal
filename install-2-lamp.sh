#!/bin/bash

# install LAMP
zenity --info --text="Set all passwords to 'quickstart'.  Select 'apache' to configure.  Click 'yes' to phpmyadmin."

# php 5.3 doesn't work for Drupal and Aegir.  Downgrade to 5.2 by using LAMP packages from Karmic (Ubuntu 9.10).
#   enable Karmic repositories
echo "# needed sources for php5.2:
deb http://archive.ubuntu.com/ubuntu      karmic          main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu  karmic          main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu      karmic-updates  main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu  karmic-updates  main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu     karmic-security main restricted universe multiverse
deb-src http://security.ubuntu.com/ubuntu karmic-security main restricted universe multiverse
" | sudo tee -a /etc/apt/sources.list.d/karmic.list > /dev/null

#   "Pin" PHP to karmic repositories
LAMP_PACKAGES="apache2 apache2-threaded-dev mysql-server php5 php5-dev php5-common php5-xsl php5-curl php5-gd php5-pgsql php5-cli php5-mcrypt php5-sqlite php5-mysql libapache2-mod-php5 php-pear php5-xdebug php-apc phpmyadmin libapache2-mod-php5"
for i in $LAMP_PACKAGES ; do echo "Package: $i
Pin: release a=karmic
Pin-Priority: 1001
" | sudo tee -a /etc/apt/preferences.d/lamp-karmic > /dev/null; done
sudo aptitude update
sudo aptitude -y install $PHP_PACKAGES

# configure Apache - enable rewrite, disable unneeded
sudo a2enmod rewrite
sudo a2dismod cgi
sudo a2dismod autoindex

# sudo sed -i 's/find_this/replace_with_this/g' infile1 infile2 etc
sudo sed -i 's/magic_quotes_gpc = On/magic_quotes_gpc = Off/g'     /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/short_open_tag = On/short_open_tag = Off/g'         /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/memory_limit = 16M/memory_limit = 64M/g'            /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/memory_limit = 32M/memory_limit = 64M/g'            /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/;error_log = php_errors.log/error_log = \/var\/log\/php-error.log/g'     /etc/php5/apache2/php.ini /etc/php5/cli/php.ini

# configure xdebug
echo "xdebug.remote_enable=on
xdebug.remote_handler=dbgp
xdebug.remote_host=localhost
xdebug.remote_port=9000
" | sudo tee -a /etc/php5/conf.d/xdebug.ini > /dev/null

# fix comment bug that will show warning on command line.
sudo sed -i 's/# /\/\/ /g'            /etc/php5/cli/conf.d/mcrypt.ini

# configure mysql for slow query log
sudo sed -i 's/#log_slow_queries/log_slow_queries/g'          /etc/mysql/my.cnf
sudo sed -i 's/#long_query_time/long_query_time/g'            /etc/mysql/my.cnf

# clean up aptitude
sudo aptitude clean

#restart web server
sudo service mysql restart
sudo service apache2 restart

