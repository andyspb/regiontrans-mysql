delimiter $$

CREATE TABLE if not exists `invoice_all` (
  `Ident` int(11) NOT NULL,
  `Number` varchar(13) NOT NULL,
  `Data` date DEFAULT NULL,
  `Clients_Ident` int(11) DEFAULT NULL,
  `Sum` varchar(12) DEFAULT NULL,
  `NDS` varchar(12) DEFAULT NULL,
  `Fee` varchar(12) DEFAULT NULL,
  `ReportReturn` int(11) DEFAULT NULL,
  `SumGD` varchar(12) DEFAULT NULL,
  `NDSGD` varchar(12) DEFAULT NULL,
  `SumAVT` varchar(12) DEFAULT NULL,
  `NDSAVT` varchar(12) DEFAULT NULL,
  `SumAG` varchar(12) DEFAULT NULL,
  `NDSAG` varchar(12) DEFAULT NULL,
  `SumPak` varchar(12) DEFAULT NULL,
  `NDSPak` varchar(12) DEFAULT NULL,
  `SumPakAg` varchar(12) DEFAULT NULL,
  `NDSPakAg` varchar(12) DEFAULT NULL,
  `SumSt` varchar(12) DEFAULT NULL,
  `NDSSt` varchar(12) DEFAULT NULL,
  `SumStAg` varchar(12) DEFAULT NULL,
  `NDSStAg` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`Ident`),
  KEY `Clients` (`Clients_Ident`),
  CONSTRAINT `invoice_all_ibfk_1` FOREIGN KEY (`Clients_Ident`) REFERENCES `clients` (`Ident`) ON UPDATE CASCADE,
  CONSTRAINT `invoice_all_ibfk_2` FOREIGN KEY (`Clients_Ident`) REFERENCES `clients` (`Ident`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=cp1251$$

