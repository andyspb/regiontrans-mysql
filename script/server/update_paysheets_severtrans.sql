DELETE FROM `paysheets`;

load data local infile '/home/sevtrans/paysheets1_severtrans.txt' 
replace
into table paysheets
ignore 1 lines
(id,ident,`number`,name,alias,`date`,`sum`);
