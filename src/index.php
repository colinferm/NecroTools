<?php
require_once 'api/_config.php';
require_once 'api/necrodb.php';
require_once 'api/lib/vendor/autoload.php';
require_once 'api/slim_controller.php';
require_once 'api/utils.php';
require_once 'api/weapon.php';
require_once 'api/fighter.php';
require_once 'api/gang.php';
?>
<!doctype html>
<html class="no-js" lang="en">
	<head>
		<meta charset="utf-8" />
		<meta http-equiv="x-ua-compatible" content="ie=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
		<link href="/css/bootstrap-icons.min.css" rel="stylesheet" type="text/css" />
		<link href="/css/foundation-icons.css" rel="stylesheet" type="text/css" />
		<link href="/css/jquery-ui.theme.min.css" rel="stylesheet" type="text/css" />
		<link href="/css/jquery.tagit.css" rel="stylesheet" type="text/css" />
		<link href="/css/necro.css" rel="stylesheet" type="text/css" />
		<script src="/js/libs/jquery-3.7.1.min.js"></script>
		<title>Necro Tools</title>
	</head>
	<body>
		<nav class="navbar fixed-top navbar-dark bg-dark"></nav>
		<div class="container-fluid pt-5">
			<div class="row main-content">

			</div>
		</div>
		<div class="footer-content"></div>

		<script>
			$(document).ready(function($) {
				window.$ = $;
				Necro.Utils.UI.TPL.loadAllTemplates(function(count) {
					console.log("Templates loaded: " + count );
				});
				Necro.Apps.Data.WeaponTraits = <?php echo WeaponController::getTraitsJSON(); ?>;
				Necro.Apps.Data.WeaponCategories = <?php echo WeaponController::getWeaponCategoryJSON(); ?>;
				Necro.Apps.Data.SkillSets = new Necro.Collections.SkillSets(<?php echo FighterController::getSkillsJSON(); ?>);
				Necro.Apps.Data.Injuries = <?php echo FighterController::getInjuriesJSON(); ?>;
				Necro.Apps.Data.FighterRoles = <?php echo FighterController::getFighterRolesJSON(); ?>;
				Necro.Apps.Data.GangTypes = <?php echo GangController::getGangTypesJSON(); ?>;
				Necro.Apps.Data.RoleClasses = [
					{name: 'Leader', type: 'leader'},
					{name: 'Champion', type: 'champion'},
					{name: 'Fighter', type: 'fighter'},
					{name: 'Prospect', type: 'prospect'},
					{name: 'Juve', type: 'juve'},
					{name: 'Crew', type: 'crew'},
					{name: 'Brute', type: 'brute'},
					{name: 'Hanger-on', type: 'hanger-on'},
					{name: 'Pet', type: 'pet'}
				];

				window.necro = new Necro.Routers.NecroRouter();
				necro.load();
			});
		</script>

		<?php require_once 'js/templates.js'; ?>
		<script src="/js/libs/moment.js"></script>
		<script src="/js/libs/underscore-umd-1.13.7.min.js"></script>
		<script src="/js/libs/handlebars.min-v4.7.8.js"></script>
		<script src="/js/libs/backbone-1.6.0.min.js"></script>
		<script src="/js/libs/bootstrap.bundle.min.js"></script>
		<script src="/js/libs/jquery.cookie-1.3.js"></script>
		<script src="/js/libs/jquery-ui.min.js"></script>
		<script src="/js/libs/tag-it.min.js"></script>
		<script src="/js/necro.js"></script>
	</body>
</html>