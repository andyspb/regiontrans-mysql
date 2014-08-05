# show tables;
# select * from clients;

DELETE FROM `sends`;

load data local infile '/home/sevtrans/sends1_severtrans.txt' 
replace
into table sends
ignore 1 lines
(id,ident,`number`,`date`,name,alias,sender,receiver,destination,weight,volume,seats,total,send_date);
