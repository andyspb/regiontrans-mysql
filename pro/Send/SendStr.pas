unit SendStr;

interface

uses
  Windows, Messages, SysUtils, Variants,Controls,DateUtils,SqlGrid, Dialogs,
  DB, DBTables, TSQLCLS, EntrySec;
  //public
  // { Public declarations }
  function MoneyToString(Money:string):string;
  function NumberToString(Money:string):string;
  function Money00(Money:string):string;
  function String000(Str:string;i:integer):string;
  Function String0(t:string;j:integer):string;
  function String00(str:string;k:integer):string;
  function StrTo00(s:string):string;
  Function DayToDate(s:string;D:TDate):TDate;
  function SToDate(str:string;D:TDate):Tdate ;
  Function Credit(id:longint):string;
  Function CreditUpdate(id:longint;kreditTek:string):string;
  Function CreditDate(id:longint;Dat:Tdate):string;
  Function CreditDate2004(id:longint;Dat:Tdate):string;
  Function CreditDate2007(id:longint;Dat:Tdate):string;
  Function CreditType(id,l:longint):string;
  Function CreditTypeDate(id,l:longint;D1,D2:TDate):string;
  function DataDMstrY(d:Tdate):string;

implementation

Function CreditTypeDate(id,l:longint;D1,D2:TDate):string;
var
  Sum,Sum1:real;
  q:TQUEry;
  DateStart,DateFin:TDate;
