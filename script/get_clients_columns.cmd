#
#mysqldump --user=dba --password=sql --host=192.168.1.40 severtrans clients > clients.sql

mysql --user=dba --password=sql --host=192.168.1.40 --port=3306 --database=severtrans ^
--execute="select `Ident`, `Acronym` , `Inn`, `KPP`, `Email`, `password`, `Saldo` from `clients`;" -X > clients.xml

mysql --user=dba --password=sql --host=192.168.1.40 --port=3306 --database=severtrans ^
--execute="select `Ident`, `Acronym` , `Inn`, `KPP`, `Email`, `password`, `Saldo` from `clients`;" > clients.txt


#mysql --user=dba --password=sql --host=192.168.1.40 --port=3306 --database=severtrans ^
#--execute="SELECT * FROM `clients` LIMIT 0, 40000;" -X > file.xml