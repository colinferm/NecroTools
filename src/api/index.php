<?php
require_once('./_config.php');
require_once('./necrodb.php');

require_once('./utils.php');
require_once('./lib/vendor/autoload.php');
require_once('./slim_controller.php');
require_once('./archetype.php');
require_once('./fighter.php');
require_once('./gang.php');
require_once('./skills.php');
require_once('./user.php');
require_once('./weapon.php');

use Slim\Factory\AppFactory;
use Slim\Routing\RouteCollectorProxy;

$app = AppFactory::create();
$app->setBasePath("/api");

$requireLoggedIn = new NecroUserValidation([]);
$requireUserAdmin = new NecroUserValidation(['ADM-USER']);
$requireDataAdmin = new NecroUserValidation(['ADM-DATA']);

/* Basic */
$app->post('/login', [\UserController::class, 'login']);
$app->post('/register', [\UserController::class, 'register']);
$app->post('/registerValidation', [\UserController::class, 'registerValidation']);
$app->post('/verify', [\UserController::class, 'verify']);
$app->get('/verify-nonce/{nonce}', [\UserController::class, 'validateNonce']);
$app->get('/password', [\UserController::class, 'passwordGen']);
$app->get('/pepper', [\UserController::class, 'pepperGen']);
$app->get('/nonce/{id}', [\UserController::class, 'nonceGen']);
$app->put('/user-profile/{id}', [\UserController::class, 'updateProfile'])->add($requireLoggedIn);

/* Admin */
$app->get('/site-users', [\UserController::class, 'getSiteUsers'])->add($requireUserAdmin);
$app->post('/site-users', [\UserController::class, 'addSiteUser'])->add($requireUserAdmin);
$app->get('/site-users/{id}', [\UserController::class, 'fetchUserById'])->add($requireUserAdmin);
$app->put('/site-users/{id}', [\UserController::class, 'updateSiteUser'])->add($requireUserAdmin);
$app->delete('/site-users/{id}', [\UserController::class, 'deleteSiteUser'])->add($requireUserAdmin);

$app->post('/gang-type', [\GangController::class, 'addUpdateGangType'])->add($requireDataAdmin);
$app->get('/gang-types', [\GangController::class, 'fetchGangTypes'])->add($requireDataAdmin);
$app->get('/gang-type/{id}', [\GangController::class, 'fetchGangType'])->add($requireDataAdmin);
$app->put('/gang-type/{id}', [\GangController::class, 'addUpdateGangType'])->add($requireDataAdmin);
$app->delete('/gang-type/{id}', [\GangController::class, 'deleteGangType'])->add($requireDataAdmin);

$app->get('/gang-type/{id}/fighters', [\FighterController::class, 'fetchGangTypeFighters'])->add($requireLoggedIn);
$app->get('/gang-types/{id}/roles', [\FighterController::class, 'fetchGangTemplates'])->add($requireLoggedIn);

$app->get('/fighter/roles', [\FighterController::class, 'fetchFighterRoles'])->add($requireLoggedIn);
$app->post('/fighter/role', [\FighterController::class, 'addUpdateFighterRole'])->add($requireDataAdmin);
$app->put('/fighter/role/{id}', [\FighterController::class, 'addUpdateFighterRole'])->add($requireDataAdmin);
$app->get('/fighter/role/{id}', [\FighterController::class, 'fetchFighterRole'])->add($requireLoggedIn);
$app->delete('/fighter/role/{id}', [\FighterController::class, 'deleteFighterRole'])->add($requireDataAdmin);
$app->post('/fighter/role/{id}/stats', [\FighterController::class, 'addUpdateTemplateStats'])->add($requireDataAdmin);
$app->put('/fighter/role/{id}/stats', [\FighterController::class, 'addUpdateTemplateStats'])->add($requireDataAdmin);
$app->put('/fighter/role/{id}/skills/{primary}', [\FighterController::class, 'updateTemplateSkills'])->add($requireDataAdmin);

$app->get('/archetypes', [\ArchetypeController::class, 'fetchArchetypes']);
$app->put('/archetypes/{id}/sets/{primary}', [\ArchetypeController::class, 'updateArchetypeSkills']);
$app->post('/archetype', [\ArchetypeController::class, 'addUpdateArchetype'])->add($requireLoggedIn);
$app->get('/archetype/{id}', [\ArchetypeController::class, 'fetchArchetype']);
$app->put('/archetype/{id}', [\ArchetypeController::class, 'addUpdateArchetype'])->add($requireLoggedIn);
$app->delete('/archetype/{id}', [\ArchetypeController::class, 'removeArchetype'])->add($requireLoggedIn);