begin
  if D2<D1 then
  begin
    Datestart:=D2;
    Datefin:=D1;
  end
  else
  begin
    DateStart:=D1;
    DateFin:=D2;
  end;
  Sum:=0;
  Sum1:=0;
  if id<>0 then
  begin
{if l=2 then
begin
  q:=sql.select(EntrySec.send_table,'SumCount,Client_Ident,PayType_Ident','Client_Ident='+
                 IntToStr(Id)+' and PayType_Ident='+IntToStr(l)+
                 ' and `Start` >= '+sql.MakeStr(FormatDateTime('yyyy-mm-dd',DateStart))+
                 ' and `Start`<= '+sql.MakeStr(FormatDateTime('yyyy-mm-dd',DateFin)),'');
  while (not q.eof) do      {считаем сумму по всем отправкам c нал оплатой-}
{  begin
  Sum:=Sum+StrToFloat(q.FieldByName('SumCount').asString);
  q.Next;
  end;
  q:=sql.select(EntrySec.order_table,'SumNDS,Client_Ident','Client_Ident='+IntToStr(Id),'');
  while not q.eof do      {считаем сумму по всем приходникам +}
{  begin
  Sum1:=Sum1+StrToFloat(q.FieldByName('SumNDS').asString);
  q.Next;
  end;
  if Sum>Sum1 then CreditTypeDate:='-'+FloatToStr(Sum-Sum1)
   else CreditTypeDate:=FloatToStr(Sum1-Sum) ;
  q.Free;
end else }
    if l=1 then
    begin
      q:=sql.select(EntrySec.send_table{'Send'},'SumCount,Client_Ident,PayType_Ident','Client_Ident='+
                         IntToStr(Id)+' and PayType_Ident='+IntToStr(l)+
                         ' and `Start` >= '+sql.MakeStr(FormatDateTime('yyyy-mm-dd',DateStart))+
                         ' and `Start`<= '+sql.MakeStr(FormatDateTime('yyyy-mm-dd',DateFin)),'');
      while (not q.eof) do      {считаем сумму по всем отправкам c безнал оплатой-}
      begin
        Sum:=Sum+q.FieldByName('SumCount').asfloat;
        q.Next;
      end;
{        q:=sql.select(EntrySec.paysheet_table,'Sum,Client_Ident','Client_Ident='+IntToStr(Id),'');
         while not q.eof do      {считаем сумму по всем платежкам +}
{         begin
         Sum1:=Sum1+StrToFloat(q.FieldByName('Sum').asString);
         q.Next;
         end;
       if Sum>Sum1 then CreditTypeDate:='-'+FloatToStr(Sum-Sum1)
          else CreditTypeDate:=FloatToStr(Sum1-Sum) ;    }
      CreditTypeDate:=FloatToStr(Sum) ;
      q.Free;
    end;
  end
  else
    CreditTypeDate:='0';
end;

Function CreditType(id,l:longint):string;
var
  Sum,Sum1:real;
  S1,S2:string;
  q:TQUEry;
begin
  Sum:=0;
  Sum1:=0;
  if id<>0 then
  begin
    if l=2 then
    begin
      q:=sql.select(EntrySec.send_table {'Send'},'SumCount,Client_Ident,PayType_Ident','Client_Ident='+
                 IntToStr(Id)+' and PayType_Ident='+IntToStr(l),'');
    while (not q.eof) do      {считаем сумму по всем отправкам c нал оплатой-}
    begin
      Sum:=Sum+q.FieldByName('SumCount').asfloat;
      q.Next;
    end;
    q.Free;
    q:=sql.select(EntrySec.order_table {'`Order`'},'SumNDS,Client_Ident','Client_Ident='+IntToStr(Id),'');
    while not q.eof do      {считаем сумму по всем приходникам +}
    begin
      Sum1:=Sum1+q.FieldByName('SumNDS').asfloat;
      q.Next;
    end;
    q.Free;
    S1:='';
    S2:='';
    S1:=FloatToStr(Sum);
    S2:=FloatToStr(Sum1);
    S2:=StrTo00(S2);
    S1:=StrTo00(S1);
    if (S1=S2) then
      CreditType:='0.00'
    else
      CreditType:=FloatToStr(Sum1-Sum);
  end
  else
  if l=1 then
  begin
    q:=sql.select(EntrySec.send_table{'Send'},'SumCount,Client_Ident,PayType_Ident','Client_Ident='+
                         IntToStr(Id)+' and PayType_Ident='+IntToStr(l),'');
    while (not q.eof) do      {считаем сумму по всем отправкам c безнал оплатой-}
    begin
      Sum:=Sum+q.FieldByName('SumCount').asfloat;
      q.Next;
    end;
    q.Free;
    q:=sql.select(EntrySec.paysheet_table {'PaySheet'},'Sum,Client_Ident','Client_Ident='+IntToStr(Id),'');
    while not q.eof do      {считаем сумму по всем платежкам +}
    begin
      Sum1:=Sum1+q.FieldByName('Sum').asfloat;
      q.Next;
    end;
    q.Free;
    S1:='';
    S2:='';
    S1:=FloatToStr(Sum);
    S2:=FloatToStr(Sum1);
    S2:=StrTo00(S2);
    S1:=StrTo00(S1);
    if (S1=S2) then
      CreditType:='0.00'
    else
      CreditType:=FloatToStr(Sum1-Sum);
    end;
  end
  else
    CreditType:='0';
end;


Function Credit(id:longint):string;
var
  Sum,Sum1:real;
  s1,s2,s3:string;
  q:TQUEry;
begin
  Sum:=0;   {-}
  Sum1:=0;  {+}
  if id<>0 then
  begin
    q:=sql.select(EntrySec.send_table {'Send'},'SumCount,Client_Ident','Client_Ident='+IntToStr(Id),'');
    while (not q.eof) do      {считаем сумму по всем отправкам -}
    begin
      Sum:=Sum+q.FieldByName('SumCount').asfloat;
      q.Next;
    end;
    q.Free;
    //---------------------
    q:=sql.select(EntrySec.order_table {'`Order`'},'SumNDS,Client_Ident','Client_Ident='+IntToStr(Id),'');
    while not q.eof do      {считаем сумму по всем приходникам +}
    begin
      Sum1:=Sum1+q.FieldByName('SumNDS').asfloat;
      q.Next;
    end;
    q.Free;
    //----------------------
    q:=sql.select(EntrySec.paysheet_table {'PaySheet'},'Sum,Client_Ident','Client_Ident='+IntToStr(Id),'');
    while not q.eof do      {считаем сумму по всем платежкам +}
    begin
      if pos('-',q.FieldByName('Sum').asstring)<>0  then
      begin
        s3:= q.FieldByName('Sum').asstring  ;
        Delete(s3,1,1);
      end;
      if pos('-',q.FieldByName('Sum').asstring)=0  then
        Sum1:=Sum1+q.FieldByName('Sum').asfloat
      else
      if (FloatToStr(Sum1) = s3)then
        Sum1:=0
      else
        Sum1:=Sum1+q.FieldByName('Sum').asfloat;
      q.Next;
    end;
    q.Free;
    //---------------------
    q:=sql.select('Clients','KreditTEK','Ident='+IntToStr(Id),'');
    if (trim(q.FieldByName('KreditTEK').asstring) <> '') then
    begin
      if (pos('-',q.FieldByName('KreditTEK').asstring)=0) then
      begin
        Sum1:=Sum1+q.FieldByName('KreditTEK').asFloat    {+}
      end
      else
      begin
        s3:= q.FieldByName('KreditTEK').asstring  ;
        Delete(s3,1,1);
        Sum:=Sum+ StrToFloat(s3);       {-}
      end;
    end;
    q.Free;
    //---------------------
    S1:='';
    S2:='';
    S1:=FloatToStr(Sum);
    S2:=FloatToStr(Sum1);
    S2:=StrTo00(S2);
    S1:=StrTo00(S1);
    if (S1=s2) then
      Credit:='0.00'
    else
      Credit:=FloatToStr(Sum1-Sum);
  end
  else
    Credit:='0';
end;

Function CreditUpdate(id:longint;kreditTek:string):string;
var
  Sum,Sum1:real;
  s1,s2,s3:string;
  q:TQUEry;
begin
  Sum:=0;   {-}
  Sum1:=0;  {+}
  if id<>0 then
  begin
  q:=sql.select(EntrySec.send_table {'Send'},'SumCount,Client_Ident','Client_Ident='+IntToStr(Id),'');
  while (not q.eof) do      {считаем сумму по всем отправкам -}
  begin
    Sum:=Sum+q.FieldByName('SumCount').asfloat;
    q.Next;
  end;
  q.Free;
  //---------------------
  q:=sql.select(EntrySec.Order_table {'`Order`'},'SumNDS,Client_Ident','Client_Ident='+IntToStr(Id),'');
  while not q.eof do      {считаем сумму по всем приходникам +}
  begin
    Sum1:=Sum1+q.FieldByName('SumNDS').asfloat;
    q.Next;
  end;
  q.Free;
  //----------------------
  q:=sql.select(EntrySec.paysheet_table {'PaySheet'},'Sum,Client_Ident','Client_Ident='+IntToStr(Id),'');
while not q.eof do      {считаем сумму по всем платежкам +}
begin
if pos('-',q.FieldByName('Sum').asstring)<>0  then
begin
s3:= q.FieldByName('Sum').asstring  ;
Delete(s3,1,1);
end;
if pos('-',q.FieldByName('Sum').asstring)=0  then
Sum1:=Sum1+q.FieldByName('Sum').asfloat
else
    if (FloatToStr(Sum1) = s3)then
        Sum1:=0
     else  Sum1:=Sum1+q.FieldByName('Sum').asfloat;
q.Next;
end;
q.Free;
//---------------------

if (trim(kreditTek) <> '') then
 begin
  if (pos('-',kreditTek)=0) then
     begin
         Sum1:=Sum1+StrToFloat(kreditTek)    {+}
     end
   else
     begin
       s3:= kreditTek  ;
       Delete(s3,1,1);
       Sum:=Sum+ StrToFloat(s3);       {-}
     end;
 end;
//---------------------
S1:='';
S2:='';
S1:=FloatToStr(Sum);
S2:=FloatToStr(Sum1);
S2:=StrTo00(S2);
S1:=StrTo00(S1);
if  (S1=s2)  then CreditUpdate:='0.00'
    else  CreditUpdate:=FloatToStr(Sum1-Sum);

end else CreditUpdate:='0';
end;

Function CreditDate2004(id:longint;Dat:Tdate):string;
var Sum,Sum1:real;
    S1,S2:string;
    q:TQUEry;
begin
Sum:=0;
Sum1:=0;
if id<>0 then
begin
q:=sql.select(EntrySec.send_table {'Send'},'SumCount,Client_Ident','Client_Ident='+IntToStr(Id)+
              ' and `Start`>'+ Sql.MakeStr('2003-12-31')+
              ' and `Start`<'+sql.MakeStr(FormatDateTime('yyyy-mm-dd',Dat)),'');
while (not q.eof) do      {считаем сумму по всем отправкам -}
begin
Sum:=Sum+q.FieldByName('SumCount').asfloat;
q.Next;
end;
q.Free;
//--------------------------------
//q:=sql.select(EntrySec.Order_table {'`Order`'},'SumNDS,Client_Ident','Client_Ident='+IntToStr(Id)+
//              ' and Dat<'+sql.MakeStr(FormatDateTime('yyyy-mm-dd',Dat)),'');
//while not q.eof do      {считаем сумму по всем приходникам +}
//begin
//Sum1:=Sum1+q.FieldByName('SumNDS').asfloat;
//q.Next;
//end;
//q.Free;
//----------------------------------
q:=sql.select(EntrySec.paysheet_table {'PaySheet'},'Sum,Client_Ident','Client_Ident='+IntToStr(Id)+
              ' and Dat>'+ Sql.MakeStr('2003-12-31')+
              ' and Dat<'+sql.MakeStr(FormatDateTime('yyyy-mm-dd',Dat)),'');
while not q.eof do      {считаем сумму по всем платежкам +}
begin
if pos('-',q.FieldByName('Sum').asstring)=0 then   {учитываем только положительные}
    Sum1:=Sum1+q.FieldByName('Sum').asfloat;
q.Next;
end;
q.Free;

S1:='';
S2:='';
S1:=FloatToStr(Sum);
S2:=FloatToStr(Sum1);
S2:=StrTo00(S2);
S1:=StrTo00(S1);

if  (S1=S2)  then CreditDate2004:='0.00'
    else  CreditDate2004:=FloatToStr(Sum1-Sum);

end else CreditDate2004:='0';

end;




Function CreditDate2007(id:longint;Dat:Tdate):string;
var
  Sum,Sum1:real;
  S1,S2,S3:string;
  q:TQUEry;
begin
  Sum:=0;
  Sum1:=0;
  if id<>0 then
  begin
    q:=sql.select(EntrySec.send_table {'Send'},'SumCount,Client_Ident','Client_Ident='+IntToStr(Id)+
              ' and `Start`>'+ Sql.MakeStr('2007-01-01')+
              ' and `Start`<'+sql.MakeStr(FormatDateTime('yyyy-mm-dd',Dat)),'');
    while (not q.eof) do      {считаем сумму по всем отправкам -}
    begin
      Sum:=Sum+q.FieldByName('SumCount').asfloat;
      q.Next;
    end;
    q.Free;
    //--------------------------------
    q:=sql.select(EntrySec.Order_table {'`Order`'},'SumNDS,Client_Ident','Client_Ident='+IntToStr(Id)+
              ' and Dat>'+sql.MakeStr('2007-01-01') +
              ' and Dat<'+sql.MakeStr(FormatDateTime('yyyy-mm-dd',Dat)),'');
    while not q.eof do      {считаем сумму по всем приходникам +}
    begin
      Sum1:=Sum1+q.FieldByName('SumNDS').asfloat;
      q.Next;
    end;
    q.Free;
    //----------------------------------
    q:=sql.select(EntrySec.paysheet_table {'PaySheet'},'Sum,Client_Ident','Client_Ident='+IntToStr(Id)+
              ' and Dat>'+sql.MakeStr('2007-01-01')+
              ' and Dat<'+sql.MakeStr(FormatDateTime('yyyy-mm-dd',Dat)),'');
    while not q.eof do      {считаем сумму по всем платежкам +}
    begin
    if pos('-',q.FieldByName('Sum').asstring)<>0  then
    begin
      s3:= q.FieldByName('Sum').asstring  ;
      Delete(s3,1,1);
    end;
    if pos('-',q.FieldByName('Sum').asstring)=0  then
      Sum1:=Sum1+q.FieldByName('Sum').asfloat
    else
      if (FloatToStr(Sum1) = s3)then
        Sum1:=0
      else
        Sum1:=Sum1+q.FieldByName('Sum').asfloat;
    //----------------------------------
    q.Next;
    end;
    q.Free;
    //-----------------------------------
    q:=sql.select('Clients','Saldo','Ident='+IntToStr(Id),'');
    if q.FieldByName('Saldo').asFloat<0 then    {-}
      Sum:=Sum-q.FieldByName('Saldo').asFloat
    else
      Sum1:=Sum1+q.FieldByName('Saldo').asFloat;    {+}
    q.Free;
    //---------------------
    S1:='';
    S2:='';
    S1:=FloatToStr(Sum);
    S2:=FloatToStr(Sum1);
    S2:=StrTo00(S2);
    S1:=StrTo00(S1);
    if (S1=S2) then
      CreditDate2007:='0.00'
    else
      CreditDate2007:=FloatToStr(Sum1-Sum);

  end
  else
    CreditDate2007:='0.00';
end;

Function CreditDate(id:longint;Dat:Tdate):string;
var
  Sum,Sum1:real;
  S1,S2,S3:string;
  q:TQUEry;
begin
  Sum:=0;
  Sum1:=0;
  if id<>0 then
  begin
    q:=sql.select(EntrySec.send_table {'Send'},'SumCount,Client_Ident','Client_Ident='+IntToStr(Id)+
              ' and `Start`<'+sql.MakeStr(FormatDateTime('yyyy-mm-dd',Dat)),'');
    while (not q.eof) do      {считаем сумму по всем отправкам -}
    begin
      Sum:=Sum+q.FieldByName('SumCount').asfloat;
      q.Next;
    end;
    q.Free;
    //--------------------------------
    q:=sql.select(EntrySec.Order_table {'`Order`'},'SumNDS,Client_Ident','Client_Ident='+IntToStr(Id)+
              ' and Dat<'+sql.MakeStr(FormatDateTime('yyyy-mm-dd',Dat)),'');
    while not q.eof do      {считаем сумму по всем приходникам +}
    begin
      Sum1:=Sum1+q.FieldByName('SumNDS').asfloat;
      q.Next;
    end;
    q.Free;
    //----------------------------------
    q:=sql.select(EntrySec.paysheet_table {'PaySheet'},'Sum,Client_Ident','Client_Ident='+IntToStr(Id)+
              ' and Dat<'+sql.MakeStr(FormatDateTime('yyyy-mm-dd',Dat)),'');
    while not q.eof do      {считаем сумму по всем платежкам +}
    begin
      if pos('-',q.FieldByName('Sum').asstring)<>0  then
      begin
        s3:= q.FieldByName('Sum').asstring  ;
        Delete(s3,1,1);
      end;
      if pos(' ',q.FieldByName('Sum').asstring)<>0 then
        ShowMessage('Проверьте правильность всех введенных числовых значений!');

      if pos('-',q.FieldByName('Sum').asstring)=0  then
        Sum1:=Sum1+q.FieldByName('Sum').asfloat
      else
        if (FloatToStr(Sum1) = s3)then
          Sum1:=0
        else
          Sum1:=Sum1+q.FieldByName('Sum').asfloat;
      q.Next;
    end;
    q.Free;
  end;
  //-----------------------------------
  q:=sql.select('Clients','KreditTEK','Ident='+IntToStr(Id),'');
  if (trim(q.FieldByName('KreditTEK').asstring) <> '') then
  begin
    if (pos('-',q.FieldByName('KreditTEK').asstring)=0) then
    begin
      Sum1:=Sum1+q.FieldByName('KreditTEK').asFloat    {+}
    end
    else
    begin
      s3:= q.FieldByName('KreditTEK').asstring  ;
      Delete(s3,1,1);
      Sum:=Sum+ StrToFloat(s3);       {-}
    end;
  end;
  q.Free;
  //---------------------
  S1:='';
  S2:='';
  S1:=FloatToStr(Sum);
  S2:=FloatToStr(Sum1);
  S2:=StrTo00(S2);
  S1:=StrTo00(S1);
  if (S1=S2) then
    CreditDate:='0.00'
  else
    CreditDate:=FloatToStr(Sum1-Sum);
  // aic012 end else CreditDate:='0';

end;

Function DayToDate(s:string;D:TDate):TDate;
var  i:integer;
     j:Word;
begin
j:=DayOfTheWeek(d) ;
if s='Пн' then i:=1;
if s='Вт' then i:=2;
if s='Ср' then i:=3;
if s='Чт' then i:=4;
if s='Пт' then i:=5;
if s='Сб' then i:=6;
if s='Вс' then i:=7;
if i>=j then i:=i-j
else i:=7-(j-i) ;

 DayToDate:=D+i ;
 //else DayToDate:=D+7;
end;

function SToDate(str:string;D:TDate):Tdate ;
var
  len : integer;
  posit:integer;
  s,sV:string;
  Dat,Dat1:TDate;
  dig2:string;
  dig1:string;
  dig : string;
  D1,m1,y1:word;

begin
  dig:=' Пн '+' Вт '+' Ср '+' Чт '+' Пт '+' Сб '+' Вс ';
  dig1:='1  2  3  4  5  6  7  8  9  10  11  12  13  14  15 '+
        ' 16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31';
  dig2:=' Нечет  Чет ' ;
  Len:=Length(trim(str));
  sv:=trim(str);
  Dat1:=d+31;
  while  (Len>0) do
  begin
  posit:=pos(',',sv);
  if posit<>0 then
  begin
    s:=copy(sv,1,posit-1);
    delete(sv,1,posit);
  end
  else
  begin
    s:=sv;
    sv:='';
  end;
  s:=trim(s);
  sv:=trim(sv);
  len:=Length(sv);
  if (Pos(s,dig)<>0) then
  begin
    Dat:=DayToDate(S,d);
    if Dat<=Dat1 then
      Dat1:=Dat;
  end;
 if (Pos(s,dig1)<>0) then
   begin
   decodeDate(d,y1,m1,d1) ;
   if StrToInt(s)>=d1 then
   dat:=encodeDate(y1,m1,StrToInt(s))
   else begin
         if m1<12 then dat:=encodeDate(y1,m1+1,StrToInt(s))
          else  dat:=encodeDate(y1+1,1,StrToInt(s))
        end;
   if Dat<=Dat1 then Dat1:=Dat;
   end;
 if (Pos(s,dig2)<>0) then
   begin
    decodeDate(d,y1,m1,d1) ;
         if (d1 mod 2)=0 then
         begin
          if  (s='Нечет')then Dat1:=d+1;
           if (s='Чет') then  Dat1:=d;
         end else begin
                    if  (s='Нечет') Then Dat1:=d;
                    if  (s='Чет') Then   Dat1:=d+1;
                  end;
   end;

end;
SToDate:=Dat1;
end;

function StrTo00(s:string):string;
var   F1,F,Neg:string;
      i:integer;
      N1,N2,N3:integer;
begin
N3:=0;
i:=0;
Neg:='';
i:=pos('-',s);
if i<>0 then
begin
 if i=1 then
 begin
 Neg:='-';
 delete(s,1,1);
 end
 else begin
       ShowMessage('Проверьте правильность всех введенных числовых значений!');
       exit;
      end;
end;

 if s<>'' then
 begin
 i:=0;
 i:=pos('.',s);
 if i<>0 then
 begin
 f1:=copy(s,1,i-1);
 if Length(f1)=0 then f1:='0';
 f:=copy(s,i+1,Length(s)-i);
 if Length(f)=1 then  f:=f+'0';
 if Length(f)=0 then  f:='00';
 if Length(f)>2 then
 begin
 N1:=0;
 N2:=0;
 N3:=0;
 while Length(F)>2  do
   begin
    N1:=StrToInt(copy(f,Length(f),1));
    N2:=StrToInt(copy(f,Length(f)-1,1))+N3;
    if (N1>4) then N2:=N2+1;
    if N2=10 then
      begin
      N3:=1;
      N2:=0;
      end else N3:=0;
    F:=copy(f,1,Length(f)-2);
    F:=F+IntToStr(N2);
   end;
 end  ;
 if N3=1 then
    begin
      if  Length(f)=2 then
       begin
           N1:=StrToInt(copy(f,Length(f),1));
           N2:=StrToInt(copy(f,Length(f)-1,1))+N3;
           if (N2=10) then
            begin
              N2:=0;
              f1:=inttostr(StrToInt(F1)+1);
            end;
            f:=inttostr(N2)+inttostr(N1);
       end;
    end;
 if Length(f1)=0 then f1:='0';
 end else
      begin
      f1:=s;
      f:='00';
      end;
 end else begin
          F1:='0';
          F:='00';
          end;
if  Length(f)=0 then f:='00'
 else if Length(f)=1 then f:=f+'0';
 StrTo00:=Neg+f1+'.'+f;
end;

function Money00(Money:string):string;
var S,s1:string;
    posit:integer;
begin
if Length(Money)<>0 then
begin
Posit:=Pos('.',Money);
if posit<>0 then
 begin
  s:=copy(money,1,posit-1);
  s1:=copy(money,posit+1,Length(Money)-posit) ;
 end  else begin
           s:=Money;
           s1:='00';
           end;
end else begin
         s:='0';
         s1:='00';
         end;
if s='' then s:='0';
if Length(s1)>2 then s1:=copy(s1,1,2);
if Length(s1)=1 then s1:=s1+'0';
if Length(s1)=0 then s1:='00';
Money00:=s+' руб. '+s1+' коп.';
end;


function MoneyToString(Money:string):string;
var F1,f,s1:string;  {Ёєсыш}
    F2:string;    {ъюяхщъш}
    Mon:string;
    P:integer;
    Len,l,l1:integer;
    str:string;

begin
 s1:='';
 F1:='';
 F2:='';
 str:='' ;
 Mon:=Money;
 Len:=Length(Mon)  ;
 if Len>0 then
 begin
 P:=Pos('.',Mon) ;
 if P>0 then
  begin
  F1:=copy(Mon,1,p-1)   ;  {Ёєсыш}
  F2:=copy(Mon,p+1,Len) ;  {ъюяхщъш}
  end else begin
            F1:=Mon;
            F2:='00';
           end;

  l1:=length(f1);
  l:=(l1 div 3)+1;
while l>0 do begin
  f:=copy(f1,1,l1-3*(l-1));
  delete(f1,1,l1-3*(l-1));
  l1:=Length(f1);
  Len:=Length(F);
 case Len of
 1:  str:=str+' '+String0(f,l) ;
 2:  str:=str+' '+String00(f,l) ;
 3:  str:=str+' '+String000(f,l);
 end;
l:=l-1;
end;
f1:=str;
 end else
   Begin
   F1:='0';
   f2:='00'; 
   end;
if Length(F2)=1 then f2:=f2+'0';
if length(f2)>2 then f2:=copy(f2,1,2);
if F1='' then F1:='0';
 F1:=trim(f1);
 s1:=copy(f1,1,1);
 delete(f1,1,1);
 s1:=AnsiUpperCase(s1);

MoneyToString:=s1+F1+' руб. '+F2+' коп.';
end;


function NumberToString(Money:string):string;
var 
  F1,f,s1:string;  {число}
  Mon:string;
  Len,l,l1:integer;
  str:string;
begin
  s1:='';
  F1:='';
  str:='' ;
  Mon:=Money;
  Len:=Length(Mon)  ;
  if Len>0 then
  begin
    F1:=Mon;
    l1:=length(f1);
    l:=(l1 div 3)+1;
    while l>0 do 
    begin
      f:=copy(f1,1,l1-3*(l-1));
      delete(f1,1,l1-3*(l-1));
      l1:=Length(f1);
      Len:=Length(F);
      case Len of
        1:  str:=str+' '+String0(f,l) ;
        2:  str:=str+' '+String00(f,l) ;
        3:  str:=str+' '+String000(f,l);
      end;
      l:=l-1;
    end;
    f1:=str;
  end 
  else
  begin
    F1:='0';
  end;
  if F1='' then 
    F1:='0';
  F1:=trim(f1);
  s1:=copy(f1,1,1);
  delete(f1,1,1);
  s1:=AnsiUpperCase(s1);
  NumberToString:=s1+F1;
end;

function String000(Str:string;i:integer):string;
var  
  F,f1:string;
  j:integer;
  Len:integer;
begin
  F:=Str;
  Len:=Length(f);
  f1:=copy(f,1,1) ;
  j:=StrToInt(f1);
  f:=copy(f,2,2);
  case j of
    0:  String000:=String00(f,i);
    1:  String000:='сто '+String00(f,i);
    2:  String000:='двести '+String00(f,i);
    3:  String000:='триста '+String00(f,i);
    4:  String000:='четыреста '+String00(f,i);
    5:  String000:='пятьсот '+String00(f,i);
    6:  String000:='шестьсот '+String00(f,i);
    7:  String000:='семьсот '+String00(f,i);
    8:  String000:='восемьсот '+String00(f,i);
    9:  String000:='девятьсот '+String00(f,i);
  end;
end;

Function String0(t:string;j:integer):string;
var 
  I:integer;
  str,s:string;
begin
  str:='';
  s:='';
  str:=t;
  I:=StrToInt(str);
  Case i of
    1: begin
        if (j=2) then 
          Str:='одна'
        else 
          Str:='один';
        end;
    2: begin
        if j=2 then 
          Str:='две'
        else 
          Str:='два';
        end;
    3: Str:='три';
    4: Str:='четыре';
    5: Str:='пять';
    6: Str:='шесть';
    7: Str:='семь';
    8: Str:='восемь';
    9: Str:='девять';
    0: Str:='';
  end;
  case i of
    1:begin
        if j=1 then 
          s:='';
        if j=2 then 
          s:=' тысяча';
        if j=3 then 
          s:=' миллион';
        if j=4 then 
          s:=' миллиард';
       end;
    2..4:begin
           if j=1 then s:='';
           if j=2 then s:=' тысячи';
           if j=3 then s:=' миллиона';
           if j=4 then s:=' миллиарда';
         end;
    0,5..9:begin
             if j=1 then 
               s:='';
             if j=2 then 
               s:=' тысяч';
             if j=3 then 
               s:=' миллионов';
             if j=4 then 
               s:=' миллиардов';
    end;
  end;
  String0:=str+s;
end;

Function String00(str:string;k:integer):string;
var i,j:integer;
    s1,s:string;
begin
case k of
    1: s:='';
    2: s:=' тысяч';
    3: s:=' миллионов';
    4: s:=' миллиардов';
end;
 s1:=copy(str,1,1);
 i:=StrToInt(s1) ;
 s1:=copy(str,2,1);
 j:=StrToInt(s1);
case i of
0:  String00:=String0(IntToStr(j),k) ;
1: begin
    case j of
     0:String00:='десять'+s;
     1:String00:='одинадцать'+s;
     2:String00:='двенадцать'+s;
     3:String00:='тринадцать'+s;
     4:String00:='четырнадцать'+s;
     5:String00:='пятнадцать'+s;
     6:String00:='шестнадцать'+s;
     7:String00:='семнадцать'+s;
     8:String00:='восемнадцать'+s;
     9:String00:='девятнадцать'+s;
    end;
   end;
2: String00:='двадцать '+String0(s1,k) ;
3: String00:='тридцать '+String0(s1,k) ;
4: String00:='сорок '+String0(s1,k) ;
5: String00:='пятьдесят '+String0(s1,k) ;
6: String00:='шестьдесят '+String0(s1,k) ;
7: String00:='семьдесят '+String0(s1,k) ;
8: String00:='восемьдесят '+String0(s1,k) ;
9: String00:='девяносто '+String0(s1,k) ;
end;
end;

function DataDMstrY(d:Tdate):string;
var
  Year, Month, Day: Word;
  M,Y,Da:string;
begin
  DecodeDate(d, Year, Month, Day);
  case Month of
    1: M:='января';
    2: M:='февраля';
    3: M:='марта';
    4:  M:='апреля';
    5: M:='мая';
    6:  M:='июня';
    7:  M:='июля';
    8:  M:='августа';
    9:  M:='сентября';
    10: M:='октября';
    11: M:='ноября';
    12:  M:='декабря';
  else
    M:='';
  end;
  if day<>0 then
    Da:='"'+IntToStr(Day)+'"'
  else Da:='';
    if Year<>0 then
      Y:=IntToStr(Year)+' г.'
    else
      Y:='';
  DataDMstrY:=Da+' '+M+' '+Y;
end;

end.
