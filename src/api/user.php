<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;

class NecroUserValidation {
	private $requiredPermissions = array();

	public function __construct(array $permissionGroups) {
		$this->requiredPermissions = $permissionGroups;
	}

	public function __invoke(ServerRequestInterface $request, RequestHandler $handler) {

		$oauth = $request->getHeaderLine("Authorization");
		$token = null;
	
		if (isset($oauth) && !empty($oauth)) {
			$token = $pairs[1];
		}
		$sessionToken = isset($_COOKIE['auth']) ? $_COOKIE['auth'] : null;
	
		if (empty($token) && !empty($sessionToken)) {
			$token = $sessionToken;
		}
	
		if (!is_null($token)) {
			if (isset($_SESSION['user'])) $user = $_SESSION['user'];
	
			if (isset($user) && !is_null($user)) {
				if (!isset($user['oauth_key']) || $user['oauth_key'] != $token) {
					$oauth = UserController::findOauth($token);
	
					if (!isset($oauth) || empty($oauth) || $oauth->id != $user->id) {
						unset($user);
					}
				}
			} 
	
			if (!isset($user) || is_null($user)) {
				$user = UserController::findOauth($token);
				if (!empty($user)) $_SESSION['user'] = $user;
			}
		}

		if (!isset($_SESSION['user'])) {
			error_log('  Not authorized', 0);
			throw new AuthenticationException();
		} 

		if (count($this->requiredPermissions) > 0) {
			$hasGroup = false;
			foreach ($this->requiredPermissions as $reqired) {
				foreach($user['permissions'] as $perm) {
					if ($perm['code'] == 'ADM-SITE' || $reqired == $perm['code']) {
						$hasGroup = true;
						break;
					}
				}
				if ($hasGroup) break;
			}
			if (!$hasGroup) {
				throw new AuthenticationException();
			}
		}

		return $handler->handle($request);
	}
}

class UserController extends SlimController {

	public static function findOauth($token) {
		global $ndb, $cache;
		$userJSON = $cache->get("user-{$token}");
		if ($userJSON) return json_decode($userJSON, true);

		$user = $ndb->queryFirst("SELECT id, username, email_address, confirmed, registered, last_login, is_admin, oauth_key FROM {$ndb->user} WHERE oauth_key = :token", ['token' => $token]);
		if ($user) {
			$permissions = UserCOntroller::getPermissionsForUserId($user['id']);
			$user['permissions'] = $permissions;
			$cache->setEx("user-{$token}", 300, json_encode($user));
			return $user;
		}
	}

	public static function doLogin($params) {
		global $ndb, $cache;
		$email = $params['email_address'];
		$password = $params['userpassword'];

		$user = $ndb->queryFirst("SELECT id, username, userpassword, email_address, confirmed, registered, last_login, is_admin, oauth_key FROM necro_user WHERE (email_address = :email_address OR username = :email_address)", ['email_address' => $email]);
		if (password_verify($email, PEPPER.$user['userpassword'])) {
			throw new AuthenticationException();
		}
		unset($user['userpassword']);
		$token = md5(microtime());

		$permissions = UserCOntroller::getPermissionsForUserId($user['id']);
		$user['permissions'] = $permissions;

		setcookie('auth', $token, time() + 86400, "/");
		$user['oauth_key'] = $token;
		$_SESSION['user'] = $user;

		$ndb->update("UPDATE {$ndb->user} SET oauth_key = :token, last_login = NOW() WHERE id = :id", ['token' => $token, 'id' => $user['id']]);
		$cache->setEx("user-{$token}", 300, json_encode($user));

		return [$user, $token];
	}

	public static function getCurrentUser() {
		if (isset($_SESSION['user'])) return $_SESSION['user'];
	}

	public static function getCurrentUserId() {
		if (isset($_SESSION['user'])) return $_SESSION['user']['id'];
	}

