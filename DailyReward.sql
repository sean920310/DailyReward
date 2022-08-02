CREATE TABLE `dailyreward` (
	`identifier` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`month` INT(11) NULL DEFAULT NULL,
	`lastcollectday` INT(11) NULL DEFAULT NULL,
	`today` INT(11) NULL DEFAULT NULL,
	`resign_ticket` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`identifier`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
