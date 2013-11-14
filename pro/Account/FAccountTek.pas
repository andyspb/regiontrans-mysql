unit FAccountTek;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Lbledit, LblEdtDt, Sqlctrls, Lbsqlcmb, StdCtrls, Buttons,
  BMPBtn, ComCtrls,DB,TSQLCLS,DBTables,Tadjform, SqlGrid, OleServer,
  Word2000,Printers,QDialogs, EntrySec;

type
  TFormAccountTEK = class(TForm)
    HeaderControl1: THeaderControl;
    btPrint: TBMPBtn;
    btCansel: TBMPBtn;
    cbClient: TLabelSQLComboBox;
    eSumNDS: TLabelEdit;
    LabelEditDate1: TLabelEditDate;
    BMPBtn1: TBMPBtn;
    WordApplication1: TWordApplication;
    procedure btCanselClick(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure Print;
    procedure FormCreate;
    procedure eSumNDSChange(Sender: TObject);
    procedure cbClientChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BMPBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
  Function AddRecord:longint;
  Function EditRecord(Iden:longInt):longint;
  Function Num:string;
    { Public declarations }
  end;

var
  FormAccountTEK: TFormAccountTEK;
  Number:string;
  Ident:longint;
  Enabl:boolean;
  NewN:integer;
implementation
Uses makerepp ,SendStr, Menu,Invoice,Finvoice, FAKT;
{$R *.dfm}
Function TFormAccountTEK.AddRecord:longint;
var  l:longint;
      str:string;
  fields: string;
  ins_thread: TInsertThread;
begin

Enabl:=true;
FormAccounttek.FormCreate;
Number:='';
//Ptype:=0;
Ident:=0;
LabelEditDate1.Text:=FormatDateTime('dd.mm.yyyy',now);
if showModal=mrOk then
begin
l:=sql.FindNextInteger('Ident',EntrySec.accounttek_table {'`AccountTEK`'},'',MaxLongint);
str:=IntToStr(L);
str:=str+','+Sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.Text)));
if  eSumNDS.text<>'' then
 str:=str+','+sql.MakeStr(eSumNDS.text)
 else str:=str+',NULL';
if cbClient.GetData<>0 then
 str:=str+','+IntToStr(cbClient.GetData)
 else str:=str+',NULL';
Number:=Num;
 str:=str+','+sql.MakeStr(Number);

fields:='Ident,Dat,Sum,Client_Ident,Number';
if sql.insertstring(EntrySec.accounttek_table {'`AccountTEK`'},fields,str)=0
then begin AddRecord:=l;
// success
// update other table
  ins_thread:= TInsertThread.Create(True, EntrySec.accounttek_table_other, fields, str);
  ins_thread.Resume();
end
  else begin
        AddRecord:=0;
        exit;
       end;
NewN:=1;
Print;
end else AddRecord:=0;
end;

Function TFormAccountTEK.EditRecord(Iden:longInt):longint;
var q:TQuery;
    I:longint;
    Sum:real;
begin

Enabl:=false;
FormCreate;
I:=Iden;
q:=sql.Select(EntrySec.accounttek_table {'`AccountTEK`'},'*','Ident='+IntToStr(Iden),'');
Number:=q.fieldByName('Number').asString;
LabelEditDate1.SetValue(q);
//cbClient.SetValue(q);
cbClient.SQLComboBox.SetActive(q.fieldByName('Client_Ident').asInteger);
eSumNDS.SetValue(q);
 Sum:=(StrToFloat(eSumNDS.text));

Ident:=cbClient.getdata;
//Ptype:=sql.SelectInteger('Clients','PersonType_Ident','Ident='+IntToStr(Ident));

q.Free;
if showModal=mrOk then
begin
NewN:=1;
Print;
EditRecord:= I;
end else   EditRecord:= I;
end;


procedure TFormAccountTEK.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TFormAccountTEK.btPrintClick(Sender: TObject);
var l:longint;
    label Next1;
