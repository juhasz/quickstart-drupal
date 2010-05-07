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

# "Pin" PHP to karmic repositories
PHP_PACKAGES="php5 php5-dev php5-common php5-xsl php5-curl php5-gd php5-pgsql php5-cli php5-mcrypt php5-sqlite php5-mysql libapache2-mod-php5 php-pear php5-imap"
echo '' | sudo tee -a /etc/apt/preferences.d/php-karmic > /dev/null
for i in $PHP_PACKAGES ; do echo "Package: $i
Pin: version 5.2.*
Pin-Priority: 1001
" | sudo tee -a /etc/apt/preferences.d/php-karmic > /dev/null; done
echo "Package: php5-xdebug
Pin: version 2.0.4*
Pin-Priority: 1001
" | sudo tee -a /etc/apt/preferences.d/php-karmic > /dev/null
echo "Package: php-apc
Pin: version 3.0.*
Pin-Priority: 1001
" | sudo tee -a /etc/apt/preferences.d/php-karmic > /dev/null
echo "Package: libapache2-svn
Pin: version 1.6.5*
Pin-Priority: 1001
" | sudo tee -a /etc/apt/preferences.d/php-karmic > /dev/null
sudo aptitude update
sudo apt-get -y install $PHP_PACKAGES 
sudo apt-get -y install apache2 apache2-threaded-dev mysql-server phpmyadmin php5-xdebug php-apc libapache2-svn # aptitude freaks out from pinning and holding.
# aptitude doesn't listen to pinning of apt.  hold packages to prevent 'aptitude safe-upgrade' overwriting
sudo aptitude hold $PHP_PACKAGES apache2 apache2-threaded-dev mysql-server phpmyadmin php5-xdebug php-apc libapache2-svn

# configure Apache - enable rewrite, disable unneeded
sudo a2enmod ssl
sudo a2enmod rewrite
sudo a2dismod cgi
sudo a2dismod autoindex

# configuure ssl and apache - FIXME
# sudo openssl req -new -x509 -nodes -out server.crt -keyout server.key

# sudo sed -i 's/find_this/replace_with_this/g' infile1 infile2 etc
sudo sed -i 's/magic_quotes_gpc = On/magic_quotes_gpc = Off/g'     /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/short_open_tag = On/short_open_tag = Off/g'         /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/memory_limit = 16M/memory_limit = 64M/g'            /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/memory_limit = 32M/memory_limit = 64M/g'            /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/g'                 /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/;error_log = filename/error_log = \/var\/log\/php-error.log/g'        /etc/php5/apache2/php.ini /etc/php5/cli/php.ini # php 5.2
sudo sed -i 's/;error_log = php_errors.log/error_log = \/var\/log\/php-error.log/g'  /etc/php5/apache2/php.ini /etc/php5/cli/php.ini # php 5.3

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

# install upload progress (warning in D7)
sudo pecl -q install uploadprogress 
echo "extension=apc.so" | sudo tee -a /etc/php5/apache2/conf.d/apc.ini

# clean up aptitude
sudo aptitude clean

#restart web server
sudo service mysql restart
sudo service apache2 graceful

