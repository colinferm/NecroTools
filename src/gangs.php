<?php
// SET UP BACKBONE

?>

<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
		<link href="/css/necro.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
		<title>Bootstrap demo</title>
	</head>
	<body>
		<nav class="navbar navbar-expand-lg bg-dark border-bottom border-body" data-bs-theme="dark">
			<div class="container-xl">
				<a class="navbar-brand" href="#">
					<i class="bi bi-dice-6"></i> NecroTools
				</a>
				<div class="collapse navbar-collapse" id="navbarScroll">
					<ul class="navbar-nav me-auto my-2 my-lg-0 navbar-nav-scroll" style="--bs-scroll-height: 100px;">
						<li class="nav-item dropdown">
							<a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
							Tools
							</a>
							<ul class="dropdown-menu">
								<li><a class="dropdown-item" href="#">Gangs</a></li>
								<li><hr class="dropdown-divider"></li>
								<li><a class="dropdown-item" href="#">Admin</a></li>
								<li><a class="dropdown-item" href="#">Add Weapon</a></li>
								<li><a class="dropdown-item" href="#">Add Weapon Trait</a></li>
							</ul>
						</li>
					</ul>
					<form class="d-flex" role="search">
						<input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
						<button class="btn btn-outline-success" type="submit">Search</button>
					</form>
				</div>
			</div>
		</nav>

		<div class="container-xl main-content">
			<div class="row">
				<div class="col-3 left-content">
				Left Column
				</div>
				<div class="col-9 container right-content">
					<div class="header col-12 m-2 text-end">
						<h3>Gangs</h3>
					</div>
					<div class="me-3 right-content-container">
						<table class="table table-striped table-hover">
							<thead class="table-dark">
								<tr>
									<th scope="col">Name</th>
									<th scope="col">Type</th>
									<th scope="col">Members</th>
									<th scope="col">Value</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>Killers</td>
									<td>Goliath</td>
									<td class="text-center">8</td>
									<td class="text-center">1050</td>
								</tr>
								<tr>
									<td>Killers</td>
									<td>Goliath</td>
									<td class="text-center">8</td>
									<td class="text-center">1050</td>
								</tr>
								<tr>
									<td>Killers</td>
									<td>Goliath</td>
									<td class="text-center">8</td>
									<td class="text-center">1050</td>
								</tr>
								<tr>
									<td>Killers</td>
									<td>Goliath</td>
									<td>8</td>
									<td>1050</td>
								</tr>
								<tr>
									<td>Killers</td>
									<td>Goliath</td>
									<td>8</td>
									<td>1050</td>
								</tr>
								<tr>
									<td>Killers</td>
									<td>Goliath</td>
									<td>8</td>
									<td>1050</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="container-xl row align-items-center bg-dark footer">
				<div class="col-4 text-center">
					Footer Column Left
				</div>
				<div class="col-4 text-center">
					Footer Column Middle
				</div>
				<div class="col-4 text-center">
					Footer Column Right
				</div>
			</div>
		</div>
	</body>

	<?php require_once 'js/templates.js'; ?>
	<script src="/js/libs/bootstrap.bundle.min.js"></script>
	<script src="/js/libs/jquery-3.7.1.min.js"></script>
	<script src="/js/libs/underscore-umd-1.13.7.min.js"></script>
	<script src="/js/libs/backbone-1.6.0.min.js"></script>
</html>