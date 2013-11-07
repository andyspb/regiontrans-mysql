delimiter $$
CREATE or replace ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `accounttekview_all` 
AS select `accounttek_all`.`IDENT` 
AS `Ident`,`accounttek_all`.`Number` 
AS `Number`,`accounttek_all`.`Dat` 
AS `Dat`,year(`accounttek_all`.`Dat`) 
AS `Year`,`accounttek_all`.`Client_Ident` 
AS `Client_ident`,`accounttek_all`.`Sum` 
AS `sum`,`clients`.`Acronym` 
AS `Client_Acronym` from (`accounttek_all` left join `clients` on((`clients`.`Ident` = `accounttek_all`.`Client_Ident`)))$$

delimiter $$
CREATE or replace ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `accountview_all` 
AS select `account_all`.`Ident` 
AS `Ident`,`account_all`.`Client_Ident` 
AS `Client_Ident`,`clients`.`Acronym` 
AS `ClientName`,`account_all`.`Dat` 
AS `Dat`,year(`account_all`.`Dat`) 
AS `Year`,`account_all`.`SumNDS` 
AS `SumNDS`,`account_all`.`Number` 
AS `Number` from (`account_all` left join `clients` on((`clients`.`Ident` = `account_all`.`Client_Ident`)))$$

delimiter $$

CREATE or replace ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `invoiceview_all` 
AS select `invoice_all`.`Ident` 
AS `Ident`,`invoice_all`.`Number` 
AS `Number`,`invoice_all`.`Data` 
AS `Data`,year(`invoice_all`.`Data`) 
AS `Year`,`invoice_all`.`Clients_Ident` 
AS `Clients_Ident`,`clients`.`Acronym` 
AS `Acronym`,`invoice_all`.`Sum` 
AS `Sum`,`invoice_all`.`NDS` 
AS `NDS`,`invoice_all`.`Fee` 
AS `Fee`,`invoice_all`.`SumGD` 
AS `SumGD`,`invoice_all`.`NDSGD` 
AS `NDSGD`,`invoice_all`.`SumAVT` 
AS `SumAvt`,`invoice_all`.`NDSAVT` 
AS `NDSAvt`,`invoice_all`.`SumAG` 
AS `SumAg`,`invoice_all`.`NDSAG` 
AS `NDSAg`,`invoice_all`.`SumPak` 
AS `SumPak`,`invoice_all`.`NDSPak` 
AS `NDSPak`,`invoice_all`.`SumPakAg` 
AS `SumPakAg`,`invoice_all`.`NDSPakAg` 
AS `NDSPakAg`,`invoice_all`.`SumSt` 
AS `SumSt`,`invoice_all`.`NDSSt` 
AS `NDSSt`,`invoice_all`.`SumStAg` 
AS `SumStAg`,`invoice_all`.`NDSStAg` 
AS `NDSStAg`,(substr(`invoice_all`.`Number`,-(4),(-(length(`invoice_all`.`Number`)) + 3)) + 0) 
AS `NUM`,`invoice_all`.`ReportReturn` 
AS `ReportReturn`,`severtrans`.`Report_return`(`invoice_all`.`ReportReturn`) 
AS `ReportReturnName` from (`invoice_all` join `clients` on((`invoice_all`.`Clients_Ident` = `clients`.`Ident`)))$$

delimiter $$
CREATE or replace ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `orders_all` 
AS select `order_all`.`Ident` 
AS `Ident`,`order_all`.`Client_Ident` 
AS `Client_Ident`,`clients`.`Acronym` 
AS `ClientsName`,`order_all`.`Number` 
AS `Number`,`order_all`.`Dat` AS `Dat`,year(`order_all`.`Dat`) 
AS `Year`,`order_all`.`Sum` 
AS `Sum`,`order_all`.`NDS` 
AS `NDS`,`order_all`.`SumNDS` 
AS `SumNDS`,`order_all`.`NSP` 
AS `NSP`,`order_all`.`DatNow` 
AS `DatNow` from (`order_all` left join `clients` on((`order_all`.`Client_Ident` = `clients`.`Ident`)))$$

delimiter $$

