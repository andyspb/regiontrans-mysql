unit EntrySec;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Tadjform, StdCtrls, Sqlctrls, Lbledit, ExtCtrls, Buttons, BMPBtn,tsqlcls,
  DB,DBTables,SEQUENCE;

type
  TEntrySecurity = class(Tadjustform)
    Bevel1: TBevel;
    eShortName: TLabelEdit;
    ePassword: TEdit;
    Label1: TLabel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EntrySecurity: TEntrySecurity;

implementation

uses    Menu;

{$R *.DFM}

procedure TEntrySecurity.btOKClick(Sender: TObject);
var q:TQuery;
str:string;
begin
  str:='(ShortName='''+eShortName.text +''') and (Password='''+ePassword.text+''')';
  q:=sql.select('Inspector','Ident,Roles_Ident',str ,  '' );
  if q.eof then
    begin
    Application.MessageBox('Неправильное имя или пароль!','Ошибка',0);
    eShortName.setfocus;
    exit;
    end;
   FMenu.CurrentUser:=q.FieldByName('Ident').AsInteger;
   FMenu.CurrentUserRoles:=q.FieldByName('Roles_Ident').AsInteger;
   FMenu.CurrentUserName:=eShortName.text;

   ModalResult:=mrOK;



end;

procedure TEntrySecurity.btCancelClick(Sender: TObject);
begin
  ModalResult:= mrCancel
end;




procedure TEntrySecurity.FormCreate(Sender: TObject);
begin
eShortName.Edit.Font.Size:=10;
ePassword.Font.Size:=10;

fsection:='EntrySecuritySect';
end;

procedure TEntrySecurity.FormActivate(Sender: TObject);
begin
   if FMenu.CurrentUser<>0
    then
      begin
        btCancel.Caption:='Отменить';
        eShortName.Edit.SetFocus;          //btOk.setfocus;
      end;
end;

procedure TEntrySecurity.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key = VK_Return
  then btOKClick(Sender)
end;

end.
