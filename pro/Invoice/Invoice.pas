unit Invoice;

interface
uses
  Windows, Messages, SysUtils, Variants,Controls,DateUtils,SqlGrid,Dialogs,
  DB,DBTables,TSQLCLS, EntrySec;

function InvoiceCount(Id:longint;strId:string;NewNalog:integer):integer;
function AftoSumCount(Id:longint):real;
function AktCount(Id: longint; strId: string):integer;
function InvoiceTest(Id:longint;D:TDate):boolean;
Procedure InvoiceFill;
Procedure InvoiceCompare;
function String12(st:string):string;
implementation

Uses SendStr;

function InvoiceCount(Id:longint;strId:string;NewNalog:integer):integer;
var Typ:integer;
    q:TQUEry;
    F1,F,F2,F3,F4,F5,F6,NDS,Sum,pack:Real;
    l,i:longint;
    str,str1:string;
    perc:integer;
    Country:string;
begin
q:=sql.Select(EntrySec.sends_view {'Sends'},'','Ident in ('+strId+')','');//+
             { ' and NumberCountPattern is NULL and( (ContractType_Ident=2 and '+
              'DateSupp is not NULL) or (ContractType_Ident=2 and '+
              'DateSupp is not NULL and SumWay is not NULL and '+
              'SumServ is not NULL))','DateSupp'); }
if not q.eof then
begin
Sql.Delete('PrintInvoice','Send_Ident in ('+strId+')');
Country:='';
F:=0;  {стоимость перевозки жд транспортом}
F1:=0;  {стоимость перевозки авто трансп}
F2:=0;  {Вознаграждение  агента за перевозку}
F3:=0;  {упаковочный  материал}
F4:=0;  {Вознаграждение агента за упаковку}
F5:=0;   {Страхование}
f6:=0;  {Вознаграждение агента за Страхование}
Country:=sql.SelectString('Country','Name','Ident='+
                          sql.SelectString('Clients','Country_Ident',
                          'Ident='+IntToStr(Id))) ;
if Country='' then Country:='Россия';
while not q.eof do
  begin
F:=0;  {стоимость перевозки жд транспортом}
F1:=0;  {стоимость перевозки авто трансп}
F2:=0;  {Вознаграждение  агента за перевозку}
F3:=0;  {упаковочный  материал}
F4:=0;  {Вознаграждение агента за упаковку}
F5:=0;   {Страхование}
f6:=0;  {Вознаграждение агента за Страхование}
  Typ:=q.fieldByName('ContractType_Ident').AsInteger;
if Typ=1 then  {жд}
   begin
   str1:=''; {вес только для авто перевозок}
    f1:=q.FieldByName('Fare').AsFloat   ;
    if f1=0 then begin
                 InvoiceCount:=1;
                  q.Free;
                  exit;
                 end;
//---------------------------------
    F:=q.fieldByName('SumWay').AsFloat+q.fieldByName('SumServ').AsFloat ;

//----------------------------------------------
F1:=f1-f;
if (q.fieldByName('InsuranceValue').Asstring<>'0.00') and
   (q.fieldByName('InsuranceValue').Asstring<>'')
   and (NewNalog = 1){введено с 01.01.04}then
f1:=f1+q.fieldByName('InsuranceValue').Asfloat;

if q.fieldByName('AddServiceExp').AsInteger=1 then
f1:=f1+q.fieldByName('ExpCount').AsFloat*q.fieldByName('ExpTarif').AsFloat;
if q.fieldByName('AddServiceProp').AsInteger=1 then
f1:=f1+q.fieldByName('PropCount').AsFloat*q.fieldByName('PropTarif').AsFloat;
perc:=0;
perc:=sql.SelectInteger('Constant','PercentSend','');
f2:=f1*perc/100;
f2:=StrToFloat(StrTo00(FloatToStr(f2)));
f1:=f1-f2;
if (q.fieldByName('AddServicePack').AsInteger=1) and
   (q.fieldByName('PackTarif').AsFloat<>0) then
f3:=q.fieldByName('PackTarif').AsFloat;
perc:=0;
perc:=sql.SelectInteger('Constant','PercentPack','');
f4:=f3*perc/100;
f4:=StrToFloat(StrTo00(FloatToStr(f4)));
f3:=f3-f4;
   end else
   if Typ=2 then {авто}
    begin
       str1:='';
       str1:=q.fieldByName('Weight').Asstring;
       if str1<>'' then str1:=', '+str1+' кг.'; {вес отправки для печати в с/ф}

       f1:=q.FieldByName('Fare').AsFloat   ;
       if f1=0 then begin
                     InvoiceCount:=1;
                     q.Free;
                     exit;
                     end;
if (q.fieldByName('InsuranceValue').Asstring<>'0.00') and
   (q.fieldByName('InsuranceValue').Asstring<>'')
   and (NewNalog = 1)then     {введено с 01.01.04}
  f1:=f1+q.fieldByName('InsuranceValue').Asfloat;

       if q.fieldByName('AddServiceExp').AsInteger=1 then
        f1:=f1+q.fieldByName('ExpCount').AsFloat*q.fieldByName('ExpTarif').AsFloat;
       if q.fieldByName('AddServiceProp').AsInteger=1 then
        f1:=f1+q.fieldByName('PropCount').AsFloat*q.fieldByName('PropTarif').AsFloat;
       if StrToDate(q.FieldByName('Start').AsString)> StrToDate('31.05.2012') then
          begin       {сумму по доп услуге не суммируем с перевозной платой с 01.06.2012 }
          if (q.fieldByName('AddServSum').AsString <> '') and
             (q.fieldByName('AddServSum').AsString <> '0.00') and
             (q.fieldByName('AddServSum').AsString <> 'NULL')  then
             f1:=f1+q.fieldByName('AddServSum').AsFloat; {AddServSum}
          end;
       perc:=0;
       perc:=sql.SelectInteger('Constant','PercentSend','');
       f2:=f1*perc/100;
       f2:=StrToFloat(StrTo00(FloatToStr(f2)));
       f1:=f1-f2;
       if (q.fieldByName('AddServicePack').AsInteger=1) and
             (q.fieldByName('PackTarif').AsFloat<>0) then
        f3:=q.fieldByName('PackTarif').AsFloat;
       perc:=0;
       perc:=sql.SelectInteger('Constant','PercentPack','');
       f4:=f3*perc/100;
       f4:=StrToFloat(StrTo00(FloatToStr(f4)));
       f3:=f3-f4;
    end else begin
              InvoiceCount:=2;
              q.Free;
              exit;
             end;
