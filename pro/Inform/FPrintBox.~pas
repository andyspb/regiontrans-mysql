unit FPrintBox;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlGrid,Tadjform,tsqlcls,  StdCtrls, Buttons, BMPBtn;
type
  TFormPrinterBox = class(TAdjustForm)
    BEdit: TBMPBtn;
    BAdd: TBMPBtn;
    BDel: TBMPBtn;
    BExit: TBMPBtn;
    SQLGrid1: TSQLGrid;
    procedure BExitClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BDelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SQLGrid1RowChange(Sender: TObject);
    procedure BAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrinterBox: TFormPrinterBox;

implementation

uses FPrint;

{$R *.dfm}

procedure TFormPrinterBox.BExitClick(Sender: TObject);
begin
close;
end;

procedure TFormPrinterBox.BEditClick(Sender: TObject);
var l:longint;
st:string;
begin
st:=SQLGrid1.Query.FieldByName('ComputerName').asstring;
sql.StartTransaction;
FormPrinter:=TFormPrinter.Create(Application) ;
l:=FormPrinter.EditRecord(st);
FormPrinter.Free;
if l<>0 then
begin
sql.Commit;
SQLGrid1.execTable('PrinterView');
//SQLGrid1.LoadPoint('Ident',l);
end else sql.Rollback;

end;


procedure TFormPrinterBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then BEditClick(Sender)
end;

procedure TFormPrinterBox.BDelClick(Sender: TObject);
var
    N:string;
begin

N:=sqlGrid1.Query.FieldByName('ComputerName').AsString;
//sqlGrid1.SaveNextPoint('ComputerName');
Sql.StartTransaction;
if sql.Delete('Printer','ComputerName='+sql.Makestr(N))<>0 then
  begin
   application.MessageBox('Запись не подлежит удалению!','Ошибка!',0);
   sql.Rollback;
   exit
  end;

case Application.MessageBox('Удалить!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
sql.Commit;
SQLGrid1.exec;
SQLGrid1RowChange(Sender);
     end;
     IDNO:
      begin
      sql.rollback;
      exit
      end;
end;
end;

procedure TFormPrinterBox.FormCreate(Sender: TObject);
begin
SQLGrid1.Section:='PrinterView' ;
SQLGrid1.ExecTable('PrinterView');
if SQLGrid1.Query.eof then
begin
    SQLGrid1.visible:=false;
    BEdit.enabled:=false;
    BDel.enabled:=false;
end else begin
           SQLGrid1.visible:=true;
           BEdit.enabled:=true;
           BDel.enabled:=true;
         end;
fsection:='FPrinter' ;


end;

procedure TFormPrinterBox.SQLGrid1RowChange(Sender: TObject);
begin
if (SQLGrid1.Query.Eof) and (SQLGrid1.Query.bof)
then begin
     SQLGrid1.visible:=false;
     BEdit.enabled:=false;
     BDel.enabled:=false;
     end else
         begin
           SQLGrid1.visible:=true;
           BEdit.enabled:=true;
           BDel.enabled:=true;
         end;
end;

procedure TFormPrinterBox.BAddClick(Sender: TObject);
var l:longint;
st:string;
begin
st:='';
sql.StartTransaction;
FormPrinter:=TFormPrinter.Create(Application) ;
l:=FormPrinter.AddRecord(st);
FormPrinter.Free;
if l<>0 then
begin
sql.Commit;
SQLGrid1.execTable('PrinterView');
//SQLGrid1.LoadPoint('ComputerName',st);
//SQLGrid1.s
end else sql.Rollback;


end;

end.
