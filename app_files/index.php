<h1>This request is handeled by the server working on <?php echo $_SERVER['SERVER_ADDR'] ?></h1>
<?php $host = "container_mysql";
$user = "dev";
$pass = "dev123";
$db = "myTest";
try {
    $conn = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
 
    echo "Connected successfully";
} catch(PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}
?>
<? phpinfo()?>