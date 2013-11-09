unit FormUnload;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, toolbtn, StdCtrls, Buttons, BMPBtn, ToolWin, ComCtrls, Sqlctrls,
  LblCombo,Printers, LblEdtDt, ExtCtrls,TSQLCLS,SqlGrid, DB,StrUtils,FunChar,
  DBTables, Lbsqlcmb, OleServer, Word2000,XMLDOM, DBClient, MConnect, EntrySec;

type
  TFUnload = class(TForm)
    LabelEditDate1: TLabelEditDate;
    LabelEditDate2: TLabelEditDate;
    btPrint: TBMPBtn;
    eExit: TToolbarButton;
     procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btOkClick(Sender: TObject);
    procedure eExitClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
        function Unload:integer;
        function NullString(s:string):string;
        function NullDate(s:string;Dat:TdateTime):string;
  end;

var
  FUnload: TFUnload;

implementation
uses DLoad;
{$R *.dfm}


function TFUnload.Unload:integer;
var
    S,s1:string;
    TabName,Cond,Filds,Ord: string;
    DatStar,DatFin: string;
    TempList4: TStrings;
    q,qCL:TQuery;
    M:TextFile;
    i,f: integer;
begin
Unload:=0;
DatStar:= LabelEditDate1.TEXT;
DatFin:= LabelEditDate2.text;

if ShowModal=mrOk then
begin
DatStar:= LabelEditDate1.TEXT;
DatFin:= LabelEditDate2.text;
//--------------------------   {Создаем или очищаем лог файл}
if not FileExists(systemdir+'Unload.log') then
       begin
       f:=FileCreate(systemdir+'Unload.log'); {создаем если нет файла}
       FileClose(f) ;
       end;
               AssignFile(m,systemdir+'Unload.log');        {очищаем файл}
               {$I-}
               Rewrite(m)  ;
               {$I-}
               Writeln (m,'Выгружаем данные за период с '+ DatStar+ ' по '+DatFin);
//------------------------------

TempList4 := TStringList.Create;
CreateClearDir;
{1 Выгружаем данные из таблицы 'Bank' при условии все 'Ident>620'}
TabName:='Bank';
Cond:= 'Ident>620';
Ord:='Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:=q.fieldByName('Ident').asstring + '@,@''' + q.fieldByName('Name').asstring +'''@,@'''+
    q.fieldByName('KorCount').asstring + '''@,@''' + q.fieldByName('BIK').asstring+'''';
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
  if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
