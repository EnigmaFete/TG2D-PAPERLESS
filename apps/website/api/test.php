<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "PHP Version: " . phpversion() . "<br>";
echo "PDO Drivers: " . implode(', ', PDO::getAvailableDrivers()) . "<br>";

try {
    require_once __DIR__ . '/db.php';
    echo "db.php loaded OK<br>";
    $pdo = tg2d_get_db();
    echo "DB connected OK<br>";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "<br>";
}
