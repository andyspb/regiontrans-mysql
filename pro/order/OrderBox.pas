unit OrderBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Lbledit, Lbsqlcmb, Sqlctrls, LblEdtDt, StdCtrls, Buttons,SqlGrid,
  DB,TSQLCLS,DBTables,Tadjform,  BMPBtn, ComCtrls, OleServer, Word2000,
  ExtCtrls, EntrySec;

type
  TFormOrderBox = class(Tform)
    cbClient: TLabelSQLComboBox;
    eSumNDS: TLabelEdit;
    eNDS: TLabelEdit;
    eSum: TLabelEdit;
    HeaderControl1: THeaderControl;
    btPrint: TBMPBtn;
    btCansel: TBMPBtn;
    eNSP: TLabelEdit;
    WordApplication1: TWordApplication;
    Panel1: TPanel;
    CheckBox2: TCheckBox;
    Panel2: TPanel;
    LabelEditDate1: TLabelEditDate;
    eNumber: TLabelEdit;
    procedure btCanselClick(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure cbClientChange(Sender: TObject);
    procedure eSumNDSChange(Sender: TObject);
    procedure Print;
    procedure FormCreate;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox2Click(Sender: TObject);
    procedure LabelEditDate1Exit(Sender: TObject);
    procedure eNumberChange(Sender: TObject);
   
  private
    { Private declarations }
  public
  Function AddRecord:longint;
  Function EditRecord(Iden:longInt):longint;
  Function Num:string;

    { Public declarations }
  end;

var
  FormOrderBox: TFormOrderBox;
  Number:string;
  Ident:longint;
  Ptype:integer;
  Enabl:boolean;
  NSP:integer;

implementation

Uses makerepp ,SendStr, Menu,Invoice,FInvoice;
{$R *.dfm}

Function TFormOrderBox.AddRecord:longint;
var  l:longint;
      str:string;
  fields: string;
  thread: TInsertThread;
begin
Enabl:=true;
FormCreate;
Number:='';
Ptype:=0;
Ident:=0;
NSP:=0;
LabelEditDate1.Text:=FormatDateTime('dd.mm.yyyy',now);
eNumber.Enabled:=true;
Number:=Num;
eNumber.Text:=Number;

CheckBox2.Visible:=false;

if showModal=mrOk then
begin
l:=sql.FindNextInteger('Ident',EntrySec.order_table,'',MaxLongint);
str:=IntToStr(L);
str:=str+','+Sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.Text)));
if  eSumNDS.text<>'' then
 str:=str+','+sql.MakeStr(eSumNDS.text)
 else str:=str+',NULL';
if  eNDS.text<>'' then
 str:=str+','+sql.MakeStr(eNDS.text)
 else str:=str+',NULL';
if  eSum.text<>'' then
 str:=str+','+sql.MakeStr(eSum.text)
 else str:=str+',NULL';
if cbClient.GetData<>0 then
 str:=str+','+IntToStr(cbClient.GetData)
 else str:=str+',NULL';

//Number:=Num;
 str:=str+','+sql.MakeStr(Number);

if (eNSP.text<>'')and (eNSP.visible) then
 str:=str+','+sql.MakeStr(eNSP.text)
 else str:=str+',NULL';

 str:=str+','+sql.MakeStr(FormatDateTime('yyyy-mm-dd',now));

fields:='Ident,Dat,SumNDS,NDS,Sum,Client_Ident,Number,NSP,DatNow';
if sql.insertstring(EntrySec.order_table {'`Order`'}, fields ,str)=0
then begin
       // success
       AddRecord:=l;
       Print;
       // insert into other table
       thread:= TInsertThread.Create(True, EntrySec.order_table_other, fields, str);
       thread.Resume();
     end
     else begin
          AddRecord:=0;
          exit;
          end;

end else AddRecord:=0;
end;

Function TFormOrderBox.EditRecord(Iden:longInt):longint;
var q:TQuery;
    I:longint;
begin
Enabl:=false;
FormCreate;
I:=Iden;
NSP:=0;
q:=sql.Select(EntrySec.order_table {'`Order`'},'*','Ident='+IntToStr(I),'');
Number:=q.fieldByName('Number').asString;
eNumber.Text:=Number;
eNumber.enabled:=false;
LabelEditDate1.SetValue(q);
cbClient.SetValue(q);
eSumNDS.SetValue(q);
eNDS.SetValue(q);
eSum.SetValue(q);
Ident:=cbClient.getdata;
Ptype:=sql.SelectInteger('Clients','PersonType_Ident','Ident='+IntToStr(Ident));

  eNSP.Visible:=false;
  CheckBox2.Visible:=false;

q.Free;
if showModal=mrOk then
begin
Print;
EditRecord:= I;
end else   EditRecord:= I;
end;

procedure TFormOrderBox.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;

end;

procedure TFormOrderBox.btPrintClick(Sender: TObject);
var
//  l:longint;
  q: TQuery;
  label Next1;
