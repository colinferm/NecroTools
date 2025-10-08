INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (7, "Scragfrid Mining Clan", "SQUAT_ANCESTRY", 1, 1);
INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (7, "Svadrhol Mining Clan", "SQUAT_ANCESTRY", 1, 1);
INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (7, "Tapferkeit Mining Clan", "SQUAT_ANCESTRY", 1, 1);
INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (7, "Helmaeth Mining Clan", "SQUAT_ANCESTRY", 1, 1);
INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (7, "Snorrag Mining Clan", "SQUAT_ANCESTRY", 1, 1);
INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (7, "Trocken Mining Clan", "SQUAT_ANCESTRY", 1, 1);
INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (7, "Vossinki Mining Clan", "SQUAT_ANCESTRY", 1, 1);
INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (7, "Splinter Mining Clan", "SQUAT_ANCESTRY", 1, 1);
INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (9, "Palanite Prefecture", "ENFORCER_PREFECTURE", 1, 1);
INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (9, "Mynerva Prefecture", "ENFORCER_PREFECTURE", 1, 1);
INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (9, "Secundan Prefecture", "ENFORCER_PREFECTURE", 1, 1);
INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (9, "Badlands Prefecture", "ENFORCER_PREFECTURE", 1, 1);
INSERT INTO necro_lookups (gang_type_id, lookup_value, lookup_key, is_special_attribute, is_gang_related) VALUES (9, "Poison Sea Prefecture", "ENFORCER_PREFECTURE", 1, 1);

DROP TABLE IF EXISTS necro_user_gang;
CREATE TABLE necro_user_gang (
	id INT NOT NULL AUTO_INCREMENT,
	user_id INT NOT NULL,
	gang_name VARCHAR(255) NOT NULL,
	gang_type_id INT NOT NULL,
	outlaw TINYINT NOT NULL DEFAULT '0',
	outcast TINYINT NOT NULL DEFAULT '0',
	credits INT NOT NULL DEFAULT '0',
	current_value INT NOT NULL DEFAULT '0',
	reputation INT NOT NULL DEFAULT '1',
	meat INT NOT NULL DEFAULT '0',
	current_status ENUM('Active', 'Retired') DEFAULT 'Active',
	created DATETIME NOT NULL,
	last_mod DATETIME NOT NULL,
	PRIMARY KEY (id),
	INDEX idx_gang_user (user_id)
);

INSERT INTO necro_user_gang VALUES (1, 1, 'The Bad Asses', 1, 0, 0, 1000, NOW(), NOW());
INSERT INTO necro_user_gang VALUES (2, 1, 'Not Your Mamas', 2, 0, 0, 1000, NOW(), NOW());

DROP TABLE IF EXISTS necro_user_gang_audit;
CREATE TABLE necro_user_gang_audit (
	id INT NOT NULL AUTO_INCREMENT,
	user_gang_id INT NOT NULL,
	created DATETIME NOT NULL,
	description VARCHAR(255),
	PRIMARY KEY(id),
	INDEX idx_gang_audit(user_gang_id)
);

DROP TABLE IF EXISTS necro_user_fighter;
CREATE TABLE necro_user_fighter (
	id INT NOT NULL AUTO_INCREMENT,
	user_gang_id INT NOT NULL,
	fighter_name VARCHAR(255) NOT NULL,
	fighter_role_id INT NOT NULL,
	backstory TEXT,
	movement VARCHAR(4),
	weapon_skill VARCHAR(4),
	ballistic_skill VARCHAR(4),
	strength VARCHAR(4),
	toughness VARCHAR(4),
	toughness_side VARCHAR(4),
	toughness_rear VARCHAR(4),
	wounds VARCHAR(4),
	initiative VARCHAR(4),
	attacks VARCHAR(4),
	handling VARCHAR(4),
	save_roll VARCHAR(4),
	leadership VARCHAR(4),
	cool VARCHAR(4),
	willpower VARCHAR(4),
	intelligence VARCHAR(4),
	is_vehicle TINYINT NOT NULL DEFAULT '0',
	is_convalescence TINYINT NOT NULL DEFAULT '0',
	is_captured TINYINT NOT NULL DEFAULT '0',
	is_dramatis TINYINT NOT NULL DEFAULT '0',
	is_wyrd TINYINT NOT NULL DEFAULT '0',
	experience TINYINT NOT NULL,
	advancements TINYINT NOT NULL,
	base_value INT NOT NULL,
	view_order TINYINT NOT NULL DEFAULT '0',
	created DATETIME NOT NULL,
	PRIMARY KEY (id),
	INDEX idx_user_fighter_gang (user_gang_id)
);
INSERT INTO necro_user_fighter VALUES(1, 1, 'Joe Blow', 11, NULL, '5', '3', '3', '3', '3', '0', '0', '2', '4', '2', 0, 0, '7', '8', '8', '8', 0, 0, 0, 0, 0, 6, 2, 125, 1, NOW());
INSERT INTO necro_user_fighter VALUES(2, 1, 'Jill Jones', 13, NULL, '5', '4', '3', '3', '3', '0', '0', '2', '4', '2', 0, 0, '8', '8', '8', '8', 0, 0, 0, 0, 0, 4, 1, 115, 1, NOW());

