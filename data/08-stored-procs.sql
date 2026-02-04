DROP PROCEDURE IF EXISTS `necro_calc_gang_val`;

DELIMITER $$

CREATE PROCEDURE `necro_calc_gang_val` (IN GangId INTEGER)
BEGIN
	
	DECLARE v_fighter_cost INTEGER DEFAULT 0;
	DECLARE v_fighter_id INTEGER DEFAULT 0;
	DECLARE v_gang_total INTEGER DEFAULT 0;

	DECLARE finished INTEGER DEFAULT 0;

	/* SELECT COALESCE(SUM(w.weapon_value) + SUM(l.misc_value), SUM(w.weapon_value)) as weapon_value INTO @StashValue
	FROM necro_user_gang g
	LEFT JOIN necro_user_gang_stash_map sm ON (g.id = sm.user_gang_id)
	LEFT JOIN necro_weapon w ON (sm.weapon_id = w.id)
	LEFT JOIN necro_weapon_characteristic wc ON (w.id = wc.weapon_id)
	LEFT JOIN necro_weapon_trait_characteristic_map wtcm ON (wc.id = wtcm.characteristic_id)
	LEFT JOIN necro_lookups l ON (wtcm.trait_lookup_id = l.id)
	WHERE g.id = GangId; */

	DECLARE fighter_cursor CURSOR FOR
	(SELECT f.id,
		 COALESCE(
			f.base_value + SUM(w.weapon_value) + SUM(ia.value_adj), 
			f.base_value + SUM(w.weapon_value), 
			f.base_value
		) AS total_val
	FROM necro_user_fighter f
	LEFT JOIN necro_user_fighter_weapon_map fwm ON (f.id = fwm.user_fighter_id)
	LEFT JOIN necro_weapon w ON (fwm.weapon_id = w.id)
	LEFT JOIN necro_user_fighter_injury_advancement_map iam ON (f.id = iam.user_fighter_id)
	LEFT JOIN necro_gang_fighter_injury_advancement ia ON (iam.injury_advancement_id = ia.id)
	WHERE 1 = 1
	AND f.user_gang_id = GangId
	GROUP BY f.id);

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

	OPEN fighter_cursor;
	get_fighter_val: LOOP
		FETCH fighter_cursor INTO v_fighter_id, v_fighter_cost;
		IF finished = 1 THEN 
			LEAVE get_fighter_val;
		END IF;
		UPDATE necro_user_fighter SET current_value = v_fighter_cost WHERE id = v_fighter_id;
		SET v_gang_total = v_gang_total + v_fighter_cost;
	END LOOP get_fighter_val;
	CLOSE fighter_cursor;

	UPDATE necro_user_gang SET current_value = v_gang_total WHERE id = GangId;
END$$
DELIMITER ;