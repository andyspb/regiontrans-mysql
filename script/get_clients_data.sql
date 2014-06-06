select 
`clients`.`Ident`, 
`clients`.`Name` , 
`clients`.`Acronym` , 
`clients`.`Inn`, 
`clients`.`KPP`, 
`clients`.`Email`,
`clients`.`password`, 
`clients`.`Saldo`, 
`clients`.`Kredit`, 
`city`.`Name`,
`address`.`AdrName`
from `clients` 
left join `city` 
on `clients`.`City_Ident`=`City`.`Ident`
left join `address`
on `clients`.`Ident`=`address`.`Clients_Ident` where `address`.`AddressType_Ident`=1;