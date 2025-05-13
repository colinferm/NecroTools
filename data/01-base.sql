DROP TABLE IF EXISTS necro_gang_type;
CREATE TABLE necro_gang_type (
	id INT NOT NULL AUTO_INCREMENT,
	type_name VARCHAR(255) NOT NULL,
	house_gang TINYINT NOT NULL DEFAULT '1',
	outlaw TINYINT NOT NULL DEFAULT '0',
	gang_description TEXT NULL,
	created DATETIME NOT NULL,
	last_mod DATETIME NOT NULL,
	PRIMARY KEY (id)
);
INSERT INTO necro_gang_type VALUES (1, 'Orlock', 1, 0, NULL, NOW(), NOW());
INSERT INTO necro_gang_type VALUES (2, 'Escher', 1, 0, NULL, NOW(), NOW());
INSERT INTO necro_gang_type VALUES (3, 'Goliath', 1, 0, NULL, NOW(), NOW());
INSERT INTO necro_gang_type VALUES (4, 'Cawdor', 1, 0, NULL, NOW(), NOW());
INSERT INTO necro_gang_type VALUES (5, 'Delaque', 1, 0, NULL, NOW(), NOW());
INSERT INTO necro_gang_type VALUES (6, 'Van Saar', 1, 0, NULL, NOW(), NOW());
INSERT INTO necro_gang_type VALUES (7, 'Ironhead Squat', 0, 0, NULL, NOW(), NOW());
INSERT INTO necro_gang_type VALUES (8, 'Ash Waste Nomad', 0, 1, NULL, NOW(), NOW());
INSERT INTO necro_gang_type VALUES (9, 'Enforcer', 0, 0, NULL, NOW(), NOW());
INSERT INTO necro_gang_type VALUES (10, 'Corpse Grinder', 0, 1, NULL, NOW(), NOW());

DROP TABLE IF EXISTS necro_gang_fighter_role;
CREATE TABLE necro_gang_fighter_role (
	id INT NOT NULL AUTO_INCREMENT,
	hierarchy_role ENUM('leader', 'champion', 'fighter', 'prospect', 'juve', 'crew', 'brute', 'hanger-on', 'pet'),
	gang_type_id INT NOT NULL,
	role_name VARCHAR(100),
	PRIMARY KEY (id)
);
INSERT INTO necro_gang_fighter_role VALUES (1, 'leader', 2, 'Queen');
INSERT INTO necro_gang_fighter_role VALUES (2, 'champion', 2, 'Death-Maiden');
INSERT INTO necro_gang_fighter_role VALUES (3, 'champion', 2, 'Matriarch');
INSERT INTO necro_gang_fighter_role VALUES (4, 'fighter', 2, 'Sister');
INSERT INTO necro_gang_fighter_role VALUES (5, 'prospect', 2, 'Wyld-Runner');
INSERT INTO necro_gang_fighter_role VALUES (6, 'prospect', 2, 'Little Sister');
INSERT INTO necro_gang_fighter_role VALUES (7, 'crew', 2, 'Helion');
INSERT INTO necro_gang_fighter_role VALUES (8, 'pet', 2, 'Phelynx');
INSERT INTO necro_gang_fighter_role VALUES (9, 'pet', 2, 'Phyrr Cat');
INSERT INTO necro_gang_fighter_role VALUES (10, 'brute', 2, 'Khimerix');

INSERT INTO necro_gang_fighter_role VALUES (11, 'leader', 1, 'Road Captain');
INSERT INTO necro_gang_fighter_role VALUES (12, 'champion', 1, 'Arms Master');
INSERT INTO necro_gang_fighter_role VALUES (13, 'champion', 1, 'Road Sergeant');
INSERT INTO necro_gang_fighter_role VALUES (14, 'fighter', 1, 'Gunner');
INSERT INTO necro_gang_fighter_role VALUES (15, 'prospect', 1, 'Wrecker');
INSERT INTO necro_gang_fighter_role VALUES (16, 'prospect', 1, 'Greenhorn');
INSERT INTO necro_gang_fighter_role VALUES (17, 'crew', 1, 'Helion');
INSERT INTO necro_gang_fighter_role VALUES (18, 'pet', 1, 'Cyber-Mastiff');


