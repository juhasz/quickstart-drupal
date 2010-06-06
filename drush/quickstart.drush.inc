<?php
// $Id$

include("quickstart.inc");

/**
 * @file
 *   Quickstart drush commands.
 *
 *   These commands are designed to be run inside the Quickstart development environment.
 *   They *might* run outside that, on a Ubuntu/Debian system.
 *
 *   1. Run 'sudo drush quicktart-setup' to allow current user to edit dns/apache config and restart apache.  See comments for details.
 *   2. Set mysql root users password to 'quickstart' (FIXME make option for user and pass)
 *   3. Logged in user must be called 'quickstart'
 *
 */

// note, these are hardcoded in examples section
function quickstart_arg_list() {
  return array('code'=>'code', 'database'=>'database', 'apache'=>'apache', 'dns'=>'dns', 'install'=>'install');
}

function quickstart_arg_list_all() {
  return quickstart_arg_list();
}

function quickstart_drush_command() {
  $items = array();

  $items['quickstart-create'] = array(
          'description' => "Create a quickstart development website (" . implode(', ', quickstart_arg_list()) . ").",
          'arguments' => array(
                  'what' => 'What to create: [all|' . implode('|', quickstart_arg_list()) . ']',
          ),
          'options' => array(
                  'domain' => 'Required.  Domain name of new site.  Use this to reference site with other commands.  Becomes dns, dbname, dbuser, dbpass, site-name, and kitchen-sink',
                  'codepath' => 'Default.  Path to drupal code.  Defaults to "~/websites/[domain]"',
                  'makefile' => 'Default.  Path to drupal make file.  Defaults to "~/websites/default.make"',
                  'profile' => 'Default.  Name of profile to install.  Defaults to "default"',
                  'patch' => 'Optional.  URL to a patch to apply before install.  Only used with "all" or "code"',
          ),
          'examples' => array(
                  'Create site in one command: setup dns, apache, create db, download d6, run installer, open in firefox' => 'drush quickstart-create all --domain=example1.dev',
                  'Simplest format' => 'drush qc all --domain=example.dev',
                  'Complete format' => 'drush quickstart-create all --domain=example2.dev --codepath=/path/to/drupal --makefile=~/quickstart/d7dev.make --profile=basic --patch=http://drupal.org/path/to/file.patch',
                  'Create DNS (/etc/hosts)' => 'drush quickstart-create dns --domain=example.dev',
                  'Create Apache (/etc/apache2/sites-enabled/)' => 'drush quickstart-create apache --domain=example.dev --codepath=/path/to/drupal',
                  'Create Database (mysql db and user)' => 'drush quickstart-create database --domain=example.dev',
                  'Create Code (download and patch)' =>'drush quickstart-create code --domain=example.dev --codepath=/path/to/drupal --makefile=/path/to/drupal.make --patch=http://example.com/path/to/patch',
                  'Open Firefox to start install' => 'drush quickstart-create install --domain=example.dev --codepath=/path/to/drupal --profile=default',
          ),
          'aliases' => array('qc'),
          'bootstrap' => DRUSH_BOOTSTRAP_DRUSH, // No bootstrap at all.
  );

  $items['quickstart-destroy'] = array(
          'description' => "Destroy a quickstart development website (" . implode(', ', quickstart_arg_list()) . ").",
          'arguments' => array(
                  'what' => 'What to destroy: [all|' . implode('|', quickstart_arg_list()) . ']',
          ),
          'options' => array(
                  'domain' => 'Domain name to destroy.',
                  'codepath' => 'Path to drupal code.  Defaults to ~/websites/[domain]',
          ),
          'examples' => array(
                  'Simplest format' => 'drush qd all --domain=example.dev',
                  'Complete format' => 'drush quickstart-destroy all --domain=example.dev --codepath=/path/to/drupal',
                  'Destroy DNS (/etc/hosts)' => 'drush quickstart-destroy dns --domain=example.dev',
                  'Destroy Apache (/etc/apache2/sites-enabled/)' => 'drush quickstart-destroy apache --domain=example.dev',
                  'Destroy Database (mysql db and user)' => 'drush quickstart-destroy database --domain=example.dev',
                  'Destroy Code and files (~/webistes/<domain>)' => 'drush quickstart-destroy code --domain=example.dev --codepath=/path/to/drupal',
          ),
          'aliases' => array('qd'),
          'bootstrap' => DRUSH_BOOTSTRAP_DRUSH, // No bootstrap at all.
  );
/*
  $items['quickstart-backup'] = array(
          'description' => "NOT IMPLEMENTED YET.  Backup a quickstart development website (" . implode(', ', quickstart_arg_list()) . ").",
          'arguments' => array(
                  'what' => 'What to backup: [all|' . implode('|', quickstart_arg_list()) . ']',
          ),
          'options' => array(
                  'domain' => 'Domain name to backup.',
                  'codepath' => 'Path to drupal code.  Defaults to ~/websites/[domain]',
                  'backupfile' => 'Path to backup file (.tgz format).  Defaults to ~/websites/backups/[domain].[currentdatetime]',
          ),
          'examples' => array(
          ),
          'aliases' => array('qb'),
          'bootstrap' => DRUSH_BOOTSTRAP_DRUSH, // No bootstrap at all.
  );

  $items['quickstart-restore'] = array(
          'description' => "NOT IMPLEMENTED YET.  Restore a quickstart development website (" . implode(', ', quickstart_arg_list()) . ").",
          'arguments' => array(
                  'what' => 'What to restore: [all|' . implode('|', quickstart_arg_list()) . ']',
          ),
          'options' => array(
                  'domain' => 'Domain name to restore.',
                  'codepath' => 'Path to drupal code.  Defaults to ~/websites/[domain]',
                  'backupfile' => 'Path to backup file (.tgz format).',
                  'overwrite' => 'Should we overwrite existing apache/db/code?  Defaults to false',
          ),
          'examples' => array(
          ),
          'aliases' => array('qr'),
          'bootstrap' => DRUSH_BOOTSTRAP_DRUSH, // No bootstrap at all.
  );

  $items['quickstart-status'] = array(
          'description' => "NOT IMPLEMENTED YET.  Check status of a quickstart development website (" . implode(', ', quickstart_arg_list()) . ").",
          'arguments' => array(
                  'what' => 'What to status: [all|' . implode('|', quickstart_arg_list()) . ']',
          ),
          'options' => array(
                  'domain' => 'Domain name to restore.',
                  'codepath' => 'Path to drupal code.  Defaults to ~/websites/[domain]',
          ),
          'examples' => array(
          ),
          'aliases' => array('qs'),
          'bootstrap' => DRUSH_BOOTSTRAP_DRUSH, // No bootstrap at all.
  );
*/
  $items['quickstart-setup'] = array(
          'description' => "Configures a system to use quickstart drush commands.  Run as root.",
          'examples' => array(
                  'sudo drush quickstart-setup',
          ),
          'bootstrap' => DRUSH_BOOTSTRAP_DRUSH, // No bootstrap at all.
  );

  return $items;
}

