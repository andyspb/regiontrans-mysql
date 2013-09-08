unit fAccountB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlGrid,Tadjform,tsqlcls,  StdCtrls, Buttons, BMPBtn;

type
  TFormAccountBox = class(TAdjustForm)
    BAdd: TBMPBtn;
    BEdit: TBMPBtn;
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
  FormAccountBox: TFormAccountBox;

implementation

uses FAccount;

{$R *.dfm}

procedure TFormAccountBox.FormCreate(Sender: TObject);
begin
SQLGrid1.Section:='Account' ;
SQLGrid1.ExecTable('AccountView');
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
fsection:='FAccount' ;
end;

procedure TFormAccountBox.SQLGrid1RowChange(Sender: TObject);
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

procedure TFormAccountBox.BAddClick(Sender: TObject);
var l:longint;
begin
sql.StartTransaction;
FormAccount:=TFormAccount.Create(Application) ;
l:=FormAccount.AddRecord;
FormAccount.Free;
if l<>0 then
begin
sql.Commit;
SQLGrid1.execTable('AccountView');
SQLGrid1.LoadPoint('Ident',l);
end else sql.Rollback;

end;

procedure TFormAccountBox.BEditClick(Sender: TObject);
var Id,L:longint;
begin
Id:=SQLGrid1.Query.FieldByName('Ident').AsInteger;
sql.StartTransaction;
FormAccount:=TFormAccount.Create(Application) ;
l:=FormAccount.EditRecord(Id);
FormAccount.Free;
if l<>0 then
begin
sql.Commit;
SQLGrid1.execTable('AccountView');
SQLGrid1.LoadPoint('Ident',l);
end else sql.Rollback;

end;

procedure TFormAccountBox.BDelClick(Sender: TObject);
var Id:longint;
begin
sql.StartTransaction;
Id:=SQLGrid1.Query.FieldByName('Ident').AsInteger;
SQLGrid1.saveNextPoint('Ident');
if sql.Delete('`Account`','Ident='+IntToStr(Id))=0 then
begin
case Application.MessageBox('Удалить!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
sql.Commit;
SQLGrid1.ExecTable('AccountView');
SQLGrid1RowChange(Sender);
    end;
     IDNO:
      begin
      sql.rollback;
      exit
      end;
end;
end else begin
        { application.MessageBox('Счет не может быть удален так как используется в отправках!',
                       'Ошибка!',0);   }
         sql.Rollback;
         end;
end;

procedure TFormAccountBox.BExitClick(Sender: TObject);
begin
close;
end;

procedure TFormAccountBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then BEditClick(Sender)
end;

end.