//---------------------
if f<>0 then
      begin
      NDS:=0;
      Sum:=0;
       l:=q.fieldByName('Ident').AsInteger;
       str:=IntTOstr(l);
       str:=str+',NULL';
       str:=str+','+sql.MakeStr('Перевозка грузобагажа ж/д транспортом');
       str:=str+','+sql.MakeStr('шт.');
       str:=str+','+sql.MakeStr('1.0');
       str:=str+','+sql.MakeStr(SendStr.StrTo00(FloatToStr(f)));
       NDS:=(f*18)/118;
       NDS:=StrToFloat(StrTo00(FloatToStr(NDS)));
       str:=str+','+sql.MakeStr(SendStr.StrTo00(FloatToStr(NDS)));
       Sum:=f-NDS;
       str:=str+','+sql.MakeStr(SendStr.StrTo00(FloatToStr(Sum)));
       str:=str+','+sql.MakeStr(SendStr.StrTo00(FloatToStr(Sum)));
       str:=str+','+sql.MakeStr('------')+',';
       str:=str+sql.MakeStr('18%')+',';
       str:=str+sql.MakeStr(Country)+','+sql.MakeStr('---');
       i:=sql.FindNextInteger('Ident','PrintInvoice','',MaxLongint) ;
       str:=str+','+IntToStr(i);
       sql.InsertString('PrintInvoice','Send_Ident,Place,NameGood,Unit,Count,'+
                        'SumNDS,NDS,SumUnit,Sum,Akc,PercNDS,Country,GTD,Ident',
                        str);
      end;
//---------------------------------------
if f1<>0 then
    begin
        NDS:=0;
        Sum:=0;
        l:=q.fieldByName('Ident').AsInteger;
       str:=IntTOstr(l);
       if (q.fieldByName('CityName').AsString<>'')  then
       str:=str+','+sql.MakeStr(q.fieldByName('CityName').AsString +'; '+
            q.fieldByName('Namber').AsString)

       else str:=str+',NULL' + q.fieldByName('Namber').AsString;
       str:=str+','+sql.MakeStr('Перевозка грузобагажа автотранспортом');
       str:=str+','+sql.MakeStr('шт.');
       str:=str+','+sql.MakeStr('1.0');
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(f1)));
       NDS:=(f1*18)/118;
       NDS:=StrToFloat(StrTo00(FloatToStr(NDS)));
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(NDS)));
       Sum:=f1-NDS;
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(Sum)));
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(Sum)));
       str:=str+','+sql.MakeStr('------')+',';
       str:=str+sql.MakeStr('18%')+',';
       str:=str+sql.MakeStr(Country)+','+sql.MakeStr('---');
       i:=sql.FindNextInteger('Ident','PrintInvoice','',MaxLongint) ;
       str:=str+','+IntToStr(i);
       sql.InsertString('PrintInvoice','Send_Ident,Place,NameGood,Unit,Count,'+
                        'SumNDS,NDS,SumUnit,Sum,Akc,PercNDS,Country,GTD,Ident',str);

    end;
///--------------------------------
if f2<>0 then
    begin
      NDS:=0;
      Sum:=0;
        l:=q.fieldByName('Ident').AsInteger;
       str:=IntTOstr(l);
       if (q.fieldByName('Namber').AsString<>'') or (str1<>'') then
       str:=str+','+sql.MakeStr(q.fieldByName('Namber').AsString+str1)
       else str:=str+',NULL';
       str:=str+','+sql.MakeStr('Вознагр. агента за организацию перевозки');
       str:=str+','+sql.MakeStr('шт.');
       str:=str+','+sql.MakeStr('1.0');
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(f2)));
       NDS:=(f2*18)/118;
       NDS:=StrToFloat(StrTo00(FloatToStr(NDS)));
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(NDS)));
       Sum:=f2-NDS;
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(Sum)));
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(Sum)));
       str:=str+','+sql.MakeStr('------')+',';
       str:=str+sql.MakeStr('18%')+',';
       str:=str+sql.MakeStr(Country)+','+sql.MakeStr('---');
       i:=sql.FindNextInteger('Ident','PrintInvoice','',MaxLongint) ;
       str:=str+','+IntToStr(i);
       sql.InsertString('PrintInvoice','Send_Ident,Place,NameGood,Unit,Count,'+
                        'SumNDS,NDS,SumUnit,Sum,Akc,PercNDS,Country,GTD,Ident',str);

    end;
///---------------------------------------
if f3<>0 then
    begin
      NDS:=0;
      Sum:=0;
        l:=q.fieldByName('Ident').AsInteger;
       str:=IntTOstr(l);
       str:=str+',NULL';
       str:=str+','+sql.MakeStr('Упаковочный материал');
       str:=str+','+sql.MakeStr('м');
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(f3)));
       NDS:=(f3*18)/118;
       NDS:=StrToFloat(StrTo00(FloatToStr(NDS)));
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(NDS)));
       Sum:=f3-NDS;
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(Sum)));
       pack:=0;
       pack:=StrToFloat(sql.Selectstring('Constant','PackTariff',''));
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(pack)));
       Sum:=Sum/pack;
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(Sum)));
       str:=str+','+sql.MakeStr('------')+',';
       str:=str+sql.MakeStr('18%')+',';
       str:=str+sql.MakeStr(Country)+','+sql.MakeStr('---');
       i:=sql.FindNextInteger('Ident','PrintInvoice','',MaxLongint) ;
       str:=str+','+IntToStr(i);
       sql.InsertString('PrintInvoice','Send_Ident,Place,NameGood,Unit,'+
                        'SumNDS,NDS,Sum,SumUnit,Count,Akc,PercNDS,Country,GTD,Ident',
                        str);

    end;
