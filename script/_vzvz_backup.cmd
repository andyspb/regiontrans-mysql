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

set s_clients_file=%current_dir%\s_clients.txt
set s_clients_file_severtrans=%current_dir%\s_clients_severtrans.txt
set s_accounts_file_severtrans=%current_dir%\s_accounts_severtrans.txt
set s_accountstek_file_severtrans=%current_dir%\s_accountstek_severtrans.txt
set s_sends_file_severtrans=%current_dir%\s_sends_severtrans.txt
set s_invoices_file_severtrans=%current_dir%\s_invoices_severtrans.txt
set s_paysheets_file_severtrans=%current_dir%\s_paysheets_severtrans.txt
set s_aktstek_file_severtrans=%current_dir%\s_aktstek_severtrans.txt

set r_clients_file=%current_dir%\r_clients.txt
set r_clients_file_severtrans=%current_dir%\r_clients_severtrans.txt
set r_accounts_file_severtrans=%current_dir%\r_accounts_severtrans.txt
set r_accountstek_file_severtrans=%current_dir%\r_accountstek_severtrans.txt
set r_sends_file_severtrans=%current_dir%\r_sends_severtrans.txt
set r_invoices_file_severtrans=%current_dir%\r_invoices_severtrans.txt
set r_paysheets_file_severtrans=%current_dir%\r_paysheets_severtrans.txt
set r_aktstek_file_severtrans=%current_dir%\r_aktstek_severtrans.txt

cd %current_dir%

echo "copy regiontrans"
copy /y  %backup_path%%rfile% %rpfile%
echo "copy severtrans"
copy /y  %backup_path%%sfile% %spfile%

rem backup severtrans
mysql --user=dba --password=sql --host=%host% --port=%sport% severtrans < %spfile%
rem backup regiontrans
mysql --user=dba --password=sql --host=%host% --port=%rport% severtrans < %rpfile%
 
rem mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans ^
rem --execute="select `Ident`, `Acronym` , `Inn`, `KPP`, `Email`, `password`, `Saldo` from `clients`;" > %clients_file%

mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_all_clients_data.sql" > %s_clients_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_all_accounts_data.sql" > %s_accounts_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_all_accountstek_data.sql" > %s_accountstek_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_all_sends_data.sql" > %s_sends_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_all_invoices_data.sql" > %s_invoices_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_all_paysheets_data.sql" > %s_paysheets_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "%current_dir%\get_all_aktstek_data.sql" > %s_aktstek_file_severtrans%

mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans < "%current_dir%\get_all_clients_data.sql" > %r_clients_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans < "%current_dir%\get_all_accounts_data.sql" > %r_accounts_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans < "%current_dir%\get_all_accountstek_data.sql" > %r_accountstek_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans < "%current_dir%\get_all_sends_data.sql" > %r_sends_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans < "%current_dir%\get_all_invoices_data.sql" > %r_invoices_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans < "%current_dir%\get_all_paysheets_data.sql" > %r_paysheets_file_severtrans%
mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans < "%current_dir%\get_all_aktstek_data.sql" > %r_aktstek_file_severtrans%


