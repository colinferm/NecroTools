<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class GangController extends SlimController {
	
	public function fetchGangs(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$query = "
			SELECT g.id, g.gang_name, g.gang_type_id, gt.type_name, gt.house_gang, g.outlaw, COUNT(f.id) AS num_fighters, unix_timestamp(g.created) * 1000 AS created, unix_timestamp(g.last_mod) * 1000 AS last_mod 
			FROM necro_gang g
			JOIN necro_gang_type gt ON (g.gang_type_id = gt.id)
			LEFT JOIN necro_fighter f ON (g.id = f.gang_id)
			GROUP BY g.id, g.gang_name, g.gang_type_id, gt.type_name, gt.house_gang, g.outlaw, g.last_mod
			ORDER BY g.last_mod
		";
		$data = dbQuery($query);
		$response->getBody()->write(json_encode($data));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function fetchGang(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$id = $args['id'];
		$query = "
			SELECT g.id, g.gang_name, g.gang_type_id, gt.type_name, gt.house_gang, g.outlaw, COUNT(f.id) AS num_fighters, unix_timestamp(g.created) * 1000 AS created, unix_timestamp(g.last_mod) * 1000 AS last_mod 
			FROM necro_gang g
			JOIN necro_gang_type gt ON (g.gang_type_id = gt.id)
			LEFT JOIN necro_fighter f ON (g.id = f.gang_id)
			WHERE g.id = :id
			GROUP BY g.id, g.gang_name, g.gang_type_id, gt.type_name, gt.house_gang, g.outlaw, g.last_mod
			ORDER BY g.last_mod
		";
		$db = getDb();
		$data = dbQueryFirst($query, ['id' => $id], $db);

		$fighters = FighterController::getFightersForGang($id, $db);
		$data['fighters'] = $fighters;

		$response->getBody()->write(json_encode($data));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addGang(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$gang = json_decode($response->getBody());
		$query = "
			INSERT INTO necro_gang
			(user_id, gang_name, gang_type_id, outlaw, created, last_mod)
			VALUES
			(:user_id, :gang_name, :gang_type_id, :outlaw, NOW(), NOW())
		";
		$result = dbInsert($query, $gang);
		if ($result) {
			$gang['id'] = $result;
			$response->getBody()->write(json_encode($gang));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}

	public function updateGang(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$gang = json_decode($response->getBody());
		$query = "
			UPDATE necro_gang
			SET gang_name = :gang_name, gang_type_id = :gang_type_id, outlaw = :outlaw, last_mod = NOW()
			WHERE id = :id
		";
		$result = dbUpdate($query, $gang);
		if ($result) {
			$response->getBody()->write(json_encode($gang));
			return $response->withHeader('Content-Type', 'application/json');
		}
		throw new DatabaseException();
	}
}
?>