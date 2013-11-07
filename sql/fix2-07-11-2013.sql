select * into outfile 'd:\\send.txt '  from `send` where `ident`<91516; 
load data local infile 'd:\\send.txt' replace into table `send_all`;
select Ident, Start, Akttek_Ident from send_all where Client_Ident=20168 ;