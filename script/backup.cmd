rem copy from dropbox
rem @echo off

set backup_path="W:\Dropbox\backup\"
set rfile=regiontrans_backup_19h.sql
set sfile=severtrans_backup_19h.sql
set rpfile=d:\work\regiontrans-mysql\script\regiontrans_backup_19h.sql
set spfile=d:\work\regiontrans-mysql\script\severtrans_backup_19h.sql


set host=192.168.1.40
set rport=3306
set sport=3307

set clients_file=d:\work\regiontrans-mysql\script\clients.txt

cd d:\work\regiontrans-mysql\script\

rem copy regiontrans
copy /y  %backup_path%%rfile% %rpfile%
rem copy severtrans
copy /y  %backup_path%%sfile% %spfile%

rem backup regiontrans
mysql --user=dba --password=sql --host=192.168.1.40 --port=%rport% severtrans < %rpfile%
rem backup severtrans
mysql --user=dba --password=sql --host=192.168.1.40 --port=%sport% severtrans < %spfile%
 
rem mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans ^
rem --execute="select `Ident`, `Acronym` , `Inn`, `KPP`, `Email`, `password`, `Saldo` from `clients`;" > %clients_file%

set clients_data=d:\work\regiontrans-mysql\script\clients_data.txt

mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans < "D:\work\regiontrans-mysql\script\get_clients_data.sql" > %clients_file%

python d:\work\regiontrans-mysql\script\regiontrans.py

winscp.exe sevtrans:0jq6szd9@ssh.sevtrans.nichost.ru /command ^
"option batch on" "option confirm off" "put D:/work/regiontrans-mysql/script/clients1.txt /home/sevtrans/clients1.txt" "exit"