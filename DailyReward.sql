CREATE TABLE IF NOT EXISTS `dailyreward` (
  `identifier` varchar(50) DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `lastcollectday` int(11) DEFAULT NULL,
  `today` int(11) DEFAULT NULL,
  `resign_ticket` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;