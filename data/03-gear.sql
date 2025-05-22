DROP TABLE IF EXISTS necro_fighter_gear;
DROP TABLE IF EXISTS necro_fighter_gear_category;
DROP TABLE IF EXISTS necro_user_fighter_gear_map;

DROP TABLE IF EXISTS necro_weapon_category;
CREATE TABLE necro_weapon_category (
	id INT NOT NULL AUTO_INCREMENT,
	category_name VARCHAR(255) NOT NULL,
	is_wargear TINYINT NOT NULL DEFAULT 0,
	PRIMARY KEY (id)
);
INSERT INTO necro_weapon_category VALUES (1, 'Pistols', 0);
INSERT INTO necro_weapon_category VALUES (2, 'Basic Weapons', 0);
INSERT INTO necro_weapon_category VALUES (3, 'Special Weapons', 0);
INSERT INTO necro_weapon_category VALUES (4, 'Heavy Weapons', 0);
INSERT INTO necro_weapon_category VALUES (5, 'Close Combat', 0);
INSERT INTO necro_weapon_category VALUES (6, 'Grenades', 0);
INSERT INTO necro_weapon_category VALUES (7, 'Booby Traps', 0);
INSERT INTO necro_weapon_category VALUES (8, 'Others', 0);

INSERT INTO necro_weapon_category VALUES (9, 'Armor', 1);
INSERT INTO necro_weapon_category VALUES (10, 'Field Armor', 1);
INSERT INTO necro_weapon_category VALUES (11, 'Bionics', 1);
INSERT INTO necro_weapon_category VALUES (12, 'Gang Equipment', 1);
INSERT INTO necro_weapon_category VALUES (13, 'Personal Equipment', 1);
INSERT INTO necro_weapon_category VALUES (14, 'Chems', 1);
INSERT INTO necro_weapon_category VALUES (15, 'Weapon Accessories', 1);
INSERT INTO necro_weapon_category VALUES (16, 'Status Items', 1);
INSERT INTO necro_weapon_category VALUES (17, 'Servo-skulls', 1);
INSERT INTO necro_weapon_category VALUES (18, 'Status Items', 1);
INSERT INTO necro_weapon_category VALUES (19, 'Pets', 1);

DROP TABLE IF EXISTS necro_weapon;
CREATE TABLE necro_weapon (
	id INT NOT NULL AUTO_INCREMENT,
	weapon_category_id INT NOT NULL,
	weapon_name VARCHAR(255) NOT NULL,
	weapon_value INT NOT NULL,
	rarity VARCHAR(10),
	notes TEXT,
	is_wargear TINYINT NOT NULL DEFAULT 0,
	INDEX idx_weapon_category (weapon_category_id),
	PRIMARY KEY (id)
);
INSERT INTO necro_weapon VALUES (1, 2, 'Boltgun', 55, 'R8', NULL, 0);
INSERT INTO necro_weapon VALUES (2, 1, 'Autopistol', 10, 'C', NULL, 0);
INSERT INTO necro_weapon VALUES (3, 5, 'Knife', 15, 'C', NULL, 0);
INSERT INTO necro_weapon VALUES (4, 5, 'Stilleto Knife', 20, 'R9', NULL, 0);
INSERT INTO necro_weapon VALUES (5, 5, 'Stilleto Sword', 35, 'R9', NULL, 0);
INSERT INTO necro_weapon VALUES (6, 5, 'Chain Sword', 25, 'R8', NULL, 0);
INSERT INTO necro_weapon VALUES (7, 3, 'Escher Pattern Combi-', 180, 'R8', NULL, 0);

INSERT INTO necro_weapon VALUES (8, 9, 'Flak Armor', 10, 'C', NULL, 1);