////------------------------------------------
if f4<>0 then
    begin
      NDS:=0;
      Sum:=0;
      l:=q.fieldByName('Ident').AsInteger;
       str:=IntTOstr(l);
       str:=str+',NULL';
       str:=str+','+sql.MakeStr('Вознагр. агента за упаковку');
       str:=str+','+sql.MakeStr('шт.');
       str:=str+','+sql.MakeStr('1.0');
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(f4)));
       NDS:=(f4*18)/118;
       NDS:=StrToFloat(StrTo00(FloatToStr(NDS)));
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(NDS)));
       Sum:=f4-NDS;
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(Sum)));
       str:=str+','+sql.MakeStr(StrTo00(FloatToStr(Sum)));
       str:=str+','+sql.MakeStr('------')+',';
       str:=str+sql.MakeStr('18%')+',';
       str:=str+sql.MakeStr(Country)+','+sql.MakeStr('---');
       i:=sql.FindNextInteger('Ident','PrintInvoice','',MaxLongint) ;
       str:=str+','+IntToStr(i);
       sql.InsertString('PrintInvoice','Send_Ident,Place,NameGood,Unit,Count,'+
                        'SumNDS,NDS,SumUnit,Sum,Akc,PercNDS,Country,GTD,Ident',str);

    end;
///-------------------------------------------

  q.Next;
  end;

end else InvoiceCount:=0;
q.Free;
end;

function AktCount(Id: longint; strId: string):integer;
var
    q:TQUEry;
    F,Sum:Real;
    l,i:longint;
    str,str1:string;
begin
q:=sql.Select(EntrySec.sends_view {'Sends'},'','Ident in ('+strId+')','');
if not q.eof then
begin
Sql.Delete('PrintInvoice','Send_Ident in ('+strId+')');

F:=0;  {стоимость перевозки }

while not q.eof do
  begin
F:=0;  {стоимость перевозки жд транспортом}

    F:=q.fieldByName('SumCount').AsFloat ;

//----------------------------------------------

if f<>0 then
      begin
      Sum:=0;
       l:=q.fieldByName('Ident').AsInteger;
       str:=IntTOstr(l);
       str1:='';
       if (q.fieldByName('CityName').AsString<>'')  then
       str1:=q.fieldByName('CityName').AsString
       else str1:='';
       if (q.fieldByName('Namber').AsString<>'') then
       str1:=str1+' '+q.fieldByName('Namber').AsString;


       if str1<>'' then str:=str+','+sql.MakeStr(str1)
       else   str:=str+',NULL';
       str:=str+','+sql.MakeStr('Перевозка грузобагажа ж/д транспортом');
       str:=str+','+sql.MakeStr('шт.');
       str:=str+','+sql.MakeStr('1.0');
       str:=str+','+sql.MakeStr(SendStr.StrTo00(FloatToStr(f)));
       str:=str+','+sql.MakeStr(SendStr.StrTo00(FloatToStr(f)));
       Sum:=f;
       str:=str+','+sql.MakeStr(SendStr.StrTo00(FloatToStr(Sum)));
       str:=str+','+sql.MakeStr(SendStr.StrTo00(FloatToStr(Sum)));
       str:=str+','+sql.MakeStr('------')+',';
       str:=str+sql.MakeStr('-')+',';
       str:=str+sql.MakeStr('')+','+sql.MakeStr('---');
       i:=sql.FindNextInteger('Ident','PrintInvoice','',MaxLongint) ;
       str:=str+','+IntToStr(i);
       sql.InsertString('PrintInvoice','Send_Ident,Place,NameGood,Unit,Count,'+
                        'SumNDS,NDS,SumUnit,Sum,Akc,PercNDS,Country,GTD,Ident',
                        str);
      end;
//---------------------------------------
  q.Next;
  end;

end else AktCount:=0;
q.Free;
end;

function InvoiceTest(Id:longint;D:TDate):boolean;
var     test:boolean;
        i,PT:integer;
        DatSup:TDate;
        q,q1:TQuery;
begin
test:=false;
PT:=sql.selectinteger('Clients','PersonType_Ident','Ident='+IntToStr(Id));
if  PT = 1 then
begin
q1:=sql.select('Clientstek','Acronym','Ident='+IntToStr(Id),'');
 if q1.eof then
 q:=sql.Select(EntrySec.send_table {'Send'},'DateSupp,Ident,CountInvoice','Client_Ident='+IntToStr(Id)+
              ' and NumberCountPattern is NULL and( (ContractType_Ident=2 and '+
              'DateSupp is not NULL) or (ContractType_Ident=1 and '+
              'DateSupp is not NULL and SumWay is not NULL and '+
              'SumServ is not NULL)) and DateSupp<='+
              sql.MakeStr(FormatDateTime('yyyy-mm-dd',D))+
              ' and CountInvoice is not NULL','DateSupp')
 else
 q:=sql.Select(EntrySec.send_table {'Send'},'DateSupp,Ident,CountInvoice','Client_Ident='+IntToStr(Id)+
              ' and AktTek_Ident is NULL and( (ContractType_Ident=2 and '+
              'DateSupp is not NULL) or (ContractType_Ident=1 and '+
              'DateSupp is not NULL and SumWay is not NULL and '+
              'SumServ is not NULL)) and DateSupp<='+
              sql.MakeStr(FormatDateTime('yyyy-mm-dd',D))+
              ' and CountInvoice is not NULL','DateSupp');
