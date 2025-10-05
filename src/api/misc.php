<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class OtherDataController extends SlimController {

	public static function fetchLookups(ServerRequestInterface $request, ResponseInterface $response): ResponseInterface  {
		global $ndb, $cache;
		$lookups = $cache->get("lookups");
		if (!$lookups) {
			$lookupQuery = "
				SELECT id, gang_type_id, lookup_value, lookup_key, misc_value, is_special_attribute, is_gang_related, is_fighter_related, notes
				FROM {$ndb->lookups}
				WHERE lookup_key != 'WEAPON_TRAIT'
				ORDER BY lookup_key ASC, lookup_value ASC, is_special_attribute ASC
			";
			$data = $ndb->query($lookupQuery);
			$lookups = json_encode($data);
			$cache->setEx("lookups", 300, $lookups);
		}
		$response->getBody()->write($lookups);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public static function fetchLookupByCode(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface  {
		global $ndb, $cache;
		$code = $args['code'];
		$lookups = $cache->get("lookups-{$code}");
		if (!$lookups) {
			$lookupQuery = "
				SELECT id, gang_type_id, lookup_value, lookup_key, misc_value, is_special_attribute, is_gang_related, is_fighter_related, notes
				FROM {$ndb->lookups}
				WHERE lookup_key = :code
				ORDER BY lookup_key ASC, lookup_value ASC, is_special_attribute ASC
			";
			$data = $ndb->query($lookupQuery, ['code' => $code]);
			$lookups = json_encode($data);
			$cache->setEx("lookups-{$code}", DEFAULT_CACHE_TIME, $lookups);
		}
		$response->getBody()->write($lookups);
		return $response->withHeader('Content-Type', 'application/json');
	}

	private static function fetchLookupById($id) {
		global $ndb;
		$lookupQuery = "
			SELECT id, gang_type_id, lookup_value, lookup_key, misc_value, is_special_attribute, is_gang_related, is_fighter_related, notes
			FROM {$ndb->lookups}
			WHERE id = :id
			ORDER BY lookup_key ASC, lookup_value ASC, is_special_attribute ASC
		";
		return $ndb->queryFirst($lookupQuery, ['id' => $id]);
	}

	public static function fetchLookup(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$id = $args['id'];
		$lookup = $cache->get("lookup-{$id}");
		if (!$lookup) {
			$data = OtherDataController::fetchLookupById($id);
			$lookup = json_encode($data);
			$cache->setEx("lookup-{$id}", DEFAULT_CACHE_TIME, $lookup);
		}
		$response->getBody()->write($lookup);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public static function addUpdateLookup(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;

		$id = (array_key_exists('id', $args)) ? $args['id'] : 0;

		$lookup = json_decode($request->getBody(), true);

		if ($request->getMethod() == 'POST') {
			unset($lookup['id']);

			$insertQuery = "
				INSERT INTO {$ndb->lookups} (
					gang_type_id, 
					lookup_value, 
					misc_value, 
					lookup_key, 
					is_special_attribute, 
					is_gang_related, 
					is_fighter_related, 
					notes
				) VALUES (
				 	:gang_type_id, 
					:lookup_value, 
					:misc_value, 
					:lookup_key, 
					:is_special_attribute, 
					:is_gang_related, 
					:is_fighter_related, 
					:notes
				)
				";
			if ($ndb->insert($insertQuery, $lookup)) {
				$lookup['id'] = $ndb->lastInsertId;
			}

		} else {
			$ndb->updateTable($ndb->lookups, $lookup);
			$lookup = OtherDataController::fetchLookupById($id);
		}
		$cache->del(["lookups"]);

		$response->getBody()->write(json_encode($lookup));
		return $response->withHeader('Content-Type', 'application/json');
	}

	public static function removeLookup(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;
		$id = $args['id'];
		$ndb->deleteFromTable($ndb->lookups, $id);
		$cache->del(["lookups"]);
		return $response->withStatus(200);
	}
}