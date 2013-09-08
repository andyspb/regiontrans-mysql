unit ContractCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,tsqlcls, ExtCtrls, Buttons, BMPBtn, ComCtrls,DBTables,
  Sqlctrls, LblEdtDt;

type
  TFormCardContract = class(TForm)
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    eFullName: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit1: TLabelEditDate;
    procedure btCanselClick(Sender: TObject);
    procedure eFullNameChange(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure LabeledEdit1Enter(Sender: TObject);
    procedure LabeledEdit1Exit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
  function AddRecord(j,k:integer):string;
  function EditRecord(j,k:integer):string;
    { Public declarations }
  end;

var
  FormCardContract: TFormCardContract;
  Num:string;
  Date:string;
  TypeCon:string;
  CL:longint;
  CT:longint;

implementation

{$R *.dfm}

function TFormCardContract.AddRecord(j,k:integer):string;
var
str:string;
q:TQuery;
Id1:longint;
begin
Id1:=0;
  CL:=0;
  CT:=0;
  CL:=k;
  CT:=j;
  Num:='';
  Date:=formatDateTime('dd.mm.yyyy',now);
  TypeCon:=sql.selectstring('ContractType','Name','Ident='+IntToStr(j));

  LabeledEdit2.text:=TypeCon;
  LabeledEdit1.text:=Date;
  eFullName.Focused;
 if ShowModal=mrOk then
 begin
 q:=sql.Select('Contract','*','Clients_Ident='+IntToStr(CL)+
               ' and ContractType_Ident='+IntToStr(CT)+
               ' and Finish is NULL','')   ;
 if not q.eof then
   begin
   application.MessageBox('У клиента существует контракт такого типа!','Ошибка!',0);
          q.Free;
          Num:=q.fieldByName('Number').asString;
          Date:=FormatDateTime('dd.mm.yyyy',q.fieldbyname('Start').AsDateTime);
          addRecord:= Num+', '+Date;
          //btCansel.SetFocus;
          exit;
   end;
   q.free;
 Id1:=sql.FindNextInteger('Ident','Contract','',MaxLongint);
 str:=IntToStr(Id1)+','+sql.MakeStr(Num)+','+
      sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Date)))+
      ',NULL,'+IntToStr(j)+','+IntToStr(k);
 sql.execOneSql('Insert into Contract '+
                 '(Ident,Number,Start,Finish,Contracttype_ident,Clients_ident)'+
                 ' values('+Str+'); commit;');
 addRecord:= Num+', '+Date;
 end
 else addRecord:='';
end;


function TFormCardContract.EditRecord(j,k:integer):string;
var
  str:string;
   q:TQuery;
begin
  CL:=0;
  CT:=0;
  CL:=k;
  CT:=j;
   q:=sql.Select('Contract','*','Clients_Ident='+intToStr(k)+' and ContractType_Ident='+
                  IntToStr(j),'');
  Num:=q.fieldByName('Number').asstring;
  Date:=formatDateTime('dd.mm.yyyy',StrToDate(q.fieldByName('Start').asstring));
  TypeCon:=sql.selectstring('ContractType','Name',
           'Ident='+IntToStr(j));

   eFullName.text:=Num;
   LabeledEdit1.text:=Date;
   LabeledEdit2.text:=TypeCon;

   LabeledEdit2.enabled:=false;
   LabeledEdit2.EditLabel.Enabled:=true;
 q.Free;
if ShowModal=mrOk then
begin
str:='Number='+sql.MakeStr(Num)+', `Start`='+
     sql.MakeStr(formatDateTime('yyyy-mm-dd',StrToDate(LabeledEdit1.text)));
sql.execOneSql('Update Contract set '+str+' where Clients_Ident='+
               IntToStr(k)+' and ContractType_Ident='+IntToStr(j) ) ;
EditRecord:= Num+', '+Date;
end
 else EditRecord:= Num+', '+Date;
end;

procedure TFormCardContract.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TFormCardContract.eFullNameChange(Sender: TObject);
begin
Num:=trim(eFullName.Text);
end;

procedure TFormCardContract.LabeledEdit1Change(Sender: TObject);
begin
Date:=LabeledEdit1.Text;
end;

procedure TFormCardContract.btOkClick(Sender: TObject);
var q:TQuery;
begin
if eFullName.text='' then
begin
 Application.MessageBox
      ('Введите номер договора!','Ошибка',0);
     eFullName.focused;
end
else if LabeledEdit1.Text='  .  .    ' then
 begin
    Application.MessageBox
      ('Введите дату заключения договора!','Ошибка',0);
     LabeledEdit1.focused;
 end else begin
          q:=sql.select('Contract','Clients_Ident','Clients_Ident='+InttoStr(Cl)+
                        ' and ContractType_Ident='+IntToStr(CT)+
                        ' and Number='+sql.MakeStr(Num)+
                        ' and  `Start`='+
                        sql.MakeStr(formatDateTime('yyyy-mm-dd',StrToDate(LabeledEdit1.Text))),'');
          if not q.eof then
          begin
          application.MessageBox('Такой контракт уже существует!','Ошибка!',0);
          q.Free;
          btCansel.SetFocus;
          exit;
          end ;
          q.free;
         ModalResult:=mrOk;
         end;
end;

procedure TFormCardContract.LabeledEdit1Enter(Sender: TObject);
begin
Date:=LabeledEdit1.Text;
end;

procedure TFormCardContract.LabeledEdit1Exit(Sender: TObject);
var
    D:string;
begin
try
D:= FormatDateTime('yyyy-mm-dd', StrToDate( LabeledEdit1.Text));
  except
 Application.MessageBox('Неправильно введена дата!',
                     'Ошибка',0);
 LabeledEdit1.text:= Date ;
 LabeledEdit1.Focused;
 exit
 end ;
Date:=LabeledEdit1.Text;
end;

procedure TFormCardContract.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOKClick(Sender)
end;

end.