/**
 * Implementation of hook_drush_help().
 *
 * This function is called whenever a drush user calls
 * 'drush help <name-of-your-command>'
 *
 * @param
 *   A string with the help section (prepend with 'drush:')
 *
 * @return
 *   A string with the help text for your command.
 */
function quickstart_drush_help($section) {
  switch ($section) {
    case 'drush:quickstart-setup':
      return dt("Configures a system to use quickstart drush commands.  Use sudo.");
  }
}

function quickstart_params($required) {

  // check arguments
  $ret = drush_get_arguments();
  if (count($ret)==1) {
    $ret['fail'] = true;
    drush_print("  Argument required.  One or several of: " . implode(', ', quickstart_arg_list()));
  }

  if(array_search("all", $ret)) $ret = quickstart_arg_list_all();

  // get options
  $ret['domain'] = drush_get_option('domain');
  $ret['codepath'] = drush_get_option('codepath');
  $ret['backupfile'] = drush_get_option('backupfile');
  $ret['overwrite'] = drush_get_option('overwrite');
  $ret['makefile'] = drush_get_option('makefile');
  $ret['profile'] = drush_get_option('profile');
  $ret['patch'] = drush_get_option('patch');

  $ret['dbuser'] = 'root';
  $ret['dbpassword'] = 'quickstart';

  // set defaults
  if (empty($ret['codepath'])) $ret['codepath'] = quickstart_fixpath("~/websites/" . $ret['domain']);
  if (empty($ret['overwrite'])) $ret['overwrite'] = "false";
  if (empty($ret['makefile'])) $ret['makefile'] = quickstart_fixpath("~/websites/default.make");
  if (empty($ret['profile'])) $ret['profile'] = "default";
  if (empty($ret['backupfile'])) $ret['backupfile'] = quickstart_fixpath("~/websites/backups/" . $ret['domain']);  // process differently in backup and restore

  // check required
  foreach($required as $require) {
    if (empty($ret[$require])) {
      $ret['fail'] = true;
      drush_print("  '--$require' is a required option for this command.", 'error');
    }
  }
  return $ret;
}

