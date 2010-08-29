#!/bin/bash

# Database home page can be found here at http://<ip>:8080/apex  username: system

# REQUIRES REBOOT FOR APACHE TO SEE ORACLE_HOME

#install server
echo "deb http://oss.oracle.com/debian unstable main non-free" | sudo tee -a /etc/apt/sources.list
wget http://oss.oracle.com/el4/RPM-GPG-KEY-oracle -O- | sudo apt-key add - 
sudo apt-get update
sudo apt-get install oracle-xe
sudo /etc/init.d/oracle-xe configure

#install php driver
. /usr/lib/oracle/xe/app/oracle/product/10.2.0/server/bin/oracle_env.sh
echo $ORACLE_HOME > oracle_home
sudo pecl install oci8 < oracle_home
rm oracle_home
echo "extension=oci8.so" | sudo tee /etc/php5/conf.d/oci8.ini
echo "
#============================================== copied from oracle_env.sh
export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server
export ORACLE_SID=XE
export NLS_LANG=`$ORACLE_HOME/bin/nls_lang.sh`
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
" | sudo tee -a /etc/apache2/envvars	

#restart apache

sudo apache2ctl restart
