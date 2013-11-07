delimiter $$
alter table send_all 
drop foreign key `send_all_ibfk_16`,
ADD CONSTRAINT `send_all_ibfk_16` FOREIGN KEY (`Invoice_Ident`) REFERENCES `invoice_all` (`Ident`) ON DELETE SET NULL ON UPDATE CASCADE,
drop foreign key `send_all_ibfk_17`,
ADD CONSTRAINT `send_all_ibfk_17` FOREIGN KEY (`Akttek_Ident`) REFERENCES `akttek_all` (`IDENT`) ON DELETE SET NULL ON UPDATE CASCADE;
$$