/**
 * Drush callbacks
 */

function drush_quickstart_setup() {
  /* This has already been taken care of during install-quickstart.sh
  quickstart_shell_exec('useradd -G www-data quickstart');  // add quickstart to www-data (probably already done)
  quickstart_shell_exec('chown root:www-data /etc/hosts');  // allow access to hosts file
  quickstart_shell_exec('chmod g+w /etc/hosts');
  quickstart_shell_exec('chown -R root:www-data /etc/apache2');  // allow access to apache config files
  quickstart_shell_exec('chmod -R g+w /etc/apache2');
  quickstart_shell_exec('chown -R root:www-data /etc/mysql');  // allow access to mysql config files
  quickstart_shell_exec('chmod -R g+w /etc/mysql');
  quickstart_shell_exec('chown -R root:www-data /etc/php5');  // allow access to php config files
  quickstart_shell_exec('chmod -R g+w /etc/php5');
  quickstart_shell_exec('echo "quickstart ALL=NOPASSWD: /usr/sbin/apache2ctl" | tee -a /etc/sudoers > /dev/null');  // allow restarting apache
  quickstart_shell_exec('chown root:www-data /etc/ssl/private');  // fix apache restart error for SSL
  quickstart_shell_exec('chmod -R g+r /etc/ssl/private');
  */
  quickstart_shell_exec('mv ~/.drush/quickstart/*.make ~/websites'); // make templates.  Use mv so path doesn't get confused, and so don't acidentally overwrite work if run again.

}

function drush_quickstart_create() {

  $params = quickstart_params(array('domain'));
  if (isset($params['fail'])) return drush_set_error(0, dt('Bad parameters.  Try "drush help quickstart-create"'));
  $domain = $params['domain'];

  try {
    // can you say "object orientation..."
    if (array_search("database", $params)) {
      drush_log('Creating database [domain] ...');
      quickstart_create_database($domain, $params);
      drush_log('... database done.');
    }
    if (array_search("code", $params)) {
      drush_log('Creating code ...');
      quickstart_create_code($domain, $params);
      drush_log('... code done.');
    }
    if (array_search("apache", $params)) {
      drush_log('Creating apache config (/etc/apache2/sites-enabled/[domain]) ...');
      quickstart_create_apache($domain, $params);
      drush_log('... apache config done.');
    }
    if (array_search("dns", $params)) {
      drush_log('Creating dns config (/etc/hosts) ...');
      quickstart_create_dns($domain, $params);
      drush_log('... dns config done.');
    }
    if (array_search("install", $params)) {
      drush_log('Running installer ...');
      quickstart_create_install($domain, $params);
      drush_log('... installer done.');
    }
  } catch (Exception $e) {
    $message = $e->getMessage();
    drush_log("Command failed: $message", "error");
    return false;
  }

  drush_log("Command completed successfully.", "success");
  return true;
}

function drush_quickstart_destroy() {

  $params = quickstart_params(array('domain'));
  if (isset($params['fail'])) return drush_set_error(0, dt('Bad parameters.  Try "drush help quickstart-destroy"'));
  $domain = $params['domain'];

  try {
    // can you say "object orientation..."
    if (array_search("install", $params)) {
      drush_log('Destroying installation ...');
      quickstart_destroy_install($domain, $params);
      drush_log('... installation done.');
    }
    if (array_search("code", $params)) {
      drush_log('Destroying code ...');
      quickstart_destroy_code($domain, $params);
      drush_log('... code done.');
    }
    if (array_search("database", $params)) {
      drush_log('Destroying database [domain] ...');
      quickstart_destroy_database($domain, $params);
      drush_log('... database done.');
    }
    if (array_search("apache", $params)) {
      drush_log("Destroying apache config (/etc/apache2/sites-enabled/$domain) ...");
      quickstart_destroy_apache($domain, $params);
      drush_log('... apache config done.');
    }
    if (array_search("dns", $params)) {
      drush_log('Destroying dns config (/etc/hosts) ...');
      quickstart_destroy_dns($domain, $params);
      drush_log('... dns config done.');
    }
  } catch (Exception $e) {
    $message = $e->getMessage();
    drush_log("Command failed: $message", "error");
    return false;
  }

  drush_log("Command completed successfully.", "success");
  return true;
}

