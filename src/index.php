<?php
require_once 'api/_config.php';
require_once 'api/necrodb.php';
require_once 'api/lib/vendor/autoload.php';
require_once 'api/slim_controller.php';
require_once 'api/utils.php';
require_once 'api/weapon.php';
require_once 'api/fighter.php';
?>
<!doctype html>
<html class="no-js" lang="en">
	<head>
		<meta charset="utf-8" />
		<meta http-equiv="x-ua-compatible" content="ie=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="/css/foundation.css" rel="stylesheet" type="text/css" />
		<link href="/css/foundation-icons.css" rel="stylesheet" type="text/css" />
		<link href="/css/jquery-ui.theme.min.css" rel="stylesheet" type="text/css" />
		<link href="/css/jquery.tagit.css" rel="stylesheet" type="text/css" />
		<link href="/css/necro.css" rel="stylesheet" type="text/css" />
		<script src="/js/libs/jquery-3.7.1.min.js"></script>
		<title>Necro Tools</title>
	</head>
	<body>
		<div class="nav-content"></div>
		<div class="grid-container fluid">
			<div class="grid-x grid-padding-x main-content">

			</div>
		</div>
		<div class="footer-content"></div>

		<script>
			$(document).ready(function($) {
				window.$ = $;
				Necro.Utils.UI.TPL.loadAllTemplates(function(count) {
					console.log("Templates loaded: " + count );
				});
				Necro.Apps.Data.Traits = <?php echo WeaponController::getTraitsJSON(); ?>;
				Necro.Apps.Data.Skills = <?php echo FighterController::getSkillsJSON(); ?>;
				Necro.Apps.Data.Injuries = <?php echo FighterController::getInjuriesJSON(); ?>;
				Necro.Apps.Data.FighterRoles = <?php echo FighterController::getFighterRolesJSON(); ?>;

				window.necro = new Necro.Routers.NecroRouter();
				necro.load();
			});
		</script>

		<?php require_once 'js/templates.js'; ?>
		<script src="/js/libs/underscore-umd-1.13.7.min.js"></script>
		<script src="/js/libs/handlebars.min-v4.7.8.js"></script>
		<script src="/js/libs/backbone-1.6.0.min.js"></script>
		<script src="/js/libs/foundation.min.js"></script>
		<script src="/js/libs/jquery.cookie-1.3.js"></script>
		<script src="/js/libs/jquery-ui.min.js"></script>
		<script src="/js/libs/tag-it.min.js"></script>
		<script src="/js/necro.js"></script>
	</body>
</html>