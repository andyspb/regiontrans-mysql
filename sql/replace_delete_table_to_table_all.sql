replace into send_all select * from send;
delete from send where `start` < (select CURDATE()  - interval 1 year );

replace into invoice_all select * from invoice;
delete from invoice where `Data` < (select CURDATE()  - interval 1 year );

replace into account_all select * from account;
delete from account where `Dat` < (select CURDATE()  - interval 1 year );

replace into accounttek_all select * from accounttek;
delete from accounttek where `Dat` < (select CURDATE()  - interval 1 year );

replace into order_all select * from `order`;
delete from `order` where `Dat` < (select CURDATE()  - interval 1 year );

replace into akttek_all select * from akttek;
delete from akttek where `Data` < (select CURDATE()  - interval 1 year );

replace into paysheet_all select * from paysheet;
delete from paysheet where `Dat` < (select CURDATE()  - interval 1 year );
