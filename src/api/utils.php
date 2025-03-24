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
	public $user = DB_PREFIX.'user';
	public $gang_type = DB_PREFIX.'gang_type';
	public $fighter_template = DB_PREFIX.'fighter_template';
	public $fighter_role = DB_PREFIX.'gang_fighter_role';
	public $fighter_role_skill_set_map = DB_PREFIX.'gang_fighter_role_skill_set_map';
	public $weapon = DB_PREFIX.'weapon';
	public $weapon_category = DB_PREFIX.'weapon_category';
	public $weapon_characteristic = DB_PREFIX.'weapon_characteristic';
	public $weapon_trait = DB_PREFIX.'weapon_trait';
	public $weapon_trait_characteristic_map = DB_PREFIX.'weapon_trait_characteristic_map';
	public $skill_set = DB_PREFIX.'fighter_skill_set';
	public $skill = DB_PREFIX.'fighter_skill';
	public $wargear = DB_PREFIX.'fighter_gear';
	
	public $user_gang = DB_PREFIX.'user_gang';
	public $user_fighter = DB_PREFIX.'user_fighter';
	public $user_gang_stash_map = DB_PREFIX.'user_gang_stash_map';
	public $user_fighter_weapon_map = DB_PREFIX.'user_fighter_weapon_map';
	public $user_fighter_skill_map = DB_PREFIX.'user_fighter_skill_map';
	public $user_fighter_gear_map = DB_PREFIX.'user_fighter_gear_map';
	
	private $db = null;
	
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