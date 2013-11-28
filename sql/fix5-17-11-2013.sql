-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`dba`@`localhost` PROCEDURE `update_tables_all_6m`()
BEGIN

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

insert into account_all select * from account ON DUPLICATE KEY UPDATE  
account_all.`Client_Ident`=account.`Client_Ident`,
account_all.`Dat`=account.`Dat`,
account_all.`SumNDS`=account.`SumNDS`,
account_all.`Number`=account.`Number`;

insert into accounttek_all select * from accounttek ON DUPLICATE KEY UPDATE  
accounttek_all.`Number`=accounttek.`Number`,
accounttek_all.`Dat`=accounttek.`Dat`,
accounttek_all.`Client_Ident`=accounttek.`Client_Ident`,
accounttek_all.`Sum`=accounttek.`Sum`;

insert into order_all select * from `order` ON DUPLICATE KEY UPDATE  
order_all.`Client_Ident`=`order`.`Client_Ident`,
order_all.`Number`=`order`.`Number`,
order_all.`Dat`=`order`.`Dat`,
order_all.`Sum`=`order`.`Sum`,
order_all.`NDS`=`order`.`NDS`,
order_all.`SumNDS`=`order`.`SumNDS`,
order_all.`NSP`=`order`.`NSP`,
order_all.`DatNow`=`order`.`DatNow`;

insert into akttek_all select * from akttek ON DUPLICATE KEY UPDATE  
akttek_all.`Number`= akttek.`Number`, 
akttek_all.`Data`= akttek.`Data`, 
akttek_all.`Clients_Ident` = akttek.`Clients_Ident`, 
akttek_all.`Sum`= akttek.`Sum`, 
akttek_all.`ReportReturn` = akttek.`ReportReturn`;

insert into paysheet_all select * from paysheet ON DUPLICATE KEY UPDATE  
paysheet_all.`Client_Ident`= paysheet.`Client_Ident`, 
paysheet_all.`Number`= paysheet.`Number`,
paysheet_all.`Dat`= paysheet.`Dat`, 
paysheet_all.`Sum`= paysheet.`Sum`;

insert into send_all select * from send ON DUPLICATE KEY UPDATE  
send_all.`Start`= send.`Start`,
send_all.`Inspector_Ident`= send.`Inspector_Ident`,
send_all.`ContractType_Ident`= send.`ContractType_Ident`,
send_all.`Client_Ident`= send.`Client_Ident`,
send_all.`Credit`= send.`Credit`,
send_all.`Contract`= send.`Contract`,
send_all.`Client_Ident_Sender`= send.`Client_Ident_Sender`,
send_all.`City_Ident`= send.`City_Ident`,
send_all.`DateSend`= send.`DateSend`,
send_all.`Acceptor_Ident`= send.`Acceptor_Ident`,
send_all.`Forwarder_Ident`= send.`Forwarder_Ident`,
send_all.`Rollout_Ident`= send.`Rollout_Ident`,
send_all.`Namegood_Ident`= send.`Namegood_Ident`,
send_all.`Typegood_Ident`= send.`Typegood_Ident`,
send_all.`Weight`= send.`Weight`,
send_all.`Volume`= send.`Volume`,
send_all.`CountWeight`= send.`CountWeight`,
send_all.`Tariff`= send.`Tariff`,
send_all.`Fare`= send.`Fare`,
send_all.`PackTarif`= send.`PackTarif`,
send_all.`AddServiceExp`= send.`AddServiceExp`,
send_all.`AddServicePack`= send.`AddServicePack`,
send_all.`AddServiceProp`= send.`AddServiceProp`,
send_all.`AddServicePrace`= send.`AddServicePrace`,
send_all.`InsuranceSum`= send.`InsuranceSum`,
send_all.`InsurancePercent`= send.`InsurancePercent`,
send_all.`InsuranceValue`= send.`InsuranceValue`,
send_all.`SumCount`= send.`SumCount`,
send_all.`Typegood_Ident1`= send.`Typegood_Ident1`,
send_all.`Typegood_Ident2`= send.`Typegood_Ident2`,
send_all.`Namber`= send.`Namber`,
send_all.`PayType_Ident`= send.`PayType_Ident`,
send_all.`NmberOrder`= send.`NmberOrder`,
send_all.`NumberCountPattern`= send.`NumberCountPattern`,
send_all.`PayText`= send.`PayText`,
send_all.`StatusSupp_Ident`= send.`StatusSupp_Ident`,
send_all.`DateSupp`= send.`DateSupp`,
send_all.`Supplier_Ident`= send.`Supplier_Ident`,
send_all.`SuppText`= send.`SuppText`,
send_all.`PackCount`= send.`PackCount`,
send_all.`ExpCount`= send.`ExpCount`,
send_all.`PropCount`= send.`PropCount`,
send_all.`ExpTarif`= send.`ExpTarif`,
send_all.`PropTarif`= send.`PropTarif`,
send_all.`Check`= send.`Check`,
send_all.`Train_Ident`= send.`Train_Ident`,
send_all.`SumWay`= send.`SumWay`,
send_all.`NumberWay`= send.`NumberWay`,
send_all.`SumServ`= send.`SumServ`,
send_all.`NumberServ`= send.`NumberServ`,
send_all.`WeightGd`= send.`WeightGd`,
send_all.`PlaceGd`= send.`PlaceGd`,
send_all.`NumberPP`= send.`NumberPP`,
send_all.`CountInvoice`= send.`CountInvoice`,
send_all.`PlaceC`= send.`PlaceC`,
send_all.`PayTypeServ_Ident`= send.`PayTypeServ_Ident`,
send_all.`PayTypeWay_Ident`= send.`PayTypeWay_Ident`,
send_all.`Invoice_Ident`= send.`Invoice_Ident`,
send_all.`InsurancePay`= send.`InsurancePay`,
send_all.`Akttek_Ident`= send.`Akttek_Ident`,
send_all.`AddServStr`= send.`AddServStr`,
send_all.`AddServSum`= send.`AddServSum`,
send_all.`Typegood_Ident3`= send.`Typegood_Ident3`,
send_all.`PrivilegedTariff`= send.`PrivilegedTariff`,
send_all.`CutTarif`= send.`CutTarif`,
send_all.`DateDelFirst`= send.`DateDelFirst`;

delete from invoice where `Data` < (select CURDATE()  - interval 6 month );
delete from account where `Dat` < (select CURDATE()  - interval 6 month );
delete from accounttek where `Dat` < (select CURDATE()  - interval 6 month );
delete from `order` where `Dat` < (select CURDATE()  - interval 6 month );
delete from akttek where `Data` < (select CURDATE()  - interval 6 month );
delete from paysheet where `Dat` < (select CURDATE()  - interval 6 month );
delete from send where `start` < (select CURDATE()  - interval 6 month );


END
