unit FInvoiceBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlGrid,Tadjform,tsqlcls,  StdCtrls, Buttons, BMPBtn;

type
  TFormInvoiceBox = class(TAdjustForm)
    SQLGrid1: TSQLGrid;
    BAdd: TBMPBtn;
    BEdit: TBMPBtn;
    BDel: TBMPBtn;
    BExit: TBMPBtn;
    procedure BExitClick(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure SQLGrid1RowChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BDelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormInvoiceBox: TFormInvoiceBox;

implementation

uses FInvoice,Invoice;

{$R *.dfm}

procedure TFormInvoiceBox.BExitClick(Sender: TObject);
begin
close;
end;

procedure TFormInvoiceBox.BAddClick(Sender: TObject);
var l:longint;
begin
sql.StartTransaction;
FormInvoice:=TFormInvoice.Create(Application) ;
l:=FormInvoice.AddRecord(0);
FormInvoice.Free;
if l<>0 then
begin
sql.Commit;
SQLGrid1.execTable('InvoiceView');
SQLGrid1.LoadPoint('Ident',l);
end else sql.Rollback;
end;

procedure TFormInvoiceBox.SQLGrid1RowChange(Sender: TObject);
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

procedure TFormInvoiceBox.FormCreate(Sender: TObject);
begin
SQLGrid1.Section:='InvoiceView' ;
SQLGrid1.ExecTable('InvoiceView');
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
fsection:='FInvoice' ;
end;

procedure TFormInvoiceBox.BEditClick(Sender: TObject);
var L,Id:longint;
begin
//InvoiceFill;
Id:=SQLGrid1.Query.FieldByName('Ident').asInteger;
sql.StartTransaction;
FormInvoice:=TFormInvoice.Create(Application) ;
l:=FormInvoice.EditRecord(Id);
FormInvoice.Free;
if l<>0 then
begin
sql.Commit;
SQLGrid1.execTable('InvoiceView');
SQLGrid1.LoadPoint('Ident',l);
end else sql.Rollback;
end;

procedure TFormInvoiceBox.BDelClick(Sender: TObject);
var Id:longint;
    N:string;
begin  
Id:=sqlGrid1.Query.FieldByName('Ident').AsInteger;
N:=sqlGrid1.Query.FieldByName('Number').AsString;
sqlGrid1.SaveNextPoint('Ident');
Sql.StartTransaction;
if sql.Delete('Invoice','Ident='+IntToStr(Id))<>0 then
  begin
   application.MessageBox('Запись не подлежит удалению!','Ошибка!',0);
   sql.Rollback;
   exit
  end;
if sql.UpdateString('Send','NumberCountPattern=NULL','NumberCountPattern='+sql.MakeStr(N))<>0
 then begin
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

procedure TFormInvoiceBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then BEditClick(Sender)
end;

end.
