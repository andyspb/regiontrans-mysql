unit CardBoss;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Sqlctrls, StdCtrls, ExtCtrls, Buttons, BMPBtn,
  ComCtrls,tsqlcls,Lbsqlcmb,Lebtn , SqlGrid, DB,DBTables;

type
  TFCardBoss = class(TForm)
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    LabeledEdit1: TLabeledEdit;
    eFullName: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabelSQLComboBox1: TLabelSQLComboBox;
    LabelSQLComboBox2: TLabelSQLComboBox;
    LabeledEdit15: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    LabeledEdit9: TLabeledEdit;
    LabeledEdit10: TLabeledEdit;
    LabeledEdit11: TLabeledEdit;
    LabelSQLComboBox4: TLabelSQLComboBox;
    LabeledEdit13: TLabeledEdit;
    LabeledEdit14: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit18: TLabeledEdit;
    procedure btCanselClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LabeledEdit18Exit(Sender: TObject);
  private
    { Private declarations }
  public
  function EditRecord:integer;
    { Public declarations }
  end;

var
  FCardBoss: TFCardBoss;

implementation

{$R *.dfm}
 function TFCardBoss.EditRecord:integer;
 var
   q:TQuery;
   UpD,str:string;
 begin
 q:=sql.select('Boss','*','Ident=1','');
 //mysql
// q.Close;
// q.DatabaseName:=sql.DataBaseName;
 //q.SQL.Clear;
// q.SQL.Add('svdb.select * from Boss where Ident=1');
// q.ExecSQL;
// q.Open;
 //mysql
 eFullName.text:=q.fieldbyName('Name').asString;
 labeledEdit1.text:=q.fieldbyName('Acronym').asString;
 labeledEdit2.text:=q.fieldbyName('PersonBug').asString;
 labeledEdit10.text:=q.fieldbyName('OKONX').asString;
 labeledEdit11.text:=q.fieldbyName('OKPO').asString;
 labeledEdit13.text:=FormatDateTime('dd.mm.yyyy',StrToDate(q.fieldbyName('StartFix').asString));
 labeledEdit14.text:=FormatDateTime('dd.mm.yyyy',now);
 labeledEdit15.text:=q.fieldbyName('Person').asString;
 labeledEdit4.text:=q.fieldbyName('UrAddress').asString;
 labeledEdit5.text:=q.fieldbyName('Fax').asString;
 labeledEdit6.text:=q.fieldbyName('Telephone').asString;
 labeledEdit7.text:=q.fieldbyName('Email').asString;
 labeledEdit8.text:=q.fieldbyName('INN').asString;
 LabeledEdit18.text:=q.fieldbyName('KPP').asString;
 labeledEdit9.text:=q.fieldbyName('CalculateCount').asString;
 labeledEdit3.text:=q.fieldbyName('OKUD').asString;

 LabeledEdit13.Enabled:=False;
 LabeledEdit14.Enabled:=False;
 LabeledEdit14.EditLabel.Enabled:=true;
 LabeledEdit13.EditLabel.Enabled:=true;

 LabelSQLComboBox1.Lbl.Font.Size:=10;
 LabelSQLComboBox2.Lbl.Font.Size:=10;
 LabelSQLComboBox4.Lbl.Font.Size:=10;

 LabelSQLComboBox1.SQLComboBox.Font.Size:=10;
 LabelSQLComboBox2.SQLComboBox.Font.Size:=10;
 LabelSQLComboBox4.SQLComboBox.Font.Size:=10;
  if q.fieldbyName('Country_Ident').asString<>'' then
  LabelSQLComboBox2.setActive(q.fieldbyName('Country_Ident').asInteger);
  if q.fieldbyName('City_Ident').asString<>'' then
  LabelSQLComboBox1.setActive(q.fieldbyName('City_Ident').asInteger);
  if  q.fieldbyName('Bank_Ident').asString<>'' then
  LabelSQLComboBox4.setActive(q.fieldbyName('Bank_Ident').asInteger);

