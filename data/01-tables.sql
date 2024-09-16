DROP TABLE IF EXISTS necro_user;
CREATE TABLE necro_user (
	id INT NOT NULL AUTO_INCREMENT,
	username VARCHAR(100) NOT NULL,
	userpassword VARCHAR(255) NOT NULL,
	email_address VARCHAR(255) NOT NULL,
	confirmed TINYINT NOT NULL DEFAULT '0',
	registered DATETIME NOT NULL,
	last_login DATETIME NOT NULL,
	is_admin TINYINT NOT NULL DEFAULT '0',
	oauth_key VARCHAR(255),
	PRIMARY KEY (id),
	INDEX idx_user_username (username)
);
INSERT INTO necro_user VALUES (0, 'admin', '$2y$10$Q/H/OASzzpCTCBLNpjKiHeXyrJYQMiegm16MBMD98sc4W0CIgxo/u', 'admin@admin.com', 1, NOW(), NOW(), 1, NULL);

DROP TABLE IF EXISTS necro_gang_type;
CREATE TABLE necro_gang_type (
	id INT NOT NULL AUTO_INCREMENT,
	type_name VARCHAR(255) NOT NULL,
	house_gang TINYINT NOT NULL DEFAULT '1',
	PRIMARY KEY (id)
);
INSERT INTO necro_gang_type VALUES (1, 'Orlock', 1);
INSERT INTO necro_gang_type VALUES (2, 'Escher', 1);
INSERT INTO necro_gang_type VALUES (3, 'Goliath', 1);
INSERT INTO necro_gang_type VALUES (4, 'Cawdor', 1);
INSERT INTO necro_gang_type VALUES (5, 'Delaque', 1);
INSERT INTO necro_gang_type VALUES (6, 'Van Saar', 1);
INSERT INTO necro_gang_type VALUES (7, 'Ironhead Squat', 0);
INSERT INTO necro_gang_type VALUES (8, 'Ash Waste Nomad', 0);
INSERT INTO necro_gang_type VALUES (9, 'Enforcer', 0);
INSERT INTO necro_gang_type VALUES (10, 'Corpse Grinder', 0);

DROP TABLE IF EXISTS necro_gang;
CREATE TABLE necro_gang (
	id INT NOT NULL AUTO_INCREMENT,
	user_id INT NOT NULL,
	gang_name VARCHAR(255) NOT NULL,
	gang_type_id INT NOT NULL,
	outlaw TINYINT NOT NULL DEFAULT '0',
	created DATETIME NOT NULL,
	last_mod DATETIME NOT NULL,
	PRIMARY KEY (id),
	INDEX idx_gang_user (user_id)
);

INSERT INTO necro_gang VALUES (1, 1, 'The Bad Asses', 1, 0, NOW(), NOW());
INSERT INTO necro_gang VALUES (2, 1, 'Not Your Mamas', 2, 0, NOW(), NOW());

DROP TABLE IF EXISTS necro_fighter;
CREATE TABLE necro_fighter (
	id INT NOT NULL AUTO_INCREMENT,
	gang_id INT NOT NULL,
	fighter_name VARCHAR(255) NOT NULL,
	heirarchy_role ENUM('leader', 'champion', 'fighter', 'prospect', 'juve', 'brute', 'hanger-on', 'pet'),
	backstory TEXT,
	movement TINYINT NOT NULL,
	weapon_skill TINYINT NOT NULL,
	balistic_skill TINYINT NOT NULL,
	strength TINYINT NOT NULL,
	toughness TINYINT NOT NULL,
	toughness_side TINYINT NOT NULL,
	toughness_rear TINYINT NOT NULL,
	wounds TINYINT NOT NULL,
	initiative TINYINT NOT NULL,
	attacks TINYINT NOT NULL,
	handling TINYINT NOT NULL,
	save_roll TINYINT NOT NULL,
	leadership TINYINT NOT NULL,
	cool TINYINT NOT NULL,
	willpower TINYINT NOT NULL,
	intelligence TINYINT NOT NULL,
	is_vehicle TINYINT NOT NULL,
	is_convalescence TINYINT NOT NULL,
	is_captured TINYINT NOT NULL,
	is_dramatis TINYINT NOT NULL,
	experience TINYINT NOT NULL,
	advancements TINYINT NOT NULL,
	base_value INT NOT NULL,
	view_order TINYINT NOT NULL DEFAULT '0',
	created DATETIME NOT NULL,
	PRIMARY KEY (id),
	INDEX idx_fighter_gang (gang_id)
);
INSERT INTO necro_fighter VALUES(1, 1, 'Joe Blow', 'leader', NULL, '5', '3', '3', '3', '3', '0', '0', '2', '4', '2', 0, 0, '7', '8', '8', '8', 0, 0, 0, 0, 6, 2, 125, 1, NOW());
INSERT INTO necro_fighter VALUES(2, 1, 'Jill Jones', 'champion', NULL, '5', '4', '3', '3', '3', '0', '0', '2', '4', '2', 0, 0, '8', '8', '8', '8', 0, 0, 0, 0, 4, 1, 115, 1, NOW());

