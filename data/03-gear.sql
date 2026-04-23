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
	gang_type_id INT,
	INDEX idx_weapon_category (weapon_category_id),
	PRIMARY KEY (id)
);
INSERT INTO necro_weapon VALUES (1, 2, 'Boltgun', 55, 'R8', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (2, 1, 'Autopistol', 10, 'C', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (3, 5, 'Knife', 15, 'C', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (4, 5, 'Stilleto Knife', 20, 'R9', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (5, 5, 'Stilleto Sword', 35, 'R9', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (6, 5, 'Chain Sword', 25, 'R8', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (7, 3, 'Escher Pattern Combi-', 180, 'R8', NULL, 0, 2);

INSERT INTO necro_weapon VALUES (8, 9, 'Flak Armor', 10, 'C', NULL, 1, NULL);

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
	characteristic_value INT NOT NULL DEFAULT 0,
	default_loadout TINYINT NOT NULL DEFAULT 0,
	rarity VARCHAR(10),
	gang_type_id INT,
	PRIMARY KEY (id)
);
INSERT INTO necro_weapon_characteristic VALUES (1, 1, 'Standard', '12', '24', '+1', '-', '4', '-1', '2', '6+', 0, 1, 'R8',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (2, 2, 'Standard', '4', '12', '+1', '-', '3', '-', '1', '4+', 0, 1, 'C',   NULL);
INSERT INTO necro_weapon_characteristic VALUES (3, 3, 'Standard', 'E', '-', '-', '-', 'S', '-1', '1', '-', 0, 1, 'C',   NULL);
INSERT INTO necro_weapon_characteristic VALUES (4, 4, 'Standard', 'E', '-', '-', '-', '-', '-', '-', '-', 0, 1, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (5, 5, 'Standard', 'E', '-', '-', '-', '-', '-1', '-', '-', 0, 1, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (6, 6, 'Standard', 'E', '-', '+1', '-', 'S', '-1', '1', '-', 0, 1, 'R8',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (7, 7, 'Bolter', '12', '24', '+1', '-', '4', '-1', '2', '6+', 0, 1, 'R8',  2);
INSERT INTO necro_weapon_characteristic VALUES (8, 7, 'Flamer', '-', 'T', '-', '-', '4', '-1', '1', '5+', 0, 1, 'R8',  2);

INSERT INTO necro_lookups (id, lookup_value, lookup_key, notes) VALUES (1, 'Rapid Fire (1)', 'WEAPON_TRAIT', 'All ranged weapons roll an ammo check die but weapons with this trait count the number of hits that are rolled.');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (2, 'Backstab', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (3, 'Toxin', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (4, 'Parry', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (5, 'Rending', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (6, 'Combi', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (7, 'Blaze', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (8, 'Template', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (9, 'Unstable', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Assault Shield', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Blast 3"', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Blast 5"', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Burrowing', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Chem Delivery', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Concussion', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Cursed', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Demolitions', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Disarm', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Drag', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Digi', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Energy Shield', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Entangle', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Esoteric', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Exclusive', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Fear', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Flare', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Fixed', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Flash', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Force', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Gas', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Graviton Pulse', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Grenade', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Hexagrammatic', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Impale', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Knockback', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Limited', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Master-Crafted', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Melee', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Melta', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Plentiful', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Power', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Pulverise', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Rad-phage', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Reckless', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Rending', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Scarce', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Scattershot', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Seismic', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Sever', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Shield Breaker', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Shock', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Sidearm', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Silent', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Single Shot', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Smoke', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Unwieldy', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Versatile', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Web', 'WEAPON_TRAIT');

DROP TABLE IF EXISTS necro_weapon_trait_characteristic_map;
CREATE TABLE necro_weapon_trait_characteristic_map (
	characteristic_id INT NOT NULL,
	trait_lookup_id INT NOT NULL,
	INDEX idx_weapon_trait_characteristic (characteristic_id, trait_lookup_id)
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

-- ============================================================
-- BASIC WEAPONS: New traits
-- ============================================================
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Rapid Fire (2)', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Defoliate', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Gunk', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Lance', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Twin-linked', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Blast (*)', 'WEAPON_TRAIT');

-- ============================================================
-- BASIC WEAPONS: Additional ammo profiles for existing Boltgun (weapon_id=1)
-- ============================================================
INSERT INTO necro_weapon_characteristic VALUES (9,  1, 'gas shells',    '12', '24', '+1', '-',  '-', '-',  '-', '6+', 25, 0, 'R11', NULL);
INSERT INTO necro_weapon_characteristic VALUES (10, 1, 'shatter shells','12', '24', '+1', '-',  '3', '-1', '1', '6+', 15, 0, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (11, 1, 'gunk bolts',    '12', '24', '-',  '-1', '4', '-',  '1', '5+', 15, 0, 'C',   NULL);

-- ============================================================
-- BASIC WEAPONS: New weapons (IDs 9-40, weapon_category_id=2)
-- ============================================================
INSERT INTO necro_weapon VALUES (9,  2, 'Arc rifle',                            100, 'R13', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (10, 2, 'Autogun',                               15, 'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (11, 2, 'Reclaimed autogun',                     10, 'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (12, 2, 'Combat shotgun',                        70, 'R7',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (13, 2, 'Kroot long rifle',                      30, 'R10', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (14, 2, 'Lasgun',                                15, 'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (15, 2, 'Rak''gol razor gun',                   60, 'I11', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (16, 2, 'Sawn-off shotgun',                      15, 'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (17, 2, 'Shotgun',                               30, 'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (18, 2, 'Sling gun',                             55, 'R11', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (19, 2, 'Stake-crossbow',                        60, 'R9',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (20, 2, 'Throwing knives',                       10, 'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (21, 2, 'Warpstorm bolter',                      60, 'I10', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (22, 2, 'Cawdor polearm with autogun',           20, 'E',   NULL, 0, 4);
INSERT INTO necro_weapon VALUES (23, 2, 'Cawdor charger with autogun',           25, 'E',   NULL, 0, 4);
INSERT INTO necro_weapon VALUES (24, 2, 'Cawdor charger with blunderbuss',       45, 'E',   NULL, 0, 4);
INSERT INTO necro_weapon VALUES (25, 2, 'Cawdor charger with flamer',           145, 'E',   NULL, 0, 4);
INSERT INTO necro_weapon VALUES (26, 2, 'Cawdor polearm/blunderbuss',            40, 'E',   NULL, 0, 4);
INSERT INTO necro_weapon VALUES (27, 2, 'Enforcer boltgun',                      50, 'E',   NULL, 0, 9);
INSERT INTO necro_weapon VALUES (28, 2, 'Enforcer shotgun',                      60, 'E',   NULL, 0, 9);
INSERT INTO necro_weapon VALUES (29, 2, 'Exterminator',                           0, 'E',   NULL, 0, 4);
INSERT INTO necro_weapon VALUES (30, 2, 'Ironhead autogun',                      25, 'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (31, 2, 'Ironhead boltgun',                      95, 'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (32, 2, 'Ironhead combat shotgun',               40, 'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (33, 2, 'Las carbine',                           20, 'E',   NULL, 0, 6);
INSERT INTO necro_weapon VALUES (34, 2, 'Stub cannon',                           20, 'E',   NULL, 0, 3);
INSERT INTO necro_weapon VALUES (35, 2, 'Subjugation pattern grenade launcher',  50, 'E',   NULL, 0, 9);
INSERT INTO necro_weapon VALUES (36, 2, 'Suppression laser',                     40, 'E',   NULL, 0, 6);
INSERT INTO necro_weapon VALUES (37, 2, 'Twin-linked bolters',                   65, 'E',   NULL, 0, 3);
INSERT INTO necro_weapon VALUES (38, 2, 'Twin-linked Ironhead autogun',          40, 'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (39, 2, 'Twin-linked Ironhead boltgun',         115, 'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (40, 2, 'Wyld bow',                              10, 'E',   NULL, 0, 2);

-- ============================================================
-- BASIC WEAPONS: Weapon characteristics (profiles)
-- Columns: id, weapon_id, ammo_type, range_short, range_long,
--          accuracy_short, accuracy_long, strength, armor_penetration, damage, ammo_check
-- ============================================================

-- Arc rifle (9)
INSERT INTO necro_weapon_characteristic VALUES (12, 9,  'Standard',           '9',   '24',  '+2', '-1', '5',   '-',  '1', '6+', 0,  1, 'R13', NULL);
-- Autogun (10)
INSERT INTO necro_weapon_characteristic VALUES (13, 10, 'Standard',           '8',   '24',  '+1', '-',  '3',   '-',  '1', '4+', 0,  1, 'C',   NULL);
INSERT INTO necro_weapon_characteristic VALUES (14, 10, 'static rounds',      '8',   '24',  '+1', '-',  '3',   '-',  '1', '4+', 10, 0, 'I9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (15, 10, 'warp rounds',        '8',   '24',  '+1', '-',  '3',   '-',  '1', '4+', 15, 0, 'I10', NULL);
INSERT INTO necro_weapon_characteristic VALUES (16, 10, 'phosphor rounds',    '8',   '24',  '+1', '-',  '3',   '-',  '1', '4+', 10, 0, 'R8',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (17, 10, 'plantbuster rounds', '8',   '24',  '+1', '-',  '3',   '-',  '1', '4+', 15, 0, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (18, 10, 'rad rounds',         '8',   '24',  '-',  '-',  '3',   '-',  '1', '4+', 20, 0, 'R9',  NULL);
-- Reclaimed autogun (11)
INSERT INTO necro_weapon_characteristic VALUES (19, 11, 'Standard',           '8',   '24',  '+1', '-',  '3',   '-',  '1', '5+', 0,  1, 'C',   NULL);
-- Combat shotgun (12)
INSERT INTO necro_weapon_characteristic VALUES (20, 12, 'salvo ammo',         '4',   '12',  '+1', '-',  '4',   '-',  '2', '4+', 0,  1, 'R7',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (21, 12, 'shredder ammo',      '-',   'T',   '-',  '-',  '2',   '-',  '1', '4+', 0,  1, 'R7',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (22, 12, 'firestorm ammo',     '-',   'T',   '-',  '-',  '5',   '-1', '1', '6+', 30, 0, 'R8',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (23, 12, 'gas shells',         '4',   '18',  '+1', '-',  '-',   '-',  '-', '6+', 25, 0, 'R11', NULL);
INSERT INTO necro_weapon_characteristic VALUES (24, 12, 'shatter shells',     '4',   '18',  '+1', '-',  '3',   '-1', '1', '5+', 15, 0, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (25, 12, 'phosphor rounds',    '-',   'T',   '-',  '-',  '2',   '-',  '1', '4+', 10, 0, 'R8',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (26, 12, 'plantbuster rounds', '-',   'T',   '-',  '-',  '2',   '-',  '1', '4+', 15, 0, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (27, 12, 'rad rounds',         '-',   'T',   '-',  '-',  '2',   '-',  '1', '4+', 25, 0, 'R9',  NULL);
-- Kroot long rifle (13)
INSERT INTO necro_weapon_characteristic VALUES (28, 13, 'ranged',             '12',  '24',  '+1', '-',  '4',   '-',  '1', '4+', 0,  1, 'R10', NULL);
INSERT INTO necro_weapon_characteristic VALUES (29, 13, 'melee',              'E',   '2',   '-',  '-',  'S+1', '-',  '1', '-',  0,  1, 'E',   NULL);
-- Lasgun (14)
INSERT INTO necro_weapon_characteristic VALUES (30, 14, 'Standard',           '18',  '24',  '+1', '-',  '3',   '-',  '1', '2+', 0,  1, 'C',   NULL);
INSERT INTO necro_weapon_characteristic VALUES (31, 14, 'hotshot las pack',   '18',  '24',  '+1', '-',  '4',   '-1', '1', '4+', 20, 0, 'C',   NULL);
INSERT INTO necro_weapon_characteristic VALUES (32, 14, 'focusing crystal',   '18',  '24',  '+1', '-',  '3',   '-2', '1', '3+', 30, 0, 'R10', NULL);
-- Rak'gol razor gun (15)
INSERT INTO necro_weapon_characteristic VALUES (33, 15, 'Standard',           '6',   '20',  '-',  '-1', '-',   '-2', '1', '6+', 0,  1, 'I11', NULL);
-- Sawn-off shotgun (16)
INSERT INTO necro_weapon_characteristic VALUES (34, 16, 'scatter ammo',       '4',   '8',   '+2', '-',  '3',   '-',  '1', '6+', 0,  1, 'C',   NULL);
INSERT INTO necro_weapon_characteristic VALUES (35, 16, 'solid ammo',         '4',   '8',   '-',  '-2', '4',   '-',  '2', '6+', 5,  0, 'C',   NULL);
INSERT INTO necro_weapon_characteristic VALUES (36, 16, 'gas shells',         '4',   '8',   '+1', '-',  '-',   '-',  '-', '6+', 25, 0, 'R11', NULL);
INSERT INTO necro_weapon_characteristic VALUES (37, 16, 'shatter shells',     '4',   '8',   '+1', '-',  '3',   '-1', '1', '5+', 15, 0, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (38, 16, 'phosphor rounds',    '4',   '8',   '+2', '-',  '3',   '-',  '1', '2+', 10, 0, 'R8',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (39, 16, 'plantbuster rounds', '4',   '8',   '+2', '-',  '3',   '-',  '1', '2+', 15, 0, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (40, 16, 'rad rounds',         '4',   '8',   '+1', '-',  '3',   '-',  '1', '2+', 25, 0, 'R9',  NULL);
-- Shotgun (17)
INSERT INTO necro_weapon_characteristic VALUES (41, 17, 'solid ammo',         '8',   '16',  '+1', '-',  '4',   '-',  '2', '4+', 0,  1, 'C',   NULL);
INSERT INTO necro_weapon_characteristic VALUES (42, 17, 'scatter ammo',       '4',   '8',   '+2', '-',  '2',   '-',  '1', '4+', 0,  1, 'C',   NULL);
INSERT INTO necro_weapon_characteristic VALUES (43, 17, 'executioner ammo',   '4',   '16',  '-1', '+1', '4',   '-2', '2', '6+', 20, 0, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (44, 17, 'inferno ammo',       '4',   '16',  '+1', '-',  '4',   '-',  '2', '5+', 15, 0, 'R8',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (45, 17, 'gas shells',         '4',   '18',  '+1', '-',  '-',   '-',  '-', '6+', 25, 0, 'R11', NULL);
INSERT INTO necro_weapon_characteristic VALUES (46, 17, 'shatter shells',     '4',   '18',  '+1', '-',  '3',   '-1', '1', '5+', 15, 0, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (47, 17, 'acid rounds',        '4',   '8',   '+1', '-',  '3',   '-1', '1', '5+', 15, 0, 'R8',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (48, 17, 'phosphor rounds',    '4',   '8',   '+2', '-',  '2',   '-',  '1', '4+', 10, 0, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (49, 17, 'plantbuster rounds', '4',   '8',   '+2', '-',  '2',   '-',  '1', '4+', 15, 0, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (50, 17, 'rad rounds',         '4',   '8',   '+1', '-',  '2',   '-',  '1', '4+', 25, 0, 'R9',  NULL);
INSERT INTO necro_weapon_characteristic VALUES (51, 17, 'retributor ammo',    '4',   '8',   '+1', '-',  '4',   '-',  '1', '5+', 20, 0, 'E',   2);
-- Sling gun (18)
INSERT INTO necro_weapon_characteristic VALUES (52, 18, 'Standard',           '6',   '12',  '+2', '-',  '4',   '-2', '1', '5+', 0,  1, 'R11', NULL);
-- Stake-crossbow (19)
INSERT INTO necro_weapon_characteristic VALUES (53, 19, 'Standard',           '5',   '15',  '+1', '-',  '3',   '-',  '1', '4+', 0,  1, 'R9',  NULL);
-- Throwing knives (20)
INSERT INTO necro_weapon_characteristic VALUES (54, 20, 'Standard',           'Sx2', 'Sx4', '-',  '-1', '-',   '-1', '-', '5+', 0,  1, 'C',   NULL);
-- Warpstorm bolter (21)
INSERT INTO necro_weapon_characteristic VALUES (55, 21, 'Standard',           '12',  '24',  '+1', '-',  '4',   '-1', '2', '6+', 0,  1, 'I10', NULL);
-- Cawdor polearm with autogun (22)
INSERT INTO necro_weapon_characteristic VALUES (56, 22, 'Polearm',            'E',   '2',   '-1', '-',  'S+1', '-',  '1', '-',  0,  1, 'E',   4);
INSERT INTO necro_weapon_characteristic VALUES (57, 22, 'Autogun',            '8',   '24',  '+1', '-',  '3',   '-',  '1', '4+', 0,  1, 'E',   4);
-- Cawdor charger with autogun (23)
INSERT INTO necro_weapon_characteristic VALUES (58, 23, 'charger',            'E',   '2',   '-',  '-',  'S+1', '-',  '1', '-',  0,  1, 'E',   4);
INSERT INTO necro_weapon_characteristic VALUES (59, 23, 'with autogun',       '8',   '24',  '+1', '-',  '3',   '-',  '1', '5+', 0,  1, 'E',   4);
-- Cawdor charger with blunderbuss (24)
INSERT INTO necro_weapon_characteristic VALUES (60, 24, 'charger',            'E',   '2',   '-',  '-',  'S+1', '-',  '1', '-',  0,  1, 'E',   4);
INSERT INTO necro_weapon_characteristic VALUES (61, 24, 'grape shot',         '-',   'T',   '-',  '-',  '2',   '-',  '1', '6+', 0,  1, 'E',   4);
INSERT INTO necro_weapon_characteristic VALUES (62, 24, 'purgation shot',     '-',   'T',   '-',  '-',  '3',   '-',  '1', '6+', 0,  1, 'E',   4);
-- Cawdor charger with flamer (25)
INSERT INTO necro_weapon_characteristic VALUES (63, 25, 'charger',            'E',   '2',   '-',  '-',  'S+1', '-',  '1', '-',  0,  1, 'E',   4);
INSERT INTO necro_weapon_characteristic VALUES (64, 25, 'with flamer',        '-',   'T',   '-',  '-',  '4',   '-1', '1', '5+', 0,  1, 'E',   4);
-- Cawdor polearm/blunderbuss (26)
INSERT INTO necro_weapon_characteristic VALUES (65, 26, 'Polearm',            'E',   '2',   '-1', '-',  'S+1', '-',  '1', '-',  0,  1, 'E',   4);
INSERT INTO necro_weapon_characteristic VALUES (66, 26, 'grape shot',         '-',   'T',   '-',  '-',  '2',   '-',  '1', '6+', 0,  1, 'E',   4);
INSERT INTO necro_weapon_characteristic VALUES (67, 26, 'purgation shot',     '-',   'T',   '-',  '-',  '3',   '-',  '1', '6+', 0,  1, 'E',   4);
INSERT INTO necro_weapon_characteristic VALUES (68, 26, 'Emperor''s Wrath',   '8',   '12',  '-',  '-1', '4',   '-1', '2', '4+', 35, 0, 'E',   4);
-- Enforcer boltgun (27)
INSERT INTO necro_weapon_characteristic VALUES (69, 27, 'Standard',           '12',  '24',  '+1', '-',  '4',   '-1', '2', '4+', 0,  1, 'E',   9);
INSERT INTO necro_weapon_characteristic VALUES (70, 27, 'penetrator rounds',  '12',  '24',  '+1', '-',  '4',   '-2', '2', '4+', 20, 0, 'E',   9);
-- Enforcer shotgun (28)
INSERT INTO necro_weapon_characteristic VALUES (71, 28, 'Salvo rounds',       '4',   '12',  '+1', '-',  '4',   '-',  '2', '4+', 0,  1, 'E',   9);
INSERT INTO necro_weapon_characteristic VALUES (72, 28, 'Shredder rounds',    '-',   'T',   '-',  '-',  '2',   '-',  '1', '4+', 0,  1, 'E',   9);
-- Exterminator (29)
INSERT INTO necro_weapon_characteristic VALUES (73, 29, 'Standard',           '-',   'T',   '-',  '-',  '3',   '-1', '1', '*',  0,  1, 'E',   4);
-- Ironhead autogun (30)
INSERT INTO necro_weapon_characteristic VALUES (74, 30, 'Standard',           '8',   '24',  '+1', '-',  '3',   '-',  '1', '4+', 0,  1, 'E',   7);
-- Ironhead boltgun (31)
INSERT INTO necro_weapon_characteristic VALUES (75, 31, 'Standard',           '12',  '24',  '+1', '-',  '4',   '-1', '2', '6+', 0,  1, 'E',   7);
-- Ironhead combat shotgun (32)
INSERT INTO necro_weapon_characteristic VALUES (76, 32, 'Standard',           '8',   '16',  '+1', '-',  '4',   '-',  '2', '4+', 0,  1, 'E',   7);
-- Las carbine (33)
INSERT INTO necro_weapon_characteristic VALUES (77, 33, 'Standard',           '10',  '24',  '+1', '-',  '3',   '-',  '1', '4+', 0,  1, 'E',   6);
-- Stub cannon (34)
INSERT INTO necro_weapon_characteristic VALUES (78, 34, 'Standard',           '9',   '18',  '-',  '-',  '5',   '-',  '1', '3+', 0,  1, 'E',   3);
INSERT INTO necro_weapon_characteristic VALUES (79, 34, 'static rounds',      '9',   '18',  '-',  '-',  '5',   '-',  '1', '3+', 10, 0, 'I9',  3);
INSERT INTO necro_weapon_characteristic VALUES (80, 34, 'warp rounds',        '9',   '18',  '-',  '-',  '5',   '-',  '1', '3+', 15, 0, 'I10', 3);
-- Subjugation pattern grenade launcher (35)
INSERT INTO necro_weapon_characteristic VALUES (81, 35, 'frag grenades',         '6', '24',  '-1', '-',  '3',   '-',  '1', '6+', 0,  1, 'E',   9);
INSERT INTO necro_weapon_characteristic VALUES (82, 35, 'stun grenades',         '6', '24',  '-',  '-',  '2',   '-1', '1', '4+', 0,  1, 'E',   9);
INSERT INTO necro_weapon_characteristic VALUES (83, 35, 'choke gas grenades',    '6', '24',  '-1', '-',  '-',   '-',  '-', '5+', 30, 0, 'E',   9);
INSERT INTO necro_weapon_characteristic VALUES (84, 35, 'krak grenades',         '6', '24',  '-1', '-',  '6',   '-2', '2', '6+', 35, 0, 'E',   9);
INSERT INTO necro_weapon_characteristic VALUES (85, 35, 'photon flash grenades', '6', '24',  '-',  '-',  '-',   '-',  '-', '5+', 15, 0, 'E',   9);
INSERT INTO necro_weapon_characteristic VALUES (86, 35, 'scare gas grenades',    '6', '24',  '-1', '-',  '-',   '-',  '-', '6+', 40, 0, 'E',   9);
INSERT INTO necro_weapon_characteristic VALUES (87, 35, 'smoke grenades',        '6', '24',  '-1', '-',  '-',   '-',  '-', '4+', 15, 0, 'E',   9);
-- Suppression laser (36)
INSERT INTO necro_weapon_characteristic VALUES (88, 36, 'broad burst',        '4',   '8',   '+2', '-',  '2',   '-',  '1', '4+', 0,  1, 'E',   6);
INSERT INTO necro_weapon_characteristic VALUES (89, 36, 'short burst',        '8',   '16',  '+1', '-',  '4',   '-',  '2', '4+', 0,  1, 'E',   6);
-- Twin-linked bolters (37)
INSERT INTO necro_weapon_characteristic VALUES (90, 37, 'Standard',           '12',  '24',  '+1', '-',  '4',   '-1', '2', '6+', 0,  1, 'E',   3);
-- Twin-linked Ironhead autogun (38)
INSERT INTO necro_weapon_characteristic VALUES (91, 38, 'Standard',           '8',   '24',  '+1', '-',  '3',   '-',  '1', '4+', 0,  1, 'E',   7);
-- Twin-linked Ironhead boltgun (39)
INSERT INTO necro_weapon_characteristic VALUES (92, 39, 'Standard',           '12',  '24',  '+1', '-',  '4',   '-1', '2', '6+', 0,  1, 'E',   7);
-- Wyld bow (40)
INSERT INTO necro_weapon_characteristic VALUES (93, 40, 'Standard',           '9',   '18',  '-',  '-1', '3',   '-',  '-', '4+', 0,  1, 'E',   2);
INSERT INTO necro_weapon_characteristic VALUES (94, 40, 'poison arrows',      '9',   '18',  '-',  '-1', '-',   '-',  '-', '6+', 25, 0, 'E',   2);
INSERT INTO necro_weapon_characteristic VALUES (95, 40, 'explosive arrows',   '9',   '18',  '-',  '-1', '2',   '-',  '1', '6+', 20, 0, 'E',   2);
INSERT INTO necro_weapon_characteristic VALUES (96, 40, 'acid arrows',        '9',   '18',  '-',  '-1', '3',   '-',  '1', '6+', 20, 0, 'E',   2);

-- ============================================================
-- BASIC WEAPONS: Trait-characteristic mappings
-- Using subqueries to avoid hardcoding auto-incremented trait IDs
-- ============================================================

-- char 9: Boltgun gas shells → Blast 3", Gas, Limited, Single Shot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 9,  id FROM necro_lookups WHERE lookup_value = 'Blast 3"'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 9,  id FROM necro_lookups WHERE lookup_value = 'Gas'          AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 9,  id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 9,  id FROM necro_lookups WHERE lookup_value = 'Single Shot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 10: Boltgun shatter shells → Blast 3", Limited
INSERT INTO necro_weapon_trait_characteristic_map SELECT 10, id FROM necro_lookups WHERE lookup_value = 'Blast 3"'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 10, id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 11: Boltgun gunk bolts → Gunk, Limited
INSERT INTO necro_weapon_trait_characteristic_map SELECT 11, id FROM necro_lookups WHERE lookup_value = 'Gunk'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 11, id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 12: Arc rifle → Blaze, Rapid Fire (1), Shock
INSERT INTO necro_weapon_trait_characteristic_map SELECT 12, id FROM necro_lookups WHERE lookup_value = 'Blaze'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 12, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 12, id FROM necro_lookups WHERE lookup_value = 'Shock'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 13: Autogun Standard → Rapid Fire (1)
INSERT INTO necro_weapon_trait_characteristic_map SELECT 13, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 14: Autogun static rounds → Limited, Shield Breaker, Shock, Rapid Fire (1)
INSERT INTO necro_weapon_trait_characteristic_map SELECT 14, id FROM necro_lookups WHERE lookup_value = 'Limited'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 14, id FROM necro_lookups WHERE lookup_value = 'Shield Breaker' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 14, id FROM necro_lookups WHERE lookup_value = 'Shock'          AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 14, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 15: Autogun warp rounds → Cursed, Limited, Single Shot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 15, id FROM necro_lookups WHERE lookup_value = 'Cursed'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 15, id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 15, id FROM necro_lookups WHERE lookup_value = 'Single Shot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 16: Autogun phosphor rounds → Flare, Rapid Fire (1), Scarce
INSERT INTO necro_weapon_trait_characteristic_map SELECT 16, id FROM necro_lookups WHERE lookup_value = 'Flare'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 16, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 16, id FROM necro_lookups WHERE lookup_value = 'Scarce'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 17: Autogun plantbuster rounds → Defoliate, Rapid Fire (1), Scarce
INSERT INTO necro_weapon_trait_characteristic_map SELECT 17, id FROM necro_lookups WHERE lookup_value = 'Defoliate'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 17, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 17, id FROM necro_lookups WHERE lookup_value = 'Scarce'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 18: Autogun rad rounds → Rad-phage, Rapid Fire (1), Scarce
INSERT INTO necro_weapon_trait_characteristic_map SELECT 18, id FROM necro_lookups WHERE lookup_value = 'Rad-phage'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 18, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 18, id FROM necro_lookups WHERE lookup_value = 'Scarce'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 19: Reclaimed autogun → Rapid Fire (1)
INSERT INTO necro_weapon_trait_characteristic_map SELECT 19, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 20: Combat shotgun salvo → Knockback, Rapid Fire (1)
INSERT INTO necro_weapon_trait_characteristic_map SELECT 20, id FROM necro_lookups WHERE lookup_value = 'Knockback'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 20, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 21: Combat shotgun shredder → Scattershot, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 21, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 21, id FROM necro_lookups WHERE lookup_value = 'Template'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 22: Combat shotgun firestorm → Blaze, Limited, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 22, id FROM necro_lookups WHERE lookup_value = 'Blaze'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 22, id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 22, id FROM necro_lookups WHERE lookup_value = 'Template'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 23: Combat shotgun gas shells → Blast 3", Gas, Limited, Single Shot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 23, id FROM necro_lookups WHERE lookup_value = 'Blast 3"'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 23, id FROM necro_lookups WHERE lookup_value = 'Gas'          AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 23, id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 23, id FROM necro_lookups WHERE lookup_value = 'Single Shot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 24: Combat shotgun shatter shells → Blast 3", Limited
INSERT INTO necro_weapon_trait_characteristic_map SELECT 24, id FROM necro_lookups WHERE lookup_value = 'Blast 3"'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 24, id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 25: Combat shotgun phosphor rounds → Flare, Scarce, Scattershot, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 25, id FROM necro_lookups WHERE lookup_value = 'Flare'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 25, id FROM necro_lookups WHERE lookup_value = 'Scarce'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 25, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 25, id FROM necro_lookups WHERE lookup_value = 'Template'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 26: Combat shotgun plantbuster rounds → Defoliate, Scarce, Scattershot, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 26, id FROM necro_lookups WHERE lookup_value = 'Defoliate'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 26, id FROM necro_lookups WHERE lookup_value = 'Scarce'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 26, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 26, id FROM necro_lookups WHERE lookup_value = 'Template'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 27: Combat shotgun rad rounds → Scattershot, Rad-phage, Scarce, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 27, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 27, id FROM necro_lookups WHERE lookup_value = 'Rad-phage'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 27, id FROM necro_lookups WHERE lookup_value = 'Scarce'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 27, id FROM necro_lookups WHERE lookup_value = 'Template'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 28: Kroot long rifle ranged → Esoteric, Knockback, Plentiful
INSERT INTO necro_weapon_trait_characteristic_map SELECT 28, id FROM necro_lookups WHERE lookup_value = 'Esoteric'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 28, id FROM necro_lookups WHERE lookup_value = 'Knockback'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 28, id FROM necro_lookups WHERE lookup_value = 'Plentiful'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 29: Kroot long rifle melee → Disarm, Esoteric, Melee, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 29, id FROM necro_lookups WHERE lookup_value = 'Disarm'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 29, id FROM necro_lookups WHERE lookup_value = 'Esoteric'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 29, id FROM necro_lookups WHERE lookup_value = 'Melee'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 29, id FROM necro_lookups WHERE lookup_value = 'Versatile'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 30: Lasgun Standard → Plentiful
INSERT INTO necro_weapon_trait_characteristic_map SELECT 30, id FROM necro_lookups WHERE lookup_value = 'Plentiful'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 31: Lasgun hotshot las pack → (none)
-- char 32: Lasgun focusing crystal → Unstable
INSERT INTO necro_weapon_trait_characteristic_map SELECT 32, id FROM necro_lookups WHERE lookup_value = 'Unstable'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 33: Rak'gol razor gun → Esoteric, Rapid Fire (2), Toxin
INSERT INTO necro_weapon_trait_characteristic_map SELECT 33, id FROM necro_lookups WHERE lookup_value = 'Esoteric'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 33, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (2)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 33, id FROM necro_lookups WHERE lookup_value = 'Toxin'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 34: Sawn-off scatter → Plentiful, Scattershot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 34, id FROM necro_lookups WHERE lookup_value = 'Plentiful'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 34, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 35: Sawn-off solid → Knockback, Plentiful
INSERT INTO necro_weapon_trait_characteristic_map SELECT 35, id FROM necro_lookups WHERE lookup_value = 'Knockback'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 35, id FROM necro_lookups WHERE lookup_value = 'Plentiful'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 36: Sawn-off gas shells → Blast 3", Gas, Limited, Single Shot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 36, id FROM necro_lookups WHERE lookup_value = 'Blast 3"'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 36, id FROM necro_lookups WHERE lookup_value = 'Gas'          AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 36, id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 36, id FROM necro_lookups WHERE lookup_value = 'Single Shot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 37: Sawn-off shatter shells → Blast 3", Limited
INSERT INTO necro_weapon_trait_characteristic_map SELECT 37, id FROM necro_lookups WHERE lookup_value = 'Blast 3"'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 37, id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 38: Sawn-off phosphor rounds → Flare, Scarce, Scattershot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 38, id FROM necro_lookups WHERE lookup_value = 'Flare'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 38, id FROM necro_lookups WHERE lookup_value = 'Scarce'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 38, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 39: Sawn-off plantbuster rounds → Defoliate, Scarce, Scattershot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 39, id FROM necro_lookups WHERE lookup_value = 'Defoliate'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 39, id FROM necro_lookups WHERE lookup_value = 'Scarce'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 39, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 40: Sawn-off rad rounds → Rad-phage, Scarce, Scattershot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 40, id FROM necro_lookups WHERE lookup_value = 'Rad-phage'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 40, id FROM necro_lookups WHERE lookup_value = 'Scarce'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 40, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 41: Shotgun solid → Knockback
INSERT INTO necro_weapon_trait_characteristic_map SELECT 41, id FROM necro_lookups WHERE lookup_value = 'Knockback'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 42: Shotgun scatter → Scattershot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 42, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 43: Shotgun executioner → Knockback, Limited
INSERT INTO necro_weapon_trait_characteristic_map SELECT 43, id FROM necro_lookups WHERE lookup_value = 'Knockback'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 43, id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 44: Shotgun inferno → Blaze, Limited
INSERT INTO necro_weapon_trait_characteristic_map SELECT 44, id FROM necro_lookups WHERE lookup_value = 'Blaze'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 44, id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 45: Shotgun gas shells → Blast 3", Gas, Limited, Single Shot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 45, id FROM necro_lookups WHERE lookup_value = 'Blast 3"'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 45, id FROM necro_lookups WHERE lookup_value = 'Gas'          AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 45, id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 45, id FROM necro_lookups WHERE lookup_value = 'Single Shot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 46: Shotgun shatter shells → Blast 3", Limited
INSERT INTO necro_weapon_trait_characteristic_map SELECT 46, id FROM necro_lookups WHERE lookup_value = 'Blast 3"'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 46, id FROM necro_lookups WHERE lookup_value = 'Limited'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 47: Shotgun acid rounds → Blaze, Scattershot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 47, id FROM necro_lookups WHERE lookup_value = 'Blaze'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 47, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 48: Shotgun phosphor rounds → Flare, Scarce, Scattershot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 48, id FROM necro_lookups WHERE lookup_value = 'Flare'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 48, id FROM necro_lookups WHERE lookup_value = 'Scarce'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 48, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 49: Shotgun plantbuster rounds → Defoliate, Scarce, Scattershot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 49, id FROM necro_lookups WHERE lookup_value = 'Defoliate'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 49, id FROM necro_lookups WHERE lookup_value = 'Scarce'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 49, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 50: Shotgun rad rounds → Rad-phage, Scarce, Scattershot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 50, id FROM necro_lookups WHERE lookup_value = 'Rad-phage'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 50, id FROM necro_lookups WHERE lookup_value = 'Scarce'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 50, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 51: Shotgun retributor ammo → Blaze, Scattershot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 51, id FROM necro_lookups WHERE lookup_value = 'Blaze'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 51, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 52: Sling gun → Esoteric, Rapid Fire (1), Scarce
INSERT INTO necro_weapon_trait_characteristic_map SELECT 52, id FROM necro_lookups WHERE lookup_value = 'Esoteric'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 52, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 52, id FROM necro_lookups WHERE lookup_value = 'Scarce'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 53: Stake-crossbow → Hexagrammatic, Silent
INSERT INTO necro_weapon_trait_characteristic_map SELECT 53, id FROM necro_lookups WHERE lookup_value = 'Hexagrammatic' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 53, id FROM necro_lookups WHERE lookup_value = 'Silent'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 54: Throwing knives → Scarce, Silent, Toxin
INSERT INTO necro_weapon_trait_characteristic_map SELECT 54, id FROM necro_lookups WHERE lookup_value = 'Scarce'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 54, id FROM necro_lookups WHERE lookup_value = 'Silent'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 54, id FROM necro_lookups WHERE lookup_value = 'Toxin'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 55: Warpstorm bolter → Cursed, Esoteric, Rapid Fire (1), Scarce
INSERT INTO necro_weapon_trait_characteristic_map SELECT 55, id FROM necro_lookups WHERE lookup_value = 'Cursed'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 55, id FROM necro_lookups WHERE lookup_value = 'Esoteric'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 55, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 55, id FROM necro_lookups WHERE lookup_value = 'Scarce'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 56: Cawdor polearm - Polearm → Melee, Unwieldy, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 56, id FROM necro_lookups WHERE lookup_value = 'Melee'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 56, id FROM necro_lookups WHERE lookup_value = 'Unwieldy'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 56, id FROM necro_lookups WHERE lookup_value = 'Versatile'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 57: Cawdor polearm - Autogun → Rapid Fire (1)
INSERT INTO necro_weapon_trait_characteristic_map SELECT 57, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 58: Cawdor charger w/autogun - charger → Lance, Melee, Unwieldy, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 58, id FROM necro_lookups WHERE lookup_value = 'Lance'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 58, id FROM necro_lookups WHERE lookup_value = 'Melee'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 58, id FROM necro_lookups WHERE lookup_value = 'Unwieldy'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 58, id FROM necro_lookups WHERE lookup_value = 'Versatile'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 59: Cawdor charger w/autogun - with autogun → Rapid Fire (1)
INSERT INTO necro_weapon_trait_characteristic_map SELECT 59, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 60: Cawdor charger w/blunderbuss - charger → Lance, Melee, Unwieldy, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 60, id FROM necro_lookups WHERE lookup_value = 'Lance'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 60, id FROM necro_lookups WHERE lookup_value = 'Melee'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 60, id FROM necro_lookups WHERE lookup_value = 'Unwieldy'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 60, id FROM necro_lookups WHERE lookup_value = 'Versatile'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 61: Cawdor charger w/blunderbuss - grape shot → Plentiful, Scattershot, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 61, id FROM necro_lookups WHERE lookup_value = 'Plentiful'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 61, id FROM necro_lookups WHERE lookup_value = 'Scattershot'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 61, id FROM necro_lookups WHERE lookup_value = 'Template'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 62: Cawdor charger w/blunderbuss - purgation shot → Blaze, Scarce, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 62, id FROM necro_lookups WHERE lookup_value = 'Blaze'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 62, id FROM necro_lookups WHERE lookup_value = 'Scarce'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 62, id FROM necro_lookups WHERE lookup_value = 'Template'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 63: Cawdor charger w/flamer - charger → Lance, Melee, Unwieldy, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 63, id FROM necro_lookups WHERE lookup_value = 'Lance'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 63, id FROM necro_lookups WHERE lookup_value = 'Melee'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 63, id FROM necro_lookups WHERE lookup_value = 'Unwieldy'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 63, id FROM necro_lookups WHERE lookup_value = 'Versatile'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 64: Cawdor charger w/flamer - with flamer → Blaze, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 64, id FROM necro_lookups WHERE lookup_value = 'Blaze'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 64, id FROM necro_lookups WHERE lookup_value = 'Template'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 65: Cawdor polearm/blunderbuss - Polearm → Melee, Unwieldy, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 65, id FROM necro_lookups WHERE lookup_value = 'Melee'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 65, id FROM necro_lookups WHERE lookup_value = 'Unwieldy'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 65, id FROM necro_lookups WHERE lookup_value = 'Versatile'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 66: Cawdor polearm/blunderbuss - grape shot → Plentiful, Scattershot, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 66, id FROM necro_lookups WHERE lookup_value = 'Plentiful'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 66, id FROM necro_lookups WHERE lookup_value = 'Scattershot'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 66, id FROM necro_lookups WHERE lookup_value = 'Template'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 67: Cawdor polearm/blunderbuss - purgation shot → Blaze, Scarce, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 67, id FROM necro_lookups WHERE lookup_value = 'Blaze'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 67, id FROM necro_lookups WHERE lookup_value = 'Scarce'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 67, id FROM necro_lookups WHERE lookup_value = 'Template'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 68: Cawdor polearm/blunderbuss - Emperor's Wrath → Knockback, Pulverise
INSERT INTO necro_weapon_trait_characteristic_map SELECT 68, id FROM necro_lookups WHERE lookup_value = 'Knockback'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 68, id FROM necro_lookups WHERE lookup_value = 'Pulverise'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 69: Enforcer boltgun Standard → Rapid Fire (1)
INSERT INTO necro_weapon_trait_characteristic_map SELECT 69, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 70: Enforcer boltgun penetrator → Rapid Fire (1), Rending, Unstable
INSERT INTO necro_weapon_trait_characteristic_map SELECT 70, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 70, id FROM necro_lookups WHERE lookup_value = 'Rending'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 70, id FROM necro_lookups WHERE lookup_value = 'Unstable'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 71: Enforcer shotgun Salvo → Knockback, Rapid Fire (1)
INSERT INTO necro_weapon_trait_characteristic_map SELECT 71, id FROM necro_lookups WHERE lookup_value = 'Knockback'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 71, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 72: Enforcer shotgun Shredder → Scattershot, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 72, id FROM necro_lookups WHERE lookup_value = 'Scattershot'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 72, id FROM necro_lookups WHERE lookup_value = 'Template'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 73: Exterminator → Blaze, Single Shot, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 73, id FROM necro_lookups WHERE lookup_value = 'Blaze'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 73, id FROM necro_lookups WHERE lookup_value = 'Single Shot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 73, id FROM necro_lookups WHERE lookup_value = 'Template'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 74: Ironhead autogun → Rapid Fire (2)
INSERT INTO necro_weapon_trait_characteristic_map SELECT 74, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (2)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 75: Ironhead boltgun → Rapid Fire (2)
INSERT INTO necro_weapon_trait_characteristic_map SELECT 75, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (2)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 76: Ironhead combat shotgun → Knockback, Rapid Fire (1)
INSERT INTO necro_weapon_trait_characteristic_map SELECT 76, id FROM necro_lookups WHERE lookup_value = 'Knockback'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 76, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 77: Las carbine → Plentiful, Rapid Fire (1)
INSERT INTO necro_weapon_trait_characteristic_map SELECT 77, id FROM necro_lookups WHERE lookup_value = 'Plentiful'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 77, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 78: Stub cannon Standard → Knockback
INSERT INTO necro_weapon_trait_characteristic_map SELECT 78, id FROM necro_lookups WHERE lookup_value = 'Knockback'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 79: Stub cannon static rounds → Knockback, Limited, Shield Breaker, Shock
INSERT INTO necro_weapon_trait_characteristic_map SELECT 79, id FROM necro_lookups WHERE lookup_value = 'Knockback'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 79, id FROM necro_lookups WHERE lookup_value = 'Limited'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 79, id FROM necro_lookups WHERE lookup_value = 'Shield Breaker' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 79, id FROM necro_lookups WHERE lookup_value = 'Shock'          AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 80: Stub cannon warp rounds → Cursed, Knockback, Limited, Single Shot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 80, id FROM necro_lookups WHERE lookup_value = 'Cursed'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 80, id FROM necro_lookups WHERE lookup_value = 'Knockback'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 80, id FROM necro_lookups WHERE lookup_value = 'Limited'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 80, id FROM necro_lookups WHERE lookup_value = 'Single Shot'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 81: Subjugation GL frag grenades → Blast 3", Knockback
INSERT INTO necro_weapon_trait_characteristic_map SELECT 81, id FROM necro_lookups WHERE lookup_value = 'Blast 3"'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 81, id FROM necro_lookups WHERE lookup_value = 'Knockback'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 82: Subjugation GL stun grenades → Concussion
INSERT INTO necro_weapon_trait_characteristic_map SELECT 82, id FROM necro_lookups WHERE lookup_value = 'Concussion'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 83: Subjugation GL choke gas grenades → Blast 3", Gas, Limited
INSERT INTO necro_weapon_trait_characteristic_map SELECT 83, id FROM necro_lookups WHERE lookup_value = 'Blast 3"'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 83, id FROM necro_lookups WHERE lookup_value = 'Gas'           AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 83, id FROM necro_lookups WHERE lookup_value = 'Limited'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 84: Subjugation GL krak grenades → (none)
-- char 85: Subjugation GL photon flash grenades → Blast 5", Flash
INSERT INTO necro_weapon_trait_characteristic_map SELECT 85, id FROM necro_lookups WHERE lookup_value = 'Blast 5"'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 85, id FROM necro_lookups WHERE lookup_value = 'Flash'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 86: Subjugation GL scare gas grenades → Blast 3", Fear, Gas, Limited
INSERT INTO necro_weapon_trait_characteristic_map SELECT 86, id FROM necro_lookups WHERE lookup_value = 'Blast 3"'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 86, id FROM necro_lookups WHERE lookup_value = 'Fear'          AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 86, id FROM necro_lookups WHERE lookup_value = 'Gas'           AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 86, id FROM necro_lookups WHERE lookup_value = 'Limited'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 87: Subjugation GL smoke grenades → Blast (*), Smoke
INSERT INTO necro_weapon_trait_characteristic_map SELECT 87, id FROM necro_lookups WHERE lookup_value = 'Blast (*)'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 87, id FROM necro_lookups WHERE lookup_value = 'Smoke'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 88: Suppression laser broad burst → Plentiful, Scattershot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 88, id FROM necro_lookups WHERE lookup_value = 'Plentiful'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 88, id FROM necro_lookups WHERE lookup_value = 'Scattershot'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 89: Suppression laser short burst → Knockback, Plentiful
INSERT INTO necro_weapon_trait_characteristic_map SELECT 89, id FROM necro_lookups WHERE lookup_value = 'Knockback'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 89, id FROM necro_lookups WHERE lookup_value = 'Plentiful'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 90: Twin-linked bolters → Rapid Fire (1), Twin-linked
INSERT INTO necro_weapon_trait_characteristic_map SELECT 90, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (1)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 90, id FROM necro_lookups WHERE lookup_value = 'Twin-linked'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 91: Twin-linked Ironhead autogun → Rapid Fire (2), Twin-linked
INSERT INTO necro_weapon_trait_characteristic_map SELECT 91, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (2)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 91, id FROM necro_lookups WHERE lookup_value = 'Twin-linked'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 92: Twin-linked Ironhead boltgun → Rapid Fire (2), Twin-linked
INSERT INTO necro_weapon_trait_characteristic_map SELECT 92, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (2)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 92, id FROM necro_lookups WHERE lookup_value = 'Twin-linked'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 93: Wyld bow Standard → Silent
INSERT INTO necro_weapon_trait_characteristic_map SELECT 93, id FROM necro_lookups WHERE lookup_value = 'Silent'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 94: Wyld bow poison arrows → Scarce, Silent, Toxin
INSERT INTO necro_weapon_trait_characteristic_map SELECT 94, id FROM necro_lookups WHERE lookup_value = 'Scarce'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 94, id FROM necro_lookups WHERE lookup_value = 'Silent'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 94, id FROM necro_lookups WHERE lookup_value = 'Toxin'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 95: Wyld bow explosive arrows → Blast 3", Scarce, Unstable
INSERT INTO necro_weapon_trait_characteristic_map SELECT 95, id FROM necro_lookups WHERE lookup_value = 'Blast 3"'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 95, id FROM necro_lookups WHERE lookup_value = 'Scarce'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 95, id FROM necro_lookups WHERE lookup_value = 'Unstable'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 96: Wyld bow acid arrows → Blaze, Scarce
INSERT INTO necro_weapon_trait_characteristic_map SELECT 96, id FROM necro_lookups WHERE lookup_value = 'Blaze'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 96, id FROM necro_lookups WHERE lookup_value = 'Scarce'        AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;

-- ============================================================
-- CLOSE COMBAT WEAPONS: New traits
-- ============================================================
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Haemophagic', 'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Lance-bomb',   'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Paired',       'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Phase',        'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Shred',        'WEAPON_TRAIT');
INSERT INTO necro_lookups (id, lookup_value, lookup_key) VALUES (0, 'Whispering',   'WEAPON_TRAIT');

-- ============================================================
-- CLOSE COMBAT WEAPONS: New weapons (IDs 41-123, weapon_category_id=5)
-- ============================================================
INSERT INTO necro_weapon VALUES (41,  5, 'Power knife',                         25,  'R9',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (42,  5, 'Axe',                                 10,  'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (43,  5, 'Chainaxe',                            30,  'R9',  NULL, 0, 3);
INSERT INTO necro_weapon VALUES (44,  5, 'Cleaver',                             20,  'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (45,  5, 'Digi laser',                          25,  'R10', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (46,  5, 'Flail',                               20,  'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (47,  5, 'Goredrinker axe',                     40,  'I9',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (48,  5, 'Heavy club',                          15,  'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (49,  5, 'Hex''iron Blade',                     25,  'I9',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (50,  5, 'Maul (Club)',                         10,  'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (51,  5, 'Servo claw',                          35,  'R10', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (52,  5, 'Sword',                               20,  'R6',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (53,  5, 'Whip',                                15,  'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (54,  5, 'Whisperbane knife',                   30,  'I11', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (55,  5, 'Xenarch Death-arc',                   75,  'I9',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (56,  5, 'Desire''s Needle',                    50,  'I9',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (57,  5, 'Las cutter',                          85,  'R10', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (58,  5, 'Lightning claw',                      70,  'R11', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (59,  5, 'Power axe',                           35,  'R8',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (60,  5, 'Power claw',                          55,  'R11', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (61,  5, 'Power fist',                         100,  'R11', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (62,  5, 'Power hammer',                        45,  'R8',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (63,  5, 'Power maul',                          30,  'R8',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (64,  5, 'Power pick',                          40,  'R8',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (65,  5, 'Power sword',                         50,  'R9',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (66,  5, 'Shock baton',                         30,  'R8',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (67,  5, 'Shock stave',                         25,  'R9',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (68,  5, 'Tenebrous Scourge',                   60,  'I10', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (69,  5, 'Thunder hammer',                      70,  'R11', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (70,  5, 'Chain glaive*',                      60,  'R7',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (71,  5, 'Greatsword*',                         40,  'R10', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (72,  5, 'Heavy rock cutter*',                 135,  'R9',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (73,  5, 'Heavy rock drill*',                   90,  'R9',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (74,  5, 'Heavy rock saw*',                    120,  'R9',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (75,  5, 'Polearm*',                            30,  'R9',  NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (76,  5, 'Two-handed axe*',                     25,  'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (77,  5, 'Two-handed hammer*',                  35,  'C',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (78,  5, 'Araneus-pattern power fist',         145,  'E',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (79,  5, 'Arc hammer*',                         70,  'E',   NULL, 0, 1);
INSERT INTO necro_weapon VALUES (80,  5, 'Arc welder',                          50,  'E',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (81,  5, 'Augmetic fist',                       40,  'E',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (82,  5, 'Barbed flabellum',                    80,  'I12', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (83,  5, 'The Bloodfingers',                    95,  'I13', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (84,  5, 'Boning sword',                        25,  'E',   NULL, 0, 10);
INSERT INTO necro_weapon VALUES (85,  5, 'Brute cleaver',                       15,  'E',   NULL, 0, 3);
INSERT INTO necro_weapon VALUES (86,  5, 'Butcher''s chain cleaver',            45,  'E',   NULL, 0, 10);
INSERT INTO necro_weapon VALUES (87,  5, 'Butcher''s cleaver',                  20,  'E',   NULL, 0, 10);
INSERT INTO necro_weapon VALUES (88,  5, 'Drawn-out Death*',                   160,  'I13', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (89,  5, 'Eviscerator',                         70,  'E',   NULL, 0, 4);
INSERT INTO necro_weapon VALUES (90,  5, 'Excavator hammer*',                   50,  'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (91,  5, 'Flensing knife',                      35,  'E',   NULL, 0, 10);
INSERT INTO necro_weapon VALUES (92,  5, 'Frag lance',                          35,  'E',   NULL, 0, 4);
INSERT INTO necro_weapon VALUES (93,  5, 'Gleeful Judgement',                   85,  'I13', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (94,  5, 'Haemophagic Blade',                   50,  'I13', NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (95,  5, 'Heavy chain cleaver',                 80,  'E',   NULL, 0, 10);
INSERT INTO necro_weapon VALUES (96,  5, 'Heavy drill',                         35,  'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (97,  5, 'Hydraulic drill',                     25,  'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (98,  5, '''Hystrar'' pattern energy shield',   50,  'E',   NULL, 0, 6);
INSERT INTO necro_weapon VALUES (99,  5, 'Ironhead power fist',                 60,  'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (100, 5, 'Krak lance',                          50,  'E',   NULL, 0, 4);
INSERT INTO necro_weapon VALUES (101, 5, 'Paired augmetic fists*',              70,  'E',   NULL, 0, NULL);
INSERT INTO necro_weapon VALUES (102, 5, 'Paired butcher''s chain cleaver*',    80,  'E',   NULL, 0, 10);
INSERT INTO necro_weapon VALUES (103, 5, 'Paired heavy chain cleavers*',       130,  'E',   NULL, 0, 10);
INSERT INTO necro_weapon VALUES (104, 5, 'Paired psychomantic claws',            0,  'E',   NULL, 0, 5);
INSERT INTO necro_weapon VALUES (105, 5, 'Paired ''Pulverizers''*',             50,  'E',   NULL, 0, 3);
INSERT INTO necro_weapon VALUES (106, 5, 'Paired spud-jackers*',                25,  'E',   NULL, 0, 3);
INSERT INTO necro_weapon VALUES (107, 5, '''Pulverizer'' Serrated Axe',         30,  'E',   NULL, 0, 3);
INSERT INTO necro_weapon VALUES (108, 5, 'Riot shield',                         35,  'E',   NULL, 0, 9);
INSERT INTO necro_weapon VALUES (109, 5, '''Renderizer'' Serrated Axe*',        40,  'E',   NULL, 0, 3);
INSERT INTO necro_weapon VALUES (110, 5, 'Rock saw',                            35,  'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (111, 5, 'Rotary flensing saw*',                55,  'E',   NULL, 0, 10);
INSERT INTO necro_weapon VALUES (112, 5, 'Serpent''s Fangs*',                   90,  'E',   NULL, 0, 5);
INSERT INTO necro_weapon VALUES (113, 5, 'Shock whip',                          25,  'E',   NULL, 0, 2);
INSERT INTO necro_weapon VALUES (114, 5, 'Shivver sword',                       70,  'E',   NULL, 0, 5);
INSERT INTO necro_weapon VALUES (115, 5, 'Spider-rig*',                         80,  'E',   NULL, 0, 6);
INSERT INTO necro_weapon VALUES (116, 5, 'Spud-jacker',                         15,  'E',   NULL, 0, 3);
INSERT INTO necro_weapon VALUES (117, 5, 'Stun lance',                          30,  'E',   NULL, 0, 4);
INSERT INTO necro_weapon VALUES (118, 5, 'Two-handed chainaxe*',                40,  'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (119, 5, 'Two-handed power axe*',               65,  'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (120, 5, 'Two-handed power pick*',              75,  'E',   NULL, 0, 7);
INSERT INTO necro_weapon VALUES (121, 5, 'Venom claw',                          30,  'E',   NULL, 0, 2);
INSERT INTO necro_weapon VALUES (122, 5, 'Vigilance pattern assault shield',    40,  'E',   NULL, 0, 9);
INSERT INTO necro_weapon VALUES (123, 5, 'Web gauntlet',                        35,  'E',   NULL, 0, 5);

-- ============================================================
-- CLOSE COMBAT WEAPONS: Weapon characteristics
-- Columns: id, weapon_id, ammo_type, range_short, range_long,
--          accuracy_short, accuracy_long, strength, armor_penetration,
--          damage, ammo_check, characteristic_value, default_loadout, rarity, gang_type_id
-- ============================================================

-- Power knife (41)
INSERT INTO necro_weapon_characteristic VALUES (97,  41,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-2', '1', '-',  0, 1, 'R9',  NULL);
-- Axe (42)
INSERT INTO necro_weapon_characteristic VALUES (98,  42,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-',  '1', '-',  0, 1, 'C',   NULL);
-- Chainaxe (43)
INSERT INTO necro_weapon_characteristic VALUES (99,  43,  'Standard',                        'E', '-',   '-',  '+1', 'S+1', '-1', '1', '-',  0, 1, 'R9',  3);
-- Cleaver (44)
INSERT INTO necro_weapon_characteristic VALUES (100, 44,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-1', '1', '-',  0, 1, 'C',   NULL);
-- Digi laser (45)
INSERT INTO necro_weapon_characteristic VALUES (101, 45,  'Standard',                        'E', '3"',  '-',  '-',  '1',   '-',  '1', '6+', 0, 1, 'R10', NULL);
-- Flail (46)
INSERT INTO necro_weapon_characteristic VALUES (102, 46,  'Standard',                        'E', '-',   '-',  '+1', 'S+1', '-',  '1', '-',  0, 1, 'C',   NULL);
-- Goredrinker axe (47)
INSERT INTO necro_weapon_characteristic VALUES (103, 47,  'Standard',                        'E', '-',   '-',  '-',  'S+3', '-1', '2', '-',  0, 1, 'I9',  NULL);
-- Heavy club (48)
INSERT INTO necro_weapon_characteristic VALUES (104, 48,  'Standard',                        'E', '-',   '-',  '-',  'S',   '-',  '2', '-',  0, 1, 'C',   NULL);
-- Hex'iron Blade (49)
INSERT INTO necro_weapon_characteristic VALUES (105, 49,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-3', '1', '-',  0, 1, 'I9',  NULL);
-- Maul (Club) (50)
INSERT INTO necro_weapon_characteristic VALUES (106, 50,  'Standard',                        'E', '-',   '-',  '-',  'S',   '+1', '2', '-',  0, 1, 'C',   NULL);
-- Servo claw (51)
INSERT INTO necro_weapon_characteristic VALUES (107, 51,  'Standard',                        'E', '-',   '-',  '-',  'S+2', '-',  '2', '-',  0, 1, 'R10', NULL);
-- Sword (52)
INSERT INTO necro_weapon_characteristic VALUES (108, 52,  'Standard',                        'E', '-',   '-',  '+1', 'S',   '-1', '1', '-',  0, 1, 'R6',  NULL);
-- Whip (53)
INSERT INTO necro_weapon_characteristic VALUES (109, 53,  'Standard',                        'E', '3"',  '-1', '-',  'S',   '-',  '1', '-',  0, 1, 'C',   NULL);
-- Whisperbane knife (54)
INSERT INTO necro_weapon_characteristic VALUES (110, 54,  'Standard',                        'E', '-',   '-',  '+1', 'S',   '-',  '1', '-',  0, 1, 'I11', NULL);
-- Xenarch Death-arc (55)
INSERT INTO necro_weapon_characteristic VALUES (111, 55,  'Standard',                        'E', '5"',  '+1', '-',  '3',   '-',  '1', '2+', 0, 1, 'I9',  NULL);
-- Desire's Needle (56)
INSERT INTO necro_weapon_characteristic VALUES (112, 56,  'Standard',                        'E', '-',   '-',  '+1', 'S+2', '-1', '-', '-',  0, 1, 'I9',  NULL);
-- Las cutter (57)
INSERT INTO necro_weapon_characteristic VALUES (113, 57,  'Standard',                        'E', '2"',  '+1', '-',  '9',   '-3', '2', '6+', 0, 1, 'R10', NULL);
-- Lightning claw (58)
INSERT INTO necro_weapon_characteristic VALUES (114, 58,  'Standard',                        'E', '-',   '-',  '+1', 'S+1', '-2', '1', '-',  0, 1, 'R11', NULL);
-- Power axe (59)
INSERT INTO necro_weapon_characteristic VALUES (115, 59,  'Standard',                        'E', '-',   '-',  '-',  'S+2', '-2', '1', '-',  0, 1, 'R8',  NULL);
-- Power claw (60)
INSERT INTO necro_weapon_characteristic VALUES (116, 60,  'Standard',                        'E', '-',   '-',  '-',  'S',   '-1', '2', '-',  0, 1, 'R11', NULL);
-- Power fist (61)
INSERT INTO necro_weapon_characteristic VALUES (117, 61,  'Standard',                        'E', '-',   '-',  '-',  'S+3', '-3', '3', '-',  0, 1, 'R11', NULL);
-- Power hammer (62)
INSERT INTO necro_weapon_characteristic VALUES (118, 62,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-1', '2', '-',  0, 1, 'R8',  NULL);
-- Power maul (63)
INSERT INTO necro_weapon_characteristic VALUES (119, 63,  'Standard',                        'E', '-',   '-',  '-',  'S+2', '-1', '1', '-',  0, 1, 'R8',  NULL);
-- Power pick (64)
INSERT INTO necro_weapon_characteristic VALUES (120, 64,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-3', '1', '-',  0, 1, 'R8',  NULL);
-- Power sword (65)
INSERT INTO necro_weapon_characteristic VALUES (121, 65,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-2', '1', '-',  0, 1, 'R9',  NULL);
-- Shock baton (66)
INSERT INTO necro_weapon_characteristic VALUES (122, 66,  'Standard',                        'E', '-',   '-',  '-',  'S',   '-',  '1', '-',  0, 1, 'R8',  NULL);
-- Shock stave (67)
INSERT INTO necro_weapon_characteristic VALUES (123, 67,  'Standard',                        'E', '2"',  '-',  '-',  'S+1', '-',  '1', '-',  0, 1, 'R9',  NULL);
-- Tenebrous Scourge (68)
INSERT INTO necro_weapon_characteristic VALUES (124, 68,  'Standard',                        'E', '3"',  '-',  '-',  'S+3', '-',  '1', '-',  0, 1, 'I10', NULL);
-- Thunder hammer (69)
INSERT INTO necro_weapon_characteristic VALUES (125, 69,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-1', '3', '-',  0, 1, 'R11', NULL);
-- Chain glaive (70)
INSERT INTO necro_weapon_characteristic VALUES (126, 70,  'Standard',                        'E', '2"',  '-1', '-',  'S+2', '-2', '2', '-',  0, 1, 'R7',  NULL);
-- Greatsword (71)
INSERT INTO necro_weapon_characteristic VALUES (127, 71,  'Standard',                        'E', '1"',  '-',  '+1', 'S+1', '-1', '1', '-',  0, 1, 'R10', NULL);
-- Heavy rock cutter (72)
INSERT INTO necro_weapon_characteristic VALUES (128, 72,  'Standard',                        'E', '-',   '-',  '-',  'S+4', '-4', '3', '-',  0, 1, 'R9',  NULL);
-- Heavy rock drill (73)
INSERT INTO necro_weapon_characteristic VALUES (129, 73,  'Standard',                        'E', '-',   '-',  '-',  'S+2', '-3', '2', '-',  0, 1, 'R9',  NULL);
-- Heavy rock saw (74)
INSERT INTO necro_weapon_characteristic VALUES (130, 74,  'Standard',                        'E', '-',   '-',  '+1', 'S+3', '-3', '2', '-',  0, 1, 'R9',  NULL);
-- Polearm (75)
INSERT INTO necro_weapon_characteristic VALUES (131, 75,  'Standard',                        'E', '2"',  '-1', '-',  'S+1', '-',  '1', '-',  0, 1, 'R9',  NULL);
-- Two-handed axe (76)
INSERT INTO necro_weapon_characteristic VALUES (132, 76,  'Standard',                        'E', '-',   '-',  '-1', 'S+2', '-',  '2', '-',  0, 1, 'C',   NULL);
-- Two-handed hammer (77)
INSERT INTO necro_weapon_characteristic VALUES (133, 77,  'Standard',                        'E', '-',   '-',  '-1', 'S+1', '-',  '3', '-',  0, 1, 'C',   NULL);
-- Araneus-pattern power fist (78)
INSERT INTO necro_weapon_characteristic VALUES (134, 78,  'Standard',                        'E', '-',   '-',  '-',  'S+3', '-3', '3', '-',  0, 1, 'E',   NULL);
-- Arc hammer (79)
INSERT INTO necro_weapon_characteristic VALUES (135, 79,  'Standard',                        'E', '1"',  '-',  '-',  'S+3', '-1', '3', '-',  0, 1, 'E',   1);
-- Arc welder (80)
INSERT INTO necro_weapon_characteristic VALUES (136, 80,  'Standard',                        'E', '-',   '-',  '-',  'S+2', '-3', '3', '-',  0, 1, 'E',   NULL);
-- Augmetic fist (81)
INSERT INTO necro_weapon_characteristic VALUES (137, 81,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-1', '2', '-',  0, 1, 'E',   NULL);
-- Barbed flabellum (82)
INSERT INTO necro_weapon_characteristic VALUES (138, 82,  'Standard',                        'E', '4"',  '+2', '+1', '-',   '-2', '-', '-',  0, 1, 'I12', NULL);
-- The Bloodfingers (83)
INSERT INTO necro_weapon_characteristic VALUES (139, 83,  'Standard',                        'E', '-',   '-',  '-',  'S',   '-1', '2', '-',  0, 1, 'I13', NULL);
-- Boning sword (84)
INSERT INTO necro_weapon_characteristic VALUES (140, 84,  'Standard',                        'E', '-',   '-',  '-',  'S',   '-2', '2', '-',  0, 1, 'E',   10);
-- Brute cleaver (85)
INSERT INTO necro_weapon_characteristic VALUES (141, 85,  'Standard',                        'E', '-',   '-',  '+1', 'S',   '-1', '1', '-',  0, 1, 'E',   3);
-- Butcher's chain cleaver (86)
INSERT INTO necro_weapon_characteristic VALUES (142, 86,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-2', '2', '-',  0, 1, 'E',   10);
-- Butcher's cleaver (87)
INSERT INTO necro_weapon_characteristic VALUES (143, 87,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-1', '2', '-',  0, 1, 'E',   10);
-- Drawn-out Death (88)
INSERT INTO necro_weapon_characteristic VALUES (144, 88,  'Standard',                        'E', '2"',  '-1', '-',  'S+2', '-2', '2', '-',  0, 1, 'I13', NULL);
-- Eviscerator (89)
INSERT INTO necro_weapon_characteristic VALUES (145, 89,  'melee',                           'E', '1"',  '-',  '-',  'S+1', '-1', '1', '-',  0, 1, 'E',   4);
INSERT INTO necro_weapon_characteristic VALUES (146, 89,  'ranged',                          '-', 'T',   '-',  '-',  '3',   '-1', '1', '5+', 0, 1, 'E',   4);
-- Excavator hammer (90)
INSERT INTO necro_weapon_characteristic VALUES (147, 90,  'Standard',                        'E', '2"',  '-',  '-1', 'S+2', '-1', '3', '*',  0, 1, 'E',   7);
-- Flensing knife (91)
INSERT INTO necro_weapon_characteristic VALUES (148, 91,  'Standard',                        'E', '-',   '-',  '-',  'S',   '-1', '1', '-',  0, 1, 'E',   10);
-- Frag lance (92)
INSERT INTO necro_weapon_characteristic VALUES (149, 92,  'primed',                          'E', '2"',  '+1', '-',  '4',   '-1', '1', '-',  0, 1, 'E',   4);
INSERT INTO necro_weapon_characteristic VALUES (150, 92,  'spent',                           'E', '2"',  '+1', '-',  'S',   '-',  '1', '-',  0, 1, 'E',   4);
-- Gleeful Judgement (93)
INSERT INTO necro_weapon_characteristic VALUES (151, 93,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-1', '2', '-',  0, 1, 'I13', NULL);
-- Haemophagic Blade (94)
INSERT INTO necro_weapon_characteristic VALUES (152, 94,  'Standard',                        'E', '-',   '-',  '+1', '-',   '-2', '-', '-',  0, 1, 'I13', NULL);
-- Heavy chain cleaver (95)
INSERT INTO necro_weapon_characteristic VALUES (153, 95,  'Standard',                        'E', '-',   '-',  '+1', 'S+2', '-2', '2', '-',  0, 1, 'E',   10);
-- Heavy drill (96)
INSERT INTO necro_weapon_characteristic VALUES (154, 96,  'Standard',                        'E', '-',   '-',  '-',  'S',   '-1', '2', '-',  0, 1, 'E',   7);
-- Hydraulic drill (97)
INSERT INTO necro_weapon_characteristic VALUES (155, 97,  'Standard',                        'E', '-',   '-',  '-',  'S+1', '-',  '1', '-',  0, 1, 'E',   7);
-- 'Hystrar' pattern energy shield (98)
INSERT INTO necro_weapon_characteristic VALUES (156, 98,  'Standard',                        'E', '-',   '-',  '-',  'S',   '-',  '1', '-',  0, 1, 'E',   6);
-- Ironhead power fist (99)
INSERT INTO necro_weapon_characteristic VALUES (157, 99,  'Standard',                        'E', '-',   '-',  '-',  'S+2', '-2', '2', '-',  0, 1, 'E',   7);
-- Krak lance (100)
INSERT INTO necro_weapon_characteristic VALUES (158, 100, 'primed',                          'E', '2"',  '+1', '-',  '6',   '-2', '3', '-',  0, 1, 'E',   4);
INSERT INTO necro_weapon_characteristic VALUES (159, 100, 'spent',                           'E', '2"',  '+1', '-',  'S',   '-',  '1', '-',  0, 1, 'E',   4);
-- Paired augmetic fists (101)
INSERT INTO necro_weapon_characteristic VALUES (160, 101, 'Standard',                        'E', '-',   '-',  '-',  'S+1', '-1', '2', '-',  0, 1, 'E',   NULL);
-- Paired butcher's chain cleaver (102)
INSERT INTO necro_weapon_characteristic VALUES (161, 102, 'Standard',                        'E', '-',   '-',  '-',  'S+1', '-2', '2', '-',  0, 1, 'E',   10);
-- Paired heavy chain cleavers (103)
INSERT INTO necro_weapon_characteristic VALUES (162, 103, 'Standard',                        'E', '-',   '-',  '+1', 'S+2', '-2', '2', '-',  0, 1, 'E',   10);
-- Paired psychomantic claws (104)
INSERT INTO necro_weapon_characteristic VALUES (163, 104, 'Standard',                        'E', '3"',  '-',  '-',  'S+1', '*',  '1', '-',  0, 1, 'E',   5);
-- Paired 'Pulverizers' (105)
INSERT INTO necro_weapon_characteristic VALUES (164, 105, 'Standard',                        'E', '-',   '-',  '-',  'S+1', '-1', '1', '-',  0, 1, 'E',   3);
-- Paired spud-jackers (106)
INSERT INTO necro_weapon_characteristic VALUES (165, 106, 'Standard',                        'E', '-',   '-',  '-',  'S+1', '-',  '1', '-',  0, 1, 'E',   3);
-- 'Pulverizer' Serrated Axe (107)
INSERT INTO necro_weapon_characteristic VALUES (166, 107, 'Standard',                        'E', '-',   '-',  '-',  'S+1', '-1', '1', '-',  0, 1, 'E',   3);
-- Riot shield (108)
INSERT INTO necro_weapon_characteristic VALUES (167, 108, 'Standard',                        'E', '-',   '-',  '-1', 'S',   '-',  '1', '-',  0, 1, 'E',   9);
-- 'Renderizer' Serrated Axe (109)
INSERT INTO necro_weapon_characteristic VALUES (168, 109, 'Standard',                        'E', '-',   '-',  '-',  'S+2', '-1', '2', '-',  0, 1, 'E',   3);
-- Rock saw (110)
INSERT INTO necro_weapon_characteristic VALUES (169, 110, 'Standard',                        'E', '-',   '-',  '-',  'S+1', '-1', '2', '-',  0, 1, 'E',   7);
-- Rotary flensing saw (111)
INSERT INTO necro_weapon_characteristic VALUES (170, 111, 'Standard',                        'E', '4"',  '-',  '-1', 'S+1', '-2', '2', '-',  0, 1, 'E',   10);
-- Serpent's Fangs (112)
INSERT INTO necro_weapon_characteristic VALUES (171, 112, 'Standard',                        'E', '-',   '-',  '-',  'S+2', '*',  '1', '-',  0, 1, 'E',   5);
-- Shock whip (113)
INSERT INTO necro_weapon_characteristic VALUES (172, 113, 'Standard',                        'E', '3"',  '-1', '-',  'S+1', '-',  '1', '-',  0, 1, 'E',   2);
-- Shivver sword (114)
INSERT INTO necro_weapon_characteristic VALUES (173, 114, 'Standard',                        'E', '-',   '-',  '+1', 'S+1', '-1', '1', '-',  0, 1, 'E',   5);
-- Spider-rig (115)
INSERT INTO necro_weapon_characteristic VALUES (174, 115, 'Standard',                        'E', '3"',  '+1', '+1', 'S+1', '-1', '1', '-',  0, 1, 'E',   6);
-- Spud-jacker (116)
INSERT INTO necro_weapon_characteristic VALUES (175, 116, 'Standard',                        'E', '-',   '-',  '-',  'S+1', '-',  '1', '-',  0, 1, 'E',   3);
-- Stun lance (117)
INSERT INTO necro_weapon_characteristic VALUES (176, 117, 'primed',                          'E', '2"',  '+1', '-',  '2',   '-1', '1', '-',  0, 1, 'E',   4);
INSERT INTO necro_weapon_characteristic VALUES (177, 117, 'spent',                           'E', '2"',  '+1', '-',  'S',   '-',  '1', '-',  0, 1, 'E',   4);
-- Two-handed chainaxe (118)
INSERT INTO necro_weapon_characteristic VALUES (178, 118, 'Standard',                        'E', '-',   '-',  '-',  'S+2', '-1', '2', '-',  0, 1, 'E',   7);
-- Two-handed power axe (119)
INSERT INTO necro_weapon_characteristic VALUES (179, 119, 'Standard',                        'E', '2"',  '-',  '-1', 'S+2', '-1', '2', '-',  0, 1, 'E',   7);
-- Two-handed power pick (120)
INSERT INTO necro_weapon_characteristic VALUES (180, 120, 'Standard',                        'E', '2"',  '-',  '-1', 'S+1', '-3', '2', '-',  0, 1, 'E',   7);
-- Venom claw (121)
INSERT INTO necro_weapon_characteristic VALUES (181, 121, 'Standard',                        'E', '-',   '-',  '-',  '-',   '-2', '-', '-',  0, 1, 'E',   2);
-- Vigilance pattern assault shield (122)
INSERT INTO necro_weapon_characteristic VALUES (182, 122, 'Standard',                        'E', '-',   '-',  '-',  'S',   '-',  '1', '-',  0, 1, 'E',   9);
-- Web gauntlet (123)
INSERT INTO necro_weapon_characteristic VALUES (183, 123, 'Standard',                        'E', '-',   '-',  '+1', '3',   '-',  '-', '-',  0, 1, 'E',   5);

-- ============================================================
-- CLOSE COMBAT WEAPONS: Trait-characteristic mappings
-- ============================================================

-- char 97: Power knife → Backstab, Melee, Power
INSERT INTO necro_weapon_trait_characteristic_map SELECT 97,  id FROM necro_lookups WHERE lookup_value = 'Backstab'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 97,  id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 97,  id FROM necro_lookups WHERE lookup_value = 'Power'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 98: Axe → Disarm, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 98,  id FROM necro_lookups WHERE lookup_value = 'Disarm'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 98,  id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 99: Chainaxe → Disarm, Melee, Parry, Rending
INSERT INTO necro_weapon_trait_characteristic_map SELECT 99,  id FROM necro_lookups WHERE lookup_value = 'Disarm'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 99,  id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 99,  id FROM necro_lookups WHERE lookup_value = 'Parry'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 99,  id FROM necro_lookups WHERE lookup_value = 'Rending'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 100: Cleaver → Disarm, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 100, id FROM necro_lookups WHERE lookup_value = 'Disarm'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 100, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 101: Digi laser → Digi, Melee, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 101, id FROM necro_lookups WHERE lookup_value = 'Digi'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 101, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 101, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 102: Flail → Entangle, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 102, id FROM necro_lookups WHERE lookup_value = 'Entangle'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 102, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 103: Goredrinker axe → Esoteric, Melee, Reckless, Rending
INSERT INTO necro_weapon_trait_characteristic_map SELECT 103, id FROM necro_lookups WHERE lookup_value = 'Esoteric'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 103, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 103, id FROM necro_lookups WHERE lookup_value = 'Reckless'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 103, id FROM necro_lookups WHERE lookup_value = 'Rending'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 104: Heavy club → Concussion, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 104, id FROM necro_lookups WHERE lookup_value = 'Concussion' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 104, id FROM necro_lookups WHERE lookup_value = 'Melee'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 105: Hex'iron Blade → Cursed, Esoteric, Melee, Parry
INSERT INTO necro_weapon_trait_characteristic_map SELECT 105, id FROM necro_lookups WHERE lookup_value = 'Cursed'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 105, id FROM necro_lookups WHERE lookup_value = 'Esoteric'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 105, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 105, id FROM necro_lookups WHERE lookup_value = 'Parry'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 106: Maul (Club) → Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 106, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 107: Servo claw → Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 107, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 108: Sword → Melee, Parry
INSERT INTO necro_weapon_trait_characteristic_map SELECT 108, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 108, id FROM necro_lookups WHERE lookup_value = 'Parry'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 109: Whip → Entangle, Melee, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 109, id FROM necro_lookups WHERE lookup_value = 'Entangle'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 109, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 109, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 110: Whisperbane knife → Backstab, Esoteric, Melee, Scattershot
INSERT INTO necro_weapon_trait_characteristic_map SELECT 110, id FROM necro_lookups WHERE lookup_value = 'Backstab'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 110, id FROM necro_lookups WHERE lookup_value = 'Esoteric'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 110, id FROM necro_lookups WHERE lookup_value = 'Melee'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 110, id FROM necro_lookups WHERE lookup_value = 'Scattershot' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 111: Xenarch Death-arc → Esoteric, Melee, Plentiful, Rapid Fire (2), Shock, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 111, id FROM necro_lookups WHERE lookup_value = 'Esoteric'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 111, id FROM necro_lookups WHERE lookup_value = 'Melee'          AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 111, id FROM necro_lookups WHERE lookup_value = 'Plentiful'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 111, id FROM necro_lookups WHERE lookup_value = 'Rapid Fire (2)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 111, id FROM necro_lookups WHERE lookup_value = 'Shock'          AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 111, id FROM necro_lookups WHERE lookup_value = 'Versatile'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 112: Desire's Needle → Chem Delivery, Esoteric, Melee, Power, Toxin
INSERT INTO necro_weapon_trait_characteristic_map SELECT 112, id FROM necro_lookups WHERE lookup_value = 'Chem Delivery' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 112, id FROM necro_lookups WHERE lookup_value = 'Esoteric'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 112, id FROM necro_lookups WHERE lookup_value = 'Melee'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 112, id FROM necro_lookups WHERE lookup_value = 'Power'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 112, id FROM necro_lookups WHERE lookup_value = 'Toxin'         AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 113: Las cutter → Melee, Scarce, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 113, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 113, id FROM necro_lookups WHERE lookup_value = 'Scarce'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 113, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 114: Lightning claw → Melee, Parry, Power, Rending
INSERT INTO necro_weapon_trait_characteristic_map SELECT 114, id FROM necro_lookups WHERE lookup_value = 'Melee'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 114, id FROM necro_lookups WHERE lookup_value = 'Parry'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 114, id FROM necro_lookups WHERE lookup_value = 'Power'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 114, id FROM necro_lookups WHERE lookup_value = 'Rending' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 115: Power axe → Disarm, Melee, Power
INSERT INTO necro_weapon_trait_characteristic_map SELECT 115, id FROM necro_lookups WHERE lookup_value = 'Disarm' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 115, id FROM necro_lookups WHERE lookup_value = 'Melee'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 115, id FROM necro_lookups WHERE lookup_value = 'Power'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 116: Power claw → Melee, Power, Pulverise
INSERT INTO necro_weapon_trait_characteristic_map SELECT 116, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 116, id FROM necro_lookups WHERE lookup_value = 'Power'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 116, id FROM necro_lookups WHERE lookup_value = 'Pulverise' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 117: Power fist → Melee, Power, Pulverise, Unwieldy
INSERT INTO necro_weapon_trait_characteristic_map SELECT 117, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 117, id FROM necro_lookups WHERE lookup_value = 'Power'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 117, id FROM necro_lookups WHERE lookup_value = 'Pulverise' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 117, id FROM necro_lookups WHERE lookup_value = 'Unwieldy' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 118: Power hammer → Melee, Power
INSERT INTO necro_weapon_trait_characteristic_map SELECT 118, id FROM necro_lookups WHERE lookup_value = 'Melee' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 118, id FROM necro_lookups WHERE lookup_value = 'Power' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 119: Power maul → Melee, Power
INSERT INTO necro_weapon_trait_characteristic_map SELECT 119, id FROM necro_lookups WHERE lookup_value = 'Melee' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 119, id FROM necro_lookups WHERE lookup_value = 'Power' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 120: Power pick → Melee, Power, Pulverise
INSERT INTO necro_weapon_trait_characteristic_map SELECT 120, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 120, id FROM necro_lookups WHERE lookup_value = 'Power'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 120, id FROM necro_lookups WHERE lookup_value = 'Pulverise' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 121: Power sword → Melee, Parry, Power
INSERT INTO necro_weapon_trait_characteristic_map SELECT 121, id FROM necro_lookups WHERE lookup_value = 'Melee' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 121, id FROM necro_lookups WHERE lookup_value = 'Parry' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 121, id FROM necro_lookups WHERE lookup_value = 'Power' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 122: Shock baton → Melee, Parry, Shock
INSERT INTO necro_weapon_trait_characteristic_map SELECT 122, id FROM necro_lookups WHERE lookup_value = 'Melee' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 122, id FROM necro_lookups WHERE lookup_value = 'Parry' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 122, id FROM necro_lookups WHERE lookup_value = 'Shock' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 123: Shock stave → Melee, Shock, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 123, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 123, id FROM necro_lookups WHERE lookup_value = 'Shock'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 123, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 124: Tenebrous Scourge → Entangle, Esoteric, Melee, Power, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 124, id FROM necro_lookups WHERE lookup_value = 'Entangle'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 124, id FROM necro_lookups WHERE lookup_value = 'Esoteric'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 124, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 124, id FROM necro_lookups WHERE lookup_value = 'Power'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 124, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 125: Thunder hammer → Melee, Power, Shock
INSERT INTO necro_weapon_trait_characteristic_map SELECT 125, id FROM necro_lookups WHERE lookup_value = 'Melee' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 125, id FROM necro_lookups WHERE lookup_value = 'Power' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 125, id FROM necro_lookups WHERE lookup_value = 'Shock' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 126: Chain glaive → Melee, Unwieldy, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 126, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 126, id FROM necro_lookups WHERE lookup_value = 'Unwieldy'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 126, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 127: Greatsword → Melee, Sever, Unwieldy, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 127, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 127, id FROM necro_lookups WHERE lookup_value = 'Sever'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 127, id FROM necro_lookups WHERE lookup_value = 'Unwieldy'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 127, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 128: Heavy rock cutter → Melee, Unwieldy
INSERT INTO necro_weapon_trait_characteristic_map SELECT 128, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 128, id FROM necro_lookups WHERE lookup_value = 'Unwieldy' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 129: Heavy rock drill → Melee, Pulverise, Unwieldy
INSERT INTO necro_weapon_trait_characteristic_map SELECT 129, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 129, id FROM necro_lookups WHERE lookup_value = 'Pulverise' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 129, id FROM necro_lookups WHERE lookup_value = 'Unwieldy' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 130: Heavy rock saw → Melee, Rending, Unwieldy
INSERT INTO necro_weapon_trait_characteristic_map SELECT 130, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 130, id FROM necro_lookups WHERE lookup_value = 'Rending'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 130, id FROM necro_lookups WHERE lookup_value = 'Unwieldy' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 131: Polearm → Melee, Unwieldy, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 131, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 131, id FROM necro_lookups WHERE lookup_value = 'Unwieldy'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 131, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 132: Two-handed axe → Melee, Unwieldy
INSERT INTO necro_weapon_trait_characteristic_map SELECT 132, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 132, id FROM necro_lookups WHERE lookup_value = 'Unwieldy' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 133: Two-handed hammer → Knockback, Melee, Unwieldy
INSERT INTO necro_weapon_trait_characteristic_map SELECT 133, id FROM necro_lookups WHERE lookup_value = 'Knockback' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 133, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 133, id FROM necro_lookups WHERE lookup_value = 'Unwieldy'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 134: Araneus-pattern power fist → Melee, Power, Pulverise
INSERT INTO necro_weapon_trait_characteristic_map SELECT 134, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 134, id FROM necro_lookups WHERE lookup_value = 'Power'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 134, id FROM necro_lookups WHERE lookup_value = 'Pulverise' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 135: Arc hammer → Melee, Pulverise, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 135, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 135, id FROM necro_lookups WHERE lookup_value = 'Pulverise' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 135, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 136: Arc welder → Blaze, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 136, id FROM necro_lookups WHERE lookup_value = 'Blaze' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 136, id FROM necro_lookups WHERE lookup_value = 'Melee' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 137: Augmetic fist → Knockback, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 137, id FROM necro_lookups WHERE lookup_value = 'Knockback' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 137, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 138: Barbed flabellum → Melee, Toxin, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 138, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 138, id FROM necro_lookups WHERE lookup_value = 'Toxin'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 138, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 139: The Bloodfingers → Melee, Power, Pulverise, Whispering
INSERT INTO necro_weapon_trait_characteristic_map SELECT 139, id FROM necro_lookups WHERE lookup_value = 'Melee'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 139, id FROM necro_lookups WHERE lookup_value = 'Power'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 139, id FROM necro_lookups WHERE lookup_value = 'Pulverise'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 139, id FROM necro_lookups WHERE lookup_value = 'Whispering' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 140: Boning sword → Melee, Parry, Rending
INSERT INTO necro_weapon_trait_characteristic_map SELECT 140, id FROM necro_lookups WHERE lookup_value = 'Melee'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 140, id FROM necro_lookups WHERE lookup_value = 'Parry'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 140, id FROM necro_lookups WHERE lookup_value = 'Rending' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 141: Brute cleaver → Disarm, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 141, id FROM necro_lookups WHERE lookup_value = 'Disarm' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 141, id FROM necro_lookups WHERE lookup_value = 'Melee'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 142: Butcher's chain cleaver → Melee, Shred
INSERT INTO necro_weapon_trait_characteristic_map SELECT 142, id FROM necro_lookups WHERE lookup_value = 'Melee' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 142, id FROM necro_lookups WHERE lookup_value = 'Shred' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 143: Butcher's cleaver → Disarm, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 143, id FROM necro_lookups WHERE lookup_value = 'Disarm' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 143, id FROM necro_lookups WHERE lookup_value = 'Melee'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 144: Drawn-out Death → Melee, Unwieldy, Versatile, Whispering
INSERT INTO necro_weapon_trait_characteristic_map SELECT 144, id FROM necro_lookups WHERE lookup_value = 'Melee'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 144, id FROM necro_lookups WHERE lookup_value = 'Unwieldy'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 144, id FROM necro_lookups WHERE lookup_value = 'Versatile'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 144, id FROM necro_lookups WHERE lookup_value = 'Whispering' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 145: Eviscerator melee → Melee, Sever, Shred, Unwieldy, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 145, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 145, id FROM necro_lookups WHERE lookup_value = 'Sever'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 145, id FROM necro_lookups WHERE lookup_value = 'Shred'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 145, id FROM necro_lookups WHERE lookup_value = 'Unwieldy' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 145, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 146: Eviscerator ranged → Blaze, Scarce, Template
INSERT INTO necro_weapon_trait_characteristic_map SELECT 146, id FROM necro_lookups WHERE lookup_value = 'Blaze'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 146, id FROM necro_lookups WHERE lookup_value = 'Scarce'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 146, id FROM necro_lookups WHERE lookup_value = 'Template' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 147: Excavator hammer → Melee, Pulverise, Unwieldy, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 147, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 147, id FROM necro_lookups WHERE lookup_value = 'Pulverise' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 147, id FROM necro_lookups WHERE lookup_value = 'Unwieldy' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 147, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 148: Flensing knife → Melee, Rending
INSERT INTO necro_weapon_trait_characteristic_map SELECT 148, id FROM necro_lookups WHERE lookup_value = 'Melee'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 148, id FROM necro_lookups WHERE lookup_value = 'Rending' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 149: Frag lance primed → Blast (*), Knockback, Lance-bomb, Melee, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 149, id FROM necro_lookups WHERE lookup_value = 'Blast (*)' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 149, id FROM necro_lookups WHERE lookup_value = 'Knockback' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 149, id FROM necro_lookups WHERE lookup_value = 'Lance-bomb' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 149, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 149, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 150: Frag lance spent → Lance, Melee, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 150, id FROM necro_lookups WHERE lookup_value = 'Lance'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 150, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 150, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 151: Gleeful Judgement → Melee, Power, Whispering
INSERT INTO necro_weapon_trait_characteristic_map SELECT 151, id FROM necro_lookups WHERE lookup_value = 'Melee'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 151, id FROM necro_lookups WHERE lookup_value = 'Power'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 151, id FROM necro_lookups WHERE lookup_value = 'Whispering' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 152: Haemophagic Blade → Haemophagic, Melee, Toxin
INSERT INTO necro_weapon_trait_characteristic_map SELECT 152, id FROM necro_lookups WHERE lookup_value = 'Haemophagic' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 152, id FROM necro_lookups WHERE lookup_value = 'Melee'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 152, id FROM necro_lookups WHERE lookup_value = 'Toxin'       AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 153: Heavy chain cleaver → Melee, Sever
INSERT INTO necro_weapon_trait_characteristic_map SELECT 153, id FROM necro_lookups WHERE lookup_value = 'Melee' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 153, id FROM necro_lookups WHERE lookup_value = 'Sever' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 154: Heavy drill → Melee, Rending
INSERT INTO necro_weapon_trait_characteristic_map SELECT 154, id FROM necro_lookups WHERE lookup_value = 'Melee'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 154, id FROM necro_lookups WHERE lookup_value = 'Rending' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 155: Hydraulic drill → Entangle, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 155, id FROM necro_lookups WHERE lookup_value = 'Entangle' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 155, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 156: 'Hystrar' pattern energy shield → Assault Shield, Knockback, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 156, id FROM necro_lookups WHERE lookup_value = 'Assault Shield' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 156, id FROM necro_lookups WHERE lookup_value = 'Knockback'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 156, id FROM necro_lookups WHERE lookup_value = 'Melee'          AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 157: Ironhead power fist → Melee, Power, Pulverise
INSERT INTO necro_weapon_trait_characteristic_map SELECT 157, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 157, id FROM necro_lookups WHERE lookup_value = 'Power'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 157, id FROM necro_lookups WHERE lookup_value = 'Pulverise' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 158: Krak lance primed → Lance-bomb, Melee, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 158, id FROM necro_lookups WHERE lookup_value = 'Lance-bomb' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 158, id FROM necro_lookups WHERE lookup_value = 'Melee'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 158, id FROM necro_lookups WHERE lookup_value = 'Versatile'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 159: Krak lance spent → Lance, Melee, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 159, id FROM necro_lookups WHERE lookup_value = 'Lance'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 159, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 159, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 160: Paired augmetic fists → Knockback, Melee, Paired
INSERT INTO necro_weapon_trait_characteristic_map SELECT 160, id FROM necro_lookups WHERE lookup_value = 'Knockback' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 160, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 160, id FROM necro_lookups WHERE lookup_value = 'Paired'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 161: Paired butcher's chain cleaver → Melee, Paired, Shred
INSERT INTO necro_weapon_trait_characteristic_map SELECT 161, id FROM necro_lookups WHERE lookup_value = 'Melee'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 161, id FROM necro_lookups WHERE lookup_value = 'Paired' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 161, id FROM necro_lookups WHERE lookup_value = 'Shred'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 162: Paired heavy chain cleavers → Melee, Paired, Sever
INSERT INTO necro_weapon_trait_characteristic_map SELECT 162, id FROM necro_lookups WHERE lookup_value = 'Melee'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 162, id FROM necro_lookups WHERE lookup_value = 'Paired' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 162, id FROM necro_lookups WHERE lookup_value = 'Sever'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 163: Paired psychomantic claws → Melee, Paired, Phase, Shock, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 163, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 163, id FROM necro_lookups WHERE lookup_value = 'Paired'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 163, id FROM necro_lookups WHERE lookup_value = 'Phase'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 163, id FROM necro_lookups WHERE lookup_value = 'Shock'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 163, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 164: Paired 'Pulverizers' → Melee, Paired, Pulverise
INSERT INTO necro_weapon_trait_characteristic_map SELECT 164, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 164, id FROM necro_lookups WHERE lookup_value = 'Paired'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 164, id FROM necro_lookups WHERE lookup_value = 'Pulverise' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 165: Paired spud-jackers → Knockback, Melee, Paired
INSERT INTO necro_weapon_trait_characteristic_map SELECT 165, id FROM necro_lookups WHERE lookup_value = 'Knockback' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 165, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 165, id FROM necro_lookups WHERE lookup_value = 'Paired'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 166: 'Pulverizer' Serrated Axe → Melee, Pulverise
INSERT INTO necro_weapon_trait_characteristic_map SELECT 166, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 166, id FROM necro_lookups WHERE lookup_value = 'Pulverise' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 167: Riot shield → Assault Shield, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 167, id FROM necro_lookups WHERE lookup_value = 'Assault Shield' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 167, id FROM necro_lookups WHERE lookup_value = 'Melee'          AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 168: 'Renderizer' Serrated Axe → Melee, Pulverise, Unwieldy
INSERT INTO necro_weapon_trait_characteristic_map SELECT 168, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 168, id FROM necro_lookups WHERE lookup_value = 'Pulverise' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 168, id FROM necro_lookups WHERE lookup_value = 'Unwieldy'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 169: Rock saw → Melee, Rending
INSERT INTO necro_weapon_trait_characteristic_map SELECT 169, id FROM necro_lookups WHERE lookup_value = 'Melee'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 169, id FROM necro_lookups WHERE lookup_value = 'Rending' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 170: Rotary flensing saw → Knockback, Melee, Shred, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 170, id FROM necro_lookups WHERE lookup_value = 'Knockback' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 170, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 170, id FROM necro_lookups WHERE lookup_value = 'Shred'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 170, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 171: Serpent's Fangs → Melee, Paired, Phase, Rending
INSERT INTO necro_weapon_trait_characteristic_map SELECT 171, id FROM necro_lookups WHERE lookup_value = 'Melee'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 171, id FROM necro_lookups WHERE lookup_value = 'Paired'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 171, id FROM necro_lookups WHERE lookup_value = 'Phase'   AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 171, id FROM necro_lookups WHERE lookup_value = 'Rending' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 172: Shock whip → Melee, Shock, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 172, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 172, id FROM necro_lookups WHERE lookup_value = 'Shock'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 172, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 173: Shivver sword → Melee, Parry, Power, Sever
INSERT INTO necro_weapon_trait_characteristic_map SELECT 173, id FROM necro_lookups WHERE lookup_value = 'Melee' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 173, id FROM necro_lookups WHERE lookup_value = 'Parry' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 173, id FROM necro_lookups WHERE lookup_value = 'Power' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 173, id FROM necro_lookups WHERE lookup_value = 'Sever' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 174: Spider-rig → Entangle, Melee, Paired, Parry, Shock, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 174, id FROM necro_lookups WHERE lookup_value = 'Entangle'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 174, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 174, id FROM necro_lookups WHERE lookup_value = 'Paired'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 174, id FROM necro_lookups WHERE lookup_value = 'Parry'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 174, id FROM necro_lookups WHERE lookup_value = 'Shock'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 174, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 175: Spud-jacker → Knockback, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 175, id FROM necro_lookups WHERE lookup_value = 'Knockback' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 175, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 176: Stun lance primed → Blast (*), Concussion, Lance-bomb, Melee, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 176, id FROM necro_lookups WHERE lookup_value = 'Blast (*)'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 176, id FROM necro_lookups WHERE lookup_value = 'Concussion' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 176, id FROM necro_lookups WHERE lookup_value = 'Lance-bomb' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 176, id FROM necro_lookups WHERE lookup_value = 'Melee'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 176, id FROM necro_lookups WHERE lookup_value = 'Versatile'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 177: Stun lance spent → Lance, Melee, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 177, id FROM necro_lookups WHERE lookup_value = 'Lance'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 177, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 177, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 178: Two-handed chainaxe → Melee, Rending, Unwieldy
INSERT INTO necro_weapon_trait_characteristic_map SELECT 178, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 178, id FROM necro_lookups WHERE lookup_value = 'Rending'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 178, id FROM necro_lookups WHERE lookup_value = 'Unwieldy' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 179: Two-handed power axe → Disarm, Melee, Power, Unwieldy, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 179, id FROM necro_lookups WHERE lookup_value = 'Disarm'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 179, id FROM necro_lookups WHERE lookup_value = 'Melee'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 179, id FROM necro_lookups WHERE lookup_value = 'Power'     AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 179, id FROM necro_lookups WHERE lookup_value = 'Unwieldy'  AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 179, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 180: Two-handed power pick → Melee, Power, Pulverise, Unwieldy, Versatile
INSERT INTO necro_weapon_trait_characteristic_map SELECT 180, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 180, id FROM necro_lookups WHERE lookup_value = 'Power'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 180, id FROM necro_lookups WHERE lookup_value = 'Pulverise' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 180, id FROM necro_lookups WHERE lookup_value = 'Unwieldy' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 180, id FROM necro_lookups WHERE lookup_value = 'Versatile' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 181: Venom claw → Entangle, Melee, Toxin
INSERT INTO necro_weapon_trait_characteristic_map SELECT 181, id FROM necro_lookups WHERE lookup_value = 'Entangle' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 181, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 181, id FROM necro_lookups WHERE lookup_value = 'Toxin'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 182: Vigilance pattern assault shield → Assault Shield, Knockback, Melee
INSERT INTO necro_weapon_trait_characteristic_map SELECT 182, id FROM necro_lookups WHERE lookup_value = 'Assault Shield' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 182, id FROM necro_lookups WHERE lookup_value = 'Knockback'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 182, id FROM necro_lookups WHERE lookup_value = 'Melee'          AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
-- char 183: Web gauntlet → Backstab, Melee, Web
INSERT INTO necro_weapon_trait_characteristic_map SELECT 183, id FROM necro_lookups WHERE lookup_value = 'Backstab' AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 183, id FROM necro_lookups WHERE lookup_value = 'Melee'    AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;
INSERT INTO necro_weapon_trait_characteristic_map SELECT 183, id FROM necro_lookups WHERE lookup_value = 'Web'      AND lookup_key = 'WEAPON_TRAIT' LIMIT 1;