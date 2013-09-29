delimiter $$

CREATE OR REPLACE ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `sends` 
AS select distinct `send`.`Ident` AS `Ident`,`send`.`Check` AS `Check`,`send`.`Start` AS `Start`,`send`.`Inspector_Ident` AS `Inspector_Ident`,`inspector`.`PeopleFIO` AS `PeopleFIO`,`send`.`ContractType_Ident` 
AS `ContractType_Ident`,`contracttype`.`Name` AS `ContracttypeName`,`send`.`Client_Ident` AS `Client_Ident`,`clients`.`Name` AS `ClientName`,`clients`.`Acronym` AS `ClientAcr`,`clients`.`Telephone` AS `ClientPhone`,`clients`.`PersonType_Ident` 
AS `Persontype_ident`,`send`.`Credit` AS `Credit`,`send`.`Contract` AS `Contract`,`send`.`Client_Ident_Sender` AS `Client_Ident_Sender`,`cl`.`Name` AS `ClientSenderName`,`cl`.`Acronym` AS `ClientSenderAcr`,`cl`.`Telephone` 
AS `ClientSenderPhone`,`send`.`City_Ident` AS `City_Ident`,`city`.`Name` AS `CityName`,`send`.`DateSend` AS `DateSend`,`send`.`Acceptor_Ident` AS `Acceptor_Ident`,`acceptor`.`Name` AS `AcceptorName`,`acceptor`.`Address` 
AS `AcceptorAddress`,`acceptor`.`Regime` AS `AcceptorRegime`,`acceptor`.`Phone` AS `AcceptorPhone`,`send`.`Forwarder_Ident` AS `Forwarder_Ident`,`forwarder`.`Name` AS `Forwarder`,`send`.`Rollout_Ident` AS `RollOut_Ident`,`rollout`.`Name` 
AS `RollOutName`,`send`.`Namegood_Ident` AS `Namegood_Ident`,`namegood`.`Name` AS `NamegoodName`,`send`.`Typegood_Ident` AS `Typegood_Ident`,`send`.`Weight` AS `Weight`,`send`.`Volume` AS `Volume`,`send`.`CountWeight` 
AS `CountWeight`,`send`.`Tariff` AS `Tariff`,concat(cast(((cast(`send`.`CountWeight` as decimal(10,2)) * cast(`send`.`Tariff` as decimal(10,2))) / 10) as decimal(15,2)),' руб.') AS `MoneyGD`,`send`.`Fare` AS `Fare`,`send`.`PackTarif` 
AS `PackTarif`,`send`.`AddServiceExp` AS `AddServiceExp`,`send`.`AddServicePack` AS `AddServicePack`,`send`.`AddServiceProp` AS `AddServiceProp`,`send`.`AddServicePrace` AS `AddServicePrace`,`send`.`InsuranceSum` 
AS `InsuranceSum`,`send`.`InsurancePercent` AS `InsurancePercent`,`send`.`InsuranceValue` AS `InsuranceValue`,`send`.`InsurancePay` AS `InsurancePay`,`send`.`SumCount` AS `SumCount`,`send`.`Typegood_Ident1` 
AS `Typegood_Ident1`,`send`.`Typegood_Ident2` AS `Typegood_Ident2`,`send`.`Namber` AS `Namber`,`send`.`PayType_Ident` AS `PayType_Ident`,`paytype`.`Name` AS `PayTypeName`,`send`.`NmberOrder` AS `NmberOrder`,`send`.`Invoice_Ident` 
AS `Invoice_Ident`,`invoice`.`Number` AS `InvoiceNumber`,`invoice`.`Data` AS `InvoiceDate`,`send`.`NumberCountPattern` AS `NumberCountPattern`,`send`.`PayText` AS `PayText`,`send`.`StatusSupp_Ident` AS `StatusSupp_Ident`,`sendtype`.`Name` 
AS `SendTypeName`,`send`.`DateSupp` AS `DateSupp`,`send`.`Supplier_Ident` AS `Supplier_Ident`,`supplier`.`Name` AS `SupplierName`,`send`.`SuppText` AS `SuppText`,cast(`send`.`PackCount` as char(60) charset utf8) 
AS `PackCount`,`send`.`ExpCount` AS `ExpCount`,`send`.`PropCount` AS `PropCount`,`send`.`ExpTarif` AS `ExpTarif`,`send`.`PropTarif` AS `PropTarif`,`send`.`Train_Ident` AS `Train_Ident`,`send`.`AddServStr` AS `AddServStr`,`send`.`AddServSum` 
AS `AddServSum`,`send`.`CutTarif` AS `CutTarif`,`train`.`Number` AS `Number`,`send`.`SumWay` AS `SumWay`,`send`.`NumberWay` AS `NumberWay`,`send`.`SumServ` AS `SumServ`,`send`.`NumberServ` AS `NumberServ`,`send`.`WeightGd` 
AS `WeightGd`,`send`.`PlaceGd` AS `PlaceGd`,`send`.`NumberPP` AS `NumberPP`,`send`.`PayTypeWay_Ident` AS `PayTypeWay_Ident`,`ptway`.`Name` AS `WayName`,`send`.`PayTypeServ_Ident` AS `PayTypeServ_Ident`,`ptserv`.`Name` 
AS `ServName`,`send`.`CountInvoice` AS `CountInvoice`,`send`.`PlaceC` AS `PlaceC`,'+' AS `Sel`,`severtrans`.`TP_return`(`send`.`Typegood_Ident`) AS `TP`,`severtrans`.`TP1_return`(`send`.`Typegood_Ident1`) AS `TP1`,`severtrans`.`TP2_return`(`send`.`Typegood_Ident2`) 
AS `TP2`,concat(`severtrans`.`TP_return`(`send`.`Typegood_Ident`),' ',`severtrans`.`TP1_return`(`send`.`Typegood_Ident1`),' ',`severtrans`.`TP2_return`(`send`.`Typegood_Ident2`)) AS `Typegood`,`akttek`.`IDENT` AS `Akttek_Ident`,`akttek`.`Number` 
AS `AkttekNumber`,`akttek`.`Data` AS `Akttekdata` from ((((((((((((((((`send` left join `inspector` on((`send`.`Inspector_Ident` = `inspector`.`Ident`))) left join `contracttype` on((`send`.`ContractType_Ident` = `contracttype`.`Ident`))) 
left join `clients` on((`clients`.`Ident` = `send`.`Client_Ident`))) left join `train` on((`train`.`Ident` = `send`.`Train_Ident`))) left join `city` on((`send`.`City_Ident` = `city`.`Ident`))) left join `acceptor` on((`acceptor`.`Ident` = `send`.`Acceptor_Ident`))) 
left join `rollout` on((`send`.`Rollout_Ident` = `rollout`.`Ident`))) left join `namegood` on((`send`.`Namegood_Ident` = `namegood`.`Ident`))) left join `forwarder` on((`forwarder`.`Ident` = `send`.`Forwarder_Ident`))) 
left join `paytype` on((`paytype`.`Ident` = `send`.`PayType_Ident`))) left join `supplier` on((`send`.`Supplier_Ident` = `supplier`.`Ident`))) left join `sendtype` on((`send`.`StatusSupp_Ident` = `sendtype`.`Ident`))) 
left join `invoice` on((`invoice`.`Ident` = `send`.`Invoice_Ident`))) left join `paytype` `ptway` on((`ptway`.`Ident` = `send`.`PayTypeWay_Ident`))) left join `paytype` `ptserv` on((`ptserv`.`Ident` = `send`.`PayTypeServ_Ident`))) 
left join ((`send` `s` left join `clients` `cl` on((`cl`.`Ident` = `s`.`Client_Ident_Sender`))) left join `akttek` on((`akttek`.`IDENT` = `s`.`Akttek_Ident`))) on((`send`.`Ident` = `s`.`Ident`)))$$

