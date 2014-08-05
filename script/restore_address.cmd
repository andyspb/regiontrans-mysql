rem copy from dropbox
rem @echo off

set current_dir=%cd%
echo %current_dir%

set backup_path="w:\dropbox\backup\"
set rfile=regiontrans_backup_19h.sql
set sfile=severtrans_backup_19h.sql
set rpfile=%current_dir%\regiontrans_backup_19h.sql
set spfile=%current_dir%\severtrans_backup_19h.sql


set host=192.168.1.40
set rport=3306
set sport=3307

set s_file=%current_dir%\address_severtrans.txt
set r_file=%current_dir%\address_regiontrans.txt

cd d:\work\regiontrans-mysql\script\

rem copy regiontrans
copy /y  %backup_path%%rfile% %rpfile%
rem copy severtrans
copy /y  %backup_path%%sfile% %spfile%

mysql --user=dba --password=sql --host=192.168.1.40 --port=%rport% severtrans < %rpfile%
mysql --user=dba --password=sql --host=192.168.1.40 --port=%sport% severtrans < %spfile%
 
mysql --user=dba --password=sql --host=%host% --port=%rport% --database=severtrans < "D:\work\regiontrans-mysql\script\get_address_data.sql" > %r_file%
mysql --user=dba --password=sql --host=%host% --port=%sport% --database=severtrans < "D:\work\regiontrans-mysql\script\get_address_data.sql" > %s_file%
