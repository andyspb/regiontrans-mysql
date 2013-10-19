delimiter $$

CREATE TABLE if not exists `akttek_all` (
  `IDENT` int(11) NOT NULL,
  `Number` varchar(13) DEFAULT NULL,
  `Data` date DEFAULT NULL,
  `Clients_Ident` int(11) DEFAULT NULL,
  `Sum` varchar(12) DEFAULT NULL,
  `ReportReturn` int(11) DEFAULT NULL,
  PRIMARY KEY (`IDENT`),
  KEY `Clients` (`Clients_Ident`),
  CONSTRAINT `akttek_all_ibfk_1` FOREIGN KEY (`Clients_Ident`) REFERENCES `clients` (`Ident`),
  CONSTRAINT `akttek_all_ibfk_2` FOREIGN KEY (`Clients_Ident`) REFERENCES `clients` (`Ident`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251$$

