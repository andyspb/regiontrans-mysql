delimiter $$

CREATE TABLE if not exists`accounttek_all` (
  `IDENT` int(11) NOT NULL,
  `Number` varchar(13) DEFAULT NULL,
  `Dat` date DEFAULT NULL,
  `Client_Ident` int(11) DEFAULT NULL,
  `Sum` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`IDENT`),
  KEY `Clients` (`Client_Ident`),
  CONSTRAINT `accounttek_all_ibfk_1` FOREIGN KEY (`Client_Ident`) REFERENCES `clients` (`Ident`),
  CONSTRAINT `accounttek_all_ibfk_2` FOREIGN KEY (`Client_Ident`) REFERENCES `clients` (`Ident`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251$$

