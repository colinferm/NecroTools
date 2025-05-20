<?php
/* 
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
}; */

class PasswordUtils {
	private static $PASSWORD_DICT = [
		'LETTERS' => [
				'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 
				'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
				'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
		],
		'SYMBOLS' => ['!', '?', '#', '%', '&', '+']
	];

	public static function buildPassword($minLen = 12, $maxLen = 14) {
		$len = rand($minLen, $maxLen);
		$passwd = "";
		for ($i = 0; $i < $len; $i++) {
			$letter = rand(1, 4);
			if (strlen($passwd) == 0 || $letter < 4) {
				$passwd .= static::buildPassBlock(3, 4, static::$PASSWORD_DICT['LETTERS']);
			} else {
				$passwd .= static::buildPassBlock(1, 3, static::$PASSWORD_DICT['SYMBOLS']);
			}
			$i = strlen($passwd);
		}
		if (strlen($passwd) > $len) $passwd = substr($passwd, 0, $len);
		return $passwd;
	}

	private static function buildPassBlock($min, $max, $dict) {
		$len = rand($min, $max);
		$block = "";
		for ($i = 0; $i < $len; $i++) {
			$idx = rand(0, count($dict) - 1);
			$block .= $dict[$idx];
		}
		$uppercase = rand(0, 1);
		if ($uppercase) $block = strtoupper($block);
		return $block;
	}
}

class AuthenticationException extends Exception {}
class DatabaseException extends Exception {}
?>