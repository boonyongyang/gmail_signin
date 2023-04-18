<?php
header('Content-Type: application/json');
date_default_timezone_set('Asia/Kuala_Lumpur');

$response = array(
    'dateTime' => date('Y-m-d H:i:s')
);

echo json_encode($response);
?>
