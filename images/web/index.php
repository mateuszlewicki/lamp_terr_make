<!DOCTYPE html>
<html>
<body>

<?php
print gethostname();
try {
    $dbh = new PDO('mysql:host=db;dbname=mlewicki', 'mlewicki', 'mlewicki');
    foreach($dbh->query('SELECT * from test') as $row) {
        print_r($row);
    }
    $dbh = null;
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}
?>

</body>
</html>