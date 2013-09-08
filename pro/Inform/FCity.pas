unit FCity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,tsqlcls, ExtCtrls, Buttons, BMPBtn, ComCtrls,DBTables,
  Sqlctrls, LblEditMoney, DB, Grids, DBGrids, Menus, Lblint, Mask;

type
    TCityForm = class(TForm)
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    eFullName: TLabeledEdit;
    eTariff1: TLblEditMoney;
    eTariff2: TLblEditMoney;
    eTariff3: TLblEditMoney;
    eTariff4: TLblEditMoney;
    eTariff5: TLblEditMoney;
    eSending: TLabeledEdit;
    Query1: TQuery;
    UpdateSQL1: TUpdateSQL;
    Query1City_Ident: TIntegerField;
    Query1Train_Ident: TIntegerField;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Query1Number: TStringField;
    BMPBtn1: TBMPBtn;
    edistance: TLblEditMoney;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    CheckBox1: TCheckBox;
    PopupMenu2: TPopupMenu;
    N4: TMenuItem;
    egdstrah: TLblEditMoney;
    MaskEdit1: TMaskEdit;
    LabelInteger1: TLabelInteger;
    procedure eFullNameChange(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btCanselClick(Sender: TObject);
    procedure BMPBtn1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
  public
  function AddRecord:longint;
  function EditRecord(j:longint):longint;
  function  DaySet(var str: string):Boolean;
    { Public declarations }
  end;

var
  CityForm: TCityForm;
  eName:string;
implementation

uses FTrain;

{$R *.dfm}
 function TCityForm.AddRecord:longint;
 var
    l,i:longInt;
    str:string;
    q:Tquery;
    s:string;
 begin
 eName:='';

 Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select City_Ident,Train_Ident,Number from CityTrain join Train on(Train.Ident=Train_Ident) where City_Ident is NULL and Arch=0');
 Query1.ExecSQL;
 query1.Open;
 DBGrid1.Columns.Items[0].PickList.clear;
 q:=sql.Select('Train','Number','Arch=0','Number');
while not q.Eof do
begin
   s:=q.FieldByName('Number').AsString;
   DBGrid1.Columns.Items[0].PickList.add(s) ;
   q.Next;
end;
q.Free;

 //eFullName.text:=eName;
 if ShowModal=mrOk then
 begin
  l:=sql.FindNextInteger('Ident','City','',MaxLongint);
  str:=IntToStr(l)+', '+sql.Makestr(trim(eName));
  if eTariff1.text='' then
    str:=str+',NULL'
  else
    str:=str+','+Sql.MakeStr(eTariff1.text);
 //----
  if eTariff2.text='' then
    str:=str+',NULL'
  else
    str:=str+','+Sql.MakeStr(eTariff2.text);
 //--
  if eTariff3.text='' then
    str:=str+',NULL'
  else
    str:=str+','+Sql.MakeStr(eTariff3.text);
 //--
  if eTariff4.text='' then
    str:=str+',NULL'
  else
    str:=str+','+Sql.MakeStr(eTariff4.text);
 //--
  if eTariff5.text='' then
    str:=str+',NULL'
  else
    str:=str+','+Sql.MakeStr(eTariff5.text);
 //--
 if eSending.text='' then
    str:=str+',NULL'
  else
    str:=str+','+Sql.MakeStr(trim(eSending.text));
 //--
 if edistance.text='' then
    str:=str+',NULL'
  else str:=str+','+sql.MakeStr(trim(edistance.text));
//----
 if CheckBox1.Checked then
  str:=str+','+IntToStr(1)
  else str:=str+','+IntToStr(0);
//----------
if egdstrah.text='' then
    str:=str+',NULL'
  else str:=str+','+sql.MakeStr(trim(egdstrah.text));
//-----------------
 if LabelInteger1.Text= '' then
 str:=str+',0'
 else str:=str+','+ LabelInteger1.Text;
 //---------------------------------------
 if sql.insertstring('City','Ident,Name,Tariff200,Tariff500,Tariff1000,'+
                   'Tariff2000,TariffMore2000,Sending,Distance,Check,gdstrah,DaysDel',str)<>0
                   then Addrecord:=0
                   else  AddRecord:=l;
 //----
 Query1.DisableControls;
 Query1.First;

  while (not Query1.eof) do
   begin
   if  Query1.FieldByName('Train_Ident').asString='' then
   begin
   Query1.Edit;
   i:=sql.SelectInteger('Train','Ident','Number='+
                         sql.MakeStr(Query1.FieldValues['Number'])) ;
   Query1.FieldValues['Train_Ident']:=I;
   Query1.FieldValues['City_Ident']:=l;
   Query1.Post;
   end;
   Query1.Next;
  end;
  Query1.EnableControls ;
  Query1.ApplyUpdates;
  Query1.CommitUpdates;
 {if sql.Updatestring('CityTrain','City_Ident='+IntToStr(l),'City_Ident is NULL')<>0
   then Addrecord:=0 else AddRecord:=l;  }
 end
 else AddRecord:=0;
 end;

function TCityForm.EditRecord(j:longint):longint;
var Id,i:longint;
    q:TQUery;
    str,s:string;
begin
Id:=j;
q:=sql.Select('City','*','Ident='+IntToStr(Id),'')  ;
eName:=sql.selectstring('City','Name','Ident='+IntToStr(Id)) ;
eFullName.text:=eName;
eTariff1.SetValue(q);
eTariff2.SetValue(q);
eTariff3.SetValue(q);
eTariff4.SetValue(q);
eTariff5.SetValue(q);
eDistance.SetValue(q);
egdstrah.SetValue(q);
LabelInteger1.SetValue(q);
if q.FieldByName('Check').AsInteger = 1 then CheckBox1.Checked:=true
  else CheckBox1.Checked:=false;
eSending.Text:=q.FieldByName('Sending').AsString;
Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select City_Ident,Train_Ident,Number from CityTrain join Train on(Train.Ident=Train_Ident) where City_Ident='+IntToStr(Id)+' and Arch=0');
 Query1.ExecSQL;
 query1.Open;
 DBGrid1.Columns.Items[0].PickList.clear;
 q:=sql.Select('Train','Number','Arch=0','Number');
while not q.Eof do
begin
   s:=q.FieldByName('Number').AsString;
   DBGrid1.Columns.Items[0].PickList.add(s) ;
   q.Next;
end;
q.Free;
if ShowModal=mrOk then
 begin
  //l:=sql.FindNextInteger('Ident','City','',MaxLongint);
 str:='Name='+sql.Makestr(trim(eName));
  if eTariff1.text='' then
    str:=str+',Tariff200=NULL'
  else
    str:=str+',Tariff200='+Sql.MakeStr(eTariff1.text);
 //----
  if eTariff2.text='' then
    str:=str+',Tariff500=NULL'
  else
    str:=str+',Tariff500='+Sql.MakeStr(eTariff2.text);
 //--
  if eTariff3.text='' then
    str:=str+',Tariff1000=NULL'
  else
    str:=str+',Tariff1000='+Sql.MakeStr(eTariff3.text);
 //--
  if eTariff4.text='' then
    str:=str+',Tariff2000=NULL'
  else
    str:=str+',Tariff2000='+Sql.MakeStr(eTariff4.text);
 //--
  if eTariff5.text='' then
    str:=str+',TariffMore2000=NULL'
  else
    str:=str+',TariffMore2000='+Sql.MakeStr(eTariff5.text);
 //--
 if eSending.text='' then
    str:=str+',Sending=NULL'
  else
    str:=str+',Sending='+Sql.MakeStr(trim(eSending.text));
 //------
 if edistance.text='' then
    str:=str+',distance=NULL'
  else str:=str+',distance='+sql.MakeStr(trim(edistance.text));
//----------
 if CheckBox1.Checked then
   str:=str+',`Check`='+IntToStr(1)
   else str:=str+',`Check`='+IntToStr(0);
//-----------
 if egdstrah.text='' then
    str:=str+',gdstrah=NULL'
  else str:=str+',gdstrah='+sql.MakeStr(trim(egdstrah.text));
//----------
if LabelInteger1.text='' then
    str:=str+',DaysDel=0'
  else str:=str+',DaysDel='+LabelInteger1.text;
//-----------------
  if sql.updatestring('City',str ,'Ident='+IntToStr(Id))=0
   then EditRecord:=Id else EditRecord:=0;
//----
 Query1.DisableControls;
 Query1.First;

  while (not Query1.eof) do
   begin
   if  Query1.FieldByName('Train_Ident').asString='' then
   begin
   Query1.Edit;
   i:=sql.SelectInteger('Train','Ident','Number='+
                         sql.MakeStr(Query1.FieldValues['Number'])) ;
   Query1.FieldValues['Train_Ident']:=i;
   Query1.FieldValues['City_Ident']:=Id;
   Query1.Post;
   end;
   Query1.Next;
  end;
  Query1.EnableControls ;
  Query1.ApplyUpdates;
  Query1.CommitUpdates;
{ if sql.Updatestring('CityTrain','City_Ident='+IntToStr(id),'City_Ident is NULL')<>0
   then EditRecord:=0 else EditRecord:=id;  }
 end
 else EditRecord:=0;
end;

procedure TCityForm.eFullNameChange(Sender: TObject);
begin
eName:=trim(eFullName.Text);
end;

procedure TCityForm.btOkClick(Sender: TObject);
var i:longint;
    test:boolean;
    s:string;
begin
//--------------
 test:=true;
 s:='';
 Query1.DisableControls;
 Query1.First;

  while (not Query1.eof)and(test) do
   begin
   if (Query1.FieldByName('Number').asString<>'') then
   begin
   s:=Query1.FieldValues['Number']  ;
   i:=sql.SelectInteger('Train','Ident','Number='+
                         sql.MakeStr(s)) ;

   if i=0 then test:=false;
   end;
   Query1.Next;
  end;
  Query1.EnableControls ;
if (not test) then
begin
   
   ShowMessage
      ('Поезда с номером: '+s+' не существует!');
     DBGrid1.focused;
     exit;
     end ;
//-------------------------

if eFullName.Text='' then
begin
   Application.MessageBox
      ('Введите название города!','Ошибка',0);
     eFullName.focused;
     exit;
     end ;
s:=eSending.Text;
test:=DaySet(s);
 if (not test) then
    begin
   Application.MessageBox
      ('Дни недели введены не правильно!','Ошибка',0);
     eSending.focused;
     exit;
     end else begin

          ModalResult:=mrOk;

                end;
end;

procedure TCityForm.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure TCityForm.BMPBtn1Click(Sender: TObject);
var l:longint;
    q:Tquery;
    s:string;
begin
  FormTrain:=TFormTrain.Create(Application) ;
  l:=FormTrain.EditRecord;
  if l<>0 then
  begin
    DBGrid1.Columns.Items[0].PickList.clear;
    q:=sql.Select('Train','Number','','');
    while not q.Eof do
    begin
     s:=q.FieldByName('Number').AsString;
     DBGrid1.Columns.Items[0].PickList.add(s) ;
     q.Next;
   end;
   q.Free;
  end;
  FormTrain.Free;
end;

function  TCityForm.DaySet(var str: string):Boolean;  
var
   dig : string;
   len : integer;
   test : boolean;
   posit:integer;
   s,sV:string;
label Finish;
begin
test:=true;
dig:=' Пн '+' Вт '+' Ср '+' Чт '+' Пт '+' Сб '+' Вс ';
Len:=Length(trim(str));
sv:=trim(str);

while  (Len>0) and test do
begin
posit:=pos(',',sv);
if posit<>0 then
begin
s:=copy(sv,1,posit-1);
delete(sv,1,posit);
end
else begin
       s:=sv;
       sv:='';
     end;
s:=trim(s);
sv:=trim(sv);
len:=Length(sv);
if (pos(S,dig)<>0)then begin
                       test:=true;
                       goto Finish;
                       exit;
                       end else test:=false;
if (Length(s)=1) then test:=false  ;
end;
finish:
DaySet:=test;
end;

procedure TCityForm.N1Click(Sender: TObject);
begin
Query1.Delete;
end;

procedure TCityForm.N2Click(Sender: TObject);
begin
CityForm.BMPBtn1.setFocus;
end;

procedure TCityForm.N3Click(Sender: TObject);
begin
CityForm.esending.setFocus;
end;

procedure TCityForm.N4Click(Sender: TObject);
begin
if  CheckBox1.Focused and CheckBox1.Checked then
    CheckBox1.Checked:=False
    else if CheckBox1.Focused then CheckBox1.Checked:=true;
end;

procedure TCityForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOkClick(Sender)
end;

end.


