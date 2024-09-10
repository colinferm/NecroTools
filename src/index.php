<?php
require_once 'api/_config.php';
require_once('api/lib/vendor/autoload.php');
require_once('api/slim_controller.php');
require_once 'api/utils.php';
require_once 'api/weapon.php';
require_once 'api/fighter.php';
// SET UP BACKBONE

?>
<!doctype html>
<html class="no-js" lang="en">
	<head>
		<meta charset="utf-8" />
		<meta http-equiv="x-ua-compatible" content="ie=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="/css/foundation-compiled.css" rel="stylesheet" type="text/css" />
		<link href="/css/necro.css" rel="stylesheet" type="text/css" />
		<script src="/js/libs/jquery-3.7.1.min.js"></script>
		<title>Bootstrap demo</title>
	</head>
	<body>
		<div class="nav-content"></div>
		<div class="grid-container fluid">
			<div class="grid-x grid-margin-x main-content">

			</div>
		</div>
		<div class="footer-content"></div>

		<script>
			$(document).ready(function($) {
				window.$ = $;
				$(document).foundation();
				Necro.Utils.UI.TPL.loadAllTemplates(function(count) {
					console.log("Templates loaded: " + count );
				});
				Necro.Apps.Data.Traits = <?php echo json_encode(WeaponController::getTraits()); ?>;
				Necro.Apps.Data.Skills = <?php echo json_encode(FighterController::getSkills()); ?>;

				var necro = new Necro.Routers.NecroRouter();
				necro.load();
			});
		</script>

		<?php require_once 'js/templates.js'; ?>
		<script src="/js/libs/underscore-umd-1.13.7.min.js"></script>
		<script src="/js/libs/handlebars.min-v4.7.8.js"></script>
		<script src="/js/libs/backbone-1.6.0.min.js"></script>
		<script src="/js/libs/foundation.min.js"></script>
		<script src="/js/necro.js"></script>
	</body>
</html>