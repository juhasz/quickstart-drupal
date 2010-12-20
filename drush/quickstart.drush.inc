<?php
// $Id$

include("quickstart.inc");

/**
 * @file
 *   Quickstart drush commands.
 *
 *   These commands are designed to be run inside the Quickstart development environment.
 */

/**
 * Implements hook_drush_command()
 * @return array
 */
function quickstart_drush_command() {
  $items = array();

  $items['quickstart-create'] = array(
          'description' => "Create a quickstart development website (" . implode(', ', _quickstart_arg_list()) . ").",
          'arguments' => array(
                  'what' => 'What to create: [all|' . implode('|', _quickstart_arg_list()) . ']',
          ),
          'options' => array(
                  'domain' => 'Required.  Domain name of new site.  Use this to reference site with other commands.  Becomes dns, dbname, dbuser, dbpass, site-name, and kitchen-sink',
                  'codepath' => 'Default.  Path to drupal code.  Defaults to "~/websites/[domain]"',
                  'makefile' => 'Default.  Path to drupal make file.  Defaults to D7 "~/websites/default.make"',
                  'profile' => 'Default.  Name of profile to install.  Defaults to "default"',
          ),
          'examples' => array(
                  'Create site in one command: setup dns, apache, create db, download d6, run installer, open in firefox' => 'drush quickstart-create --domain=example1.dev',
                  'Quick D7 site' => 'drush qc --domain=example.dev',
                  'Create DNS (/etc/hosts)' => 'drush quickstart-create dns --domain=example.dev',
                  'Create Apache (/etc/apache2/sites-enabled/)' => 'drush quickstart-create apache --domain=example.dev --codepath=/path/to/drupal',
                  'Create Database (mysql db and user)' => 'drush quickstart-create database --domain=example.dev',
          ),
          'aliases' => array('qc'),
          'bootstrap' => DRUSH_BOOTSTRAP_DRUSH, // No bootstrap at all.
  );

  $items['quickstart-destroy'] = array(
          'description' => "Destroy a quickstart development website (" . implode(', ', _quickstart_arg_list()) . ").",
          'arguments' => array(
                  'what' => 'What to destroy: [all|' . implode('|', _quickstart_arg_list()) . ']',
          ),
          'options' => array(
                  'domain' => 'Domain name to destroy.',
                  'codepath' => 'Path to drupal code.  Defaults to ~/websites/[domain]',
          ),
          'examples' => array(
                  'Simplest format' => 'drush qd --domain=example.dev',
                  'Complete format' => 'drush quickstart-destroy all --domain=example.dev --codepath=/path/to/drupal',
                  'Destroy DNS (/etc/hosts)' => 'drush quickstart-destroy dns --domain=example.dev',
                  'Destroy Apache (/etc/apache2/sites-enabled/)' => 'drush quickstart-destroy apache --domain=example.dev',
                  'Destroy Database (mysql db and user)' => 'drush quickstart-destroy database --domain=example.dev',
                  'Destroy Code and files (~/webistes/<domain>)' => 'drush quickstart-destroy code --domain=example.dev --codepath=/path/to/drupal',
          ),
          'aliases' => array('qd'),
          'bootstrap' => DRUSH_BOOTSTRAP_DRUSH, // No bootstrap at all.
  );
  return $items;
}

/**
 * Implementation of hook_drush_help().
 */
function quickstart_drush_help($section) {
  switch ($section) {
  }
}

/**
 * Simple helper function to keep all the arguments in a list.
 * @return <type>
 */
function _quickstart_arg_list() {
  return array('code'=>'code', 'database'=>'database', 'apache'=>'apache', 'dns'=>'dns', 'install'=>'install');
}

/**
 * Helper function to check input parameters
 * @param  $required any parameters that are required
 * @return array  if $ret['fail'] is true, then check failed, and an error was logged.
 */
