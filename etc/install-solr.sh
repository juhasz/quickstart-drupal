#!/bin/bash

# ################################################################################ Apache SOLR - 183mb

# README:
#
# This script will install apache tomcat (a java app web server) and apache solr (a java search server)
#
HELP="

Solr Installation complete.

Apache Solr is a java web application.
It is running inside the Apache Tomcat java webapp server on port 8080.

To restart tomcat (and solr):  sudo /etc/init.d/tomcat6 restart

To admin tomcat: http://localhost:8080/manager/html
To admin solr:  http://localhost:8080/solr/admin/

Tomcat has been configured with a user 'admin' with password 'admin'

For details on using solr with Drupal, see here: http://drupal.org/project/apachesolr
"

cd ~
sudo apt-get update

sudo apt-get -y install tomcat6 tomcat6-admin tomcat6-common tomcat6-user tomcat6-docs tomcat6-examples
sudo apt-get -y install solr-common solr-tomcat

echo '
<tomcat-users>
  <role rolename="admin"/>
  <role rolename="manager"/>
  <user username="admin" password="admin" roles="admin,manager"/>
</tomcat-users>' | sudo tee /etc/tomcat6/tomcat-users.xml > /dev/null

sudo /etc/init.d/tomcat6 restart
echo "$HELP"
