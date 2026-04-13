<?php
class NecroDB {
	public $user = DB_PREFIX.'user';
	public $permission = DB_PREFIX.'user_permission';
	public $permission_map = DB_PREFIX.'user_permission_map';
	public $preferences = DB_PREFIX.'user_preference';
	public $preference_map = DB_PREFIX.'user_preference_map';
	
	public $lookups = DB_PREFIX.'lookups';

	public $gang_type = DB_PREFIX.'gang_type';
	public $fighter_template = DB_PREFIX.'fighter_template';
	public $fighter_role = DB_PREFIX.'gang_fighter_role';
	public $fighter_role_skill_set_map = DB_PREFIX.'gang_fighter_role_skill_set_map';
	public $injury_advancement = DB_PREFIX.'gang_fighter_injury_advancement';

	public $weapon = DB_PREFIX.'weapon';
	public $weapon_category = DB_PREFIX.'weapon_category';
	public $weapon_characteristic = DB_PREFIX.'weapon_characteristic';
	public $weapon_trait_characteristic_map = DB_PREFIX.'weapon_trait_characteristic_map';

	public $skill_set = DB_PREFIX.'fighter_skill_set';
	public $skill = DB_PREFIX.'fighter_skill';
	
	public $user_gang = DB_PREFIX.'user_gang';
	public $user_gang_audit = DB_PREFIX.'user_gang_audit';
	public $user_gang_stash_map = DB_PREFIX.'user_gang_stash_map';
	public $user_gang_trait_map = DB_PREFIX.'user_gang_special_trait_map';

	public $user_fighter = DB_PREFIX.'user_fighter';
	public $user_fighter_audit = DB_PREFIX."user_fighter_audit";
	public $user_fighter_weapon_map = DB_PREFIX.'user_fighter_weapon_map';
	public $user_fighter_weapon_characteristic_map = DB_PREFIX.'user_fighter_weapon_characteristic_map';
	public $user_fighter_skill_map = DB_PREFIX.'user_fighter_skill_map';
	public $user_fighter_injury_advancement_map = DB_PREFIX.'user_fighter_injury_advancement_map';
	public $user_fighter_trait_map = DB_PREFIX.'user_fighter_special_trait_map';

	public $fighter_archetype = DB_PREFIX.'archetype';
	public $fighter_archetype_skill_set_map = DB_PREFIX."archetype_skill_set_map";
	
	private $db = null;

	public $lastInsertId;
	
	public function getInstance() {
		if (is_null($this->db)) {
			$dsn = DB_TYPE.':dbname='.DB_NAME.';host='.DB_HOST;
			$this->db = new PDO($dsn, DB_USER, DB_PASS);
		}
		return $this->db;
	}

	public function delete($query, $id) {
		return $this->deleteWithParams($query, ['id' => $id]);
	}

	public function deleteWithParams($query, $params) {
		$db = $this->getInstance();
	
		$stmt = $db->prepare($query);
		return $stmt->execute($params);
	}

	public function deleteFromTable($tableName, $id) {
		$query = "DELETE FROM {$tableName} WHERE id = :id";
		return $this->delete($query, $id);
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
		//$this->bindParams($stmt, $args);

		return $stmt->execute($args);
	}

	function updateTable($table, $args) {
		$db = $this->getInstance();

		$sql = "UPDATE {$table} SET ";
		$i = 0;
		foreach ($args as $key => $val) {
			if ($key == 'id') continue;
			if ($key == 'created') continue;
			if ($i > 0) $sql .= ", ";
			if ($key == 'last_mod') {
				$sql .= "last_mod = NOW()";
			} else {
				$sql .= "{$key} = :{$key}";
			}
			$i++;
		}
		$sql .= " WHERE id = :id";
		unset($args['created']);
		unset($args['last_mod']);

		return $this->update($sql, $args);
	}
	
	function insert($query, $args) {
		$db = $this->getInstance();
		
		$stmt = $db->prepare($query);
		$status = $stmt->execute($args);
		$this->lastInsertId = $db->lastInsertId();
		return $status;
	}

	function bindParams(&$stmt, $args) {
		foreach ($args as $key => $val) {
			if (strpos($key, 'id')) {
				$stmt->bindParam(':'.$key, intval($val), PDO::PARAM_INT);
			} else {
				$stmt->bindParam(':'.$key, $val, PDO::PARAM_STR);
			}
		}
	}
}
$ndb = new NecroDB();
?>