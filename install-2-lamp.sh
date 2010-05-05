#!/bin/bash

# install LAMP
zenity --info --text="Set all passwords to 'quickstart'.  Select 'apache' to configure.  Click 'yes' to phpmyadmin."
sudo aptitude -y install apache2 mysql-server phpmyadmin php5 php5-gd php-pear # basic lamp server with phpmyadmin
sudo aptitude -y install php5-mysql php5-pgsql php5-sqlite # database support
sudo aptitude -y install apache2-threaded-dev php5-dev # apc and xdebug
sudo aptitude -y install php5-xsl php5-curl # symfony/propel

# configure Apache - enable rewrite, disable unneeded
sudo a2enmod rewrite
sudo a2dismod cgi
sudo a2dismod autoindex

# configure php for drupal and modern php development
# sudo sed -i 's/find_this/replace_with_this/g' infile1 infile2 etc
sudo sed -i 's/magic_quotes_gpc = On/magic_quotes_gpc = Off/g'     /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/short_open_tag = On/short_open_tag = Off/g'         /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/memory_limit = 16M/memory_limit = 64M/g'            /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/memory_limit = 32M/memory_limit = 64M/g'            /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
sudo sed -i 's/;error_log = php_errors.log/error_log = \/var\/log\/php-error.log/g'     /etc/php5/apache2/php.ini /etc/php5/cli/php.ini
# fix comment bug that will show warning on command line.
sudo sed -i 's/# /\/\/ /g'            /etc/php5/cli/conf.d/mcrypt.ini

# configure mysql for slow query log
sudo sed -i 's/#log_slow_queries/log_slow_queries/g'          /etc/mysql/my.conf
sudo sed -i 's/#long_query_time/long_query_time/g'            /etc/mysql/my.conf

#install APC (op-code cache - improves performance)
sudo aptitude -y install php-apc

#install xdebug
sudo aptitude -y install php5-xdebug
sudo echo >> /etc/php5/conf.d/xdebug.ini <<END
xdebug.remote_enable=on
xdebug.remote_handler=dbgp
xdebug.remote_host=localhost
xdebug.remote_port=9000
END

# clean up aptitude
sudo aptitude clean

#restart web server
sudo service mysql restart
sudo service apache2 restart