DROP TABLE IF EXISTS necro_user_fighter_audit;
CREATE TABLE necro_user_fighter_audit (
	id INT NOT NULL AUTO_INCREMENT,
	user_fighter_id INT NOT NULL,
	created DATETIME NOT NULL,
	description VARCHAR(255),
	PRIMARY KEY(id),
	INDEX idx_fighter_audit(user_fighter_id)
);

DROP TABLE IF EXISTS necro_user_gang_stash_map;
CREATE TABLE necro_user_gang_stash_map (
	user_gang_id INT NOT NULL,
	gear_id INT,
	weapon_id INT,
	INDEX idx_gang_stash_map (user_gang_id, gear_id, weapon_id)
);

DROP TABLE IF EXISTS necro_user_fighter_weapon_map;
CREATE TABLE necro_user_fighter_weapon_map (
	user_fighter_id INT NOT NULL,
	weapon_id INT NOT NULL,
	INDEX idx_weapon_fighter_map (user_fighter_id, weapon_id)
);
INSERT INTO necro_user_fighter_weapon_map VALUES (1, 1);
INSERT INTO necro_user_fighter_weapon_map VALUES (1, 3);
INSERT INTO necro_user_fighter_weapon_map VALUES (2, 7);
INSERT INTO necro_user_fighter_weapon_map VALUES (2, 3);

DROP TABLE IF EXISTS necro_user_fighter_skill_map;
CREATE TABLE necro_user_fighter_skill_map (
	user_fighter_id INT NOT NULL,
	skill_id INT NOT NULL,
	INDEX idx_fighter_trait_map (user_fighter_id, skill_id)
);
INSERT INTO necro_user_fighter_skill_map VALUES (1, 53);
INSERT INTO necro_user_fighter_skill_map VALUES (2, 71);

DROP TABLE IF EXISTS necro_user_fighter_gear_map;
CREATE TABLE necro_user_fighter_gear_map (
	user_fighter_id INT NOT NULL,
	gear_id INT NOT NULL,
	INDEX idx_fighter_gear_map (user_fighter_id, gear_id)
);
INSERT INTO necro_user_fighter_gear_map VALUES (1, 1);
INSERT INTO necro_user_fighter_gear_map VALUES (2, 1);

DROP TABLE IF EXISTS necro_user_fighter_injury_advancement_map;
CREATE TABLE necro_user_fighter_injury_advancement_map (
	user_fighter_id INT NOT NULL,
	injury_advancement_id INT NOT NULL,
	INDEX idx_fighter_injury_map (user_fighter_id, injury_advancement_id)
);

DROP TABLE IF EXISTS necro_user_fighter_xp_record;
CREATE TABLE necro_user_fighter_xp_record (
	id INT NOT NULL AUTO_INCREMENT,
	user_fighter_id INT NOT NULL,
	created DATETIME NOT NULL,
	xp_lookup_id INT NOT NULL,
	PRIMARY KEY(id),
	INDEX idx_fighter_xp_record (user_fighter_id, xp_lookup_id)
);

INSERT INTO necro_lookups (lookup_value, lookup_key, misc_value) VALUES ('Inflicted Serious Injury', 'XP_EVENT', 1);
INSERT INTO necro_lookups (lookup_value, lookup_key, misc_value) VALUES ('Provided Aide', 'XP_EVENT', 1);
INSERT INTO necro_lookups (lookup_value, lookup_key, misc_value) VALUES ('Fighter Rallied', 'XP_EVENT', 1);
INSERT INTO necro_lookups (lookup_value, lookup_key, misc_value) VALUES ('Out of Action', 'XP_EVENT', 2);
INSERT INTO necro_lookups (lookup_value, lookup_key, misc_value) VALUES ('Out of Action (Champion/Vehicle)', 'XP_EVENT', 3);
INSERT INTO necro_lookups (lookup_value, lookup_key, misc_value) VALUES ('Killed Fighter', 'XP_EVENT', 1);

DROP TABLE IF EXISTS necro_user_gang_special_trait_map;
CREATE TABLE necro_user_gang_special_trait_map (
	user_gang_id INT NOT NULL,
	special_trait_lookup_id INT NOT NULL,
	INDEX idx_user_gang_special_trait (user_gang_id, special_trait_lookup_id)
);

DROP TABLE IF EXISTS necro_user_fighter_special_trait_map;
CREATE TABLE necro_user_fighter_special_trait_map (
	user_fighter_id INT NOT NULL,
	special_trait_lookup_id INT NOT NULL,
	INDEX idx_user_fighter_special_trait (user_fighter_id, special_trait_lookup_id)
);