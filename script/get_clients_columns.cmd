rem 
rem mysqldump --user=dba --password=sql --host=192.168.1.40 severtrans clients > clients.sql

rem mysql --user=dba --password=sql --host=192.168.1.40 --port=3306 --database=severtrans --execute="select `Ident`, `Acronym` , `Inn`, `KPP`, `Email`, `password`, `Saldo` from `clients`;" -X > clients.xml

set host=192.168.1.40
set rport=3306
set clients_file=clients.txt

mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans ^
--execute="select `Ident`, `Acronym` , `Inn`, `KPP`, `Email`, `password`, `Saldo` from `clients`;" > %clients_file%


#mysql --user=dba --password=sql --host=192.168.1.40 --port=3306 --database=severtrans ^
#--execute="SELECT * FROM `clients` LIMIT 0, 40000;" -X > file.xml