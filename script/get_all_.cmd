
set host=192.168.1.40
set sport=3307
set rport=3306
set severtrans_clients_file=severtrans_2015_clients.txt
set regiontrans_clients_file=regiontrans_clients.txt
set severtrans_sends_file=severtrans_2015_sends.txt
set regiontrans_sends_file=regiontrans_sends.txt



mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans ^
--execute="select * from `clients` left join `city` on `clients`.`City_Ident`=`City`.`Ident` left join `address` on `clients`.`Ident`=`address`.`Clients_Ident` where `address`.`AddressType_Ident`=1 ;" > %severtrans_clients_file%

mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans ^
--execute="select * from `clients` left join `city` on `clients`.`City_Ident`=`City`.`Ident` left join `address` on `clients`.`Ident`=`address`.`Clients_Ident` where `address`.`AddressType_Ident`=1;" > %regiontrans_clients_file%

mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans ^
--execute="select * from `sends_all`;" > %severtrans_sends_file%

mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans ^
--execute="select * from `sends_all`;" > %regiontrans_sends_file%



