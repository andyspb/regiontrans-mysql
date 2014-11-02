echo "set variables"
set current_dir=%cd%
echo "current_dir: " %current_dir%

set backup_path=%BACKUP_PATH%
echo "backup_path: " %backup_path%

set rfile=regiontrans_backup_19h.sql
set sfile=severtrans_backup_19h.sql
set rpfile=%current_dir%\regiontrans_backup_19h.sql
set spfile=%current_dir%\severtrans_backup_19h.sql

rem set your server ip
set host=%MYSQL_IP_ADDRESS%
echo "host: " %host%
set rport=3306
set sport=3307

set clients_file=%current_dir%\clients.txt
set clients_file_severtrans=%current_dir%\clients_severtrans.txt
set accounts_file_severtrans=%current_dir%\accounts_severtrans.txt
set accountstek_file_severtrans=%current_dir%\accountstek_severtrans.txt
set sends_file_severtrans=%current_dir%\sends_severtrans.txt
set invoices_file_severtrans=%current_dir%\invoices_severtrans.txt
set paysheets_file_severtrans=%current_dir%\paysheets_severtrans.txt
set aktstek_file_severtrans=%current_dir%\aktstek_severtrans.txt


cd %current_dir%

echo "copy regiontrans"
copy /y  %backup_path%%rfile% %rpfile%
echo "copy severtrans"
copy /y  %backup_path%%sfile% %spfile%

rem backup regiontrans
rem mysql --user=dba --password=sql --host=192.168.1.40 --port=%rport% severtrans < %rpfile%
rem backup severtrans
mysql --user=dba --password=sql --host=%host% --port=%sport% severtrans < %spfile%
 
rem mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans ^
rem --execute="select `Ident`, `Acronym` , `Inn`, `KPP`, `Email`, `password`, `Saldo` from `clients`;" > %clients_file%

set clients_data=%current_dir%\clients_data.txt

rem mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans < "D:\work\regiontrans-mysql\script\get_clients_data.sql" > %clients_file%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_clients_data.sql" > %clients_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_accounts_data.sql" > %accounts_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_accountstek_data.sql" > %accountstek_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_sends_data.sql" > %sends_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_invoices_data.sql" > %invoices_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_paysheets_data.sql" > %paysheets_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_aktstek_data.sql" > %aktstek_file_severtrans%

rem python d:\work\regiontrans-mysql\script\regiontrans.py
python %current_dir%\severtrans_clients.py
python %current_dir%\severtrans_accounts.py
python %current_dir%\severtrans_sends.py
python %current_dir%\severtrans_invoices.py
python %current_dir%\severtrans_paysheets.py

rem winscp.exe sevtrans:0jq6szd9@ssh.sevtrans.nichost.ru /command ^
rem "option batch on" "option confirm off" "put D:/work/regiontrans-mysql/script/clients1.txt /home/sevtrans/clients1.txt" "exit"

winscp.exe sevtrans:0jq6szd9@ssh.sevtrans.nichost.ru /command ^
"option batch on" "option confirm off" "put D:/work/regiontrans-mysql/script/clients1_severtrans.txt /home/sevtrans/clients1_severtrans.txt" "exit"

winscp.exe sevtrans:0jq6szd9@ssh.sevtrans.nichost.ru /command ^
"option batch on" "option confirm off" "put D:/work/regiontrans-mysql/script/accounts1_severtrans.txt /home/sevtrans/accounts1_severtrans.txt" "exit"

winscp.exe sevtrans:0jq6szd9@ssh.sevtrans.nichost.ru /command ^
"option batch on" "option confirm off" "put D:/work/regiontrans-mysql/script/sends1_severtrans.txt /home/sevtrans/sends1_severtrans.txt" "exit"

winscp.exe sevtrans:0jq6szd9@ssh.sevtrans.nichost.ru /command ^
"option batch on" "option confirm off" "put D:/work/regiontrans-mysql/script/invoices1_severtrans.txt /home/sevtrans/invoices1_severtrans.txt" "exit"

winscp.exe sevtrans:0jq6szd9@ssh.sevtrans.nichost.ru /command ^
"option batch on" "option confirm off" "put D:/work/regiontrans-mysql/script/paysheets1_severtrans.txt /home/sevtrans/paysheets1_severtrans.txt" "exit"
