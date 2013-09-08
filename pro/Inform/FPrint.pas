unit FPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, BMPBtn, ComCtrls, LblEdtDt,
  SqlGrid, DB,TSQLCLS,DBTables,Tadjform;

type
  TFormPrinter = class(TForm)
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    ePrA4: TLabeledEdit;
    ePrA5: TLabeledEdit;
    eComA5: TLabeledEdit;
    eComA4: TLabeledEdit;
    eComName: TLabeledEdit;
    procedure btCanselClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure PrName;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
  function EditRecord(st:string):integer;
  function AddRecord(var st:string):integer;
    { Public declarations }
  end;

var
  FormPrinter: TFormPrinter;

implementation

{$R *.dfm}
function TFormPrinter.AddRecord(var st:string):integer ;
var
    str:string;
begin
str:='';
ePrA5.text:=   '';
ePrA4.text:=   '';
eComA4.text:=  '';
eComA5.text:=  '';
eComName.text:='';
if showModal=mrOk then
begin
str:= trim(eComName.text)   ;
  if sql.selectstring('Printer','ComputerName','ComputerName='+sql.MakeStr(str)) <> ''
  then
   begin
    Application.MessageBox('Принтера для компьютера с таким именем уже внесены!','Ошибка!',0);
    ADDRecord:=0;
    exit
   end
  else begin
  PrName;
  if  ePrA5.text<>'' then
   str:=sql.MakeStr(trim(ePrA5.text))
   else str:='NULL';
  if  ePrA4.text<>'' then
   str:=str+','+sql.MakeStr(trim(ePrA4.text))
   else str:=str+',NULL';
  if  ecomA5.text<>'' then
   str:=str+','+sql.MakeStr(trim(eComA5.text))
   else str:=str+','+'NULL';
  if  eComA4.text<>'' then
   str:=str+','+sql.MakeStr(trim(eComA4.text))
   else str:=str+',NULL';
  if  eComName.text<>'' then
   str:=str+','+sql.MakeStr(trim(eComName.text))
   else str:=str+',NULL';

   if sql.insertstring('Printer','NameA5,NameA4,ComNameA5,ComNameA4,ComputerName',str) <>0
   then
    begin
    ADDRecord:=0;
    exit
    end;

  AddRecord:=1;
  st:= trim(eComName.text);
  end;
end else AddRecord:=0;
end;
function TFormPrinter.EditRecord(st:string):integer;
var q:TQuery;
    str:string;
begin
str:='';
q:=sql.select('Printer','','ComputerName='+sql.MakeStr(st),'');
if  q.FieldByName('NameA5').asString<>'' then
ePrA5.text:=q.FieldByName('NameA5').asString;

if  q.FieldByName('NameA4').asString<>'' then
ePrA4.text:=q.FieldByName('NameA4').asString;

if  q.FieldByName('ComNameA4').asString<>'' then
eComA4.text:=q.FieldByName('ComNameA4').asString;
if  q.FieldByName('ComNameA5').asString<>'' then
eComA5.text:=q.FieldByName('ComNameA5').asString;

if  q.FieldByName('ComputerName').asString<>'' then
eComName.text:=q.FieldByName('ComputerName').asString;
q.Free;
if showModal=mrOk then
begin
PrName;
   if  ePrA5.text<>'' then
   str:='NameA5='+sql.MakeStr( trim(ePrA5.text))
   else str:='NameA5=NULL';
  if  ePrA4.text<>'' then
   str:=str+',NameA4='+sql.MakeStr(trim(ePrA4.text))
   else str:=str+',NameA4=NULL';
 //-------------------
   if  eComA5.text<>'' then
  str:=str+',ComNameA5='+sql.MakeStr( trim(eComA5.text))
   else str:=str+',ComNameA5=NULL';
  if  eComA4.text<>'' then
   str:=str+',ComNameA4='+sql.MakeStr(trim(eComA4.text))
   else str:=str+',ComNameA4=NULL';
  if  eComName.text<>'' then
   str:=str+',ComputerName='+sql.MakeStr(trim(eComName.text))
   else str:=str+',ComputerName=NULL';

   if sql.updatestring('Printer',str,'ComputerName='+sql.MakeStr(trim(eComName.text)))<>0
   then
   begin
   EditRecord:=0;
   exit
   end;

  EditRecord:=1  ;

end else EditRecord:=0;

end;


procedure TFormPrinter.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TFormPrinter.btOkClick(Sender: TObject);
begin
if  ePrA4.text=''then
begin
 Application.MessageBox('Введите значение!','Ошибка!',0);
 ePrA4.SetFocus;
 exit
end else
    if ePrA5.text='' then
    begin
     Application.MessageBox('Введите значение!','Ошибка!',0);
     ePrA5.SetFocus;
     exit
    end else
    if eComA5.text='' then
    begin
     Application.MessageBox('Введите значение!','Ошибка!',0);
     eComA5.SetFocus;
     exit
     end else
    if eComA4.text='' then
    begin
     Application.MessageBox('Введите значение!','Ошибка!',0);
     eComA4.SetFocus;
     exit
    end else
    if eComName.text='' then
    begin
     Application.MessageBox('Введите значение!','Ошибка!',0);
     eComName.SetFocus;
     exit
    end else
      ModalResult:=mrOk;
end;

procedure TFormPrinter.PrName;
var txt:string;
begin
txt:='';

txt:=trim(ePrA4.text);
if pos('\',txt)<>0 then
if pos('\\\',txt)=0 then
  txt:='\\'+txt;
ePrA4.text:=txt;
//----------------------------------------------------
txt:=trim(ePrA5.text);
if pos('\',txt)<>0 then 
if pos('\\\',txt)=0 then
  txt:='\\'+txt;
ePrA5.text:=txt;
end ;

procedure TFormPrinter.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOkClick(Sender)
end;

end.
