DROP TABLE IF EXISTS necro_user;
CREATE TABLE necro_user (
	id INT NOT NULL AUTO_INCREMENT,
	username VARCHAR(100) NOT NULL,
	userpassword VARCHAR(255) NOT NULL,
	email_address VARCHAR(255) NOT NULL,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	country VARCHAR(100),
	confirmed TINYINT NOT NULL DEFAULT '0',
	registered DATETIME NOT NULL,
	last_login DATETIME NOT NULL,
	is_admin TINYINT NOT NULL DEFAULT '0',
	oauth_key VARCHAR(255),
	PRIMARY KEY (id),
	INDEX idx_user_username (username)
);
INSERT INTO necro_user (id, username, userpassword, email_address, confirmed, registered, last_login, is_admin, oauth_key) VALUES (1, 'admin', '$2y$10$Q/H/OASzzpCTCBLNpjKiHeXyrJYQMiegm16MBMD98sc4W0CIgxo/u', 'admin@admin.com', 1, NOW(), NOW(), 1, NULL);

DROP TABLE IF EXISTS necro_user_permission;
CREATE TABLE necro_user_permission (
	id INT NOT NULL AUTO_INCREMENT,
	permisson VARCHAR(100) NOT NULL,
	code VARCHAR(100) NOT NULL,
	priority_order INT NOT NULL DEFAULT 0,
	PRIMARY KEY (id),
	INDEX idx_perm_code (code)
);
INSERT INTO necro_user_permission VALUES (1, 'Site Administrator', 'ADM-SITE', 1);
INSERT INTO necro_user_permission VALUES (2, 'User Admin', 'ADM-USER', 2);
INSERT INTO necro_user_permission VALUES (3, 'Data Admin', 'ADM-DATA', 2);
INSERT INTO necro_user_permission VALUES (4, 'Site User', 'USR-SITE', 10);
INSERT INTO necro_user_permission VALUES (5, 'Campaign Owner', 'OWN-CAMP', 5);
INSERT INTO necro_user_permission VALUES (6, 'Campaign Admin', 'ADM-CAMP', 6);

DROP TABLE IF EXISTS necro_user_permission_map;
CREATE TABLE necro_user_permission_map (
	user_id INT NOT NULL,
	permission_id INT NOT NULL,
	campaign_id INT NULL,
	INDEX idx_user_perms (user_id, permission_id)
);

INSERT INTO necro_user_permission_map (user_id, permission_id) VALUES (1, 1);
INSERT INTO necro_user_permission_map (user_id, permission_id) VALUES (1, 2);
INSERT INTO necro_user_permission_map (user_id, permission_id) VALUES (1, 3);
INSERT INTO necro_user_permission_map (user_id, permission_id) VALUES (1, 4);

DROP TABLE IF EXISTS necro_user_preference;
CREATE TABLE necro_user_preference (
	id INT NOT NULL AUTO_INCREMENT,
	preference_code VARCHAR(100) NOT NULL,
	preference_default VARCHAR(255) NOT NULL,
	priority_order INT NOT NULL DEFAULT 0,
	PRIMARY KEY (id),
	INDEX idx_pref_code (preference_code)
);

DROP TABLE IF EXISTS necro_user_preference_map;
CREATE TABLE necro_user_preference_map (
	user_id INT NOT NULL,
	preference_id INT NOT NULL,
	preference_value VARCHAR(255) NOT NULL,
	INDEX idx_user_prefs (user_id, preference_id)
);

DROP TABLE IF EXISTS necro_user_gang;
CREATE TABLE necro_user_gang (
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

INSERT INTO necro_user_gang VALUES (1, 1, 'The Bad Asses', 1, 0, NOW(), NOW());
INSERT INTO necro_user_gang VALUES (2, 1, 'Not Your Mamas', 2, 0, NOW(), NOW());

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
	INDEX idx_user_fighter_gang (user_gang_id)
);
INSERT INTO necro_user_fighter VALUES(1, 1, 'Joe Blow', 11, NULL, '5', '3', '3', '3', '3', '0', '0', '2', '4', '2', 0, 0, '7', '8', '8', '8', 0, 0, 0, 0, 6, 2, 125, 1, NOW());
INSERT INTO necro_user_fighter VALUES(2, 1, 'Jill Jones', 13, NULL, '5', '4', '3', '3', '3', '0', '0', '2', '4', '2', 0, 0, '8', '8', '8', '8', 0, 0, 0, 0, 4, 1, 115, 1, NOW());

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

DROP TABLE IF EXISTS necro_user_fighter_injury_map;
CREATE TABLE necro_user_fighter_injury_map (
	user_fighter_id INT NOT NULL,
	injury_id INT NOT NULL,
	INDEX idx_fighter_injury_map (user_fighter_id, injury_id)
);
