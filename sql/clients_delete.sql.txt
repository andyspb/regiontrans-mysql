delete from clients where not exists (select distinct Client_ident,Client_Ident_sender from send as b where (clients.Ident=b.Client_ident or clients.Ident=b.Client_Ident_sender )) and 
not exists (select distinct Client_ident from account where clients.Ident=account.Client_ident) and 
not exists (select distinct Client_ident from accounttek where clients.Ident=accounttek.Client_ident) and 
not exists (select distinct Clients_ident from akttek where clients.Ident=akttek.Clients_ident) and
not exists (select distinct Client_ident from paysheet where clients.Ident=paysheet.Client_ident) and
not exists (select distinct Clients_Ident from invoice where clients.Ident=invoice.Clients_Ident) and
not exists (select distinct Client_ident from `order` where clients.Ident=`order`.Client_ident);