-- Create Test User
INSERT INTO necro_user VALUES (0, 'admin', '$2y$10$Q/H/OASzzpCTCBLNpjKiHeXyrJYQMiegm16MBMD98sc4W0CIgxo/u', 'admin@admin.com', 1, NOW(), NOW(), 1);

-- Create Dummy gangs
INSERT INTO necro_gang VALUES (1, 1, 'The Bad Asses', 1, 0, NOW(), NOW());
INSERT INTO necro_gang VALUES (2, 1, 'Not Your Mamas', 2, 0, NOW(), NOW());

-- Create Weapons
INSERT INTO necro_weapon VALUES (1, 2, 'Boltgun', 55, 'R8');
INSERT INTO necro_weapon VALUES (2, 1, 'Autopistol', 10, 'C');
INSERT INTO necro_weapon VALUES (3, 5, 'Knife', 15, 'C');
INSERT INTO necro_weapon VALUES (4, 5, 'Stilleto Knife', 20, 'R9');
INSERT INTO necro_weapon VALUES (5, 5, 'Stilleto Sword', 35, 'R9');
INSERT INTO necro_weapon VALUES (6, 5, 'Chain Sword', 25, 'R8');
INSERT INTO necro_weapon VALUES (7, 3, 'Escher Pattern Combi-', 180, 'R8');

-- Create Weapon Traits
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (1, 'Rapid Fire (1)');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (2, 'Backstab');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (3, 'Toxin');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (4, 'Parry');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (5, 'Rending');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (6, 'Combi');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (7, 'Blaze');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (8, 'Template');
INSERT INTO necro_weapon_trait (id, trait_name) VALUES (9, 'Unstable');

-- Create Weapon Characterists
INSERT INTO necro_weapon_characteristic VALUES (1, 1, 'Standard', '12', '24', '+1', '-', '4', '-1', '2', '6+');
INSERT INTO necro_weapon_characteristic VALUES (2, 2, 'Standard', '4', '12', '+1', '-', '3', '-', '1', '4+');
INSERT INTO necro_weapon_characteristic VALUES (3, 3, 'Standard', 'E', '-', '-', '-', 'S', '-1', '1', '-');
INSERT INTO necro_weapon_characteristic VALUES (4, 4, 'Standard', 'E', '-', '-', '-', '-', '-', '-', '-');
INSERT INTO necro_weapon_characteristic VALUES (5, 5, 'Standard', 'E', '-', '-', '-', '-', '-1', '-', '-');
INSERT INTO necro_weapon_characteristic VALUES (6, 6, 'Standard', 'E', '-', '+1', '-', 'S', '-1', '1', '-');
INSERT INTO necro_weapon_characteristic VALUES (7, 7, 'Bolter', '12', '24', '+1', '-', '4', '-1', '2', '6+');
INSERT INTO necro_weapon_characteristic VALUES (8, 7, 'Flamer', '-', 'T', '-', '-', '4', '-1', '1', '5+');

-- Map traits to Characteristics
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

-- Add Gear
INSERT INTO necro_fighter_gear VALUES (1, 'Flak Armor', 10);

-- Add Fighters
INSERT INTO necro_fighter VALUES(1, 1, 'Joe Blow', 'leader', NULL, '5', '3', '3', '3', '3', '0', '0', '2', '4', '2', 0, 0, '7', '8', '8', '8', 0, 0, 0, 0, 6, 2, 125, 1, NOW());
INSERT INTO necro_fighter VALUES(2, 1, 'Jill Jones', 'champion', NULL, '5', '4', '3', '3', '3', '0', '0', '2', '4', '2', 0, 0, '8', '8', '8', '8', 0, 0, 0, 0, 4, 1, 115, 1, NOW());

-- Map Weapons to fighters
INSERT INTO necro_weapon_fighter_map VALUES (1, 1);
INSERT INTO necro_weapon_fighter_map VALUES (1, 3);
INSERT INTO necro_weapon_fighter_map VALUES (2, 2);
INSERT INTO necro_weapon_fighter_map VALUES (2, 3);

-- Map Skills to fighters
INSERT INTO necro_fighter_skill_map VALUES (1, 53);
INSERT INTO necro_fighter_skill_map VALUES (2, 71);

-- Map Gear to fighters
INSERT INTO necro_fighter_gear_map VALUES (1, 1);
INSERT INTO necro_fighter_gear_map VALUES (2, 1);
