#!/usr/bin/php
<?php
$content = file_get_contents('php://stdin');
preg_match('|^To: (.*)|', $content, $address);
$filename = "/home/quickstart/websites/logs/mail/" . date('Y-m-d_H:i:s') . '--' . $address[1] . '.txt'; 
file_put_contents($filename, $content);
chmod($filename, 0666);
?>
