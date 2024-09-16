<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class FighterController extends SlimController {

	public static function getSkills() {
		$query = "
			SELECT s.id, s.skill_name FROM necro_fighter_skill s ORDER BY s.skill_name ASC
		";
		return dbQuery($query);
	}

	public static function getFightersForGang($gangId, $db) {
		$query = "
			SELECT f.id, f.fighter_name, f.heirarchy_role, f.backstory, 
			f.movement, f.weapon_skill, f.balistic_skill, f.strength, f.toughness, f.wounds, f.initiative, f.attacks,
			f.leadership, f.cool, f.willpower, f.intelligence, 
			f.is_vehicle, f.is_convalescence, f.is_captured, f.experience, f.advancements, f.base_value, f.view_order
			FROM necro_fighter f
			WHERE f.gang_id = :gang_id
			ORDER BY f.view_order
		";
		return dbQuery($query, ['gang_id' => $gangId]);
	}

	public function fetchGangFighters(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$gangId = $args['id'];
		$db = getDb();
		$fighters = FighterController::getFightersForGang($gangId, $db);
		$response->getBody()->write(json_encode($fighters));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function fetchFighter(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$id = $args['id'];
		$query = "
			SELECT f.id, f.fighter_name, f.heirarchy_role, f.backstory, f.advancements, 
			f.movement, f.weapon_skill, f.balistic_skill, f.strength, f.toughness, f.toughness_side, f.toughness_rear,  
			f.handling, f.save_roll, f.wounds, f.initiative, f.attacks, f.leadership, f.cool, f.willpower, f.intelligence, 
			f.is_vehicle, f.is_convalescence, f.is_captured, f.experience, f.base_value, f.view_order
			FROM necro_fighter f
			WHERE f.id = :id
			ORDER BY f.view_order
		";
		$fighter = dbQueryFirst($query, ['id' => $id]);
		$fighter['weapons'] = WeaponController::getWeaponsForFighter($id);

		$response->getBody()->write(json_encode($fighter));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addFighter(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$fighter = json_decode($response->getBody());

		if ($fighter['is_vehicle']) {
			$query = "
				INSERT INTO necro_fighter
				(
					gang_id, fighter_name, heirarchy_role, backstory, movement, weapon_skill, balistic_skill, strength,
					toughness, toughness_side, toughness_rear, wounds, initiative, attacks, handling, leadership, cool, willpower, intelligence,
					save_roll, is_vehicle, is_convalescence, is_captured, experience, advancements, base_value, view_order, created
				) VALUES (
					:gang_id, :fighter_name, :heirarchy_role, :backstory, :movement, :weapon_skill, :balistic_skill, :strength,
					:toughness, :toughness_side, :toughness_rear, :wounds, :initiative, :attacks, :handling, :leadership, :cool, :willpower, :intelligence,
					:save_roll, :is_vehicle, :is_convalescence, :is_captured, :experience, 0, :base_value, :view_order, NOW()
				)
			";
		} else {
			$query = "
				INSERT INTO necro_fighter
				(
					gang_id, fighter_name, heirarchy_role, backstory, movement, weapon_skill, balistic_skill, strength,
					toughness, wounds, initiative, attacks, leadership, cool, willpower, intelligence,
					is_vehicle, is_convalescence, is_captured, experience, advancements, base_value, view_order, created
				) VALUES (
					:gang_id, :fighter_name, :heirarchy_role, :backstory, :movement, :weapon_skill, :balistic_skill, :strength,
					:toughness, :wounds, :initiative, :attacks, :leadership, :cool, :willpower, :intelligence,
					:is_vehicle, :is_convalescence, :is_captured, :experience, 0, :base_value, :view_order, NOW()
				)
			";
		}

		$result = dbInsert($query, $fighter);
		if ($result) {
			$fighter['id'] = $result;
			$response->getBody()->write(json_encode($fighter));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}

	public function updateFighter(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$fighter = json_decode($response->getBody());
		if ($fighter['is_vehicle']) {
			$query = "
				UPDATE necro_fighter SET
				gang_id = :gang_id, fighter_name = :fighter_name, heirarchy_role = :heirarchy_role, backstory = :backstory, 
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
				UPDATE necro_fighter SET
				gang_id = :gang_id, fighter_name = :fighter_name, heirarchy_role = :heirarchy_role, backstory = :backstory, 
				movement = :movement, weapon_skill = :weapon_skill, balistic_skill = :balistic_skill, strength = :strength,
				toughness = :toughness, wounds = :wounds, initiative = :initiative, attacks = :attacks,
				leadership = :leadership, cool = :cool, willpower = :willpower, intelligence = :intelligence,
				is_vehicle = :is_vehicle, is_convalescence = :is_convalescence, is_captured = :is_captured, experience = :experience, 
				base_value = :base_value, view_order = :view_order, advancements = :advancements
				WHERE id = :id
			";
		}
		$result = dbUpdate($query, $fighter);
		if ($result) {
			$response->getBody()->write(json_encode($fighter));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}
}
?>