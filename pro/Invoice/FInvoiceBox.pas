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
    SQLGrid1.execTable(EntrySec.invoiceview_view);
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
//  SQLGrid1.Section:='InvoiceView' ;
  SQLGrid1.Section:=EntrySec.invoiceview_view ;
  // krutogolov
  Caption:='Счет-Фактуры ( ' + EntrySec.period + ' )';
  // BAdd.Enabled:= iff(EntrySec.bAllData, False, True);
  // delete
  Caption:='Счет-Фактуры ( ' + EntrySec.period + ' )';

  SQLGrid1.ExecTable(EntrySec.invoiceview_view);
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
  SQLGrid1.execTable(EntrySec.invoiceview_view);
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
  invoice_table: string;
  invoice_table_other: string;
  del_thread: TDeleteThread;
  update_thread: TUpdateThread;

begin
  ident := sqlGrid1.Query.FieldByName('Ident').AsInteger;
  ident_str := IntToStr(ident);
  number := sqlGrid1.Query.FieldByName('Number').AsString;
  sqlGrid1.SaveNextPoint('Ident');
  invoice_table:=iff(EntrySec.bAllData, '`Invoice_all`', '`Invoice`');
  invoice_table_other:=iff(EntrySec.bAllData, '`Invoice`', '`Invoice_all`');

  Sql.StartTransaction;
  if sql.Delete(invoice_table,'Ident='+IntToStr(ident))<>0 then
  begin
    application.MessageBox('Запись не подлежит удалению!','Ошибка!',0);
    sql.Rollback;
    exit
  end;
  if sql.UpdateString(EntrySec.send_table {'Send'},'NumberCountPattern=NULL','NumberCountPattern='+sql.MakeStr(number))<>0 then
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
      del_thread := TDeleteThread.Create(True, invoice_table_other, ident_str);
      del_thread.Resume();
      update_thread := TUpdateThread.Create(True, EntrySec.send_table_other, 'NumberCountPattern=NULL','NumberCountPattern='+sql.MakeStr(number));
      update_thread.Resume();
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