if q.Eof then test:=false;

i:=0;
while (not q.Eof)and(not test)  do
begin
DatSup:=StrToDate(q.FieldByName('DateSupp').asString) ;
if DatSup<(D-4) then test:=true;
i:=i+q.FieldByName('CountInvoice').AsInteger;
if i>21 then test:=true;

q.next;
end;
q.Free;
q1.Free;
end;
InvoiceTest:=test;

end;


Procedure InvoiceFill;
var
    q,qIn:TQuery;
    s:string;
    SumControl:real;{введена для контроля старой суммы с/ф с новой}
     SumNDS:real; {сумма с НДС}
     Sum:real;     {сумма без НДС}
     NDS:real;    {сумма НДС}
     Fee:real;    {сумма вознаграждение агента}
    SumGd:  Real;    {сумма за жд перевозку}
    NDSGD:  Real;    {НДС с суммы за жд перевозку}
    SumAvt: Real;    {сумма за авто перевозку}
    NDSAvt: Real;    {НДС с суммы за авто перевозку}
    SumAg:  Real;    {сумма вознагрождение агента}
    NDSAg:  Real;    {НДС с вознаграждения агента}
    SumPak: Real;    {сумма за упаковку}
    NDSPak: Real;    {НДС с суммы за упаковку}
    SumPakAg:Real;   {сумма вознаграждения за упаковку}
    NDSPakAg:Real;   {НДС с суммы вознаграждения за упаковку}
    SumSt:  real;    {сумма страхования}
    NDSSt:  real;    {НДС со страхования}
    SumStAg:real;    {сумма вознаграждения агента за страхование}
    NDSStAg:real;    {НДС с суммы вознагражд. агента за страх.}
    strIdSend, num:string;
    J,M:TextFile;
    NEWN:integer;
    label T;
begin

 qIn:=sql.Select(EntrySec.invoice_table {'Invoice'},'','','Ident');

T: while  (not qIn.eof) do
 begin
             num:= qIn.fieldByName('Number').asstring;
             delete(num,Length(num)-2,3) ;
            if not FileExists('c:\nnnn') then  FileCreate('c:\nnnn');
               AssignFile(m,'c:\nnnn');
               Append(m)  ;
               Writeln (m,num);
                CloseFile(m);
   strIdSend:='';
   NEWN:=1;
       q:=sql.Select(EntrySec.sends_view {'Sends'},'DateSupp,Ident,CountInvoice','Invoice_Ident='+
              qIn.fieldByName('Ident').asString,'DateSupp');
       if not q.Eof then
       begin
        while not q.Eof do
        begin
         strIdSend:=strIdSend+','+q.FieldByName('Ident').AsString;
        q.Next;
        end;
        if (Pos(',',strIdSend)=1) then
            Delete(strIdSend,1,1);
        InvoiceCount(qIn.fieldByName('Clients_Ident').asInteger,StrIdSend,NEWN);
       end
         else begin
               ShowMessage('Не найдено отправок на счет фактуру с идентом и номером '+
               qIn.fieldByName('Ident').asstring+' '+
               qIn.fieldByName('Number').asstring +'!');
               qIN.Next;
               goto T;
               exit
              end;
       q.Free;
//---------------------------------------
SumControl:=0;
SumControl:=qIn.fieldByName('Sum').asFloat;
  Sum:=0;
  SumNDS:=0;
  NDS:=0;
  Fee:=0;
    SumGd:=0;
    NDSGD:=0;
    SumAvt:=0;
    NDSAvt:=0;
    SumAg:=0;
    NDSAg:=0;
    SumPak:=0;
    NDSPak:=0;
    SumPakAg:=0;
    NDSPakAg:=0;
    SumSt:=0;
    NDSSt:=0;
    SumStAg:=0;
    NDSStAg:=0;
