<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class GangController extends SlimController {
	
	public function fetchGangs(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$userId = UserController::getCurrentUserId();
		//error_log("User id: {$userId}");
		$gangs = $cache->get("user-gangs-{$userId}");
		if (!$gangs) {
			$query = "
				SELECT g.id, g.gang_name, g.gang_type_id, gt.type_name, gt.house_gang, g.outlaw, COUNT(f.id) AS num_fighters, unix_timestamp(g.created) * 1000 AS created, unix_timestamp(g.last_mod) * 1000 AS last_mod 
				FROM {$ndb->user_gang} g
				JOIN {$ndb->gang_type} gt ON (g.gang_type_id = gt.id)
				LEFT JOIN {$ndb->user_fighter} f ON (g.id = f.user_gang_id)
				WHERE g.user_id = :user_id
				GROUP BY g.id, g.gang_name, g.gang_type_id, gt.type_name, gt.house_gang, g.outlaw, g.last_mod
				ORDER BY g.last_mod
			";
			$data = $ndb->query($query, ['user_id' => $userId]);
			foreach ($data as &$gang) {
				$fighters = FighterController::getFightersForGang($gang['id']);
				$gang['fighters'] = $fighters;
			}
			$gangs = json_encode($data);
			$cache->setEx("user-gang-{$userId}", DEFAULT_CACHE_TIME, $gangs);
		}
		$response->getBody()->write($gangs);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public static function getGang($gangId) {
		global $ndb;
		$query = "
			SELECT g.id, g.gang_name, g.gang_type_id, gt.type_name, gt.house_gang, g.outlaw, COUNT(f.id) AS num_fighters, unix_timestamp(g.created) * 1000 AS created, unix_timestamp(g.last_mod) * 1000 AS last_mod 
			FROM {$ndb->user_gang} g
			JOIN {$ndb->gang_type} gt ON (g.gang_type_id = gt.id)
			LEFT JOIN {$ndb->user_fighter} f ON (g.id = f.user_gang_id)
			WHERE g.id = :id
			GROUP BY g.id, g.gang_name, g.gang_type_id, gt.type_name, gt.house_gang, g.outlaw, g.last_mod
			ORDER BY g.last_mod
		";
		return $ndb->queryFirst($query, ['id' => $gangId]);
	}

	public function fetchGang(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$id = $args['id'];
		$gang = $cache->get("gang-{$id}");
		if (!$gang) {
			$query = "
				SELECT g.id, g.gang_name, g.gang_type_id, gt.type_name, gt.house_gang, g.outlaw, COUNT(f.id) AS num_fighters, unix_timestamp(g.created) * 1000 AS created, unix_timestamp(g.last_mod) * 1000 AS last_mod 
				FROM {$ndb->user_gang} g
				JOIN {$ndb->gang_type} gt ON (g.gang_type_id = gt.id)
				LEFT JOIN {$ndb->user_fighter} f ON (g.id = f.user_gang_id)
				WHERE g.id = :id
				GROUP BY g.id, g.gang_name, g.gang_type_id, gt.type_name, gt.house_gang, g.outlaw, g.last_mod
				ORDER BY g.last_mod
			";
			$data = $ndb->queryFirst($query, ['id' => $id]);

			if (!$data) return $response->withStatus(404);

			$fighters = FighterController::getFightersForGang($id);
			$data['fighters'] = $fighters;
			$gang = json_encode($data);
			$cache->setEx("gang-{$id}", DEFAULT_CACHE_TIME, $gang);
		}

		$response->getBody()->write($gang);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addGang(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$userId = UserController::getCurrentUserId();
		$gang = json_decode($request->getBody(), true);

		if ($gang['user_id'] != $userId) return $response->withStatus(403);

		$params = array(
			'user_id' => $gang['user_id'],
			'gang_name' => $gang['gang_name'],
			'gang_type_id' => $gang['gang_type_id'],
			'outlaw' => $gang['outlaw'],
			'outcast' => $gang['outcast']
		);

		$query = "
			INSERT INTO {$ndb->user_gang}
			(user_id, gang_name, gang_type_id, outlaw, outcast, created, last_mod)
			VALUES
			(:user_id, :gang_name, :gang_type_id, :outlaw, :outcast, NOW(), NOW())
		";
		$result = $ndb->insert($query, $params);
		if ($result) {
			$cache->del("user-gangs-{$userId}");

			$gang['id'] = $ndb->lastInsertId;
			$gangType = static::getGangTypeById($gang['gang_type_id']);
			$gang['num_fighters'] = 0;
			$gang['type_name'] = $gangType['type_name'];
			$gang['last_mod'] = date("m/d/Y");
			$gang['created'] = date("m/d/Y");
			$response->getBody()->write(json_encode($gang));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}

	public function updateGang(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$userId = UserController::getCurrentUserId();
		$gang = json_decode($response->getBody());

		if ($gang['user_id'] != $userId)return $response->withStatus(403);

		$query = "
			UPDATE {$ndb->user_gang}
			SET gang_name = :gang_name, gang_type_id = :gang_type_id, outlaw = :outlaw, last_mod = NOW()
			WHERE id = :id
		";
		$result = $ndb->update($query, $gang);
		if ($result) {
			$gang['last_mod'] = date("m/d/Y");
			$cache->del(["gang-{$gang['id']}", "user-gangs-{$userId}"]);
			$response->getBody()->write(json_encode($gang));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}

	public function removeGang(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$userId = UserController::getCurrentUserId();
		$gangId = $args['id'];

		$gang = $ndb->queryFirst("SELECT id FROM {$ndb->user_gang} WHERE user_id = :user_id AND id = :gang_id", ['user_id' => $userId, 'gang_id' => $gangId]);
		if (!$gang) $response->withStatus(403);

		$fighters = $ndb->query("SELECT id FROM {$ndb->user_fighter} WHERE user_gang_id = :gang_id", ['gang_id' => $gangId]);
		foreach($fighters as $fighter) {
			$ndb->deleteWithParams("DELETE FROM {$ndb->user_fighter_audit} WHERE user_fighter_id = :id", ['id' => $fighter['id']]);
			$ndb->deleteWithParams("DELETE FROM {$ndb->user_fighter_injury_map} WHERE user_fighter_id = :id", ['id' => $fighter['id']]);
			$ndb->deleteWithParams("DELETE FROM {$ndb->user_fighter_skill_map} WHERE user_fighter_id = :id", ['id' => $fighter['id']]);
			$ndb->deleteWithParams("DELETE FROM {$ndb->user_fighter_injury_map} WHERE user_fighter_id = :id", ['id' => $fighter['id']]);
		}

		$ndb->deleteWithParams("DELETE FROM {$ndb->user_gang_audit} WHERE user_gang_id = :id", ['id' => $gangId]);
		$ndb->deleteWithParams("DELETE FROM {$ndb->user_gang_stash_map} WHERE user_gang_id = :id", ['id' => $gangId]);
		$ndb->deleteFromTable($ndb->user_gang, $gangId);
		$cache->del("user-gangs-{$userId}");

		return $response->withStatus(200);
	}

	public static function getGangTypes() {
		global $ndb;
		$query = "
			SELECT 
				gt.id, gt.type_name, gt.house_gang, gt.outlaw, gt.outcast, gt.created, gt.last_mod
			FROM {$ndb->gang_type} gt
			ORDER BY gt.house_gang DESC, gt.outlaw ASC, gt.type_name ASC
		";
		return $ndb->query($query);
	}

	public static function getGangTypesJSON() {
		global $cache;
		$types = null;
		$types = $cache->get("gang-types");
		if (!$types) {
			$types = json_encode(GangController::getGangTypes());
			$cache->set("gang-types", $types);
		}
		return $types;
	}

	public static function getGangTypeById($gangTypeId) {
		global $ndb;
		$query = "
			SELECT 
				gt.id, gt.type_name, gt.house_gang, gt.outlaw, gt.outcast, gt.created, gt.last_mod
			FROM {$ndb->gang_type} gt
			WHERE gt.id = :gang_type_id
			ORDER BY gt.house_gang DESC, gt.outlaw ASC, gt.type_name ASC
		";
		return $ndb->queryFirst($query, ['gang_type_id' => $gangTypeId]);
	}

	public function fetchGangTypes(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $cache;
		$gangs = GangController::getGangTypesJSON();
		$response->getBody()->write($gangs);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addUpdateGangType(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$gang = json_decode($request->getBody());

		$id = (array_key_exists('id', $args)) ? $args['id'] : 0;
		$params = [
			'type_name' => $gang->type_name,
			'description' => $gang->gang_description,
			'house_gang' => $gang->house_gang,
			'outlaw' => $gang->outlaw
		];

		if ($request->getMethod() == 'POST') {
			$insertQuery = "INSERT INTO {$ndb->gang_type} (type_name, gang_description, house_gang, outlaw, outcast, created, last_mod) VALUES (:type_name, :description, :house_gang, :outlaw, :outcast, NOW(), NOW())";
			if ($ndb->insert($insertQuery, $params)) {
				$gang->id = $ndb->lastInsertId;
				$gang->created = date("m/d/Y");
				$gang->last_mod = date("m/d/Y");
			}
		} else {
			$updateQuery = "UPDATE {$ndb->gang_type} SET type_name = :type_name, gang_description = :description, house_gang = :house_gang, outlaw = :outlaw, outcast = :outcast, last_mod = NOW() WHERE id = :id";
			$params['id'] = $id;
			$ndb->update($updateQuery, $params);
			$gang->last_mod = date("m/d/Y");
		}

		$cache->del("gang-types");

		$response->getBody()->write(json_encode($gang));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function deleteGangType(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$gangTypeId = $args['id'];

		$selectGangRoles = "SELECT r.id FROM {$ndb->fighter_role} r WHERE r.gang_type_id = :gang_type_id";
		$roles = $ndb->query($selectGangRoles, ['gang_type_id' => $gangTypeId]);
		foreach ($roles as $role) {
			FighterController::deleteTemplateFighter($role['id']);
		}
		$result = $ndb->delete("DELETE FROM {$ndb->gang_type} WHERE id = :id", $gangTypeId);

		$cache->del("gang-types");

		$response->withStatus(200);
		return $response;
	}
}
?>