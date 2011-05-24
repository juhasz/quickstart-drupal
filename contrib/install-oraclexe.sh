#!/bin/bash

# README:
#
# This script will install Oracle XE (Express Edition) on port 8080
#

HELP="

Oracle XE Installation complete.  Review output for any errors.

Oracle is a legacy database server.  Oracle XE is the 'developers version',
and may be useful in porting legacy data from Oracle DB into something useful.

This script isn't very well written or tested.  I wrote it in 2009, while 
working on a legacy Windows/IIS/Oracle/PHP app.  Leaving it here, gives that
time in my life meaning and purpose.

Database home page can be found here at http://<ip>:8080/apex  username: system

To restart Oracle:  sudo /etc/init.d/oraccle restart

To admin Oracle: http://localhost:8080/apex  username: system  password: (set during install)

For details on using Oracle with Drupal, see here: http://api.drupal.org/api/drupal/includes--database.inc/group/database/6

REBOOT YOUR SERVER FOR APACHE TO SEE THE OCI8 DRIVER
"

if [ `uname -p` == "x86_64" ] 
then
  echo "

*** 32-bit only.  Oracle doesn't offer 64-bit version in their PPA ***

"
  exit
fi



cd ~
sudo apt-get update

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
echo "extension=oci8.so" | sudo tee /etc/php5/conf.d/oci8.ini > /dev/null
echo "
#============================================== copied from oracle_env.sh
export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server
export ORACLE_SID=XE
export NLS_LANG=`$ORACLE_HOME/bin/nls_lang.sh`
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
" | sudo tee -a /etc/apache2/envvars > /dev/null

#restart apache
sudo apache2ctl restart

echo "$HELP"


