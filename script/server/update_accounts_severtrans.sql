# show tables;
# select * from clients;

DELETE FROM `accounts`;

load data local infile '/home/sevtrans/accounts1_severtrans_utf8.txt' 
replace
into table accounts
ignore 1 lines
(id,ident,name,alias,account_date,account_number,nds,`sum`,sum_with_nds);
