unit FFerryman;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Sqlctrls, Lbsqlcmb, StdCtrls, ExtCtrls, Buttons, BMPBtn,
  ComCtrls,tsqlcls,Lebtn , SqlGrid, DB,DBTables;

type
  TFormFerryman = class(TForm)
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    LabeledEdit1: TLabeledEdit;
    eFullName: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit9: TLabeledEdit;
    LabelSQLComboBox4: TLabelSQLComboBox;
    LabeledEdit15: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    procedure btCanselClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
  public
    { Public declarations }
      function AddRecord:longint;    
      function EditRecord(l:longint):longint;
  end;

var
  FormFerryman: TFormFerryman;
  Id:longint;

implementation

{$R *.dfm}

function TFormFerryman.AddRecord:longint;
var
s:string;
I:longint;
begin
LabelSQLComboBox4.Lbl.Font.Size:=10;

 if ShowModal=mrOk then
begin
I:=sql.FindNextInteger('Ident','FerryMan','',MaxLongint);
s:=IntToStr(I);
s:=s+','+Sql.MakeStr(trim(LabeledEdit1.text))+','+
    Sql.MakeStr(trim(eFullName.text));
 if LabeledEdit4.text<>'' then
   s:=s+','+sql.MakeStr(trim(LabeledEdit4.text))
    else s:=s+',NULL';
 if LabeledEdit6.Text<>'' then
  s:=s+','+sql.MakeStr(trim(LabeledEdit6.Text))
   else s:=s+',NULL';
 if LabeledEdit9.Text<>'' then
 s:=s+','+sql.MakeStr(trim(LabeledEdit9.Text))
   else s:=s+',NULL';
 if LabeledEdit15.Text<>'' then
 s:=s+','+sql.MakeStr(trim(LabeledEdit15.Text))
   else s:=s+',NULL';
 if LabeledEdit2.text<>''  then
 s:=s+','+sql.MakeStr(trim(LabeledEdit2.Text))
   else s:=s+',NULL';
 if LabeledEdit5.Text<>'' then
 s:=s+','+sql.MakeStr(trim(LabeledEdit5.Text))
   else s:=s+',NULL';
 if LabeledEdit3.text<>'' then
 s:=s+','+sql.MakeStr(trim(LabeledEdit3.text))
   else s:=s+',NULL';
 if LabeledEdit7.text<>'' then
 s:=s+','+sql.MakeStr(trim(LabeledEdit7.text))
   else s:=s+',NULL';
 if LabeledEdit8.Text<>'' then
 s:=s+','+sql.MakeStr(trim(LabeledEdit8.Text))
   else s:=s+',NULL';
 if LabelSQLComboBox4.GetData<>0 then
 s:=s+','+IntToStr(LabelSQLComboBox4.GetData)
   else s:=s+',NULL';
 if sql.InsertString('FerryMan','Ident,Acronym,Name,Address,Phone,CalculateCount,Driver,'+
                  'DrivingLicence,Car,CarNumber,Licence,LicenceSeries,Bank_Ident',
                  s)<>0
                  then begin
                     Addrecord:=0 ;
                         exit;
 end   else Addrecord:=1 ;

end else Addrecord:=0 ;
end;

function TFormFerryman.EditRecord(l:longint):longint;
var
s:string;
q:TQuery;

begin
Id:=l;
q:=sql.Select('FerryMan','','Ident='+IntToStr(Id),'');
if q.FieldByName('Acronym').asstring<>'' then
LabeledEdit1.text:=q.FieldByName('Acronym').asstring;
if q.FieldByName('Name').asstring<>'' then
eFullName.text:= q.FieldByName('Name').asstring;
if q.FieldByName('Address').asstring<>'' then
LabeledEdit4.text:=q.FieldByName('Address').asstring;
if q.FieldByName('Phone').asstring<>'' then
LabeledEdit6.text:= q.FieldByName('Phone').asstring;
if q.FieldByName('CalculateCount').asstring<>'' then
LabeledEdit9.text:=q.FieldByName('CalculateCount').asstring;
if q.FieldByName('Bank_Ident').asstring<>'' then
LabelSQLComboBox4.SQLComboBox.setActive(q.FieldByName('Bank_Ident').asInteger);
if q.FieldByName('Driver').asstring<>'' then
LabeledEdit15.text:= q.FieldByName('Driver').asstring;
if q.FieldByName('DrivingLicence').asstring<>'' then
LabeledEdit2.text:=q.FieldByName('DrivingLicence').asstring;
if q.FieldByName('Car').asstring<>'' then
LabeledEdit5.text:=q.FieldByName('Car').asstring ;
if q.FieldByName('CarNumber').asstring<>'' then
LabeledEdit3.text:= q.FieldByName('CarNumber').asstring;
if q.FieldByName('Licence').asstring<>'' then
LabeledEdit7.text:=q.FieldByName('Licence').asstring;
if q.FieldByName('LicenceSeries').asstring<>'' then
LabeledEdit8.text:=q.FieldByName('LicenceSeries').asstring;

