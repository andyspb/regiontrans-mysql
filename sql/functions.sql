DELIMITER $$

CREATE DEFINER=`dba`@`localhost` FUNCTION `NumberNull`() RETURNS int(11)
    DETERMINISTIC
begin
      return @number:=0;
   end
$$   
DELIMITER $$

CREATE DEFINER=`dba`@`localhost` FUNCTION `booksel_ClearFee`( a varchar(10), i varchar(12)) RETURNS varchar(12) CHARSET cp1251
    DETERMINISTIC
BEGIN
	 DECLARE C VARCHAR(12);
     IF  a < '2004-01-01' THEN 
	 SET C = cast(cast(i-cast(i*1/6 as decimal(10,2)) as decimal(10,2)) as char(12));
	 ELSE SET C = cast(cast(i-cast(i*18/118 as decimal(10,2)) as decimal(10,2)) as char(12));
	 END IF;
     RETURN C;
    END
$$

DELIMITER $$

CREATE DEFINER=`dba`@`localhost` FUNCTION `RefContract`(t integer, Id integer) RETURNS varchar(60) CHARSET cp1251
begin
  declare Str varchar(60);
  select Concat(`Number`,', ',DAY(`Start`),'.',MONTH(`Start`),'.',YEAR(`Start`)) as S into Str
    from severtrans.Contract where ContractType_Ident=t  and Clients_Ident=Id;
  return(str);
end
$$
DELIMITER $$

CREATE DEFINER=`dba`@`localhost` FUNCTION `booksel_NDSFee`( a varchar(10), i varchar(12)) RETURNS varchar(12) CHARSET cp1251
    DETERMINISTIC
BEGIN
	 DECLARE C VARCHAR(12);
     IF  a < '2004-01-01' THEN 
	 SET C = cast(cast(i*1/6 as decimal(10,2)) as char(12));
	 ELSE SET C = cast(cast(i*18/118 as decimal(10,2)) as char(12));
	 END IF;
     RETURN C;
    END
$$
DELIMITER $$

CREATE DEFINER=`dba`@`localhost` FUNCTION `Report_return`( a int) RETURNS varchar(10) CHARSET cp1251
    DETERMINISTIC
BEGIN
	 DECLARE C VARCHAR(10);
     IF  a = 1 THEN SET C = 'верн.';
	 ELSE SET C = 'не верн.';
	 END IF;
     RETURN C;
    END
$$
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fillnumbers`()
begin
declare i int default 0;
insert_loop: LOOP
  set i:=i+1;
  select i;
  if i < 10000000 then
      insert into severtrans.numbers values (i);
  else 
      LEAVE insert_loop;
  END IF;    
END LOOP insert_loop;
end
$$
DELIMITER $$

CREATE DEFINER=`dba`@`localhost` FUNCTION `RowNumber`() RETURNS int(11)
    DETERMINISTIC
begin
       return if(@number, @number:=@number+1, @number:=1);
   end
$$
DELIMITER $$

CREATE DEFINER=`dba`@`localhost` FUNCTION `InvoiceNumDiff`(a int) RETURNS int(11)
    DETERMINISTIC
BEGIN
     DECLARE c int;
     SELECT @InvoiceNum INTO c;
     SET @InvoiceNum = a;
	 SET c = a-c;
     RETURN c-1;
    END
$$
DELIMITER $$

CREATE DEFINER=`dba`@`localhost` FUNCTION `TP_return`( a int) RETURNS varchar(10) CHARSET cp1251
    DETERMINISTIC
BEGIN
	 DECLARE C VARCHAR(10);
     IF  a = 1 THEN SET C = 'Теплый';
	 ELSE SET C = '';
	 END IF;
     RETURN C;
    END
$$
DELIMITER $$

CREATE DEFINER=`dba`@`localhost` FUNCTION `Moskow`( a int) RETURNS varchar(10) CHARSET cp1251
    DETERMINISTIC
BEGIN
	 DECLARE C VARCHAR(10);
     IF  a = 1 THEN SET C = 'Ч/З Москву';
	 ELSE SET C = '';
	 END IF;
     RETURN C;
    END
$$
DELIMITER $$

CREATE DEFINER=`dba`@`localhost` FUNCTION `TP1_return`( a int) RETURNS varchar(10) CHARSET cp1251
    DETERMINISTIC
BEGIN
	 DECLARE C VARCHAR(10);
     IF  a = 1 THEN SET C = 'Хрупкий';
	 ELSE SET C = '';
	 END IF;
     RETURN C;
    END
$$
DELIMITER $$

CREATE DEFINER=`root`@`localhost` FUNCTION `Number`() RETURNS int(11)
    DETERMINISTIC
BEGIN
     DECLARE c int;
     SELECT @counter INTO c;
     SET @counter = c+1;
     RETURN c+1;
    END
$$
DELIMITER $$

CREATE DEFINER=`dba`@`localhost` FUNCTION `TP2_return`( a int) RETURNS varchar(10) CHARSET cp1251
    DETERMINISTIC
BEGIN
	 DECLARE C VARCHAR(10);
     IF  a = 1 THEN SET C = 'Негабаритный';
	 ELSE SET C = '';
	 END IF;
     RETURN C;
    END
$$
DELIMITER ;