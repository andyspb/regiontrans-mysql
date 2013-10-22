unit Fpaysheet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlGrid, StdCtrls,Tadjform,tsqlcls, Buttons, BMPBtn, EntrySec;

type
  TFormPaysheetBox = class(TAdjustForm)
    BAdd: TBMPBtn;
    BEdit: TBMPBtn;
    BDel: TBMPBtn;
    BExit: TBMPBtn;
    SQLGrid1: TSQLGrid;
    procedure FormCreate(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BDelClick(Sender: TObject);
    procedure BExitClick(Sender: TObject);
    procedure SQLGrid1RowChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPaysheetBox: TFormPaysheetBox;

implementation

uses Fpaysheetu;

{$R *.dfm}

procedure TFormPaysheetBox.FormCreate(Sender: TObject);
begin
  SQLGrid1.Section:='PaySheetView' ;
  Caption:='Платежки ( '+ EntrySec.period+ ' )';
  if EntrySec.bAllData then
    begin
    SQLGrid1.ExecTable('PaySheetView_all');
    BAdd.Enabled:=False;
    end
  else
    begin
      SQLGrid1.ExecTable('PaySheetView');
      BAdd.Enabled:=True;
    end;
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
  fsection:='FPaySheetView' ;
end;

procedure TFormPaysheetBox.BAddClick(Sender: TObject);
var
  l:longint;
begin
  sql.StartTransaction;
  FormPaySheet:=TFormPaySheet.Create(Application) ;
  l:=FormPaySheet.AddRecord;
  FormPaySheet.Free;
  if l<>0 then
  begin
  sql.Commit;
  if EntrySec.bAllData then
    SQLGrid1.exectable('PaySheetView_all')
  else
    SQLGrid1.exectable('PaySheetView');
  SQLGrid1.LoadPoint('Ident',l);
end
else
  sql.Rollback;

end;

procedure TFormPaysheetBox.BEditClick(Sender: TObject);
var
  l:longint;
begin
  SQLGrid1.Query.FieldByName('Ident').AsInteger;
  sql.StartTransaction;
  FormPaySheet:=TFormPaySheet.Create(Application) ;
  l:=FormPaySheet.EditRecord(SQLGrid1.Query);
  FormPaySheet.Free;
  if l<>0 then
  begin
    sql.Commit;
    if EntrySec.bAllData then
      SQLGrid1.exectable('PaySheetView_All')
    else
      SQLGrid1.exectable('PaySheetView');

    SQLGrid1.LoadPoint('Ident',l);
  end
  else
    sql.Rollback;
end;

procedure TFormPaysheetBox.BDelClick(Sender: TObject);
var
  Id:longint;
begin
  sql.StartTransaction;
  Id:=SQLGrid1.Query.FieldByName('Ident').AsInteger;
  SQLGrid1.saveNextPoint('Ident');
  if sql.Delete('PaySheet','Ident='+IntToStr(Id))=0 then
  begin
    case Application.MessageBox('Удалить!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
      begin
        sql.Commit;
        SQLGrid1.Exec;
        SQLGrid1RowChange(Sender);
      end;
    IDNO:
      begin
        sql.rollback;
        exit
      end;
    end;
  end
  else
  begin
    sql.Rollback;
  end;
end;

procedure TFormPaysheetBox.BExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPaysheetBox.SQLGrid1RowChange(Sender: TObject);
begin
  if (SQLGrid1.Query.eof)and (SQLGrid1.Query.bof) then
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

procedure TFormPaysheetBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return then
  BEditClick(Sender)
end;

end.
