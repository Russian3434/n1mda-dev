<?php

$latitude = $_REQUEST['LATITUDE'];
$longitude = $_REQUEST['LONGITUDE'];
$altitude = $_REQUEST['ALTITUDE'];
$random = $_REQUEST['RANDOM'];

mail("axelmoller5@gmail.com", "GPS Results", $latitude + $longitude + $altitude + $random, "From: iphone@mobile");
?>
