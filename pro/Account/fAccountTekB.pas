unit fAccountTekB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlGrid,Tadjform,tsqlcls,  StdCtrls, Buttons, BMPBtn, EntrySec;


type
  TFormAccountTekBox = class(TAdjustForm)
    BEdit: TBMPBtn;
    BAdd: TBMPBtn;
    BDel: TBMPBtn;
    BExit: TBMPBtn;
    SQLGrid1: TSQLGrid;
    procedure FormCreate(Sender: TObject);
    procedure SQLGrid1RowChange(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BDelClick(Sender: TObject);
    procedure BExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAccountTekBox: TFormAccountTekBox;
  accounttekvew_str: string;
implementation

uses FAccount, FAccountTek;

{$R *.dfm}

procedure TFormAccountTekBox.FormCreate(Sender: TObject);
begin
  SQLGrid1.Section:='AccountTEKView' ;
  Caption:='Счета-ТЭК ( ' + EntrySec.period + ' )';
  if EntrySec.bAllData then
    begin
      accounttekvew_str:='AccountTEKView_all';
      BAdd.Enabled:=False;
    end
  else
    begin
      accounttekvew_str:='AccountTEKView';
      BAdd.Enabled:=True;
   end;
  SQLGrid1.ExecTable(accounttekvew_str);
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
  fsection:='FAccountTEK' ;
end;

procedure TFormAccountTekBox.SQLGrid1RowChange(Sender: TObject);
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
    BDel.enabled:=true;
  end;
end;

procedure TFormAccountTekBox.BAddClick(Sender: TObject);
var
  l:longint;
begin
  sql.StartTransaction;
  FormAccountTEK:=TFormAccountTEK.Create(Application) ;
  l:=FormAccountTEK.AddRecord;
  FormAccountTEK.Free;
  if l<>0 then
  begin
    sql.Commit;
    SQLGrid1.execTable(accounttekvew_str);
    SQLGrid1.LoadPoint('Ident',l);
  end
  else
    sql.Rollback;

end;

procedure TFormAccountTekBox.BEditClick(Sender: TObject);
var
  Id,L:longint;
begin
  Id:=SQLGrid1.Query.FieldByName('Ident').AsInteger;
  sql.StartTransaction;
  FormAccountTek:=TFormAccountTek.Create(Application) ;
  l:=FormAccounttek.EditRecord(Id);
  FormAccounttek.Free;
  if l<>0 then
  begin
    sql.Commit;
    SQLGrid1.execTable(accounttekvew_str);
    SQLGrid1.LoadPoint('Ident',l);
  end
  else
    sql.Rollback;

end;

procedure TFormAccountTekBox.BDelClick(Sender: TObject);
var
  ident: longint;
  ident_str: string;
  table_str: string;
  other_table_str: string;
  del_thread: TDeleteThread;
begin
  sql.StartTransaction;
  ident:=SQLGrid1.Query.FieldByName('Ident').AsInteger;
  SQLGrid1.saveNextPoint('Ident');
  ident_str := IntToStr(ident);
  if EntrySec.bAllData then
  begin
    table_str:='`AccountTek_all`';
    other_table_str:='`AccountTek`';
  end
  else
  begin
    table_str:='`AccountTek`';
    other_table_str:='`AccountTek_all`';
  end;

  if sql.Delete('`AccountTek`','Ident='+IntToStr(Id))=0 then
  begin
    case Application.MessageBox('Удалить!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
      IDYES:
      begin
        sql.Commit;
        SQLGrid1.ExecTable(accounttekvew_str);
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
  end
  else
  begin
    { application.MessageBox('Счет не может быть удален так как используется в отправках!',
    'Ошибка!',0);   }
    sql.Rollback;
  end;
end;

procedure TFormAccountTekBox.BExitClick(Sender: TObject);
begin
  close;
end;

procedure TFormAccountTEKBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_Return then
    BEditClick(Sender)
end;

end.
