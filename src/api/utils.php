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

class NecroDB {
	public var $prefix = 'necro_';
	public var $user = $prefix.'user';
	public var $gang_type = $prefix.'gang_type';
	public var $fighter_template $prefix.'fighter_template';
	public var $fighter_role = $prefix.'gang_fighter_role';
	public var $fighter_role_skill_set_map = $prefix.'gang_fighter_role_skill_set_map';
	public var $weapon = $prefix.'weapon';
	public var $weapon_category = $prefix.'weapon_category';
	public var $weapon_characteristic = $prefix.'weapon_characteristic';
	public var $weapon_trait = $prefix.'weapon_trait';
	public var $weapon_trait_characteristic_map = $prefix.'weapon_trait_characteristic_map';
	public var $skill_set = $prefix.'fighter_skill_set';
	public var $skill = $prefix.'fighter_skill';
	public var $wargear = $prefix.'fighter_gear';
	
	public var $user_gang = $prefix.'user_gang';
	public var $user_fighter = $prefix.'user_fighter';
	public var $user_gang_stash_map = $prefix.'user_gang_stash_map';
	public var $user_fighter_weapon_map = $prefix.'user_fighter_weapon_map';
	public var $user_fighter_skill_map = $prefix.'user_fighter_skill_map';
	public var $user_fighter_gear_map = $prefix.'user_fighter_gear_map';
	
	private var $db = null;
	
	public function getInstance() {
		if (is_null($this->db)) {
			$dsn = DB_TYPE.':dbname='.DB_NAME.';host='.DB_HOST;
			$this->db = new PDO($dsn, DB_USER, DB_PASS);
		}
		return $this->db;
	}
	
	public function query($query, $args = array()) {
		$db = $this->getInstance();
		$data = array();
	
		$stmt = $db->prepare($query);
		$stmt->setFetchMode(PDO::FETCH_ASSOC);
		$stmt->execute($args);
		return $stmt->fetchAll();
	}
	
	public function queryFirst($query, $args = array()) {
		$db = $this->getInstance();
		$data = array();
	
		$stmt = $db->prepare($query);
		$stmt->setFetchMode(PDO::FETCH_ASSOC);
		$stmt->execute($args);
		return $stmt->fetch();
	}
	
	function update($query, $args) {
		$db = $this->getInstance();
		
		$stmt = $db->prepare($query);
		$stmt->setFetchMode(PDO::FETCH_ASSOC);
		return $stmt->execute($args);
	}
	
	function insert($query, $args) {
		$db = $this->getInstance();
		
		$stmt = $db->prepare($query);
		$result = $stmt->execute($args);
		if ($result) {
			return $db->lastInsertId;
		}
		return $result;
	}
}
$ndb = new NecroDB();
?>