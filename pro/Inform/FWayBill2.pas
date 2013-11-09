unit FWayBill2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Lbsqlcmb, Sqlctrls, LblEdtDt, ExtCtrls, OleServer, Word2000,
  toolbtn, StdCtrls, Buttons, BMPBtn, ToolWin, ComCtrls, Printers,
  TSQLCLS,SqlGrid, DB, DBTables, XMLDOM, DBClient, MConnect,Menu,LblCombo,
  Lbledit,Tadjform, Grids, DBGrids,Sqlcombo,EntrySec;

type
  TFormWayBill2 = class(TForm)
    ToolBar1: TToolBar;
    btPrint: TBMPBtn;
    eExit: TToolbarButton;
    WordApplication1: TWordApplication;
    Panel1: TPanel;
    cbZak: TLabelSQLComboBox;
    BitBtn7: TBitBtn;
    BitBtn3: TBitBtn;
    Panel3: TPanel;
    cbCity: TLabelSQLComboBox;
    Panel4: TPanel;
    LNameGood1: TLabelSQLComboBox;
    Panel5: TPanel;
    LNameGood3: TLabelSQLComboBox;
    Panel6: TPanel;
    LNameGood2: TLabelSQLComboBox;
    Panel2: TPanel;
    LabelEditDate1: TLabelEditDate;
    procedure eExitClick(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabelEditDate1Enter(Sender: TObject);
    procedure LabelEditDate1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormWayBill2: TFormWayBill2;
  DateTest:string;
implementation
uses SendStr,makerepp, FFerryman;
{$R *.dfm}

procedure TFormWayBill2.eExitClick(Sender: TObject);
begin
close;
end;

procedure TFormWayBill2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btPrintClick(Sender);
end;

procedure TFormWayBill2.BitBtn3Click(Sender: TObject);
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

procedure TFormWayBill2.BitBtn7Click(Sender: TObject);
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

procedure TFormWayBill2.btPrintClick(Sender: TObject);
var
q,qInf,qA:TQuery;
cond,cond1,cond2:string;
IFerry:longint;
ICity:longint;
Good1,Good2,Good3,Place:integer;
Weight, ISUM:real;
poin, mach:string;
ReportMakerWP:TReportMakerWP;
ReportMaker:TReportMakerWP;
p,w1,w2,w3,w4,w5: OleVariant;
zak:integer;
label T,T1;
begin
 zak:=0;
 if LabelEditDate1.Text='  .  .    ' then
 begin
    Application.MessageBox('Введите дату!','Ошибка!',0);
     LabelEditDate1.SetFocus;
      exit
 end;
 if cbZak.SQLComboBox.GetData=0 then  Zak:=0
 else zak:=1;
 if cbCity.SQLComboBox.GetData=0 then
 begin
     Application.MessageBox('Выберите город!','Ошибка!',0);
     cbCity.SQLComboBox.SetFocus;
      exit
 end;
if  (LNameGood1.SQLComboBox.GetData=0) and
    (LNameGood2.SQLComboBox.GetData=0) and
    (LNameGood3.SQLComboBox.GetData=0) then
 begin
     Application.MessageBox('Выберите наименование груза!','Ошибка!',0);
     LNameGood1.SQLComboBox.SetFocus;
      exit
 end;
if  (LNameGood1.SQLComboBox.GetData<>0) and
    (LNameGood2.SQLComboBox.GetData<>0) and
    (LNameGood3.SQLComboBox.GetData=0) then
 begin
     Application.MessageBox('Выберите наименование груза!','Ошибка!',0);
     LNameGood3.SQLComboBox.SetFocus;
      exit
 end;
if  (LNameGood1.SQLComboBox.GetData<>0) and
    (LNameGood2.SQLComboBox.GetData=0) and
    (LNameGood3.SQLComboBox.GetData<>0) then
 begin
     Application.MessageBox('Выберите наименование груза!','Ошибка!',0);
     LNameGood2.SQLComboBox.SetFocus;
      exit
 end;
     Good1:=0;
     Good2:=0;
     good3:=0;

IFerry:=cbZak.SQLComboBox.GetData;
ICity:=cbCity.SQLComboBox.GetData;
if  (LNameGood2.SQLComboBox.GetData<>0) and
    (LNameGood3.SQLComboBox.GetData<>0) then
    begin
     Good1:=50;
     Good2:=30;
     good3:=20;
    end
    else   Good1:=100;

 q:=sql.Select(EntrySec.send_table {'Send'},'','ContractType_Ident=2 and `Check`=0 and '+
                ' DateSend='''+FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.Text))+
                ''' and City_Ident='+IntToStr(cbCity.SQLComboBox.GetData),'Namber');

Weight:=0;
Place:=0;
ISum:=0;
  if  (not q.eof) then
  begin
   while (not q.eof) do
   begin
    if q.fieldByName('PlaceC').asString<>'' then
     Place:=Place + q.fieldByName('PlaceC').asInteger;

     if q.fieldByName('Weight').asString<>'' then
      Weight:=Weight + q.fieldByName('Weight').asFloat;

     if (q.fieldByName('InsuranceSum').asString<>'') or
        (q.fieldByName('InsuranceSum').asfloat<>0) then
          ISum:=ISum + q.fieldByName('InsuranceSum').asFloat;
 q.Next
   end;
  end else
      begin
     Application.MessageBox('На введенные данные не найдено не одной отправки!','Ошибка!',0);
      exit
      end;
q.Free;
ReportMakerWP:=TReportMakerWP.Create(Application);
ReportMakerWP.ClearParam;
cond:='';

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

ReportMakerWP.AddParam('3='+cond);

//---------------------------------------------
cond:='';

ReportMakerWP.AddParam('4='+cond);

//-------------------------------------
cond:='';
if LNameGood1.SQLComboBox.GetData<>0 then
   cond:=LNameGood1.SQLComboBox.Text ;
ReportMakerWP.AddParam('5='+cond);
//-------------------------------------------
cond:='';
if LNameGood2.SQLComboBox.GetData<>0 then
   cond:=LNameGood2.SQLComboBox.Text ;
ReportMakerWP.AddParam('6='+cond);
//-------------------------------------------
cond:='';
if LNameGood3.SQLComboBox.GetData<>0 then
   cond:=LNameGood3.SQLComboBox.Text ;
ReportMakerWP.AddParam('22='+cond);
//-------------------------------------------
cond:='';
 cond:= IntToStr((Place*good1)div(100));
ReportMakerWP.AddParam('16='+cond);
//---------------------------------------
cond:='';
if (good2<>0) then
 cond:= IntToStr((Place*good2) div (100));
ReportMakerWP.AddParam('17='+cond);
//---------------------------------------
cond:='';
if (good3<>0) then
 cond:= IntToStr(Place-(Place*good1)div(100)-(Place*good2) div (100));
ReportMakerWP.AddParam('18='+cond);
//---------------------------------------
cond:='';
 cond:=SendStr.NumberToString(IntToStr(Place));
 ReportMakerWP.AddParam('9='+cond);
//-------------------------------------------
cond:='';
 cond:= FloatToStr(Weight);
 ReportMakerWP.AddParam('7='+cond);
//------------------------------------------
 cond:=SendStr.NumberToString(cond);
 ReportMakerWP.AddParam('8='+cond);
//-------------------------------------------
cond:='';
 cond:= FloatToStr(Weight*good1/100);
ReportMakerWP.AddParam('19='+cond);
//---------------------------------------
cond:='';
if (good2<>0) then
 cond:= FloatToStr(Weight*good2/100);
ReportMakerWP.AddParam('20='+cond);
//---------------------------------------
cond:='';
if (good3<>0) then
 cond:= FloatToStr(Weight-(Weight*good1/100)-(Weight*good2/100));
ReportMakerWP.AddParam('21='+cond);
//---------------------------------------
cond:='';
if sql.selectstring('Inspector','PeopleFIO','Ident='+IntToStr(FMenu.CurrentUser))<>'' then
cond:= sql.selectstring('Inspector','PeopleFIO','Ident='+IntToStr(FMenu.CurrentUser));
ReportMakerWP.AddParam('12='+cond);
//--------------------------------------------
ReportMakerWP.AddParam('13='+DataDMstrY(StrToDate(LabelEditDate1.Text)));
//------------------------------------------------
cond:='';
cond1:='';
if ISum<>0 then
begin
cond:=FloatToStr(ISum);
if pos('.',cond)<>0 then
begin
cond1:=copy(cond,pos('.',cond)+1,2);
delete(cond,pos('.',cond),3);
cond:=SendStr.NumberToString(cond);
end;

end;
ReportMakerWP.AddParam('14='+cond);
ReportMakerWP.AddParam('15='+cond1);

if  ReportMakerWP.DoMakeReport(systemdir+'select\FerryMan11.rtf',
                             systemdir+'select\FerryMan.ini',
                              systemdir+'select\Out.rtf')<>0 then
                              begin
                              ReportMakerWP.Free;
                              exit
                              end;
ReportMakerWP.Free;
WordApplication1:=TWordApplication.Create(Application);
p := systemdir+'select\Out.rtf';
  mach:='';
  mach:= trim(WordApplication1.UserName);
  w2:=sql.SelectString('Printer','NameA4','ComputerName='+sql.MakeStr(mach));
  w1:=1;
w3:=sql.SelectString('Printer','ComNameA4','ComputerName='+sql.MakeStr(mach));
if  (VarToStr(w2)='') or (VarToStr(w3)='') then
begin
     application.MessageBox('Информация о принтерах не внесена в базу для данной машины'+
                       ' или в параметрах WinWord не верно указано имя машины!','Ошибка!',0);
     WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
     WordApplication1.WindowState:=2;
     WordApplication1.Free;
     goto T;
     exit
end;

WordApplication1.Documents.Open(p,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam);
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
cond:=DataDMstrY(StrToDate(LabelEditDate1.Text)+3);
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
    cond:=cbCity.SQLComboBox.Text;
ReportMaker.AddParam('10='+cond);
//--------------------------------
cond:='';
if LNameGood1.SQLComboBox.GetData<>0 then
   cond:=LNameGood1.SQLComboBox.Text ;
ReportMakerWP.AddParam('24='+cond);
//-------------------------------------------
cond:='';
if LNameGood2.SQLComboBox.GetData<>0 then
   cond:=LNameGood2.SQLComboBox.Text ;
ReportMakerWP.AddParam('17='+cond);
//-------------------------------------------
cond:='';
if LNameGood3.SQLComboBox.GetData<>0 then
   cond:=LNameGood3.SQLComboBox.Text ;
ReportMakerWP.AddParam('18='+cond);
//-------------------------------------------
cond:='';
 cond:= IntToStr(Place);
 cond:=SendStr.NumberToString(cond);
 ReportMaker.AddParam('14='+cond);
//-------------------------------------------
cond:='';
 cond:= IntToStr((Place*good1)div(100));
ReportMakerWP.AddParam('12='+cond);
//---------------------------------------
cond:='';
if (good2<>0) then
 cond:= IntToStr((Place*good2) div (100));
ReportMakerWP.AddParam('19='+cond);
//---------------------------------------
cond:='';
if (good3<>0) then
 cond:= IntToStr(Place-(Place*good1)div(100)-(Place*good2) div (100));
ReportMakerWP.AddParam('20='+cond);
//---------------------------------------
 cond:='';
 cond:= FloatToStr(Weight);
 ReportMakerWP.AddParam('23='+cond);
 cond:=SendStr.NumberToString(cond);
 ReportMaker.AddParam('15='+cond);
//-------------------------------------------
cond:='';
 cond:= FloatToStr(Weight*good1/100);
ReportMakerWP.AddParam('13='+cond);
//---------------------------------------
cond:='';
if (good2<>0) then
 cond:= FloatToStr(Weight*good2/100);
ReportMakerWP.AddParam('21='+cond);
//---------------------------------------
cond:='';
if (good3<>0) then
 cond:= FloatToStr(Weight-(Weight*good1/100)-(Weight*good2/100));
ReportMakerWP.AddParam('22='+cond);
//---------------------------------------
cond:='';
if sql.selectstring('Inspector','PeopleFIO','Ident='+IntToStr(FMenu.CurrentUser))<>'' then
cond:= sql.selectstring('Inspector','PeopleFIO','Ident='+IntToStr(FMenu.CurrentUser));
ReportMaker.AddParam('16='+cond);
//--------------------------------------------

if  ReportMaker.DoMakeReport(systemdir+'select\FerryMan21.rtf',
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
w3:=sql.SelectString('Printer','ComNameA4','ComputerName='+sql.MakeStr(mach));
if  (VarToStr(w2)='') or (VarToStr(w3)='') then
begin
application.MessageBox('Информация о принтерах не внесена в базу для данной машины'+
                       ' или в параметрах WinWord не верно указано имя машины!','Ошибка!',0);
      WordApplication1.Documents.Close(EmptyParam,EmptyParam,
                                        EmptyParam);
      WordApplication1.WindowState:=2;
      WordApplication1.Free;

 goto T;
 exit;
end;

WordApplication1.Documents.Open(p,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam);
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
      goto T;
      exit
     end; 
WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
        WordApplication1.WindowState:=2;
WordApplication1.Free;


T:
end;

procedure TFormWayBill2.FormCreate(Sender: TObject);
begin
LabelEditDate1.text:=FormatDateTime('dd.mm.yyyy',now);
end;

procedure TFormWayBill2.LabelEditDate1Enter(Sender: TObject);
begin
DateTest:=LabelEditDate1.text;
end;

procedure TFormWayBill2.LabelEditDate1Exit(Sender: TObject);
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

end.
