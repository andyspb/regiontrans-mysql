unit FWayBill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Lbsqlcmb, Sqlctrls, LblEdtDt, ExtCtrls, OleServer, Word2000,
  toolbtn, StdCtrls, Buttons, BMPBtn, ToolWin, ComCtrls, Printers,
  TSQLCLS,SqlGrid, DB, DBTables, XMLDOM, DBClient, MConnect,Menu,LblCombo,
  Lbledit,Tadjform, Grids, DBGrids,Sqlcombo, EntrySec;


 //Tadjform, Grids,   DBGrids,

type
  TFormWayBill = class(TForm)
    Panel2: TPanel;
    LabelEditDate1: TLabelEditDate;
    Panel3: TPanel;
    cbCity: TLabelSQLComboBox;
    ToolBar1: TToolBar;
    btPrint: TBMPBtn;
    eExit: TToolbarButton;
    WordApplication1: TWordApplication;
    Panel1: TPanel;
    cbZak: TLabelSQLComboBox;
    BitBtn7: TBitBtn;
    BitBtn3: TBitBtn;
    Panel4: TPanel;
    cbxList: TLabelComboBox;
    procedure eExitClick(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LabelEditDate1Exit(Sender: TObject);
    procedure LabelEditDate1Enter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormWayBill: TFormWayBill;
   DateTest:string;
implementation
uses SendStr,makerepp, FFerryman;
{$R *.dfm}

procedure TFormWayBill.eExitClick(Sender: TObject);
begin
close;
end;

procedure TFormWayBill.btPrintClick(Sender: TObject);
var
q,qInf,qA:TQuery;
cond,cond1,cond2:string;
IFerry:longint;
ICity:longint;
Dat:TDate;
poin, mach:string;
ReportMakerWP:TReportMakerWP;
ReportMaker:TReportMakerWP;
p,w1,w2,w3,w4,w5: OleVariant;
zak,ctrax:integer;
label T,T1;
begin
if LabelEditDate1.Text='  .  .    ' then
begin
    Application.MessageBox('Введите дату!','Ошибка!',0);
     LabelEditDate1.SetFocus;
      exit
end;
{ if cbZak.SQLComboBox.GetData=0 then
 begin
     Application.MessageBox('Выберите перевозчика!','Ошибка!',0);
     cbZak.SQLComboBox.SetFocus;
      exit
 end;      }
 zak:=0;
 ctrax:=0;
 if cbZak.SQLComboBox.GetData=0 then  Zak:=0
 else zak:=1;
 ctrax:=cbxList.ComboBox.ItemIndex;
 if cbCity.SQLComboBox.GetData=0 then
 begin
     Application.MessageBox('Выберите город!','Ошибка!',0);
     cbCity.SQLComboBox.SetFocus;
      exit
 end;
IFerry:=cbZak.SQLComboBox.GetData;
ICity:=cbCity.SQLComboBox.GetData;
Dat:=StrToDate(LabelEditDate1.Text);
if ctrax=0 then
 q:=sql.Select(EntrySec.send_table {'Send'},'','ContractType_Ident=2 and `Check`=0 and '+
               ' cast (InsuranceSum as float) <> 0 and '  +
               ' DateSend='''+FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.Text))+
               ''' and City_Ident='+IntToStr(cbCity.SQLComboBox.GetData),'Namber')

else
 q:=sql.Select(EntrySec.send_table {'Send'},'','ContractType_Ident=2 and `Check`=0 and '+
               ' cast (InsuranceSum as float) = 0 and '+
               ' DateSend='''+FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.Text))+
               ''' and City_Ident='+IntToStr(cbCity.SQLComboBox.GetData),'Namber');

if  (not q.eof) then
begin
while (not q.eof) do
begin
ReportMakerWP:=TReportMakerWP.Create(Application);
ReportMakerWP.ClearParam;
cond:='';
if  q.fieldbyname('Namber').AsString <> '' then
  cond:= q.fieldbyname('Namber').AsString;
ReportMakerWP.AddParam('1='+cond);
//-------------------------------------------
cond:='';
cond1:='';
cond2:='';
qInf:=sql.Select('Boss','','','');
if (not qInf.eof) then
begin
if qinf.FieldByName('Acronym').AsString<>'' then
cond:=cond+qinf.FieldByName('Acronym').AsString;

if qinf.FieldByName('UrAddress').AsString<>'' then
 if  cond<>'' then
 cond:=cond+', '+qinf.FieldByName('UrAddress').AsString
 else cond:=cond+qinf.FieldByName('UrAddress').AsString;

 if qinf.FieldByName('Telephone').AsString<>'' then
 if  cond<>'' then
 cond:=cond+', '+qinf.FieldByName('Telephone').AsString
 else cond:=cond+qinf.FieldByName('Telephone').AsString;

 if qinf.FieldByName('Person').AsString<>'' then
 cond2:=qinf.FieldByName('Person').AsString;

 if qinf.FieldByName('PersonBug').AsString<>'' then
 cond1:=qinf.FieldByName('PersonBug').AsString;
end;
ReportMakerWP.AddParam('2='+cond);
ReportMakerWP.AddParam('11='+cond1);
ReportMakerWP.AddParam('10='+cond2);
qInf.Free;
//------------------------------------------------------
cond:='';
qInf:=sql.Select('Acceptor','','Ident='+q.fieldbyname('Acceptor_Ident').AsString,'');
if (not qInf.eof) then
begin
if qinf.FieldByName('Name').AsString<>'' then
cond:=cond+qinf.FieldByName('name').AsString;

if qinf.FieldByName('Address').AsString<>'' then
 if  cond<>'' then
 cond:=cond+', '+qinf.FieldByName('Address').AsString
 else cond:=cond+qinf.FieldByName('Address').AsString;

 if qinf.FieldByName('phone').AsString<>'' then
 if  cond<>'' then
 cond:=cond+', '+qinf.FieldByName('phone').AsString
 else cond:=cond+qinf.FieldByName('phone').AsString;
end;
ReportMakerWP.AddParam('3='+cond);
qInf.Free;
//---------------------------------------------
cond:='';
qInf:=sql.Select('Clients','','Ident='+q.fieldbyname('Client_Ident').AsString,'');
if (not qInf.eof) then
begin
if qinf.FieldByName('Name').AsString<>'' then
cond:=cond+qinf.FieldByName('name').AsString;

qA:=sql.select('Address','','Clients_Ident='+q.fieldbyname('Client_Ident').AsString+
                ' and AddressType_Ident=1','') ;
if not qA.eof then
if qA.FieldByName('AdrName').AsString<>'' then
 if  cond<>'' then
 cond:=cond+', '+qA.FieldByName('AdrName').AsString
 else cond:=cond+qA.FieldByName('AdrName').AsString;
qA.Free;

 if qinf.FieldByName('Telephone').AsString<>'' then
 if  cond<>'' then
 cond:=cond+', '+qinf.FieldByName('Telephone').AsString
 else cond:=cond+qinf.FieldByName('Telephone').AsString;
end;
ReportMakerWP.AddParam('4='+cond);
qInf.Free;
//-------------------------------------
cond:='';
if q.fieldbyname('NameGood_Ident').AsString<>'' then
begin
 qA:=sql.Select('NameGood','','Ident='+q.fieldbyname('NameGood_Ident').AsString,'');
 if not qA.eof then
  if qA.FieldByName('Name').asString<>'' then
   cond:=qA.FieldByName('Name').asString;
 qA.Free;
end;
ReportMakerWP.AddParam('5='+cond);
//-------------------------------------------
cond:='';
if q.fieldByName('PlaceC').asString<>'' then
 cond:= q.fieldByName('PlaceC').asString;
 ReportMakerWP.AddParam('6='+cond);
//---------------------------------------
 cond:=SendStr.NumberToString(cond);
 ReportMakerWP.AddParam('9='+cond);
//-------------------------------------------
cond:='';
if q.fieldByName('Weight').asString<>'' then
 cond:= q.fieldByName('Weight').asString;
 ReportMakerWP.AddParam('7='+cond);
//------------------------------------------
 cond:=SendStr.NumberToString(cond);
 ReportMakerWP.AddParam('8='+cond);
//-------------------------------------------
cond:='';
if sql.selectstring('Inspector','PeopleFIO','Ident='+IntToStr(FMenu.CurrentUser))<>'' then
cond:= sql.selectstring('Inspector','PeopleFIO','Ident='+IntToStr(FMenu.CurrentUser));
ReportMakerWP.AddParam('12='+cond);
//--------------------------------------------
ReportMakerWP.AddParam('13='+DataDMstrY(Dat));
//------------------------------------------------
cond:='';
cond1:='';
if (q.fieldByName('InsuranceSum').asString<>'') or
(q.fieldByName('InsuranceSum').asfloat<>0) then
begin
cond:=q.fieldByName('InsuranceSum').asString;
if pos('.',cond)<>0 then
begin
cond1:=copy(cond,pos('.',cond)+1,2);
delete(cond,pos('.',cond),3);
cond:=SendStr.NumberToString(cond);
end;

end;
ReportMakerWP.AddParam('14='+cond);
ReportMakerWP.AddParam('15='+cond1);

if  ReportMakerWP.DoMakeReport(systemdir+'select\FerryMan1.rtf',
                             systemdir+'select\FerryMan.ini',
                              systemdir+'select\Out.rtf')<>0 then
                              begin
                              ReportMakerWP.Free;
                             // application.messagebox('Закройте выходной документ в WINWORD!',
                             // 'Совет!',0);
 //                          goto T;
                              exit
                              end;
ReportMakerWP.Free;
WordApplication1:=TWordApplication.Create(Application);
p := systemdir+'select\Out.rtf';
  w1:=1;
  mach:='';
  mach:= trim(WordApplication1.UserName);
  w2:=sql.SelectString('Printer','NameA4','ComputerName='+sql.MakeStr(mach));
  w1:=1;
WordApplication1.Documents.Open(p,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam);
w3:=sql.SelectString('Printer','ComNameA4','ComputerName='+sql.MakeStr(mach));
if  (VarToStr(w2)='') or (VarToStr(w3)='') then
begin
application.MessageBox('Информация о принтерах не внесена в базу для данной машины'+
                       ' или в параметрах WinWord не верно указано имя машины!','Ошибка!',0);
 WordApplication1.Documents.Close(EmptyParam,EmptyParam,EmptyParam);
 WordApplication1.WindowState:=2;
 WordApplication1.Free;
 goto T1;
 exit;
end;
        
if Application.MessageBox('Распечать?','Сообщение!',MB_YESNO+MB_ICONQUESTION)=IDYES
 then
begin
w4:=WordApplication1.UserName;
if w3<>w4 then   w2:= '\\'+w3+'\'+w2;
WordApplication1.ActivePrinter:=w2;
WordApplication1.ActiveDocument.PrintOut(
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam, EmptyParam,EmptyParam,
	EmptyParam,w1,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
        w2 ,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam,EmptyParam);
end else
     begin
     WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
     WordApplication1.WindowState:=2;
     WordApplication1.Free;
     goto T;
     exit
     end;
WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
//        WordApplication1.WindowState:=2;
WordApplication1.Free;

ReportMaker:=TReportMakerWP.Create(Application);
  ReportMaker.ClearParam;
//--------------------------------
cond:='';
cond:=DataDMstrY(Dat+3);
ReportMaker.AddParam('1='+cond);
//---------------------------------
if zak<>0 then
begin
cond:='';
qInf:=sql.Select('FerryMan','','Ident='+IntToStr(IFerry),'');
if  not qInf.eof then
begin
if    qInf.FieldByName('Name').AsString<>''    then
 cond:= qInf.FieldByName('Name').AsString;
if    qInf.FieldByName('Address').AsString<>''    then
 if cond<>'' then
  cond:=cond+', '+ qInf.FieldByName('Address').AsString
 else cond:= qInf.FieldByName('Address').AsString ;

if    qInf.FieldByName('Phone').AsString<>''    then
 if cond<>'' then
  cond:=cond+', '+ qInf.FieldByName('Phone').AsString
 else cond:= qInf.FieldByName('Phone').AsString ;
ReportMaker.AddParam('2='+cond);
//-----------------------------
cond:='' ;
if    qInf.FieldByName('Car').AsString<>''    then
 cond:= qInf.FieldByName('Car').AsString;
ReportMaker.AddParam('3='+cond);
//---------------------------------
cond:='';
if    qInf.FieldByName('CarNumber').AsString<>''    then
 cond:= qInf.FieldByName('CarNumber').AsString;
ReportMaker.AddParam('4='+cond);
//-------------------------------------
cond:='';
if    qInf.FieldByName('Driver').AsString<>''    then
 cond:= qInf.FieldByName('Driver').AsString;
ReportMaker.AddParam('5='+cond);
//-------------------------------------
cond:='';
if    qInf.FieldByName('DrivingLicence').AsString<>''    then
 cond:= qInf.FieldByName('DrivingLicence').AsString;
ReportMaker.AddParam('6='+cond);
//-------------------------------------
cond:='';
if    qInf.FieldByName('Licence').AsString<>''    then
 cond:= qInf.FieldByName('Licence').AsString;
ReportMaker.AddParam('7='+cond);
//-------------------------------------
cond:='';
if    qInf.FieldByName('LicenceSeries').AsString<>''    then
 cond:= qInf.FieldByName('LicenceSeries').AsString;
ReportMaker.AddParam('8='+cond);
//-------------------------------------
end ;
qinf.Free;
end else begin
         ReportMaker.AddParam('2='+cond);
         ReportMaker.AddParam('3='+cond);
         ReportMaker.AddParam('4='+cond);
         ReportMaker.AddParam('5='+cond);
         ReportMaker.AddParam('6='+cond);
         ReportMaker.AddParam('7='+cond);
         ReportMaker.AddParam('8='+cond);
         end;
//---------------------------------------
cond:='С.-Петербург, Полтавская д.9';
ReportMaker.AddParam('9='+cond);
//--------------------------------
cond:='';
qInf:=sql.Select('Acceptor','','Ident='+q.fieldbyname('Acceptor_Ident').AsString,'');
if (not qInf.eof) then
begin
if qinf.FieldByName('Address').AsString<>'' then
    cond:=cond+qinf.FieldByName('Address').AsString;
 if qinf.FieldByName('phone').AsString<>'' then
 if  cond<>'' then
 cond:=cond+', '+qinf.FieldByName('phone').AsString
 else cond:=cond+qinf.FieldByName('phone').AsString;
end;
ReportMaker.AddParam('10='+cond);
qInf.free;
//--------------------------------
cond:='';
if q.fieldByName('PlaceC').asString<>'' then
 cond:= q.fieldByName('PlaceC').asString;
 ReportMaker.AddParam('12='+cond);
//---------------------------------------
 cond:=SendStr.NumberToString(cond);
 ReportMaker.AddParam('14='+cond);
//-------------------------------------------
if q.fieldByName('Weight').asString<>'' then
 cond:= q.fieldByName('Weight').asString;
 ReportMaker.AddParam('13='+cond);
//------------------------------------------
 cond:=SendStr.NumberToString(cond);
 ReportMaker.AddParam('15='+cond);
//-------------------------------------------
cond:='';
if sql.selectstring('Inspector','PeopleFIO','Ident='+IntToStr(FMenu.CurrentUser))<>'' then
cond:= sql.selectstring('Inspector','PeopleFIO','Ident='+IntToStr(FMenu.CurrentUser));
ReportMaker.AddParam('16='+cond);
//--------------------------------------------

if  ReportMaker.DoMakeReport(systemdir+'select\FerryMan2.rtf',
                             systemdir+'select\FerryMan.ini',
                              systemdir+'select\Out1.rtf')<>0 then
                              begin
                              ReportMaker.Free;
                             // application.messagebox('Закройте выходной документ в WINWORD!',
                             // 'Совет!',0);
 //                          goto T;
                              exit
                              end;
ReportMaker.Free;
WordApplication1:=TWordApplication.Create(Application);
p := systemdir+'select\Out1.rtf';
  mach:='';
  mach:= trim(WordApplication1.UserName);
  w2:=sql.SelectString('Printer','NameA4','ComputerName='+sql.MakeStr(mach));
  w1:=1;
WordApplication1.Documents.Open(p,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam);
w3:=sql.SelectString('Printer','ComNameA4','ComputerName='+sql.MakeStr(mach));
if  (VarToStr(w2)='') or (VarToStr(w3)='') then
begin
application.MessageBox('Информация о принтерах не внесена в базу для данной машины'+
                       ' или в параметрах WinWord не верно указано имя машины!','Ошибка!',0);
 WordApplication1.Documents.Close(EmptyParam,EmptyParam,
                                        EmptyParam);
 WordApplication1.WindowState:=2;
 WordApplication1.Free;
 goto T1;
 exit;
end;

if Application.MessageBox('Лист бумаги вставлен?','Сообщение!',
                          MB_YESNO+MB_ICONQUESTION)=IDYES
 then
begin
w4:=WordApplication1.UserName;
if w3<>w4 then   w2:= '\\'+w3+'\'+w2;
WordApplication1.ActivePrinter:=w2;
WordApplication1.ActiveDocument.PrintOut(
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam, EmptyParam,EmptyParam,
	EmptyParam,w1,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
        w2 ,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam,EmptyParam);
end else
     begin
      WordApplication1.Documents.Close(EmptyParam,EmptyParam,
                                        EmptyParam);
        WordApplication1.WindowState:=2;
      WordApplication1.Free;
     if Application.MessageBox('Прекратить печать?','Сообщение!',
                          MB_YESNO+MB_ICONQUESTION)=IDYES
 then   begin
        q.Free;
        exit;
        end else begin
                 goto T;
                 exit
                 end;
     end;
WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
        WordApplication1.WindowState:=2;
WordApplication1.Free;


T: q.Next
end;
end else
  begin
     Application.MessageBox('На введенные данные не найдено не одной отправки!','Ошибка!',0);
      exit

  end;
T1: q.Free;
end;


procedure TFormWayBill.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btPrintClick(Sender);
end;

procedure TFormWayBill.LabelEditDate1Exit(Sender: TObject);
begin
try
FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text));
except
 Application.MessageBox('Неправильно введена дата!','Ошибка',0);  
 LabelEditDate1.Text:= DateTest;
 LabelEditDate1.SetFocus;
 exit;
end;

end;

procedure TFormWayBill.LabelEditDate1Enter(Sender: TObject);
begin
DateTest:=LabelEditDate1.text;
end;


procedure TFormWayBill.BitBtn3Click(Sender: TObject);
var l:longint;
begin
sql.StartTransaction;
FormFerryman:=TFormFerryman.Create(Application) ;
l:=FormFerryman.AddRecord;
FormFerryman.Free;
if l<>0 then
begin
cbZak.SQLComboBox.Recalc;
cbZak.SQLComboBox.SetActive(l);
sql.Commit;
end else sql.Rollback;
end;

procedure TFormWayBill.BitBtn7Click(Sender: TObject);
var l,m:longint;
begin
if cbZak.GetData<>0 then
begin
sql.StartTransaction;
m:=cbZak.GetData;
FormFerryman:=TFormFerryman.Create(Application) ;
l:=FormFerryman.EditRecord(cbZak.GetData);
if l<>0 then
    begin
    cbZak.SQLComboBox.Recalc;
    cbZak.SQLComboBox.SetActive(l);
    sql.Commit;
    end else sql.Rollback;
FormFerryman.Free;   
end;
end;

procedure TFormWayBill.FormCreate(Sender: TObject);
begin
 LabelEditDate1.text:=FormatDateTime('dd.mm.yyyy',now);
  cbxList.ComboBox.DropDownCount:=2;

 cbxList.ComboBox.Items.Add('застрахован') ;
 cbxList.ComboBox.Items.Add('не застрахован')    ;
 // cbZak.SQLComboBox.Sorted:=true;
end;

end.

