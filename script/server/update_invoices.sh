#!/bin/sh
# mysql --user=sevtrans_mysql --password=hyaoexrj --local-infile=1 sevtrans_regiontrans < /home/sevtrans/update.sql

mysql --user=sevtrans_mysql --password=hyaoexrj --local-infile=1 sevtrans_regiontrans < /home/sevtrans/update_invoices_severtrans.sql