begin
{if Enabl=true then
begin
case Application.MessageBox('','',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
     ModalResult:=mrOk;
    end;
    IDNO:Print;
end;
end else } ModalResult:=mrOk;
if Invoice.InvoiceTest(cbClient.getdata,Now) then
begin
case Application.MessageBox('Пора распечатать акт! Подтвердите печать!',
                            'Сообщение',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
     FormAkt:=TFormAkt.Create(Application) ;
     l:=FormAkt.AddRecord(cbClient.getdata);
     FormAkt.Free;
     
    end;
    IDNO:begin
         goto next1 ;
         exit
         end;
end;
end;
Next1:
end;

Function TFormAccountTEK.Num:string;
var
  q:TQuery;
  Year, Month, Day: Word;
  Num1,Num2:string;
  N1,N2:integer;
begin
  if LabelEditDate1.text<>'  .  .    '  then
    DecodeDate(StrToDate(LabelEditDate1.text), Year, Month, Day)
  else
  begin
    Application.MessageBox('Введите дату составления!','Ошибка!',0);
    exit
   end;
  q:=sql.select(EntrySec.accounttekview_view {'`AccountTEKView`'},'Number,`Year`','`Year`='+IntToStr(Year),'');
if q.eof then Num:='1/'+FormatDateTime('yy',StrToDate(LabelEditDate1.text))
     else
     begin
      Num1:=q.fieldByName('Number').AsString;
      N1:=pos('/',Num1);
      delete(Num1,N1,Length(Num1)-N1+1) ;
      N1:=StrToInt(Num1);
      while not q.Eof do
      begin
      Num2:=q.fieldByName('Number').AsString;
      N2:=pos('/',Num2);
      delete(Num2,N2,Length(Num2)-N2+1) ;
      N2:=StrToInt(Num2);
      if N1<N2 then N1:=N2;
      q.Next;
      end;
     Num:=IntToStr(N1+1)+'/'+FormatDateTime('yy',StrToDate(LabelEditDate1.text));
     end;

 q.free;
end;

procedure TFormAccountTEK.FormCreate;
begin
if Enabl then
begin
 cbClient.Enabled:=true;
 LabelEditDate1.Enabled:=true;
 eSumNDS.Enabled:=true;
end else begin
           cbClient.Enabled:=false;
           LabelEditDate1.Enabled:=false;
           eSumNDS.Enabled:=false;
         end;
end;
procedure TFormAccountTEK.eSumNDSChange(Sender: TObject);
begin
try
if (eSumNDS.text<>'') then
   eSumNDS.text:=StrTo00(eSumNDS.text)
else
   eSumNDS.text:='0.00';
except
//eSumNDS.text:='';
application.MessageBox('Проверьте введенную сумму!','Ошибка!',0);
exit
end
end;

procedure TFormAccountTEK.cbClientChange(Sender: TObject); 
var Sum,s:string;
begin
if  cbClient.getdata<>0 then
begin
Ident:=cbClient.getdata;
Sum:=SendStr.CreditType(Ident,1);
s:=copy(Sum,1,1);
if s='-' then
 begin
  Sum:=copy(Sum,2,Length(Sum)-1);
  eSumNDS.text:=StrTo00(FloatTOStr(StrToFloat(Sum)));
 end
  else
    eSumNDS.text:='0.00';    
end;
end;

procedure TFormAccountTEK.Print;
var ReportMakerWP:TReportMakerWP;
    p,w1,w2,w3,w4: OleVariant;
    s,s2, mach: string;
    q:tQuery;
    i1,i2,i3,i4: integer;
label T;
begin
try
  ReportMakerWP:=TReportMakerWP.Create(Application);
  ReportMakerWP.ClearParam;
//--------  
  q:=sql.Select('BOSS','*','','');
  ReportMakerWP.AddParam('1='+Number);
  s:=SendStr.DataDMstrY(StrToDate(LabelEditDate1.text));
  ReportMakerWP.AddParam('2='+s);
  //-------------------------------------------

  ReportMakerWP.AddParam('14='+q.FieldByName('Person').asstring);
  ReportMakerWP.AddParam('15='+q.FieldByName('PersonBug').asstring);
  q.Free;
//---------
  q:=sql.Select('Clients','*','Ident='+IntToStr(cbClient.SQLComboBox.GetData),'');
  ReportMakerWP.AddParam('16='+q.FieldByName('Name').asstring);
  s:=sql.SelectString('Address','AdrName','Clients_Ident='+
                      IntToStr(cbClient.SQLComboBox.GetData)+
                      ' and Addresstype_Ident='+intToStr(1));
  ReportMakerWP.AddParam('17='+s);
  ReportMakerWP.AddParam('18='+q.FieldByName('Telephone').asstring);
  ReportMakerWP.AddParam('19='+q.FieldByName('INN').asstring);
  ReportMakerWP.AddParam('20='+q.FieldByName('CalculatCount').asstring);
  s:=sql.SelectString('Bank','Name','Ident='+IntToStr(q.fieldByName('Bank_Ident').asInteger));
  ReportMakerWP.AddParam('21='+s);
  s:=sql.SelectString('Bank','KorCount','Ident='+IntToStr(q.fieldByName('Bank_Ident').asInteger));
  ReportMakerWP.AddParam('22='+s);
  s:=sql.SelectString('Bank','BIK','Ident='+IntToStr(q.fieldByName('Bank_Ident').asInteger));
  ReportMakerWP.AddParam('23='+s);
  s:=sql.SelectString('City','Name','Ident='+IntToStr(q.fieldByName('City_Ident').asInteger));
  ReportMakerWP.AddParam('24='+s);
  ReportMakerWP.AddParam('25='+q.FieldByName('OKONX').asstring);
  ReportMakerWP.AddParam('26='+q.FieldByName('OKPO').asstring);
  q.Free;
   if sql.SelectString('Contract','Number','Clients_Ident='+
                         IntToStr(cbClient.SQLComboBox.GetData)+
                         ' and `Start`<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+
                         ' and ContractType_Ident=1 and (Finish is NULL or Finish>'+
                         sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+')')<>'' then
  begin
  ReportMakerWP.AddParam('27='+'№ '+sql.SelectString('Contract','Number','Clients_Ident='+
                         IntToStr(cbClient.SQLComboBox.GetData)+
                         ' and `Start`<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+
                         ' and ContractType_Ident=1 and (Finish is NULL or Finish>'+
                         sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+')'));
   s2:=FormatDateTime('dd.mm.yyyy',StrToDate(sql.SelectString('Contract','Start','Clients_Ident='+
                         IntToStr(cbClient.SQLComboBox.GetData)+
                         ' and `Start`<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+
                         ' and ContractType_Ident=1 and (Finish is NULL or Finish>'+
                         sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+')')));
  ReportMakerWP.AddParam('28='+' от '+S2+' г. (жд)');
  end else begin
           ReportMakerWP.AddParam('27='+'');
           ReportMakerWP.AddParam('28='+'');
           end;
  if sql.SelectString('Contract','Number','Clients_Ident='+
                         IntToStr(cbClient.SQLComboBox.GetData)+
                         ' and `Start`<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+
                         ' and ContractType_Ident=2 and (Finish is NULL or Finish>'+
                         sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+')')<>'' then
  begin
  ReportMakerWP.AddParam('29='+'№ '+sql.SelectString('Contract','Number','Clients_Ident='+
                         IntToStr(cbClient.SQLComboBox.GetData)+
                         ' and `Start`<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+
                         ' and ContractType_Ident=2 and (Finish is NULL or Finish>'+
                         sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+')'));
  ReportMakerWP.AddParam('30='+' от '+FormatDateTime('dd.mm.yyyy',StrToDate(sql.SelectString('Contract','Start','Clients_Ident='+
                         IntToStr(cbClient.SQLComboBox.GetData)+
                         ' and `Start`<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+
                         ' and ContractType_Ident=2 and (Finish is NULL or Finish>'+
                         sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+')')))+
                         ' г. (авто)');
  end else begin
           ReportMakerWP.AddParam('29='+'');
           ReportMakerWP.AddParam('30='+'');
           end;
  if  (sql.SelectString('Contract','Number','Clients_Ident='+
                         IntToStr(cbClient.SQLComboBox.GetData)+
                         ' and ContractType_Ident=2 and Finish is NULL or Finish>'+
                         sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text))))<>'') and
       (sql.SelectString('Contract','Number','Clients_Ident='+
                         IntToStr(cbClient.SQLComboBox.GetData)+
                         ' and ContractType_Ident=1 and Finish is NULL or Finish>'+
                         sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text))))<>'')
  then  ReportMakerWP.AddParam('31='+', ') else ReportMakerWP.AddParam('31='+'');
  ReportMakerWP.AddParam('34='+eSumNDS.text);
  s:=SendStr.MoneyToString(eSumNDS.text);
  ReportMakerWP.AddParam('35='+s);
  if ReportMakerWP.DoMakeReport(systemdir+'Account\AccountTEK.rtf',
          systemdir+'Account\AccountTEK.ini', systemdir+'Account\out.rtf')<>0 then
                              begin
                              ReportMakerWP.Free;  
                              //goto T;
                              exit
                              end;;
  ReportMakerWP.Free;