if ShowModal=mrOk then
begin
s:='';
s:='Acronym='+Sql.MakeStr(trim(LabeledEdit1.text))+',Name='+
    Sql.MakeStr(trim(eFullName.text));
 if LabeledEdit4.text<>'' then
   s:=s+',Address='+sql.MakeStr(trim(LabeledEdit4.text))
    else s:=s+',Address=NULL';
 if LabeledEdit6.Text<>'' then
  s:=s+',Phone='+sql.MakeStr(trim(LabeledEdit6.Text))
   else s:=s+',Phone=NULL';
 if LabeledEdit9.Text<>'' then
 s:=s+',CalculateCount='+sql.MakeStr(trim(LabeledEdit9.Text))
   else s:=s+',CalculateCount=NULL';
 if LabeledEdit15.Text<>'' then
 s:=s+',Driver='+sql.MakeStr(trim(LabeledEdit15.Text))
   else s:=s+',Driver=NULL';
 if LabeledEdit2.text<>''  then
 s:=s+',DrivingLicence='+sql.MakeStr(trim(LabeledEdit2.Text))
   else s:=s+',DrivingLicence=NULL';
 if LabeledEdit5.Text<>'' then
 s:=s+',Car='+sql.MakeStr(trim(LabeledEdit5.Text))
   else s:=s+',Car=NULL';
 if LabeledEdit3.text<>'' then
 s:=s+',CarNumber='+sql.MakeStr(trim(LabeledEdit3.text))
   else s:=s+',CarNumber=NULL';
 if LabeledEdit7.text<>'' then
 s:=s+',Licence='+sql.MakeStr(trim(LabeledEdit7.text))
   else s:=s+',Licence=NULL';
 if LabeledEdit8.Text<>'' then
 s:=s+',LicenceSeries='+sql.MakeStr(trim(LabeledEdit8.Text))
   else s:=s+',LicenceSeries=NULL';
 if LabelSQLComboBox4.GetData<>0 then
 s:=s+',Bank_Ident='+IntToStr(LabelSQLComboBox4.GetData)
   else s:=s+',Bank_Ident=NULL';
 if sql.UpdateString('FerryMan',s,'Ident='+IntToStr(Id))<>0
                  then begin
                     Editrecord:=0 ;
                         exit;

 end else Editrecord:=1 ;
 end else Editrecord:=0 ;

end;

procedure TFormFerryman.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;    
end;

procedure TFormFerryman.btOkClick(Sender: TObject);
begin
if LabeledEdit1.text='' then
begin
      Application.MessageBox
      ('Введите укороченное название перевозчика!','Ошибка',0);
     LabeledEdit1.SetFocus ;
     exit;
end;
if eFullName.text='' then
begin
      Application.MessageBox
      ('Введите полное название перевозчика!','Ошибка',0);
     eFullName.SetFocus ;
     exit;
end;
if sql.SelectString('FerryMan','Ident','Acronym='+sql.MakeStr(trim(LabeledEdit1.text))+
                     ' and Ident not in ('+IntToStr(Id)+')')<>'' then
begin
      Application.MessageBox
      ('Перевозчик с таким именем уже существует!','Ошибка',0);
     LabeledEdit1.SetFocus ;
     exit;
end else  ModalResult:=mrOk;
end;


procedure TFormFerryman.LabeledEdit1Change(Sender: TObject);
begin
if eFullName.text='' then
eFullName.Text:=LabeledEdit1.Text;
end;

procedure TFormFerryman.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOkClick(Sender)
end;

end.
