# show tables;
# select * from clients;

DELETE FROM `clients_severtrans`;

load data local infile '/home/sevtrans/clients1_severtrans_utf8.txt' 
replace
into table clients_severtrans
ignore 1 lines
(id,ident,name,alias,inn,kpp,email,password,saldo,kredit,city,address);
