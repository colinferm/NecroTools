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

		<div class="grid-x main-content">
			<div class="cell large-3 left-content">
			Left Column
			</div>
			<div class="cell large-9 grid-x right-content">
				<div class="cell header small-12 text-right">
					<h3 class="subheader">Gang Name</h3>
				</div>
				<div class="cell small-12 grid-x right-content-container">
					<div class="cell small-12 text-right">
						<a href="#" class="button submit" data-bs-toggle="modal" data-bs-target="#fighterEditModal">Add Fighter</a>
						<a href="#" class="button submit">Print Cards</a>
					</div>
					<div class="cell small-12">
						<table>
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
										<ul class="dropdown menu" data-dropdown-menu>
											<li>
												<a href="#" class="button hollow">Actions</a>
												<ul class="menu">
													<li><a href="#">Edit</a></li>
													<li><a href="#">Create Card</a></li>
													<li><a href="#">Remove</a></li>
												</ul>
											</li>
										</ul>
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
										<ul class="dropdown menu" data-dropdown-menu>
											<li>
												<a href="#" class="button hollow">Actions</a>
												<ul class="menu">
													<li><a href="#">Edit</a></li>
													<li><a href="#">Create Card</a></li>
													<li><a href="#">Remove</a></li>
												</ul>
											</li>
										</ul>
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
										<ul class="dropdown menu" data-dropdown-menu>
											<li>
												<a href="#" class="button hollow">Actions</a>
												<ul class="menu">
													<li><a href="#">Edit</a></li>
													<li><a href="#">Create Card</a></li>
													<li><a href="#">Remove</a></li>
												</ul>
											</li>
										</ul>
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
										<ul class="dropdown menu" data-dropdown-menu>
											<li>
												<a href="#" class="button hollow">Actions</a>
												<ul class="menu">
													<li><a href="#">Edit</a></li>
													<li><a href="#">Create Card</a></li>
													<li><a href="#">Remove</a></li>
												</ul>
											</li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
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
		</div>
		<div class="reveal" id="exampleModal1" data-reveal>
			<div class="grid-x">
				<div class="cell small-12">
					<h5 class="modal-title">Add/Edit Fighter</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="cell small-12 grid-x">
					<div class="cell small-6">
						<input type="text" name="fighter_name" id="fighter_name" class="form-control form-control-sm" placeholder="Fighter Name" aria-label="Fighter Name">
					</div>
					<div class="cell small-3">
						<select name="heirarchy_role" id="heirarchy_role" class="form-select form-select-sm" aria-label="Role">
							<option value="">Role</option>
							<option value="leader">Leader</option>
							<option value="champion">Champion</option>
							<option value="fighter">Fighter</option>
						</select>
					</div>
					<div class="cell small-3">
						<input type="text" name="base_cost" class="form-control form-control-sm" placeholder="Cost" aria-label="Base Cost">
					</div>
				</div>
				<div class="cell small-12 grid-x">
					<div class="cell small-1">
						<input type="text" name="movement" class="form-control form-control-sm" placeholder="M" aria-label="Movement">
					</div>
					<div class="cell small-1">
						<input type="text" name="weapon_skill" class="form-control form-control-sm" placeholder="WS" aria-label="Movement">
					</div>
					<div class="cell small-1">
						<input type="text" name="ballistic_skill" class="form-control form-control-sm" placeholder="BS" aria-label="Movement">
					</div>
					<div class="cell small-1">
						<input type="text" name="strength" class="form-control form-control-sm" placeholder="S" aria-label="Movement">
					</div>
					<div class="cell small-1">
						<input type="text" name="toughness" class="form-control form-control-sm" placeholder="T" aria-label="Movement">
					</div>
					<div class="cell small-1">
						<input type="text" name="wounds" class="form-control form-control-sm" placeholder="W" aria-label="Movement">
					</div>
					<div class="cell small-1">
						<input type="text" name="initiative" class="form-control form-control-sm" placeholder="I" aria-label="Movement">
					</div>
					<div class="cell small-1">
						<input type="text" name="actions" class="form-control form-control-sm" placeholder="A" aria-label="Movement">
					</div>
					<div class="cell small-1">
						<input type="text" name="leadership" class="form-control form-control-sm" placeholder="LD" aria-label="Movement">
					</div>
					<div class="cell small-1">
						<input type="text" name="cool" class="form-control form-control-sm" placeholder="CL" aria-label="Movement">
					</div>
					<div class="cell small-1">
						<input type="text" name="willpower" class="form-control form-control-sm" placeholder="WIL" aria-label="Movement">
					</div>
					<div class="cell small-1">
						<input type="text" name="intelligence" class="form-control form-control-sm" placeholder="INT" aria-label="Movement">
					</div>
				</div>
				<div class="cell small-12">
					<table class="table fighter-weapon">
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
							<tr>
								<td colspan="3">
									<input type="text" name="weapon_name" class="form-control form-control-sm" placeholder="Name" aria-label="Weapon Name">
								</td>
								<td colspan="1">
									<input type="text" name="weapon_name" class="form-control form-control-sm" placeholder="Name" aria-label="Weapon Name">
								</td>
								<td colspan="2" class="two-stat">
									<input type="text" name="range_short" class="form-control form-control-sm" placeholder="S" aria-label="Range Short">
									<input type="text" name="range_long" class="form-control form-control-sm" placeholder="L" aria-label="Range Long">
								</td>
								<td colspan="2" class="two-stat">
									<input type="text" name="accuracy_short" class="form-control form-control-sm" placeholder="S" aria-label="Accuracy Short">
									<input type="text" name="accuracy_long" class="form-control form-control-sm" placeholder="L" aria-label="Accuracy Long">
								</td>
								<td colspan="1">
									<input type="text" name="strength" class="form-control form-control-sm" placeholder="Str" aria-label="Strength">
								</td>
								<td colspan="1">
									<input type="text" name="armor_penetration" class="form-control form-control-sm" placeholder="Ap" aria-label="Armor Penetration">
								</td>
								<td colspan="1">
									<input type="text" name="damage" class="form-control form-control-sm" placeholder="D" aria-label="Damage">
								</td>
								<td colspan="1">
									<input type="text" name="ammo_check" class="form-control form-control-sm" placeholder="Am" aria-label="Ammo Check">
								</td>
								<td colspan="3">
									<input type="text" name="traits" class="form-control form-control-sm" placeholder="Traits" aria-label="Traits">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="cell small-12">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary">Save changes</button>
				</div>
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