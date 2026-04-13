DROP TABLE IF EXISTS necro_fighter_template;
CREATE TABLE necro_fighter_template (
	id INT NOT NULL AUTO_INCREMENT,
	gang_type_id INT NOT NULL DEFAULT '0',
	fighter_role INT NOT NULL DEFAULT '0',
	movement  VARCHAR(4),
	weapon_skill  VARCHAR(4),
	balistic_skill  VARCHAR(4),
	strength  VARCHAR(4),
	toughness  VARCHAR(4),
	toughness_side  VARCHAR(4),
	toughness_rear  VARCHAR(4),
	wounds  VARCHAR(4),
	initiative  VARCHAR(4),
	attacks  VARCHAR(4),
	handling  VARCHAR(4),
	save_roll  VARCHAR(4),
	leadership  VARCHAR(4),
	cool  VARCHAR(4),
	willpower  VARCHAR(4),
	intelligence  VARCHAR(4),
	num_start_skills INT NOT NULL DEFAULT '0',
	is_vehicle TINYINT NOT NULL DEFAULT '0',
	is_dramatis TINYINT NOT NULL DEFAULT '0',
	base_value INT NOT NULL DEFAULT '0',
	view_order TINYINT NOT NULL DEFAULT '0',
	created DATETIME NOT NULL,
	last_mod DATETIME NOT NULL,
	PRIMARY KEY (id),
	INDEX idx_fighter_gang_template (id)
);

INSERT INTO necro_fighter_template (
	gang_type_id, fighter_role, movement, weapon_skill, balistic_skill, strength,
	toughness, toughness_side, toughness_rear, handling,
	wounds, initiative, attacks, save_roll, leadership, cool, willpower, intelligence,
	num_start_skills, is_vehicle, is_dramatis, base_value, view_order, 
	created, last_mod
) VALUES (
	2, 1, '5', '2', '3', '3',
	'3', '0', '0', '0',
	'2', '6', '3', '0', '6', '6', '7', '7',
	1, 0, 0, 130, 1, 
	NOW(), NOW()
);


DROP TABLE IF EXISTS necro_gang_fighter_role_skill_set_map;
CREATE TABLE necro_gang_fighter_role_skill_set_map (
	fighter_role_id INT NOT NULL,
	skill_set_id INT NOT NULL,
	is_primary TINYINT NOT NULL DEFAULT '1',
	INDEX idx_fighter_role_skill_set (fighter_role_id, skill_set_id)
);

DROP TABLE IF EXISTS necro_archetype;
CREATE TABLE necro_archetype (
	id INT NOT NULL AUTO_INCREMENT,
	archetype_name VARCHAR(200) NOT NULL,
	archetype_description TEXT,
	is_wyrd TINYINT NOT NULL DEFAULT '0',
	PRIMARY KEY (id)
);

DROP TABLE IF EXISTS necro_archetype_skill_set_map;
CREATE TABLE necro_archetype_skill_set_map (
	archetype_id INT NOT NULL,
	skill_set_id INT NOT NULL,
	is_primary TINYINT NOT NULL DEFAULT '1',
	INDEX idx_archetype_skill_set (archetype_id, skill_set_id)
);