$app->get('/fighter/template/{id}', [\FighterController::class, 'fetchFighterTemplate'])->add($requireDataAdmin);

$app->get('/traits', [\WeaponController::class, 'fetchTraits'])->add($requireLoggedIn);
$app->post('/trait', [\WeaponController::class, 'addTrait'])->add($requireDataAdmin);
$app->get('/trait/{id}', [\WeaponController::class, 'fetchTrait'])->add($requireLoggedIn);
$app->put('/trait/{id}', [\WeaponController::class, 'updateTrait'])->add($requireDataAdmin);
$app->delete('/trait/{id}', [\WeaponController::class, 'deleteTrait'])->add($requireDataAdmin);

$app->post('/weapon-characteristic', [\WeaponController::class, 'addCharacteristic'])->add($requireDataAdmin);
$app->get('/weapon-characteristic/{id}', [\WeaponController::class, 'fetchCharacteristic'])->add($requireLoggedIn);
$app->put('/weapon-characteristic/{id}', [\WeaponController::class, 'updateCharacteristic'])->add($requireDataAdmin);
$app->delete('/weapon-characteristic/{id}', [\WeaponController::class, 'deleteCharacteristic'])->add($requireDataAdmin);

$app->get('/skills', [\SkillsController::class, 'skills']);

$app->get('/skill-set/{id}', [\SkillsController::class, 'getSkillSet']);
$app->post('/skill-set', [\SkillsController::class, 'addUpdateSkillSet'])->add($requireDataAdmin);
$app->put('/skill-set/{id}', [\SkillsController::class, 'addUpdateSkillSet'])->add($requireDataAdmin);

$app->get('/skill/{id}', [\SkillsController::class, 'getSkill']);
$app->post('/skill', [\SkillsController::class, 'addUpdateSkill'])->add($requireDataAdmin);
$app->put('/skill/{id}', [\SkillsController::class, 'addUpdateSkill'])->add($requireDataAdmin);
$app->delete('/skill/{id}', [\SkillsController::class, 'deleteSkill'])->add($requireDataAdmin);

$app->get('/weapons', [\WeaponController::class, 'fetchWeapons'])->add($requireLoggedIn);
$app->get('/weapons/category/{id}', [\WeaponController::class, 'fetchWeaponsByCategory'])->add($requireLoggedIn);
$app->get('/weapon/{id}', [\WeaponController::class, 'fetchWeaponById'])->add($requireLoggedIn);
$app->get('/weapon/{id}/characteristics', [\WeaponController::class, 'fetchCharacteristicsForWeaponId'])->add($requireLoggedIn);

$app->get('/gear', [\WeaponController::class, 'fetchGear'])->add($requireLoggedIn);
$app->post('/gear', [\WeaponController::class, 'addUpdateGear'])->add($requireDataAdmin);
$app->get('/gear/category/{id}', [\WeaponController::class, 'fetchGearByCategory'])->add($requireLoggedIn);
$app->get('/gear/{id}', [\WeaponController::class, 'fetchGearById'])->add($requireLoggedIn);
$app->put('/gear/{id}', [\WeaponController::class, 'addUpdateGear'])->add($requireDataAdmin);
$app->delete('/gear/{id}', [\WeaponController::class, 'deleteGear'])->add($requireDataAdmin);

/* Front end */
$app->get('/gangs', [\GangController::class, 'fetchGangs'])->add($requireLoggedIn);
$app->post('/gang', [\GangController::class, 'addGang'])->add($requireLoggedIn);
$app->get('/gang/{id}', [\GangController::class, 'fetchGang'])->add($requireLoggedIn);
$app->put('/gang/{id}', [\GangController::class, 'updateGang'])->add($requireLoggedIn);
$app->delete('/gang/{id}', [\GangController::class, 'removeGang'])->add($requireLoggedIn);
$app->get('/gang/{id}/fighters', [\FighterController::class, 'fetchGangFighters'])->add($requireLoggedIn);

$app->post('/fighter', [\FighterController::class, 'addFighter'])->add($requireLoggedIn);
$app->get('/fighter/{id}', [\FighterController::class, 'fetchFighter'])->add($requireLoggedIn);
$app->put('/fighter/{id}', [\FighterController::class, 'updateFighter'])->add($requireLoggedIn);

$app->post('/injury/{id}', [\FighterController::class, 'addInjury'])->add($requireLoggedIn);

$app->run();

if ($isCache) $cache->close();
?>