DELETE FROM `invoices`;

load data local infile '/home/sevtrans/invoices1_severtrans.txt' 
replace
into table invoices
ignore 1 lines
(id,ident,`number`,`date`,name,alias,`sum`,nds, `return`);
