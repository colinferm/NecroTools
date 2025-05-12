DROP TABLE IF EXISTS necro_fighter_template;
CREATE TABLE necro_fighter_template (
	id INT NOT NULL AUTO_INCREMENT,
	gang_type_id INT NOT NULL,
	fighter_role INT NOT NULL,
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
	is_dramatis TINYINT NOT NULL,
	base_value INT NOT NULL,
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
	is_vehicle, is_dramatis, base_value, view_order, 
	created, last_mod
) VALUES (
	2, 1, 5, 2, 3, 3,
	3, 0, 0, 0,
	2, 6, 3, 0, 6, 6, 7, 7,
	0, 0, 130, 1, 
	NOW(), NOW()
);


DROP TABLE IF EXISTS necro_gang_fighter_role_skill_set_map;
CREATE TABLE necro_gang_fighter_role_skill_set_map (
	fighter_role_id INT NOT NULL,
	skill_set_id INT NOT NULL,
	is_primary TINYINT NOT NULL DEFAULT '1',
	INDEX idx_fighter_role_skill_set (fighter_role_id, skill_set_id)
);