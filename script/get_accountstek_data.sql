select 
`clients`.`Ident`,
`clients`.`Name`,
`clients`.`Acronym`,
`accounttekview_all`.`Dat`,
`accounttekview_all`.`Number`,
`accounttekview_all`.`sum`
from `clients`, `accounttekview_all` 
where `clients`.`Ident`=`accounttekview_all`.`Client_Ident`
;