function _quickstart_params($required) {

  // check arguments
  $ret = drush_get_arguments();

  if (count($ret)==1) {
    $ret = array("all");
  }
  
  if(array_search("all", $ret)!==false) {
    $ret = _quickstart_arg_list();
  }

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

  if (strlen($ret['domain']) > 15) {
    $ret['fail'] = true;
    drush_log("  '--domain' must be less than 16 characters long.", 'error');
  }
  if (strlen($ret['domain']) < 1) {
    $ret['fail'] = true;
    drush_log("  '--domain' must be at least 1 characters long.", 'error');
  }

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
      drush_log("  '--$require' is a required option for this command.", 'error');
    }
  }
  return $ret;
}

/**
 * Drush callbackfunction for 'drush quickstart-create'.
 *
 * This function goes step-by-step in creating the new site.
 *
 * @reurn true on success
 */
function drush_quickstart_create() {

  $params = _quickstart_params(array('domain'));
  if (isset($params['fail'])) return drush_set_error(0, dt('Bad parameters.  Try "drush help quickstart-create"'));
  $domain = $params['domain'];

  $domain_ = str_replace('.','_',$domain);

  try {
    // can you say "object orientation..."
    if (array_search("database", $params)) {
      drush_log("Creating database: $domain_", 'ok');
      quickstart_create_database($domain, $params);
      drush_log(' ', 'ok');
    }
    if (array_search("code", $params)) {
      drush_log('Downloading code (this could take a minute, check network activity) ...', 'ok');
      quickstart_create_code($domain, $params);
      drush_log(' ', 'ok');
    }
    if (array_search("apache", $params)) {
      drush_log("Creating apache config (/etc/apache2/sites-enabled/$domain)", 'ok');
      quickstart_create_apache($domain, $params);
      drush_log(' ', 'ok');
    }
    if (array_search("dns", $params)) {
      drush_log('Creating dns config (/etc/hosts) ...', 'ok');
      quickstart_create_dns($domain, $params);
      drush_log(' ', 'ok');
    }
    if (array_search("install", $params)) {
      drush_log('Running installer ...', 'ok');
      quickstart_create_install($domain, $params);
      drush_log(' ', 'ok');
    }
  } catch (Exception $e) {
    $message = $e->getMessage();
    drush_log("Command failed: $message", "error");
    return false;
  }

  drush_log("Command completed successfully.", "success");
  return true;
}

/**
 * Drush callback function for 'drush quickstart-destroy'
 *
 * Works step-by-step to destroy the site.
 *
 * @return true on success
 */
function drush_quickstart_destroy() {

  $params = _quickstart_params(array('domain'));
  if (isset($params['fail'])) return drush_set_error(0, dt('Bad parameters.  Try "drush help quickstart-destroy"'));
  $domain = $params['domain'];

  try {
    // can you say "object orientation..."
    if (array_search("install", $params)) {
      drush_log('Destroying installation ...', 'ok');
      quickstart_destroy_install($domain, $params);
      drush_log('... installation done.', 'ok');
    }
    if (array_search("code", $params)) {
      drush_log('Destroying code ...', 'ok');
      quickstart_destroy_code($domain, $params);
      drush_log('... code done.', 'ok');
    }
    if (array_search("database", $params)) {
      drush_log('Destroying database [domain] ...', 'ok');
      quickstart_destroy_database($domain, $params);
      drush_log('... database done.', 'ok');
    }
    if (array_search("apache", $params)) {
      drush_log("Destroying apache config (/etc/apache2/sites-enabled/$domain) ...", 'ok');
      quickstart_destroy_apache($domain, $params);
      drush_log('... apache config done.', 'ok');
    }
    if (array_search("dns", $params)) {
      drush_log('Destroying dns config (/etc/hosts) ...', 'ok');
      quickstart_destroy_dns($domain, $params);
      drush_log('... dns config done.', 'ok');
    }
  } catch (Exception $e) {
    $message = $e->getMessage();
    drush_log("Command failed: $message", "error");
    return false;
  }

  drush_log("Command completed successfully.", "success");
  return true;
}

