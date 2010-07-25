#!/usr/bin/php
<?php
$input = file_get_contents('php://stdin');
preg_match('|^To: (.*)|', $input, $matches);
$t = tempnam("/home/quickstart/websites/logs/mail", $matches[1]);
file_put_contents($t, $input);
chmod($t, 0644);
