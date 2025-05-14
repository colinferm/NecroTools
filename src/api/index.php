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

$app->post('/gang-type', [\GangController::class, 'addUpdateGangType'])->add($authCheck);
$app->get('/gang-types', [\GangController::class, 'fetchGangTypes'])->add($authCheck);
$app->get('/gang-type/{id}', [\GangController::class, 'fetchGangType'])->add($authCheck);
$app->put('/gang-type/{id}', [\GangController::class, 'addUpdateGangType'])->add($authCheck);
$app->delete('/gang-type/{id}', [\GangController::class, 'deleteGangType'])->add($authCheck);
$app->get('/gang-type/{id}/fighters', [\FighterController::class, 'fetchGangTypeFighters'])->add($authCheck);

$app->get('/gang-types/{id}/roles', [\FighterController::class, 'fetchGangTemplates'])->add($authCheck);

$app->post('/fighter', [\FighterController::class, 'addFighter'])->add($authCheck);

$app->get('/fighter/roles', [\FighterController::class, 'fetchFighterRoles'])->add($authCheck);
$app->post('/fighter/role', [\FighterController::class, 'addUpdateFighterRole'])->add($authCheck);
$app->put('/fighter/role/{id}', [\FighterController::class, 'addUpdateFighterRole'])->add($authCheck);
$app->get('/fighter/role/{id}', [\FighterController::class, 'fetchFighterRole'])->add($authCheck);
$app->delete('/fighter/role/{id}', [\FighterController::class, 'deleteFighterRole'])->add($authCheck);
$app->post('/fighter/role/{id}/stats', [\FighterController::class, 'addUpdateTemplateStats'])->add($authCheck);
$app->put('/fighter/role/{id}/stats', [\FighterController::class, 'addUpdateTemplateStats'])->add($authCheck);
$app->put('/fighter/role/{id}/skills/{primary}', [\FighterController::class, 'updateTemplateSkills'])->add($authCheck);

$app->get('/fighter/template/{id}', [\FighterController::class, 'fetchFighterTemplate'])->add($authCheck);

$app->get('/fighter/{id}', [\FighterController::class, 'fetchFighter'])->add($authCheck);
$app->put('/fighter/{id}', [\FighterController::class, 'updateFighter'])->add($authCheck);


$app->post('/injury/{id}', [\FighterController::class, 'addInjury'])->add($authCheck);

$app->get('/traits', [\WeaponController::class, 'fetchTraits'])->add($authCheck);
$app->post('/trait', [\WeaponController::class, 'addTrait'])->add($authCheck);
$app->get('/trait/{id}', [\WeaponController::class, 'fetchTrait'])->add($authCheck);
$app->put('/trait/{id}', [\WeaponController::class, 'updateTrait'])->add($authCheck);
$app->delete('/trait/{id}', [\WeaponController::class, 'deleteTrait'])->add($authCheck);

$app->get('/skills', [\FighterController::class, 'skills']);

$app->get('/skill-set/{id}', [\FighterController::class, 'getSkillSet']);
$app->post('/skill-set', [\FighterController::class, 'addUpdateSkillSet']);
$app->put('/skill-set/{id}', [\FighterController::class, 'addUpdateSkillSet']);
//$app->delete('/skill-set/{id}', [\FighterController::class, 'skillSet']);

$app->get('/skill/{id}', [\FighterController::class, 'getSkill']);
$app->post('/skill', [\FighterController::class, 'addUpdateSkill']);
$app->put('/skill/{id}', [\FighterController::class, 'addUpdateSkill']);
$app->delete('/skill/{id}', [\FighterController::class, 'deleteSkill']);

$app->get('/weapons', [\WeaponController::class, 'fetchWeapons'])->add($authCheck);

$app->run();

if ($isCache) $cache->close();
?>