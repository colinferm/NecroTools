<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;

$authCheck = function(ServerRequestInterface $request, RequestHandler $handler) {

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
	//$response = $next($request, $response);
	//return $response;
	return $handler->handle($request);
};

class UserController extends SlimController {

	public static function findOauth($token) {
		global $ndb, $cache;
		$userJSON = $cache->get("user-{$token}");
		if ($userJSON) return json_decode($userJSON, true);

		$user = $ndb->queryFirst("SELECT id, username, email_address, confirmed, registered, last_login, is_admin, oauth_key FROM {$ndb->user} WHERE oauth_key = :token", ['token' => $token]);
		if ($user) {
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

	public function register(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		global $ndb;
		$params = json_decode($request->getBody());
		$username = $params['username'];
		$password = password_hash(PEPPER.$params['password'], PASSWORD_DEFAULT);
		$email = $password['email_address'];

		$result = $ndb->insert("
			INSERT INTO {$ndb->user}
				(user_name, userpassword, email_address, confirmed, last_login, is_admin, oauth_key) 
			VALUES 
				(:username, :userpassword, :email, 0, NOW(), 0, '')
		", ['username' => $username, 'userpassword' => $password, 'email' => $email]);

		if ($result) {
			list($user, $token) = UserController::doLogin($params);
			$response->getBody()->write(json_encode($user));
			return $response->withHeader('Content-Type', 'application/json')->withHeader("Authorization", "OAuth oauth_token=".$token);
		} else {
			throw new AuthenticationException();
		}
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
}
?>