WordApplication1:=TWordApplication.Create(Application);
  p := systemdir+'Account\out.rtf';
  {спрашиваем колличество копий}
   i1:=0;
   i2:=0;
   i3:=5;
   i4:=1;
   if InputQuery('Диалог!','Какое количество копий счета распечатать?',i1,i2,i3,i4) then
   w1:=i1;
if i1 = 0 then w1:=1;      {если не задано, то печаем одну копию}
 // w1:=2;
  mach:='';
  mach:= trim(WordApplication1.UserName);
  w2:=sql.SelectString('Printer','NameA4','ComputerName='+sql.MakeStr(mach));
 WordApplication1.Documents.Open(p,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam);
//print.SetPrinter('HP DeskJet 610C','WINSPOOL','',h);
w3:=sql.SelectString('Printer','ComNameA4','ComputerName='+sql.MakeStr(mach));
if  (VarToStr(w2)='') or (VarToStr(w3)='') then
begin
application.MessageBox('Информация о принтерах не внесена в базу для данной машины'+
                       ' или в параметрах WinWord не верно указано имя машины!','Ошибка!',0);
 goto T;
 exit;
end;

w4:=WordApplication1.UserName;
if w3<>w4 then   w2:= '\\'+w3+'\'+w2;
WordApplication1.ActivePrinter:=w2;
WordApplication1.ActiveDocument.PrintOut(
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam, EmptyParam,EmptyParam,
	EmptyParam,w1,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
        w2,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam,EmptyParam);    
T: WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
        WordApplication1.WindowState:=2;
WordApplication1.Free;
except
WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
application.MessageBox('Проверьте все настройки для печати!','Ошибка!',0);
exit
end;

end;


procedure TFormAccountTEK.FormActivate(Sender: TObject);
begin
 //cbClient.SQLComboBox.Sorted:=true;
 Ident:=0;

end;

procedure TFormAccountTEK.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key = VK_Return
  then btPrintClick(Sender)
end;

procedure TFormAccountTEK.BMPBtn1Click(Sender: TObject);
var
Sum:string;
dat:Tdate;
begin
try
dat:=StrToDate(LabelEditDate1.text);
if  cbClient.getdata<>0 then
begin
  if LabelEditDate1.Text='  .  .    'then
   begin
    Application.MessageBox('Введите дату составления!','Ошибка!',0);
    exit
   end;

Ident:=cbClient.getdata;
Sum:=SendStr.CreditTypeDate(Ident,1,Dat,Dat);
if  sum<>'' then
  eSumNDS.text:=StrTo00(FloatTOStr(StrToFloat(Sum)))
else
   eSumNDS.text:='0.00';
end;
except
application.MessageBox('Проверьте введенную дату!','Ошибка!',0);
exit
end;
end;




end.
