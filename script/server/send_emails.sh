#!/bin/sh

cd $HOME/severtrans-spb.ru/docs/ 
/opt/php/bin/php -c $HOME/etc/php.ini $HOME/severtrans-spb.ru/docs/testreg1.php >/dev/null 2>&1

echo "Emails date: " $(date +"%m-%d-%Y") > /home/sevtrans/emails_date.txt
