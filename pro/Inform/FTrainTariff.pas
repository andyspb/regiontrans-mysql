unit FTrainTariff;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, Menus, OleServer, Word2000, DBTables,
  StdCtrls, Buttons, BMPBtn,tsqlcls,SqlGrid, ComCtrls;

type
  TFormTrainTariff = class(TForm)
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    btPrint: TBMPBtn;
    Query1: TQuery;
    UpdateSQL1: TUpdateSQL;
    DataSource1: TDataSource;
    WordApplication1: TWordApplication;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    DBGrid1: TDBGrid;
    Query1Distance: TFloatField;
    Query1Tariff: TFloatField;
    procedure btCanselClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
  function EditRecord:longint;         
    { Public declarations }
  end;

var
  FormTrainTariff: TFormTrainTariff;
  Id:longint;
implementation

Uses makerepp, FConstant ;
{$R *.dfm}

function TFormTrainTariff.EditRecord:longint;
begin
 Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select * from TrainTariff order by Distance');
 Query1.ExecSQL;
 query1.Open;
 Query1Distance.DisplayFormat:='#####.##'   ;
 Query1Tariff.DisplayFormat:='#####.##';
 Query1Tariff.EditFormat:='#####.##';
  Query1Distance.EditFormat:='#####.##'   ;
  //Query1Tariff.
 if ShowModal=mrOk then
 begin
   Query1.CommitUpdates;
   EditRecord:=1;
 end
 else  EditRecord:=0
end;

procedure TFormTrainTariff.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TFormTrainTariff.btOkClick(Sender: TObject);
begin
  Query1.ApplyUpdates;
  ModalResult:=mrOk;

end;

procedure TFormTrainTariff.N1Click(Sender: TObject);
begin
Query1.Delete;
end;

procedure TFormTrainTariff.N2Click(Sender: TObject);
begin
 FormTrainTariff.btOk.SetFocus;
end;


procedure TFormTrainTariff.btPrintClick(Sender: TObject);
var
ReportMakerWP:TReportMakerWP;
p,w1,w2,w3,w4:OleVariant;
mach:string;
label T;
begin
try
 ReportMakerWP:=TReportMakerWP.Create(Application);

  ReportMakerWP.ClearParam;
  ReportMakerWP.AddParam('1='+FormatDateTime('dd.mm.yyyy',now)+' г.');
  ReportMakerWP.AddParam('2='+'Тарифы на ');
  ReportMakerWP.AddParam('3='+'* При перевозке в Москве дополнительно'+
                            ' взыскивается 25.00 руб. за каждое место');
  if ReportMakerWP.DoMakeReport(systemdir+'Inform\TrainTariff.rtf',
          systemdir+'Inform\TrainTariff.ini', systemdir+'Inform\out.rtf')<>0 then
                              begin
                              ReportMakerWP.Free;
                             // application.messagebox('Закройте выходной документ в WINWORD!',
                             // 'Совет!',0);
                             //goto T;
                              exit
                              end;;
  ReportMakerWP.Free;
//---
WordApplication1:=TWordApplication.Create(Application);
  p :=systemdir+'Inform\out.rtf';
  w1:=1;
  mach:='';
  mach:= trim(WordApplication1.UserName);
  w2:=sql.SelectString('Printer','NameA4','ComputerName='+sql.MakeStr(mach));

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

procedure TFormTrainTariff.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOkClick(Sender)
end;

end.
