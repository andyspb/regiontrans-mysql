unit FormAcceptoru;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Sqlctrls, Lbsqlcmb, StdCtrls, ExtCtrls, Buttons, BMPBtn,
  ComCtrls,TSQLCLS,Lebtn, Filtrnam,DB, DBTables,SqlGrid;


type
  TFormAcceptor = class(TForm)
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    eName: TLabeledEdit;
    eAddress: TLabeledEdit;
    eRegime: TLabeledEdit;
    ePhone: TLabeledEdit;
    cbCity: TLabelSQLComboBox;
    BitBtn2: TBitBtn;
    eComent: TLabeledEdit;
    procedure btCanselClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    function AddRecord:longint;
    function EditRecord(Id:integer):longint;
  end;

var
  FormAcceptor: TFormAcceptor;

implementation

uses FAddEdit, FCity;

{$R *.dfm}
function TFormAcceptor.AddRecord:longint;
var  l:longint;
     insStr:string;
     q:TQuery;
begin

if ShowModal=mrOk then
begin
   q:=sql.select('Acceptor','','City_Ident='+IntToStr(CbCity.getData)+
                 ' and Name='+sql.MakeStr(trim(eName.Text)),'');
   if not q.eof then
   begin
   application.MessageBox('Получатель с таким именем в данном городе уже существует!','Ошибка!',0);
   addrecord:=0;
   q.Free;
   exit
   end;
     l:=sql.FindNextInteger('Ident','Acceptor','',MaxLongint);
     insStr:=IntToStr(l);
     if  CbCity.getData=0 then insStr:=InsStr+',NULL'
      else insStr:=InsStr+','+IntToStr(CbCity.getData) ;
     if eAddress.Text='' then  insStr:=InsStr+',NULL'
      else insStr:=InsStr+','+sql.MakeStr(trim(eAddress.text));
     if eName.text='' then insStr:=InsStr+',NULL'
      else insStr:=InsStr+','+sql.MakeStr(trim(eName.Text));
     if ePhone.Text='' then insStr:=InsStr+',NULL'
      else insStr:=InsStr+','+sql.MakeStr(trim(ePhone.Text));
     if eRegime.Text='' then insStr:=InsStr+',NULL'
      else insStr:=InsStr+','+sql.MakeStr(trim(eRegime.Text));
     if eComent.Text='' then insStr:=InsStr+',NULL'
      else insStr:=InsStr+','+sql.MakeStr(trim(eComent.Text));
 if sql.Insertstring('Acceptor','Ident,City_Ident,Address,Name,'+
               'Phone,Regime,Coment',InsStr)<>0 then
 begin

   addrecord:=0;

 end else
      begin
      
      addrecord:=l;
      end;

end else addrecord:=0;
end;

function TFormAcceptor.EditRecord(Id:longInt):longint;
var
   q:TQuery;
   insStr:string;
   l:longint;
begin
   l:=Id;
  q:=sql.select('Acceptor','*','Ident='+IntToStr(Id),'');
   cbCity.SQLComboBox.SetActive(q.FieldByName('City_Ident').asInteger);
   eAddress.Text:=q.fieldByName('Address').asString;
   eName.Text:=q.fieldByName('Name').asString;
   ePhone.Text:=q.fieldByName('Phone').asString;
   eRegime.Text:=q.fieldByName('Regime').asString;
   eComent.Text:=q.fieldByName('Coment').asString;
 if ShowModal=mrOk then
 begin
 //sql.Delete('Acceptor','Ident='+IntToStr(Id));

   //  l:=sql.FindNextInteger('Ident','Acceptor','',MaxLongint);


     if  CbCity.getData=0 then insStr:='City_Ident=NULL'
      else insStr:='City_Ident='+IntToStr(CbCity.getData) ;
     if eAddress.Text='' then  insStr:=InsStr+',Address=NULL'
      else insStr:=InsStr+',Address='+sql.MakeStr(trim(eAddress.text));
     if eName.text='' then insStr:=InsStr+',Name=NULL'
      else insStr:=InsStr+',Name='+sql.MakeStr(trim(eName.Text));
     if ePhone.Text='' then insStr:=InsStr+',Phone=NULL'
      else insStr:=InsStr+',Phone='+sql.MakeStr(trim(ePhone.Text));
     if eRegime.Text='' then insStr:=InsStr+',Regime=NULL'
      else insStr:=InsStr+',Regime='+sql.MakeStr(trim(eRegime.Text));
     if eComent.Text='' then insStr:=InsStr+',Coment=NULL'
      else insStr:=InsStr+',Coment='+sql.MakeStr(trim(eComent.Text));
 if sql.updatestring('Acceptor',InsStr,'Ident='+
                     IntToStr(l))<>0 then
 begin

   Editrecord:=0;

 end else
     begin

      Editrecord:=l;
     end;
 end else EditRecord:=Id;

end;

procedure TFormAcceptor.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TFormAcceptor.btOkClick(Sender: TObject);
begin
if eName.Text='' then
begin
      Application.MessageBox
      ('Введите  название получателя!','Ошибка',0);
     eName.focused;
     exit;
end else if cbCity.SQLComboBox.Text='' then
  begin
      Application.MessageBox
      ('Введите  город получателя!','Ошибка',0);
     cbCity.SQLComboBox.SetFocus;
     exit;
  end else  ModalResult:=mrOk;
end;

procedure TFormAcceptor.BitBtn2Click(Sender: TObject);
var l:longint;
begin
  CityForm:=TCityForm.Create(Application) ;
  l:=CityForm.AddRecord;
  if l<>0 then
    begin
    cbCity.SQLComboBox.Recalc;
    cbCity.SQLComboBox.SetActive(l);
    end    ;

  CityForm.Free   ;

end;

procedure TFormAcceptor.FormCreate(Sender: TObject);
begin
//cbCity.SQLComboBox.Sorted:=true;
end;

procedure TFormAcceptor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOkClick(Sender)
end;

end.
