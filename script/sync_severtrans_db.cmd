echo "set variables"
set current_dir=%cd%
echo "current_dir: " %current_dir%

set backup_path=%BACKUP_PATH%
echo "backup_path: " %backup_path%

set rfile=regiontrans_backup_19h.sql
set sfile=severtrans_backup_19h.sql
set rpfile=%current_dir%\regiontrans_backup_19h.sql
set spfile=%current_dir%\severtrans_backup_19h.sql

set host=%MYSQL_IP_ADDRESS%
echo "host: " %host%
set rport=3306
set sport=3307

cd %current_dir%

echo "copy regiontrans"
copy /y  %backup_path%%rfile% %rpfile%

echo "copy severtrans"
copy /y  %backup_path%%sfile% %spfile%

mysql --user=dba --password=sql --host=%host% --port=%rport% severtrans < %rpfile%
mysql --user=dba --password=sql --host=%host% --port=%sport% severtrans < %spfile%
 

