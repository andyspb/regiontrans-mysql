delimiter $$

CREATE TABLE if not exists `account_all` (
  `Ident` int(11) NOT NULL,
  `Client_Ident` int(11) NOT NULL,
  `Dat` date NOT NULL,
  `SumNDS` varchar(10) NOT NULL,
  `Number` varchar(8) NOT NULL,
  PRIMARY KEY (`Ident`),
  KEY `Clients` (`Client_Ident`),
  CONSTRAINT `account_all_ibfk_1` FOREIGN KEY (`Client_Ident`) REFERENCES `clients` (`Ident`) ON UPDATE CASCADE,
  CONSTRAINT `account_all_ibfk_2` FOREIGN KEY (`Client_Ident`) REFERENCES `clients` (`Ident`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=cp1251$$

