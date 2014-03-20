#!/bin/sh
mysql --user=sevtrans_mysql --password=hyaoexrj --local-infile=1 sevtrans_regiontrans < /home/sevtrans/update.sql
echo "Update date: " $(date +"%m-%d-%Y") > /home/sevtrans/update_date.txt
