<?php

$api_url = 'https://api.roblox.com/users/1409390355/onlinestatus/';
$lol = true;
$doit = true;
$json_data = file_get_contents($api_url);
$response_data = json_decode($json_data);
//$user_data = $response_data->data;

//$user_data = array_slice($user_data, 0, 9);

// Print data if need to debug
//print_r($response_data);

// Traverse array and display user data
//foreach ($user_data as $user) {
	echo '{"data":'.($response_data->IsOnline ? "true": "false")."}";
//}

?>
