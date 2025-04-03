<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class FighterController extends SlimController {

	public static function getSkills($id = 0) {
		global $ndb;
		$params = array();
		$query = "
			SELECT ss.id, ss.skill_set_name, ss.limited_to_gang, ss.gang_type_id, gt.type_name AS gang_name
			FROM {$ndb->skill_set} ss
			LEFT JOIN {$ndb->gang_type} gt ON ss.gang_type_id = gt.id
			WHERE 1 = 1
		";

		if ($id > 0) {
			$query .= "
				AND ss.id = :ss_id
			"; 	
			$params['ss_id'] = $id;
		}

		$query .= "
			ORDER BY ss.skill_set_name ASC
		";
		$results = $ndb->query($query, $params);

		$skillSets = array();
		foreach ($results as $s) {
			$query = "
				SELECT s.id, s.skill_name, s.skill_set_id, s.skill_description  
				FROM {$ndb->skill} s 
				WHERE s.skill_set_id = :skillset_id
				ORDER BY s.skill_name ASC
			";
			$skills = $ndb->query($query, array("skillset_id" => $s['id']));
			$s['skills'] = $skills;
			$skillSets[] = $s;
		}
		if ($id > 0) return $skillSets[0];
		return $skillSets;
	}

	public static function getSkillsJSON() {
		global $cache;
		$skills = null;
		$skills = $cache->get("fighter-skills");
		if (!$skills) {
			$skills = json_encode(FighterController::getSkills());
			$cache->set("fighter-skills", $skills);
		}
		return $skills;
	}

	public function skills(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$skills = FighterController::getSkills();
		$response->getBody()->write(json_encode($skills));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function getSkillSet(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$skills = FighterController::getSkills($args['id']);
		$response->getBody()->write(json_encode($skills));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addUpdateSkillSet(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;

		$id = (array_key_exists('id', $args)) ? $args['id'] : 0;

		$skillSet = json_decode($request->getBody(), true);
		unset($skillSet['skills']);
		unset($skillSet['gang_name']);
		if ($request->getMethod() == 'POST') {
			unset($skillSet['id']);

			$insertQuery = "INSERT INTO {$ndb->skill_set} (skill_set_name, limited_to_gang, gang_type_id) VALUES (:skill_set_name, :limited_to_gang, :gang_type_id)";
			if ($ndb->insert($insertQuery, $skillSet)) {
				$skillSet['id'] = $ndb->lastInsertId;
			}

		} else {
			$ndb->updateTable($ndb->skill_set, $skillSet);
			/* $updateQuery = "UPDATE {$ndb->skill_set} SET ";
			$i = 0;
			foreach ($skillSet as $key => $val) {
				if ($key == 'id') continue;
				if ($i > 0) $updateQuery .= ", ";
				$updateQuery .= "{$key} = :{$key}";
				$i++;
			}
			$updateQuery .= " WHERE id = :id";
			$result = $ndb->update($updateQuery, $skillSet); */
			$skillSet = FighterController::getSkills($id);
		}

		$response->getBody()->write(json_encode($skillSet));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function fetchSkill($id) {
		global $ndb;

		$skillQuery = "
			SELECT s.id, s.skill_set_id, s.skill_name, s.skill_description, ss.skill_set_name
			FROM {$ndb->skill} s, {$ndb->skill_set} ss 
			WHERE s.skill_set_id = ss.id
			AND s.id = :id
		";
		return $ndb->query($skillQuery, array("id" => $id));
	}

	public function getSkill(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$id = $args['id'];

		$skill = $this->fetchSkill($id);

		$response->getBody()->write(json_encode($skill));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addUpdateSkill(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;

		$id = (array_key_exists('id', $args)) ? $args['id'] : 0;
		$skill = json_decode($request->getBody(), true);
		unset($skill['skill_set_name']);

		if ($request->getMethod() == 'POST') {
			unset($skill['id']);
			$insertQuery = "INSERT INTO {$ndb->skill} (skill_set_id, skill_name, skill_description) VALUES (:skill_set_id, :skill_name, :skill_description)";
			if ($result = $ndb->insert($insertQuery, $skill)) {
				$id = $ndb->lastInsertId;
			}
		} else {
			$ndb->updateTable($ndb->skill, $skill);
		}
		$skills = $this->fetchSkill($id);
		if (is_array($skills)) $skill = $skills[0];
		$response->getBody()->write(json_encode($skill));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function deleteSkill(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$id = $args['id'];
		$result = $ndb->deleteFromTable($ndb->skill, $id);
		if ($result) {
			$response->withStatus(200);
		} else {
			$response->withStatus(500);
		}
		return $response;
	}

	public static function getFighterRoles() {
		global $ndb;
		$query = "
			SELECT r.id, r.role_name, r.heirarchy_role, r.gang_id, t.type_name AS gang FROM {$ndb->fighter_role} r, {$ndb->gang_type} t WHERE r.gang_id = t.id ORDER BY r.gang_id ASC, id ASC
		";
		$results = $ndb->query($query);
		$gangRoles = array();
		$gangId = 0;
		$gang = array();
		foreach ($results as $r) {
			if ($gangId != $r['gang_id']) {
				if ($gangId > 0) $gangRoles[] = $gang;
				$gangId = $r['gang_id'];
				$gang = array(
					'gang_id' => $gangId,
					'gang_name' => $r['gang'],
					'roles' => array()
				);
			}
			unset($r['gang_id']);
			unset($r['gang']);
			$gang['roles'][] = $r;
		}
		$gangRoles[] = $gang;

 		return $gangRoles;
	}

	public static function getFighterRolesJSON() {
		global $cache;
		$roles = $cache->get("fighter-roles");
		if (!$roles) {
			$roles = json_encode(FighterController::getFighterRoles());
			$cache->set("fighter-roles", $roles);
		}
		return $roles;
	}

	public static function getInjuries() {
		global $ndb;
		$query = "
			SELECT id, name, description, convalescence FROM {$ndb->injury} ORDER BY id ASC
		";
		return $ndb->query($query);
	}

	public static function getInjuriesJSON() {
		global $cache;
		$inj = $cache->get("fighter-injuries");
		if (!$inj) {
			$inj = json_encode(FighterController::getInjuries());
			$cache->set("fighter-injuries", $inj);
		}
		return $inj;
	}

	public static function getFightersForGang($gangId) {
		global $ndb;
		$query = "
			SELECT f.id, f.fighter_name, fr.role_name, f.backstory, 
			f.movement, f.weapon_skill, f.ballistic_skill, f.strength, f.toughness, f.wounds, f.initiative, f.attacks,
			f.leadership, f.cool, f.willpower, f.intelligence, 
			f.is_vehicle, f.is_convalescence, f.is_captured, f.experience, f.advancements, f.base_value, f.view_order
			FROM {$ndb->user_fighter} f
			LEFT JOIN {$ndb->fighter_role} fr ON (fr.id = f.fighter_role_id)
			WHERE f.user_gang_id = :user_gang_id
			ORDER BY f.view_order
		";
		return $ndb->query($query, ['user_gang_id' => $gangId]);
	}

	public function fetchGangFighters(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$gangId = $args['id'];
		$fighters = FighterController::getFightersForGang($gangId);
		$response->getBody()->write(json_encode($fighters));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function fetchFighter(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$fighter = $this->getFighterByID($args['id']);

		$response->getBody()->write(json_encode($fighter));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function getFighterByID($fighterId): array {
		global $ndb;
		$query = "
			SELECT f.id, f.fighter_name, f.fighter_role_id, f.backstory, f.advancements, 
			f.movement, f.weapon_skill, f.ballistic_skill, f.strength, f.toughness, f.toughness_side, f.toughness_rear,  
			f.handling, f.save_roll, f.wounds, f.initiative, f.attacks, f.leadership, f.cool, f.willpower, f.intelligence, 
			f.is_vehicle, f.is_convalescence, f.is_captured, f.experience, f.base_value, f.view_order
			FROM {$ndb->user_fighter} f
			WHERE f.id = :id
			ORDER BY f.view_order
		";
		$fighter = $ndb->queryFirst($query, ['id' => $fighterId]);
		$fighter['weapons'] = WeaponController::getWeaponsForFighter($fighterId);

		return $fighter;
	}

	public function addFighter(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$fighter = json_decode($response->getBody());

		if ($fighter['is_vehicle']) {
			$query = "
				INSERT INTO {$ndb->user_fighter}
				(
					user_gang_id, fighter_name, fighter_role_id, backstory, movement, weapon_skill, ballistic_skill, strength,
					toughness, toughness_side, toughness_rear, wounds, initiative, attacks, handling, leadership, cool, willpower, intelligence,
					save_roll, is_vehicle, is_convalescence, is_captured, experience, advancements, base_value, view_order, created
				) VALUES (
					:user_gang_id, :fighter_name, :fighter_role_id, :backstory, :movement, :weapon_skill, :ballistic_skill, :strength,
					:toughness, :toughness_side, :toughness_rear, :wounds, :initiative, :attacks, :handling, :leadership, :cool, :willpower, :intelligence,
					:save_roll, :is_vehicle, :is_convalescence, :is_captured, :experience, 0, :base_value, :view_order, NOW()
				)
			";
		} else {
			$query = "
				INSERT INTO {$ndb->user_fighter}
				(
					user_gang_id, fighter_name, fighter_role_id, backstory, movement, weapon_skill, ballistic_skill, strength,
					toughness, wounds, initiative, attacks, leadership, cool, willpower, intelligence,
					is_vehicle, is_convalescence, is_captured, experience, advancements, base_value, view_order, created
				) VALUES (
					:user_gang_id, :fighter_name, :fighter_role_id, :backstory, :movement, :weapon_skill, :ballistic_skill, :strength,
					:toughness, :wounds, :initiative, :attacks, :leadership, :cool, :willpower, :intelligence,
					:is_vehicle, :is_convalescence, :is_captured, :experience, 0, :base_value, :view_order, NOW()
				)
			";
		}

		$result = $ndb->insert($query, $fighter);
		if ($result) {
			$fighter['id'] = $result;
			$response->getBody()->write(json_encode($fighter));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}

	public function updateFighter(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$fighter = json_decode($request->getBody(), true);
		$weapons = array();
		if (array_key_exists('weapons', $fighter)) {
			$weapons = $fighter['weapons'];
			unset($fighter['weapons']);
		}
		$auditMessage;
		$updateQuery = "UPDATE {$ndb->user_fighter} SET ";
		$i = 0;
		foreach(array_keys($fighter) as $key) {
			if ($key == 'audit') {
				$auditMessage = $fighter[$key];
				unset($fighter[$key]);
				continue;
			}
			if ($key == 'role_name') continue;
			if ($i > 0) $updateQuery .= ", ";
			$updateQuery .=  "{$key} = :{$key}";
			$i++;
		}
		$updateQuery .= " WHERE id = :id";
		//error_log($updateQuery);

		$result = $ndb->update($updateQuery, $fighter);
		if ($result) {
			if (strlen($auditMessage)) $this->addFighterAudit($fighter['id'], $auditMessage);
			$response->getBody()->write(json_encode($fighter));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}

	private function addFighterAudit($fighterId, $message) {
		global $ndb;
		$auditSQL = "INSERT INTO {$ndb->user_fighter_audit} (user_fighter_id, created, description) VALUES (:user_fighter_id, NOW(), :description)";
		$result = $ndb->insert($auditSQL, ['user_fighter_id' => $fighterId, 'description' => $message]);
	}

	public function addInjury(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;

		$auditMessage;
		$fighterId = $args['id'];
		$injury = json_decode($request->getBody(), true);

		$insertInjurySQL = "INSERT INTO {$ndb->user_fighter_injury_map} (user_fighter_id, injury_id) VALUES (:user_fighter_id, :injury_id)";
		$result = $ndb->update($query, array('user_fighter_id' => $fighterId, 'injury_id' => $injury->id));

		$fighter = $this->getFighterByID($fighterId);
		if ($injury['id'] == 1) {
			$fighter['cool'] += 1;
			$auditMessage = 'Injury: Impressive Scars: Cool +1';

		} else if ($injury['id'] == 2) {
			// add skill fearsome
			error_log('Add fearsome skill');

		} else if ($injury['id'] == 3) {
			// add skill beserker
			error_log('Add beserker skill');

		} else if ($injury['id'] == 4) {
			// add old battle wound
			error_log('Stack battle wound');

		} else if ($injury['id'] == 5) {
			$fighter['leadership'] -= 1;
			$auditMessage = "Injury: Partially Deafened: -1 Leadership";

		}  else if ($injury['id'] == 6) {
			$fighter['cool'] -= 1;
			$auditMessage = "Injury: Humiliated: -1 Cool";
			
		} else if ($injury['id'] == 7) {
			$fighter['ballistic_skill'] -= 1;
			$auditMessage = "Injury: Eye Injury: -1 BS";
			
		} else if ($injury['id'] == 8) {
			$fighter['weapon_skill'] -= 1;
			$auditMessage = "Injury: Hand Injury: -1 WS";
			
		}  else if ($injury['id'] == 9) {
			$fighter['movement'] -= 1;
			$auditMessage = "Injury: Hobbled: -1 M";
			
		}  else if ($injury['id'] == 10) {
			$fighter['strength'] -= 1;
			$auditMessage = "Injury: Spinal Injury: -1 S";
			
		}  else if ($injury['id'] == 11) {
			$fighter['toughness'] -= 1;
			$auditMessage = "Injury: Enfeebled: -1 T]";
			
		}  else if ($injury['id'] == 12) {
			$fighter['intelligence'] -= 1;
			$fighter['willpower'] -= 1;
			$auditMessage = "Injury: Head Injury: Int -1, Will -1";
			
		}

		if ($result) {
			if (strlen($auditMessage)) $this->addFighterAudit($fighterId, $auditMessage);
			$response->getBody()->write(json_encode($fighter));
			return $response->withHeader('Content-Type', 'application/json');
		}
	}
}
?>