CREATE or replace ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `orderstek_all` 
AS select `order_all`.`Ident` AS `Ident`,`order_all`.`Client_Ident` AS `Client_Ident`,`clientstek`.`Acronym` 
AS `ClientsName`,`order_all`.`Number` AS `Number`,(substr(`order_all`.`Number`,1,(length(`order_all`.`Number`) - 3)) + 0) 
AS `Num`,`order_all`.`Dat` AS `Dat`,year(`order_all`.`Dat`) AS `Year`,`order_all`.`Sum` AS `Sum`,`order_all`.`NDS` 
AS `NDS`,concat(`order_all`.`Number`,';',dayofmonth(`order_all`.`Dat`),'.',month(`order_all`.`Dat`),'.',year(`order_all`.`Dat`)) 
AS `NumDat`,concat(cast('Оплата перевозки/' as char character set cp1251),`clientstek`.`Acronym`) AS `ClN`,`order_all`.`SumNDS` 
AS `SumNDS` from (`clientstek` left join `order_all` on((`order_all`.`Client_Ident` = `clientstek`.`Ident`))) 
where (`order_all`.`Dat` > '2006-10-31')$$

delimiter $$

CREATE or replace ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `paysheetview_all` 
AS select `paysheet_all`.`Ident` AS `Ident`,`paysheet_all`.`Client_Ident` AS `Client_Ident`,`clients`.`Acronym` 
AS `Acronym`,`paysheet_all`.`Number` AS `Number`,`paysheet_all`.`Dat` AS `Dat`,`paysheet_all`.`Sum` 
AS `Sum` from (`paysheet_all` left join `clients` on((`paysheet_all`.`Client_Ident` = `clients`.`Ident`)))$$

delimiter $$

