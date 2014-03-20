unit ClientCardu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,tsqlcls,Lebtn, Sqlctrls, Lbsqlcmb, StdCtrls, ExtCtrls, Buttons, BMPBtn,
  ComCtrls,DBTables, Lbledit, Lblint;

type
    Tcard = class(TForm)
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btCansel: TBMPBtn;
    eFullName: TLabeledEdit;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    eCountry: TLabelSQLComboBox;
    LabelSQLComboBox1: TLabelSQLComboBox;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    LabeledEdit9: TLabeledEdit;
    LabeledEdit10: TLabeledEdit;
    LabeledEdit11: TLabeledEdit;
    LabelSQLComboBox2: TLabelSQLComboBox;
    LabeledEdit12: TLabeledEdit;
    LabelSQLComboBox3: TLabelSQLComboBox;
    LabeledEdit13: TLabeledEdit;
    LabeledEdit14: TLabeledEdit;
    LabelSQLComboBox4: TLabelSQLComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn5: TBitBtn;
    LabelSQLComboBox6: TLabelSQLComboBox;
    LabeledEdit15: TLabeledEdit;
    LabeledEdit16: TLabeledEdit;
    LabeledEdit17: TLabeledEdit;
    cbGryz: TLabelSQLComboBox;
    LabelEdit5: TLabelEdit;
    cbForwarder: TLabelSQLComboBox;
    LabeledEdit18: TLabeledEdit;
    eSalePersent: TLabelInteger;
    LabelEdit1: TLabelEdit;
    LabelEditPassword: TLabeledEdit;
    procedure eFullNameChange(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit2Change(Sender: TObject);
    procedure LabeledEdit4Change(Sender: TObject);
    procedure LabeledEdit3Change(Sender: TObject);
    procedure LabeledEdit6Change(Sender: TObject);
    procedure LabeledEdit5Change(Sender: TObject);
    procedure LabeledEdit7Change(Sender: TObject);
    procedure LabeledEdit8Change(Sender: TObject);
    procedure LabeledEdit9Change(Sender: TObject);
    procedure LabeledEdit10Change(Sender: TObject);
    procedure LabeledEdit11Change(Sender: TObject);
    procedure LabeledEdit12Change(Sender: TObject);
    procedure LabelEditBmpBtn1ChangeData(Sender: TObject);
    procedure LabelSQLComboBox2Change(Sender: TObject);
    procedure LabelSQLComboBox1Change(Sender: TObject);
    //procedure LabelEditBmpBtn2ChangeData(Sender: TObject);
    procedure eCountryChange(Sender: TObject);
    procedure LabelSQLComboBox3Change(Sender: TObject);
    procedure btCanselClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    //procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabelSQLComboBox6Change(Sender: TObject);
    procedure LabeledEdit16Change(Sender: TObject);
    procedure LabeledEdit17Change(Sender: TObject);
    procedure LabeledEdit15Change(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure LabeledEdit2Exit(Sender: TObject);
    procedure LabeledEdit1Exit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LabeledEdit18Exit(Sender: TObject);
    procedure LabelEdit1Exit(Sender: TObject);
    procedure LabelEditPasswordChange(Sender: TObject);
  private
    { Private declarations }
  public
  function AddRecord:longint;
  function EditRecord(l:longint):longint;
    { Public declarations }
  end;

var
  card: Tcard;
  countryId:integer;
  cityId:integer;
  FullName:string;
  ShotName: string;
  AcrName:string;
  UrAddr:string;
  FacAddr:string;
  phone:string;
  Fax:string;
  Email:string;
  INN:string;
  CalCount:string;
  OKONX:string;
  OKPO:string;
  BankId:integer;
  ContrAv:string;
  ContrGd:string;
  ReasId:integer;
  ClTypeId:integer;
  InPers:string;
  PersTypeId:integer;
  ContactName:string;
  Id:longint;
  kreditTek:string;
  password:string;


implementation

uses CardBank, ContractCard, FAddEdit, SendStr,FCity, FInvoice,Invoice,
  FAKT;

{$R *.dfm}


function Tcard.AddRecord:longint;
var
s:string;
//l:longint;
st,UpD:string;
begin
//btOk.Enabled:=false;
LabelSQLComboBox1.Lbl.Font.Size:=10;
LabelSQLComboBox2.Lbl.Font.Size:=10;
LabelSQLComboBox3.Lbl.Font.Size:=10;
LabelSQLComboBox4.Lbl.Font.Size:=10;
LabelSQLComboBox6.Lbl.Font.Size:=10;
eCountry.Lbl.Font.Size:=10;

eCountry.SQLComboBox.Font.size:=10;
LabelSQLComboBox1.SQLComboBox.Font.Size:=10;
LabelSQLComboBox2.SQLComboBox.Font.Size:=10;
LabelSQLComboBox3.SQLComboBox.Font.Size:=10;
LabelSQLComboBox4.SQLComboBox.Font.Size:=10;
LabelSQLComboBox6.SQLComboBox.Font.Size:=10;
//eCountry.lbl.Font.s
LabeledEdit13.Text:=FormatDateTime('dd.mm.yyyy',now);
LabeledEdit14.Text:=FormatDateTime('dd.mm.yyyy',now);

LabeledEdit13.Enabled:=False;
LabeledEdit14.Enabled:=False;
LabeledEdit14.EditLabel.Enabled:=true;
LabeledEdit13.EditLabel.Enabled:=true;
cbForwarder.Where:='Clients_Ident is NULL';
cbForwarder.SQLComboBox.Recalc;
LabelSQLComboBox6.SetActive(1);
LabelSQLComboBox3.SetActive(1);
PersTypeId:=1;
  eSalePersent.MaxLength:=2;
  countryId:=1;
  cityId:=0;
  FullName:='';
  ShotName:='';
  AcrName:='';
  UrAddr:='';
  FacAddr:='';
  phone:='';
  Fax:='';
  Email:='';
  INN:='';
  CalCount:='';
  OKONX:='';
  OKPO:='';
  BankId:=0;
  ContrAv:='';
  ContrGd:='';
  ContactName:='';
  ReasId:=0;
  ClTypeId:=1;
  InPers:='';
  PersTypeId:=1;
  password:='';
  LabelSQLComboBox2.SetActive(CountryId);
  LabelSQLComboBox6.Focused;
  Id:=sql.FindNextInteger('Ident','Clients','',MaxLongint);

  s:=intToStr(Id)+',(Null),(Null),(Null),(Null),(Null),(Null),(Null)'+
      ',(Null),(Null),(Null),(Null),(Null),(Null),'+
      '(Null),(Null),(Null),(NULL),(Null),(Null),(Null),'+
      '(Null),(Null),(Null),(NULL),(NULL),(NULL),(Null),(Null)';

 sql.ExecOneSql('Insert into Clients Values('+s+'); ');

 cbForwarder.Where:='Clients_Ident is NULL' ;

if ShowModal=mrOk then
begin
 st:=FormatDateTime('yyyy-mm-dd',now) ;
 UpD:=FormatDateTime('yyyy-mm-dd',now) ;

 //If PersTypeId=1 then
// begin
  if  ShotName<>'' then
  s:='Name='+sql.MakeStr(ShotName)
  else s:='Name=NULL';

  if AcrName<>'' then
  s:=s+', Acronym='+sql.MakeStr(AcrName)
  else s:=s+',Acronym=NULL';

  s:=s+', FullName='+ sql.MakeStr(FullName)  ;

 if  phone<>''  then
   s:=S+', Telephone='+sql.MakeStr(phone)
   else s:=S+', Telephone='+'NULL';

 if Fax<>'' then
   s:=s+', Fax='+sql.MakeStr(Fax)
   else s:=S+', Fax='+'NULL';

 if Email<>'' then
   s:=s+', Email='+sql.MakeStr(Email)
   else s:=S+', Email='+'NULL';

 if LabeledEdit18.Text<>'' then
   s:=s+', KPP='+sql.MakeStr(LabeledEdit18.Text)
   else s:=S+', KPP='+'NULL';

 if INN<>'' then
   s:=s+', INN='+sql.MakeStr(INN)
   else s:=S+', INN='+'NULL';

 if CalCount<>'' then
   s:=s+', CalculatCount='+sql.MakeStr(CalCount)
   else s:=S+', CalculatCount='+'NULL';

 if BankId<>0 then
   s:=s+', Bank_Ident='+IntToStr(BankID)
   else s:=S+', Bank_Ident='+'NULL';

 if  OKONX<>'' then
   s:=s+', OKONX='+sql.MakeStr(OKONX)
    else s:=S+', OKONX='+'NULL';

 if  OKPO<>'' then
   s:=s+', OKPO='+sql.MakeStr(OKPO)
    else s:=S+', OKPO='+'NULL';

 if  InPers<>'' then
   s:=s+', INPerson='+sql.MakeStr(InPers)
       else s:=S+', INPerson='+'NULL';

 if  ReasId<>0 then
   s:=s+', OnReason_Ident='+IntToStr(ReasId)
          else s:=S+', OnReason_Ident='+'NULL';

 if  ClTypeId<>0 then
   s:=s+', ClientType_Ident='+IntToStr(ClTypeId)
            else s:=S+', ClientType_Ident='+'NULL';

   s:=s+', `Start`='+sql.MakeStr(st);

   s:=s+', DateUpd='+sql.MakeStr(UpD)  ;

 if  CityId<>0 then
   s:=s+', City_Ident='+intToStr(CityId)
               else s:=S+', City_Ident='+'NULL';

 if  CountryId<>0 then
   s:=s+', Country_Ident='+IntToStr(CountryId)
     else s:=S+', Country_Ident='+'NULL';

 if   PersTypeId<>0 then
   s:=s+',PersonType_Ident='+IntToStr(PersTypeId)
   else s:=S+', PersonType_Ident='+'NULL';

 if cbGryz.getData<>0 then
   s:=s+',NameGood_Ident='+IntToStr(cbGryz.getData)
   else s:=S+', NameGood_Ident='+'NULL';

 if cbForwarder.SQLComboBox.getdata<>0 then
     s:=s+', Forwarder_Ident='+IntToStr(cbForwarder.SQLComboBox.getdata)
     else s:=S+', Forwarder_Ident='+'NULL';

 if  LabelEdit5.Text<>'' then
     s:=s+', Kredit='+sql.MakeStr(trim(LabelEdit5.text))
     else s:=S+', Kredit='+sql.MakeStr('0.00');

 if  LabelEdit1.Text<>'' then
     s:=s+', KreditTEK='+sql.MakeStr(trim(LabelEdit1.text))
     else s:=S+', KreditTEK='+sql.MakeStr('0.00');

  s:=S+', Saldo='+sql.MakeStr('0.00');

 if eSalePersent.Text<>'' then
  s:=s+', SalePersent='+eSalePersent.text
   else  s:=s+', SalePersent=0';

  // password
  if (password<>'') then
    s:=s+', password='+sql.MakeStr(password)
  else
    s:=s+', password=NULL';

  if  sql.ExecOneSql('Update Clients set '+s+' where Ident='+IntToStr(Id)+'; ')<>0
  then begin
          Addrecord:=0 ;
          exit;
       end   ;
// end;
{ If PersTypeId=2 then
 begin
  s:='Name='+sql.MakeStr(ShotName)+', Acronym='+sql.MakeStr(AcrName)+', FullName='+
   sql.MakeStr(FullName)+', Telephone='+sql.MakeStr(phone)+', Fax='+
   sql.MakeStr(Fax)+', Email='+sql.MakeStr(Email)+', INN='+sql.MakeStr(INN)+
   ', CalculatCount='+sql.MakeStr(CalCount)+
   ', INPerson='+sql.MakeStr(InPers)+', OnReason_Ident='+
   IntToStr(ReasId)+', ClientType_Ident='+IntToStr(ClTypeId)+', `Start`='''+st+
   ''', DateUpd='''+UpD+''', City_Ident='+intToStr(CityId)+', Country_Ident='+
   IntToStr(CountryId)+',PersonType_Ident='+IntToStr(PersTypeId);
   sql.ExecOneSql('Update Clients set '+s+' where Ident='+IntToStr(Id)+'; commit;');
 end;       }

 if ContactName<>'' then
 S:=sql.MakeStr(ContactName)
 else s:='NULL' ;

 if phone<>'' then
 s:=s+','+sql.MakeStr(phone)
 else S:=s+','+'NULL';

 s:=s+','+InttoStr(Id) ;
// s:=s+','+IntToStr(sql.FindNextInteger('Ident','Contact','',MaxLongint));
 if sql.ExecOneSql('Insert into Contact values('+s+'); commit;')<>0
 then begin
         addrecord:=0 ;
          exit;
       end   ;

 if FacAddr<>'' then s:=sql.MakeStr(FacAddr)
 else s:='NULL';
 s:=s+','+IntToStr(Id)+','+IntToStr(2);
 if sql.ExecOneSql('Insert into Address values('+s+'); commit;')<>0
 then begin
          addrecord:=0 ;
          exit;
       end   ;

 if UrAddr<>'' then s:=sql.MakeStr(UrAddr)
 else s:='NULL';
 s:=s+','+IntToStr(Id)+','+IntToStr(1);
 if sql.ExecOneSql('Insert into Address values('+s+'); commit;')<>0
 then begin
          addrecord:=0 ;
          exit;
       end   ;

 addRecord:=Id
 end else addrecord:=0;
end;

function Tcard.EditRecord(l:longint):longint;
var
s:string;
q:TQuery;
qc:TQuery;
qAd:TQuery;
//l:longint;
st,UpD,cond:string;
FullName1,ShotName1:string;
begin
id:=l;
LabelSQLComboBox1.Lbl.Font.Size:=10;
LabelSQLComboBox2.Lbl.Font.Size:=10;
LabelSQLComboBox3.Lbl.Font.Size:=10;
LabelSQLComboBox4.Lbl.Font.Size:=10;
LabelSQLComboBox6.Lbl.Font.Size:=10;
eCountry.Lbl.Font.Size:=10;

eCountry.SQLComboBox.Font.size:=10;
LabelSQLComboBox1.SQLComboBox.Font.Size:=10;
LabelSQLComboBox2.SQLComboBox.Font.Size:=10;
LabelSQLComboBox3.SQLComboBox.Font.Size:=10;
LabelSQLComboBox4.SQLComboBox.Font.Size:=10;
LabelSQLComboBox6.SQLComboBox.Font.Size:=10;
  eSalePersent.MaxLength:=2;
LabeledEdit13.Text:=FormatDateTime('dd.mm.yyyy',now);
LabeledEdit14.Text:=FormatDateTime('dd.mm.yyyy',now);

LabeledEdit13.Enabled:=False;
LabeledEdit14.Enabled:=False;
LabeledEdit14.EditLabel.Enabled:=true;
LabeledEdit13.EditLabel.Enabled:=true;

  PersTypeId:=sql.SelectInteger('Clients','PersonType_Ident','Ident='+intToStr(l));
  countryId:=sql.SelectInteger('Clients','Country_Ident','Ident='+intToStr(l));
  cityId:=sql.SelectInteger('Clients','City_Ident','Ident='+intToStr(l));
  FullName1:=sql.Selectstring('Clients','FullName','Ident='+intToStr(l));
  ShotName1:=sql.Selectstring('Clients','Name','Ident='+intToStr(l));
  AcrName:=sql.Selectstring('Clients','Acronym','Ident='+intToStr(l));
  UrAddr:=sql.Selectstring('Address','AdrName','Clients_Ident='+intToStr(l)+' and AddressType_Ident=1');
  FacAddr:=sql.Selectstring('Address','AdrName','Clients_Ident='+intToStr(l)+' and AddressType_Ident=2');
  phone:=sql.Selectstring('Clients','Telephone','Ident='+intToStr(l));
  Fax:=sql.Selectstring('Clients','Fax','Ident='+intToStr(l));
  Email:=sql.Selectstring('Clients','Email','Ident='+intToStr(l));
  INN:=sql.Selectstring('Clients','INN','Ident='+intToStr(l));
  CalCount:=sql.Selectstring('Clients','CalculatCount','Ident='+intToStr(l));
  OKONX:=sql.Selectstring('Clients','OKONX','Ident='+intToStr(l));
  OKPO:=sql.Selectstring('Clients','OKPO','Ident='+intToStr(l));
  BankId:=sql.SelectInteger('Clients','Bank_Ident','Ident='+intToStr(l));
 // ContrId:=sql.SelectInteger('Clients','Contract_Ident','Ident='+intToStr(l));
  ReasId:=sql.SelectInteger('Clients','OnReason_Ident','Ident='+intToStr(l));
  ClTypeId:=sql.SelectInteger('Clients','ClientType_Ident','Ident='+intToStr(l));
  eSalePersent.Text:=sql.SelectString('Clients','SalePersent','Ident='+intToStr(l));
  LabelEditPassword.Text:=sql.SelectString('Clients','password','Ident='+intToStr(l));

  if IntToStr(ClTypeId)='' then
  begin
   LabeledEdit16.visible:=false;
   LabeledEdit17.visible:=false;
  end;
  InPers:=sql.Selectstring('Clients','INperson','Ident='+intToStr(l));
  st:=FormatDateTime('yyyy-mm-dd',StrToDate(sql.Selectstring('Clients','Start','Ident='+intToStr(l))));
  if ClTypeId=1  then
  begin
  q:=sql.Select('Contract','Number','Clients_Ident='+intToStr(l)+' and ContractType_Ident=2','') ;
  if not q.eof then
  ContrAv:=sql.Selectstring('Contract','Number','Clients_Ident='+intToStr(l)+' and ContractType_Ident=2')+', '+
                            FormatDateTime('mm.dd.yyyy',StrToDate(sql.Selectstring('Contract','Start','Clients_Ident='+
                            intToStr(l)+' and ContractType_Ident=2')))
    else  ContrAv:='' ;
  q.Free;
   ContrGd:='';
  end
  else
  if ClTypeId=3 then
  begin
  q:=sql.select('Contract','Number',
                            'Clients_Ident='+intToStr(l)+' and ContractType_Ident=1','');
  if not q.eof then
  ContrGd:=sql.Selectstring('Contract','Number',
                            'Clients_Ident='+intToStr(l)+' and ContractType_Ident=1')+', '+
                            FormatDateTime('mm.dd.yyyy',StrToDate(sql.Selectstring('Contract','Start','Clients_Ident='+
                            intToStr(l)+' and ContractType_Ident=1')))
     else ContrGd:='';
  q.free;
  ContrAv:='';
  end
  else
  If ClTypeId=2 then
  begin
  q:=sql.select('Contract','Number',
                            'Clients_Ident='+intToStr(l)+' and ContractType_Ident=1','');

  if  not q.eof then
   ContrGd:=sql.Selectstring('Contract','Number',
                            'Clients_Ident='+intToStr(l)+' and ContractType_Ident=1')+', '+
                            FormatDateTime('mm.dd.yyyy',StrToDate(sql.Selectstring('Contract','Start','Clients_Ident='+
                            intToStr(l)+' and ContractType_Ident=1')))
     else ContrGd:='';
  q.Free;
  q:=sql.Select('Contract','Number','Clients_Ident='+intToStr(l)+' and ContractType_Ident=2','');

   if not q.eof then
   ContrAv:=sql.Selectstring('Contract','Number','Clients_Ident='+intToStr(l)+' and ContractType_Ident=2')+', '+
                            FormatDateTime('mm.dd.yyyy',StrToDate(sql.Selectstring('Contract','Start','Clients_Ident='+
                            intToStr(l)+' and ContractType_Ident=2')))
     else ContrAv:='';
  end
  else
  begin
      ContrAv:='';
      ContrGd:='';
  end;
    cond:='';
   // if phone<>'' then
  //  cond:=' and Phone='+sql.MakeStr(phone)
   // else cond:=' and Phone is NULL'     ;
    qc:=sql.select('Contact','Name','Clients_Ident='+intToStr(l)+
                   cond,'');
    if not qc.eof then ContactName:=qc.fieldByName('Name').asString
      else ContactName:='';
   qc.free;
    LabelSQLComboBox3.SQLComboBox.setActive(ClTypeId);
    LabelSQLComboBox6.SQLComboBox.setActive(PersTypeId);
    LabeledEdit2.text:=AcrName;
    LabeledEdit1.text:=ShotName1;
    eFullName.text:=FullName1;
    LabeledEdit4.text:=UrAddr;
    LabeledEdit6.text:=phone;
    eCountry.SQLComboBox.setActive(ReasId);
    LabelSQLComboBox1.SQLComboBox.setActive(CityId);
    LabeledEdit3.text:=FacAddr;
    LabeledEdit5.text:=Fax;
    LabeledEdit7.text:=Email;
    LabeledEdit8.text:=INN;
    LabeledEdit18.Text:=sql.Selectstring('Clients','KPP','Ident='+intToStr(l));
    LabeledEdit9.text:=CalCount;
    LabeledEdit10.text:=OKONX;
    LabeledEdit11.text:=OKPO;
    LabelSQLComboBox2.SQLComboBox.setActive(CountryId);
    LabeledEdit12.text:=InPers;

    LabeledEdit13.text:=FormatDateTime('dd.mm.yyyy',StrToDate(sql.Selectstring('Clients','Start','Ident='+intToStr(l))));
    LabeledEdit14.text:=FormatDateTime('dd.mm.yyyy',now) ;
    LabelSQLComboBox4.SQLComboBox.setActive(BankId);

    LabeledEdit16.text:=ContrGd;
    LabeledEdit17.text:=ContrAv;
    LabeledEdit15.text:=ContactName;
    if sql.SelectInteger('Clients','NameGood_Ident','Ident='+intToStr(l))<>0 then
      cbGryz.SetActive(sql.SelectInteger('Clients','NameGood_Ident','Ident='+intToStr(l)));
    cbForwarder.SQLComboBox.where:='Clients_Ident='+IntToStr(ID);
    //cbForwarder.SQLComboBox.recalc;  
    if  sql.Selectstring('Clients','Forwarder_Ident','Ident='+intToStr(l))<>'' then
     cbForwarder.SQLComboBox.setactive(sql.SelectInteger('Clients','Forwarder_Ident','Ident='+IntToStr(Id))) ;

    if sql.Selectstring('Clients','Kredit','Ident='+intToStr(l))<>'' then
      LabelEdit5.Text:=SendStr.StrTo00(SendStr.Credit(l));
    if sql.Selectstring('Clients','KreditTEK','Ident='+intToStr(l))<>'' then
      LabelEdit1.Text:=sql.Selectstring('Clients','KreditTEK','Ident='+intToStr(l));
      kreditTek:=LabelEdit1.Text;

    //LabelSQLComboBox5.setActive(ContrId);
 if ShowModal=mrOk then
begin
 UpD:=FormatDateTime('yyyy-mm-dd',now) ;
//If PersTypeId=1 then
// begin
if ShotName<>'' then
 s:='Name='+sql.MakeStr(ShotName)
 else s:='Name=NULL';
 if AcrName<>'' then
 s:=s+', Acronym='+sql.MakeStr(AcrName)
 else s:=s+',Acronym=NULL';

 s:=s+', FullName='+sql.MakeStr(FullName)  ;

 if  phone<>''  then
   s:=S+', Telephone='+sql.MakeStr(phone)
   else  s:=S+', Telephone='+'NULL';

 if Fax<>'' then
   s:=s+', Fax='+sql.MakeStr(Fax)
   else  s:=S+', Fax='+'NULL';

 if Email<>'' then
   s:=s+', Email='+sql.MakeStr(Email)
   else  s:=S+', Email='+'NULL';

 if INN<>'' then
   s:=s+', INN='+sql.MakeStr(INN)
   else  s:=S+', INN='+'NULL';

 if LabeledEdit18.Text<>'' then
   s:=s+', KPP='+sql.MakeStr(LabeledEdit18.Text)
   else  s:=S+', KPP='+'NULL';

 if CalCount<>'' then
   s:=s+', CalculatCount='+sql.MakeStr(CalCount)
    else  s:=S+', CalculatCount='+'NULL';

 if BankId<>0 then
   s:=s+', Bank_Ident='+IntToStr(BankID)
   else  s:=S+', Bank_Ident='+'NULL';

 if  OKONX<>'' then
   s:=s+', OKONX='+sql.MakeStr(OKONX)
   else  s:=S+', OKONX='+'NULL';

 if  OKPO<>'' then
   s:=s+', OKPO='+sql.MakeStr(OKPO)
   else  s:=S+', OKPO='+'NULL';

 if  InPers<>'' then
   s:=s+', INPerson='+sql.MakeStr(InPers)
     else  s:=S+', INPerson='+'NULL';

 if  ReasId<>0 then
   s:=s+', OnReason_Ident='+IntToStr(ReasId)
   else  s:=S+', OnReason_Ident='+'NULL';

 if  ClTypeId<>0 then
   s:=s+', ClientType_Ident='+IntToStr(ClTypeId)
     else  s:=S+', ClientType_Ident='+'NULL';

   s:=s+', DateUpd='+sql.MakeStr(UpD)  ;

 if  CityId<>0 then
   s:=s+', City_Ident='+intToStr(CityId)
      else  s:=S+', City_Ident='+'NULL';

 if  CountryId<>0 then
   s:=s+', Country_Ident='+IntToStr(CountryId)
       else  s:=S+', Country_Ident='+'NULL';

 if   PersTypeId<>0 then
   s:=s+',PersonType_Ident='+IntToStr(PersTypeId)
     else  s:=S+', PersonType_Ident='+'NULL';

 if cbGryz.getData<>0 then
   s:=s+',NameGood_Ident='+IntToStr(cbGryz.getData)
   else s:=S+', NameGood_Ident='+'NULL';

 if cbForwarder.SQLComboBox.getdata<>0 then
     s:=s+', Forwarder_Ident='+IntToStr(cbForwarder.SQLComboBox.getdata)
     else s:=S+', Forwarder_Ident='+'NULL';

 if  LabelEdit5.Text<>'' then
     s:=s+', Kredit='+sql.MakeStr(trim(LabelEdit5.text))
     else s:=S+', Kredit='+sql.MakeStr('0.00');
 if  LabelEdit1.Text<>'' then
     s:=s+', KreditTEK='+sql.MakeStr(trim(LabelEdit1.text))
     else s:=S+', KreditTEK='+sql.MakeStr('0.00');

  if eSalePersent.Text<>'' then
  s:=s+', SalePersent='+eSalePersent.text
   else  s:=s+', SalePersent=0';

  // password
  if (password<>'') then
    s:=s+', password='+sql.MakeStr(password)
  else
    s:=s+', password=NULL';

if  sql.ExecOneSql('Update Clients set '+s+' where Ident='+IntToStr(Id))<>0
then begin
          editRecord:=0;
          exit;
       end   ;
// end;
//end;
{If PersTypeId=2 then
 begin
  s:='Name='+sql.MakeStr(ShotName)+', Acronym='+sql.MakeStr(AcrName)+', FullName='+
   sql.MakeStr(FullName)+', Telephone='+sql.MakeStr(phone)+', Fax='+
   sql.MakeStr(Fax)+', Email='+sql.MakeStr(Email)+', INN='+sql.MakeStr(INN)+
   ', CalculatCount='+sql.MakeStr(CalCount)+
   ', INPerson='+sql.MakeStr(InPers)+', OnReason_Ident='+
   IntToStr(ReasId)+', ClientType_Ident='+IntToStr(ClTypeId)+', `Start`='''+st+
   ''', DateUpd='''+UpD+''', City_Ident='+intToStr(CityId)+', Country_Ident='+
   IntToStr(CountryId)+',PersonType_Ident='+IntToStr(PersTypeId);
   sql.ExecOneSql('Update Clients set '+s+' where Ident='+IntToStr(l)+'; commit;');
 end; }
qad:=sql.Select('Contact','','Clients_Ident='+IntToStr(id),'') ;
if not qad.eof then
begin

 if ContactName<>'' then
  S:='Name='+sql.MakeStr(ContactName)
  else    S:='Name='+'NULL'  ;
  if  phone<>'' then
  s:=s+',Phone='+sql.MakeStr(phone)
  else s:=s+',Phone='+'NULL';

if  sql.ExecOneSql('Update Contact set '+s+' where Clients_Ident='+IntToStr(id))<>0
then begin
         editRecord:=0;
          exit;
       end   ;
end else
begin
  if ContactName<>'' then
  S:=sql.MakeStr(ContactName)
  else    S:='NULL'  ;
  if  phone<>'' then
  s:=s+','+sql.MakeStr(phone)
  else s:=s+','+'NULL';
  s:=s+ ','+IntToStr(id) ;
  if  sql.ExecOneSql('Insert into Contact values('+s+');')<>0
   then begin
         editRecord:=0;
          exit;
       end   ;

end;
qad.free;
qad:=sql.Select('Address','','Clients_Ident='+IntToStr(id)+' and AddressType_Ident=2','');
if not qad.eof then
begin
 if FacAddr<>'' then
 s:='AdrName='+sql.MakeStr(FacAddr)
 else s:='AdrName='+'NULL';

 if sql.ExecOneSql('Update Address set '+s+' where Clients_Ident='+IntToStr(id)+
                  ' and AddressType_Ident=2; ')<>0
 then begin
          editRecord:=0;
          exit;
       end   ;
end else
    begin
      if FacAddr<>'' then
       begin
      s:=sql.MakeStr(FacAddr)+',' +IntToStr(id)+','+IntToStr(2);
      if sql.insertstring('Address','AdrName,Clients_Ident,AddressType_Ident',s)<>0
      then begin
          editRecord:=0;
          exit;
           end   ;
       end;
    end;
qad.Free;
qad:=sql.Select('Address','','Clients_Ident='+IntToStr(id)+' and AddressType_Ident=1','') ;
if not qad.eof then
begin
 if UrAddr<>'' then
 s:='AdrName='+sql.MakeStr(UrAddr)
 else s:='AdrName='+'NULL';

 if sql.ExecOneSql('Update Address set '+s+' where Clients_Ident='+IntToStr(id)+
                  ' and AddressType_Ident=1; ')<>0
 then begin
          editRecord:=0;
          exit;
       end;
end else
    begin
      if UrAddr<>'' then
       begin
      s:=sql.MakeStr(UrAddr)+',' +IntToStr(id)+','+IntToStr(1);
      if sql.insertstring('Address','AdrName,Clients_Ident,AddressType_Ident',s)<>0
      then begin
          editRecord:=0;
          exit;
           end   ;
       end;
    end;
qad.Free;

 editrecord:=Id;
end
else editrecord:=0;
end;

procedure Tcard.eFullNameChange(Sender: TObject);
begin
if  Length(eFullName.text)>70 then
 begin
 Application.MessageBox
      ('Полное название клиента не должно превышать 70 символов!','Ошибка',0);
  eFullName.Focused;
  //FullName:=trim(eFullName.text);
  //SetFocus ;
 end
  else FullName:=trim(eFullName.text);
end;

procedure Tcard.LabeledEdit1Change(Sender: TObject);
begin
 if  Length(LabeledEdit1.text)>45 then
 begin
 Application.MessageBox
      ('Укароченное название клиента не должно превышать 35 символов!','Ошибка',0);
  LabeledEdit1.SetFocus ;
 // ShotName:=trim(LabeledEdit1.text);
 end
  else
  begin
  ShotName:=trim(LabeledEdit1.text);
  end;
end;

procedure Tcard.LabeledEdit2Change(Sender: TObject);
begin
  if  Length(LabeledEdit2.text)>25 then
 begin
 Application.MessageBox
      ('Укороченное название клиента не должно превышать 25 символов!','Ошибка',0);
  LabeledEdit2.SetFocus ;
  //AcrName:=trim(LabeledEdit2.text);
 end
  else
   begin
   AcrName:=trim(LabeledEdit2.text);
   end;
end;


procedure Tcard.LabeledEdit4Change(Sender: TObject);
begin
  if  Length(LabeledEdit4.text)>80 then
 begin
 Application.MessageBox
      ('Адресс клиента не должн превышать 80 символов!','Ошибка',0);
  LabeledEdit4.SetFocus ;
  //UrAddr:=trim(LabeledEdit4.text);
 end
  else UrAddr:=trim(LabeledEdit4.text);
end;

procedure Tcard.LabeledEdit3Change(Sender: TObject);
begin
  if  Length(LabeledEdit3.text)>80 then
 begin
 Application.MessageBox
      ('Адресс клиента не должн превышать 80 символов!','Ошибка',0);
  LabeledEdit3.SetFocus ;
  //FacAddr:=trim(LabeledEdit3.text);
 end
  else FacAddr:=trim(LabeledEdit3.text);
end;

procedure Tcard.LabeledEdit6Change(Sender: TObject);
begin
 if  Length(LabeledEdit6.text)>30
  then
 begin
 Application.MessageBox
      ('Телефон клиента не должн превышать 30 символов!','Ошибка',0);
  LabeledEdit6.SetFocus ;
  //Phone:=trim(LabeledEdit6.text);
 end
  else Phone:=trim(LabeledEdit6.text);
end;

procedure Tcard.LabeledEdit5Change(Sender: TObject);
begin
if  Length(LabeledEdit5.text)>15 then
 begin
 Application.MessageBox
      ('Номер факса клиента не должн превышать 15 символов!','Ошибка',0);
  LabeledEdit5.SetFocus ;
  //Fax:=trim(LabeledEdit5.text);
 end
  else Fax:=trim(LabeledEdit5.text);
end;

procedure Tcard.LabeledEdit7Change(Sender: TObject);
begin
if  Length(LabeledEdit7.text)>50 then
 begin
 Application.MessageBox
      ('E-mail клиента не должн превышать 50 символов!','Ошибка',0);
  LabeledEdit7.SetFocus ;
  //Email:=trim(LabeledEdit7.text);
 end
  else Email:=trim(LabeledEdit7.text);
end;

procedure Tcard.LabeledEdit8Change(Sender: TObject);
begin
if  Length(LabeledEdit8.text)>12 then
 begin
 Application.MessageBox
      ('ИНН клиента не должн превышать 12 символов!','Ошибка',0);
  LabeledEdit8.SetFocus ;
  //INN:=trim(LabeledEdit8.text);
 end
  else INN:=trim(LabeledEdit8.text);
end;

procedure Tcard.LabeledEdit9Change(Sender: TObject);
begin
if  Length(LabeledEdit9.text)>20 then
 begin
 Application.MessageBox
      ('Расчетный счет клиента не должн превышать 20 символов!','Ошибка',0);
  LabeledEdit9.SetFocus ;
  //CalCount:=trim(LabeledEdit9.text);
 end
  else CalCount:=trim(LabeledEdit9.text);
end;

procedure Tcard.LabeledEdit10Change(Sender: TObject);
begin
if  Length(LabeledEdit10.text)>5 then
 begin
 Application.MessageBox
      ('Код по ОКОНХ клиента не должн превышать 5 символов!','Ошибка',0);
  LabeledEdit10.SetFocus ;
  //OKONX:=trim(LabeledEdit10.text);
 end
  else OKONX:=trim(LabeledEdit10.text);
end;

procedure Tcard.LabeledEdit11Change(Sender: TObject);
begin
 if  Length(LabeledEdit11.text)>8 then
 begin
 Application.MessageBox
      ('Код по ОКПО клиента не должн превышать 8 символов!','Ошибка',0);
  LabeledEdit11.SetFocus ;
  //OKPO:=trim(LabeledEdit11.text);
 end
  else OKPO:=trim(LabeledEdit11.text);
end;

procedure Tcard.LabeledEdit12Change(Sender: TObject);
begin
 if  Length(LabeledEdit12.text)>50 then
 begin
 Application.MessageBox
      ('Описание представителя клиента не должно превышать 50 символов!','Ошибка',0);
  LabeledEdit12.SetFocus ;
  InPers:=trim(LabeledEdit12.text);
 end
  else InPers:=trim(LabeledEdit12.text);
end;

procedure Tcard.LabelEditBmpBtn1ChangeData(Sender: TObject);
begin 
BankId:=LabelSQLComboBox4.getData;
end;

procedure Tcard.LabelSQLComboBox2Change(Sender: TObject);
begin
 CountryId:=LabelSQLComboBox2.getData;
end;

procedure Tcard.LabelSQLComboBox1Change(Sender: TObject);
begin
CityId:=LabelSQLComboBox1.getData;
end;



procedure Tcard.eCountryChange(Sender: TObject);
begin
 ReasId:=eCountry.getData;
end;

procedure Tcard.LabelSQLComboBox3Change(Sender: TObject);
begin
ClTypeId:=LabelSQLComboBox3.getData;
if (ClTypeId=1) and (PersTypeId=1)then
begin
LabeledEdit16.visible:=false;
//BitBtn4.Visible:=false;
LabeledEdit17.visible:=true;
//BitBtn6.Visible:=true;
end
else if (ClTypeId=3)  and (PersTypeId=1)then
begin
   LabeledEdit17.visible:=false;
   //BitBtn6.Visible:=false;
   LabeledEdit16.visible:=true;
   //BitBtn4.Visible:=true;
end
else if (CltypeId=2)  and (PersTypeId=1)then
begin
LabeledEdit16.visible:=true;
LabeledEdit17.visible:=true;
end
  else
   begin
       LabeledEdit17.visible:=false;
       LabeledEdit16.visible:=false;
   end;

end;

procedure Tcard.btCanselClick(Sender: TObject);
begin
case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
end;
end;

procedure Tcard.btOkClick(Sender: TObject);
var q:TQuery;
  val:string;
  l:longint;
  label Next1;
begin
    if  (LabeledEdit1.text='') and (LabelSQLComboBox6.getData=1) then
    begin
     Application.MessageBox
      ('Введите укороченное название клиента!','Ошибка',0);
     LabeledEdit1.SetFocus ;
    end
    else
      if  (LabeledEdit2.text='')  then
       begin
     Application.MessageBox
      ('Введите укороченное название клиента!','Ошибка',0);
     LabeledEdit2.SetFocus ;
       end
       else
       if  eFullName.text='' then
        begin
     Application.MessageBox
      ('Введите полное название клиента!','Ошибка',0);
     eFullName.SetFocus ;
 end  else
 if
   (cbGryz.SQLComboBox.Text <> '') and
   (cbGryz.SQLComboBox.ItemIndex =-1)
    then begin
    val:=trim(cbGryz.SQLComboBox.Text);
    q:=sql.select('NameGood','Ident','Name='+sql.MakeStr(val),'');
    if q.eof then
    begin
    l:=sql.FindNextInteger('Ident','NameGood','',maxlongint);
    if sql.InsertString('NameGood','Ident,Name',
           IntToStr(l)+','+ sql.MakeStr(val)) <> 0
       then begin
              exit
            end
       else begin
            cbGryz.SQLComboBox.recalc;
            cbGryz.setactive(l);
            end;
     end else cbGryz.setactive(q.fieldByName('Ident').asInteger);
     q.Free;
    end
//--------------------------
else
 if
   (cbForwarder.SQLComboBox.Text <> '') and
   (cbForwarder.SQLComboBox.ItemIndex =-1)
    then begin
    val:=trim(cbForwarder.SQLComboBox.Text);
    q:=sql.select('Forwarder','Ident','Name='+sql.MakeStr(val)+
                  ' and Clients_Ident='+IntToStr(Id),'');
    if q.eof then
    begin
    l:=sql.FindNextInteger('Ident','Forwarder','',maxlongint);
    if sql.InsertString('Forwarder','Ident,Name,Clients_Ident',
           IntToStr(l)+','+ sql.MakeStr(val)+','+IntToStr(Id)) <> 0
       then begin
              exit
            end
       else begin
         if  (Id > 0) then begin
            cbForwarder.SQLComboBox.Where:='Clients_Ident = '+IntToStr(Id);
         end   
         else  begin
            cbForwarder.SQLComboBox.Where:='';
         end;
            cbForwarder.SQLComboBox.recalc;
            cbForwarder.setactive(l);
            end;
     end else cbForwarder.setactive(q.fieldByName('Ident').asInteger);
     q.Free;
    end


 else
       if   LabelSQLComboBox1.getData=0 then
       begin
     Application.MessageBox
      ('Введите город!','Ошибка',0);
     LabelSQLComboBox1.Focused ;
       end

    else begin
if pos('"',AcrName)<> 0 then
begin
if Invoice.InvoiceTest(Id,Now) then
begin
case Application.MessageBox('Пора распечатать акт! Подтвердите печать!',
                            'Сообщение',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
     FormAkt:=TFormAkt.Create(Application) ;
     FormAkt.AddRecord(Id);
     FormAkt.Free;
    end;
    IDNO:begin
         goto next1 ;
         exit
         end;
end;
end;

end
else  begin
if Invoice.InvoiceTest(Id,Now) then
begin
case Application.MessageBox('Пора распечатать счет фактуру! Подтвердите печать!',
                            'Сообщение',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
     FormInvoice:=TFormInvoice.Create(Application) ;
     FormInvoice.AddRecord(Id);
     FormInvoice.Free;
    end;
    IDNO:begin
         goto next1 ;
         exit
         end;
end;
end;
end;  {else - pos('"',AcrName)<> 0}
Next1:
         ModalResult:=mrOk;

        end;
end;

procedure Tcard.BitBtn3Click(Sender: TObject);
var
   l:longint;
begin

FormCardBank:=TFormCardBank.Create(Application) ;
l:=FormCardBank.AddRecord;
FormCardBank.Free;
if l<>0 then
begin
LabelSQLComboBox4.sqlCombobox.Recalc;
LabelSQLComboBox4.SetActive(l);
end;
end;



procedure Tcard.FormCreate(Sender: TObject);
begin
 LabeledEdit14.Text:=FormatDateTime('dd.mm.yyyy',now);
 //LabelSQLComboBox6.SQLComboBox.Sorted:=true;
 //LabelSQLComboBox4.SQLComboBox.Sorted:=true;
 //eCountry.SQLComboBox.Sorted:=true;
 //cbGryz.SQLComboBox.Sorted:=true;
 //cbForwarder.SQLComboBox.Sorted:=true;
end;

procedure Tcard.LabelSQLComboBox6Change(Sender: TObject);
begin
PersTypeId:=LabelSQLComboBox6.getData;
 if   PersTypeId=2 then
 begin
  eFullName.EditLabel.Caption:='Фамилия Имя Отчество' ;
  eFullName.Hint:='Введите ФИО клиента (не более 70 символов)'    ;
  LabeledEdit2.EditLabel.Caption:='Фамилия И.О.' ;
  LabeledEdit2.Hint:='Введите ФИО клиента (не более 25 символов)'    ;
  LabeledEdit10.Visible:=false;
  LabeledEdit11.Visible:=false;
  LabelSQLComboBox4.Visible:=false;
  bitBtn3.Visible:=false;
  LabeledEdit4.Visible:=false;
  LabeledEdit1.Visible:=false;
  //LabeledEdit2.Visible:=false;
  LabeledEdit12.Visible:=false;
   LabeledEdit8.Visible:=false;
   LabeledEdit9.Visible:=false;
   eCountry.Visible:=false;
   BitBTN5.Visible:=false;
   LabeledEdit16.Visible:=false;
   LabeledEdit17.Visible:=false;
 end;
 if   PersTypeId=1 then
 begin
  eFullName.EditLabel.Caption:='Полное название клиента ' ;
  eFullName.Hint:='Введите полное название клиента (не должено превышать 70 символов)'    ;
  LabeledEdit2.EditLabel.Caption:='Короткое название клиента ' ;
  LabeledEdit2.Hint:='Введите короткое название клиента (не должено превышать 25 символов)'    ;
  LabeledEdit10.Visible:=true;
  LabeledEdit11.Visible:=true;
  LabelSQLComboBox4.Visible:=true;
  bitBtn3.Visible:=true;
  LabeledEdit4.Visible:=true;
  LabeledEdit1.Visible:=true;
  //LabeledEdit2.Visible:=true;
  LabeledEdit12.Visible:=true;
  LabeledEdit8.Visible:=true;
  LabeledEdit9.Visible:=true;
   eCountry.Visible:=true;
   BitBTN5.Visible:=true;
   LabeledEdit16.Visible:=false;
   LabeledEdit17.Visible:=false;
 end;
 LabelSQLComboBox3Change(Sender);
end;

procedure Tcard.LabeledEdit16Change(Sender: TObject);
begin   {железнодорожные}
 //l:=sql.FindNextInteger('Ident','Clients','',MaxLongint);
 if   LabeledEdit16.text='' then
 begin
 FormCardContract:=TFormCardContract.Create(Application) ;
 ContrGd:=FormCardContract.AddRecord(1,Id);
 FormCardContract.Free;
 LabeledEdit16.text:=ContrGd;
 end
  else
  begin
   FormCardContract:=TFormCardContract.Create(Application) ;
   ContrGd:=FormCardContract.EditRecord(1,Id);
   FormCardContract.Free;
   LabeledEdit16.text:=ContrGd;

  end;
end;

procedure Tcard.LabeledEdit17Change(Sender: TObject);
begin           {автомобильные}
 //l:=sql.FindNextInteger('Ident','Clients','',MaxLongint);
 if  LabeledEdit17.text='' then
 begin
 FormCardContract:=TFormCardContract.Create(Application) ;
 ContrAv:=FormCardContract.AddRecord(2,Id);
 FormCardContract.Free;
 LabeledEdit17.text:=ContrAv;
 end
 else
    begin
    FormCardContract:=TFormCardContract.Create(Application) ;
    ContrAv:=FormCardContract.EditRecord(2,Id);
    FormCardContract.Free;
    LabeledEdit17.text:=ContrAv;
    end;
end;

procedure Tcard.LabeledEdit15Change(Sender: TObject);
begin
ContactName:=LabeledEdit15.text;
end;

procedure Tcard.BitBtn2Click(Sender: TObject);
var
    l:longint;
begin
  CityForm:=TCityForm.Create(Application) ;
  l:=CityForm.AddRecord;
  if l<>0 then
    begin
    LabelSQLComboBox1.SQLComboBox.Recalc;
    LabelSQLComboBox1.SQLComboBox.SetActive(l);
    end;
   CityForm.Free;  
end;

procedure Tcard.BitBtn1Click(Sender: TObject);
var q:TQuery;
    l:longint;
begin
  q:=sql.Select('Country','*','','');

  FormAE:=TFormAE.Create(Application);
  l:=FormAE.AddRecord (q,'Country',1);
  if l<>0 then
    begin
    LabelSQLComboBox2.SQLComboBox.Recalc;
    LabelSQLComboBox2.SQLComboBox.SetActive(l);
    end;
  FormAE.Free   ;
  q.Free;

end;

procedure Tcard.BitBtn5Click(Sender: TObject);
var q:TQuery;
    l:longint;
begin
  q:=sql.Select('OnReason','*','','');
 
  FormAE:=TFormAE.Create(Application);
  l:=FormAE.AddRecord (q,'OnReason',1);
  if l<>0 then
    begin
    eCountry.SQLComboBox.Recalc;
    eCountry.SQLComboBox.SetActive(l);
    end;
  FormAE.Free   ;
  q.Free;
end;

procedure Tcard.LabeledEdit2Exit(Sender: TObject);
begin
if    LabeledEdit1.Text='' then
   LabeledEdit1.Text:=AcrName;
end;

procedure Tcard.LabeledEdit1Exit(Sender: TObject);
begin
 if  eFullName.Text='' then
  eFullName.Text:=ShotName;
end;

procedure Tcard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btOkClick(Sender)
end;

procedure Tcard.LabeledEdit18Exit(Sender: TObject);
begin
if LabeledEdit18.Text<>'' then
 LabeledEdit18.text:=trim(LabeledEdit18.Text);
end;

procedure Tcard.LabelEdit1Exit(Sender: TObject);
var
 newKreditTek:  string;
begin
newKreditTek:=LabelEdit1.Text;
if  (newKreditTek<>kreditTek) then
begin
  if pos(' ', newKreditTek) <> 0 then
  begin
     newKreditTek:= trim(newKreditTek);
     LabelEdit1.Text:=newKreditTek;
  end;
  if ((pos('-', newKreditTek) <> 0) and (pos('-', newKreditTek) <> 1))
      or (pos(' ', newKreditTek) <> 0) then
  begin
     Application.MessageBox
      ('Проверте правильность введенных данных!','Ошибка',0);
     LabelEdit1.SetFocus ;
  end
  else
  begin
    kreditTek:=newKreditTek;
    LabelEdit5.Text:= SendStr.StrTo00(SendStr.CreditUpdate(id,kreditTek));
  end;
end;
end;

procedure Tcard.LabelEditPasswordChange(Sender: TObject);
begin
  if (Length(LabelEditPassword.text)>11) then
  begin
    Application.MessageBox
      ('Длина пароля не более 11 символов!','Ошибка',0);
    LabelEditPassword.SetFocus ;
  end
  else
  begin
    password:=trim(LabelEditPassword.text);
  end;

end;

end.

