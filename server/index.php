<?php
#$servername = "localhost";
#$username = "username";
#$password = "password";
#$dbname = "pokerth_acc";
include('config.php'); 
// display pokerth_acc database in a table format for human browser viewing

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);
// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}


$top = '<table border="1">
  <tr>
    <th>ID</th>
    <th>Nickname</th>
    <th>StellarAcc</th>
    <th>Date Updated</th>
    <th>Visits</th>
    <th>STR_Bal</th>
    <th>CHP_Bal</th>
  </tr>
  <tr>';

$query = 'SELECT * FROM Players';
$result = mysqli_query($conn,$query) or die('Query failed: ' . mysql_error());

echo $top;
//  <td>sacarlson</td>
while ($line = mysqli_fetch_assoc($result)) {

    foreach ($line as $col_value) {
       echo "<td>" . $col_value . "</td>";
    }
    echo "</tr><tr>";
}

// Free resultset
//mysqli_free_result($result);
mysqli_close($conn);

?>
