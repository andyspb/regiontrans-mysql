# show tables;
# select * from clients;
load data local infile '/home/sevtrans/clients1_severtrans.txt' 
replace
into table clients
ignore 1 lines
(id,alias,inn,kpp,email,password,saldo,kredit,city,address);
