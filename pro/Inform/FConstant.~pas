unit FConstant;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, BMPBtn, ComCtrls, Mask, EditMoney ,tsqlcls,
  Sqlctrls, LblEdtDt,DBTables, Lblint ;

type
  TFormConstant = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditMoney1: TEditMoney;
    EditMoney2: TEditMoney;
    EditMoney3: TEditMoney;
    MaskEdit1: TMaskEdit;
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    UpDate: TLabelEditDate;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LabelInteger1: TLabelInteger;
    LabelInteger2: TLabelInteger;
    LabelInteger3: TLabelInteger;
    Label8: TLabel;
    EditMoney4: TEditMoney;
    Label9: TLabel;
    eMinPayGd: TEditMoney;
    ePlaceTariff: TEditMoney;
    Label10: TLabel;
    Label11: TLabel;
    ePercentTarGd: TLabelInteger;
    GroupBox2: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    ePackTariff: TEditMoney;
    ePercentInsurance: TLabelInteger;
    ePercentSend: TLabelInteger;
    ePercentPack: TLabelInteger;
    EPriceSklad: TEditMoney;
    EPriceDver: TEditMoney;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    EditMoney5: TEditMoney;
    procedure btCanselClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
   function AddRecord:longint;
   function  SumSet(var Sum: string):Boolean;
    { Public declarations }
  end;

var
  FormConstant: TFormConstant;

implementation

{$R *.dfm}

procedure TFormConstant.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;


function TFormConstant.AddRecord:longint;
var q:TQuery;
    str:string;
begin
q:=sql.select('Constant','*','','') ;
if not q.eof then
begin
 if q.FieldByName('UnitVol').asString<>'' then
     MaskEdit1.Text:=q.FieldByName('UnitVol').asString;
 if q.FieldByName('UnitPack').asString<>'' then
     EditMoney1.Text:=q.FieldByName('UnitPack').asString;
 if q.FieldByName('UnitExp').asString<>'' then
     EditMoney2.Text:=q.FieldByName('UnitExp').asString;
 if q.FieldByName('UnitPass').asString<>'' then
     EditMoney3.Text:=q.FieldByName('UnitPass').asString;
 if q.FieldByName('UpDate').asString<>'' then
     UpDate.text:=FormatDateTime('dd.mm.yyyy',StrToDate(q.FieldByName('UpDate').asString))
  else  UpDate.text:=FormatDateTime('dd.mm.yyyy',now);
 if q.FieldByName('PercentWarm').asString<>'' then
     LabelInteger1.Text:=q.FieldByName('PercentWarm').asString;
 if q.FieldByName('PercentOversized').asString<>'' then
     LabelInteger3.Text:=q.FieldByName('PercentOversized').asString;
 if q.FieldByName('PercentFragile').asString<>'' then
     LabelInteger2.Text:=q.FieldByName('PercentFragile').asString;
 if q.FieldByName('MinPay').asString<>'' then
     EditMoney4.Text:=q.FieldByName('MinPay').asString;
  if q.FieldByName('MinPayWarm').asString<>'' then
     EditMoney5.Text:=q.FieldByName('MinPayWarm').asString;
 ePercentTarGd.SetValue(q);
  if q.FieldByName('MinPayGd').asString<>'' then
     eMinPayGd.Text:=q.FieldByName('MinPayGd').asString;
 if q.FieldByName('PlaceTariff').asString<>'' then
     ePlaceTariff.Text:=q.FieldByName('PlaceTariff').asString;
 ePercentSend.SetValue(q);
 ePercentPack.SetValue(q);
 ePercentInsurance.SetValue(q);
  if q.FieldByName('PackTariff').asString<>'' then
     ePackTariff.Text:=q.FieldByName('PackTariff').asString;
  if q.FieldByName('PriceSklad').asString<>'' then
     EPriceSklad.Text:=q.FieldByName('PriceSklad').asString;
  if q.FieldByName('PriceDver').asString<>'' then
     EPriceDver.Text:=q.FieldByName('PriceDver').asString;

end
 else  UpDate.text:=FormatDateTime('dd.mm.yyyy',now);

if ShowModal=mrOk then
begin
 str:='';
