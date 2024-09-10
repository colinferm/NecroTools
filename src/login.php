<?php
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
		<div data-sticky-container>
			<div class="title-bar" data-sticky data-options="marginTop:0;" style="width:100%" data-top-anchor="1">
				<div class="title-bar-left">NecroTools</div>
				<div class="title-bar-right"><!-- Content --></div>
			</div>
		</div>

		<div class="grid-container fluid">
			<div class="grid-x grid-margin-x main-content">
				<div class="cell large-3 left-content">
				Left Column
				</div>
				<div class="cell large-9 grid-x right-content">
					<div class="cell header small-12 text-right">
						<h3 class="subheader">Login</h3>
					</div>
					
					<div class="cell small-12 grid-x right-content-container">
						<div class="large-6">
							<label for="emailInput" class="form-label">Email address</label>
							<input type="email" class="form-control" id="emailInput" placeholder="name@example.com">

							<label for="passwordInput" class="form-label">Password</label>
							<input type="password" class="form-control" id="passwordInput">

							<button type="submit" class="button">Login</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="grid-x footer">
			<div class="large-4 text-center">
				Footer Column Left
			</div>
			<div class="large-4 text-center">
				Footer Column Middle
			</div>
			<div class="large-4 text-center">
				Footer Column Right
			</div>
		</div>
		<script>
			$(document).ready(function($) {
				$(document).foundation();
			});
		</script>

		<?php require_once 'js/templates.js'; ?>
		<script src="/js/libs/underscore-umd-1.13.7.min.js"></script>
		<script src="/js/libs/backbone-1.6.0.min.js"></script>
		<script src="/js/libs/foundation.min.js"></script>
	</body>
</html>