//----------------
q:=sql.Select('PrintInvoice','Sum,SumNDS,NDS','Send_Ident in ('+strIdSend+')','');
  if q.Eof then exit
  else begin
        While (not q.eof) do
        begin
         Sum:=Sum+q.FieldByName('Sum').AsFloat;
         SumNDS:=SumNDS+q.FieldByName('SumNDS').AsFloat;
         NDS:=NDS+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
       end;
  q.Free;
 //----------------------
 //Controlled
 If FloatToStr(SumNDS)<>FloatToStr(SumControl) then
 begin

               ShowMessage('Старая сумма не сошлась с новой в с/ф '+
               qIn.fieldByName('Ident').asstring+' '+
               qIn.fieldByName('Number').asstring +'!'+
               ' Старая = '+FloatToStr(SumControl)+
               ' Новая = '+FloatToStr(SumNDS));
               if not FileExists('c:\dddd') then FileCreate('c:\dddd');
               AssignFile(J,'c:\dddd');
               Append(J)  ;
               Writeln (J,qIn.fieldByName('Number').asstring+' '+
                        FloatToStr(SumControl)+' '+FloatToStr(SumNDS)  );
                CloseFile(J);
               qIN.Next;
               goto T;
               exit

 end;
 //-------------------------

   q:=sql.Select('PrintInvoice','NameGood,SumNDS,','Send_Ident in ('+StrIdSend+')'+
                                ' and (NameGOOD like ''Вознагр.%'')','');
  while not q.Eof do
  begin
  Fee:=Fee+q.fieldByName('SumNDS').AsFloat;
  q.Next;
  end;
  q.Free;
 //----------------------------
  q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
                ' and NameGood='+
                sql.Makestr('Перевозка грузобагажа ж/д транспортом'),'') ;
    While (not q.eof) do
        begin
         SumGd:=SumGd+q.FieldByName('SumNDS').AsFloat;
         NDSGD:=NDSGD+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
  q.Free;
 //----------------
    q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
                ' and NameGood='+
                sql.Makestr('Перевозка грузобагажа автотранспортом'),'') ;
    While (not q.eof) do
        begin
         SumAvt:=SumAvt+q.FieldByName('SumNDS').AsFloat;
         NDSAvt:=NDSAvt+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
               ' and NameGood='+
                sql.Makestr('Вознагр. агента за организацию перевозки'),'') ;
    While (not q.eof) do
        begin
         SumAg:=SumAg+q.FieldByName('SumNDS').AsFloat;
         NDSAg:=NDSAg+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')'+
                ' and NameGood='+
                sql.Makestr('Упаковочный материал'),'') ;
    While (not q.eof) do
        begin
         SumPak:=SumPak+q.FieldByName('SumNDS').AsFloat;
         NDSPak:=NDSPak+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')'+
                ' and NameGood='+
                sql.Makestr('Вознагр. агента за упаковку'),'') ;
    While (not q.eof) do
        begin
         SumPakAg:=SumPakAg+q.FieldByName('SumNDS').AsFloat;
         NDSPakAg:=NDSPakAg+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
                ' and NameGood='+
                sql.Makestr('Страхование'),'') ;
    While (not q.eof) do
        begin
         SumSt:=SumSt+q.FieldByName('SumNDS').AsFloat;
         NDSSt:=NDSSt+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
               ' and NameGood='+
                sql.Makestr('Вознагр. агента за страхование'),'') ;
    While (not q.eof) do
        begin
         SumStAg:=SumStAg+q.FieldByName('SumNDS').AsFloat;
         NDSStAg:=NDSStAg+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
 s:='';
 s:=s+'SumGd='+sql.MakeStr(StrTo00(FloatToStr(SumGd)));
 s:=s+',NDSGd='+sql.MakeStr(StrTo00(FloatToStr(NDSGd)));
 s:=s+',SumAvt='+sql.MakeStr(StrTo00(FloatToStr(SumAvt)));
 s:=s+',NDSAvt='+sql.MakeStr(StrTo00(FloatToStr(NDSAvt)));
 s:=s+',SumAg='+sql.MakeStr(StrTo00(FloatToStr(SumAg)));
 s:=s+',NDSAG='+sql.MakeStr(StrTo00(FloatToStr(NDSAG)));
 s:=s+',SumPak='+sql.MakeStr(StrTo00(FloatToStr(SumPak)));
 s:=s+',NDSPak='+sql.MakeStr(StrTo00(FloatToStr(NDSPak)));
 s:=s+',SumPakAg='+sql.MakeStr(StrTo00(FloatToStr(SumPakAg)));
 s:=s+',NDSPakAg='+sql.MakeStr(StrTo00(FloatToStr(NDSPakAg)));
 s:=s+',SumSt='+sql.MakeStr(StrTo00(FloatToStr(SumSt)));
 s:=s+',NDSSt='+sql.MakeStr(StrTo00(FloatToStr(NDSSt)));
 s:=s+',SumStAg='+sql.MakeStr(StrTo00(FloatToStr(SumStAg)));
 s:=s+',NDSStAg='+sql.MakeStr(StrTo00(FloatToStr(NDSStAg)));
 s:=S+', Sum = '+sql.MakeStr(StrTo00(FloatToStr(SumNDS)))  ;
 s:=s+', NDS = '+sql.MakeStr(StrTo00(FloatToStr(NDS)));
 s:=s+', Fee = '+sql.MakeStr(StrTo00(FloatToStr(Fee)));


 if sql.UpdateString(EntrySec.invoice_table {'Invoice'},s,'Ident='+IntToStr(qIn.fieldByName('Ident').asInteger))<>0
  then begin
       sql.Rollback;
       ShowMessage('В заполнении произошел збой на номере '+
       qIn.fieldByName('Ident').asstring+' '+
       qIn.fieldByName('Number').asstring +'!');
       sql.Delete('PrintInvoice','Send_Ident in ('+strIdSend+')');
       Break;
       end;
 sql.Delete('PrintInvoice','Send_Ident in ('+StrIdSend+')');
 qIN.Next;
 end;

 qIn.Free;

end;

Procedure InvoiceCompare;
var
    q,qIn:TQuery;
    s,s1:string;
    SumControl:real;{введена для контроля старой суммы с/ф с новой}
     SumNDS:real; {сумма с НДС}
     Sum:real;     {сумма без НДС}
     NDS:real;    {сумма НДС}
     Fee:real;    {сумма вознаграждение агента}
    SumGd:  Real;    {сумма за жд перевозку}
    NDSGD:  Real;    {НДС с суммы за жд перевозку}
    SumAvt: Real;    {сумма за авто перевозку}
    NDSAvt: Real;    {НДС с суммы за авто перевозку}
    SumAg:  Real;    {сумма вознагрождение агента}
    NDSAg:  Real;    {НДС с вознаграждения агента}
    SumPak: Real;    {сумма за упаковку}
    NDSPak: Real;    {НДС с суммы за упаковку}
    SumPakAg:Real;   {сумма вознаграждения за упаковку}
    NDSPakAg:Real;   {НДС с суммы вознаграждения за упаковку}
    SumSt:  real;    {сумма страхования}
    NDSSt:  real;    {НДС со страхования}
    SumStAg:real;    {сумма вознаграждения агента за страхование}
    NDSStAg:real;    {НДС с суммы вознагражд. агента за страх.}
    strIdSend, num:string;
    J,M,K,C:TextFile;
    Test : boolean;
    FH:integer;
    Num1,Num2:integer;
    NEWN:integer;
    label T;
begin
test:=false;
DefaultTextLineBreakStyle:=tlbsCRLF;
//--------------------------
if not FileExists(systemdir+'NumberINV') then
       begin
       FH:=FileCreate(systemdir+'NumberINV'); {создаем если нет файла}
       FileClose(FH);
       end;
               AssignFile(m,systemdir+'NumberINV');              {очищаем файл}
               {$I-}
               Rewrite(m)  ;
               {$I-}
               Writeln (m,'Номера счет-фактур#13#1010');
               CloseFile(m);
