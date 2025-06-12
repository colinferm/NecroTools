DROP TABLE IF EXISTS necro_campaign;
CREATE TABLE necro_campaign (
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(255) NOT NULL,
	creator_id INT NOT NULL,
	campaign_type_id INT NOT NULL,
	phase ENUM ('phase 1', 'phase 2', 'phase 3'),
	round_num CHAR(10),
	PRIMARY KEY(id)
);

DROP TABLE IF EXISTS necro_campaign_type;
CREATE TABLE necro_campaign_type (
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(255) NOT NULL,
	next_in_series_id INT,
	combinable_id INT,
	PRIMARY KEY(id)
);
INSERT INTO necro_campaign_type (id, name, combinable_id) VALUES (1, 'Dominion', 2);
INSERT INTO necro_campaign_type (id, name, combinable_id) VALUES (2, 'Law & Misrule', 1);
INSERT INTO necro_campaign_type (id, name) VALUES (3, 'Uprising');
INSERT INTO necro_campaign_type (id, name) VALUES (4, 'Outlander');
INSERT INTO necro_campaign_type (id, name) VALUES (5, 'Ash Wastes');
INSERT INTO necro_campaign_type (id, name, next_in_series_id) VALUES (6, 'Sucession I', 7);
INSERT INTO necro_campaign_type (id, name, next_in_series_id) VALUES (7, 'Sucession II', 8);
INSERT INTO necro_campaign_type (id, name) VALUES (8, 'Sucession III');
INSERT INTO necro_campaign_type (id, name) VALUES (9, 'Hive Secondus');
INSERT INTO necro_campaign_type (id, name) VALUES (10, 'Desolation');

DROP TABLE IF EXISTS necro_campaign_type_phase;
CREATE TABLE necro_campaign_type_phase (
	id INT NOT NULL AUTO_INCREMENT,
	campaign_type_id INT NOT NULL,
	phase ENUM ('phase 1', 'phase 2', 'phase 3'),
	name VARCHAR(255) NOT NULL,
	next_phase ENUM ('phase 1', 'phase 2', 'phase 3'),
	PRIMARY KEY(id),
	INDEX idx_phase_campaign_type(campaign_type_id, phase)
);
INSERT INTO necro_campaign_type_phase (id, campaign_type_id, phase, name, next_phase) VALUES (1, 1, 'phase 1', 'Phase I', 'phase 2');
INSERT INTO necro_campaign_type_phase (id, campaign_type_id, phase, name, next_phase) VALUES (2, 1, 'phase 2', 'Phase II - Downtime', 'phase 3');
INSERT INTO necro_campaign_type_phase (id, campaign_type_id, phase, name, next_phase) VALUES (3, 1, 'phase 3', 'Phase III', null);
INSERT INTO necro_campaign_type_phase (id, campaign_type_id, phase, name, next_phase) VALUES (4, 2, 'phase 1', 'Phase I', 'phase 2');
INSERT INTO necro_campaign_type_phase (id, campaign_type_id, phase, name, next_phase) VALUES (5, 2, 'phase 2', 'Phase II - Downtime', 'phase 3');
INSERT INTO necro_campaign_type_phase (id, campaign_type_id, phase, name, next_phase) VALUES (6, 2, 'phase 3', 'Phase III', null);

DROP TABLE IF EXISTS necro_campaign_members;
CREATE TABLE necro_campaign_members (
	campaign_id INT NOT NULL,
	gang_id INT NOT NULL,
	role ENUM('emperor', 'warlord', 'gang'),
	INDEX idx_campaign_members_map (campaign_id, gang_id)
);

DROP TABLE IF EXISTS necro_campaign_territory;
CREATE TABLE necro_campaign_territory (
	id INT NOT NULL AUTO_INCREMENT,
	campaign_id INT NOT NULL,
	name VARCHAR(255) NOT NULL,
	territory_description TEXT,
	generic_boon TEXT,
	gang_specific_boon TEXT,
	gang_specific_id INT,
	owning_gang_id INT,
	is_despoiled TINYINT,
	last_mod DATETIME NOT NULL,
	PRIMARY KEY(id),
	INDEX idx_territory_campaign (campaign_id)
);

DROP TABLE IF EXISTS necro_campaign_type_territory_template;
CREATE TABLE necro_campaign_type_territory_template (
	id INT NOT NULL AUTO_INCREMENT,
	campaign_type_id INT NOT NULL,
	name VARCHAR(255) NOT NULL,
	territory_description TEXT,
	generic_boon TEXT,
	gang_specific_boon TEXT,
	gang_specific_id INT,
	PRIMARY KEY(id),
	INDEX idx_territory_campaign_type (campaign_type_id)
);

DROP TABLE IF EXISTS necro_campaign_battle;
CREATE TABLE necro_campaign_battle (
	id INT NOT NULL AUTO_INCREMENT,
	campaign_id INT NOT NULL,
	campaign_territory_id INT,
	rumble_date DATETIME NOT NULL,
	notes TEXT,
	battle_finalized TINYINT NOT NULL DEFAULT '0',
	PRIMARY KEY(id)
);

DROP TABLE IF EXISTS necro_campaign_battle_participants;
CREATE TABLE necro_campaign_battle_participants (
	campaign_battle_id INT NOT NULL,
	gang_id INT NOT NULL,
	winner TINYINT NOT NULL DEFAULT '0',
	INDEX idx_campaign_battle_particip (campaign_battle_id, gang_id)
);

DROP TABLE IF EXISTS necro_campaign_battle_event;
CREATE TABLE necro_campaign_battle_event (
	id INT NOT NULL AUTO_INCREMENT,
	campaign_battle_id INT NOT NULL,
	agressor_fighter_id INT NOT NULL,
	victim_fighter_id INT,
	event_lookup_id INT NOT NULL,
	die_roll VARCHAR(20),
	xp_val INT,
	created DATETIME NOT NULL,
	PRIMARY KEY(id),
	INDEX idx_battle_event_gang (campaign_battle_id, agressor_fighter_id, event_lookup_id)
);

DROP TABLE IF EXISTS necro_campaign_battle_event_type;
CREATE TABLE necro_campaign_battle_event_type (
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(255),
	PRIMARY KEY(id)
);
INSERT INTO necro_lookups (lookup_value, lookup_key) VALUES ('Inflicted Serious Injury', 'BATTLE_EVENT');
INSERT INTO necro_lookups (lookup_value, lookup_key) VALUES ('Provided Aide', 'BATTLE_EVENT');
INSERT INTO necro_lookups (lookup_value, lookup_key) VALUES ('Fighter Recovered', 'BATTLE_EVENT');
INSERT INTO necro_lookups (lookup_value, lookup_key) VALUES ('Fighter Broken', 'BATTLE_EVENT');
INSERT INTO necro_lookups (lookup_value, lookup_key) VALUES ('Fighter Rallied', 'BATTLE_EVENT');
INSERT INTO necro_lookups (lookup_value, lookup_key) VALUES ('Out of Action', 'BATTLE_EVENT');
INSERT INTO necro_lookups (lookup_value, lookup_key) VALUES ('Gang Bottled', 'BATTLE_EVENT');