CREATE or replace  ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `sends_all` 
AS select distinct `send_all`.`Ident` AS `Ident`,`send_all`.`Check` AS `Check`,`send_all`.`Start` AS `Start`,`send_all`.`Inspector_Ident` 
AS `Inspector_Ident`,`inspector`.`PeopleFIO` AS `PeopleFIO`,`send_all`.`ContractType_Ident` AS `ContractType_Ident`,`contracttype`.`Name` 
AS `ContracttypeName`,`send_all`.`Client_Ident` AS `Client_Ident`,`clients`.`Name` AS `ClientName`,`clients`.`Acronym` AS `ClientAcr`,`clients`.`Telephone` 
AS `ClientPhone`,`clients`.`PersonType_Ident` AS `Persontype_ident`,`send_all`.`Credit` AS `Credit`,`send_all`.`Contract` AS `Contract`,`send_all`.`Client_Ident_Sender` 
AS `Client_Ident_Sender`,`cl`.`Name` AS `ClientSenderName`,`cl`.`Acronym` AS `ClientSenderAcr`,`cl`.`Telephone` AS `ClientSenderPhone`,`send_all`.`City_Ident` 
AS `City_Ident`,`city`.`Name` AS `CityName`,`send_all`.`DateSend` AS `DateSend`,`send_all`.`Acceptor_Ident` AS `Acceptor_Ident`,`acceptor`.`Name` 
AS `AcceptorName`,`acceptor`.`Address` AS `AcceptorAddress`,`acceptor`.`Regime` AS `AcceptorRegime`,`acceptor`.`Phone` AS `AcceptorPhone`,`send_all`.`Forwarder_Ident` 
AS `Forwarder_Ident`,`forwarder`.`Name` AS `Forwarder`,`send_all`.`Rollout_Ident` AS `RollOut_Ident`,`rollout`.`Name` AS `RollOutName`,`send_all`.`Namegood_Ident` 
AS `Namegood_Ident`,`namegood`.`Name` AS `NamegoodName`,`send_all`.`Typegood_Ident` AS `Typegood_Ident`,`send_all`.`Weight` AS `Weight`,`send_all`.`Volume` AS `Volume`,`send_all`.`CountWeight` 
AS `CountWeight`,`send_all`.`Tariff` AS `Tariff`,concat(cast(((cast(`send_all`.`CountWeight` as decimal(10,2)) * cast(`send_all`.`Tariff` as decimal(10,2))) / 10) as decimal(15,2)),' руб.') 
AS `MoneyGD`,`send_all`.`Fare` AS `Fare`,`send_all`.`PackTarif` AS `PackTarif`,`send_all`.`AddServiceExp` AS `AddServiceExp`,`send_all`.`AddServicePack` 
AS `AddServicePack`,`send_all`.`AddServiceProp` AS `AddServiceProp`,`send_all`.`AddServicePrace` AS `AddServicePrace`,`send_all`.`InsuranceSum` 
AS `InsuranceSum`,`send_all`.`InsurancePercent` AS `InsurancePercent`,`send_all`.`InsuranceValue` AS `InsuranceValue`,`send_all`.`InsurancePay` 
AS `InsurancePay`,`send_all`.`SumCount` AS `SumCount`,`send_all`.`Typegood_Ident1` AS `Typegood_Ident1`,`send_all`.`Typegood_Ident2` AS `Typegood_Ident2`,`send_all`.`Namber` 
AS `Namber`,`send_all`.`PayType_Ident` AS `PayType_Ident`,`paytype`.`Name` AS `PayTypeName`,`send_all`.`NmberOrder` AS `NmberOrder`,`send_all`.`Invoice_Ident` AS `Invoice_Ident`,`invoice_all`.`Number` 
AS `InvoiceNumber`,`invoice_all`.`Data` AS `InvoiceDate`,`send_all`.`NumberCountPattern` AS `NumberCountPattern`,`send_all`.`PayText` AS `PayText`,`send_all`.`StatusSupp_Ident` 
AS `StatusSupp_Ident`,`sendtype`.`Name` AS `SendTypeName`,`send_all`.`DateSupp` AS `DateSupp`,`send_all`.`Supplier_Ident` AS `Supplier_Ident`,`supplier`.`Name` 
AS `SupplierName`,`send_all`.`SuppText` AS `SuppText`,cast(`send_all`.`PackCount` as char(60) charset utf8) AS `PackCount`,`send_all`.`ExpCount` AS `ExpCount`,`send_all`.`PropCount` 
AS `PropCount`,`send_all`.`ExpTarif` AS `ExpTarif`,`send_all`.`PropTarif` AS `PropTarif`,`send_all`.`Train_Ident` AS `Train_Ident`,`send_all`.`AddServStr` AS `AddServStr`,`send_all`.`AddServSum` 
AS `AddServSum`,`send_all`.`CutTarif` AS `CutTarif`,`train`.`Number` AS `Number`,`send_all`.`SumWay` AS `SumWay`,`send_all`.`NumberWay` AS `NumberWay`,`send_all`.`SumServ` 
AS `SumServ`,`send_all`.`NumberServ` AS `NumberServ`,`send_all`.`WeightGd` AS `WeightGd`,`send_all`.`PlaceGd` AS `PlaceGd`,`send_all`.`NumberPP` AS `NumberPP`,`send_all`.`PayTypeWay_Ident` 
AS `PayTypeWay_Ident`,`ptway`.`Name` AS `WayName`,`send_all`.`PayTypeServ_Ident` AS `PayTypeServ_Ident`,`ptserv`.`Name` AS `ServName`,`send_all`.`CountInvoice` AS `CountInvoice`,`send_all`.`PlaceC` 
AS `PlaceC`,'+' AS `Sel`,`severtrans`.`TP_return`(`send_all`.`Typegood_Ident`) AS `TP`,`severtrans`.`TP1_return`(`send_all`.`Typegood_Ident1`) AS `TP1`,`severtrans`.`TP2_return`(`send_all`.`Typegood_Ident2`) 
AS `TP2`,concat(`severtrans`.`TP_return`(`send_all`.`Typegood_Ident`),' ',`severtrans`.`TP1_return`(`send_all`.`Typegood_Ident1`),' ',`severtrans`.`TP2_return`(`send_all`.`Typegood_Ident2`)) 
AS `Typegood`,`akttek_all`.`IDENT` AS `Akttek_Ident`,`akttek_all`.`Number` AS `AkttekNumber`,`akttek_all`.`Data` AS `Akttekdata` from ((((((((((((((((`send_all` left join `inspector` 
on((`send_all`.`Inspector_Ident` = `inspector`.`Ident`))) left join `contracttype` on((`send_all`.`ContractType_Ident` = `contracttype`.`Ident`))) left join `clients` 
on((`clients`.`Ident` = `send_all`.`Client_Ident`))) left join `train` on((`train`.`Ident` = `send_all`.`Train_Ident`))) left join `city` on((`send_all`.`City_Ident` = `city`.`Ident`))) left join `acceptor` 
on((`acceptor`.`Ident` = `send_all`.`Acceptor_Ident`))) left join `rollout` on((`send_all`.`Rollout_Ident` = `rollout`.`Ident`))) left join `namegood` on((`send_all`.`Namegood_Ident` = `namegood`.`Ident`))) 
left join `forwarder` on((`forwarder`.`Ident` = `send_all`.`Forwarder_Ident`))) left join `paytype` on((`paytype`.`Ident` = `send_all`.`PayType_Ident`))) left join `supplier` 
on((`send_all`.`Supplier_Ident` = `supplier`.`Ident`))) left join `sendtype` on((`send_all`.`StatusSupp_Ident` = `sendtype`.`Ident`))) left join `invoice_all` 
on((`invoice_all`.`Ident` = `send_all`.`Invoice_Ident`))) left join `paytype` `ptway` on((`ptway`.`Ident` = `send_all`.`PayTypeWay_Ident`))) left join `paytype` `ptserv` 
on((`ptserv`.`Ident` = `send_all`.`PayTypeServ_Ident`))) left join ((`send_all` `s` left join `clients` `cl` on((`cl`.`Ident` = `s`.`Client_Ident_Sender`))) left join `akttek_all` 
on((`akttek_all`.`IDENT` = `s`.`Akttek_Ident`))) on((`send_all`.`Ident` = `s`.`Ident`)))$$


