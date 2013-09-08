unit FTrain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, BMPBtn, ComCtrls, DBTables, DB, Grids,
  DBGrids,tsqlcls, OleServer, SqlGrid,Word2000, Menus, Sqlctrls, LblCombo,
  ExtCtrls;

type
  TFormTrain = class(TForm)
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    Query1: TQuery;
    Query1Number: TStringField;
    Query1Way: TStringField;
    Query1Count: TIntegerField;
    Query1Day: TStringField;
    UpdateSQL1: TUpdateSQL;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    HeaderControl1: THeaderControl;
    Query1Ident: TIntegerField;
    Query1Times: TStringField;
    btPrint: TBMPBtn;
    WordApplication1: TWordApplication;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    Panel1: TPanel;
    cbxList: TLabelComboBox;
    BMPBtn1: TBMPBtn;
    BMPBtn2: TBMPBtn;
    procedure btCanselClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure BDelClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure cbxListChange(Sender: TObject);
    procedure BMPBtn1Click(Sender: TObject);
    procedure BMPBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
  function AddRecord:longint;
  function EditRecord:longint;
  function  DaySet(var str: string):Boolean;
    { Public declarations }
  end;

var
  FormTrain: TFormTrain;
  Id:longint;
implementation

Uses makerepp ;
{$R *.dfm}
function TFormTrain.AddRecord:longint;
begin
 Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select * from Train where Arch=0');
 Query1.ExecSQL;
 query1.Open;
 if ShowModal=mrOk then
 begin
   Query1.CommitUpdates;
   AddRecord:=1;
 end
 else  AddRecord:=0
end;

function TFormTrain.EditRecord:longint;
begin
 Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select * from Train where Arch=0;');
 Query1.ExecSQL;
 query1.Open;
 if ShowModal=mrOk then
 begin
   Query1.CommitUpdates;
   EditRecord:=1;
 end
 else  EditRecord:=0
end;

procedure TFormTrain.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TFormTrain.btOkClick(Sender: TObject);
var i:integer;
    test:boolean;
    s:string;
begin
 test:=true;
 s:='';
 Query1.DisableControls;
 Query1.First;

  while (not Query1.eof)and(test) do
   begin
   if (Query1.FieldByName('Day').asString<>'') then
   begin
   s:=Query1.FieldValues['Day']  ;
    test:=DaySet(s);
   end;
   Query1.Next;
  end;
  Query1.EnableControls ;
  if (not test) then
   begin
   
   ShowMessage
      ('Дни недели введены не правильно! - '+s+' ');
     DBGrid1.focused;
     exit;
     end ;
//-------------------------
 id:=sql.FindNextInteger('Ident','Train','',MaxLongint);
 i:=0;
 Query1.DisableControls;
 Query1.First;

  while (not Query1.eof) do
   begin
   if  Query1.FieldByName('Ident').asString='' then
   begin
   Query1.Edit;
   Query1.FieldValues['Ident']:=Id+i;
   Query1.Post;
   i:=i+1;
   end;
   Query1.Next;
  end;
  Query1.EnableControls ;
  Query1.ApplyUpdates;
  ModalResult:=mrOk;
end;

function  TFormTrain.DaySet(var str: string):Boolean;
Type  Digital = set of char;
var dig2:string;
   dig1:string;
   dig : string;
   dig3: Digital;
   len : integer;
   test : boolean;
   posit:integer;
   s,sV:string;
label Finish;
begin
test:=true;
dig:=' Пн '+' Вт '+' Ср '+' Чт '+' Пт '+' Сб '+' Вс ';
dig1:=' 10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31';
dig2:=' Нечет  Чет ' ;
dig3:= ['1','2','3','4','5','6','7','8','9'];
Len:=Length(trim(str));
sv:=trim(str);
while  (Len>0) and test do
begin
posit:=pos(',',sv);
if posit<>0 then
begin
s:=copy(sv,1,posit-1);
delete(sv,1,posit);
end
else begin
       s:=sv;
       sv:='';
     end;
s:=trim(s);
sv:=trim(sv);
len:=Length(sv);
if Length(s)>1 then
begin
if (pos(S,dig)=0)then test:=false
  else begin
       test:=true;
       goto Finish;
       exit;
       end;
   if(pos(s,dig2)=0) then test:=false
      else begin
            test:=true;
            goto Finish;
            exit;
           end ;
      if  (pos(s,dig1)=0)  then test:=false
             else begin
                   test:=true;
                   goto Finish;
                   exit;
                  end;
 end else if (not(s[1] in dig3))then test:=false
         else begin
               test:=true;
               goto Finish;
               exit;
              end;
