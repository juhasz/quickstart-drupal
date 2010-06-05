<?php

// Note: for shell commands: 0=success, non-zero=error code

function quickstart_shell_exec($cmd, $throwexception=true) {
  $ret = drush_shell_exec($cmd);
  if ($throwexception && !$ret) {
    $msg = "Command returned unexpected result: $cmd";
    $output = drush_shell_exec_output();
    foreach ($output as $line) {
      $msg="\n  $line";
    }
    throw new Exception($msg);
  }
}

function quickstart_mysql_exec($sql) {
  quickstart_shell_exec("echo \"$sql\" | mysql -uroot -pquickstart");
}


function quickstart_fixpath($pathin) {
  // fix ~'s
  $homedir = "/home/" . exec('whoami');
  $pathout = str_replace("~", $homedir, $pathin);
  // realpath fails on non-existant folders.  So it's hard to fix .'s and ..'s
  return $pathout;
}

// DNS functions here.  Just manipulate /etc/hosts file.

function quickstart_create_dns($domain, $params) {
  // FIXME detect duplicates
  quickstart_shell_exec("echo '127.0.0.1 $domain #quickstart' >> /etc/hosts");
}
function quickstart_destroy_dns($domain, $params) {
  quickstart_shell_exec("sed \"/ $domain .*#quickstart/d\" /etc/hosts > ~/hosts.tmp");
  quickstart_shell_exec("cat ~/hosts.tmp > /etc/hosts");
  quickstart_shell_exec("rm ~/hosts.tmp");
}
function quickstart_backup_dns($domain, $params) {
  // nothing to do
}
function quickstart_restore_dns($domain, $params) {
  // recreate to restore
  return quickstart_create_dns($domain, $params);
}
function quickstart_status_dns($domain, $params) {
  // FIXME verify in file
}

// APACHE functions here

define('APACHE_TEMPLATE', "
<VirtualHost *:80>
  ServerName #DOMAIN#
  ServerAlias *.#DOMAIN#
  DocumentRoot #CODEPATH#
  <Directory #CODEPATH#>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride None
    Order allow,deny
    allow from all
  </Directory>
</VirtualHost>
<IfModule mod_ssl.c>
  <VirtualHost *:443>
    ServerName #DOMAIN#
    ServerAlias *.#DOMAIN#
    DocumentRoot #CODEPATH#
    <Directory #CODEPATH#>
      Options Indexes FollowSymLinks MultiViews
      AllowOverride None
      Order allow,deny
      allow from all
    </Directory>
    SSLEngine on
    SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
    SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
  </VirtualHost>
</IfModule>");

function quickstart_create_apache($domain, $params) {
  // get codepath and make sure it exists.
  $codepath = $params['codepath'];

  if (!file_exists($codepath)) mkdir($codepath, 0777, true);

  // get template
  $str_config = APACHE_TEMPLATE;

  // make our own :-)
  $str_config = str_replace("#DOMAIN#", $domain, $str_config);
  $str_config = str_replace("#CODEPATH#", $codepath, $str_config);

  $config_handle = fopen("/etc/apache2/sites-enabled/$domain", "w+");
  fwrite($config_handle, $str_config);

  // restart apache
  quickstart_shell_exec("sudo apache2ctl restart"); // hopefully sudoers file negates password check
}
function quickstart_destroy_apache($domain, $params) {
  $filename = "/etc/apache2/sites-enabled/$domain";
  if (file_exists($filename)) unlink($filename);  // unlink = delete file
  quickstart_shell_exec("sudo apache2ctl restart"); // hopefully sudoers file negates password check
}
function quickstart_backup_apache($domain, $params) {
  // FIXME
}
function quickstart_restore_apache($domain, $params) {
  // FIXME
}
function quickstart_status_apache($domain, $params) {
  // FIXME
}

// Database functions here

// We create the user with the GRANT statement, instead of CREATE USER, because it can be run twice without deleting.
define('DATABASE_CREATE', "
GRANT USAGE ON *.* TO #DOMAIN#@localhost IDENTIFIED BY '#DOMAIN#' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
CREATE DATABASE IF NOT EXISTS #DOMAIN#;
GRANT ALL PRIVILEGES ON #DOMAIN#.* TO #DOMAIN#@localhost;
FLUSH PRIVILEGES;");
// We GRANT before DROP USER to make sure there is something to drop.  USAGE is synonym for 'no priveledges'.
define('DATABASE_DESTROY', "
GRANT USAGE ON *.* TO #DOMAIN#@localhost;
DROP USER #DOMAIN#@localhost;
DROP DATABASE IF EXISTS #DOMAIN#;
FLUSH PRIVILEGES;");

function quickstart_create_database($domain, $params) {
  $domain = str_replace('.','_',$domain);
  $sql = str_replace("#DOMAIN#", $domain, DATABASE_CREATE);
  quickstart_mysql_exec($sql);
}
function quickstart_destroy_database($domain, $params) {
  $domain = str_replace('.','_',$domain);
  $sql = str_replace("#DOMAIN#", $domain, DATABASE_DESTROY);
  quickstart_mysql_exec($sql);
}
function quickstart_backup_database($domain, $params) {
  $domain = str_replace('.','_',$domain); // FIXME
}
function quickstart_restore_database($domain, $params) {
  $domain = str_replace('.','_',$domain); // FIXME
}
function quickstart_status_database($domain, $params) {
  $domain = str_replace('.','_',$domain); // FIXME
}

// Code functions here

function quickstart_create_code($domain, $params) {

  $codepath = $params['codepath'];
  $makefile = $params['makefile'];

  if (file_exists($codepath)) {
    quickstart_shell_exec("mv $codepath $codepath.old");
    drush_log("Moved existing directory $codepath to $codepath.old", "ok");
  }
  if (!file_exists($makefile)) {
    // try to find makefile in ~/websites folder
    $makefile = quickstart_fixpath("~/websites/$makefile");
    if (!file_exists($makefile)) throw new Exception("Makefile ". $params['makefile'] ." not found.");
  }

  drush_backend_invoke("make $makefile $codepath");
}
function quickstart_destroy_code($domain, $params) {
  $codepath = $params['codepath'];
  // only delete a web folder.  "drush qd --codepath=/" would be bad.
  if (!file_exists($codepath . '/index.php')) throw new Exception("No index.php found.  Aborting...");
  quickstart_shell_exec("rm -rf $codepath");
  quickstart_shell_exec("rm -rf $codepath.old");
}
function quickstart_backup_code($domain, $params) {
  // FIXME
}
function quickstart_restore_code($domain, $params) {
  // FIXME
}
function quickstart_status_code($domain, $params) {
  // FIXME
}

// Install functions here

function quickstart_create_install($domain, $params) {
  $profile = $params['profile'];
  $database = str_replace('.','_',$domain);
  $dbuser = $params['dbuser'];
  $dbpassword = $params['dbpassword'];
  $codepath = $params['codepath'];

  drush_backend_invoke("provision-install $domain --profile=$profile --master_db_user=$dbuser --master_db_passwd=$dbpassword --db_type=mysql --db_host=localhost --root=$codepath");
}
function quickstart_destroy_install($domain, $params) {
  // drop and create database and user.
  quickstart_destroy_database($domain, $params);
  quickstart_create_database($domain, $params);
  // delete settings.php file

  // delete files folder
  
}
function quickstart_backup_install($domain, $params) {
  // FIXME
}
function quickstart_restore_install($domain, $params) {
  // FIXME
}
function quickstart_status_install($domain, $params) {
  // FIXME
}

?>