	public function login(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$params = $request->getParsedBody();
		
		list($user, $token) = UserController::doLogin($params);

		$response->getBody()->write(json_encode($user));
		return $response->withHeader('Content-Type', 'application/json')->withHeader("Authorization", "OAuth oauth_token=".$token);
	}

	public function verify(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$body = $request->getBody()->getContents();
		$auth = json_decode($body);
		
		$user = UserController::findOauth($auth->oauth_key);

		if ($user) {
			$response->getBody()->write(json_encode($user));
			return $response->withHeader('Content-Type', 'application/json')->withHeader("Authorization", "OAuth oauth_token=".$auth->oauth_key);
		} else {
			throw new AuthenticationException();
		}
	}

	public function registerValidation(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$params = $request->getParsedBody();
		$field = $params['field'];
		$value = $params['value'];

		if ($field == 'email_address') {
			$validationQuery = "SELECT * FROM {$ndb->user} WHERE email_address = :value";
		} else {
			$validationQuery = "SELECT * FROM {$ndb->user} WHERE username = :value";
		}
		$exists = $ndb->queryFirst($validationQuery, ['value' => $value]);

		if ($exists) {
			return $response->withStatus(406);
		}
		return $response->withStatus(200);
	}

	public function register(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$params = json_decode($request->getBody());
		$username = $params['username'];
		$password = password_hash(PEPPER.$params['password'], PASSWORD_DEFAULT);
		$email = $params['email_address'];

		$result = $ndb->insert("
			INSERT INTO {$ndb->user}
				(user_name, userpassword, email_address, confirmed, last_login, is_admin, oauth_key) 
			VALUES 
				(:username, :userpassword, :email, 0, NOW(), 0, '')
		", ['username' => $username, 'userpassword' => $password, 'email' => $email]);

		if ($result) {
			list($user, $token) = UserController::doLogin($params);
			$this->assignPermissions($user);

			$response->getBody()->write(json_encode($user));
			return $response->withHeader('Content-Type', 'application/json')->withHeader("Authorization", "OAuth oauth_token=".$token);
		} else {
			throw new AuthenticationException();
		}
	}

	public function addSiteUser(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;

		$params = json_decode($request->getBody(), true);
		$username = $params['username'];
		$emailAddress = $params['email_address'];
		$firstName = $params['first_name'];
		$lastName = $params['last_name'];
		$confirmed = $params['confirmed'];
		$permissions = $params['permissions'];

		if (array_key_exists('generate_password', $params) && $parma['generate_password'] == 'generate-password') {
			$params['password'] = static::buildPassword();
			error_log("Generated Password: " . $params['password']);
		}
		$password = password_hash(PEPPER.$params['password'], PASSWORD_DEFAULT);

		$isAdmin = (count($permissions) > 1) ? 1 : 0;

		$result = $ndb->insert("
			INSERT INTO {$ndb->user}
				(username, userpassword, email_address, first_name, last_name, confirmed, registered, last_login, is_admin, oauth_key) 
			VALUES 
				(:username, :userpassword, :email_address, :first_name, :last_name, :confirmed, NOW(), NOW(), :is_admin, '')
		", [
			'username' => $username, 
			'userpassword' => $password, 
			'email_address' => $emailAddress, 
			'first_name' => $firstName,
			'last_name' => $lastName,
			'confirmed' => $confirmed, 
			'is_admin' => $isAdmin
		]);

		if ($result) {
			$user = static::getUserById($ndb->lastInsertId);

			$this->assignPermissions($user, $permissions);

			$cache->del("site-users");

			$response->getBody()->write(json_encode($user));
			return $response->withHeader('Content-Type', 'application/json');
		} else {
			return $response->withStatus(500);
		}
	}

