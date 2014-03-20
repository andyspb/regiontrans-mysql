
# copy from dropbox

#copy /y "W:\Dropbox\backup\regiontrans_backup_19h.sql"  regiontrans_backup_19h.sql

#mysql --user=dba --password=sql --host=192.168.1.40 --port=3306 severtrans < regiontrans_backup_19h.sql
 
set host=192.168.1.40
set rport=3306
set sport=3307
set clients_data=d:\work\regiontrans-mysql\script\clients_data.txt

mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans < "D:\work\regiontrans-mysql\script\get_clients_data.sql" ^
> %clients_data%
