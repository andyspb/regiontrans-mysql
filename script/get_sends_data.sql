SELECT
`send_all`.`Ident`,
`send_all`.`Namber`,
`send_all`.`Start`,
`send_all`.`Client_Ident`,
`send_all`.`Client_Ident_Sender`,
`send_all`.`Acceptor_Ident`,
`send_all`.`City_Ident`,
`send_all`.`Weight`,
`send_all`.`Volume`,
`send_all`.`PackCount`,
`send_all`.`SumCount`,
`send_all`.`DateSend`,
`send_all`.`Invoice_Ident`,
`send_all`.`Akttek_Ident`
FROM `severtrans`.`send_all`;