DROP TABLE IF EXISTS necro_weapon_characteristic;
CREATE TABLE necro_weapon_characteristic (
	id INT NOT NULL AUTO_INCREMENT,
	weapon_id INT NOT NULL,
	ammo_type VARCHAR(255),
	range_short VARCHAR(4),
	range_long VARCHAR(4),
	accuracy_short VARCHAR(4),
	accuracy_long VARCHAR(4),
	strength VARCHAR(4),
	armor_penetration VARCHAR(4),
	damage VARCHAR(4),
	ammo_check VARCHAR(4),
	PRIMARY KEY (id)
);
INSERT INTO necro_weapon_characteristic VALUES (1, 1, 'Standard', '12', '24', '+1', '-', '4', '-1', '2', '6+');
INSERT INTO necro_weapon_characteristic VALUES (2, 2, 'Standard', '4', '12', '+1', '-', '3', '-', '1', '4+');
INSERT INTO necro_weapon_characteristic VALUES (3, 3, 'Standard', 'E', '-', '-', '-', 'S', '-1', '1', '-');
INSERT INTO necro_weapon_characteristic VALUES (4, 4, 'Standard', 'E', '-', '-', '-', '-', '-', '-', '-');
INSERT INTO necro_weapon_characteristic VALUES (5, 5, 'Standard', 'E', '-', '-', '-', '-', '-1', '-', '-');
INSERT INTO necro_weapon_characteristic VALUES (6, 6, 'Standard', 'E', '-', '+1', '-', 'S', '-1', '1', '-');
INSERT INTO necro_weapon_characteristic VALUES (7, 7, 'Bolter', '12', '24', '+1', '-', '4', '-1', '2', '6+');
INSERT INTO necro_weapon_characteristic VALUES (8, 7, 'Flamer', '-', 'T', '-', '-', '4', '-1', '1', '5+');

DROP TABLE IF EXISTS necro_weapon_trait;
CREATE TABLE necro_weapon_trait (
	id INT NOT NULL AUTO_INCREMENT,
	trait_name VARCHAR(255) NOT NULL,
	trait_value INT NOT NULL DEFAULT '0',
	notes TEXT NULL,
	PRIMARY KEY (id)
);
INSERT INTO necro_weapon_trait (id, trait_name, notes) VALUES (1, 'Rapid Fire (1)', 'All ranged weapons roll an ammo check die but weapons with this trait count the number of hits that are rolled.');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (2, 'Backstab');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (3, 'Toxin');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (4, 'Parry');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (5, 'Rending');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (6, 'Combi');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (7, 'Blaze');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (8, 'Template');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (9, 'Unstable');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Assault Shield');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Blast 3"');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Blast 5"');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Burrowing');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Chem Delivery');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Concussion');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Cursed');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Demolitions');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Disarm');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Drag');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Digi');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Energy Shield');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Entangle');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Esoteric');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Exclusive');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Fear');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Flare');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Fixed');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Flash');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Force');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Gas');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Graviton Pulse');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Grenade');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Hexagrammatic');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Impale');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Knockback');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Limited');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Master-Crafted');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Melee');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Melta');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Plentiful');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Power');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Pulverise');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Rad-phage');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Reckless');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Rending');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Scarce');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Scattershot');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Seismic');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Sever');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Shield Breaker');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Shock');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Sidearm');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Silent');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Single Shot');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Smoke');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Unwieldy');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Versatile');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (0, 'Web');

DROP TABLE IF EXISTS necro_weapon_trait_characteristic_map;
CREATE TABLE necro_weapon_trait_characteristic_map (
	characteristic_id INT NOT NULL,
	trait_id INT NOT NULL,
	INDEX idx_weapon_trait_characteristic (characteristic_id, trait_id)
);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (1, 1);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (2, 1);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (3, 2);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (4, 3);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (5, 3);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (5, 4);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (6, 4);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (6, 5);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (7, 6);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (7, 1);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (8, 6);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (8, 7);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (8, 8);
INSERT INTO necro_weapon_trait_characteristic_map VALUES (8, 9);