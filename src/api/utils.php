<?php

$authCheck = function($request, $response, $next) {
	$oauth = $request->getHeaderLine("Authorization");
	$token = null;
	error_log("AUTH={$oauth}",0);
	if (isset($oauth) && !empty($oauth)) {
		$token = $pairs[1];
	}
	//error_log("AUTH={$token}",0);
	//if oauth token not found in header, then look for token in "auth" cookie
	$sessionToken = isset($_COOKIE['auth']) ? $_COOKIE['auth'] : null;
	if (empty($token) && !empty($sessionToken)) {
		$token = $sessionToken;
	}

	if (!is_null($token)) {
		if (isset($_SESSION['user'])) {
			$user = $_SESSION['user'];
		}
		if (isset($user) && !is_null($user)) {
			if (!isset($user->oauth_key) || $user->oauth_key != $token) {
				$oauth = UserController::findOauth($token);
				if (!isset($oauth) || empty($oauth) || $oauth->id != $user->id) {
					unset($user);
				}
			}
		} 

		if (!isset($user) || is_null($user)) {
			$user = UserController::findOauth($token);
			if (!empty($user)) {
				$_SESSION['user'] = $user;
			}
		}
	}

	if (!isset($_SESSION['user'])) {
		error_log('  Not authorized', 0);
		throw new AuthenticationException();
	} 
	$response = $next($request, $response);
	return $response;
};

class AuthenticationException extends Exception {}
class DatabaseException extends Exception {}
?>