<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class UserController extends SlimController {

	public static function findOauth($token) {
		return dbQueryFirst("SELECT id, username, email_address, confirmed, registered, last_login, is_admin, oauth_key FROM necro_user WHERE oauth_key = :token", ['token' => $token]);
	}

	public static function doLogin($params) {
		$email = $params['email_address'];
		$password = $params['userpassword'];

		$user = dbQueryFirst("SELECT id, username, userpassword, email_address, confirmed, registered, last_login, is_admin, oauth_key FROM necro_user WHERE email_address = :email_address", ['email_address' => $email]);
		if (password_verify($email, PEPPER.$user['userpassword'])) {
			throw new AuthenticationException();
		}
		unset($user['userpassword']);
		$token = md5(microtime());

		setcookie('auth', $token, time() + 86400, "/");
		$user['oauth_key'] = $token;
		$_SESSION['user'] = $user;

		dbUpdate("UPDATE necro_user SET oauth_key = :token, last_login = NOW() WHERE id = :id", ['token' => $token, 'id' => $user['id']]);

		return [$user, $token];
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
		$params = json_decode($request->getBody());
		$username = $params['username'];
		$password = password_hash(PEPPER.$params['password'], PASSWORD_DEFAULT);
		$email = $password['email_address'];

		$result = dbInsert("
			INSERT INTO necro_user 
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
	
	public function peperGen(ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface {
		$pepper = password_hash(time(), PASSWORD_DEFAULT);
		$response->getBody()->write('Pepper: '.$pepper);
		return $response;
	}
}
?>