if ShowModal=mrOk then
begin
 UpD:=FormatDateTime('yyyy-mm-dd',now);
 str:='UDAte='+sql.MakeStr(UpD);
 if eFullName.text<>'' then
    str:=str+', Name='+sql.Makestr(eFullName.text)
    else str:=str+', Name='+'NULL';
 if LabeledEdit1.text<>'' then
     str:=str+', Acronym='+sql.Makestr(LabeledEdit1.text)
     else str:=str+', Acronym='+'NULL';
 if LabeledEdit10.text<>'' then
     str:=str+', OKONX='+sql.Makestr(LabeledEdit10.text)
     else str:=str+', OKONX='+'NULL';
 if LabeledEdit11.text<>'' then
     str:=str+', OKPO='+sql.Makestr(LabeledEdit11.text)
     else str:=str+', OKPO='+'NULL';
 if LabeledEdit3.text<>'' then
     str:=str+', OKUD='+sql.Makestr(LabeledEdit3.text)
     else str:=str+', OKUD='+'NULL';
 if LabeledEdit15.text<>'' then
     str:=str+', Person='+sql.Makestr(LabeledEdit15.text)
     else str:=str+', Person='+'NULL';
 if LabeledEdit2.text<>'' then
     str:=str+', PersonBug='+sql.Makestr(LabeledEdit2.text)
     else str:=str+', PersonBug='+'NULL';
 if LabeledEdit4.text<>'' then
     str:=str+', UrAddress='+sql.Makestr(LabeledEdit4.text)
     else str:=str+', UrAddress='+'NULL';
 if LabeledEdit5.text<>'' then
     str:=str+', Fax='+sql.Makestr(LabeledEdit5.text)
     else str:=str+', Fax='+'NULL';
 if LabeledEdit6.text<>'' then
      str:=str+', Telephone='+sql.Makestr(LabeledEdit6.text)
      else str:=str+', Telephone='+'NULL';
 if LabeledEdit7.text<>'' then
      str:=str+', Email='+sql.Makestr(LabeledEdit7.text)
      else str:=str+', Email='+'NULL';
 if LabeledEdit8.text<>'' then
      str:=str+', INN='+sql.Makestr(LabeledEdit8.text)
      else str:=str+', INN='+'NULL';
 if LabeledEdit18.text<>'' then
     str:=str+', KPP='+sql.Makestr(LabeledEdit18.text)
     else str:=str+', KPP='+'NULL';
 if LabeledEdit9.text<>'' then
      str:=str+', CalculateCount='+sql.Makestr(LabeledEdit9.text)
      else str:=str+', CalculateCount='+'NULL';
 if LabelSQLComboBox1.getData<>0 then
      str:=str+', City_Ident='+IntToStr(LabelSQLComboBox1.getData)
      else str:=str+', City_Ident='+'NULL';
 if LabelSQLComboBox2.getData<>0 then
      str:=str+', Country_Ident='+IntToStr(LabelSQLComboBox2.getData)
      else str:=str+', Country_Ident='+'NULL';
 if LabelSQLComboBox4.getData<>0 then
      str:=str+', Bank_Ident='+IntToStr(LabelSQLComboBox4.getData)
      else str:=str+', Bank_Ident='+'NULL';

 sql.UpdateString('BOSS',str ,'Ident=1')

end;
EditRecord:=1;
 end;
procedure TFCardBoss.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TFCardBoss.btOkClick(Sender: TObject);
begin
 ModalResult:=mrOk;
end;

procedure TFCardBoss.LabeledEdit1Change(Sender: TObject);
begin
eFullName.Text:=LabeledEdit1.text  ;
end;

procedure TFCardBoss.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOkClick(Sender)
end;

procedure TFCardBoss.LabeledEdit18Exit(Sender: TObject);
begin
if   LabeledEdit18.Text<>'' then
LabeledEdit18.text:=trim(LabeledEdit18.Text);
end;

end.
