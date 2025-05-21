<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class GangController extends SlimController {
	
	public function fetchGangs(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$userId = UserController::getCurrentUserId();
		//error_log("User id: {$userId}");
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
		$response->getBody()->write(json_encode($data));
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

			$fighters = FighterController::getFightersForGang($id);
			$data['fighters'] = $fighters;
			$gang = json_encode($data);
			$cache->setEx("gang-{$id}", 300, $gang);
		}

		$response->getBody()->write($gang);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addGang(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$gang = json_decode($response->getBody());
		$query = "
			INSERT INTO {$ndb->user_gang}
			(user_id, gang_name, gang_type_id, outlaw, created, last_mod)
			VALUES
			(:user_id, :gang_name, :gang_type_id, :outlaw, NOW(), NOW())
		";
		$result = $ndb->insert($query, $gang);
		if ($result) {
			$gang['id'] = $result;
			$response->getBody()->write(json_encode($gang));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}

	public function updateGang(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$gang = json_decode($response->getBody());
		$query = "
			UPDATE {$ndb->user_gang}
			SET gang_name = :gang_name, gang_type_id = :gang_type_id, outlaw = :outlaw, last_mod = NOW()
			WHERE id = :id
		";
		$result = $ndb->update($query, $gang);
		if ($result) {
			$cache->del("gang-{$gang['id']}");
			$response->getBody()->write(json_encode($gang));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}

	public static function getGangTypes() {
		global $ndb;
		$query = "
			SELECT 
				gt.id, gt.type_name, gt.house_gang, gt.outlaw, gt.created, gt.last_mod
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
			$insertQuery = "INSERT INTO {$ndb->gang_type} (type_name, gang_description, house_gang, outlaw, created, last_mod) VALUES (:type_name, :description, :house_gang, :outlaw, NOW(), NOW())";
			if ($ndb->insert($insertQuery, $params)) {
				$gang->id = $ndb->lastInsertId;
				$gang->created = date("M d Y H:i:s");
				$gang->last_mod = date("M d Y H:i:s");
			}
		} else {
			$updateQuery = "UPDATE {$ndb->gang_type} SET type_name = :type_name, gang_description = :description, house_gang = :house_gang, outlaw = :outlaw, last_mod = NOW() WHERE id = :id";
			$params['id'] = $id;
			$ndb->update($updateQuery, $params);
			$gang->last_mod = date("M d Y H:i:s");
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