<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class ArchetypeController extends SlimController {
	private static function getArchetypeById($id) {
		global $ndb;
		$query = "
			SELECT a.id, a.archetype_name, a.archetype_description, a.is_wyrd FROM {$ndb->fighter_archetype} a WHERE id = :id
		";
		$archetype = $ndb->queryFirst($query, ['id' => $id]);
		$archetype['primary_skills'] = FighterController::getArchetypeSkills($id, true);
		$archetype['secondary_skills'] = FighterController::getArchetypeSkills($id, false);
		return $archetype;
	}

	private static function getArchetypes() {
		global $ndb;
		$query = "SELECT a.id, a.archetype_name, a.archetype_description, a.is_wyrd FROM {$ndb->fighter_archetype} a ORDER BY a.archetype_name ASC";
		$archetypes = $ndb->query($query);
		foreach ($archetypes as &$archetype) {
			$archetype['primary_skills'] = FighterController::getArchetypeSkills($archetype['id'], true);
			$archetype['secondary_skills'] = FighterController::getArchetypeSkills($archetype['id'], false);
		}
		return $archetypes;
	}

	public function fetchArchetypes(ServerRequestInterface $request, ResponseInterface $response): ResponseInterface {
		global $cache;
		$archetypes = $cache->get("fighter-archetypes");
		if (!$archetypes) {
			$archetypes = json_encode(ArchetypeController::getArchetypes());
			$cache->set("fighter-archetypes", $archetypes);
		}
		$response->getBody()->write($archetypes);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function fetchArchetype(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$result = ArchetypeController::getArchetypeById($args['id']);
		if ($result) {
			$response->getBody()->write(json_encode($result));
			return $response->withHeader('Content-Type', 'application/json');
		}
		return $response->withStatus(404);
	}

	public function addUpdateArchetype(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;

		$id = (array_key_exists('id', $args)) ? $args['id'] : 0;

		$archetype = json_decode($request->getBody(), true);
		$pskills = $archetype['primary_skills'];
		$sskills = $archetype['secondary_skills'];

		unset($archetype['primary_skills']);
		unset($archetype['secondary_skills']);
		if ($request->getMethod() == 'POST') {
			unset($archetype['id']);

			$insertQuery = "INSERT INTO {$ndb->fighter_archetype} (archetype_name, archetype_description, is_wyrd) VALUES (:archetype_name, :archetype_description, :is_wyrd)";
			if ($ndb->insert($insertQuery, $archetype)) {
				$archetype['id'] = $ndb->lastInsertId;
			}

		} else {
			$ndb->updateTable($ndb->fighter_archetype, $archetype);
			$archetype = ArchetypeController::getArchetypeById($id);
		}

		ArchetypeController::updateArchetypeSkill($archetype['id'], 1, $pskills);
		ArchetypeController::updateArchetypeSkill($archetype['id'], 0, $sskills);

		$cache->del(["fighter-archetypes"]);

		$response->getBody()->write(json_encode($archetype));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function removeArchetype(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $cache, $ndb;
		$id = $args['id'];
		$result = $ndb->delete("DELETE FROM {$ndb->fighter_archetype_skill_set_map} WHERE archetype_id = :id", $id);
		$result = $ndb->delete("DELETE FROM {$ndb->fighter_archetype} WHERE id = :id", $id);

		$cache->del(["fighter-archetypes"]);
		return $response->withStatus(200);
	}

	private static function updateArchetypeSkill($id, $primary, $skillSets) {
		global $ndb;
		$deleteSetMapping = "DELETE FROM {$ndb->fighter_archetype_skill_set_map} WHERE archetype_id = :archetype_id AND is_primary = :primary";
		$ndb->deleteWithParams($deleteSetMapping, [ 'archetype_id' => $id, 'primary' => $primary ]);

		foreach($skillSets as $ss) {
			$setId = $ss['id'];
			$insertQuery = "INSERT INTO {$ndb->fighter_archetype_skill_set_map} VALUES (:archetype_id, :set_id, :primary)";
			$ndb->insert($insertQuery, [ 'archetype_id' => $id, 'set_id' => $setId, 'primary' => $primary ]);
		}
	}

	public function addUpdateArchetypeSkills(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $cache, $ndb;
		$id = $args['id'];
		$primary = $args['primary'];
		$skillSets = json_decode($request->getBody(), true);

		ArchetypeController::updateArchetypeSkill($id, $primary, $skillSets);

		/* $deleteSetMapping = "DELETE FROM {$ndb->fighter_archetype_skill_set_map} WHERE archetype_id = :archetype_id AND is_primary = :primary";
		$ndb->deleteWithParams($deleteSetMapping, [ 'archetype_id' => $id, 'primary' => $primary ]);

		foreach($skillSets as $ss) {
			$setId = $ss['id'];
			$insertQuery = "INSERT INTO {$ndb->fighter_archetype_skill_set_map} VALUES (:archetype_id, :set_id, :primary)";
			$ndb->insert($insertQuery, [ 'archetype_id' => $id, 'set_id' => $setId, 'primary' => $primary ]);
		} */

		$cache->del(["fighter-archetypes"]);

		$response->getBody()->write(json_encode($skillSets));
		return $response->withHeader('Content-Type', 'application/json');
	}
}
?>