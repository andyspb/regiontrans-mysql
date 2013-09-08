unit Cardcountry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,tsqlcls, BMPBtn, ComCtrls;

type
  TFormCountry = class(TForm)
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    eFullName: TLabeledEdit;
    procedure btCanselClick(Sender: TObject);
    procedure eFullNameChange(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
  function AddRecord:longint;
  function EditRecord(j:longint):longint;
    { Public declarations }
  end;

var
  FormCountry: TFormCountry;
  eName:string;
implementation

{$R *.dfm}
function TFormCountry.AddRecord:longint;
 var
    l:longInt;
 begin
 eName:='';
 //eFullName.text:=eName;
 if ShowModal=mrOk then
 begin
  l:=sql.FindNextInteger('Ident','Country','',MaxLongint);
  sql.insertstring('Country','Ident,Name',intToStr(l)+', '+sql.Makestr(eName));
  AddRecord:=l;
 end
 else AddRecord:=0;
 end;

function TFormCountry.EditRecord(j:longint):longint;
var Id:longint;
begin
Id:=j;
eName:=sql.selectstring('Country','Name','Ident='+IntToStr(Id)) ;
eFullName.text:=eName;
if ShowModal=mrOk then
 begin
  //l:=sql.FindNextInteger('Ident','City','',MaxLongint);
 if sql.updatestring('Country','Name='+sql.Makestr(eName),'Ident='+IntToStr(Id))=0
   then sql.Commit else sql.Rollback;
  EditRecord:=Id;
 end
 else EditRecord:=Id;
end;

procedure TFormCountry.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TFormCountry.eFullNameChange(Sender: TObject);
begin
eName:=eFullName.Text;
end;

procedure TFormCountry.btOkClick(Sender: TObject);
begin
if eFullName.Text='' then
begin
   Application.MessageBox
      ('Введите название страны!','Ошибка',0);
     eFullName.focused;
     end
      else ModalResult:=mrOk;
end;

procedure TFormCountry.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOKClick(Sender)
end;

end.
