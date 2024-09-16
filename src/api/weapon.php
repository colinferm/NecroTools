<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class WeaponController extends SlimController {

	public static function getTraits() {
		$query = "
			SELECT t.id, t.trait_name, t.trait_value FROM necro_weapon_trait t ORDER BY t.trait_name ASC
		";
		return dbQuery($query);
	}

	public static function getWeaponsForFighter($id) {
		$query = "
			SELECT w.id, w.weapon_category_id, wc.category_name, w.weapon_name, w.weapon_value, w.rarity
			FROM necro_weapon w, necro_weapon_category wc, necro_weapon_fighter_map wfm
			WHERE 1 = 1
			AND w.weapon_category_id = wc.id
			AND wfm.weapon_id = w.id
			AND wfm.fighter_id = :id
		";
		$weapons = dbQuery($query, ['id' => $id]);

		foreach ($weapons as &$weapon) {
			$charSQL = "
				SELECT id, ammo_type, range_short, range_long, accuracy_short, accuracy_long, strength, armor_penetration, damage, ammo_check 
				FROM necro_weapon_characteristic
				WHERE weapon_id = :weapon_id
			";
			$chars = dbQuery($charSQL, ['weapon_id' => $weapon['id']]);

			foreach($chars as &$char) {
				$traitSQL = "
					SELECT t.id, t.trait_name, t.trait_value 
					FROM necro_weapon_trait t, necro_weapon_trait_characteristic_map wtcm
					WHERE t.id = wtcm.trait_id
					AND wtcm.characteristic_id = :char_id
					ORDER BY t.trait_name ASC
				";
				$traits = dbQuery($traitSQL, ['char_id' => $char['id']]);
				$char['traits'] = $traits;
			}
			$weapon['characteristics'] = $chars;
		}
		return $weapons;
	}
	
	public function fetchTraits(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$data = WeaponController::getTraits();
		$response->getBody()->write(json_encode($data));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function fetchTrait(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$id = $args['id'];
		$query = "
			SELECT t.id, t.trait_name, t.trait_value FROM necro_weapon_trait t WHERE t.id = :id ORDER BY t.trait_name ASC
		";
		$data = dbQuery($query, ['id' => $id]);
		$response->getBody()->write(json_encode($data));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addTrait(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$trait = json_decode($response->getBody());
		$query = "
			INSERT INTO necro_weapon_trait
			(trait_name, trait_value)
			VALUES
			(:trait_name, :trait_value)
		";
		$result = dbInsert($query, $trait);
		if ($result) {
			$trait['id'] = $result;
			$response->getBody()->write(json_encode($trait));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}

	public function updateTrait(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$trait = json_decode($response->getBody());
		$query = "
			UPDATE necro_weapon_trait
			SET trait_name = :trait_name, trait_value = :trait_value
			WHERE id = :id
		";
		$result = dbUpdate($query, $trait);
		if ($result) {
			$response->getBody()->write(json_encode($trait));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}

	public function fetchWeapons(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$dbparams = [];
		$query = "
			SELECT CASE WHEN COUNT(ca.ammo_type) > 1 THEN CONCAT(w.weapon_name, GROUP_CONCAT(ca.ammo_type SEPARATOR '/')) ELSE w.weapon_name END as weapon_name, COUNT(ca.ammo_type) AS ammo_types, c.category_name
			FROM necro_weapon_category c, necro_weapon w, necro_weapon_characteristic ca
			WHERE c.id = w.weapon_category_id
			AND w.id = ca.weapon_id
			GROUP BY weapon_name, category_name
		";

		$params = $request->getQueryParams();
		if (array_key_exists("ac", $params)) {
			$dbparams['autocomplete'] =  $params['ac']."%";
			$query .= " AND w.weapon_name LIKE :autocomplete ";
		}
		if (array_key_exists("wc", $params)) {
			$dbparams['weapon_category'] =  $params['wc'];
			$query .= " AND w.weapon_category_id = :weapon_category ";
		}

		$query .= "
			GROUP BY weapon_name, c.category_name
			ORDER BY w.weapon_name ASC
		";

		$data = dbQuery($query, $dbparams);
		$response->getBody()->write(json_encode($data));
		return $response->withHeader('Content-Type', 'application/json');
	}
}
?>