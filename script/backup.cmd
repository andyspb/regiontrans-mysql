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
set clients_file_severtrans=d:\work\regiontrans-mysql\script\clients_severtrans.txt
set accounts_file_severtrans=d:\work\regiontrans-mysql\script\accounts_severtrans.txt
set accountstek_file_severtrans=d:\work\regiontrans-mysql\script\accountstek_severtrans.txt

cd d:\work\regiontrans-mysql\script\

rem copy regiontrans
copy /y  %backup_path%%rfile% %rpfile%
rem copy severtrans
copy /y  %backup_path%%sfile% %spfile%

rem backup regiontrans
rem mysql --user=dba --password=sql --host=192.168.1.40 --port=%rport% severtrans < %rpfile%
rem backup severtrans
mysql --user=dba --password=sql --host=192.168.1.40 --port=%sport% severtrans < %spfile%
 
rem mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans ^
rem --execute="select `Ident`, `Acronym` , `Inn`, `KPP`, `Email`, `password`, `Saldo` from `clients`;" > %clients_file%

set clients_data=d:\work\regiontrans-mysql\script\clients_data.txt

rem mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans < "D:\work\regiontrans-mysql\script\get_clients_data.sql" > %clients_file%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "D:\work\regiontrans-mysql\script\get_clients_data.sql" > %clients_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "D:\work\regiontrans-mysql\script\get_accounts_data.sql" > %accounts_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "D:\work\regiontrans-mysql\script\get_accountstek_data.sql" > %accountstek_file_severtrans%

rem python d:\work\regiontrans-mysql\script\regiontrans.py
python d:\work\regiontrans-mysql\script\severtrans.py
python d:\work\regiontrans-mysql\script\severtrans_accounts.py

rem winscp.exe sevtrans:0jq6szd9@ssh.sevtrans.nichost.ru /command ^
rem "option batch on" "option confirm off" "put D:/work/regiontrans-mysql/script/clients1.txt /home/sevtrans/clients1.txt" "exit"

winscp.exe sevtrans:0jq6szd9@ssh.sevtrans.nichost.ru /command ^
"option batch on" "option confirm off" "put D:/work/regiontrans-mysql/script/clients1_severtrans.txt /home/sevtrans/clients1_severtrans.txt" "exit"

winscp.exe sevtrans:0jq6szd9@ssh.sevtrans.nichost.ru /command ^
"option batch on" "option confirm off" "put D:/work/regiontrans-mysql/script/accounts1_severtrans.txt /home/sevtrans/accounts1_severtrans.txt" "exit"
