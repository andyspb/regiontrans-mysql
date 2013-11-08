--- drop func
drop procedure `severtrans`.`update_tables_all_6m`
drop procedure `severtrans`.`update_tables_all`;
--- create func
USE `severtrans`;
DROP procedure IF EXISTS `update_tables_all_6m`;
DELIMITER $$
USE `severtrans`$$
CREATE DEFINER=`dba`@`localhost` PROCEDURE `update_tables_all_6m`()
BEGIN
--replace into invoice_all select * from invoice;
--delete from invoice where `Data` < (select CURDATE()  - interval 6 month );
--replace into invoice_all select * from invoice;
insert into invoice_all select * from invoice ON DUPLICATE KEY UPDATE  
invoice_all.`Number`=invoice.`Number`,
invoice_all.`Data`=invoice.`Data`,
invoice_all.`Clients_Ident`=invoice.`Clients_Ident`,
invoice_all.`Sum`=invoice.`Sum`,
invoice_all.`NDS`=invoice.`NDS`,
invoice_all.`Fee`=invoice.`Fee`,
invoice_all.`ReportReturn`=invoice.`ReportReturn`,
invoice_all.`SumGD`=invoice.`SumGD`,
invoice_all.`NDSGD`=invoice.`NDSGD`,
invoice_all.`SumAVT`=invoice.`SumAVT`,
invoice_all.`NDSAVT`=invoice.`NDSAVT`,
invoice_all.`SumAG`=invoice.`SumAG`,
invoice_all.`NDSAG`=invoice.`NDSAG`,
invoice_all.`SumPak`=invoice.`SumPak`,
invoice_all.`NDSPak`=invoice.`NDSPak`,
invoice_all.`SumPakAg`=invoice.`SumPakAg`,
invoice_all.`NDSPakAg`=invoice.`NDSPakAg`,
invoice_all.`SumSt`=invoice.`SumSt`,
invoice_all.`NDSSt`=invoice.`NDSSt`,
invoice_all.`SumStAg`=invoice.`SumStAg`,
invoice_all.`NDSStAg`=invoice.`NDSStAg`;
delete from invoice where `Data` < (select CURDATE()  - interval 6 month );

replace into account_all select * from account;
delete from account where `Dat` < (select CURDATE()  - interval 6 month );
replace into accounttek_all select * from accounttek;
delete from accounttek where `Dat` < (select CURDATE()  - interval 6 month );
replace into order_all select * from `order`;
delete from `order` where `Dat` < (select CURDATE()  - interval 6 month );
-- replace into akttek_all select * from akttek;
insert into akttek_all select * from akttek ON DUPLICATE KEY UPDATE  akttek_all.`Number`= akttek.`Number`, akttek_all.`Data`= akttek.`Data`, 
akttek_all.Clients_Ident = akttek.Clients_Ident, akttek_all.`Sum`= akttek.`Sum`, akttek_all.ReportReturn = akttek.ReportReturn;
delete from akttek where `Data` < (select CURDATE()  - interval 6 month );
replace into paysheet_all select * from paysheet;
delete from paysheet where `Dat` < (select CURDATE()  - interval 6 month );
replace into send_all select * from send;
delete from send where `start` < (select CURDATE()  - interval 6 month );
END
$$

--- create func
USE `severtrans`;
DROP procedure IF EXISTS `update_tables_all`;
DELIMITER $$
USE `severtrans`$$
CREATE DEFINER=`dba`@`localhost` PROCEDURE `update_tables_all`()
BEGIN
--replace into invoice_all select * from invoice;
--delete from invoice where `Data` < (select CURDATE()  - interval 6 month );

--replace into invoice_all select * from invoice;
insert into invoice_all select * from invoice ON DUPLICATE KEY UPDATE  
invoice_all.`Number`=invoice.`Number`,
invoice_all.`Data`=invoice.`Data`,
invoice_all.`Clients_Ident`=invoice.`Clients_Ident`,
invoice_all.`Sum`=invoice.`Sum`,
invoice_all.`NDS`=invoice.`NDS`,
invoice_all.`Fee`=invoice.`Fee`,
invoice_all.`ReportReturn`=invoice.`ReportReturn`,
invoice_all.`SumGD`=invoice.`SumGD`,
invoice_all.`NDSGD`=invoice.`NDSGD`,
invoice_all.`SumAVT`=invoice.`SumAVT`,
invoice_all.`NDSAVT`=invoice.`NDSAVT`,
invoice_all.`SumAG`=invoice.`SumAG`,
invoice_all.`NDSAG`=invoice.`NDSAG`,
invoice_all.`SumPak`=invoice.`SumPak`,
invoice_all.`NDSPak`=invoice.`NDSPak`,
invoice_all.`SumPakAg`=invoice.`SumPakAg`,
invoice_all.`NDSPakAg`=invoice.`NDSPakAg`,
invoice_all.`SumSt`=invoice.`SumSt`,
invoice_all.`NDSSt`=invoice.`NDSSt`,
invoice_all.`SumStAg`=invoice.`SumStAg`,
invoice_all.`NDSStAg`=invoice.`NDSStAg`;
delete from invoice where `Data` < (select CURDATE()  - interval 6 month );

replace into account_all select * from account;
delete from account where `Dat` < (select CURDATE()  - interval 6 month );
replace into accounttek_all select * from accounttek;
delete from accounttek where `Dat` < (select CURDATE()  - interval 6 month );
replace into order_all select * from `order`;
delete from `order` where `Dat` < (select CURDATE()  - interval 6 month );
-- replace into akttek_all select * from akttek;
insert into akttek_all select * from akttek ON DUPLICATE KEY UPDATE  akttek_all.`Number`= akttek.`Number`, akttek_all.`Data`= akttek.`Data`, 
akttek_all.Clients_Ident = akttek.Clients_Ident, akttek_all.`Sum`= akttek.`Sum`, akttek_all.ReportReturn = akttek.ReportReturn;
delete from akttek where `Data` < (select CURDATE()  - interval 6 month );
replace into paysheet_all select * from paysheet;
delete from paysheet where `Dat` < (select CURDATE()  - interval 6 month );
replace into send_all select * from send;
delete from send where `start` < (select CURDATE()  - interval 6 month );
END
$$


DELIMITER ;

----------------------------------
delimiter $$
alter table `severtrans`.`send_all` 
drop foreign key `send_all_ibfk_16`;
$$

delimiter $$
alter table `severtrans`.`send_all` 
drop foreign key `send_all_ibfk_17`;
$$

delimiter $$
alter table `severtrans`.`send_all` 
ADD CONSTRAINT `send_all_ibfk_16` FOREIGN KEY (`Invoice_Ident`) REFERENCES `invoice_all` (`Ident`) ON DELETE SET NULL ON UPDATE CASCADE;
$$

delimiter $$
alter table `severtrans`.`send_all` 
ADD CONSTRAINT `send_all_ibfk_17` FOREIGN KEY (`Akttek_Ident`) REFERENCES `akttek_all` (`IDENT`) ON DELETE SET NULL ON UPDATE CASCADE;
$$

-- select * into outfile 'd:\\send.txt '  from `send` where `ident`<91516; 
load data local infile 'd:\\send.txt' replace into table `send_all`;

-- select Ident, Start, Akttek_Ident from send_all where Client_Ident=20168;

drop view `severtrans`.`sends_all`;

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

select Ident, Start, Akttek_Ident from sends_all where Client_Ident=20168 ;

