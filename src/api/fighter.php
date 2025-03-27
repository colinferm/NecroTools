<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class FighterController extends SlimController {

	public static function getSkills() {
		global $ndb;
		$query = "
			SELECT s.id, s.skill_name FROM {$ndb->skill} s ORDER BY s.skill_name ASC
		";
		return $ndb->query($query);
	}

	public static function getSkillsJSON() {
		global $cache;
		$skills = $cache->get("fighter-skills");
		if (!$skills) {
			$skills = json_encode(FighterController::getSkills());
			$cache->set("fighter-skills", $skills);
		}
		return $skills;
	}

	public static function getFighterRoles() {
		global $ndb;
		$query = "
			SELECT r.id, r.role_name, r.heirarchy_role, r.gang_id, t.type_name AS gang FROM {$ndb->fighter_role} r, {$ndb->gang_type} t WHERE r.gang_id = t.id ORDER BY r.gang_id ASC, id ASC
		";
		$results = $ndb->query($query);
		$roles = array();
		foreach ($results as $r) {
			$gangId = $r['gang_id'];
			$roles[$gangId][] = $r;
		}
 		return $roles;
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
			f.movement, f.weapon_skill, f.balistic_skill, f.strength, f.toughness, f.wounds, f.initiative, f.attacks,
			f.leadership, f.cool, f.willpower, f.intelligence, 
			f.is_vehicle, f.is_convalescence, f.is_captured, f.experience, f.advancements, f.base_value, f.view_order
			FROM {$ndb->user_fighter} f
			LEFT JOIN {$ndb->fighter_role} fr ON (fr.id = f.fighter_role)
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
			SELECT f.id, f.fighter_name, f.fighter_role, f.backstory, f.advancements, 
			f.movement, f.weapon_skill, f.balistic_skill, f.strength, f.toughness, f.toughness_side, f.toughness_rear,  
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
					user_gang_id, fighter_name, fighter_role, backstory, movement, weapon_skill, balistic_skill, strength,
					toughness, toughness_side, toughness_rear, wounds, initiative, attacks, handling, leadership, cool, willpower, intelligence,
					save_roll, is_vehicle, is_convalescence, is_captured, experience, advancements, base_value, view_order, created
				) VALUES (
					:user_gang_id, :fighter_name, :fighter_role, :backstory, :movement, :weapon_skill, :balistic_skill, :strength,
					:toughness, :toughness_side, :toughness_rear, :wounds, :initiative, :attacks, :handling, :leadership, :cool, :willpower, :intelligence,
					:save_roll, :is_vehicle, :is_convalescence, :is_captured, :experience, 0, :base_value, :view_order, NOW()
				)
			";
		} else {
			$query = "
				INSERT INTO {$ndb->user_fighter}
				(
					user_gang_id, fighter_name, fighter_role, backstory, movement, weapon_skill, balistic_skill, strength,
					toughness, wounds, initiative, attacks, leadership, cool, willpower, intelligence,
					is_vehicle, is_convalescence, is_captured, experience, advancements, base_value, view_order, created
				) VALUES (
					:user_gang_id, :fighter_name, :fighter_role, :backstory, :movement, :weapon_skill, :balistic_skill, :strength,
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
		$fighterId = $args['id'];
		$injury = json_decode($request->getBody(), true);


	}

	public function addInjury(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;

		$auditMessage;
		$fighterId = $args['id'];
		$injury = json_decode($request->getBody(), true);

		$insertInjurySQL = "INSERT INTO {$ndb->user_fighter_injury_map} (user_fighter_id, injury_id) VALUES (:user_fighter_id, :injury_id);
		$result = $ndb->update($query, array('user_fighter_id' => $fighterId, 'injury_id' => $injury->id);

		$fighter = $this->getFighterByID($args['id']);
		if ($injury['id'] == 1) {
			$fighter['cool'] += 1;
			$auditMessage = "Injury: Impressive Scars: Cool +1";

		} else if ($injury['id'] == 2) {
			// add skill fearsome

		} else if ($injury['id'] == 3) {
			// add skill beserker

		} else if ($injury['id'] == 4) {
			// add old battle wound

		} else if ($injury['id'] == 5) {
			$fighter['leadership'] -= 1;
			$auditMessage = "Injury: Partially Deafened: -1 Leadership";

		}  else if ($injury['id'] == 6) {
			$fighter['cool'] -= 1;
			$auditMessage = "Injury: Humiliated: -1 Cool";
			
		} else if ($injury['id'] == 7) {
			$fighter['balistic_skill'] -= 1;
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