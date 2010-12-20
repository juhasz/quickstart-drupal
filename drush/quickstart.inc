<?php
/**
 * This is an include file.  These are the "callback" functions that drush
 * uses to get the job done.  See quickstart.drush.inc for the definition of
 * the commands.
 * 
 * @file
 */

/**
 * Helper function for executing shell commands.  Throws exceptions on error.
 *
 * @param <type> $cmd the command to run
 * @param <type> $throwexception throw exception on error?
 */
function quickstart_shell_exec($cmd, $throwexception=true) {
  // Note: for shell commands: 0=success, non-zero=error code
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

/**
 * Helper function for running SQL on a local mysql database.
 *
 * @param <type> $sql
 */
function quickstart_mysql_exec($sql) {
  quickstart_shell_exec("echo \"$sql\" | mysql -uroot -pquickstart");
}

/**
 * Helper function for dereferencing paths.
 *
 * @param <type> $pathin
 * @return <type>
 */
function quickstart_fixpath($pathin) {
  // fix ~'s
  $homedir = "/home/" . exec('whoami');
  $pathout = str_replace("~", $homedir, $pathin);
  // realpath fails on non-existant folders.  So it's hard to fix .'s and ..'s
  return $pathout;
}

/**
 * Create the DNS.  Edits /etc/hosts on local machine.
 * Entries in file are marked with #quickstart
 *
 * @param <type> $domain the domain to DNS
 * @param <type> $params
 */
function quickstart_create_dns($domain, $params) {
  // FIXME detect duplicates
  quickstart_shell_exec("echo '127.0.0.1 $domain #quickstart' >> /etc/hosts");
}

/**
 * Destroy the DNS.  Edit /etc/hosts file on local machine
 *
 * @param <type> $domain
 * @param <type> $params
 */
function quickstart_destroy_dns($domain, $params) {
  quickstart_shell_exec("sed \"/ $domain .*#quickstart/d\" /etc/hosts > ~/hosts.tmp");
  quickstart_shell_exec("cat ~/hosts.tmp > /etc/hosts");
  quickstart_shell_exec("rm ~/hosts.tmp");
}


/**
 * This is the virtual hosts template file for the apache functions.
 */
define('APACHE_TEMPLATE', "
<VirtualHost *:80>
  ServerName #DOMAIN#
  ServerAlias *.#DOMAIN#
  DocumentRoot #CODEPATH#
  <Directory #CODEPATH#>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
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
      AllowOverride All
      Order allow,deny
      allow from all
    </Directory>
    SSLEngine on
    SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
    SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
  </VirtualHost>
</IfModule>");

/**
 * Configure apache virtualhost file using the template.
 * Files put in /etc/apache2/sites-available/$domain, then a2ensite'd
 * Runs: apache2ctl restart
 *
 * @param <type> $domain
 * @param <type> $params 'codepath'
 */
function quickstart_create_apache($domain, $params) {
  // get codepath and make sure it exists.
  $codepath = $params['codepath'];

  if (!file_exists($codepath)) mkdir($codepath, 0777, true);

  // get template
  $str_config = APACHE_TEMPLATE;

  // make our own :-)
  $str_config = str_replace("#DOMAIN#", $domain, $str_config);
  $str_config = str_replace("#CODEPATH#", $codepath, $str_config);

  $config_handle = fopen("/etc/apache2/sites-available/$domain", "w+");
  fwrite($config_handle, $str_config);

  // enable using script
  quickstart_shell_exec("a2ensite $domain"); 

  // restart apache
  quickstart_shell_exec("apache2ctl restart");
}

/**
 * Destroy the apache virtual hosts config. a2dissite, then rm file.
 * Runs: apache2ctl restart
 *
 * @param <type> $domain
 * @param <type> $params
 */
function quickstart_destroy_apache($domain, $params) {
  quickstart_shell_exec("a2dissite $domain");
  $filename = "/etc/apache2/sites-available/$domain";
  if (file_exists($filename)) unlink($filename);  // unlink = delete file
  quickstart_shell_exec("apache2ctl restart");
}

/**
 * These define SQL commands to run on database
 */
define('DATABASE_CREATE', "
GRANT USAGE ON *.* TO #DOMAIN#@localhost IDENTIFIED BY '#DOMAIN#' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
CREATE DATABASE IF NOT EXISTS #DOMAIN#;
GRANT ALL PRIVILEGES ON #DOMAIN#.* TO #DOMAIN#@localhost;
FLUSH PRIVILEGES;");
/**
 * We GRANT before DROP USER to make sure there is something to drop.  USAGE is synonym for 'no priveledges'.
 */
define('DATABASE_DESTROY', "
GRANT USAGE ON *.* TO #DOMAIN#@localhost;
DROP USER #DOMAIN#@localhost;
DROP DATABASE IF EXISTS #DOMAIN#;
FLUSH PRIVILEGES;");

/**
 * Create the database.  Runs SQL.  Replaces .'s with _'s in domain name
 * to get the database name, database username, and password.
 *
 * @param <type> $domain
 * @param <type> $params
 */
function quickstart_create_database($domain, $params) {
  $domain = str_replace('.','_',$domain);
  $sql = str_replace("#DOMAIN#", $domain, DATABASE_CREATE);
  quickstart_mysql_exec($sql);
}
/**
 * Destroys the database using SQL.
 *
 * @param <type> $domain
 * @param <type> $params
 */
function quickstart_destroy_database($domain, $params) {
  $domain = str_replace('.','_',$domain);
  $sql = str_replace("#DOMAIN#", $domain, DATABASE_DESTROY);
  quickstart_mysql_exec($sql);
}

/**
 * Download the code using drush make.  
 * If path already exists, moves it to path.old.
 * 
 * @param <type> $domain
 * @param <type> $params 'codepath' 'makefile'
 */
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
    if (!file_exists($makefile)) throw new Exception("Makefile ". $makefile ." not found.");
  }

  drush_backend_invoke("make $makefile $codepath");
  quickstart_shell_exec("chown quickstart:www-data -R $codepath");
  quickstart_shell_exec("chmod g+w -R $codepath");
}

/**
 * Deletes the sites files using rm -rf.  Also path.old.
 *
 * @param <type> $domain
 * @param <type> $params 'codepath'
 */
function quickstart_destroy_code($domain, $params) {
  $codepath = $params['codepath'];
  // only delete a web folder.  "drush qd --codepath=/" would be bad.
  if (!file_exists($codepath . '/index.php')) {
      drush_log('No index.php found.  Aborting deletion of files...', 'warning');
      return;
  }
  quickstart_shell_exec("rm -rf $codepath");
  quickstart_shell_exec("rm -rf $codepath.old");
}

/**
 * Install the site.  D6 and D7 versions.
 *
 * @param <type> $domain
 * @param <type> $params
 */
function quickstart_create_install($domain, $params) {
  $profile = $params['profile'];
  $database = str_replace('.','_',$domain);
  $codepath = $params['codepath'];
  
  $str=implode("\n",file("$codepath/sites/default/default.settings.php"));
  $fp=fopen("$codepath/sites/default/settings.php",'w');
  fwrite($fp,$str,strlen($str));

  quickstart_shell_exec("chown quickstart:www-data -R \"$codepath\"");
  quickstart_shell_exec("chmod g+w -R \"$codepath\"");

  quickstart_shell_exec("zenity --info --text=\"Drupal installer will now start.\n  dbuser, password, and database are: $database\n  Return to this window and press ENTER to fix settings.php warning.\"");

  quickstart_shell_exec("firefox http://$domain");

  quickstart_shell_exec("zenity --info --text=\"**** AFTER INSTALLER HAS COMPLETED ****\n close this dialog to finish\"");

  quickstart_shell_exec("chmod g-w \"$codepath/sites/default/settings.php\"");
  quickstart_shell_exec("chmod g-w \"$codepath/sites/default\"");

  // Provision has it's own plan that is incompatible with quickstart.  D7 includes it's own command line installer.
  //drush_backend_invoke("provision-install $domain --profile=$profile --master_db_user=$dbuser --master_db_passwd=$dbpassword --db_type=mysql --db_host=localhost --root=$codepath");
}

/**
 * Return site to situation where "drush qc install --domain=site.dev" could
 * be re-run successfully.
 *
 * @param <type> $domain
 * @param <type> $params 'codepath'
 */
function quickstart_destroy_install($domain, $params) {
  // only delete a web folder.  "drush qd --codepath=/" would be bad.
  $codepath = $params['codepath'];
  if (!file_exists($codepath . '/index.php')) {
      drush_log('No index.php found.  Aborting un-install of site...', 'warning');
      return;
  }

  // drop and create database and user.
  quickstart_destroy_database($domain, $params);
  quickstart_create_database($domain, $params);

  // delete settings.php file
  quickstart_shell_exec("rm -rf $codepath/sites/all/default/settings.php");

  // delete files folder
  quickstart_shell_exec("rm -rf $codepath/sites/all/default/files");
  
}

?>
