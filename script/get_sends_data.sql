select 
`send_all`.`Ident`,
`clients`.`Name`,
`clients`.`Acronym`
from `clients`, `send_all` 
where `clients`.`Ident`=`send_all`.`Client_Ident`
;