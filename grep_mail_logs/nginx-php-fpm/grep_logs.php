<?php
//$debug_log = "/var/log/grep_logs.log";

if ( empty($_POST) ) {

//file_put_contents($debug_log, date("Y-m-d H:i:s")."\nPOST empty\n\n", FILE_APPEND);
?>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<form action="index.php" method="post">
Искомый E-Mail адрес (или Exim ID): <input type="text" name="email"><br>
<input type="submit">
</form>

</body>
</html>

<?php
} else {
?>

<body>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<pre>

<?php
//file_put_contents($debug_log, date("Y-m-d H:i:s")."\nPOST not empty - $_POST[email]\n\n", FILE_APPEND);

$root = (!empty($_SERVER['HTTPS']) ? 'https' : 'http') . '://' . $_SERVER['HTTP_HOST'] . '/';

//$hostname = getenv('HTTP_HOST');
//echo $hostname;

echo "<a href='$root'>Go back</a>\n\n";

echo "E-Mail (or Exim ID) entered: ".$_POST["email"]."\n\n";

//$output = shell_exec('grep -ih '.$_POST["email"].' /usr/share/nginx/html/logs/maillog');
$output = shell_exec('grep -iRh '.$_POST["email"].' /usr/share/nginx/html/logs/');
echo "$output";
?>

</pre>
</body>
</html>

<?php
}
?>
