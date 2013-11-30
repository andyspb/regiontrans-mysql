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
  accounttekvew_view: string;
implementation

uses FAccount, FAccountTek;

{$R *.dfm}

procedure TFormAccountTekBox.FormCreate(Sender: TObject);
begin
//  SQLGrid1.Section:='AccountTEKView' ;
  SQLGrid1.Section:=iff (EntrySec.bAllData, 'AccountTEKView_all','AccountTEKView') ;
  Caption:='Счета-ТЭК ( ' + EntrySec.period + ' )';
  accounttekvew_view:= iff (EntrySec.bAllData, 'AccountTEKView_all', 'AccountTEKView');
  // BAdd.Enabled:=iff (EntrySec.bAllData,  False, True);
  SQLGrid1.ExecTable(accounttekvew_view);
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
    SQLGrid1.execTable(accounttekvew_view);
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
    SQLGrid1.execTable(accounttekvew_view);
    SQLGrid1.LoadPoint('Ident',l);
  end
  else
    sql.Rollback;

end;

procedure TFormAccountTekBox.BDelClick(Sender: TObject);
var
  ident: longint;
  ident_str: string;
  accounttek_table: string;
  accounttek_other_table: string;
  del_thread: TDeleteThread;
begin
  sql.StartTransaction;
  ident:=SQLGrid1.Query.FieldByName('Ident').AsInteger;
  SQLGrid1.saveNextPoint('Ident');
  ident_str := IntToStr(ident);
  accounttek_table:=iff(EntrySec.bAllData, '`AccountTek_all`', '`AccountTek`');
  accounttek_other_table:=iff(EntrySec.bAllData, '`AccountTek`', '`AccountTek_all`');

  if sql.Delete(accounttek_table,'Ident='+IntToStr(Id))=0 then
  begin
    case Application.MessageBox('Удалить!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
      IDYES:
      begin
        sql.Commit;
        SQLGrid1.ExecTable(accounttekvew_view);
        SQLGrid1RowChange(Sender);
        del_thread := TDeleteThread.Create(True, accounttek_other_table, ident_str);
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