if  q.eof then
begin
 if  MaskEdit1.Text<>'' then
     str:=sql.MakeStr(trim(MaskEdit1.Text))
    else str:='NULL';
 if  EditMoney1.Text<>'' then
     str:=str+','+sql.MakeStr(trim(EditMoney1.Text))
    else str:=str+','+'NULL';
 if  EditMoney2.Text<>'' then
     str:=str+','+sql.MakeStr(trim(EditMoney2.Text))
    else str:=str+','+'NULL';
 if  EditMoney3.Text<>'' then
     str:=str+','+sql.MakeStr(trim(EditMoney3.Text ))
    else str:=str+','+'NULL';
 if LabelInteger1.text<>'' then
           str:=str+','+LabelInteger1.text
       else str:=str+',NULL' ;

    if LabelInteger2.text<>'' then
           str:=str+','+LabelInteger2.text
       else str:=str+',NULL' ;

    if LabelInteger3.text<>'' then
           str:=str+','+LabelInteger3.text
       else str:=str+',NULL' ;

     if  EditMoney4.Text<>'' then
            str:=str+', '+sql.MakeStr(trim(EditMoney4.Text))
       else str:=str+', '+'NULL';
     if  EditMoney5.Text<>'' then
            str:=str+', '+sql.MakeStr(trim(EditMoney5.Text))
       else str:=str+', '+'NULL';

 str:=str+','+Sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(UpDate.Text)));

 if  eMinPayGd.Text<>'' then
            str:=str+', '+sql.MakeStr(trim(eMinPayGd.Text))
       else str:=str+', '+'NULL';

     if  ePlaceTariff.Text<>'' then
            str:=str+', '+sql.MakeStr(trim(ePlaceTariff.Text))
       else str:=str+', '+'NULL';

     if  ePercentTarGd.Text<>'' then
            str:=str+', '+sql.MakeStr(trim(ePercentTarGd.Text))
       else str:=str+', '+'NULL';
     if  ePriceSklad.Text<>'' then
            str:=str+', '+sql.MakeStr(trim(ePriceSklad.Text))
       else str:=str+', '+'NULL';
     if  ePriceDver.Text<>'' then
            str:=str+', '+sql.MakeStr(trim(ePriceDver.Text))
       else str:=str+', '+'NULL';
 //-------------------------------
    if  ePercentSend.Text<>'' then
            str:=str+', '+sql.MakeStr(trim(ePercentSend.Text))
       else str:=str+', '+'NULL';
    if  ePercentPack.Text<>'' then
            str:=str+', '+sql.MakeStr(trim(ePercentPack.Text))
       else str:=str+', '+'NULL';
    if  ePercentInsurance.Text<>'' then
            str:=str+', '+sql.MakeStr(trim(ePercentInsurance.Text))
       else str:=str+', '+'NULL';
    if  ePackTariff.Text<>'' then
            str:=str+', '+sql.MakeStr(trim(ePackTariff.Text))
       else str:=str+', '+'NULL';
 //------------------------------

 sql.InsertString('Constant','UnitVol,UnitPack,UnitExp,UnitPass,'+
                  'PercentWarm,PercentFragile,PercentOversized,MinPay,MinPayWarm,'+
                  'UpDate,MinPayGd,PlaceTariff,PercentTarGd,PriceSklad,PriceDver,'+
                  'PercentSend,PercentPack,PercentInsurance,PackTariff',str);
//-----------------------------------------------------------------------------
end else begin
     if  MaskEdit1.Text<>'' then
            str:='UnitVol='+sql.MakeStr(trim(MaskEdit1.Text))
       else str:='UnitVol='+'NULL';
     if  EditMoney1.Text<>'' then
            str:=str+', UnitPack='+sql.MakeStr(trim(EditMoney1.Text))
       else str:=str+', UnitPack='+'NULL';
     if  EditMoney2.Text<>'' then
            str:=str+', UnitExp='+sql.MakeStr(trim(EditMoney2.Text))
       else str:=str+', UnitExp='+'NULL';
     if  EditMoney3.Text<>'' then
            str:=str+', UnitPass='+sql.MakeStr(trim(EditMoney3.Text))
       else str:=str+', UnitPass='+'NULL';

    str:=str+', `UpDate`='+Sql.MakeStr(FormatDateTime('yyyy-mm-dd',now));

    if LabelInteger1.text<>'' then
           str:=str+',PercentWarm='+LabelInteger1.text
       else str:=str+',PercentWarm=NULL' ;

    if LabelInteger2.text<>'' then
           str:=str+',PercentFragile='+LabelInteger2.text
       else str:=str+',PercentFragile=NULL' ;

    if LabelInteger3.text<>'' then
           str:=str+',PercentOversized='+LabelInteger3.text
       else str:=str+',PercentOversized=NULL' ;

     if  EditMoney4.Text<>'' then
            str:=str+', MinPay='+sql.MakeStr(trim(EditMoney4.Text))
       else str:=str+', MinPay='+'NULL';

     if  EditMoney5.Text<>'' then
            str:=str+', MinPayWarm='+sql.MakeStr(trim(EditMoney5.Text))
       else str:=str+', MinPayWarm='+'NULL';

     if  eMinPayGd.Text<>'' then
            str:=str+', MinPayGd='+sql.MakeStr(trim(eMinPayGd.Text))
       else str:=str+', MinPayGd='+'NULL';

     if  ePlaceTariff.Text<>'' then
            str:=str+', PlaceTariff='+sql.MakeStr(trim(ePlaceTariff.Text))
       else str:=str+', PlaceTariff='+'NULL';

     if  ePercentTarGd.Text<>'' then
            str:=str+', PercentTarGd='+sql.MakeStr(trim(ePercentTarGd.Text))
       else str:=str+', PercentTarGd='+'NULL';
     if  ePriceSklad.Text<>'' then
            str:=str+', PriceSklad='+sql.MakeStr(trim(ePriceSklad.Text))
       else str:=str+', PriceSklad='+'NULL';
     if  ePriceDver.Text<>'' then
            str:=str+', PriceDver='+sql.MakeStr(trim(ePriceDver.Text))
       else str:=str+', PriceDver='+'NULL';
