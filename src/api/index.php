<?php
// SET UP SLIM
require_once('./_config.php');
require_once('./utils.php');
require_once('./lib/vendor/autoload.php');
require_once('./slim_controller.php');
require_once('./gang.php');
require_once('./fighter.php');
require_once('./user.php');
require_once('./weapon.php');

use Slim\Factory\AppFactory;

$app = AppFactory::create();
$app->setBasePath("/api");
$app->post('/login', [\UserController::class, 'login']);
$app->post('/register', [\UserController::class, 'register']);
$app->post('/verify', [\UserController::class, 'verify']);
//$app->get('/password', [\UserController::class, 'passwordGen']);

$app->get('/gangs', [\GangController::class, 'fetchGangs']);

$app->post('/gang', [\GangController::class, 'addGang']);
$app->get('/gang/{id}', [\GangController::class, 'fetchGang']);
$app->put('/gang/{id}', [\GangController::class, 'updateGang']);
$app->get('/gang/{id}/fighters', [\FighterController::class, 'fetchGangFighters']);

$app->post('/fighter', [\FighterController::class, 'addFighter']);
$app->get('/fighter/{id}', [\FighterController::class, 'addFighter']);
$app->put('/fighter/{id}', [\FighterController::class, 'updateFighter']);

$app->get('/traits', [\WeaponController::class, 'fetchTraits']);
$app->post('/trait', [\WeaponController::class, 'addTrait']);
$app->get('/trait/{id}', [\WeaponController::class, 'fetchTrait']);
$app->put('/trait/{id}', [\WeaponController::class, 'updateTrait']);

$app->get('/weapons', [\WeaponController::class, 'fetchWeapons']);

$app->run();
?>