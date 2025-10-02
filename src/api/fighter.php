<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class FighterController extends SlimController {

	public static function getFighterRoles() {
		global $ndb;
		$query = "
			SELECT r.id, r.role_name, r.hierarchy_role, r.gang_type_id, t.type_name AS gang FROM {$ndb->fighter_role} r, {$ndb->gang_type} t WHERE r.gang_type_id = t.id ORDER BY r.gang_type_id ASC, id ASC
		";
		$results = $ndb->query($query);
		$gangRoles = array();
		$gangId = 0;
		$gang = array();
		foreach ($results as $r) {
			if ($gangId != $r['gang_type_id']) {
				if ($gangId > 0) $gangRoles[] = $gang;
				$gangId = $r['gang_type_id'];
				$gang = array(
					'gang_id' => $gangId,
					'gang_name' => $r['gang'],
					'roles' => array()
				);
			}
			unset($r['gang_type_id']);
			unset($r['gang']);
			$gang['roles'][] = $r;
		}
		$gangRoles[] = $gang;

 		return $gangRoles;
	}

	public static function getFighterRole($roleId) {
		global $ndb;
		$query = "
			SELECT r.id, r.role_name, r.hierarchy_role, r.gang_type_id, t.type_name AS gang FROM {$ndb->fighter_role} r, {$ndb->gang_type} t WHERE r.gang_type_id = t.id AND r.id = :role_id ORDER BY r.gang_type_id ASC, id ASC
		";
		return $ndb->queryFirst($query, ['role_id' => $roleId]);
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

	public function fetchFighterRoles(ServerRequestInterface $request, ResponseInterface $response): ResponseInterface {
		$roles = FighterController::getFighterRolesJSON();
		$response->getBody()->write($roles);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public static function fetchFighterRole(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$roleId = $args['id'];
		$role = null;
		$role = $cache->get("gang-role-{$roleId}");
		if (!$role) {
			$query = "
				SELECT 
					r.id AS role_id, r.role_name, r.hierarchy_role, r.gang_id,
					ft.id AS template_id, ft.movement, ft.weapon_skill, ft.balistic_skill, ft.strength, ft.toughness, ft.toughness_side, ft.toughness_rear,
					ft.wounds, ft.initiative, ft.attacks, ft.handling, ft.save_roll, ft.leadership, ft.cool, ft.willpower, ft.intelligence, ft.num_start_skills,
					ft.is_vehicle, ft.is_dramatis, ft.base_value, ft.view_order, created
				FROM {$ndb->fighter_role} r
				LEFT JOIN {$ndb->fighter_template} ft ON (ft.fighter_role = r.id)
				WHERE r.id = :id 
				ORDER BY r.hierarchy_role ASC, role_id ASC
				LIMIT 1
			";
			//AND (ft.is_dramatis = 0 OR ft.is_dramatis IS NULL)
			$results = $ndb->queryFirst($query, ['id' => $roleId]);
			$templates = json_encode($results);
			$cache->set("gang-role-{$roleId}", $role);
		}
		$response->getBody()->write($templates);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addUpdateFighterRole(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;

		$id = (array_key_exists('id', $args)) ? $args['id'] : 0;
		$role = json_decode($request->getBody(), true);

		$gangId = $role['gang_type_id'];
		$params = [
			'gang_type_id' => $gangId,
			'hierarchy_role' => $role['hierarchy_role'],
			'role_name' => $role['role_name']
		];
		if ($request->getMethod() == 'POST' && $id == 0) {
			$insertQuery = "INSERT INTO {$ndb->fighter_role} (gang_type_id, hierarchy_role, role_name) VALUES (:gang_type_id, :hierarchy_role, :role_name)";
			if ($ndb->insert($insertQuery, $params)) {
				$id = $ndb->lastInsertId;
				$role['id'] = $id;
			}

		} else {
			$params['id'] = $id;
			$ndb->updateTable($ndb->fighter_role, $params);
		}

		$cache->del(["gang-role-{$id}", "gang-roles-templates-{$gangId}"]);

		$response->getBody()->write(json_encode($role));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function deleteFighterRole(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$id = $args['id'];
		FighterController::deleteTemplateFighter($id);
		$response->withStatus(200);
		return $response;
	}

	public static function deleteTemplateFighter($id) {
		global $ndb, $cache;
		$gangResults = $ndb->queryFirst("SELECT gang_type_id FROM {$ndb->fighter_template} WHERE id = :id", ['id' => $id]);
		$gangId = $gangResults['gang_type_id'];

		$result = $ndb->delete("DELETE FROM {$ndb->fighter_template} WHERE id = :id", $id);
		$result = $ndb->delete("DELETE FROM {$ndb->fighter_role_skill_set_map} WHERE fighter_role_id = :id", $id);
		$result = $ndb->delete("DELETE FROM {$ndb->fighter_role} WHERE id = :id", $id);

		$cache->del(["gang-role-{$id}", "gang-roles-templates-{$gangId}", "gang-roles-{$gangId}"]);
	}

	public function fetchFighterRolesForGang(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$gangId = $args['id'];
		$roles = $cache->get("gang-roles-{$gangId}");
		if (!$roles) {
			$query = "
				SELECT r.id, r.role_name, r.hierarchy_role, r.gang_id
				FROM {$ndb->fighter_role} r 
				WHERE r.gang_type_id = :gang_id ORDER BY r.hierarchy_role ASC, id ASC
			";
			$results = $ndb->query($query, ['gang_id' => $gangId]);
			$roles = json_encode($results);
			$cache->set("gang-roles-{$gangId}", $roles);
		}
		$response->getBody()->write($roles);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public static function getFighterTemplate($roleId) {
		global $ndb;
		$query = "
			SELECT 
				ft.id AS template_id, ft.movement, ft.weapon_skill, ft.balistic_skill, ft.strength, ft.toughness, ft.toughness_side, ft.toughness_rear,
				ft.wounds, ft.initiative, ft.attacks, ft.handling, ft.save_roll, ft.leadership, ft.cool, ft.willpower, ft.intelligence, ft.num_start_skills,
				ft.is_vehicle, ft.is_dramatis, ft.base_value, ft.view_order, created
			FROM {$ndb->fighter_template} ft
			WHERE ft.fighter_role = :role_id 
		";
		//AND (ft.is_dramatis = 0 OR ft.is_dramatis IS NULL)
		return $ndb->queryFirst($query, ['role_id' => $roleId]);
	}

	public function fetchFighterTemplate(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$templateId = $args['id'];

		$template = null;
		$template = $cache->get("gang-fighter-template-{$templateId}");
		if (!$template) {
			$query = "
				SELECT 
					ft.id AS template_id, ft.movement, ft.weapon_skill, ft.balistic_skill, ft.strength, ft.toughness, ft.toughness_side, ft.toughness_rear,
					ft.wounds, ft.initiative, ft.attacks, ft.handling, ft.save_roll, ft.leadership, ft.cool, ft.willpower, ft.intelligence, ft.num_start_skills
					ft.is_vehicle, ft.is_dramatis, ft.base_value, ft.view_order, created
				FROM {$ndb->fighter_template} ft
				WHERE ft.id = :id 
			";
			//AND (ft.is_dramatis = 0 OR ft.is_dramatis IS NULL)
			$result = $ndb->queryFirst($query, ['id' => $templateId]);
			$template = json_encode($result);
			$cache->set("gang-fighter-template-{$templateId}", $template);
		}

		$response->getBody()->write($template);
		return $response->withHeader('Content-Type', 'application/json');
	}


	public function fetchGangTemplates(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$gangId = $args['id'];
		$gang = GangController::getGang($gangId);
		$templates = null;
		//$templates = $cache->get("gang-roles-templates-{$gangId}");
		if (!$templates) {
			$query = "
				SELECT 
					r.id, r.role_name, r.hierarchy_role, r.gang_type_id
				FROM {$ndb->fighter_role} r
				WHERE r.gang_type_id = :gang_id 
				ORDER BY r.hierarchy_role ASC, r.id ASC
			";
			$results = $ndb->query($query, ['gang_id' => $gangId]);
			foreach ($results as &$r) {
				$template = FighterController::getFighterTemplate($r['id']);
				$r['template'] = $template;
				$r['gang'] = $gang;
				$r['primary_skills'] = FighterController::getTemplateSkills($r['id'], $gangId, true);
				$r['secondary_skills'] = FighterController::getTemplateSkills($r['id'], $gangId, false);
			}
			$templates = json_encode($results);
			$cache->set("gang-roles-templates-{$gangId}", $templates);
		}
		$response->getBody()->write($templates);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public static function getTemplateSkills($roleId, $gangId, $primarySkill) {
		global $ndb;
		$isPrimary = 0;
		if ($primarySkill) $isPrimary = 1;
		$query = "
			SELECT s.id, s.skill_set_name, s.limited_to_gang, s.is_wyrd
			FROM {$ndb->skill_set} s, {$ndb->fighter_role_skill_set_map} m
			WHERE s.id = m.skill_set_id
			AND m.fighter_role_id = :role_id
			AND m.is_primary = :primary_skill
		";

		$results = $ndb->query($query, [
			'role_id' => $roleId, 
			'primary_skill' => $isPrimary
		]);
		if ($results) return $results;
		return [];
	}

	public static function getArchetypeSkills($archetypeId, $primarySkill) {
		global $ndb;
		$isPrimary = 0;
		if ($primarySkill) $isPrimary = 1;
		$query = "
			SELECT s.id, s.skill_set_name, s.limited_to_gang, s.is_wyrd
			FROM {$ndb->skill_set} s, {$ndb->fighter_archetype_skill_set_map} m
			WHERE s.id = m.skill_set_id
			AND m.archetype_id = :archetype_id
			AND m.is_primary = :primary_skill
		";

		$results = $ndb->query($query, [
			'archetype_id' => $archetypeId, 
			'primary_skill' => $isPrimary
		]);
		if ($results) return $results;
		return [];
	}

	public function updateTemplateSkills(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$roleId = $args['id'];
		$primary = $args['primary'];
		$skillSets = json_decode($request->getBody(), true);

		$role = FighterController::getFighterRole($roleId);
		$gangId = $role['gang_type_id'];

		$deleteSetMapping = "DELETE FROM {$ndb->fighter_role_skill_set_map} WHERE fighter_role_id = :role_id AND is_primary = :primary";
		$ndb->deleteWithParams($deleteSetMapping, [ 'role_id' => $roleId, 'primary' => $primary ]);

		foreach($skillSets as $ss) {
			$setId = $ss['id'];
			$insertQuery = "INSERT INTO {$ndb->fighter_role_skill_set_map} VALUES (:role_id, :set_id, :primary)";
			$ndb->insert($insertQuery, [ 'role_id' => $roleId, 'set_id' => $setId, 'primary' => $primary ]);
		}

		$cache->del(["gang-roles-templates-{$gangId}", "gang-roles-{$gangId}"]);

		$response->getBody()->write(json_encode($skillSets));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addUpdateTemplateStats(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;

		$roleId = $args['id'];
		$fighterRole = FighterController::getFighterRole($roleId);
		$gangId = $fighterRole['gang_type_id'];
		$statline = json_decode($request->getBody(), true);

		$templateId = (array_key_exists('template_id', $statline)) ? $statline['template_id'] : 0;
		unset($statline['template_id']);

		$statline['gang_type_id'] = $gangId;
		$statline['fighter_role'] = $roleId;

		if ($request->getMethod() == 'POST') {
			unset($statline['created']);
			unset($statline['last_mod']);

			$insertQuery = "
				INSERT INTO {$ndb->fighter_template}
				(
					gang_type_id, fighter_role, 
					movement, weapon_skill, balistic_skill, strength, toughness, toughness_side, toughness_rear,
					wounds, initiative, attacks, handling, save_roll, 
					leadership, cool, willpower, intelligence, 
					num_start_skills, is_vehicle, is_dramatis, 
					base_value, view_order, created, last_mod
				) VALUES (
					:gang_type_id, :fighter_role, 
					:movement, :weapon_skill, :balistic_skill, :strength, :toughness, :toughness_side, :toughness_rear,
					:wounds, :initiative, :attacks, :handling, :save_roll, 
					:leadership, :cool, :willpower, :intelligence, 
					:num_start_skills, :is_vehicle, :is_dramatis, 
					:base_value, :view_order, NOW(), NOW()
				)
			";
			$ndb->insert($insertQuery, $statline);
			$templateId = $ndb->lastInsertId;
			$statline['created'] = date("M d Y H:i:s");
		} else {
			$statline['id'] = $templateId;
			$ndb->updateTable($ndb->fighter_template, $statline);
			$statline['template_id'] = $templateId;
			unset($statline['id']);
		}
		$statline['last_mod'] = date("M d Y H:i:s");

		$cache->del(["gang-roles-templates-{$gangId}", "gang-roles-{$gangId}", "gang-role-{$roleId}"]);

		$response->getBody()->write(json_encode($statline));
		return $response->withHeader('Content-Type', 'application/json');
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
			f.is_vehicle, f.is_convalescence, f.is_captured, f.is_wyrd,
			f.experience, f.advancements, f.base_value, f.view_order
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
			f.is_vehicle, f.is_convalescence, f.is_captured, f.is_wyrd, f.experience, f.base_value, f.view_order
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
					save_roll, is_vehicle, is_convalescence, is_captured, is_wyrd, experience, advancements, base_value, view_order, created
				) VALUES (
					:user_gang_id, :fighter_name, :fighter_role_id, :backstory, :movement, :weapon_skill, :ballistic_skill, :strength,
					:toughness, :toughness_side, :toughness_rear, :wounds, :initiative, :attacks, :handling, :leadership, :cool, :willpower, :intelligence,
					:save_roll, :is_vehicle, :is_convalescence, :is_captured, :is_wyrd, :experience, 0, :base_value, :view_order, NOW()
				)
			";
		} else {
			$query = "
				INSERT INTO {$ndb->user_fighter}
				(
					user_gang_id, fighter_name, fighter_role_id, backstory, movement, weapon_skill, ballistic_skill, strength,
					toughness, wounds, initiative, attacks, leadership, cool, willpower, intelligence,
					is_vehicle, is_convalescence, is_captured, is_wyrd, experience, advancements, base_value, view_order, created
				) VALUES (
					:user_gang_id, :fighter_name, :fighter_role_id, :backstory, :movement, :weapon_skill, :ballistic_skill, :strength,
					:toughness, :wounds, :initiative, :attacks, :leadership, :cool, :willpower, :intelligence,
					:is_vehicle, :is_convalescence, :is_captured, :is_wyrd, :experience, 0, :base_value, :view_order, NOW()
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
		$auditMessage = '';
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

		$auditMessage = '';
		$fighterId = $args['id'];
		$injury = json_decode($request->getBody(), true);

		$insertInjurySQL = "INSERT INTO {$ndb->user_fighter_injury_map} (user_fighter_id, injury_id) VALUES (:user_fighter_id, :injury_id)";
		$result = $ndb->update($insertInjurySQL, array('user_fighter_id' => $fighterId, 'injury_id' => $injury->id));

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

		if (strlen($auditMessage)) $this->addFighterAudit($fighterId, $auditMessage);
		$response->getBody()->write(json_encode($fighter));
		return $response->withHeader('Content-Type', 'application/json');
	}
}
?>