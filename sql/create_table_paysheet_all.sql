delimiter $$

CREATE TABLE `paysheet_all` (
  `Ident` int(11) NOT NULL,
  `Client_Ident` int(11) NOT NULL,
  `Number` varchar(10) NOT NULL,
  `Dat` date NOT NULL,
  `Sum` varchar(11) NOT NULL,
  PRIMARY KEY (`Ident`),
  KEY `Clients` (`Client_Ident`),
  CONSTRAINT `paysheet_all_ibfk_1` FOREIGN KEY (`Client_Ident`) REFERENCES `clients` (`Ident`) ON UPDATE CASCADE,
  CONSTRAINT `paysheet_all_ibfk_2` FOREIGN KEY (`Client_Ident`) REFERENCES `clients` (`Ident`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=cp1251$$