	public function updateSiteUser(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;

		$userId = $args['id'];

		$params = json_decode($request->getBody(), true);
		$permissions = $params['permissions'];
		$genPassword = $params['generate_password'];

		$params['id'] = $userId;
		$params['is_admin'] = (count($permissions) > 1) ? 1 : 0;

		unset($params['permissions']);
		unset($params['generate_password']);
		if ($genPassword != 'leave-password') {
			$tempPassword = $params['userpassword'];

			if ($genPassword == 'generate-password') {
				$tempPassword = static::buildPassword();
			}
			$params['userpassword'] = password_hash(PEPPER.$tempPassword, PASSWORD_DEFAULT);
		}
		unset($params['password']);

		$ndb->updateTable($ndb->user, $params);

		$user = static::getUserById($userId);
		$this->assignPermissions($user, $permissions);

		$cache->del("site-users");

		$response->getBody()->write(json_encode($user));
		return $response->withHeader('Content-Type', 'application/json');
	}

	private function assignPermissions(&$user, $permissions = array(array('id' => 4, 'code' => 'USR-SITE'))) {
		global $ndb;

		$ndb->deleteWithParams("DELETE FROM {$ndb->permission_map} WHERE user_id = :user_id", ['user_id' => $user['id']]);

		foreach ($permissions as $perm) {
			$ndb->insert("INSERT INTO {$ndb->permission_map} (user_id, permission_id) VALUES (:user_id, :permission_id)", ['user_id' => $user['id'], 'permission_id' => $perm['id']]);
		}
		$user['permissions'] = $permissions;
		return $user;
	}

	public static function getPermissionsForUserId($userId) {
		global $ndb;
		return $ndb->query("SELECT p.id, p.code FROM {$ndb->permission} p, {$ndb->permission_map} pm WHERE p.id = pm.permission_id AND pm.user_id = :user_id", ['user_id' => $userId]);
	}

	public static function getUserPermissionsJSON() {
		global $ndb, $cache;
		$perms = $cache->get("user-permissions");
		if (!$perms) {
			$results = $ndb->query("SELECT p.id, p.permisson, p.code FROM {$ndb->permission} p ORDER BY p.id ASC");
			$perms = json_encode($results);
			$cache->set("user-permissions", $perms);
		}
		return $perms;
	}

	public static function buildPassword($minLen = 10, $maxLen = 12) {
		return PasswordUtils::buildPassword($minLen, $maxLen);
	}

	public function passwordGen(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$params = $request->getQueryParams();
		$password = password_hash(PEPPER.$params['password'], PASSWORD_DEFAULT);
		$response->getBody()->write('Password: '.$password);
		return $response;
	}
	
	public function pepperGen(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$pepper = password_hash(time(), PASSWORD_DEFAULT);
		$response->getBody()->write('Pepper: '.$pepper);
		return $response;
	}


	public function getSiteUsers(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb, $cache;

		$users = $cache->get("site-users");
		if (!$users) {
			$userResults = $ndb->query("SELECT id, username, email_address, first_name, last_name, country, confirmed, registered, last_login FROM {$ndb->user} ORDER BY last_login DESC");
			foreach($userResults as &$user) {
				$perms = static::getPermissionsForUserId($user['id']);
				$user['permissions'] = $perms;
			}
			$users = json_encode($userResults);
			$cache->set("site-users", $users);
		}
		$response->getBody()->write($users);
		return $response->withHeader('Content-Type', 'application/json');
	}

	public function fetchUserById(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$id = $args['id'];
		$user = static::getUserById($id);
		if ($user) {
			$response->getBody()->write(json_encode($user));
			return $response->withHeader('Content-Type', 'application/json');
		}
		return $response->withStatus(404);
	}

	public static function getUserById($id) {
		global $ndb;
		$user = $ndb->queryFirst("SELECT id, username, email_address, first_name, last_name, country, confirmed, registered, last_login FROM {$ndb->user} WHERE id = :id ORDER BY last_login DESC", ['id' => $id]);
		$perms = static::getPermissionsForUserId($user['id']);
		$user['permissions'] = $perms;

		return $user;
	}
}
?>