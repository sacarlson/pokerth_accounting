
<?php
//$servername = "localhost";
//$username = "username";
//$password = "password";
//$dbname = "pokerth_acc";
include('../config.php'); 
// example input
// poker.surething.biz/player_list?playernick=scotty243&account=aaasssdddfffjjj

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);
// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

$playernick = htmlspecialchars($_GET["playernick"]);
$acc = htmlspecialchars($_GET["account"]);

if ($playernick == "notset") {
  exit;
}

if (strlen($playernick) < 2) {
  exit;
}

$sql = "REPLACE INTO Players (PlayerNick, AccountID,Date_Created) VALUES ('" . $playernick . "','" . $acc . "',NOW())";


if (mysqli_query($conn, $sql)) {
    //echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

# this doesn't work
#$sql = "UPDATE SET Visites = Visites + 1  WHERE PlayerNick = '" . $playernick . "'";
#$result = mysqli_query($conn, $sql)
#if ($result) {
    //echo "New record created successfully";
#} else {
#    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
#}

//json_encode($c)
$query = 'SELECT * FROM Players';
$result = mysqli_query($conn,$query) or die('Query failed: ' . mysql_error());

$outerstack = [];
while ($line = mysqli_fetch_assoc($result)) {
    $stack = [];
    foreach ($line as $col_value) {
        array_push($stack, $col_value);
    }
    array_push($outerstack, $stack);
}
$output = json_encode($outerstack);
echo "$output";

// Free resultset
//mysqli_free_result($result);
mysqli_close($conn);

?>
 
