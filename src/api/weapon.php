<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class WeaponController extends SlimController {

	public static function getTraits() {
		global $ndb;
		$query = "
			SELECT t.id, t.lookup_value AS value, t.misc_value, t.notes FROM {$ndb->lookups} t WHERE t.lookup_key = 'WEAPON_TRAIT' ORDER BY t.lookup_value ASC
		";
		return $ndb->query($query);
	}

	public static function getTraitsJSON() {
		global $cache;
		$traits = $cache->get("weapon-traits");
		if (!$traits) {
			$traits = json_encode(WeaponController::getTraits());
			$cache->set("weapon-traits", $traits);
		}
		return $traits;
	}

	public static function getWeaponsForFighter($id) {
		return static::getWeaponsOrGearForFighter($id, 0);
	}

	public static function getWeaponsOrGearForFighter($fighterId, $isGear = 0) {
		global $ndb;
		$query = "
			SELECT w.id, w.weapon_category_id, wc.category_name, w.weapon_name, w.weapon_value, w.rarity, w.is_wargear
			FROM {$ndb->weapon} w, {$ndb->weapon_category} wc, {$ndb->user_fighter_weapon_map} wfm
			WHERE 1 = 1
			AND w.is_wargear = :is_wargear
			AND w.weapon_category_id = wc.id
			AND wfm.weapon_id = w.id
			AND wfm.user_fighter_id = :id
		";
		$weapons = $ndb->query($query, ['id' => $fighterId, 'is_wargear' => $isGear]);

		if (!$isGear) {
			foreach ($weapons as &$weapon) {
				$charSQL = "
					SELECT wc.id, wc.ammo_type, wc.range_short, wc.range_long, wc.accuracy_short, wc.accuracy_long,
					       wc.strength, wc.armor_penetration, wc.damage, wc.ammo_check, wc.characteristic_value, wc.default_loadout
					FROM {$ndb->weapon_characteristic} wc
					WHERE wc.weapon_id = :weapon_id
					AND (
						wc.default_loadout = 1
						OR wc.id IN (
							SELECT weapon_characteristic_id
							FROM {$ndb->user_fighter_weapon_characteristic_map}
							WHERE user_fighter_id = :fighter_id
							AND weapon_id = :weapon_id2
						)
					)
				";
				$chars = $ndb->query($charSQL, [
					'weapon_id'  => $weapon['id'],
					'fighter_id' => $fighterId,
					'weapon_id2' => $weapon['id'],
				]);

				foreach($chars as &$char) {
					$traitSQL = "
						SELECT t.id, t.lookup_value AS value, t.misc_value
						FROM {$ndb->lookups} t, {$ndb->weapon_trait_characteristic_map} wtcm
						WHERE t.id = wtcm.trait_lookup_id
						AND t.lookup_key = 'WEAPON_TRAIT'
						AND wtcm.characteristic_id = :char_id
						ORDER BY t.lookup_value ASC
					";
					$traits = $ndb->query($traitSQL, ['char_id' => $char['id']]);
					$char['traits'] = $traits;
				}
				$weapon['characteristics'] = $chars;
			}
		}
		return $weapons;
	}

	public static function getCharacteristicsForId($params, $fighterId = null) {
		global $ndb;

		$p = [];
		$fieldName = $params['field'];
		$p[$fieldName] = $params['value'];
		$charSQL = "
			SELECT wc.id, wc.ammo_type, wc.range_short, wc.range_long, wc.accuracy_short, wc.accuracy_long,
					wc.strength, wc.armor_penetration, wc.damage, wc.ammo_check, wc.characteristic_value, 
					wc.default_loadout, wc.rarity, wc.gang_type_id
			FROM {$ndb->weapon_characteristic} wc
			WHERE wc.{$fieldName} = :{$fieldName}
		";
		if ($fighterId != null) {
			$p['fighter_id'] = $fighterId;
			$charSQL .= "
				AND (
					wc.default_loadout = 1
					OR wc.id IN (
						SELECT weapon_characteristic_id
						FROM {$ndb->user_fighter_weapon_characteristic_map}
						WHERE user_fighter_id = :fighter_id
						AND weapon_id = wc.weapon_id
					)
				)
			";
		}
		//$chars = $ndb->query($charSQL, [$params['field'] => $params['value'], 'fighter_id' => $fighterId]);
		$chars = $ndb->query($charSQL, $p);

		foreach($chars as &$char) {
			static::buildCharacteristicTraits($char);
		}
		return $chars;
	}

	public static function buildCharacteristicTraits(&$char) {
		global $ndb;
		$traitSQL = "
			SELECT t.id, t.lookup_value AS value, t.misc_value 
			FROM {$ndb->lookups} t, {$ndb->weapon_trait_characteristic_map} wtcm
			WHERE t.id = wtcm.trait_lookup_id
			AND t.lookup_key = 'WEAPON_TRAIT'
			AND wtcm.characteristic_id = :char_id
			ORDER BY t.lookup_value ASC
		";
		$traits = $ndb->query($traitSQL, ['char_id' => $char['id']]);
		$char['traits'] = $traits;
		return $char;
	}
	
	public function fetchTraits(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$data = WeaponController::getTraits();
		$response->getBody()->write(json_encode($data));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function fetchTrait(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$id = $args['id'];
		$query = "
			SELECT t.id, t.lookup_value AS value, t.misc_value, t.notes FROM {$ndb->lookups} t WHERE t.id = :id ORDER BY t.lookup_value ASC
		";
		$data = $ndb->query($query, ['id' => $id]);
		$response->getBody()->write(json_encode($data));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function deleteTrait(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$id = $args['id'];
		$result = $ndb->delete("DELETE FROM {$ndb->weapon_trait_characteristic_map} WHERE trait_lookup_id = :id", $id);
		$result = $ndb->delete("DELETE FROM {$ndb->lookups} WHERE id = :id", $id);
		$response->withStatus(200);
		return $response;
	}

	public function addTrait(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$trait = json_decode($request->getBody(), true);
		unset($trait['id']);
		$query = "
			INSERT INTO {$ndb->lookups}
				(lookup_value, misc_value, notes, lookup_key)
			VALUES
				(:value, :misc_value, :notes, 'WEAPON_TRAIT')
		";
		$result = $ndb->insert($query, $trait);
		if ($result) {
			$trait['id'] = $ndb->lastInsertId;
			$response->getBody()->write(json_encode($trait));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}

	public function updateTrait(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$trait = json_decode($request->getBody(), true);
		$query = "
			UPDATE {$ndb->lookups}
			SET value = :value, misc_value = :misc_value, notes = :notes
			WHERE id = :id
		";
		$result = $ndb->update($query, $trait);
		if ($result) {
			$response->getBody()->write(json_encode($trait));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}

	public static function getWeapons($id = 0, $wci = 0) {
		global $ndb;
		$dbparams = [];
		//SELECT w.id AS id, CASE WHEN COUNT(ca.ammo_type) > 1 THEN CONCAT(w.weapon_name, GROUP_CONCAT(ca.ammo_type SEPARATOR '/')) ELSE w.weapon_name END as weapon_name, w.weapon_value, COUNT(ca.ammo_type) AS ammo_types, c.category_name, c.id AS category_id
		$query = "
			SELECT w.id AS id, w.weapon_name, w.weapon_value, w.rarity, COUNT(ca.ammo_type) AS ammo_types, c.category_name, c.id AS category_id
			FROM {$ndb->weapon_category} c, {$ndb->weapon} w, {$ndb->weapon_characteristic} ca
			WHERE c.id = w.weapon_category_id
			AND w.id = ca.weapon_id
			AND w.is_wargear = 0
		";

		if ($wci > 0) {
			$dbparams['weapon_category_id'] = $wci;
			$query .= " AND c.id = :weapon_category_id ";
		}

		if ($id > 0) {
			$dbparams['id'] = $id;
			$query .= " AND w.id = :id ";
		}

		$query .= "
			GROUP BY w.id, weapon_name, w.weapon_value, c.category_name, c.id, w.rarity
			ORDER BY c.id ASC
		";

		return $ndb->query($query, $dbparams);
	}

	public function fetchWeapons(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$dbparams = [];
		//SELECT w.id AS id, CASE WHEN COUNT(ca.ammo_type) > 1 THEN CONCAT(w.weapon_name, GROUP_CONCAT(ca.ammo_type SEPARATOR '/')) ELSE w.weapon_name END as weapon_name, w.weapon_name AS base_weapon_name, w.weapon_value, COUNT(ca.ammo_type) AS ammo_types, c.category_name, c.id AS category_id
		$query = "
			SELECT w.id AS id, w.weapon_name, w.weapon_name AS base_weapon_name, w.weapon_value, w.rarity, COUNT(ca.ammo_type) AS ammo_types, c.category_name, c.id AS category_id
			FROM {$ndb->weapon_category} c, {$ndb->weapon} w, {$ndb->weapon_characteristic} ca
			WHERE c.id = w.weapon_category_id
			AND w.id = ca.weapon_id
			AND w.is_wargear = 0
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
		if (array_key_exists("wci", $params)) {
			$dbparams['weapon_category_id'] =  $params['wci'];
			$query .= " AND c.id = :weapon_category_id ";
		}

		$query .= "
			GROUP BY w.id, weapon_name, w.weapon_value, c.category_name, c.id
			ORDER BY c.category_name ASC, weapon_name ASC, w.weapon_value DESC, w.id ASC
		";

		$data = $ndb->query($query, $dbparams);
		$response->getBody()->write(json_encode($data));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function fetchWeaponById(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$weaponId = $args['id'];
		$weapon = null;
		$weapons = WeaponController::getWeapons($weaponId);
		if (!count($weapons)) return $response->withStatus(404);
		$weapon = $weapons[0];

		$characteristics = static::getCharacteristicsForId(['field' => 'weapon_id', 'value' => $weaponId]);
		$weapon['characteristics'] = $characteristics;

		$response->getBody()->write(json_encode($weapon));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public static function getWeaponCategories() {
		global $ndb;
		$query = "SELECT c.id, c.category_name FROM {$ndb->weapon_category} c WHERE c.is_wargear = 0 ORDER BY c.category_name ASC";
		return $ndb->query($query);
	}

	public static function getWargearCategories() {
		global $ndb;
		$query = "SELECT c.id, c.category_name FROM {$ndb->weapon_category} c WHERE c.is_wargear = 1 ORDER BY c.category_name ASC";
		return $ndb->query($query);
	}

	public static function getWeaponCategoryJSON() {
		global $cache;
		$cats = $cache->get("weapon-categories");
		if (!$cats) {
			$cats = json_encode(WeaponController::getWeaponCategories());
			$cache->set("weapon-categories", $cats);
		}
		return $cats;
	}

	public static function getWargearCategoryJSON() {
		global $cache;
		$cats = $cache->get("wargear-categories");
		if (!$cats) {
			$cats = json_encode(WeaponController::getWargearCategories());
			$cache->set("wargear-categories", $cats);
		}
		return $cats;
	}

	public static function getCategoryById($id) {
		global $ndb;
		$query = "SELECT c.id, c.category_name FROM {$ndb->weapon_category} c WHERE c.id = :id ORDER BY c.category_name ASC";
		return $ndb->queryFirst($query, ['id' => $id]);
	}

	public function fetchWeaponsByCategory(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$catId = $args['id'];
		$weapons = $cache->get("weapon-cat-{$catId}");
		if (!$weapons) {
			$weapons = json_encode(WeaponController::getWeapons(0, $catId));
			$cache->set("weapon-cat-{$catId}", $weapons);
		}
		$response->getBody()->write($weapons);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public static function getCharacteristicById($id) {
		global $ndb;
		$chars = static::getCharacteristicsForId(['field' => 'id', 'value' => $id]);
		if (is_array($chars) && count($chars) == 1) return $chars[0];
		return null;
	}

	public function fetchCharacteristicsForWeaponId(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$weaponId = $args['id'];
		$characteristics = static::getCharacteristicsForId(['field' => 'weapon_id', 'value' => $weaponId]);

		if ($characteristics) {
			$response->getBody()->write(json_encode($characteristics));
			return $response->withHeader('Content-Type', 'application/json');
		}
		return $response->withStatus(404);
	}

	public function fetchCharacteristic(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$id = $args['id'];
		$characteristic = static::getCharacteristicById($id);
		if ($characteristic) {
			$response->getBody()->write(json_encode($characteristic));
			return $response->withHeader('Content-Type', 'application/json');
		}

		return $response->withStatus(404);
	}

	public function addCharacteristic(ServerRequestInterface $request, ResponseInterface $response): ResponseInterface {
		global $ndb;
		$body = json_decode($request->getBody(), true);
		$fighterId  = $body['user_fighter_id'];
		$weaponId   = $body['weapon_id'];
		$charId     = $body['weapon_characteristic_id'];

		$char = static::getCharacteristicById($charId);
		if (!$char || $char['default_loadout'] == 1) {
			$response->getBody()->write(json_encode([]));
			return $response->withHeader('Content-Type', 'application/json');
		}

		$ndb->insert(
			"INSERT INTO {$ndb->user_fighter_weapon_characteristic_map} (user_fighter_id, weapon_id, weapon_characteristic_id) VALUES (:user_fighter_id, :weapon_id, :weapon_characteristic_id)",
			['user_fighter_id' => $fighterId, 'weapon_id' => $weaponId, 'weapon_characteristic_id' => $charId]
		);
		$response->getBody()->write(json_encode($char));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function updateCharacteristic(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$id = $args['id'];

		return $response->withStatus(404);
	}

	public function deleteCharacteristic(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;

		$id = $args['id'];
		$ndb->deleteWithParams(
			"DELETE FROM {$ndb->user_fighter_weapon_characteristic_map} WHERE weapon_characteristic_id = :id",
			['id' => $id]
		);
		$ndb->deleteFromTable($ndb->weapon_characteristic, $id);

		return $response->withStatus(200);
	}

	public static function getGear($params = array()) {
		global $ndb;
		$sqlParams = [];
		$gearSQL = "
			SELECT w.id, w.weapon_category_id, wc.category_name, w.weapon_name, w.weapon_value, w.rarity, w.notes, w.is_wargear
			FROM {$ndb->weapon} w
			LEFT JOIN {$ndb->weapon_category} wc ON (w.weapon_category_id = wc.id)
			WHERE 1 = 1
			AND w.is_wargear = 1
		";
		if (count($params) > 0) {
			$gearSQL .= "AND w.{$params['field']} = :{$params['field']}";
			$sqlParams = [$params['field'] => $params['value']];
		}

		$gearSQL .= " ORDER BY wc.category_name ASC, w.weapon_name ASC, w.weapon_value DESC";
		$gear = $ndb->query($gearSQL, $sqlParams);
		return $gear;
	}


	public function fetchGear(ServerRequestInterface $request, ResponseInterface $response): ResponseInterface {
		global $cache;

		$gear = $cache->get("all-wargear");
		if (!$gear) {
			$gearResults = static::getGear();
			if (count($gearResults) == 0) return $response->withStatus(404);
			$gear = json_encode($gearResults);
			$cache->set("all-wargear", $gear);
		}
		$response->getBody()->write($gear);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function fetchGearByCategory(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $cache;

		$id = $args['id'];
		$gear = $cache->get("wargear-cat-{$id}");
		if (!$gear) {
			$gearResults = static::getGear(['field' => 'weapon_category_id', 'value' => $id]);
			if (count($gearResults) == 0) return $response->withStatus(404);
			$gear = json_encode($gearResults);
			$cache->set("wargear-cat-{$id}", $gear);
		}
		$response->getBody()->write($gear);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function fetchGearById(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$id = $args['id'];
		$gear = static::getGear(['field' => 'id', 'value' => $id]);

		if (count($gear) == 0) return $response->withStatus(404);
		if (count($gear) == 1) $gear = $gear[0];
		$response->getBody()->write(json_encode($gear));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addUpdateGear(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$gear = json_decode($request->getBody(), true);
		unset($gear['category_name']);

		if ($request->getMethod() == 'POST') {
			unset($gear['id']);

			$insertQuery = "
				INSERT INTO {$ndb->weapon} 
					(weapon_name, weapon_category_id, weapon_value, rarity, notes, is_wargear)
				VALUES
					(:weapon_name, :weapon_category_id, :weapon_value, :rarity, :notes, :is_wargear)
			";
			$ndb->insert($insertQuery, $gear);
			$gear['id'] = $ndb->lastInsertId;

		} else {
			$id = $args['id'];
			$gear['id'] = $id;
			$ndb->updateTable($ndb->weapon, $gear);
		}
		$catId = $gear['weapon_category_id'];
		$cat = static::getCategoryById($catId);
		$gear['category_name'] = $cat['category_name'];
		$cache->del(["all-wargear", "wargear-cat-{$catId}"]);

		$response->getBody()->write(json_encode($gear));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function deleteGear(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;

		$id = $args['id'];
		$rows = $ndb->deleteFromTable($ndb->weapon_characteristic, $id);

		$cache->del("all-wargear");

		return $response->withStatus(200);
	}

}
?>