//----------------------------------
    if  ePercentSend.Text<>'' then
            str:=str+', PercentSend='+sql.MakeStr(trim(ePercentSend.Text))
       else str:=str+', PercentSend='+'NULL';
    if  ePercentPack.Text<>'' then
            str:=str+', PercentPack='+sql.MakeStr(trim(ePercentPack.Text))
       else str:=str+', PercentPack='+'NULL';
    if  ePercentInsurance.Text<>'' then
            str:=str+', PercentInsurance='+sql.MakeStr(trim(ePercentInsurance.Text))
       else str:=str+', PercentInsurance='+'NULL';
    if  ePackTariff.Text<>'' then
            str:=str+', PackTariff='+sql.MakeStr(trim(ePackTariff.Text))
       else str:=str+', PackTariff='+'NULL';
//----------------------------------

    sql.UpdateString('Constant',str,'');
//----------------------------------------------------------------------------    
    end
end ;
q.Free;
AddRecord:=1;
end;

procedure TFormConstant.btOkClick(Sender: TObject);
var
    varStr:string;
begin
VarStr:=trim(MaskEdit1.text)  ;
if  not SumSet(varStr)then
begin
   Application.MessageBox('Неправильно введено значение!','Ошибка',0);
   MaskEdit1.SetFocus;
   exit;
end else
begin
VarStr:=trim(EditMoney1.text);
if (not SumSet(VarStr))then
begin
   Application.MessageBox('Неправильно введено значение!','Ошибка',0);
   EditMoney1.SetFocus;
   exit;
end else
begin
VarStr:=trim(EditMoney2.text)    ;
if (not SumSet(VarStr))then
begin
   Application.MessageBox('Неправильно введено значение!','Ошибка',0);
   EditMoney2.SetFocus;
   exit;
end else
begin
VarStr:=trim(EditMoney3.text)   ;
if (not SumSet(VarStr))then
begin
   Application.MessageBox('Неправильно введено значение!','Ошибка',0);
   EditMoney3.SetFocus;
   exit;
end else
begin
VarStr:=trim(EditMoney4.text)   ;
if (not SumSet(VarStr))then
begin
   Application.MessageBox('Неправильно введено значение!','Ошибка',0);
   EditMoney4.SetFocus;
   exit;
end else
begin
VarStr:=trim(EditMoney5.text)   ;
if (not SumSet(VarStr))then
begin
   Application.MessageBox('Неправильно введено значение!','Ошибка',0);
   EditMoney5.SetFocus;
   exit;
end else
begin
VarStr:=trim(eMinPayGd.text)   ;
if (not SumSet(VarStr))then
begin
   Application.MessageBox('Неправильно введено значение!','Ошибка',0);
   eMinPayGd.SetFocus;
   exit;
end else
begin
VarStr:=trim(ePlaceTariff.text)   ;
if (not SumSet(VarStr))then
begin
   Application.MessageBox('Неправильно введено значение!','Ошибка',0);
   ePlaceTariff.SetFocus;
   exit;
end else
begin
VarStr:=trim(ePriceSklad.text)   ;
if (not SumSet(VarStr))then
begin
   Application.MessageBox('Неправильно введено значение!','Ошибка',0);
   ePriceSklad.SetFocus;
   exit;
end else
begin
VarStr:=trim(ePriceDver.text)   ;
if (not SumSet(VarStr))then
begin
   Application.MessageBox('Неправильно введено значение!','Ошибка',0);
   ePriceDver.SetFocus;
   exit;
end else
 ModalResult:=mrOk;
end
end
end
end
end
end
end
end
end
end;

function  TFormConstant.SumSet(var Sum: string):Boolean;
Type  Digital = set of char;
var
   dig : Digital;
   len,i : integer;
   test : boolean;
   posit:integer;
begin
  dig:=['1','2','3','4','5','6','7','8','9','0','.'];
  len:=Length(Sum);
  i:=1;
  posit:=pos('.',Sum);
  test:=true;
  {проверяем состав текста}
  while (i<=len) and  test do
  begin
  if not(Sum[i] in dig) then test:=false;
       i:=i+1;
  end;
  {если posit не ноль то смотрим чтобы после точки было не больше 2 знаков}
 if (posit<>0) and test then
 begin
   if posit=1 then test:=false;  {точка не на первом месте}
   if (len-posit)>2 then test:=false;
   if Len=posit  then test:=false;
   if (posit>2) and (Sum[1]='0') then test:=false; {на первом месте ноль а точка не на втором}
 end else if Sum[1]='0' then test:=false;  {точки нет а на первом месте ноль}

      SumSet:=test;
end;


procedure TFormConstant.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOKClick(Sender)
end;

end.
