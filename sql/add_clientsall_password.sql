CREATE ALGORITHM=UNDEFINED DEFINER=`dba`@`%` SQL SECURITY DEFINER VIEW `clientsall` 
AS select `c`.`Ident` AS `Ident`,`c`.`Name` AS `Name`,`c`.`Acronym` AS `Acronym`,`c`.`FullName` 
AS `FullName`,`c`.`Telephone` AS `Telephone`,`c`.`Fax` AS `Fax`,`c`.`Email` AS `Email`,`c`.`INN` 
AS `INN`,`c`.`CalculatCount` AS `CalculatCount`,`c`.`Bank_Ident` AS `Bank_Ident`,`c`.`Bank` 
AS `Bank`,`c`.`OKONX` AS `OKONX`,`c`.`OKPO` AS `OKPO`,`c`.`GDContract` AS `GDContract`,
`c`.`AVTContract` AS `AVTContract`,`c`.`InPerson` AS `InPerson`,`c`.`PersonType_Ident` 
AS `PersonType_Ident`,`c`.`PersonType` AS `PersonType`,`c`.`OnReason_Ident` 
AS `OnReason_Ident`,`c`.`OnReason` AS `OnReason`,`c`.`ClientType_Ident`
AS `ClientType_Ident`,
`c`.`password` AS `password`,
`c`.`ClientType` AS `ClientType`,`c`.`Start` AS `Start`,`c`.`DateUpd` 
AS `DateUpd`,`c`.`Finish` AS `Finish`,`c`.`City_Ident` AS `City_Ident`,`c`.`City` 
AS `City`,`c`.`Country_Ident` AS `Country_Ident`,`c`.`Country` AS `Country`,`c`.`Contact` 
AS `Contact`,`RowNumber`() AS `Num` from (`clientsall1` `c` join `numbernull`)