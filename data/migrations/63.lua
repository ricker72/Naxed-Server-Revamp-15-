function onUpdateDatabase()
	logger.info("Updating database to version 63 (feat: Issavi city and zones)")

	db.query([[
		CREATE TABLE IF NOT EXISTS `player_issavi_progress` (
			`player_id` int NOT NULL,
			`zones_explored` BLOB NULL,
			`kilomaresh_intro_done` TINYINT(1) NOT NULL DEFAULT 0,
			`citizen_outfit_unlocked` TINYINT(1) NOT NULL DEFAULT 0,
			`last_zone_entered` VARCHAR(64) NOT NULL DEFAULT '',
			`updated_at` BIGINT NOT NULL DEFAULT 0,
			CONSTRAINT `player_issavi_progress_pk` PRIMARY KEY (`player_id`),
			CONSTRAINT `player_issavi_progress_players_fk`
				FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
				ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	]])

	db.query([[
		CREATE TABLE IF NOT EXISTS `issavi_zone_kills` (
			`player_id` int NOT NULL,
			`zone_id` VARCHAR(64) NOT NULL,
			`kills` INT NOT NULL DEFAULT 0,
			`last_kill` BIGINT NOT NULL DEFAULT 0,
			PRIMARY KEY (`player_id`, `zone_id`),
			CONSTRAINT `issavi_zone_kills_players_fk`
				FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
				ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	]])
end