delimiter $$

CREATE or replace ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `akttekview_all` 
AS select `akttek_all`.`IDENT` AS `Ident`,`akttek_all`.`Number` AS `Number`,`akttek_all`.`Data` 
AS `Data`,year(`akttek_all`.`Data`) AS `Year`,`akttek_all`.`Clients_Ident` AS `Clients_ident`,`akttek_all`.`Sum` 
AS `sum`,`akttek_all`.`ReportReturn` AS `ReportreturnNum`,`severtrans`.`Report_return`(`akttek_all`.`ReportReturn`) 
AS `Reportreturn`,`clients`.`Acronym` AS `Client_Acronym` from (`akttek_all` left join `clients` on((`clients`.`Ident` = `akttek_all`.`Clients_Ident`)))$$

delimiter $$

CREATE or replace ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `svpayreceipt_all` 
AS (select `akttekview_all`.`Number` AS `Number`,`akttekview_all`.`Data` AS `Data`,`akttekview_all`.`Clients_ident` AS `Clients_Ident`,`akttekview_all`.`sum` 
AS `Sum`,`akttekview_all`.`Client_Acronym` AS `Acronym`,`akttekview_all`.`ReportreturnNum` AS `Reportreturn` from `akttekview_all`) 
union (select `invoiceview_all`.`Number` AS `Number`,`invoiceview_all`.`Data` AS `Data`,`invoiceview_all`.`Clients_Ident` AS `Clients_Ident`,`invoiceview_all`.`Sum` 
AS `Sum`,`invoiceview_all`.`Acronym` AS `Acronym`,`invoiceview_all`.`ReportReturn` AS `Reportreturn` from `invoiceview_all`)$$

delimiter $$

CREATE or replace ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `vs1_all` 
AS select `sends_all`.`ClientAcr` AS `ClientAcr`,`sends_all`.`Client_Ident` AS `Client_Ident`,`sends_all`.`Start` AS `Start`,`sends_all`.`DateSupp` AS `DateSupp`,`sends_all`.`City_Ident` 
AS `City_Ident`,`sends_all`.`Ident` AS `Ident`,`sends_all`.`Weight` AS `Weight`,`sends_all`.`CountWeight` AS `CountWeight`,cast(`sends_all`.`Fare` as decimal(10,2)) 
AS `Fare`,cast(`sends_all`.`AddServicePrace` as decimal(10,2)) AS `AddServicePrace`,cast(`sends_all`.`InsuranceValue` as decimal(10,2)) 
AS `InsuranceValue`,cast(`sends_all`.`PackTarif` as decimal(10,2)) AS `PackTarif`,cast(`sends_all`.`SumCount` as decimal(10,2)) AS `SumCount` from `sends_all`$$

delimiter $$

CREATE or replace ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `vs2_all` 
AS select `s`.`ClientAcr` AS `ClientAcr`,`s`.`Client_Ident` AS `Client_Ident`,`s`.`Start` AS `Start`,`s`.`DateSupp` AS `DateSupp`,`s`.`City_Ident` 
AS `City_Ident`,`s`.`Ident` AS `Ident`,`s`.`Weight` 
AS `Weight`,`s`.`CountWeight` AS `CountWeight`,`s`.`Invoice_Ident` AS `send_Inv_ident`,cast(`s`.`Fare` as decimal(10,2)) 
AS `Fare`,cast(`s`.`AddServicePrace` as decimal(10,2)) 
AS `AddServicePrace`,cast(`s`.`InsuranceValue` as decimal(10,2)) AS `InsuranceValue`,cast(`s`.`PackTarif` as decimal(10,2)) AS `PackTarif`,cast(`s`.`SumCount` 
as decimal(10,2)) AS `SumCount`,`i`.`Ident` AS `Invoice_Ident`,`i`.`Data` AS `Invoice_Data` from (`sends_all` `s` left join `invoice_all` `i` on((`s`.`Invoice_Ident` = `i`.`Ident`)))$$