//------------------------------
 if not FileExists(systemdir+'NoSends') then
       begin
       FH:=FileCreate(systemdir+'NoSends'); {создаем если нет файла}
       FileClose(FH);
       end;
               AssignFile(K,systemdir+'NoSends');              {очищаем файл}
               {$I-}
               Rewrite(k)  ;
               {$I-}
               Writeln (K,'Номера счет фактур, на которые не найдены отправки:#13#1010');
               CloseFile(K);
//------------------------------
 if not FileExists(systemdir+'BadClient') then
       begin
       FH:=FileCreate(systemdir+'BadClient'); {создаем если нет файла}
       FileClose(FH);
       end;
               AssignFile(C,systemdir+'BadClient');              {очищаем файл}
               {$I-}
               Rewrite(c)  ;
               {$I-}
               Writeln (c,'Номера отправок, в которых заказчик не совпадает с заказчиком в с/ф:#13#1010');
               CloseFile(c);
//---------------------------
 if not FileExists(systemdir+'BadInvoice') then
           begin
           FH:=FileCreate(systemdir+'BadInvoice'); {создаем если нет файла}
           FileClose(FH);
           end ;
               AssignFile(j,systemdir+'BadInvoice');              {очищаем файл}
               {$I-}
               Rewrite(j)  ;
               {$I-}
               Writeln (j,'Номера и данные счет-фактур, у которых старые значения не сошлись с новыми.#13#1010');
               Writeln (j,'В первой строке перечисляются старые данные, во второй новые.#13#1010');
               Writeln (j,' ');
               Writeln (j,'   Номер   |'+'Сумма с НДС|'+'    НДС    |'+'Возн. агент|'+
                          ' Сумма ж/д |'+' НДС с ж/д |'+'Сумма авто.|'+'НДС с авто.|'+
                          'Воз. перев.|'+'НДС воз/пер|'+'Сумма упак.|'+'НДС с упак.|'+
                          'Воз/аг/упак|'+'НДС с аг/уп|'+'Сумма страх|'+'НДС с страх|'+
                          'Возy/аг/стр|'+'НДС с аг/ст|#13#1010');
              writeln(j,'--------------------------------------------------'+
                        '--------------------------------------------------'+
                        '--------------------------------------------------'+
                        '--------------------------------------------------'+
                        '----------------#13#1010');  {216 символов}

                          
               CloseFile(j);
//------------------------------

 qIn:=sql.Select(EntrySec.invoiceview_view {'InvoiceView'},'','Data > ''2003-12-31''','Num');
Num2:=0;
//if not qIn.eof  then Num2:=1;
T: while  (not qIn.eof) do
 begin
 Test:=false;
 num1:=0;
 Num2:=Num2+1;
             num1:= qIn.fieldByName('Num').asinteger;    {список не заполненных номеров}
//             while Num2<>Num1 do
//             begin
               num:=IntToStr(Num1);
               AssignFile(m,systemdir+'NumberINV');
               {$I-}
               Append(m)  ;
               {$I-}
               Writeln (m,num);
                CloseFile(m);
//               Num2:=Num2+1;
//            end;
   strIdSend:='';
   NEWN:=1;

       q:=sql.Select(EntrySec.sends_view {'Sends'},'DateSupp,Ident,CountInvoice,Client_Ident,Namber,ClientAcr','Invoice_Ident='+
              qIn.fieldByName('Ident').asString,'DateSupp');
       if not q.Eof then
       begin
        while not q.Eof do
        begin
        if (qIn.FieldByName('Clients_Ident').asInteger <>
            q.FieldByName('Client_Ident').AsInteger) then
            begin
            num:='';
            num:=num+'Счет-фактура: № '+qIn.fieldbyName('Number').AsString;
            num:=num+', клиент: '+qIn.fieldByName('Acronym').AsString;
            num:=num+'.    Отправка: № '+q.FieldByName('Namber').AsString;
            Num:=num+', заказчик: '+q.FieldByName('ClientAcr').AsString+'.';
                AssignFile(c,systemdir+'BadClient');
               {$I-}
               Append(c)  ;
               {$I-}
               Writeln (c,num);
                CloseFile(c);

            end;
         strIdSend:=strIdSend+','+q.FieldByName('Ident').AsString;
        q.Next;
        end;
        if (Pos(',',strIdSend)=1) then
            Delete(strIdSend,1,1);
        InvoiceCount(qIn.fieldByName('Clients_Ident').asInteger,StrIdSend,NEWN);
       end
         else begin
              // ShowMessage('Ненайдено отправок на счет фактуру с идентом и номером '+
               //qIn.fieldByName('Ident').asstring+' '+
              // qIn.fieldByName('Number').asstring +'!');
               AssignFile(k,systemdir+'NoSends');
               {$I-}
               Append(k)  ;
               {$I-}
               Writeln (k,qIn.fieldByName('Number').asstring+'   '+
                          sql.selectString('Clients','Acronym','Ident='+
                                         qIn.fieldByName('Clients_Ident').asstring));
                CloseFile(k);
               qIN.Next;
               goto T;
               exit
              end;
       q.Free;
//---------------------------------------
//SumControl:=0;
//SumControl:=qIn.fieldByName('Sum').asFloat;
  Sum:=0;
  SumNDS:=0;
  NDS:=0;
  Fee:=0;
    SumGd:=0;
    NDSGD:=0;
    SumAvt:=0;
    NDSAvt:=0;
    SumAg:=0;
    NDSAg:=0;
    SumPak:=0;
    NDSPak:=0;
    SumPakAg:=0;
    NDSPakAg:=0;
    SumSt:=0;
    NDSSt:=0;
    SumStAg:=0;
    NDSStAg:=0;
