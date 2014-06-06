select 
`clients`.`Ident`,
`clients`.`Name`,
`clients`.`Acronym`,
`accountview_all`.`Dat`,
`accountview_all`.`Number`,
`accountview_all`.`SumNDS`
from `clients`, `accountview_all` 
where `clients`.`Ident`=`accountview_all`.`Client_Ident`
;