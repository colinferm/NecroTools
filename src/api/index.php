<?php
require_once('./_config.php');
require_once('./necrodb.php');

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
$app->get('/password', [\UserController::class, 'passwordGen']);
$app->get('/pepper', [\UserController::class, 'pepperGen']);

$app->get('/gangs', [\GangController::class, 'fetchGangs'])->add($authCheck);

$app->post('/gang', [\GangController::class, 'addGang'])->add($authCheck);
$app->get('/gang/{id}', [\GangController::class, 'fetchGang'])->add($authCheck);
$app->put('/gang/{id}', [\GangController::class, 'updateGang'])->add($authCheck);
$app->get('/gang/{id}/fighters', [\FighterController::class, 'fetchGangFighters'])->add($authCheck);

$app->post('/fighter', [\FighterController::class, 'addFighter'])->add($authCheck);
$app->get('/fighter/{id}', [\FighterController::class, 'fetchFighter'])->add($authCheck);
$app->put('/fighter/{id}', [\FighterController::class, 'updateFighter'])->add($authCheck);

$app->get('/traits', [\WeaponController::class, 'fetchTraits'])->add($authCheck);
$app->post('/trait', [\WeaponController::class, 'addTrait'])->add($authCheck);
$app->get('/trait/{id}', [\WeaponController::class, 'fetchTrait'])->add($authCheck);
$app->put('/trait/{id}', [\WeaponController::class, 'updateTrait'])->add($authCheck);

$app->get('/weapons', [\WeaponController::class, 'fetchWeapons'])->add($authCheck);

$app->post('/injury/{id}', [\FighterController::class, 'addInjury'])->add($authCheck);

$app->run();

if ($isCache) $cache->close();
?>