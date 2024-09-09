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
						<h3>Gang Name</h3>
					</div>
					<div class="me-3 right-content-container">
						<div class="mb-3 text-end">
							<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#fighterEditModal">Add Fighter</button>
							<button type="button" class="btn btn-secondary">Print Cards</button>
						</div>
						<table class="table table-striped table-hover">
							<thead class="table-dark">
								<tr>
									<th scope="col">Fighter</th>
									<th scope="col">Type</th>
									<th scope="col">Cost</th>
									<th scope="col" class="text-center">XP</th>
									<th scope="col" class="text-center">ADV</th>
									<th scope="col" class="text-center">Rec</th>
									<th scope="col" class="text-center">Cap</th>
									<th scope="col"></th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>Joe Banks</td>
									<td>Leader</td>
									<td>250</td>
									<td class="text-center">6xp</td>
									<td class="text-center">3</td>
									<td class="text-center">X</td>
									<td class="text-center">X</td>
									<td>
										<div class="dropdown">
											<button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
												Actions
											</button>
											<ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
												<li><a class="dropdown-item" href="#">Edit</a></li>
												<li><a class="dropdown-item" href="#">Create Card</a></li>
												<li><a class="dropdown-item" href="#">Remove</a></li>
											</ul>
										</div>
									</td>
								</tr>
								<tr>
									<td>Frank Black</td>
									<td>Champion</td>
									<td>250</td>
									<td class="text-center">6xp</td>
									<td class="text-center">3</td>
									<td class="text-center">X</td>
									<td class="text-center">X</td>
									<td>
										<div class="dropdown">
											<button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
												Actions
											</button>
											<ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
												<li><a class="dropdown-item" href="#">Edit</a></li>
												<li><a class="dropdown-item" href="#">Create Card</a></li>
												<li><a class="dropdown-item" href="#">Remove</a></li>
											</ul>
										</div>
									</td>
								</tr>
								<tr>
									<td>Kim Deal</td>
									<td>Champion</td>
									<td>250</td>
									<td class="text-center">6xp</td>
									<td class="text-center">3</td>
									<td class="text-center">X</td>
									<td class="text-center">X</td>
									<td>
										<div class="dropdown">
											<button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
												Actions
											</button>
											<ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
												<li><a class="dropdown-item" href="#">Edit</a></li>
												<li><a class="dropdown-item" href="#">Create Card</a></li>
												<li><a class="dropdown-item" href="#">Remove</a></li>
											</ul>
										</div>
									</td>
								</tr>
								<tr>
									<td>Joey Santiago</td>
									<td>Fighter</td>
									<td>250</td>
									<td class="text-center">6xp</td>
									<td class="text-center">3</td>
									<td class="text-center">X</td>
									<td class="text-center">X</td>
									<td>
										<div class	="dropdown">
											<button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
												Actions
											</button>
											<ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
												<li><a class="dropdown-item" href="#">Edit</a></li>
												<li><a class="dropdown-item" href="#">Create Card</a></li>
												<li><a class="dropdown-item" href="#">Remove</a></li>
											</ul>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
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
		<div class="modal fade" id="fighterEditModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
			<div class="modal-dialog modal-dialog-centered modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">Add/Edit Fighter</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="row">
							<div class="mb-3 col-6">
								<input type="text" name="fighter_name" id="fighter_name" class="form-control form-control-sm" placeholder="Fighter Name" aria-label="Fighter Name">
							</div>
							<div class="mb-3 col-3">
								<select name="heirarchy_role" id="heirarchy_role" class="form-select form-select-sm" aria-label="Role">
									<option value="">Role</option>
									<option value="leader">Leader</option>
									<option value="champion">Champion</option>
									<option value="fighter">Fighter</option>
								</select>
							</div>
							<div class="mb-3 col-3">
								<input type="text" name="base_cost" class="form-control form-control-sm" placeholder="Cost" aria-label="Base Cost">
							</div>
						</div>
						<div class="row">
							<div class="mb-3 col-1">
								<input type="text" name="movement" class="form-control form-control-sm" placeholder="M" aria-label="Movement">
							</div>
							<div class="mb-3 col-1">
								<input type="text" name="weapon_skill" class="form-control form-control-sm" placeholder="WS" aria-label="Movement">
							</div>
							<div class="mb-3 col-1">
								<input type="text" name="ballistic_skill" class="form-control form-control-sm" placeholder="BS" aria-label="Movement">
							</div>
							<div class="mb-3 col-1">
								<input type="text" name="strength" class="form-control form-control-sm" placeholder="S" aria-label="Movement">
							</div>
							<div class="mb-3 col-1">
								<input type="text" name="toughness" class="form-control form-control-sm" placeholder="T" aria-label="Movement">
							</div>
							<div class="mb-3 col-1">
								<input type="text" name="wounds" class="form-control form-control-sm" placeholder="W" aria-label="Movement">
							</div>
							<div class="mb-3 col-1">
								<input type="text" name="initiative" class="form-control form-control-sm" placeholder="I" aria-label="Movement">
							</div>
							<div class="mb-3 col-1">
								<input type="text" name="actions" class="form-control form-control-sm" placeholder="A" aria-label="Movement">
							</div>
							<div class="mb-3 col-1">
								<input type="text" name="leadership" class="form-control form-control-sm" placeholder="LD" aria-label="Movement">
							</div>
							<div class="mb-3 col-1">
								<input type="text" name="cool" class="form-control form-control-sm" placeholder="CL" aria-label="Movement">
							</div>
							<div class="mb-3 col-1">
								<input type="text" name="willpower" class="form-control form-control-sm" placeholder="WIL" aria-label="Movement">
							</div>
							<div class="mb-3 col-1">
								<input type="text" name="intelligence" class="form-control form-control-sm" placeholder="INT" aria-label="Movement">
							</div>
						</div>
					</div>
					<table class="table">
						<thead>
							<th colspan="3">Weapon</th>
							<th colspan="2">Rng</th>
							<th colspan="2">Acc</th>
							<th colspan="1">Str</th>
							<th colspan="1">Ap</th>
							<th colspan="1">D</th>
							<th colspan="1">Am</th>
							<th colspan="3">Traits</th>
						</thead>
						<tbody>
							<tr colspan="3">
								<input type="text" name="weapon_name" class="form-control form-control-sm" placeholder="Name" aria-label="Weapon Name">
							</tr>
						</div>
						<div class="mb-1 col-1 weapon_line">
							<input type="text" name="range_short" class="form-control form-control-sm" placeholder="S" aria-label="Range Short">
							<input type="text" name="range_long" class="form-control form-control-sm" placeholder="L" aria-label="Range Long">
						</div>
						<div class="mb-1 col-1 weapon_line">
							<input type="text" name="accuracy_short" class="form-control form-control-sm" placeholder="S" aria-label="Accuracy Short">
							<input type="text" name="accuracy_long" class="form-control form-control-sm" placeholder="L" aria-label="Accuracy Long">
						</div>
						<div class="mb-1 col-1 weapon_line">
							<input type="text" name="strength" class="form-control form-control-sm" placeholder="Str" aria-label="Strength">
						</div>
						<div class="mb-1 col-1 weapon_line">
							<input type="text" name="armor_penetration" class="form-control form-control-sm" placeholder="Ap" aria-label="Armor Penetration">
						</div>
						<div class="mb-1 col-1 weapon_line">
							<input type="text" name="damage" class="form-control form-control-sm" placeholder="D" aria-label="Damage">
						</div>
						<div class="mb-1 col-1 weapon_line">
							<input type="text" name="ammo_check" class="form-control form-control-sm" placeholder="Am" aria-label="Ammo Check">
						</div>
						<div class="mb-1 col-2 weapon_line">
							<input type="text" name="traits" class="form-control form-control-sm" placeholder="Ap" aria-label="Traits">
						</div>
					</div>
					<!--
					<div class="row weapon_group">
						<div class="mb-1 col-2">Weapon</div>
						<div class="mb-1 col-1">Rng</div>
						<div class="mb-1 col-1">Acc</div>
						<div class="mb-1 col-1">Str</div>
						<div class="mb-1 col-1">Ap</div>
						<div class="mb-1 col-1">D</div>
						<div class="mb-1 col-1">Am</div>
						<div class="mb-1 col-2">Traits</div>
					</div>
					<div class="row">
						<div class="mb-1 col-2 weapon_line">
							<input type="text" name="weapon_name" class="form-control form-control-sm" placeholder="Name" aria-label="Weapon Name">
						</div>
						<div class="mb-1 col-1 weapon_line">
							<input type="text" name="range_short" class="form-control form-control-sm" placeholder="S" aria-label="Range Short">
							<input type="text" name="range_long" class="form-control form-control-sm" placeholder="L" aria-label="Range Long">
						</div>
						<div class="mb-1 col-1 weapon_line">
							<input type="text" name="accuracy_short" class="form-control form-control-sm" placeholder="S" aria-label="Accuracy Short">
							<input type="text" name="accuracy_long" class="form-control form-control-sm" placeholder="L" aria-label="Accuracy Long">
						</div>
						<div class="mb-1 col-1 weapon_line">
							<input type="text" name="strength" class="form-control form-control-sm" placeholder="Str" aria-label="Strength">
						</div>
						<div class="mb-1 col-1 weapon_line">
							<input type="text" name="armor_penetration" class="form-control form-control-sm" placeholder="Ap" aria-label="Armor Penetration">
						</div>
						<div class="mb-1 col-1 weapon_line">
							<input type="text" name="damage" class="form-control form-control-sm" placeholder="D" aria-label="Damage">
						</div>
						<div class="mb-1 col-1 weapon_line">
							<input type="text" name="ammo_check" class="form-control form-control-sm" placeholder="Am" aria-label="Ammo Check">
						</div>
						<div class="mb-1 col-2 weapon_line">
							<input type="text" name="traits" class="form-control form-control-sm" placeholder="Ap" aria-label="Traits">
						</div>
					</div>
					-->
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
						<button type="button" class="btn btn-primary">Save changes</button>
					</div>
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