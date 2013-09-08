unit CardBank;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,tsqlcls,Lebtn, Sqlctrls, StdCtrls, ExtCtrls, Buttons, BMPBtn,Filtrnam, ComCtrls;

type
  TFormCardBank = class(TForm)
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    eFullName: TLabeledEdit;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    procedure btCanselClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure eFullNameChange(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit2Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
  function AddRecord:longint;
  function EditRecord(Id:integer):longint;
    { Public declarations }
  end;

var
  FormCardBank: TFormCardBank;
  NameB:string;
  KC:string;
  BIK:string;
  TableName:string;
  DatePr:string;
implementation

{$R *.dfm}
function TFormCardBank.AddRecord:longint;
var
 s:string;
 l:longint;
begin

 BIK:='';
 LabeledEdit2.MaxLength:=9;
 LabeledEdit1.MaxLength:=20;
 eFullName.MaxLength:=80;

  NameB:='';
  KC:='';
  
if ShowModal=mrOk then
begin
l:=sql.FindNextInteger('Ident','Bank','',MaxLongint);
s:=IntToStr(l)+','+sql.MakeStr(NameB)+','+sql.MakeStr(KC)+','+sql.MakeStr(BIK);

if sql.InsertString('Bank','Ident,Name,KorCount,Bik',s)<>0 then
              begin  
              Addrecord:=0;
              end else
                  begin
                   Addrecord:=l;
                  end;

end
else   AddRecord:=0;
end;

function TFormCardBank.EditRecord(Id:integer):longint;
var
   s:string;
begin

 LabeledEdit2.MaxLength:=9;
 LabeledEdit1.MaxLength:=20;
 eFullName.MaxLength:=80;

 eFullName.Text:=sql.selectstring('Bank','Name','Ident='+IntToStr(Id));
 LabeledEdit1.Text:=sql.selectstring('Bank','KorCount','Ident='+IntToStr(Id));
 LabeledEdit2.Text:=sql.selectstring('Bank','BIK','Ident='+IntToStr(Id));

  NameB:=sql.selectstring('Bank','Name','Ident='+IntToStr(Id));
  KC:=sql.selectstring('Bank','KorCount','Ident='+IntToStr(Id));
  BIK:=sql.selectstring('Bank','BIK','Ident='+IntToStr(Id));

if ShowModal=mrOk then
begin

s:='Name='+sql.MakeStr(NameB)+', KorCount='+sql.MakeStr(KC)+', BIK='+sql.MakeStr(BIK);
if sql.ExecOneSql('Update Bank set '+s+' where Ident='+IntToStr(Id)+';')=0 then editRecord:=ID
  else editRecord:=0;

end else editRecord:=ID;

end;

procedure TFormCardBank.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TFormCardBank.btOkClick(Sender: TObject);
begin
 if eFullName.Text='' then
 begin
  Application.MessageBox
      ('Введите  название банка!','Ошибка',0);
      // exit;
     eFullName.focused;

     //SetFocus ;
 end
  else if LabeledEdit1.Text='' then
    begin
      Application.MessageBox
      ('Введите корреспондентский счет банка!','Ошибка',0);
      // exit;
     LabeledEdit1.SetFocus ;
    end
    else if LabeledEdit2.Text='' then
      begin
      Application.MessageBox
      ('Введите  БИК банка!','Ошибка',0);
      // exit;
       LabeledEdit2.SetFocus ;
      end
      else ModalResult:=mrOk;
end;

procedure TFormCardBank.eFullNameChange(Sender: TObject);
begin

  if  Length(eFullName.text)>80 then
 begin
 Application.MessageBox
      ('Название банка не должно превышать 30 символов!','Ошибка',0);
  eFullName.SetFocus ;
 end
  else NameB:=trim(eFullName.text);
end;

procedure TFormCardBank.LabeledEdit1Change(Sender: TObject);
begin
if  Length(LabeledEdit1.text)>20 then
 begin
 Application.MessageBox
      ('Корреспондентский счет банка не должн превышать 20 символов!','Ошибка',0);
  LabeledEdit1.SetFocus ;
 end
  else KC:=trim(LabeledEdit1.text);
end;

procedure TFormCardBank.LabeledEdit2Change(Sender: TObject);
begin
 if  Length(LabeledEdit2.text)>9 then
 begin
 Application.MessageBox
      ('БИК банка не должн превышать 9 символов!','Ошибка',0);
  LabeledEdit2.SetFocus ;
 end
  else BIK:=trim(LabeledEdit2.text);
end;

procedure TFormCardBank.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOKClick(Sender)
end;

end.