DROP TABLE IF EXISTS necro_gang_fighter_injury;
CREATE TABLE necro_gang_fighter_injury (
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL,
	description VARCHAR(200) NOT NULL,
	convalescence TINYINT NOT NULL,
	PRIMARY KEY (id)
);
INSERT INTO necro_gang_fighter_injury VALUES (1, 'Impressive Scars', 'Cool +1', 0);
INSERT INTO necro_gang_fighter_injury VALUES (2, 'Horrid Scars', 'New Skill: Fearsome', 0);
INSERT INTO necro_gang_fighter_injury VALUES (3, 'Bitter Enmity', 'New Skill: Beserker (against this gang)', 0);
INSERT INTO necro_gang_fighter_injury VALUES (4, 'Old Battle Wound', 'Stackable', 0);
INSERT INTO necro_gang_fighter_injury VALUES (5, 'Partially Deafened', '-1 Leadership', 0);
INSERT INTO necro_gang_fighter_injury VALUES (6, 'Humiliated', '-1 Cool', 1);
INSERT INTO necro_gang_fighter_injury VALUES (7, 'Eye Injury', '-1 BS', 1);
INSERT INTO necro_gang_fighter_injury VALUES (8, 'Hand Injury', '-1 WS', 1);
INSERT INTO necro_gang_fighter_injury VALUES (9, 'Hobbled', '-1 Movement', 1);
INSERT INTO necro_gang_fighter_injury VALUES (10, 'Spinal Injury', '-1 Strength', 1);
INSERT INTO necro_gang_fighter_injury VALUES (11, 'Enfeebled', '-1 Toughness', 1);
INSERT INTO necro_gang_fighter_injury VALUES (12, 'Head Injury', '-1 Intelligence, -1 Willpower', 1);

DROP TABLE IF EXISTS necro_weapon_category;
CREATE TABLE necro_weapon_category (
	id INT NOT NULL AUTO_INCREMENT,
	category_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (id)
);
INSERT INTO necro_weapon_category VALUES (1, 'Pistols');
INSERT INTO necro_weapon_category VALUES (2, 'Basic Weapons');
INSERT INTO necro_weapon_category VALUES (3, 'Special Weapons');
INSERT INTO necro_weapon_category VALUES (4, 'Heavy Weapons');
INSERT INTO necro_weapon_category VALUES (5, 'Close Combat');
INSERT INTO necro_weapon_category VALUES (6, 'Grenades');
INSERT INTO necro_weapon_category VALUES (7, 'Booby Traps');
INSERT INTO necro_weapon_category VALUES (8, 'Others');

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
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (15, 'Palanite Drill', 1, 9);
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (16, 'Savagery', 1, 10);
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (17, 'Wastelands', 1, 8);
INSERT INTO necro_fighter_skill_set (id, skill_set_name, limited_to_gang, gang_type_id) VALUES (18, 'Wisdom of the Ancients', 1, 7);
INSERT INTO necro_fighter_skill_set (id, skill_set_name) VALUES (19, 'Driving');