DROP TABLE IF EXISTS necro_weapon_category;
CREATE TABLE necro_weapon_category (
	id INT NOT NULL AUTO_INCREMENT,
	category_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (id)
);
INSERT INTO necro_weapon_category VALUES(1, 'Pistols');
INSERT INTO necro_weapon_category VALUES(2, 'Basic Weapons');
INSERT INTO necro_weapon_category VALUES(3, 'Special Weapons');
INSERT INTO necro_weapon_category VALUES(4, 'Heavy Weapons');
INSERT INTO necro_weapon_category VALUES(5, 'Close Combat');
INSERT INTO necro_weapon_category VALUES(6, 'Grenades');
INSERT INTO necro_weapon_category VALUES(7, 'Booby Traps');
INSERT INTO necro_weapon_category VALUES(8, 'Others');

DROP TABLE IF EXISTS necro_weapon;
CREATE TABLE necro_weapon (
	id INT NOT NULL AUTO_INCREMENT,
	weapon_category_id INT NOT NULL,
	weapon_name VARCHAR(255) NOT NULL,
	weapon_value INT NOT NULL,
	rarity VARCHAR(10),
	PRIMARY KEY (id)
);
INSERT INTO necro_weapon VALUES (1, 2, 'Boltgun', 55, 'R8');
INSERT INTO necro_weapon VALUES (2, 1, 'Autopistol', 10, 'C');
INSERT INTO necro_weapon VALUES (3, 5, 'Knife', 15, 'C');
INSERT INTO necro_weapon VALUES (4, 5, 'Stilleto Knife', 20, 'R9');
INSERT INTO necro_weapon VALUES (5, 5, 'Stilleto Sword', 35, 'R9');
INSERT INTO necro_weapon VALUES (6, 5, 'Chain Sword', 25, 'R8');
INSERT INTO necro_weapon VALUES (7, 3, 'Escher Pattern Combi-', 180, 'R8');

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
	PRIMARY KEY (id)
);
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (1, 'Rapid Fire (1)');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (2, 'Backstab');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (3, 'Toxin');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (4, 'Parry');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (5, 'Rending');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (6, 'Combi');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (7, 'Blaze');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (8, 'Template');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (9, 'Unstable');

DROP TABLE IF EXISTS necro_fighter_skill_set;
CREATE TABLE necro_fighter_skill_set (
	id INT NOT NULL AUTO_INCREMENT,
	skill_set_name VARCHAR(255),
	limited_to_gang TINYINT NOT NULL DEFAULT '0',
	gang_type_id INT,
	PRIMARY KEY (id)
);
INSERT INTO necro_fighter_skill_set (id, skill_set_name) VALUES (1, 'Agility');
INSERT INTO necro_fighter_skill_set (id, skill_set_name) VALUES (2, 'Brawn');
INSERT INTO necro_fighter_skill_set (id, skill_set_name) VALUES (3, 'Combat');
INSERT INTO necro_fighter_skill_set (id, skill_set_name) VALUES (4, 'Cunning');
INSERT INTO necro_fighter_skill_set (id, skill_set_name) VALUES (5, 'Ferocity');
INSERT INTO necro_fighter_skill_set (id, skill_set_name) VALUES (6, 'Leadership');
INSERT INTO necro_fighter_skill_set (id, skill_set_name) VALUES (7, 'Savant');
INSERT INTO necro_fighter_skill_set (id, skill_set_name) VALUES (8, 'Shooting');
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (9, 'Muscle', 1, 3);
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (10, 'Finese', 1, 2);
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (11, 'Bravado', 1, 1);
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (12, 'Tech', 1, 6);
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (13, 'Piety', 1, 4);
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (14, 'Obfuscation', 1, 5);
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (15, 'Palatite Drill', 1, 9);
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (16, 'Savagery', 1, 10);
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (17, 'Wastelands', 1, 8);
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (18, 'Wisdom of the Ancients', 1, 7);
INSERT INTO necro_fighter_skill_set (id, skill_set_name) VALUES (19, 'Shooting');

