#!/bin/bash

mkdir /home/quickstart/websites

# ##### Install LAMP packages

LAMP_APACHE="apache2 apache2-threaded-dev libapache2-mod-php5 libapache2-svn"
LAMP_MYSQL="mysql-server"
LAMP_PHP="php5 php5-dev php5-common php5-xsl php5-curl php5-gd php5-pgsql php5-cli php5-mcrypt php5-sqlite php5-mysql php-pear php5-imap php5-xdebug php-apc"
LAMP_TOOLS="phpmyadmin"
sudo apt-get -y install $LAMP_APACHE
zenity --info --text="Set all passwords to 'quickstart'"
sudo apt-get -y install $LAMP_MYSQL
sudo apt-get -y install $LAMP_PHP 
zenity --info --text="Select 'apache' to configure.  Select 'yes' to phpmyadmin. Set passwords to 'quickstart'"
sudo apt-get -y install $LAMP_TOOLS


# ###### Configure APACHE

sudo a2enmod ssl
sudo a2enmod rewrite
sudo a2dismod cgi
sudo a2dismod autoindex
# configure default site
echo "<VirtualHost *:80>
	DocumentRoot /var/www
	<Directory /var/www/>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
		Order allow,deny
		allow from all
	</Directory>
</VirtualHost>" | sudo tee /etc/apache2/sites-enabled/000-default
# Default ssl site
sudo ln /etc/apache2/sites-available/default-ssl /etc/apache2/sites-enabled/default-ssl
# Fix ssl for easier virtual hosting
echo "NameVirtualHost *:80
Listen 80
<IfModule mod_ssl.c>
    NameVirtualHost *:443
    Listen 443
</IfModule>" | sudo tee /etc/apache2/ports.conf
echo "<IfModule mod_ssl.c>
<VirtualHost *:443>
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www
  <Directory />
    Options FollowSymLinks
    AllowOverride None
  </Directory>
  <Directory /var/www/>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride None
    Order allow,deny
    allow from all
  </Directory>
  SSLEngine on
  SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
  SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
</VirtualHost>
</IfModule>" | sudo tee /etc/apache2/sites-enabled/default-ssl



# ###### Configure MYSQL

sudo sed -i 's/#log_slow_queries/log_slow_queries/g'          /etc/mysql/my.cnf
sudo sed -i 's/#long_query_time/long_query_time/g'            /etc/mysql/my.cnf



# ###### Configure PHP

# sudo sed -i 's/find_this/replace_with_this/g' infile1 infile2 etc
sudo sed -i 's/magic_quotes_gpc = On/magic_quotes_gpc = Off/g'     /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/short_open_tag = On/short_open_tag = Off/g'         /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/memory_limit = 16M/memory_limit = 64M/g'            /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/memory_limit = 32M/memory_limit = 64M/g'            /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g'                 /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 50M/g'                             /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/;error_log = filename/error_log = \/var\/log\/php-error.log/g'        /etc/php5/apache2/php.ini /etc/php5/cli/php.ini # php 5.2
sudo sed -i 's/;error_log = php_errors.log/error_log = \/var\/log\/php-error.log/g'  /etc/php5/apache2/php.ini /etc/php5/cli/php.ini # php 5.3

# Fix comment bug that will show warning on command line
sudo sed -i 's/# /\/\/ /g'            /etc/php5/cli/conf.d/mcrypt.ini

# Install upload progress (warning in D7)
sudo pecl -q install uploadprogress 
echo "extension=uploadprogress.so" | sudo tee /etc/php5/apache2/conf.d/uploadprogress.ini > /dev/null



# ###### Apache SOLR - 183mb

sudo apt-get -y install solr-common solr-tomcat



# ###### Restart web server

sudo service mysql restart
sudo service apache2 graceful