DROP TABLE IF EXISTS necro_fighter_skill;
CREATE TABLE necro_fighter_skill (
	id INT NOT NULL AUTO_INCREMENT,
	skill_set_id INT NOT NULL,
	skill_name VARCHAR(255),
	skill_description TEXT NULL,
	PRIMARY KEY (id)
);
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (1, 1, 'Catfall');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (2, 1, 'Clamber');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (3, 1, 'Dodge');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (4, 1, 'Mighty Leap');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (5, 1, 'Spring Up');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (6, 1, 'Sprint');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (7, 2, 'Bull Charge');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (8, 2, 'Bulging Biceps');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (9, 2, 'Crushing Blow');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (10, 2, 'Headbutt');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (11, 2, 'Hurl');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (12, 2, 'Iron Jaw');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (13, 3, 'Combat Master');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (14, 3, 'Counter-Attack');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (15, 3, 'Disarm');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (16, 3, 'Parry');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (17, 3, 'Rain of Blows');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (18, 3, 'Step Aside');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (19, 4, 'Backstab');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (20, 4, 'Escape Artist');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (21, 4, 'Evade');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (22, 4, 'Infiltrate');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (23, 4, 'Lie Low');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (24, 4, 'Overwatch');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (25, 19, 'Jink');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (26, 19, 'Expert Driver');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (27, 19, 'Heavy Foot');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (28, 19, 'Slalom');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (29, 19, 'T-Bone');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (30, 19, 'Running Repairs');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (31, 5, 'Beserker');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (32, 5, 'Fearsome');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (33, 5, 'Impetuous');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (34, 5, 'Nerves of Steel');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (35, 5, 'True Grit');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (36, 5, 'Unstoppable');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (37, 6, 'Commanding Presence');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (38, 6, 'Inspirational');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (39, 6, 'Iron Will');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (40, 6, 'Mentor');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (41, 6, 'Overseer');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (42, 6, 'Regroup');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (43, 7, 'Ballistics Expert');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (44, 7, 'Connected');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (45, 7, 'Fixer');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (46, 7, 'Medicae');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (47, 7, 'Munitioneer');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (48, 7, 'Savvy Trader');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (49, 8, 'Fast Shot');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (50, 8, 'Gunfighter');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (51, 8, 'Hip Shooting');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (52, 8, 'Marksman');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (53, 8, 'Precision Shot');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (54, 8, 'Trick Shot');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (55, 9, 'Fists of Steel');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (56, 9, 'Iron Man');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (57, 9, 'Immovable Stance');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (59, 9, 'Unleash the Beast');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (60, 9, 'Walk It Off');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (61, 10, 'Acrobatic');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (62, 10, 'Combat Focus');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (63, 10, 'Combat Virtuoso');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (64, 10, 'Hit & Run');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (65, 10, 'Lighting Reflexes');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (66, 10, 'Somersault');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (67, 11, 'Big Brother');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (68, 11, 'Bring It On!');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (69, 11, 'Guilder Contacts');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (70, 11, 'King Hit');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (71, 11, 'Shotgun Savant');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (72, 11, 'Steady Hands');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (73, 12, 'Cold & Calculating');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (74, 12, 'Gadgetert');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (75, 12, 'Mental Mastery');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (76, 12, 'Photonic Engineer');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (77, 12, 'Rad-Phaged');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (78, 12, 'Weaponsmith');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (79, 13, 'Lord of Rats');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (80, 13, "Scavenger's Eye");
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (81, 13, 'Blazing Faith');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (82, 13, 'Unshakeable Conviction');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (83, 13, 'Devotional Frenzy');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (84, 13, 'Restless Faith');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (85, 14, 'Faceless');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (86, 14, 'Psi-touched');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (87, 14, 'Take Down');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (88, 14, 'Rumour-Monger');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (89, 14, 'Fake Out');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (90, 14, 'Doppleganger');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (91, 15, 'Got Your Six');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (92, 15, "Helmawr's Justice");
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (93, 15, 'Non-verbal Communication');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (94, 15, 'Restrain');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (95, 15, 'Team Work');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (96, 15, 'Threat Response');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (97, 16, 'Avatar of Blood');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (98, 16, 'Bloodlust');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (99, 16, 'Crimson Haze');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (100, 16, 'Frenzy');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (101, 16, 'Killing Blow');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (102, 16, 'Slaughterborn');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (103, 17, 'Born to the Wastes');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (104, 17, 'Stormwalker');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (105, 17, 'Eyes of the Wasteland');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (106, 17, 'Beast Handler');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (107, 17, 'Ever Vigilant');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (108, 17, 'Bring It Down');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (109, 18, "Where There's Scrap, There's Creds!");
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (110, 18, 'Nobody Pushes Kin Around');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (111, 18, 'Chemical Bonds Never Break');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (112, 18, 'Dependable Like Kin');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (113, 18, 'Stubborn to the Last');
INSERT INTO necro_fighter_skill (id, skill_set_id, skill_name) VALUES (114, 18, "There's Always Another Secret");

DROP TABLE IF EXISTS necro_fighter_gear;
CREATE TABLE necro_fighter_gear (
	id INT NOT NULL AUTO_INCREMENT,
	gear_name VARCHAR(255),
	base_value INT,
	notes VARCHAR(255) NULL,
	PRIMARY KEY (id)
);
INSERT INTO necro_fighter_gear VALUES (1, 'Flak Armor', 10, NULL);

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