DROP TABLE IF EXISTS necro_fighter_skill;
CREATE TABLE necro_fighter_skill (
	id INT NOT NULL AUTO_INCREMENT,
	skill_set_id INT NOT NULL,
	skill_name VARCHAR(255),
	PRIMARY KEY (id)
);
INSERT INTO necro_fighter_skill VALUES(1, 1, 'Catfall');
INSERT INTO necro_fighter_skill VALUES(2, 1, 'Clamber');
INSERT INTO necro_fighter_skill VALUES(3, 1, 'Dodge');
INSERT INTO necro_fighter_skill VALUES(4, 1, 'Mighty Leap');
INSERT INTO necro_fighter_skill VALUES(5, 1, 'Spring Up');
INSERT INTO necro_fighter_skill VALUES(6, 1, 'Sprint');
INSERT INTO necro_fighter_skill VALUES(7, 2, 'Bull Charge');
INSERT INTO necro_fighter_skill VALUES(8, 2, 'Bulging Biceps');
INSERT INTO necro_fighter_skill VALUES(9, 2, 'Crushing Blow');
INSERT INTO necro_fighter_skill VALUES(10, 2, 'Headbutt');
INSERT INTO necro_fighter_skill VALUES(11, 2, 'Hurl');
INSERT INTO necro_fighter_skill VALUES(12, 2, 'Iron Jaw');
INSERT INTO necro_fighter_skill VALUES(13, 3, 'Combat Master');
INSERT INTO necro_fighter_skill VALUES(14, 3, 'Counter-Attack');
INSERT INTO necro_fighter_skill VALUES(15, 3, 'Disarm');
INSERT INTO necro_fighter_skill VALUES(16, 3, 'Parry');
INSERT INTO necro_fighter_skill VALUES(17, 3, 'Rain of Blows');
INSERT INTO necro_fighter_skill VALUES(18, 3, 'Step Aside');
INSERT INTO necro_fighter_skill VALUES(19, 4, 'Backstab');
INSERT INTO necro_fighter_skill VALUES(20, 4, 'Escape Artist');
INSERT INTO necro_fighter_skill VALUES(21, 4, 'Evade');
INSERT INTO necro_fighter_skill VALUES(22, 4, 'Infiltrate');
INSERT INTO necro_fighter_skill VALUES(23, 4, 'Lie Low');
INSERT INTO necro_fighter_skill VALUES(24, 4, 'Overwatch');
INSERT INTO necro_fighter_skill VALUES(25, 19, 'Jink');
INSERT INTO necro_fighter_skill VALUES(26, 19, 'Expert Driver');
INSERT INTO necro_fighter_skill VALUES(27, 19, 'Heavy Foot');
INSERT INTO necro_fighter_skill VALUES(28, 19, 'Slalom');
INSERT INTO necro_fighter_skill VALUES(29, 19, 'T-Bone');
INSERT INTO necro_fighter_skill VALUES(30, 19, 'Running Repairs');
INSERT INTO necro_fighter_skill VALUES(31, 5, 'Beserker');
INSERT INTO necro_fighter_skill VALUES(32, 5, 'Fearsome');
INSERT INTO necro_fighter_skill VALUES(33, 5, 'Impetuous');
INSERT INTO necro_fighter_skill VALUES(34, 5, 'Nerves of Steel');
INSERT INTO necro_fighter_skill VALUES(35, 5, 'True Grit');
INSERT INTO necro_fighter_skill VALUES(36, 5, 'Unstoppable');
INSERT INTO necro_fighter_skill VALUES(37, 6, 'Commanding Presence');
INSERT INTO necro_fighter_skill VALUES(38, 6, 'Inspirational');
INSERT INTO necro_fighter_skill VALUES(39, 6, 'Iron Will');
INSERT INTO necro_fighter_skill VALUES(40, 6, 'Mentor');
INSERT INTO necro_fighter_skill VALUES(41, 6, 'Overseer');
INSERT INTO necro_fighter_skill VALUES(42, 6, 'Regroup');
INSERT INTO necro_fighter_skill VALUES(43, 7, 'Ballistics Expert');
INSERT INTO necro_fighter_skill VALUES(44, 7, 'Connected');
INSERT INTO necro_fighter_skill VALUES(45, 7, 'Fixer');
INSERT INTO necro_fighter_skill VALUES(46, 7, 'Medicae');
INSERT INTO necro_fighter_skill VALUES(47, 7, 'Munitioneer');
INSERT INTO necro_fighter_skill VALUES(48, 7, 'Savvy Trader');
INSERT INTO necro_fighter_skill VALUES(49, 8, 'Fast Shot');
INSERT INTO necro_fighter_skill VALUES(50, 8, 'Gunfighter');
INSERT INTO necro_fighter_skill VALUES(51, 8, 'Hip Shooting');
INSERT INTO necro_fighter_skill VALUES(52, 8, 'Marksman');
INSERT INTO necro_fighter_skill VALUES(53, 8, 'Precision Shot');
INSERT INTO necro_fighter_skill VALUES(54, 8, 'Trick Shot');
INSERT INTO necro_fighter_skill VALUES(55, 9, 'Fists of Steel');
INSERT INTO necro_fighter_skill VALUES(56, 9, 'Iron Man');
INSERT INTO necro_fighter_skill VALUES(57, 9, 'Immovable Stance');
INSERT INTO necro_fighter_skill VALUES(58, 9, 'Naargah!');
INSERT INTO necro_fighter_skill VALUES(59, 9, 'Unleash the Beast');
INSERT INTO necro_fighter_skill VALUES(60, 9, 'Walk It Off');
INSERT INTO necro_fighter_skill VALUES(61, 10, 'Acrobatic');
INSERT INTO necro_fighter_skill VALUES(62, 10, 'Combat Focus');
INSERT INTO necro_fighter_skill VALUES(63, 10, 'Combat Virtuoso');
INSERT INTO necro_fighter_skill VALUES(64, 10, 'Hit & Run');
INSERT INTO necro_fighter_skill VALUES(65, 10, 'Lighting Reflexes');
INSERT INTO necro_fighter_skill VALUES(66, 10, 'Somersault');
INSERT INTO necro_fighter_skill VALUES(67, 11, 'Big Brother');
INSERT INTO necro_fighter_skill VALUES(68, 11, 'Bring It On!');
INSERT INTO necro_fighter_skill VALUES(69, 11, 'Guilder Contacts');
INSERT INTO necro_fighter_skill VALUES(70, 11, 'King Hit');
INSERT INTO necro_fighter_skill VALUES(71, 11, 'Shotgun Savant');
INSERT INTO necro_fighter_skill VALUES(72, 11, 'Steady Hands');
INSERT INTO necro_fighter_skill VALUES(73, 12, 'Cold & Calculating');
INSERT INTO necro_fighter_skill VALUES(74, 12, 'Gadgetert');
INSERT INTO necro_fighter_skill VALUES(75, 12, 'Mental Mastery');
INSERT INTO necro_fighter_skill VALUES(76, 12, 'Photonic Engineer');
INSERT INTO necro_fighter_skill VALUES(77, 12, 'Rad-Phaged');
INSERT INTO necro_fighter_skill VALUES(78, 12, 'Weaponsmith');
INSERT INTO necro_fighter_skill VALUES(79, 13, 'Lord of Rats');
INSERT INTO necro_fighter_skill VALUES(80, 13, "Scavenger's Eye");
INSERT INTO necro_fighter_skill VALUES(81, 13, 'Blazing Faith');
INSERT INTO necro_fighter_skill VALUES(82, 13, 'Unshakeable Conviction');
INSERT INTO necro_fighter_skill VALUES(83, 13, 'Devotional Frenzy');
INSERT INTO necro_fighter_skill VALUES(84, 13, 'Restless Faith');
INSERT INTO necro_fighter_skill VALUES(85, 14, 'Faceless');
INSERT INTO necro_fighter_skill VALUES(86, 14, 'Psi-touched');
INSERT INTO necro_fighter_skill VALUES(87, 14, 'Take Down');
INSERT INTO necro_fighter_skill VALUES(88, 14, 'Rumour-Monger');
INSERT INTO necro_fighter_skill VALUES(89, 14, 'Fake Out');
INSERT INTO necro_fighter_skill VALUES(90, 14, 'Doppleganger');
INSERT INTO necro_fighter_skill VALUES(91, 15, 'Got Your Six');
INSERT INTO necro_fighter_skill VALUES(92, 15, "Helmawr's Justice");
INSERT INTO necro_fighter_skill VALUES(93, 15, 'Non-verbal Communication');
INSERT INTO necro_fighter_skill VALUES(94, 15, 'Restrain');
INSERT INTO necro_fighter_skill VALUES(95, 15, 'Team Work');
INSERT INTO necro_fighter_skill VALUES(96, 15, 'Threat Response');
INSERT INTO necro_fighter_skill VALUES(97, 16, 'Avatar of Blood');
INSERT INTO necro_fighter_skill VALUES(98, 16, 'Bloodlust');
INSERT INTO necro_fighter_skill VALUES(99, 16, 'Crimson Haze');
INSERT INTO necro_fighter_skill VALUES(100, 16, 'Frenzy');
INSERT INTO necro_fighter_skill VALUES(101, 16, 'Killing Blow');
INSERT INTO necro_fighter_skill VALUES(102, 16, 'Slaughterborn');
INSERT INTO necro_fighter_skill VALUES(103, 17, 'Born to the Wastes');
INSERT INTO necro_fighter_skill VALUES(104, 17, 'Stormwalker');
INSERT INTO necro_fighter_skill VALUES(105, 17, 'Eyes of the Wasteland');
INSERT INTO necro_fighter_skill VALUES(106, 17, 'Beast Handler');
INSERT INTO necro_fighter_skill VALUES(107, 17, 'Ever Vigilant');
INSERT INTO necro_fighter_skill VALUES(108, 17, 'Bring It Down');
INSERT INTO necro_fighter_skill VALUES(109, 18, "Where There's Scrap, There's Creds!");
INSERT INTO necro_fighter_skill VALUES(110, 18, 'Nobody Pushes Kin Around');
INSERT INTO necro_fighter_skill VALUES(111, 18, 'Chemical Bonds Never Break');
INSERT INTO necro_fighter_skill VALUES(112, 18, 'Dependable Like Kin');
INSERT INTO necro_fighter_skill VALUES(113, 18, 'Stubborn to the Last');
INSERT INTO necro_fighter_skill VALUES(114, 18, "There's Always Another Secret");

