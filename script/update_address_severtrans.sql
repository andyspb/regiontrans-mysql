SET foreign_key_checks = 0;
load data local infile 'D:/work/regiontrans-mysql/script/address1_severtrans.txt' 
ignore
into table address
ignore 1 lines
(`AdrName`,`Clients_Ident`,`AddressType_Ident`);