//TempList4.free;
TempList4 := TStringList.Create;
{------------------------------------------------------}
{2 Выгружаем данные из таблицы 'OnReason' при условии все 'Ident>13'}
TabName:='OnReason';
Cond:= 'Ident>13';
Ord:='Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:=q.fieldByName('Ident').asstring + '@,@''' + q.fieldByName('Name').asstring +'''';
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
  if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}
{3 Выгружаем данные из таблицы 'City' при условии все 'Ident>402'}
TabName:='City';
Cond:= 'Ident>402';
Ord:='Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:=q.fieldByName('Ident').asstring + '@,@''' + q.fieldByName('Name').asstring + '''@,@''' +
q.fieldByName('Tariff200').asstring + '''@,@''' + q.fieldByName('Tariff500').asstring + '''@,@''' +
q.fieldByName('Tariff1000').asstring + '''@,@''' + q.fieldByName('Tariff2000').asstring + '''@,@''' +
q.fieldByName('TariffMore2000').asstring + '''@,@''' + q.fieldByName('Sending').asstring + '''@,@''' +
q.fieldByName('Distance').asstring + '''@,@' + NullString(q.fieldByName('Check').asstring) + '@,@''' +
q.fieldByName('GDStrah').asstring + '''';
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
  if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}
{4 Выгружаем данные из таблицы 'Forwarder' при условии все 'Ident>7938'}
TabName:='Forwarder';
Cond:= 'Ident>7938';
Ord:='Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:=q.fieldByName('Ident').asstring + '@,@''' + q.fieldByName('Name').asstring +'''@,@'+
NullString(q.fieldByName('Clients_Ident').asstring);
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
  if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}
{5 Выгружаем данные из таблицы 'Acceptor' при условии все 'Ident>13930'}
TabName:='Acceptor';
Cond:= 'Ident>13930';
Ord:='Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:=q.fieldByName('Ident').asstring + '@,@''' + q.fieldByName('Name').asstring +'''@,@'''+
q.fieldByName('Regime').asstring + '''@,@''' + q.fieldByName('Phone').asstring + '''@,@' +
NullString(q.fieldByName('City_Ident').asstring) + '@,@''' + q.fieldByName('Address').asstring + '''@,@''' +
q.fieldByName('Coment').asstring + '''';
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
  if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}
{6 Выгружаем данные из таблицы 'Clients' при условии все 'Ident>8862'}
TabName:='Clients';
Cond:= 'Ident>8862';
Ord:='Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:=q.fieldByName('Ident').asstring + '@,@''' + q.fieldByName('Name').asstring +'''@,@'''+
q.fieldByName('Acronym').asstring + '''@,@''' + q.fieldByName('FullName').asstring + '''@,@''' +
q.fieldByName('Telephone').asstring + '''@,@''' + q.fieldByName('Fax').asstring + '''@,@''' +
q.fieldByName('Email').asstring + '''@,@'''+ q.fieldByName('INN').asstring + '''@,@'''+
q.fieldByName('CalculatCount').asstring + '''@,@'+NullString(q.fieldByName('Bank_Ident').asstring)+ '@,@'''+
q.fieldByName('OKONX').asstring + '''@,@'''+ q.fieldByName('OKPO').asstring + '''@,@'''+
q.fieldByName('InPerson').asstring + '''@,@'+ NullString(q.fieldByName('OnReason_Ident').asstring) + '@,@'+
NullString(q.fieldByName('ClientType_Ident').asstring) + '@,@'+
NullDate(q.fieldByName('Start').asString,q.fieldByName('Start').asDateTime) + '@,@'+
NullDate(q.fieldByName('DateUpd').asString,q.fieldByName('DateUpd').asDateTime) + '@,@'+
NullDate(q.fieldByName('Finish').asString,q.fieldByName('Finish').asDateTime) + '@,@'+
NullString(q.fieldByName('City_Ident').asstring) + '@,@'+ NullString(q.fieldByName('Country_Ident').asstring) + '@,@'+
NullString(q.fieldByName('PersonType_Ident').asstring) + '@,@'+ NullString(q.fieldByName('Forwarder_Ident').asstring) + '@,@'''+
q.fieldByName('Kredit').asstring + '''@,@'+ NullString(q.fieldByName('NameGood_Ident').asstring) + '@,@'''+
q.fieldByName('KPP').asstring + '''';

if q.fieldByName('City_Ident').asstring <>'' then
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
  if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}
{7 Выгружаем данные из таблицы 'NameGood' при условии все 'Ident>1026'}
TabName:='NameGood';
Cond:= 'Ident>1026';
Ord:='Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:=q.fieldByName('Ident').asstring + '@,@''' + q.fieldByName('Name').asstring +'''@,@'+
NullString(q.fieldByName('Clients_Ident').asstring) ;
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
  if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}

{8 Выгружаем данные из таблицы 'Address' при условии все 'Clients_Ident>8862'}
TabName:='Address';
Cond:= 'Clients_Ident>8862';
Ord:='Clients_Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:= NullString(q.fieldByName('Clients_Ident').asstring) + '@,@' +NullString(q.fieldByName('AddressType_Ident').asstring)+
'@,@''' +q.fieldByName('AdrName').asstring +'''' ;
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
  if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}

{9 Выгружаем данные из таблицы 'Contact' при условии все 'Clients_Ident>8862'}
TabName:='Contact';
Cond:= 'Clients_Ident>8862';
Ord:='Clients_Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:= NullString(q.fieldByName('Clients_Ident').asstring) + '@,@'''+q.fieldByName('Name').asstring+
'''@,@''' +q.fieldByName('Phone').asstring +'''' ;
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
  if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}

{10 Выгружаем данные из таблицы 'Contract' при условии все 'Clients_Ident>8862'}
TabName:='Contract';
Cond:= 'Clients_Ident>8862';
Ord:='Clients_Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:= NullString(q.fieldByName('Clients_Ident').asstring) + '@,@'''+NullString(q.fieldByName('Number').asstring)+
'''@,@' +NullDate(q.fieldByName('Start').asString,q.fieldByName('Start').asDateTime) +
'@,@' +NullDate(q.fieldByName('Finish').asString,q.fieldByName('Finish').asDateTime) +
'@,@' +q.fieldByName('ContractType_Ident').asstring ;
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
  if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}

{11 Выгружаем данные из таблицы 'Order' при условии все 'DatNow><'}
TabName:=EntrySec.order_table {'`Order`'};
Cond:= '(Dat>='''+FormatDateTime('yyyy-mm-dd',StrToDate(DatStar))+''' and '+
'Dat<='''+FormatDateTime('yyyy-mm-dd',StrToDate(DatFin))+''')' ;
Ord:='Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:= q.fieldByName('Ident').asstring + '@,@'+NullString(q.fieldByName('Client_Ident').asstring)+
'@,@''' +q.fieldByName('Number').asstring +'''@,@' +
NullDate(q.fieldByName('Dat').asString,q.fieldByName('Dat').asDateTime) +
'@,@''' +q.fieldByName('Sum').asstring +'''@,@''' +q.fieldByName('NDS').asstring +
'''@,@''' +q.fieldByName('SumNDS').asstring +'''@,@''' +q.fieldByName('NSP').asstring +
'''@,@' +NullDate(q.fieldByName('DatNow').asString,q.fieldByName('DatNow').asDateTime) ;
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
  if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}

{12 Выгружаем данные из таблицы 'Supplier' при условии все 'DatNow><'}
TabName:='Supplier';
Cond:= 'Ident>16' ;
Ord:='Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:= q.fieldByName('Ident').asstring + '@,@''' +q.fieldByName('Name').asstring +'''';
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
 if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}

{13 Выгружаем данные из таблицы 'Send' при условии все 'Start><'}
TabName:=EntrySec.send_table {'Send'};
Cond:= '(`start`>='''+FormatDateTime('yyyy-mm-dd',StrToDate(DatStar))+''' and '+
'`Start`<='''+FormatDateTime('yyyy-mm-dd',StrToDate(DatFin))+''')' ;
Ord:='Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:= q.fieldByName('Ident').asstring + '@,@'+NullString(q.fieldByName('Client_Ident').asstring)+
'@,@' +NullString(q.fieldByName('Client_Ident_Sender').asstring) +'@,@' +NullString(q.fieldByName('City_Ident').asstring) +
'@,@' +NullString(q.fieldByName('Acceptor_Ident').asstring) +'@,@' +NullString(q.fieldByName('Forwarder_Ident').asstring) +
'@,@' +NullString(q.fieldByName('NameGood_Ident').asstring) +'@,@' +NullString(q.fieldByName('Supplier_Ident').asstring) +
'@,@''' +q.fieldByName('Namber').asstring +'''@,@' +
NullDate(q.fieldByName('Start').asString,q.fieldByName('Start').asDateTime) +
'@,@''' +q.fieldByName('Credit').asstring +'''@,@''' +q.fieldByName('Contract').asstring +
'''@,@' +NullString(q.fieldByName('Inspector_Ident').asstring) +'@,@' +NullString(q.fieldByName('ContractType_Ident').asstring) +
'@,@' +NullString(q.fieldByName('RollOut_Ident').asstring) +'@,@' +NullString(q.fieldByName('TypeGood_Ident').asstring) +
'@,@' +NullString(q.fieldByName('Weight').asstring) +'@,@' +
NullDate(q.fieldByName('DateSend').asString,q.fieldByName('DateSend').asDateTime) +
'@,@''' +q.fieldByName('Volume').asstring +'''@,@''' +q.fieldByName('CountWeight').asstring +
'''@,@''' +q.fieldByName('Tariff').asstring +'''@,@''' +q.fieldByName('Fare').asstring +
'''@,@''' +q.fieldByName('PackTarif').asstring +'''@,@' +NullString(q.fieldByName('AddServiceExp').asstring) +
'@,@' +NullString(q.fieldByName('AddServicePack').asstring) +'@,@' +NullString(q.fieldByName('AddServiceProp').asstring) +
'@,@''' +q.fieldByName('AddServicePrace').asstring +'''@,@''' +q.fieldByName('InsuranceSum').asstring +
'''@,@''' +q.fieldByName('InsurancePercent').asstring +'''@,@''' +q.fieldByName('InsuranceValue').asstring +
'''@,@''' +q.fieldByName('SumCount').asstring +'''@,@' +NullString(q.fieldByName('TypeGood_Ident1').asstring) +
'@,@' +NullString(q.fieldByName('TypeGood_Ident2').asstring) +'@,@' +NullString(q.fieldByName('PayType_Ident').asstring) +
'@,@''' +q.fieldByName('NmberOrder').asstring +'''@,@''' +q.fieldByName('NumberCountPattern').asstring +
'''@,@''' +q.fieldByName('PayText').asstring +'''@,@' +NullString(q.fieldByName('StatusSupp_Ident').asstring) +
'@,@' +NullDate(q.fieldByName('DateSupp').asString,q.fieldByName('DateSupp').asDateTime) +
'@,@''' +q.fieldByName('SuppText').asstring +
'''@,@''' +q.fieldByName('PackCount').asstring +'''@,@''' +q.fieldByName('ExpCount').asstring +
'''@,@' +NullString(q.fieldByName('PropCount').asstring) +'@,@''' +q.fieldByName('ExpTarif').asstring +
'''@,@''' +q.fieldByName('PropTarif').asstring +'''@,@' +NullString(q.fieldByName('Check').asstring) +
'@,@' +NullString(q.fieldByName('Train_Ident').asstring) +'@,@'''+q.fieldByName('SumWay').asstring +
'''@,@''' +q.fieldByName('NumberWay').asstring +'''@,@''' +q.fieldByName('SumServ').asstring +
'''@,@''' +q.fieldByName('NumberServ').asstring +'''@,@' +NullString(q.fieldByName('WeightGd').asstring) +
'@,@''' +q.fieldByName('PlaceGd').asstring +'''@,@''' +q.fieldByName('NumberPP').asstring +
'''@,@' +NullString(q.fieldByName('CountInvoice').asstring) +'@,@' +NullString(q.fieldByName('PlaceC').asstring) +
'@,@' +NullString(q.fieldByName('PayTypeServ_Ident').asstring) +'@,@' +NullString(q.fieldByName('PayTypeWay_Ident').asstring) +
'@,@' +NullString(q.fieldByName('Invoice_Ident').asstring) +'@,@'''+q.fieldByName('InsurancePay').asstring +
'''@,@' +NullString(q.fieldByName('Akttek_Ident').asstring) +'@,@''' +q.fieldByName('AddServStr').asstring +
'''@,@''' +q.fieldByName('AddServSum').asstring +'''@,@'+NullString(q.fieldByName('TypeGood_Ident3').asstring)+
'@,@' +NullString(q.fieldByName('PrivilegedTariff').asstring);

if q.fieldByName('Client_Ident').asstring<>'' then
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
 if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}

{14 Выгружаем данные из таблицы 'SendPack' при условии все 'Send_Ident in start><'}
TabName:='SendPack';
Cond:= 'Send_Ident in (Select Ident from Send where (`start`>='''+FormatDateTime('yyyy-mm-dd',StrToDate(DatStar))+''' and '+
'`Start`<='''+FormatDateTime('yyyy-mm-dd',StrToDate(DatFin))+'''))' ;
Ord:='Send_Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:= NullString(q.fieldByName('Send_Ident').asstring) + '@,@''' +q.fieldByName('Name').asstring +'''@,@'+
NullString(q.fieldByName('Count').asstring) ;
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
 if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
TempList4 := TStringList.Create;
{-------------------------------------------------------}

{15 Выгружаем данные из таблицы 'SendPackTariff' при условии все 'Send_Ident in start><'}
TabName:='SendPackTariff';
Cond:= 'Send_Ident in (Select Ident from Send where (`start`>='''+FormatDateTime('yyyy-mm-dd',StrToDate(DatStar))+''' and '+
'`Start`<='''+FormatDateTime('yyyy-mm-dd',StrToDate(DatFin))+'''))' ;
Ord:='Send_Ident';
q:=sql.Select(TabName,'*',Cond,Ord);
i:=0; {счетчик данных}
while (not q.Eof) do
begin
s1:= NullString(q.fieldByName('Send_Ident').asstring) + '@,@''' +q.fieldByName('PackName').asstring +'''@,@'+
NullString(q.fieldByName('Count').asstring) + '@,@''' +q.fieldByName('Tariff').asstring +'''';
TempList4.add(s1);
q.Next;
i:=i+1;
end;
q.Free;
UnltoFile(TempList4,TabName,'');
 if i<>0 then
   begin
     Writeln (m,'Выгружeно '+IntToStr(i)+' данных из таблицы: '+TabName);
   end;
{-------------------------------------------------------}
CloseFile(m) ;

Unload:=1;
end;

end;

procedure TFUnload.btOkClick(Sender: TObject);
begin
try
if  (strToDate(LabelEditDate1.Text) > StrToDate(LabelEditDate2.Text))  then
  begin
      Application.MessageBox('Дата "с" больше даты "по"!','Ошибка!',0);
      exit
  end;
except
 Application.MessageBox('Проверьте правильность введенных дат!','Ошибка!',0);
 exit
end;
 ModalResult:=mrOk;
end;

procedure TFUnload.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOkClick(Sender)
end;

procedure TFUnload.eExitClick(Sender: TObject);
begin
 ModalResult:=mrCancel;
end;

function TFUnload.NullString(s:string):string;
begin
if s <> '' then
  NullString:=s
else NullString:='NULL';
end;

function TFUnload.NullDate(s:string;Dat:TdateTime):string;
begin
if s <> '' then
  NullDate:=''''+FormatDateTime('yyyy-mm-dd',Dat)+''''
else NullDate:='NULL';
end;

end.
