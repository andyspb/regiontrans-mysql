unit FInvoiceBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlGrid, Tadjform, tsqlcls, StdCtrls, Buttons, BMPBtn, EntrySec;

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
  invoiceview_str: string;

implementation

uses FInvoice,Invoice;

{$R *.dfm}

procedure TFormInvoiceBox.BExitClick(Sender: TObject);
begin
  close;
end;

procedure TFormInvoiceBox.BAddClick(Sender: TObject);
var
  l:longint;
begin
  sql.StartTransaction;
  FormInvoice:=TFormInvoice.Create(Application) ;
  l:=FormInvoice.AddRecord(0);
  FormInvoice.Free;
  if l<>0 then
  begin
    sql.Commit;
    SQLGrid1.execTable(invoiceview_str);
    SQLGrid1.LoadPoint('Ident',l);
  end
  else
    sql.Rollback;
end;

procedure TFormInvoiceBox.SQLGrid1RowChange(Sender: TObject);
begin
if (SQLGrid1.Query.Eof) and (SQLGrid1.Query.bof)
then
begin
  SQLGrid1.visible:=false;
  BEdit.enabled:=false;
  BDel.enabled:=false;
end
else
  begin
    SQLGrid1.visible:=true;
    BEdit.enabled:=true;
    BDel.enabled:=true;
  end;
end;

procedure TFormInvoiceBox.FormCreate(Sender: TObject);
begin
  SQLGrid1.Section:='InvoiceView' ;
  // krutogolov
  Caption:='Счет-Фактры ( ' + EntrySec.period + ' )';
  if EntrySec.bAllData then
    begin
      invoiceview_str:='InvoiceView_all';
      BAdd.Enabled:= False;
    end
  else
    begin
      BAdd.Enabled:= True;
      invoiceview_str:='InvoiceView';
    end;
  // delete
  Caption:='Счет-Фактры ( ' + EntrySec.period + ' ) [' + invoiceview_str  + ']';

  SQLGrid1.ExecTable(invoiceview_str);
  if SQLGrid1.Query.eof then
  begin
    SQLGrid1.visible:=false;
    BEdit.enabled:=false;
    BDel.enabled:=false;
  end
  else
  begin
    SQLGrid1.visible:=true;
    BEdit.enabled:=true;
    BDel.enabled:=true;
  end;
  fsection:='FInvoice' ;
end;

procedure TFormInvoiceBox.BEditClick(Sender: TObject);
var
  L,Id:longint;
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
  SQLGrid1.execTable(invoiceview_str);
  SQLGrid1.LoadPoint('Ident',l);
end
else
  sql.Rollback;
end;

procedure TFormInvoiceBox.BDelClick(Sender: TObject);
var
  ident: longint;
  number: string;
  ident_str: string;
  table_str: string;
  other_table_str: string;
  del_thread: TDeleteThread;

begin
  ident := sqlGrid1.Query.FieldByName('Ident').AsInteger;
  ident_str := IntToStr(ident);
  number := sqlGrid1.Query.FieldByName('Number').AsString;
  sqlGrid1.SaveNextPoint('Ident');
  if EntrySec.bAllData then
  begin
    table_str:='`Invoice_all`';
    other_table_str:='`Invoice`';
  end
  else
  begin
    table_str:='`Invoice`';
    other_table_str:='`Invoice_all`';
  end;

  Sql.StartTransaction;
  if sql.Delete(table_str,'Ident='+IntToStr(ident))<>0 then
  begin
    application.MessageBox('Запись не подлежит удалению!','Ошибка!',0);
    sql.Rollback;
    exit
  end;
  if sql.UpdateString('Send','NumberCountPattern=NULL','NumberCountPattern='+sql.MakeStr(number))<>0 then
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
      del_thread := TDeleteThread.Create(True, other_table_str, ident_str);
      del_thread.Resume();
    end;
    IDNO:
    begin
      sql.rollback;
      exit
    end;
  end;
end;

procedure TFormInvoiceBox.FormKeyDown(Sender: TObject;
var
  Key: Word;
  Shift: TShiftState);
begin
  if key = VK_Return then
    BEditClick(Sender)
end;

end.
