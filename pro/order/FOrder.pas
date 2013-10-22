unit FOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, tsqlcls,SqlGrid,Tadjform,  StdCtrls, Buttons, BMPBtn, EntrySec;

type
  TFormOrder = class(Tadjustform)
    BAdd: TBMPBtn;
    BEdit: TBMPBtn;
    BDel: TBMPBtn;
    BExit: TBMPBtn;
    SQLGrid1: TSQLGrid;
    procedure FormCreate(Sender: TObject);
    procedure BExitClick(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure SQLGrid1RowChange(Sender: TObject);
    procedure BDelClick(Sender: TObject);
    procedure SQLGrid1AfterExec(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOrder: TFormOrder;

implementation

uses OrderBox,Menu;


{$R *.dfm}

procedure TFormOrder.FormCreate(Sender: TObject);
begin
  SQLGrid1.Section:='Orders' ;
  Caption:='Приходные кассоввые ордера ( ' + EntrySec.period + ' )';
  if EntrySec.bAllData then
    begin
      SQLGrid1.ExecTable('Orders_all');
      BAdd.Enabled:=False;
    end
  else
    begin
      SQLGrid1.ExecTable('Orders');
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
    SQLGrid1.visible:=true;
    BEdit.enabled:=true;
    BDel.enabled:=FMenu.byh;
  end;
  fsection:='Ford'
end;

procedure TFormOrder.BExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormOrder.BAddClick(Sender: TObject);
var
  l:longint;
begin
  sql.StartTransaction;
  FormOrderBox:=TFormOrderBox.Create(Application) ;
  l:=FormOrderBox.AddRecord;
  FormOrderBox.Free;
  if l<>0 then
  begin
    sql.Commit;
    if EntrySec.bAllData then
      SQLGrid1.exectable('Orders_all')
    else
      SQLGrid1.exectable('Orders');
    SQLGrid1.LoadPoint('Ident',l);
  end
  else
    sql.Rollback;
end;

procedure TFormOrder.SQLGrid1RowChange(Sender: TObject);
begin
  if (SQLGrid1.Query.Eof) and (SQLGrid1.Query.bof) then
  begin
    SQLGrid1.visible:=false;
    BEdit.enabled:=false;
    BDel.enabled:=false;
  end
  else
  begin
    SQLGrid1.visible:=true;
    BEdit.enabled:=true;
    BDel.enabled:=Fmenu.byh;
  end;
end;

procedure TFormOrder.BDelClick(Sender: TObject);
var
  Id:longint;
begin
  sql.StartTransaction;
  Id:=SQLGrid1.Query.FieldByName('Ident').AsInteger;
  SQLGrid1.saveNextPoint('Ident');
  if sql.Delete('`Order`','Ident='+IntToStr(Id))=0 then
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

procedure TFormOrder.SQLGrid1AfterExec(Sender: TObject);
var
  Id,l:longint;
begin
  Id:=SQLGrid1.Query.FieldByName('Ident').AsInteger;
  sql.StartTransaction;
  FormOrderBox:=TFormOrderBox.Create(Application) ;
  l:=FormOrderBox.EditRecord(Id);
  FormOrderBox.Free;
  if l<>0 then
  begin
    sql.Commit;
    if EntrySec.bAllData then 
      SQLGrid1.exectable('Orders_all')
    else
      SQLGrid1.exectable('Orders');

    SQLGrid1.LoadPoint('Ident',l);
  end
  else
    sql.Rollback;
end;

procedure TFormOrder.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_Return then
    SQLGrid1AfterExec(Sender)
end;

end.
