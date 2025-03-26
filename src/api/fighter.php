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
		global $ndb;
		$id = $args['id'];
		$query = "
			SELECT f.id, f.fighter_name, f.fighter_role, f.backstory, f.advancements, 
			f.movement, f.weapon_skill, f.balistic_skill, f.strength, f.toughness, f.toughness_side, f.toughness_rear,  
			f.handling, f.save_roll, f.wounds, f.initiative, f.attacks, f.leadership, f.cool, f.willpower, f.intelligence, 
			f.is_vehicle, f.is_convalescence, f.is_captured, f.experience, f.base_value, f.view_order
			FROM {$ndb->user_fighter} f
			WHERE f.id = :id
			ORDER BY f.view_order
		";
		$fighter = $ndb->queryFirst($query, ['id' => $id]);
		$fighter['weapons'] = WeaponController::getWeaponsForFighter($id);

		$response->getBody()->write(json_encode($fighter));
		return $response->withHeader('Content-Type', 'application/json');
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
		$fighter = json_decode($response->getBody());
		if ($fighter['is_vehicle']) {
			$query = "
				UPDATE {$ndb->user_fighter} SET
				user_gang_id = :user_gang_id, fighter_name = :fighter_name, fighter_role = :fighter_role, backstory = :backstory, 
				movement = :movement, weapon_skill = :weapon_skill, balistic_skill = :balistic_skill, strength = :strength,
				toughness = :toughness, toughness_side = :toughness_side, toughness_rear = :toughness_rear, wounds = :wounds, 
				initiative = :initiative, attacks = :attacks, handling = :handling, save_roll = :save_roll
				leadership = :leadership, cool = :cool, willpower = :willpower, intelligence = :intelligence,
				is_vehicle = :is_vehicle, is_convalescence = :is_convalescence, is_captured = :is_captured, experience = :experience, 
				base_value = :base_value, view_order = :view_order, advancements = :advancements
				WHERE id = :id
			";
		} else {
			$query = "
				UPDATE {$ndb->user_fighter} SET
				user_gang_id = :user_gang_id, fighter_name = :fighter_name, fighter_role = :fighter_role, backstory = :backstory, 
				movement = :movement, weapon_skill = :weapon_skill, balistic_skill = :balistic_skill, strength = :strength,
				toughness = :toughness, wounds = :wounds, initiative = :initiative, attacks = :attacks,
				leadership = :leadership, cool = :cool, willpower = :willpower, intelligence = :intelligence,
				is_vehicle = :is_vehicle, is_convalescence = :is_convalescence, is_captured = :is_captured, experience = :experience, 
				base_value = :base_value, view_order = :view_order, advancements = :advancements
				WHERE id = :id
			";
		}
		$result = $ndb->update($query, $fighter);
		if ($result) {
			$response->getBody()->write(json_encode($fighter));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}
}
?>