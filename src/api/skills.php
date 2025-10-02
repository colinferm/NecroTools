<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class SkillsController extends SlimController {
	public static function getSkills($id = 0) {
		global $ndb;
		$params = array();
		$query = "
			SELECT ss.id, ss.skill_set_name, ss.limited_to_gang, ss.is_wyrd, ss.gang_type_id, gt.type_name AS gang_name
			FROM {$ndb->skill_set} ss
			LEFT JOIN {$ndb->gang_type} gt ON ss.gang_type_id = gt.id
			WHERE 1 = 1
		";

		if ($id > 0) {
			$query .= "
				AND ss.id = :ss_id
			"; 	
			$params['ss_id'] = $id;
		}

		$query .= "
			ORDER BY ss.limited_to_gang ASC, ss.is_wyrd, ss.skill_set_name ASC
		";
		$results = $ndb->query($query, $params);

		$skillSets = array();
		foreach ($results as $s) {
			$query = "
				SELECT s.id, s.skill_name, s.skill_set_id, s.skill_description  
				FROM {$ndb->skill} s 
				WHERE s.skill_set_id = :skillset_id
				ORDER BY s.skill_name ASC
			";
			$skills = $ndb->query($query, array("skillset_id" => $s['id']));
			$s['skills'] = $skills;
			$skillSets[] = $s;
		}
		if ($id > 0) return $skillSets[0];
		return $skillSets;
	}

	public static function getSkillsJSON() {
		global $cache;
		$skills = null;
		$skills = $cache->get("fighter-skills");
		if (!$skills) {
			$skills = json_encode(SkillsController::getSkills());
			$cache->set("fighter-skills", $skills);
		}
		return $skills;
	}

	public function skills(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$skills = SkillsController::getSkills();
		$response->getBody()->write(json_encode($skills));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function getSkillSet(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$skills = SkillsController::getSkills($args['id']);
		$response->getBody()->write(json_encode($skills));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addUpdateSkillSet(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;

		$id = (array_key_exists('id', $args)) ? $args['id'] : 0;

		$skillSet = json_decode($request->getBody(), true);
		unset($skillSet['skills']);
		unset($skillSet['gang_name']);
		if ($request->getMethod() == 'POST') {
			unset($skillSet['id']);

			$insertQuery = "INSERT INTO {$ndb->skill_set} (skill_set_name, limited_to_gang, is_wyrd, gang_type_id) VALUES (:skill_set_name, :limited_to_gang, :is_wyrd, :gang_type_id)";
			if ($ndb->insert($insertQuery, $skillSet)) {
				$skillSet['id'] = $ndb->lastInsertId;
			}

		} else {
			$ndb->updateTable($ndb->skill_set, $skillSet);
			/* $updateQuery = "UPDATE {$ndb->skill_set} SET ";
			$i = 0;
			foreach ($skillSet as $key => $val) {
				if ($key == 'id') continue;
				if ($i > 0) $updateQuery .= ", ";
				$updateQuery .= "{$key} = :{$key}";
				$i++;
			}
			$updateQuery .= " WHERE id = :id";
			$result = $ndb->update($updateQuery, $skillSet); */
			$skillSet = SkillsController::getSkills($id);
		}

		$response->getBody()->write(json_encode($skillSet));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function fetchSkill($id) {
		global $ndb;

		$skillQuery = "
			SELECT s.id, s.skill_set_id, s.skill_name, s.skill_description, ss.skill_set_name, ss.is_wyrd
			FROM {$ndb->skill} s, {$ndb->skill_set} ss 
			WHERE s.skill_set_id = ss.id
			AND s.id = :id
		";
		return $ndb->query($skillQuery, array("id" => $id));
	}

	public function getSkill(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$id = $args['id'];

		$skill = $this->fetchSkill($id);

		$response->getBody()->write(json_encode($skill));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function addUpdateSkill(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;

		$id = (array_key_exists('id', $args)) ? $args['id'] : 0;
		$skill = json_decode($request->getBody(), true);
		unset($skill['skill_set_name']);

		if ($request->getMethod() == 'POST') {
			unset($skill['id']);
			$insertQuery = "INSERT INTO {$ndb->skill} (skill_set_id, skill_name, skill_description) VALUES (:skill_set_id, :skill_name, :skill_description)";
			if ($result = $ndb->insert($insertQuery, $skill)) {
				$id = $ndb->lastInsertId;
			}
		} else {
			$ndb->updateTable($ndb->skill, $skill);
		}
		$skills = $this->fetchSkill($id);
		if (is_array($skills)) $skill = $skills[0];
		$response->getBody()->write(json_encode($skill));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function deleteSkill(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$id = $args['id'];
		$result = $ndb->deleteFromTable($ndb->skill, $id);
		if ($result) {
			$response->withStatus(200);
		} else {
			$response->withStatus(500);
		}
		return $response;
	}
}
?>