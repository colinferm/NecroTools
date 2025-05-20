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
$app->post('/registerValidation', [\UserController::class, 'registerValidation']);
$app->post('/verify', [\UserController::class, 'verify']);
$app->get('/password', [\UserController::class, 'passwordGen']);
$app->get('/pepper', [\UserController::class, 'pepperGen']);

$app->get('/site-users', [\UserController::class, 'getSiteUsers'])->add(new NecroUserValidation(['ADM-USER']));

$app->get('/gangs', [\GangController::class, 'fetchGangs'])->add(new NecroUserValidation([]));

$app->post('/gang', [\GangController::class, 'addGang'])->add(new NecroUserValidation([]));
$app->get('/gang/{id}', [\GangController::class, 'fetchGang'])->add(new NecroUserValidation([]));
$app->put('/gang/{id}', [\GangController::class, 'updateGang'])->add(new NecroUserValidation([]));
$app->get('/gang/{id}/fighters', [\FighterController::class, 'fetchGangFighters'])->add(new NecroUserValidation([]));

$app->post('/gang-type', [\GangController::class, 'addUpdateGangType'])->add(new NecroUserValidation(['ADM-DATA']));
$app->get('/gang-types', [\GangController::class, 'fetchGangTypes'])->add(new NecroUserValidation(['ADM-DATA']));
$app->get('/gang-type/{id}', [\GangController::class, 'fetchGangType'])->add(new NecroUserValidation(['ADM-DATA']));
$app->put('/gang-type/{id}', [\GangController::class, 'addUpdateGangType'])->add(new NecroUserValidation(['ADM-DATA']));
$app->delete('/gang-type/{id}', [\GangController::class, 'deleteGangType'])->add(new NecroUserValidation(['ADM-DATA']));
$app->get('/gang-type/{id}/fighters', [\FighterController::class, 'fetchGangTypeFighters'])->add(new NecroUserValidation([]));

$app->get('/gang-types/{id}/roles', [\FighterController::class, 'fetchGangTemplates'])->add(new NecroUserValidation([]));

$app->post('/fighter', [\FighterController::class, 'addFighter'])->add(new NecroUserValidation([]));

$app->get('/fighter/roles', [\FighterController::class, 'fetchFighterRoles'])->add(new NecroUserValidation([]));
$app->post('/fighter/role', [\FighterController::class, 'addUpdateFighterRole'])->add(new NecroUserValidation(['ADM-DATA']));
$app->put('/fighter/role/{id}', [\FighterController::class, 'addUpdateFighterRole'])->add(new NecroUserValidation(['ADM-DATA']));
$app->get('/fighter/role/{id}', [\FighterController::class, 'fetchFighterRole'])->add(new NecroUserValidation([]));
$app->delete('/fighter/role/{id}', [\FighterController::class, 'deleteFighterRole'])->add(new NecroUserValidation(['ADM-DATA']));
$app->post('/fighter/role/{id}/stats', [\FighterController::class, 'addUpdateTemplateStats'])->add(new NecroUserValidation(['ADM-DATA']));
$app->put('/fighter/role/{id}/stats', [\FighterController::class, 'addUpdateTemplateStats'])->add(new NecroUserValidation(['ADM-DATA']));
$app->put('/fighter/role/{id}/skills/{primary}', [\FighterController::class, 'updateTemplateSkills'])->add(new NecroUserValidation(['ADM-DATA']));

$app->get('/fighter/template/{id}', [\FighterController::class, 'fetchFighterTemplate'])->add(new NecroUserValidation(['ADM-DATA']));

$app->get('/fighter/{id}', [\FighterController::class, 'fetchFighter'])->add(new NecroUserValidation([]));
$app->put('/fighter/{id}', [\FighterController::class, 'updateFighter'])->add(new NecroUserValidation([]));


$app->post('/injury/{id}', [\FighterController::class, 'addInjury'])->add(new NecroUserValidation([]));

$app->get('/traits', [\WeaponController::class, 'fetchTraits'])->add(new NecroUserValidation([]));
$app->post('/trait', [\WeaponController::class, 'addTrait'])->add(new NecroUserValidation(['ADM-DATA']));
$app->get('/trait/{id}', [\WeaponController::class, 'fetchTrait'])->add(new NecroUserValidation([]));
$app->put('/trait/{id}', [\WeaponController::class, 'updateTrait'])->add(new NecroUserValidation(['ADM-DATA']));
$app->delete('/trait/{id}', [\WeaponController::class, 'deleteTrait'])->add(new NecroUserValidation(['ADM-DATA']));

$app->get('/skills', [\FighterController::class, 'skills']);

$app->get('/skill-set/{id}', [\FighterController::class, 'getSkillSet']);
$app->post('/skill-set', [\FighterController::class, 'addUpdateSkillSet']);
$app->put('/skill-set/{id}', [\FighterController::class, 'addUpdateSkillSet']);
//$app->delete('/skill-set/{id}', [\FighterController::class, 'skillSet']);

$app->get('/skill/{id}', [\FighterController::class, 'getSkill']);
$app->post('/skill', [\FighterController::class, 'addUpdateSkill']);
$app->put('/skill/{id}', [\FighterController::class, 'addUpdateSkill']);
$app->delete('/skill/{id}', [\FighterController::class, 'deleteSkill']);

$app->get('/weapons', [\WeaponController::class, 'fetchWeapons'])->add(new NecroUserValidation([]));
$app->get('/weapons/category/{id}', [\WeaponController::class, 'fetchWeaponsByCategory'])->add(new NecroUserValidation([]));
$app->get('/weapon/{id}', [\WeaponController::class, 'fetchWeaponById'])->add(new NecroUserValidation([]));

$app->run();

if ($isCache) $cache->close();
?>