end;
finish:
DaySet:=test;
end;


procedure TFormTrain.btPrintClick(Sender: TObject);
var
ReportMakerWP:TReportMakerWP;
p,w1,w2,w3,w4: OleVariant;
mach:string;
label T;
begin
try

  ReportMakerWP:=TReportMakerWP.Create(Application);

  ReportMakerWP.ClearParam;
  ReportMakerWP.AddParam('1='+FormatDateTime('dd.mm.yyyy',now)+' г.');
  ReportMakerWP.AddParam('2='+'Технология на ');

  if cbxList.combobox.ItemIndex=0 then
  begin
   ReportMakerWP.AddParam('3='+'0');
  // ReportMakerWP.AddParam('4='+'Архив поездов');
  end;
  if cbxList.combobox.ItemIndex=1 then
  begin
  ReportMakerWP.AddParam('3='+'1');
   ReportMakerWP.AddParam('4='+'Архив поездов');
  end;

  if ReportMakerWP.DoMakeReport(systemdir+'Inform\Train.rtf',
          systemdir+'Inform\Train.ini', systemdir+'Inform\out.rtf')
          <>0 then
                              begin
                              ReportMakerWP.Free;
                              //application.messagebox('Закройте выходной документ в WINWORD!',
                              //'Совет!',0);
                              //goto T;
                              exit
                              end;;
  ReportMakerWP.Free;
//---
WordApplication1:=TWordApplication.Create(Application);
  p := systemdir+'Inform\out.rtf';
  w1:=1;
  mach:='';
  mach:= trim(WordApplication1.UserName);
  w2:=sql.SelectString('Printer','NameA4','ComputerName='+sql.MakeStr(mach));
 WordApplication1.Documents.Open(p,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam);
//WordApplication1.
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

procedure TFormTrain.BDelClick(Sender: TObject);
begin
   Query1.Delete; 
end;

procedure TFormTrain.N1Click(Sender: TObject);
var q:TQuery;
    Id:longint;
begin
id:=Query1.FieldValues['Ident']   ;
q:=sql.select('CityTrain','City_Ident','Train_Ident='+IntToStr(Id),'') ;
if q.eof then
Query1.Delete
else application.MessageBox('Запись не подлежит удалению!','Ошибка',0);
end;

procedure TFormTrain.N2Click(Sender: TObject);
begin
//FormTrain.FindComponent('btOk');
 FormTrain.btOk.SetFocus;
end;

procedure TFormTrain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOkClick(Sender)
end;

procedure TFormTrain.FormCreate(Sender: TObject);
begin
 cbxList.ComboBox.Items.Add('Текущие поезда') ;
 cbxList.ComboBox.Items.Add('Архив поездов')    ;
 cbxList.ComboBox.ItemIndex:=0;
  BMPBtn1.Visible:=true;
  BMPBtn2.Visible:=false;
end;

procedure TFormTrain.cbxListChange(Sender: TObject);
begin
if cbxList.combobox.ItemIndex=0 then
begin
 Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select * from Train where Arch=0');
 Query1.ExecSQL;
 query1.Open;
 BMPBtn1.Visible:=true;
  BMPBtn2.Visible:=false;
end else  if cbxList.combobox.ItemIndex=1 then
    begin
     Query1.Close;
     Query1.DatabaseName:=sql.DataBaseName;
     Query1.SQL.Clear;
     Query1.SQL.Add('select * from Train where Arch=1');
     Query1.ExecSQL;
     query1.Open;
     BMPBtn1.Visible:=false;
     BMPBtn2.Visible:=true;
    end      ;
end;

procedure TFormTrain.BMPBtn1Click(Sender: TObject);
var l:longint;
begin
if not Query1.eof then
begin
l:=Query1.FieldValues['Ident']   ;
if sql.UpdateString('Train','Arch='+IntToStr(1),'Ident='+Inttostr(l))=0 then
begin
Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select * from Train where Arch=0');
 Query1.ExecSQL;
 query1.Open;
end //else
end
 end;

procedure TFormTrain.BMPBtn2Click(Sender: TObject);
var l:longint;
begin
if not Query1.eof then
begin
l:=Query1.FieldValues['Ident']   ;
if sql.UpdateString('Train','Arch='+IntToStr(0),'Ident='+Inttostr(l))=0 then
begin
Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select * from Train where Arch=1');
 Query1.ExecSQL;
 query1.Open;
end //else
end
end;

end.