DROP TABLE IF EXISTS necro_fighter_gear;
CREATE TABLE necro_fighter_gear (
	id INT NOT NULL AUTO_INCREMENT,
	gear_name VARCHAR(255),
	base_value INT,
	PRIMARY KEY (id)
);
INSERT INTO necro_fighter_gear VALUES (1, 'Flak Armor', 10);

DROP TABLE IF EXISTS necro_gang_stash_map;
CREATE TABLE necro_gang_stash_map (
	gang_id INT NOT NULL,
	gear_id INT,
	weapon_id INT,
	INDEX idx_gang_stash_map (gang_id, gear_id, weapon_id)
);

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

DROP TABLE IF EXISTS necro_weapon_fighter_map;
CREATE TABLE necro_weapon_fighter_map (
	fighter_id INT NOT NULL,
	weapon_id INT NOT NULL,
	INDEX idx_weapon_fighter_map (fighter_id, weapon_id)
);
INSERT INTO necro_weapon_fighter_map VALUES (1, 1);
INSERT INTO necro_weapon_fighter_map VALUES (1, 3);
INSERT INTO necro_weapon_fighter_map VALUES (2, 7);
INSERT INTO necro_weapon_fighter_map VALUES (2, 3);

DROP TABLE IF EXISTS necro_fighter_skill_map;
CREATE TABLE necro_fighter_skill_map (
	fighter_id INT NOT NULL,
	skill_id INT NOT NULL,
	INDEX idx_fighter_trait_map (fighter_id, skill_id)
);
INSERT INTO necro_fighter_skill_map VALUES (1, 53);
INSERT INTO necro_fighter_skill_map VALUES (2, 71);

DROP TABLE IF EXISTS necro_fighter_gear_map;
CREATE TABLE necro_fighter_gear_map (
	fighter_id INT NOT NULL,
	gear_id INT NOT NULL,
	INDEX idx_fighter_gear_map (fighter_id, gear_id)
);
INSERT INTO necro_fighter_gear_map VALUES (1, 1);
INSERT INTO necro_fighter_gear_map VALUES (2, 1);