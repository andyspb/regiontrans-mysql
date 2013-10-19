delimiter $$

CREATE TABLE if not exists `order_all` (
  `Ident` int(11) NOT NULL,
  `Client_Ident` int(11) DEFAULT NULL,
  `Number` varchar(8) DEFAULT NULL,
  `Dat` date DEFAULT NULL,
  `Sum` varchar(10) DEFAULT NULL,
  `NDS` varchar(8) DEFAULT NULL,
  `SumNDS` varchar(10) DEFAULT NULL,
  `NSP` varchar(8) DEFAULT NULL,
  `DatNow` date DEFAULT NULL,
  PRIMARY KEY (`Ident`),
  KEY `Clients` (`Client_Ident`),
  CONSTRAINT `order_all_ibfk_1` FOREIGN KEY (`Client_Ident`) REFERENCES `clients` (`Ident`) ON UPDATE CASCADE,
  CONSTRAINT `order_all_ibfk_2` FOREIGN KEY (`Client_Ident`) REFERENCES `clients` (`Ident`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=cp1251$$

