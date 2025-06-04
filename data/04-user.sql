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
	nonce_key VARCHAR(255),
	PRIMARY KEY (id),
	INDEX idx_user_username (username)
);
INSERT INTO necro_user (id, username, userpassword, email_address, confirmed, registered, last_login, is_admin) VALUES (1, 'admin', '$2y$10$Q/H/OASzzpCTCBLNpjKiHeXyrJYQMiegm16MBMD98sc4W0CIgxo/u', 'admin@admin.com', 1, NOW(), NOW(), 1);

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

DROP TABLE IF EXISTS necro_user_follow_map;
CREATE TABLE necro_user_follow_map (
	user_id INT NOT NULL,
	followed_user_id INT NOT NULL,
	created DATETIME NOT NULL,
	INDEX idx_user_follows (user_id, followed_user_id)
);

DROP TABLE IF EXISTS necro_user_friends_map;
CREATE TABLE necro_user_friends_map (
	requesting_friend_user_id INT NOT NULL,
	recieving_friend_user_id INT NOT NULL,
	created DATETIME NOT NULL,
	receiving_approved TINYINT NOT NULL DEFAULT `0`,
	INDEX idx_user_friends (requesting_friend_user_id, recieving_friend_user_id)
);