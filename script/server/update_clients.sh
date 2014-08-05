#!/bin/sh
# mysql --user=sevtrans_mysql --password=hyaoexrj --local-infile=1 sevtrans_regiontrans < /home/sevtrans/update.sql

iconv -f "windows-1251" -t "UTF-8" clients1_severtrans.txt > clients1_severtrans_utf8.txt
iconv -f "windows-1251" -t "UTF-8" accounts1_severtrans.txt > accounts1_severtrans_utf8.txt
#iconv -f "windows-1251" -t "UTF-8" sends1_severtrans.txt > sends1_severtrans_utf8.txt
mysql --user=sevtrans_mysql --password=hyaoexrj --local-infile=1 sevtrans_regiontrans < /home/sevtrans/update_clients_severtrans.sql
mysql --user=sevtrans_mysql --password=hyaoexrj --local-infile=1 sevtrans_regiontrans < /home/sevtrans/update_accounts_severtrans.sql
#comment these 2 lines when done
#mysql --user=sevtrans_mysql --password=hyaoexrj --local-infile=1 sevtrans_regiontrans < /home/sevtrans/update_clients_severtrans_emails.sql
#mysql --user=sevtrans_mysql --password=hyaoexrj --local-infile=1 sevtrans_regiontrans < /home/sevtrans/update_clients_severtrans_emails_30210_27404.sql
mysql --user=sevtrans_mysql --password=hyaoexrj --local-infile=1 sevtrans_regiontrans < /home/sevtrans/update_sends_severtrans.sql
mysql --user=sevtrans_mysql --password=hyaoexrj --local-infile=1 sevtrans_regiontrans < /home/sevtrans/update_invoices_severtrans.sql
mysql --user=sevtrans_mysql --password=hyaoexrj --local-infile=1 sevtrans_regiontrans < /home/sevtrans/update_paysheets_severtrans.sql

echo "Update date: " $(date +"%m-%d-%Y") > /home/sevtrans/update_date.txt