//----------------
q:=sql.Select('PrintInvoice','Sum,SumNDS,NDS','Send_Ident in ('+strIdSend+')','');
  if q.Eof then exit
  else begin
        While (not q.eof) do
        begin
         Sum:=Sum+q.FieldByName('Sum').AsFloat;
         SumNDS:=SumNDS+q.FieldByName('SumNDS').AsFloat;
         NDS:=NDS+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
       end;
  q.Free;
 //----------------------
 //Controlled
{ If FloatToStr(SumNDS)<>FloatToStr(SumControl) then
 begin

               ShowMessage('Старая сумма не сошлась с новой в с/ф '+
               qIn.fieldByName('Ident').asstring+' '+
               qIn.fieldByName('Number').asstring +'!'+
               ' Старая = '+FloatToStr(SumControl)+
               ' Новая = '+FloatToStr(SumNDS));
               if not FileExists('c:\dddd') then FileCreate('c:\dddd');
              AssignFile(J,'c:\dddd');
               Append(J)  ;
                Writeln (J,qIn.fieldByName('Number').asstring+' '+
                        FloatToStr(SumControl)+' '+FloatToStr(SumNDS)  );
                CloseFile(J);
               qIN.Next;
               goto T;
               exit

 end;  }
 //-------------------------

   q:=sql.Select('PrintInvoice','NameGood,SumNDS,','Send_Ident in ('+strIdSend+')'+
                 ' and (NameGOOD like ''Вознагр.%'')','');
  while not q.Eof do
  begin
  Fee:=Fee+q.fieldByName('SumNDS').AsFloat;
  q.Next;
  end;
  q.Free;
 //----------------------------
  q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+strIdSend+')'+
                ' and NameGood='+
                sql.Makestr('Перевозка грузобагажа ж/д транспортом'),'') ;
    While (not q.eof) do
        begin
         SumGd:=SumGd+q.FieldByName('SumNDS').AsFloat;
         NDSGD:=NDSGD+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
  q.Free;
 //----------------
    q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')'+
                ' and NameGood='+
                sql.Makestr('Перевозка грузобагажа автотранспортом'),'') ;
    While (not q.eof) do
        begin
         SumAvt:=SumAvt+q.FieldByName('SumNDS').AsFloat;
         NDSAvt:=NDSAvt+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')'+
               ' and NameGood='+
                sql.Makestr('Вознагр. агента за организацию перевозки'),'') ;
    While (not q.eof) do
        begin
         SumAg:=SumAg+q.FieldByName('SumNDS').AsFloat;
         NDSAg:=NDSAg+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')'+
                ' and NameGood='+
                sql.Makestr('Упаковочный материал'),'') ;
    While (not q.eof) do
        begin
         SumPak:=SumPak+q.FieldByName('SumNDS').AsFloat;
         NDSPak:=NDSPak+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')'+
                ' and NameGood='+
                sql.Makestr('Вознагр. агента за упаковку'),'') ;
    While (not q.eof) do
        begin
         SumPakAg:=SumPakAg+q.FieldByName('SumNDS').AsFloat;
         NDSPakAg:=NDSPakAg+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')'+
                ' and NameGood='+
                sql.Makestr('Страхование'),'') ;
    While (not q.eof) do
        begin
         SumSt:=SumSt+q.FieldByName('SumNDS').AsFloat;
         NDSSt:=NDSSt+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')'+
                ' and NameGood='+
                sql.Makestr('Вознагр. агента за страхование'),'') ;
    While (not q.eof) do
        begin
         SumStAg:=SumStAg+q.FieldByName('SumNDS').AsFloat;
         NDSStAg:=NDSStAg+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------

     if (StrTo00(FloatToStr(SumGd))<>qIn.FieldByName('SumGd').asString ) or
        (StrTo00(FloatToStr(Fee))<>qIn.FieldByName('Fee').asString )     or
        (StrTo00(FloatToStr(NDS))<>qIn.FieldByName('NDS').asString )    or
        (StrTo00(FloatToStr(SumNDS))<>qIn.FieldByName('Sum').asString )    or
        (StrTo00(FloatToStr(NDSGD))<>qIn.FieldByName('NDSGD').asString )    or
        (StrTo00(FloatToStr(SumAVT))<>qIn.FieldByName('SumAVT').asString )    or
        (StrTo00(FloatToStr(NDSAVT))<>qIn.FieldByName('NDSAVT').asString )    or
        (StrTo00(FloatToStr(SumAg))<>qIn.FieldByName('SumAg').asString )    or
        (StrTo00(FloatToStr(NDSAg))<>qIn.FieldByName('NDSAg').asString )    or
        (StrTo00(FloatToStr(SumPak))<>qIn.FieldByName('SumPak').asString )    or
        (StrTo00(FloatToStr(NDSPak))<>qIn.FieldByName('NDSPak').asString )    or
        (StrTo00(FloatToStr(SumPakAg))<>qIn.FieldByName('SumPakAg').asString )    or
        (StrTo00(FloatToStr(NDSPakAg))<>qIn.FieldByName('NDSPakAg').asString )    or
        (StrTo00(FloatToStr(SumSt))<>qIn.FieldByName('SumSt').asString )    or
        (StrTo00(FloatToStr(NDSSt))<>qIn.FieldByName('NDSSt').asString )    or
        (StrTo00(FloatToStr(SumStAg))<>qIn.FieldByName('SumStAg').asString )    or
        (StrTo00(FloatToStr(NDSStAg))<>qIn.FieldByName('NDSStAg').asString )
       then Test:=true;
