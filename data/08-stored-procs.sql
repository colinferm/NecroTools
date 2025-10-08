DROP PROCEDURE IF EXISTS `necro_calc_gang_val`;

DELIMITER $$

CREATE PROCEDURE `necro_calc_gang_val` (IN GangId INTEGER)
BEGIN
	
	DECLARE v_fighter_cost INTEGER DEFAULT 0;
	DECLARE v_fighter_id INTEGER DEFAULT 0;
	DECLARE v_gang_total INTEGER DEFAULT 0;

	DECLARE finished INTEGER DEFAULT 0;

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
	AND f.user_gang_id = 1
	GROUP BY f.id);

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

	OPEN fighter_cursor;
	get_fighter_val: LOOP
		FETCH fighter_cursor INTO v_fighter_id, v_fighter_cost;
		IF finished = 1 THEN 
			LEAVE get_fighter_val;
		END IF;
		SET v_gang_total = v_gang_total + v_fighter_cost;
	END LOOP get_fighter_val;
	CLOSE fighter_cursor;

	UPDATE necro_user_gang SET current_value = v_gang_total WHERE id = GangId;
END$$
DELIMITER ;