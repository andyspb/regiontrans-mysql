unit FAEInsp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,tsqlcls, StdCtrls,DBTables, Buttons, BMPBtn, ComCtrls, Lbledit, Sqlctrls, Lbsqlcmb;

type
  TFormAEInsp = class(TForm)
    LabelSQLComboBox1: TLabelSQLComboBox;
    LabelEdit1: TLabelEdit;
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    LabelEdit2: TLabelEdit;
    LabelEdit3: TLabelEdit;
    procedure btCanselClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
   function AddRecord:longint;
   function EditRecord(l:integer):longint;
  end;

var
  FormAEInsp: TFormAEInsp;
   id:longint;
   str:string;
   strValue:string;
   AddEdit:boolean;
implementation

{$R *.dfm}
function TFormAEInsp.AddRecord:longint;
begin
id:=0;
AddEdit:=true;
if ShowModal=mrOk then
begin
if sql.Insertstring('Inspector','Ident,PeopleFIO,ShortName,Password,Roles_Ident',str)<>0
then begin
       addrecord:=0;
       exit;
     end
     else addrecord:=id;
end else addrecord:=0;
end;

function TFormAEInsp.EditRecord(l:integer):longint;
var q:TQuery;

begin
AddEdit:=false;
id:=l;
q:=sql.select('InspectorRoles','','Ident='+IntToStr(ID),'');
LabelEdit1.setValue(q);
LabelEdit2.setValue(q);
LabelEdit3.setValue(q);
LabelSQLComboBox1.setValue(q);
if ShowModal=mrOk then
begin
if sql.Updatestring('Inspector',strValue,'Ident='+IntToStr(ID))<>0
then begin
       editrecord:=0;
       exit;
     end
     else editrecord:=id;
end else editrecord:=id;
 q.free;
end;

procedure TFormAEInsp.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TFormAEInsp.btOkClick(Sender: TObject);
var q:TQUERY;
    Val:string;
begin
 if LabelEdit1.Text='' then
 begin
  Application.MessageBox
      ('Введите ФИО оператора!','Ошибка',0);
     LabelEdit1.focused;
 end
  else if LabelEdit2.Text='' then
    begin
      Application.MessageBox
      ('Введите имя оператора!','Ошибка',0);
     LabelEdit2.SetFocus ;
    end
    else if LabelEdit3.Text='' then
      begin
      Application.MessageBox
      ('Введите  пароль оператора!','Ошибка',0);
       LabelEdit3.SetFocus ;
      end
      else if  LabelSQLComboBox1.GetData=0 then
      begin
       Application.MessageBox
      ('Выберите  роль оператора!','Ошибка',0);
      LabelSQLComboBox1.SetFocus;
      end
      else begin
       LabelEdit1.Text:=trim(LabelEdit1.Text);
       LabelEdit2.Text:=trim(LabelEdit2.Text);
       LabelEdit3.Text:=trim(LabelEdit3.Text);
       if id=0 then
              id:=sql.FindNextInteger('Ident','Inspector','',MaxLongint);
       str:=IntToStr(ID)+','+Sql.MakeStr(LabelEdit1.Text)+','+
            Sql.MakeStr(LabelEdit2.Text)+','+Sql.MakeStr(LabelEdit3.Text)+
            ','+IntToStr(LabelSQLComboBox1.GetData);
       strValue:='Ident='+IntToStr(ID)+',PeopleFIO='+Sql.MakeStr(LabelEdit1.Text)+
                 ',ShortName='+ Sql.MakeStr(LabelEdit2.Text)+
                 ',Password='+Sql.MakeStr(LabelEdit3.Text)+
                 ',Roles_Ident='+IntToStr(LabelSQLComboBox1.GetData);

      Val:='ShortName='+ Sql.MakeStr(LabelEdit2.Text)+
                 ' and Password='+Sql.MakeStr(LabelEdit3.Text);

     if AddEdit then q:=sql.select('Inspector','Ident',Val,'')
     else q:=sql.select('Inspector','Ident',Val,'');

      if q.eof then
      ModalResult:=mrOk
        else begin
              Application.MessageBox
              ('Оператор с таким паролем и именем уже существует!','Ошибка',0);
               LabelEdit2.SetFocus;
               exit;
             end;
      end;
end;

procedure TFormAEInsp.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOKClick(Sender)
end;

end.