s:='';
s1:='';
if Test then
  begin      {выписываем старые значения}
            s:=s+String12(qIn.FieldByName('Number').asString );
            s:=s+String12(qIn.FieldByName('Sum').asString );
            s:=s+String12(qIn.FieldByName('NDS').asString );
            s:=s+String12(qIn.FieldByName('Fee').asString );
            s:=s+String12(qIn.FieldByName('SumGd').asString );
            s:=s+String12(qIn.FieldByName('NDSGD').asString );
            s:=s+String12(qIn.FieldByName('SumAvt').asString );
            s:=s+String12(qIn.FieldByName('NDSAvt').asString );
            s:=s+String12(qIn.FieldByName('SumAg').asString );
            s:=s+String12(qIn.FieldByName('NDSAg').asString );
            s:=s+String12(qIn.FieldByName('SumPak').asString );
            s:=s+String12(qIn.FieldByName('NDSPak').asString );
            s:=s+String12(qIn.FieldByName('SumPakAg').asString );
            s:=s+String12(qIn.FieldByName('NDSPakAg').asString );
            s:=s+String12(qIn.FieldByName('SumSt').asString );
            s:=s+String12(qIn.FieldByName('NDSSt').asString );
            s:=s+String12(qIn.FieldByName('SumStAg').asString );
            s:=s+String12(qIn.FieldByName('NDSStAg').asString );
            //---------------------------------------------------
   {выписываем новые значения}
 s1:=s1+String12(qIn.FieldByName('Number').asString );
 s1:=S1+String12(StrTo00(FloatToStr(SumNDS)))  ;
 s1:=s1+String12(StrTo00(FloatToStr(NDS)));
 s1:=s1+String12(StrTo00(FloatToStr(Fee)));
 s1:=s1+String12(StrTo00(FloatToStr(SumGd)));
 s1:=s1+String12(StrTo00(FloatToStr(NDSGd)));
 s1:=s1+String12(StrTo00(FloatToStr(SumAvt)));
 s1:=s1+String12(StrTo00(FloatToStr(NDSAvt)));
 s1:=s1+String12(StrTo00(FloatToStr(SumAg)));
 s1:=s1+String12(StrTo00(FloatToStr(NDSAG)));
 s1:=s1+String12(StrTo00(FloatToStr(SumPak)));
 s1:=s1+String12(StrTo00(FloatToStr(NDSPak)));
 s1:=s1+String12(StrTo00(FloatToStr(SumPakAg)));
 s1:=s1+String12(StrTo00(FloatToStr(NDSPakAg)));
 s1:=s1+String12(StrTo00(FloatToStr(SumSt)));
 s1:=s1+String12(StrTo00(FloatToStr(NDSSt)));
 s1:=s1+String12(StrTo00(FloatToStr(SumStAg)));
 s1:=s1+String12(StrTo00(FloatToStr(NDSStAg)));
//---------------------------------------------------------

              AssignFile(J,systemDir+'BadInvoice');
               Append(J)  ;
               {$I-}
                Writeln (J,s+'#13#1010');
                writeln(J,s1+'#13#1010');
                writeln(j,'--------------------------------------------------'+
                          '--------------------------------------------------'+
                          '--------------------------------------------------'+
                          '--------------------------------------------------'+
                          '----------------#13#1010');  {216 символов}
                CloseFile(J);


  end;
 sql.Delete('PrintInvoice','Send_Ident in ('+StrIdSend+')');
 qIN.Next;
 end;

 qIn.Free;
ShowMessage('Работа завершена!');
end;

function String12(st:string):string;
begin
st:=st+'|';
while  Length(st)<12 do
begin
 st:=' '+st;
end;
String12:=st;
end;

function AftoSumCount(Id:longint):real;
var Typ:integer;
    q:TQUEry;
    F1,F,F2,F3,F4,F5,F6,NDS,Sum,pack:Real;
    l,i:longint;
    str,str1:string;
    perc:integer;
    Country:string;
begin
q:=sql.Select(EntrySec.send_table {'Send'},'','Ident ='+ IntToStr(Id),'');//+
if not q.eof then
begin
F1:=0;  {стоимость перевозки авто трансп}
f2:=0;
  Typ:=q.fieldByName('ContractType_Ident').AsInteger;
       str1:='';
       str1:=q.fieldByName('Weight').Asstring;
       if str1<>'' then str1:=', '+str1+' кг.'; {вес отправки для печати в с/ф}

       f1:=q.FieldByName('Fare').AsFloat   ;
       if f1=0 then begin
                     AftoSumCount:=1;
                     q.Free;
                     exit;
                     end;
  if (q.fieldByName('InsuranceValue').Asstring<>'0.00') and
   (q.fieldByName('InsuranceValue').Asstring<>'')
     then
      f1:=f1+q.fieldByName('InsuranceValue').Asfloat;

       if q.fieldByName('AddServiceExp').AsInteger=1 then
        f1:=f1+q.fieldByName('ExpCount').AsFloat*q.fieldByName('ExpTarif').AsFloat;
       if q.fieldByName('AddServiceProp').AsInteger=1 then
        f1:=f1+q.fieldByName('PropCount').AsFloat*q.fieldByName('PropTarif').AsFloat;
       if StrToDate(q.FieldByName('Start').AsString)> StrToDate('31.05.2012') then
         begin       {сумму по доп услуге не суммируем с перевозной платой с 01.06.2012 }
          if (q.fieldByName('AddServSum').AsString <> '') and
             (q.fieldByName('AddServSum').AsString <> '0.00')  and
             (q.fieldByName('AddServSum').AsString <> 'NULL')  then
             f1:=f1+q.fieldByName('AddServSum').AsFloat; {AddServSum}
          end;
       perc:=0;
       perc:=sql.SelectInteger('Constant','PercentSend','');
       f2:=f1*perc/100;
       f2:=StrToFloat(StrTo00(FloatToStr(f2)));
       f1:=f1-f2;

//---------------------

if f1<>0 then
    begin
     AftoSumCount:=f1;
              q.Free;

    end
 else
    begin
     AftoSumCount:=0;
              q.Free;

    end;
///--------------------------------
end;{q.eof}
end;
end.