begin
  if LabelEditDate1.text='  .  .    '  then
  begin
    Application.MessageBox('Введите дату составления!','Ошибка!',0);
    exit
  end;

  if  cbClient.GetData=0 then
  begin
    Application.MessageBox('Выберите заказчика!','Ошибка!',0);
    cbClient.SetFocus;
    exit;
  end;

  if Enabl=true then
  begin
    case Application.MessageBox('Если оплачивается сейчас то нажмите да!',
                            'Предупреждение',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
      if  trim(Number) = '' then
      begin
        Application.MessageBox('Введите номер приходника в формате NNN/YY!','Ошибка!',0);
        eNumber.SetFocus;
        exit;
      end;

      q:=sql.select(EntrySec.orderstek_view {'`OrdersTek`'},'Number','`Number`='+sql.MakeStr(Number),'');

      if (not q.Eof) then
      begin
        Application.MessageBox('Приходник с таким номером уже существует, введите другой!','Ошибка!',0);
        eNumber.SetFocus;
        exit;
      end
      else
        ModalResult:=mrOk;
    end;
    IDNO:Print;
    end;
  end
  else
    ModalResult:=mrOk;
  if Invoice.InvoiceTest(cbClient.getdata,Now) then
  begin
    case Application.MessageBox('Пора распечатать счет фактуру! Подтвердите печать!',
                            'Сообщение',MB_YESNO+MB_ICONQUESTION) of
      IDYES:
      begin
        FormInvoice:=TFormInvoice.Create(Application) ;
        FormInvoice.AddRecord(cbClient.getdata);
        FormInvoice.Free;
      end;

      IDNO:
      begin
        goto next1 ;
        exit
      end;
    end;
  end;

Next1:
end;

procedure TFormOrderBox.cbClientChange(Sender: TObject);
var Sum,s:string;
     N:real;

begin
if LabelEditDate1.text='  .  .    '  then
begin
    Application.MessageBox('Введите дату составления!','Ошибка!',0);
    exit
end;

if  cbClient.getdata<>0 then
begin
Ident:=cbClient.getdata;
Ptype:=sql.SelectInteger('Clients','PersonType_Ident','Ident='+IntToStr(Ident));
Sum:=SendStr.CreditType(Ident,2);
N:=1;

s:=copy(Sum,1,1);
if s='-' then
 begin
  Sum:=copy(Sum,2,Length(Sum)-1);
 eNDS.text:=StrTo00(FloatTOStr(StrToFloat(Sum)*18/118));
  eSum.text:=StrTo00(FloatTOStr(StrToFloat(Sum)-StrToFloat(eNDS.text)));
  eSumNDS.text:=StrTo00(FloatTOStr(StrToFloat(Sum)));
  if eNSP.Visible then
     eNSP.text:=StrTo00(FloatTOStr(StrToFloat(Sum)*(N-1)));
 end
else
 begin
  eSum.text:='0.00';
  eNDS.text:='0.00';
  eSumNDS.text:='0.00';
  if eNSP.Visible then  eNSP.text:='0.00';
 end;
end;
end;

procedure TFormOrderBox.eSumNDSChange(Sender: TObject);
var
  Sum:real;
  N:real;
begin
  if LabelEditDate1.text='  .  .    '  then
  begin
    Application.MessageBox('Введите дату составления!','Ошибка!',0);
    exit
  end;

  if (eSumNDS.text<>'') then
  begin
    if eNSP.Visible then
    begin
      N:=1.05;
      eNSP.Text:=StrTo00(FloatToStr(StrToFloat(eSumNDS.text)*(N-1)));
    end
    else
    begin
      //N:=1;
      eNSP.Text:='';
    end;
    Sum:=(StrToFloat(eSumNDS.text));
    eNDS.text:=StrTo00(FloatTOStr((Sum)*18/118));
    eSum.text:=StrTo00(FloatTOStr(Sum-StrToFloat(eNDS.text)));
    eSumNDS.text:=StrTo00(eSumNDS.text);
  end
  else
  begin
    eNDS.text:='0.00';
    eSum.text:='0.00';
    eSumNDS.text:='0.00';
    if eNSP.Visible then
      eNSP.Text:='0.00';
  end;
end;

Function TFormOrderBox.Num:string;
var q:TQuery;
    Year, Month, Day: Word;
    Num1,Num2:string;
    N1,N2:integer;
begin
if LabelEditDate1.text<>'  .  .    '  then
DecodeDate(StrToDate(LabelEditDate1.text), Year, Month, Day)
else begin
    Application.MessageBox('Введите дату составления!','Ошибка!',0);
    exit
    end;
q:=sql.select(EntrySec.orderstek_view {'`OrdersTek`'},'Number,`Year`','`Year`='+IntToStr(Year),'');
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

procedure TFormOrderBox.Print;
var ReportMakerWP:TReportMakerWP;
    p,W2,w1,w3,w4: OleVariant;
    s, mach:string;
    q:tQuery;
    sum1:real;
label T;
begin
try
  ReportMakerWP:=TReportMakerWP.Create(Application);
  ReportMakerWP.ClearParam;
  q:=sql.Select('BOSS','*','','');
  ReportMakerWP.AddParam('1='+q.FieldByName('OKUD').asstring);
  ReportMakerWP.AddParam('2='+q.FieldByName('OKPO').asstring);
  ReportMakerWP.AddParam('3='+q.FieldByName('Acronym').asstring);
  if Number='' then Number:='/'+FormatDateTime('yy',StrToDate(LabelEditDate1.text));
  ReportMakerWP.AddParam('4='+Number);
  ReportMakerWP.AddParam('5='+LabelEditDate1.Text);
  //ReportMakerWP.AddParam('6='+eSumNDS.text);
  if sql.SelectInteger('Clients','PersonType_Ident','Ident='+IntToStr(cbClient.GetData))=2 then
    ReportMakerWP.AddParam('7='+sql.SelectString('Clients','Acronym','Ident='+IntToStr(cbClient.GetData)));
  if sql.SelectInteger('Clients','PersonType_Ident','Ident='+IntToStr(cbClient.GetData))=1 then
    ReportMakerWP.AddParam('7='+sql.SelectString('Clients','Name','Ident='+IntToStr(cbClient.GetData)));
  ReportMakerWP.AddParam('8='+'Перевозка грузобагажа');
 // s:=SendStr.MoneyToString(eSumNDS.text);
  //ReportMakerWP.AddParam('9='+s);
  ReportMakerWP.AddParam('10='+SendStr.Money00(eNDS.text));
  sum1:=0;
  s:='';

    ReportMakerWP.AddParam('18='+'18%');
    ReportMakerWP.AddParam('19='+'');
    ReportMakerWP.AddParam('20='+'');
    ReportMakerWP.AddParam('11='+'');
    ReportMakerWP.AddParam('12='+'');
    sum1:=StrToFloat(eSumNDS.text);
    S:=StrTo00(FloatTOStr(Sum1));
    ReportMakerWP.AddParam('6='+S);
    ReportMakerWP.AddParam('15='+SendStr.Money00(s));
    s:=SendStr.MoneyToString(S);
    ReportMakerWP.AddParam('9='+s);

  ReportMakerWP.AddParam('13='+q.FieldByName('PersonBug').asstring);
  ReportMakerWP.AddParam('14='+sql.selectstring('Inspector','PeopleFIO','Ident='+
                                   IntToStr(FMenu.CurrentUser)));
  //ReportMakerWP.AddParam('15='+SendStr.Money00(eSumNDS.text));
  s:='';
  s:=SendStr.DataDMstrY(StrToDate(LabelEditDate1.text));
  ReportMakerWP.AddParam('16='+s);
  ReportMakerWP.AddParam('17='+s);
  q.Free;
  if ReportMakerWP.DoMakeReport(systemdir+'order\order.rtf',
          systemdir+'order\order.ini', systemdir+'Order\out.rtf')<>0 then
                              begin
                              ReportMakerWP.Free;

                              //application.messagebox('Закройте выходной документ в WINWORD!',
                              //'Совет!',0);
                              //goto T;
                              exit
                              end;;
  ReportMakerWP.Free;
WordApplication1:=TWordApplication.Create(Application);
  p := systemdir+'Order\out.rtf';
  w1:=1;
  mach:='';
  mach:= trim(WordApplication1.UserName);
  w2:=sql.SelectString('Printer','NameA5','ComputerName='+sql.MakeStr(mach));

 WordApplication1.Documents.Open(p,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam);
w3:=sql.SelectString('Printer','ComNameA5','ComputerName='+sql.MakeStr(mach));
if  (VarToStr(w2)='') or (VarToStr(w3)='')then
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
wordApplication1.ActiveWindow.SetFocus;
T:  //if WordApplication1.Dialogs.Count<>0 then
    WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
        //WordApplication1.WindowState:=2;
WordApplication1.Free;
except
WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
application.MessageBox('Проверьте все настройки для печати!','Ошибка!',0);
exit
end;
end;

procedure TFormOrderBox.FormCreate;
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

procedure TFormOrderBox.FormActivate(Sender: TObject);
begin
// cbClient.SQLComboBox.Sorted:=true;

end;

procedure TFormOrderBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btPrintClick(Sender)
end;

procedure TFormOrderBox.CheckBox2Click(Sender: TObject);
begin
if  CheckBox2.Checked then
    NSP:=1
 else NSP:=0;
if cbClient.GetData<>0 then
FormOrderBox.eSumNDSChange(sender);

end;

procedure TFormOrderBox.LabelEditDate1Exit(Sender: TObject);
begin

eNSP.Visible:=false;
NSP:=0;
CheckBox2.Visible:=false;

FormOrderBox.eSumNDSChange(sender);
eNumber.text:= Num;
end;

procedure TFormOrderBox.eNumberChange(Sender: TObject);
begin
Number:=eNumber.text;
end;

end.
