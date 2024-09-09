<?php
function getDb() {
	$dsn = DB_TYPE.':dbname='.DB_NAME.';host='.DB_HOST;
	$db = new PDO($dsn, DB_USER, DB_PASS);
	return $db;
}

function dbQuery($query, $args = array(), $db = null) {
	if (is_null($db)) $db = getDb();
	$data = array();

	$stmt = $db->prepare($query);
	$stmt->setFetchMode(PDO::FETCH_ASSOC);
	$stmt->execute($args);
	return $stmt->fetchAll();
}

function dbUpdate($query, $args) {
	$db = getDb();
	$stmt = $db->prepare($query);
	$stmt->setFetchMode(PDO::FETCH_ASSOC);
	return $stmt->execute($args);
}

function dbInsert($query, $args) {
	$db = getDb();
	$stmt = $db->prepare($query);
	$result = $stmt->execute($args);
	if ($result) {
		return $db->lastInsertId;
	}
	return $result;
}

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