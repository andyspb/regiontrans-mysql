unit FormSendu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Sqlcombo, LblCombo, Lbledit, Lbsqlcmb, Sqlctrls,
  LblEdtDt, ExtCtrls, ComCtrls,Tadjform, Grids, Buttons, BMPBtn, ToolWin,
  LblMemo, Lblint, LblEditMoney,DBTables,SqlGrid,TSQLCLS, DB, DBGrids,
  OleServer, Word2000, Menus,QPrinters, DateUtils, EntrySec;

type
  TFormSend = class(TForm)
    ToolBar1: TToolBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    RadioGroup1: TRadioGroup;
    LabelEditDate1: TLabelEditDate;
    cbType: TLabelSQLComboBox;
    LabelEdit1: TLabelEdit;
    cbPynkt: TLabelSQLComboBox;
    LabelEditDate2: TLabelEditDate;
    cbGryz: TLabelSQLComboBox;
    GroupBox1: TGroupBox;
    cbZak: TSQLComboBox;
    LabelEdit4: TLabelEdit;
    LabelEdit5: TLabelEdit;
    LabelEdit6: TLabelEdit;
    GroupBox2: TGroupBox;
    cbOtpr: TSQLComboBox;
    LabelEdit2: TLabelEdit;
    GroupBox3: TGroupBox;
    cbPolych: TSQLComboBox;
    LabelEdit3: TLabelEdit;
    LabelEdit7: TLabelEdit;
    LabelEdit8: TLabelEdit;
    GroupBox4: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    GroupBox5: TGroupBox;
    LabelSQLComboBox1: TLabelSQLComboBox;
    GroupBox6: TGroupBox;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    btOk: TBMPBtn;
    btPrint: TBMPBtn;
    btCansel: TBMPBtn;
    cbPayType: TLabelSQLComboBox;
    eNmberOrder: TLabelEdit;
    eNumberCountPattern: TLabelEdit;
    LabelMemo1: TLabelMemo;
    LabelMemo2: TLabelMemo;
    LabelEditDate3: TLabelEditDate;
    cbSupplier: TLabelSQLComboBox;
    eWieght: TLabelInteger;
    eTariff: TLblEditMoney;
    eFare: TLblEditMoney;
    eSumCount: TLblEditMoney;
    cbSendType: TLabelSQLComboBox;
    CheckBox5: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox6: TCheckBox;
    eAddServicePrace: TLblEditMoney;
    LblEditMoney1: TLblEditMoney;
    LblEditMoney2: TLblEditMoney;
    LabelInteger2: TLabelInteger;
    Query1: TQuery;
    UpdateSQL1: TUpdateSQL;
    DataSource1: TDataSource;
    Query1Name: TStringField;
    Query1Count: TIntegerField;
    Query1Send_Ident: TIntegerField;
    eVolume: TLblEditMoney;
    eExpCount: TLblEditMoney;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    WordApplication1: TWordApplication;
    cbForwarder: TLabelSQLComboBox;
    DBGrid1: TDBGrid;
    Query2: TQuery;
    DataSource2: TDataSource;
    UpdateSQL2: TUpdateSQL;
    Query2Send_Ident: TIntegerField;
    Query2PackName: TStringField;
    Query2Tariff: TStringField;
    DBGrid2: TDBGrid;
    LblEditMoney3: TLblEditMoney;
    Query2Count: TIntegerField;
    eInsurancePercent: TLblEditMoney;
    eInsuranceSum: TLblEditMoney;
    eInsuranceValue: TLblEditMoney;
    ePlace: TLabelEdit;
    LabelEdit10: TLabelEdit;
    cbNTrain: TLabelSQLComboBox;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    PopupMenu3: TPopupMenu;
    N7: TMenuItem;
    LabelEdit9: TLabelEdit;
    LabelEdit11: TLabelEdit;
    LblEditMoney4: TLblEditMoney;
    LblEditMoney5: TLblEditMoney;
    LabelEdit12: TLabelEdit;
    LabelInteger1: TLabelInteger;
    LabelEdit13: TLabelEdit;
    ePlac: TLabelInteger;
    PopupMenu4: TPopupMenu;
    N8: TMenuItem;
    cbTypeWay: TLabelSQLComboBox;
    cbTypeServ: TLabelSQLComboBox;
    BitBtn5: TBitBtn;
    eCountWieght: TLabelInteger;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    LabelEdit14: TLabelEdit;
    LblEditMoney6: TLblEditMoney;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    LabelEditDate4: TLabelEditDate;
    ePercent: TLabelInteger;
    procedure FormCreate(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btCanselClick(Sender: TObject);
    procedure cbZakChange(Sender: TObject);
    procedure cbOtprChange(Sender: TObject);
    procedure cbPolychChange(Sender: TObject);
    procedure cbPynktChange(Sender: TObject);
    procedure eWieghtChange(Sender: TObject);
    procedure eVolumeChange(Sender: TObject);
    procedure eTariffChange(Sender: TObject);
    procedure eCountWieghtChange(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure LabelInteger1Change(Sender: TObject);
    procedure LabelInteger2Change(Sender: TObject);
    procedure DataSource1UpdateData(Sender: TObject);
    procedure Query1CountChange(Sender: TField);
    procedure eInsuranceSumChange(Sender: TObject);
    procedure eInsurancePercentChange(Sender: TObject);
    procedure eFareChange(Sender: TObject);
    procedure LabelEditDate1Enter(Sender: TObject);
    procedure LabelEditDate1Exit(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure eAddServicePraceChange(Sender: TObject);
    procedure eInsuranceValueChange(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure LabelEditDate2Enter(Sender: TObject);
    procedure LabelEditDate2Exit(Sender: TObject);
    procedure LabelEditDate3Enter(Sender: TObject);
    procedure LabelEditDate3Exit(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure LblEditMoney3Change(Sender: TObject);
    procedure Query2CountChange(Sender: TField);
    procedure Query2PackNameSetText(Sender: TField; const Text: String);
    procedure Query2PackNameChange(Sender: TField);
    procedure Query2TariffChange(Sender: TField);
    procedure LabelSQLComboBox1Change(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure ePlaceChange(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure cbTypeExit(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure LblEditMoney6Change(Sender: TObject);
    procedure InsuranceSumMin;
    procedure CheckBox8Click(Sender: TObject);
    procedure RadioGroup1Exit(Sender: TObject);
    procedure ePercentExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function AddRecord:longint;
    function EditRecord(q:TQuery):longint;
    function CountWieght(Wieght,Volume:string):string;
    function CountWieghtGD(Wieght:string):string;
    function Fare(Tariff,CountWieght:string):string;
    function addService:string;
    Function Numbercalc:string;
  end;

var
  FormSend: TFormSend;
  SendIdent: longint;
  Number: string;
  DateTest: string;
  all: boolean;
  send_table: string;
  sends_view: string;
  send_table_other: string;
  sends_view_other: string;

implementation

uses Menu, FConstant,SendStr, FAddEdit,makerepp ,
ClientCardu, FormAcceptoru, FCity,Invoice, FInvoice, FormCalc, FAKT;

{$R *.dfm}

procedure TFormSend.FormCreate(Sender: TObject);
begin
  labelInteger2.Edit.BiDiMode:=bdLeftToRight;
  eWieght.Edit.BiDiMode:=bdLeftToRight;
//cbPynkt.SQLComboBox.Sorted:=true;
  cbPolych.Sorted:=true;
  if FMenu.CurrentUserroles = 1 then
    eNumberCountPattern.Enabled:=true
  else
    eNumberCountPattern.Enabled:=false;

  Caption:='Карточка отправки ( ' + EntrySec.period + ' )';
  all := EntrySec.bAllData;
  // btOk.Enabled := Iff(all, False, True);
  sends_view := iff(all, '`sends_all`', '`sends`');
  send_table := iff(all, '`send_all`', '`send`');
  sends_view_other := iff(not all, '`sends_all`', '`sends`');
  send_table_other := iff(not all, '`send_all`', '`send`');
end;

function TFormSend.AddRecord:longint;
var
  str, s: string;
  l: longInt;
  q: TQUEry;
  I: integer;
  fields: string;
  thread: TInsertThread;
label Next1;
begin
  Number:='';
  LabelEditDate1.text:=FormatDateTime('dd.mm.yyyy',now);
  LabelEdit1.text:=sql.selectstring('Inspector','PeopleFIO','Ident='+
                                   IntToStr(FMenu.CurrentUser));

  cbForwarder.Where:='Clients_Ident is Null';
  cbForwarder.SQLComboBox.Recalc;

  cbType.SetActive(2);
  cbSendType.SetActive(1);
  cbPayType.SetActive(1);
  cbTypeServ.SetActive(1);
  cbTypeWay.SetActive(1);
  cbZak.Where:='PersonType_Ident=1';
  cbZak.Recalc;

  Query1.Close;
  Query1.DatabaseName:=sql.DataBaseName;
  Query1.SQL.Clear;
  Query1.SQL.Add('select * from SendPack where Send_Ident is NULL');
  Query1.ExecSQL;
  query1.Open;

  Query2.Close;
  Query2.DatabaseName:=sql.DataBaseName;
  Query2.SQL.Clear;
  Query2.SQL.Add('select * from SendPackTariff where Send_Ident is NULL');
  Query2.ExecSQL;
  query2.Open;

  DBGrid2.Columns.Items[0].PickList.clear;
  DBGrid1.Columns.Items[0].PickList.clear;
  q := sql.Select('PackTariff','Name','','Name');
//eNumberCountPattern.Enabled:=false;

  while not q.Eof do
  begin
    s:=q.FieldByName('Name').AsString;
    DBGrid2.Columns.Items[0].PickList.add(s) ;
    q.Next;
  end;
  q:=sql.Select('PackType','Name','','Name');
  while not q.Eof do
  begin
    s:=q.FieldByName('Name').AsString;
    DBGrid1.Columns.Items[0].PickList.add(s) ;
    q.Next;
  end;
  q.Free;

  if ShowModal=mrOk then
  begin
    l:=sql.FindNextInteger('Ident',send_table,'',MaxLongint);

    str:=IntToStr(l)+','+IntToStr(RadioGroup1.ItemIndex)+
         ','+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)))+
         ','+IntToStr(FMenu.CurrentUser);

    //----------
    if cbType.SqlComboBox.GetData=0 then
      str:=str+','+'NULL'
    else
      str:=str+','+IntToStr(cbType.SqlComboBox.GetData);
    //----------
    if cbZak.GetData=0 then
      str:=str+','+'NULL'
    else
      str:=str+','+IntToStr(cbZak.GetData);
    //----------
    if cbOtpr.GetData=0 then
      str:=str+','+'NULL'
    else
      str:=str+','+IntToStr(cbOtpr.GetData);
    //----------
    if cbPynkt.SqlComboBox.GetData=0 then
      str:=str+','+'NULL'
    else
      str:=str+','+IntToStr(cbPynkt.SqlComboBox.GetData);
    //----------
    if LabelEditDate2.text<>'  .  .    ' then
      str:=str+','+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate2.text)))
    else
      str:=str+',NULL';
    //----------
    if cbPolych.GetData=0 then
      str:=str+','+'NULL'
    else
      str:=str+','+IntToStr(cbPolych.GetData);
    //----------
    if cbForwarder.SQLComboBox.GetData=0 then
      str:=str+','+'NULL'
    else
      str:=str+','+IntToStr(cbForwarder.SQLComboBox.GetData);
    //----------
    if LabelSqlComboBox1.SqlComboBox.GetData=0 then
      str:=str+','+'NULL'
    else
      str:=str+','+IntToStr(LabelSqlComboBox1.SqlComboBox.GetData);
    //----------
    if cbGryz.SqlComboBox.GetData=0 then
      str:=str+','+'NULL'
    else
      str:=str+','+IntToStr(cbGryz.SqlComboBox.GetData);
    //----------
    if CheckBox1.Checked then
      str:=str+','+IntToStr(1)
    else
      str:=str+','+IntToStr(0);
    //----------
    if CheckBox2.Checked then
      str:=str+','+IntToStr(1)
    else
      str:=str+','+IntToStr(0);
    //----------
    if CheckBox3.Checked then
      str:=str+','+IntToStr(1)
    else
      str:=str+','+IntToStr(0);
    //----------
    if CheckBox7.Checked then
      str:=str+','+IntToStr(1)
    else
      str:=str+','+IntToStr(0);
    //----------
    if CheckBox8.Checked then
      str:=str+','+IntToStr(1)
    else
      str:=str+','+IntToStr(0);
    //----------
    if trim(eWieght.text)<>'' then
      str:=str+','+trim(eWieght.text)
    else
      str:=str+','+'NULL';
    //----------
    if trim(eVolume.text)<>'' then
      str:=str+','+sql.MakeStr(trim(eVolume.text))
    else
      str:=str+','+'NULL';
    //----------
    if trim(eCountWieght.text)<>'' then
      str:=str+','+trim(eCountWieght.text)
    else
      str:=str+','+'NULL';
    //----------
    if trim(eTariff.text)<>'' then
      str:=str+','+sql.MakeStr(trim(eTariff.text))
    else
      str:=str+','+'NULL';
    //----------
    if trim(eFare.text)<>'' then
      str:=str+','+sql.MakeStr(trim(eFare.text) )      {провозная плата}
    else
      str:=str+','+'NULL';
    //----------
    if CheckBox4.Checked then              {экспедирование}
    begin
      str:=str+','+IntToStr(1);
      str:=str+','+SQL.MakeStr(trim(LBLEditMoney1.Text));
      str:=str+','+sql.Makestr(trim(eExpCount.text));
    end
    else
      str:=str+','+IntToStr(0)+',NULL,NULL';
    //----------
    if CheckBox5.Checked then     {упаковка}
    begin
      str:=str+','+IntToStr(1) ;
      str:=str+','+sql.MakeStr(trim(LBLEditMoney3.Text));
    end
    else
      str:=str+','+IntToStr(0)+','+sql.MakeStr('0.00');
    //----------
    if trim(ePlace.text)<>'' then
      str:=str+','+sql.MakeStr(trim(ePlace.text))
    else
      str:=str+',NULL';
    //----------
    if CheckBox6.Checked then
    begin                            {пропуска}
      str:=str+','+IntToStr(1) ;
      str:=str+','+sql.MakeStr(trim(LBLEditMoney2.Text));
      str:=str+','+trim(LabelInteger2.text);
    end
    else
      str:=str+','+IntToStr(0)+',NULL,NULL';
    //----------
    if trim(LabelEdit14.Text)<> '' then           {AddServStr}
      str:=str+','+sql.MakeStr(trim(LabelEdit14.text))
    else str:=str+',NULL';
    //----------
    if trim(LBLEditMoney6.Text)<> '0.00' then           {AddServSum}
      str:=str+','+sql.MakeStr(trim(LBLEditMoney6.text))
    else
      str:=str+',NULL';
    //----------
    if trim(eAddServicePrace.text)<>'' then
      str:=str+','+sql.MakeStr(trim(eAddServicePrace.text))
    else
      str:=str+','+'NULL';
    //----------
    if trim(eInsuranceSum.text)<>'' then
      str:=str+','+sql.MakeStr(trim(eInsuranceSum.text))
    else
      str:=str+','+'Null';
    //----------
    if trim(eInsurancePercent.text)<>'' then
      str:=str+','+sql.MakeStr(trim(eInsurancePercent.text))
    else
      str:=str+','+'Null';
    //----------
    if trim(eInsuranceValue.text)<>'' then
      str:=str+','+sql.MakeStr(trim(eInsuranceValue.text))
    else
      str:=str+','+'0.00';
    //----------
    if trim(eSumCount.text)<>'' then
      str:=str+','+sql.MakeStr(trim(eSumCount.text))
    else
      str:=str+','+'Null';
    //----------
    if cbPayType.SQLComboBox.GetData<>0 then
      str:=str+','+intToStr(cbPayType.SQLComboBox.GetData)
    else
      str:=str+','+'NULL';
    //----------
    if trim(eNmberOrder.text)<>'' then
      str:=str+','+sql.MakeStr(trim(eNmberOrder.text) )
    else
      str:=str+','+'NULL';
    //----------
    if trim(eNumberCountPattern.text)<>'' then
      str:=str+','+sql.MakeStr(trim(eNumberCountPattern.text))
    else
      str:=str+','+'NULL';
    //----------
    if trim(labelMemo1.Memo.Text)<>'' then
      str:=str+','''+trim(labelMemo1.Memo.text)+''''
    else
      str:=str+','+'NULL';
    //----------
    if cbSendType.SQLComboBox.GetData<>0 then
      str:=str+','+intToStr(cbSendType.SQLComboBox.GetData)
    else
      str:=str+','+'NULL';
    //----------
    if LabelEditDate3.text<>'  .  .    ' then
      str:=str+','+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDaTE(LabelEditDate3.text)))
    else
      str:=str+','+'NULL';
    //----------
    if cbSupplier.SQLComboBox.GetData<>0 then
      str:=str+','+intToStr(cbSupplier.SQLComboBox.GetData)
    else
      str:=str+','+'NULL';
    //----------
    if trim(labelMemo2.Memo.Text)<>'' then
      str:=str+','''+trim(labelMemo2.Memo.text)+''''
    else
      str:=str+','+'NULL';
    //----------
    str:=str+','+sql.MakeStr(trim(Number));
    //----------
    if trim(LabelEdit6.text)=''   then
      str:=str+','+'NULL'
    else
      str:=str+','+sql.MakeStr(trim(LabelEdit6.text));
    //----------
    if trim(LabelEdit5.text)=''   then
      str:=str+','+'NULL'
    else
      str:=str+','+sql.MakeStr(trim(LabelEdit5.text));
    //----------
    if cbNTrain.GetData=0 then
      str:=str+','+'NULL'
    else
      str:=str+','+IntToStr(cbNTrain.GetData);
    //----------
    if trim(LBLEditMoney4.text)='' then
      str:=str+','+'NULL'
    else
      str:=str+','+sql.MakeStr(trim(LBLEditMoney4.text));
    //----------
    if trim(LabelEdit9.text)='' then
      str:=str+','+'NULL'
    else
      str:=str+','+sql.MakeStr(trim(LabelEdit9.text));
    //----------
    if trim(LBLEditMoney5.text)='' then
      str:=str+','+'NULL'
    else
      str:=str+','+sql.MakeStr(trim(LBLEditMoney5.text));
    //----------
    if trim(LabelEdit11.text)='' then
      str:=str+','+'NULL'
    else
      str:=str+','+sql.MakeStr(trim(LabelEdit11.text));
    //----------
    if trim(LabelEdit12.text)='' then
      str:=str+','+'NULL'
    else
      str:=str+','+sql.MakeStr(trim(LabelEdit12.text));
    //----------
    if trim(LabelInteger1.text)='' then
      str:=str+','+'NULL'
    else
      str:=str+','+trim(LabelInteger1.text);
    //----------
    if trim(LabelEdit13.text)='' then
      str:=str+','+'NULL'
    else
      str:=str+','+sql.MakeStr(trim(LabelEdit13.text));
    //----------
    I:=0;
    if  (trim(eFare.text)<>'') and (trim(eFare.text)<>'0.00')then
    begin
      if cbType.GetData=1 then
        I:=I+3;
      if cbType.GetData=2 then
        I:=I+2;
    end;
    //----------
    if (checkBox5.checked) and (trim(LBLEditMoney3.text)<>'')and (trim(LBLEditMoney3.text)<>'0.00') then
      I:=I+2;
    //----------
    if (trim(eInsuranceValue.text)<>'') and(trim(eInsuranceValue.text)<>'0.00') then
      I:=I+2;
    //----------
    if I<>0 then
      I:=I+1;
    //----------
    if I=0 then
      str:=str+','+'0'
    else
      str:=str+','+IntToStr(I);
    //----------
    if trim(ePlac.text)='' then
      str:=str+','+'NULL'
    else
      str:=str+','+trim(ePlac.Text);
    //----------
    if cbTypeServ.GetData<>0 then
      str:=str+','+IntToStr(cbTypeServ.GetData)
    else
      str:=str+','+'NULL';
    //----------
    if cbTypeWay.GetData<>0 then
      str:=str+','+IntToStr(cbTypeWay.GetData)
    else
      str:=str+','+'NULL';
    //----------
    {CutTariff}
    if trim(ePercent.text)='' then
      str:=str+','+'0'
    else
      str:=str+','+trim(ePercent.text);
    //----------
    str:=str+','+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate4.text)));
    //----------
    fields:= 'Ident,Check,`Start`,Inspector_Ident,ContractType_Ident,'+
                  'Client_Ident,Client_Ident_Sender,City_Ident,DateSend,'+
                  'Acceptor_Ident,Forwarder_Ident,RollOut_Ident,NameGood_Ident,'+
                  'TypeGood_Ident,TypeGood_Ident1,TypeGood_Ident2,TypeGood_Ident3,'+
                  'PrivilegedTariff,'+
                  'Weight,Volume,CountWeight,Tariff,Fare,AddServiceExp,'+
                  'ExpTarif,ExpCount,AddServicePack,PackTarif,PackCount,'+
                  'AddServiceProp,PropTarif,PropCount,AddServStr,AddServSum,'+
                  'AddServicePrace,'+
                  'InsuranceSum,InsurancePercent,InsuranceValue,SumCount,'+
                  'PayType_Ident,NmberOrder,NumberCountPattern,PayText,'+
                  'StatusSupp_Ident,DateSupp,Supplier_Ident,SuppText,Namber,'+
                  'Contract,Credit,Train_Ident,SumWay,NumberWay,SumServ'+
                  ',NumberServ,PlaceGd,WeightGd,NumberPP,CountInvoice,PlaceC,'+
                  'PayTypeServ_Ident,PayTypeWay_Ident,CutTarif,DateDelFirst';
    if (sql.InsertString(send_table, fields, str)<>0 )
       {and (sql.UpdateString('SendPack','Send_Ident='+IntToStr(l),'Send_Ident is NULL')<>0) }
    then
    begin
      AddRecord:=0;
      exit;
    end
    else
    begin
      // success
      Addrecord:=l;
      thread:= TInsertThread.Create(True, send_table_other, fields, str);
      thread.Resume();
    end;
    //----------
    if sql.UpdateString('SendPack','Send_Ident='+IntToStr(l),
                     'Send_Ident is NULL')<>0 then
    begin
      AddRecord:=0;
      exit;
    end;
    //----------
    if sql.UpdateString('Clients','Forwarder_Ident='+IntToStr(cbForwarder.SQLComboBox.GetData)+
                  ',NameGood_Ident='+IntToStr(cbGryz.GetData),
                  'Ident='+IntToStr(cbZak.GetData))<>0 then
    begin
      AddRecord := 0;
      exit;
    end;
    //----------
    if sql.UpdateString('SendPackTariff','Send_Ident='+IntToStr(l),
                     'Send_Ident is NULL')<>0 then
    begin
      AddRecord := 0;
      exit
    end;
    //----------
  end
  else
    AddRecord:=0;
  //----------
  q := sql.Select('ClientsTek','','Ident='+IntToStr(cbZak.getData),'') ;
  if (not q.eof) then
  begin
    q.Free;
    if Invoice.InvoiceTest(cbZak.getData,Now) then
    begin
      case Application.MessageBox('Пора распечатать акт! Подтвердите печать!',
                            'Сообщение',MB_YESNO+MB_ICONQUESTION) of
      IDYES:
      begin
        FormAkt:=TFormAkt.Create(Application) ;
        FormAkt.AddRecord(Id);
        FormAkt.Free;
      end;
      IDNO:
      begin
        goto next1 ;
        exit
      end;
    end;
  end;

  end
  else
  begin
    q.Free;
    if Invoice.InvoiceTest(cbZak.getData,Now) then
    begin
        case Application.MessageBox('Пора распечатать счет фактуру! Подтвердите печать!',
                            'Сообщение',MB_YESNO+MB_ICONQUESTION) of
        IDYES:
        begin
          FormInvoice:=TFormInvoice.Create(Application) ;
          FormInvoice.AddRecord(cbZak.getdata);
          FormInvoice.Free;
        end;
        IDNO:
        begin
          goto next1 ;
          exit
        end;
      end;
    end;
  end;
  Next1:
end;

function TFormSend.EditRecord(q:TQuery):longint;
var str,s:string;
     q1:Tquery;
     I:integer;
     //l:longint;
     thread: TUpdateThread;
label Next1;
begin
 SendIdent:=q.FieldByName('Ident').asInteger;
 RadioGroup1.ItemIndex:=q.FieldByName('Check').asInteger;
 if  RadioGroup1.ItemIndex=0 then
 begin
   cbZak.Where:='PersonType_Ident=1' ;
   cbZak.Recalc
 end
 else begin
       cbZak.Where:='PersonType_Ident=2';
       cbZak.Recalc
      end;
 LabelEditDate1.Text:=FormatDateTime('dd.mm.yyyy',StrToDate(q.FieldByName('Start').asString));

 LabelEditDate1.Enabled:=false;
 LabelEdit1.text:=sql.selectstring('Inspector','PeopleFIO','Ident='+
                                   IntToStr(q.FieldByName('Inspector_Ident').asInteger));
 if q.FieldByName('ContractType_Ident').asString<>'' then
  cbType.SQLComboBox.setActive(q.FieldByName('ContractType_Ident').asInteger) ;
 FormSend.cbTypeChange(Self);
 if  q.FieldByName('Client_Ident').asString<>'' then
 begin
  cbZak.setActive(q.FieldByName('Client_Ident').asInteger) ;
  LabelEdit4.Visible:=true;
  LabelEdit5.Visible:=true;
  LabelEdit6.Visible:=true;
  LabelEdit4.Enabled:=false;
  LabelEdit5.Enabled:=false;
  LabelEdit6.Enabled:=false;
 end;
 if q.FieldByName('ClientPhone').asString<>'' then
   LabelEdit4.text:=q.FieldByName('ClientPhone').asString;
 if q.FieldByName('Credit').asString<>'' then
   LabelEdit5.text:=q.FieldByName('Credit').asString;
 if q.FieldByName('Contract').asString<>'' then
   LabelEdit6.text:=q.FieldByName('Contract').asString;

 if q.FieldByName('Client_Ident_Sender').asString<>'' then
 begin
   cbOtpr.setActive(q.FieldByName('Client_Ident_Sender').asInteger);
   LabelEdit2.Visible:=true;
   LabelEdit2.Enabled:=false;
 end;
 if q.FieldByName('ClientSenderPhone').asString<>'' then
   LabelEdit2.text:=q.FieldByName('ClientSenderPhone').asString;

 if q.FieldByName('City_Ident').asString<>'' then
 begin
   cbPynkt.SQLComboBox.setActive(q.FieldByName('City_Ident').asInteger);
   cbNTrain.Where:='City_Ident='+IntToStr(cbPynkt.GetData)+' and Arch<>1';
 end;

 if q.FieldByName('DateSend').asString<>'' then
   LabelEditDate2.Text:=FormatDateTime('dd.mm.yyyy',StrToDate(q.FieldByName('DateSend').asString));
 S:='';
 s:= sql.selectstring(send_table,'DateDelFirst','Ident='+q.FieldByName('Ident').asstring);
 if s<> ''
 then
 LabelEditDate4.Text:=FormatDateTime('dd.mm.yyyy',StrToDate(sql.selectstring(send_table,
                                     'DateDelFirst','Ident='+q.FieldByName('Ident').asString)))
 else  if q.FieldByName('DateSend').asString<>'' then
 LabelEditDate4.Text:=FormatDateTime('dd.mm.yyyy',IncDay(StrToDate(q.FieldByName('DateSend').asString),1))
  else LabelEditDate4.Text:=FormatDateTime('dd.mm.yyyy',IncDay(StrToDate(q.FieldByName('Start').asString),1));
 s:='';
 if q.FieldByName('Acceptor_Ident').asString<>'' then
 begin
   cbPolych.setActive(q.FieldByName('Acceptor_Ident').asInteger);
   LabelEdit3.Visible:=true;
   LabelEdit7.Visible:=true;
   LabelEdit8.Visible:=true;
   LabelEdit3.Enabled:=false;
   LabelEdit7.Enabled:=false;
   LabelEdit8.Enabled:=false;
 end;
 if q.FieldByName('AcceptorPhone').asString<>'' then
   LabelEdit3.text:=q.FieldByName('AcceptorPhone').asString;
 if q.FieldByName('AcceptorAddress').asString<>'' then
   LabelEdit7.text:=q.FieldByName('AcceptorAddress').asString;
 if q.FieldByName('AcceptorRegime').asString<>'' then
   LabelEdit8.text:=q.FieldByName('AcceptorRegime').asString;

 if q.FieldByName('Client_Ident').asInteger<>0 then
 begin
 cbForwarder.Where:='Clients_Ident='+IntToStr(q.FieldByName('Client_Ident').asInteger);
 cbForwarder.SQLComboBox.Recalc;
 end;
 if q.FieldByName('Forwarder_Ident').asInteger<>0 then
   cbForwarder.SetActive(q.FieldByName('Forwarder_Ident').asInteger);

 if q.FieldByName('RollOut_Ident').asString<>'' then
   LabelSQLComboBox1.SQLComboBox.setActive(q.FieldByName('RollOut_Ident').asInteger);
 if q.FieldByName('NameGood_Ident').asString<>'' then
   cbGryz.SQLComboBox.setActive(q.FieldByName('NameGood_Ident').asInteger);

 if  q.FieldByName('TypeGood_Ident').asInteger=1 then
     CheckBox1.Checked:=true;
 if  q.FieldByName('TypeGood_Ident1').asInteger=1 then
     CheckBox2.Checked:=true;
 if  q.FieldByName('TypeGood_Ident2').asInteger=1 then
     CheckBox3.Checked:=true;
 if  sql.SelectInteger(send_table,'TypeGood_Ident3','Ident='+IntToStr(SendIdent))=1 then
     CheckBox7.Checked:=true;

 if  sql.SelectInteger(send_table,'PrivilegedTariff','Ident='+IntToStr(SendIdent))=1 then
     CheckBox8.Checked:=true;

 eWieght.Text:=trim(q.FieldByName('Weight').asString)   ;
 eVolume.Text:=trim(q.FieldByName('Volume').asString);
 eCountWieght.Text:=trim(q.FieldByName('CountWeight').asString);
 eTariff.Text:=trim(q.FieldByName('Tariff').asString);
 ePercent.text:= trim(q.FieldByName('CutTarif').asString);

   ePlac.SetValue(q);
 if trim(q.FieldByName('PackCount').asString)<>'' then
   ePlace.text:=trim(q.FieldByName('PackCount').asString);
 eFare.Text:=trim(q.FieldByName('Fare').asString);


 Query1.Close;
 Query1.DatabaseName:=sql.DataBaseName;
 Query1.SQL.Clear;
 Query1.SQL.Add('select * from SendPack where Send_Ident='+
                 IntToStr(SendIdent));
 Query1.ExecSQL;
 query1.Open;

 if  q.FieldByName('AddServicePack').asInteger=1 then
     CheckBox5.Checked:=true;
 Query2.Close;
 Query2.DatabaseName:=sql.DataBaseName;
 Query2.SQL.Clear;
 Query2.SQL.Add('select * from SendPackTariff where Send_Ident='+
                 IntToStr(SendIdent));
 Query2.ExecSQL;
 query2.Open;
//---
 DBGrid2.Columns.Items[0].PickList.clear;
DBGrid1.Columns.Items[0].PickList.clear;
q1:=sql.Select('PackTariff','Name','','Name');

while not q1.Eof do
begin
   s:=q1.FieldByName('Name').AsString;
   DBGrid2.Columns.Items[0].PickList.add(s) ;
   q1.Next;
end;
q1:=sql.Select('PackType','Name','','Name');
while not q1.Eof do
begin
   s:=q1.FieldByName('Name').AsString;
   DBGrid1.Columns.Items[0].PickList.add(s) ;
   q1.Next;
end;
q1.Free;
//---
 if (trim(q.FieldByName('PackTarif').asString) <> '') then
   LblEditMoney3.text:=trim(q.FieldByName('PackTarif').asString);

 if (q.FieldByName('AddServiceExp').asInteger = 1) then
     CheckBox4.Checked:=true;
 if (trim(q.FieldByName('ExpTarif').asString) <> '') then
   LblEditMoney1.text:=trim(q.FieldByName('ExpTarif').asString);
 if (trim(q.FieldByName('ExpCount').asString) <> '') then
   eExpCount.text:=trim(q.FieldByName('ExpCount').asString);


 if (q.FieldByName('AddServiceProp').asInteger = 1) then
     CheckBox6.Checked := true;
 if trim(q.FieldByName('PropTarif').asString)<>'' then
   LblEditMoney2.text:=trim(q.FieldByName('PropTarif').asString);
 if trim(q.FieldByName('PropCount').asString)<>'' then
   LabelInteger2.text:=trim(q.FieldByName('PropCount').asString);
  if trim(q.FieldByName('AddServStr').asString)<>'' then
   LabelEdit14.text:=trim(q.FieldByName('AddServStr').asString); {AddServStr}
 LblEditMoney6.SetValue(q);      {AddServSum}

 if (trim(q.FieldByName('AddServicePrace').asString)<>'') and
    (trim(q.FieldByName('AddServicePrace').asString)<>'0.00') then
 begin
   eAddServicePrace.text:=trim(q.FieldByName('AddServicePrace').asString);
   eAddServicePrace.Visible:=true;
 end;

 if trim(q.FieldByName('InsuranceSum').asString)<>'' then
   eInsuranceSum.text:=trim(q.FieldByName('InsuranceSum').asString);
 if trim(q.FieldByName('InsurancePercent').asString)<>'' then
   eInsurancePercent.text:=trim(q.FieldByName('InsurancePercent').asString);
 if trim(q.FieldByName('InsuranceValue').asString)<>'' then
  begin
   eInsuranceValue.Visible:=true;

   eInsuranceValue.text:=trim(q.FieldByName('InsuranceValue').asString);
  end;
 
 if trim(q.FieldByName('SumCount').asString)<>'' then
   eSumCount.text:=trim(q.FieldByName('SumCount').asString);

///------------------------------------

 if q.FieldByName('PayType_Ident').asString<>'' then
   cbPayType.SQLComboBox.setActive(q.FieldByName('PayType_Ident').asInteger);
 if trim(q.FieldByName('NmberOrder').asString)<>'' then
   eNmberOrder.text:=trim(q.FieldByName('NmberOrder').asString);
 if trim(q.FieldByName('NumberCountPattern').asString)<>'' then
   eNumberCountPattern.text:=trim(q.FieldByName('NumberCountPattern').asString);
  LabelMemo1.SetValue(q);


////------------------------------------

 if q.FieldByName('StatusSupp_Ident').asString<>'' then
   cbSendType.SQLComboBox.setActive(q.FieldByName('StatusSupp_Ident').asInteger);
 if q.FieldByName('DateSupp').asString<>'' then
   LabelEditDate3.Text:=FormatDateTime('dd.mm.yyyy',StrToDate(q.FieldByName('DateSupp').asString));
 if q.FieldByName('Supplier_Ident').asString<>'' then
   cbSupplier.SQLComboBox.setActive(q.FieldByName('Supplier_Ident').asInteger);
  LabelMemo2.SetValue(q);

 Number:=q.FieldByName('Namber').asString  ;
////---------------------------
if q.FieldByName('ContractType_Ident').asInteger=1 then
begin
 LblEditMoney4.SetValue(q);
 LabelEdit9.SetValue(q);
 LblEditMoney5.SetValue(q);
 LabelEdit11.SetValue(q);
 LabelEdit12.SetValue(q);
 LabelInteger1.SetValue(q);
 LabelEdit13.SetValue(q);
 cbTypeServ.SetValue(q);
 cbTypeWay.SetValue(q);
 cbNTrain.SetValue(q);
end;
////----------------------------

if ShowModal=mrOk then
 begin


   str:='`Check`='+IntToStr(RadioGroup1.ItemIndex)+
         ',`Start`='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text)));
 //        ',Inspector_Ident='+IntToStr(FMenu.CurrentUser);

   if cbType.SqlComboBox.GetData=0 then
    str:=str+',ContractType_Ident='+'NULL'
    else str:=str+',ContractType_Ident='+IntToStr(cbType.SqlComboBox.GetData);

   if cbZak.GetData=0 then
    str:=str+',Client_Ident='+'NULL'
    else str:=str+',Client_Ident='+IntToStr(cbZak.GetData);

   if trim(LabelEdit6.text)=''   then
    str:=str+',Contract='+'NULL'
    else str:=str+',Contract='+sql.MakeStr(trim(LabelEdit6.text));

   if trim(LabelEdit5.text)=''   then
    str:=str+',Credit='+'NULL'
    else str:=str+',Credit='+sql.MakeStr(trim(LabelEdit5.text));

   if cbOtpr.GetData=0 then
    str:=str+',Client_Ident_Sender='+'NULL'
    else str:=str+',Client_Ident_Sender='+IntToStr(cbOtpr.GetData);

   if cbPynkt.SqlComboBox.GetData=0 then
    str:=str+',City_Ident='+'NULL'
    else str:=str+',City_Ident='+IntToStr(cbPynkt.SqlComboBox.GetData);

  if LabelEditDate2.text<>'  .  .    ' then
   str:=str+',DateSend='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate2.text)))
     else str:=str+',DateSend=NULL';

   if cbPolych.GetData=0 then
    str:=str+',Acceptor_Ident='+'NULL'
    else str:=str+',Acceptor_Ident='+IntToStr(cbPolych.GetData);

   if cbForwarder.SQLComboBox.GetData=0 then
    str:=str+',Forwarder_Ident='+'NULL'
    else str:=str+',Forwarder_Ident='+IntToStr(cbForwarder.SQLComboBox.GetData);

   if LabelSqlComboBox1.SqlComboBox.GetData=0 then
    str:=str+',RollOut_Ident='+'NULL'
    else str:=str+',RollOut_Ident='+IntToStr(LabelSqlComboBox1.SqlComboBox.GetData);

   if cbGryz.SqlComboBox.GetData=0 then
    str:=str+',NameGood_Ident='+'NULL'
    else str:=str+',NameGood_Ident='+IntToStr(cbGryz.SqlComboBox.GetData);

   if CheckBox1.Checked then
   str:=str+',TypeGood_Ident='+IntToStr(1)
     else str:=str+',TypeGood_Ident='+IntToStr(0);

   if CheckBox2.Checked then
   str:=str+',TypeGood_Ident1='+IntToStr(1)
     else str:=str+',TypeGood_Ident1='+IntToStr(0);

   if CheckBox3.Checked then
   str:=str+',TypeGood_Ident2='+IntToStr(1)
     else str:=str+',TypeGood_Ident2='+IntToStr(0);

   if CheckBox7.Checked then
   str:=str+',TypeGood_Ident3='+IntToStr(1)
     else str:=str+',TypeGood_Ident3='+IntToStr(0);

   if CheckBox8.Checked then
   str:=str+',PrivilegedTariff='+IntToStr(1)
     else str:=str+',PrivilegedTariff='+IntToStr(0);

   if trim(eWieght.text)<>'' then
   str:=str+',Weight='+trim(eWieght.text)
    else  str:=str+',Weight='+'NULL';

   if trim(eVolume.text)<>'' then
   str:=str+',Volume='+sql.MakeStr(trim(eVolume.text ))
    else  str:=str+',Volume='+'NULL';

   if trim(eCountWieght.text)<>'' then
   str:=str+',CountWeight='+trim(eCountWieght.text)
    else  str:=str+',CountWeight='+'NULL';

   if trim(eTariff.text)<>'' then
   str:=str+',Tariff='+sql.MakeStr(trim(eTariff.text))
    else str:=str+',Tariff='+'NULL';

   if trim(eFare.text)<>'' then
   str:=str+',Fare='+sql.MakeStr(trim(eFare.text) )
    else str:=str+',Fare='+'NULL';

   if CheckBox4.Checked then              {экспедирование}
   begin
   str:=str+',AddServiceExp='+IntToStr(1);
   str:=str+',ExpTarif='+SQL.MakeStr(trim(LBLEditMoney1.Text));
   str:=str+',ExpCount='+sql.MakeStr(trim(eExpCount.text));
   end
     else
          str:=str+',AddServiceExp='+IntToStr(0)+',ExpTarif=NULL,ExpCount=NULL';

   if CheckBox5.Checked then     {упаковка}
   begin
   str:=str+',AddServicePack='+IntToStr(1) ;
   str:=str+',PackTarif='+sql.MakeStr(trim(LBLEditMoney3.Text));
   //str:=str+',PackCount='+LabelInteger3.text;
   end
     else str:=str+',AddServicePack='+IntToStr(0)+',PackTarif='+sql.MakeStr('0.00');//,PackCount=NULL';

   if trim(ePlace.text)<>'' then
   str:=str+',PackCount='+sql.MakeStr(trim(ePlace.text))
    else str:=str+',PackCount=NULL';

   if CheckBox6.Checked then
   begin                            {пропуска}
   str:=str+',AddServiceProp='+IntToStr(1) ;
   str:=str+',PropTarif='+sql.MakeStr(trim(LBLEditMoney2.Text));
   str:=str+',PropCount='+trim(LabelInteger2.text);
   end
     else str:=str+',AddServiceProp='+IntToStr(0)+',PropTarif=NULL,PropCount=NULL';

   if trim(LabelEdit14.text)<>'' then
   str:=str+',AddServStr='+sql.MakeStr(trim(LabelEdit14.text))
    else str:=str+',AddServStr='+'NULL';

   if trim(LblEditMoney6.text)<>'0.00' then
   str:=str+',AddServSum='+sql.MakeStr(trim(LblEditMoney6.text))
    else str:=str+',AddServSum='+'NULL';


   if trim(eAddServicePrace.text)<>'' then
   str:=str+',AddServicePrace='+sql.MakeStr(trim(eAddServicePrace.text))
    else str:=str+',AddServicePrace='+'NULL';

   if trim(eInsuranceSum.text)<>'' then
   str:=str+',InsuranceSum='+sql.MakeStr(trim(eInsuranceSum.text))
     else str:=str+',InsuranceSum='+'Null';

   if trim(eInsurancePercent.text)<>'' then
   str:=str+',InsurancePercent='+sql.MakeStr(trim(eInsurancePercent.text))
     else str:=str+',InsurancePercent='+'Null';

   if trim(eInsuranceValue.text)<>'' then
   str:=str+',InsuranceValue='+sql.MakeStr(trim(eInsuranceValue.text))
     else str:=str+',InsuranceValue='+'0.00';

   if trim(eSumCount.text)<>'' then
   str:=str+',SumCount='+sql.MakeStr(trim(eSumCount.text))
     else str:=str+',SumCount='+'Null';
 ///------------

 if cbPayType.SQLComboBox.GetData<>0 then
  str:=str+',PayType_Ident='+intToStr(cbPayType.SQLComboBox.GetData)
   else str:=str+',PayType_Ident='+'NULL';

 if trim(eNmberOrder.text)<>'' then
  str:=str+',NmberOrder='+sql.MakeStr(trim(eNmberOrder.text))
   else str:=str+',NmberOrder='+'NULL';

 if trim(eNumberCountPattern.text)<>'' then
  str:=str+',NumberCountPattern='+sql.MakeStr(trim(eNumberCountPattern.text))
   else str:=str+',NumberCountPattern='+'NULL';

 if trim(labelMemo1.Memo.Text)<>'' then
   str:=str+',PayText='''+trim(labelMemo1.Memo.text)+''''
    else  str:=str+',PayText='+'NULL';

 ///--------------------


  if cbSendType.SQLComboBox.GetData<>0 then
  str:=str+',StatusSupp_Ident='+intToStr(cbSendType.SQLComboBox.GetData)
   else str:=str+',StatusSupp_Ident='+'NULL';

  if LabelEditDate3.text<>'  .  .    ' then
  str:=str+',DateSupp='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDaTE(LabelEditDate3.text)))
   else str:=str+',DateSupp='+'NULL';

  if cbSupplier.SQLComboBox.GetData<>0 then
  str:=str+',Supplier_Ident='+intToStr(cbSupplier.SQLComboBox.GetData)
   else str:=str+',Supplier_Ident='+'NULL';

 if trim(labelMemo2.Memo.Text)<>'' then
   str:=str+',SuppText='''+trim(labelMemo2.Memo.text)+''''
    else  str:=str+',SuppText='+'NULL';
  ///--------------------

  str:=str+',Namber='+sql.MakeStr(Number);
 ///---------------
  if cbNTrain.GetData=0 then
   str:=str+',Train_Ident='+'NULL'
   else str:=str+',Train_Ident='+IntToStr(cbNTrain.GetData);
 ///-----------------
 if trim(LBLEditMoney4.text)='' then
   str:=str+',SumWay='+'NULL'
   else str:=str+',SumWay='+sql.MakeStr(trim(LBLEditMoney4.text));
 if trim(LabelEdit9.text)='' then
   str:=str+',NumberWay='+'NULL'
   else str:=str+',NumberWay='+sql.MakeStr(trim(LabelEdit9.text));
 if trim(LBLEditMoney5.text)='' then
   str:=str+',SumServ='+'NULL'
   else str:=str+',SumServ='+sql.MakeStr(trim(LBLEditMoney5.text));
 if trim(LabelEdit11.text)='' then
   str:=str+',NumberServ='+'NULL'
   else str:=str+',NumberServ='+sql.MakeStr(trim(LabelEdit11.text));
 if trim(LabelEdit12.text)='' then
   str:=str+',PlaceGd='+'NULL'
   else str:=str+',PlaceGd='+sql.MakeStr(trim(LabelEdit12.text));
 if trim(LabelInteger1.text)='' then
   str:=str+',WeightGd='+'NULL'
   else str:=str+',WeightGd='+trim(LabelInteger1.text);
 if trim(LabelEdit13.text)='' then
   str:=str+',NumberPP='+'NULL'
   else str:=str+',NumberPP='+sql.MakeStr(trim(LabelEdit13.text));
//---------------------------------------------------------------------------------------
I:=0;
 if  (trim(eFare.text)<>'') and (trim(eFare.text)<>'0.00')then
 begin
     if cbType.GetData=1 then I:=I+3;
     if cbType.GetData=2 then I:=I+2;
 end;
 if (checkBox5.checked) and (trim(LBLEditMoney3.text)<>'')and (trim(LBLEditMoney3.text)<>'0.00')
  then    I:=I+2;
 if (trim(eInsuranceValue.text)<>'') and(trim(eInsuranceValue.text)<>'0.00')
  then I:=I+2;
 if I<>0 then I:=I+1;
 if I=0 then
   str:=str+',CountInvoice='+'NULL'
   else str:=str+',CountInvoice='+IntToStr(I);
 ///------------------
if trim(eplac.text)='' then
  str:=str+',PlaceC=NULL'
  else str:=str+',PlaceC='+trim(ePlac.Text);
//-------------------------------------------------------------------
 if cbTypeServ.GetData<>0 then
    str:=str+',PayTypeServ_Ident='+IntToStr(cbTypeServ.GetData)
    else str:=str+',PayTypeServ_Ident='+'NULL';
  if cbTypeWay.GetData<>0 then
    str:=str+',PayTypeWay_Ident='+IntToStr(cbTypeWay.GetData)
    else str:=str+',PayTypeWay_Ident='+'NULL';
//-------------------------------------
{CutTariff}
if trim(ePercent.text)='' then
   str:=str+','+'CutTarif=0'
   else str:=str+',CutTarif='+trim(ePercent.text);
//--------------------------------------
if LabelEditDate4.text<>'  .  .    ' then
   str:=str+',DateDelFirst='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate4.text)))
     else str:=str+',DateDelFirst=NULL';
//-----------------------------------------------
 if (sql.UpdateString(send_table,str,'Ident='+IntToStr(SendIdent))<>0 )

   then EditRecord:=0
 else begin
  // success
  Editrecord:=SendIdent;
   // update in other table
  thread:= TUpdateThread.Create(True, send_table_other, str, 'Ident='+IntToStr(SendIdent));
  thread.Resume();

 str:=sql.SelectString('SendPack','Name','Send_Ident is null and Name=''коробка''');
 if sql.UpdateString('SendPack','Send_Ident='+IntToStr(SendIdent),
                     'Send_Ident is NULL')<>0 then editRecord:=0 ;
 if sql.UpdateString('Clients','Forwarder_Ident='+IntToStr(cbForwarder.SQLComboBox.GetData)+
                  ',NameGood_Ident='+IntToStr(cbGryz.GetData),
                  'Ident='+IntToStr(cbZak.GetData))<>0 then editRecord:=0 ;
 if sql.UpdateString('SendPackTariff','Send_Ident='+IntToStr(SendIdent),
                     'Send_Ident is NULL')<>0 then editRecord:=0 ;

 end;
 end
 else editRecord:=0 ;
q1:=sql.Select('ClientsTek','','Ident='+IntToStr(cbZak.getData),'') ;
if (not q1.eof) then
begin
q1.Free;
 if Invoice.InvoiceTest(cbZak.getData,Now) then
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
else begin
q1.Free;

 if Invoice.InvoiceTest(cbZak.getData,Now) then
begin
case Application.MessageBox('Пора распечатать счет фактуру! Подтвердите печать!',
                            'Сообщение',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
     FormInvoice:=TFormInvoice.Create(Application) ;
     FormInvoice.AddRecord(cbZak.getdata);
     FormInvoice.Free;
    end;
    IDNO:begin
         goto next1 ;
         exit
         end;
end;
end;
end;
Next1:
end;

procedure TFormSend.btOkClick(Sender: TObject);
var l:longint;
    val:string;
    q:TQUERY;
    S1:real;
    S2:real;
Label T1;    
begin
//S1:=0;
//S2:=0;
Query1.ApplyUpdates;
if (trim(eInsuranceSum.Text) = '') or (trim(eInsuranceSum.text) = '0.00')
    or (trim(eInsuranceSum.text) = '0') then
 begin
    application.MessageBox('Объявленная ценность не может быть равна 0!'+
                            ' Проверьте правильность введенных сумм!','Ошибка',0);
    eInsuranceSum.setfocus;
    exit;
end;
if CheckBox5.Checked then
  Query2.ApplyUpdates;

s1:=StrToFloat(trim(eFare.Text));

if cbType.SQLComboBox.GetData=1 then        {проверка для жд перевозок,
                   чтобы сумма заплаченная жд не превышала суммы взятой с клеента}
  S2:=StrToFloat(trim(LblEditMoney4.text))+StrToFloat(trim(LblEditMoney5.text))
else
  S2:=0;

//--------{криминальный случай: сумма взятая ж/д больше суммы взятой с клиента }
if S1<S2 then
begin
    application.MessageBox('Сумма за дорогу и услуги дороги превышает сумму провозной платы!'+
                            ' Проверьте правильность введенных сумм!','Ошибка',0);
     PageControl1.ActivePage:=TabSheet3;
     LblEditMoney4.setfocus;
    exit;
end;
//--------{не критичный: вознаграждение за организацию перевозки оказалось ниже ожидаемого}
S1:=0.7*s1; {30% - то что пологается за организацию перевозки}
if s1<s2 then
begin
  ShowMessage('Сумма за дорогу и улуги дороги больше, чем предпологалось: '+
              'предпологалось(70% от провозной): '+StrTo00(FloatToStr(s1))+'; '+
              'получилась: '+StrTo00(FloatToStr(s2)))  ;
  case
  application.MessageBox('Исправить введенные суммы за дорогу и услуги?','Сообщение',
                         MB_YESNO+MB_ICONQUESTION) of
  IDYES:
    begin
     PageControl1.ActivePage:=TabSheet3;
     LblEditMoney4.setfocus;
     exit
    end;
    IDNO:begin
         goto T1 ;
         exit
         end;
   end;
end;
//////////////////////////////////////////////////////////////////////////

T1:            {метка выхода }
if LabelEditDate1.text='  .  .    '  then
begin
application.MessageBox('Введите дату отправки!','Ошибка',0);
LabelEditDate1.SetFocus;
exit;
end else
  begin
  if
   (trim(cbGryz.SQLComboBox.Text) <> '') and
   (cbGryz.SQLComboBox.ItemIndex =-1)
    then begin
    val:=trim(cbGryz.SQLComboBox.Text);
    q:=sql.select('NameGood','Ident','Name='+sql.MakeStr(val),'');
    if q.eof then
    begin
    l:=sql.FindNextInteger('Ident','NameGood','',maxlongint);
    if sql.InsertString('NameGood','Ident,Name',
           IntToStr(l)+','+ sql.MakeStr(val)) <> 0
       then exit
       else begin
            cbGryz.SQLComboBox.recalc;
            cbGryz.setactive(l);
            end;
     end else cbGryz.setactive(q.fieldByName('Ident').asInteger);
     q.Free;
    end ;
//--------------------------
   if
   (trim(cbSupplier.SQLComboBox.Text) <> '') and
   (cbSupplier.SQLComboBox.ItemIndex =-1)
    then begin
    val:=trim(cbSupplier.SQLComboBox.Text);
    q:=sql.select('Supplier','Ident','Name='+sql.MakeStr(val),'');
    if q.eof then
    begin
    l:=sql.FindNextInteger('Ident','Supplier','',maxlongint);
    if sql.InsertString('Supplier','Ident,Name',
           IntToStr(l)+','+ sql.MakeStr(val)) <> 0
       then exit
       else begin
            cbSupplier.SQLComboBox.recalc;
            cbSupplier.setactive(l);
            end;
     end else cbSupplier.setactive(q.fieldByName('Ident').asInteger);
     q.Free;
    end ;
 //-----
  if
   (trim(cbForwarder.SQLComboBox.Text) <> '') and
   (cbForwarder.SQLComboBox.ItemIndex =-1)
    then begin
    val:=trim(cbForwarder.SQLComboBox.Text);
    q:=sql.select('Forwarder','Ident','Name='+sql.MakeStr(val)+
                  ' and Clients_Ident='+IntToStr(cbZak.GetData),'');
    if q.eof then
    begin
    l:=sql.FindNextInteger('Ident','Forwarder','',maxlongint);
    if sql.InsertString('Forwarder','Ident,Name,Clients_Ident',
           IntToStr(l)+','+ sql.MakeStr(val)+','+IntToStr(cbZak.GetData)) <> 0
       then begin
              exit
            end
       else begin
            cbForwarder.SQLComboBox.recalc;
            cbForwarder.setactive(l);
            end;
     end else cbForwarder.setactive(q.fieldByName('Ident').asInteger);
     q.Free;
    end  ;

  Query1.CommitUpdates;
  Query2.CommitUpdates;
  if Number='' then Numbercalc
  else begin     {дополнительная проверка, не дать удалить номер сф из отправки, если не начальник}
    if ((sql.SelectString(send_table,'NumberCountPattern','Ident='+IntToStr(SendIdent)) <> '')
       and (trim(eNumberCountPattern.Text) = '') and (FMenu.CurrentUserRoles <> 1))
    then
    begin
      ShowMessage('Произошла попытка удалить номер счетфакутруры у отправки! '+
              'Закройте отправку не сохраняя! ');
      exit;
    end;  
  end;
  ModalResult:=mrOk;
  end;
end;

procedure TFormSend.btCanselClick(Sender: TObject);
begin
  case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
  IDYES: ModalResult:=mrCancel;
  IDNO:exit;
  end;
end;

procedure TFormSend.cbZakChange(Sender: TObject);
begin
if cbZak.getData<>0 then
begin
  LabelEdit2.Visible:=true;
  LabelEdit2.enabled:=false;
  {выставляем скидку}
  if sql.SelectString('Clients','SalePersent','Ident='+intToStr(cbZak.GetData))<>'' then
    ePercent.text := trim(sql.SelectString('Clients','SalePersent','Ident='+intToStr(cbZak.GetData)));
  If (sql.SelectInteger('ClientsTek','Ident','Ident='+intToStr(cbZak.GetData))<> 0)
    and (trim(ePercent.text) = '0' ) then
    ePercent.text := '5';

  if  (cbOtpr.GetData=0) or (cbOtpr.GetData=-1) then
  begin
    cbOtpr.SetActive(cbZak.getData);
    LabelEdit2.Text:=sql.SelectString('Clients','Telephone',
                                  'Ident='+intToStr(cbZak.GetData)) ;
  end;
  cbForwarder.Where:='Clients_Ident='+IntToStr(cbZak.GetData);
  cbForwarder.SQLComboBox.Recalc;
  cbForwarder.SetActive(sql.SelectInteger('Clients','Forwarder_Ident','Ident='+
                                        IntToStr(cbZak.GetData)));
  LabelEdit4.Visible:=true;
  LabelEdit6.Visible:=true;
  LabelEdit5.Visible:=true;
  LabelEdit4.enabled:=false;
  LabelEdit6.enabled:=false;
  LabelEdit5.enabled:=false;
  LabelEdit5.Text:=SendStr.StrTo00(SendStr.Credit(cbZak.GetData));
  LabelEdit4.Text:=sql.SelectString('Clients','Telephone',
                                  'Ident='+intToStr(cbZak.GetData)) ;
  if sql.SelectInteger('Clients','NameGood_Ident',
                     'Ident='+intToStr(cbZak.GetData))<>0 then
    cbGryz.SetActive(sql.SelectInteger('Clients','NameGood_Ident',
                                   'Ident='+intToStr(cbZak.GetData)));
  if cbType.getdata=0 then
  begin
    Application.MessageBox('Выберите тип перевозки!','Ошибка',0) ;
    cbType.SetFocus;
    exit;
  end
  else
    begin
      LabelEdit6.Text:=sql.SelectString('Contract','Number',
                                        'Clients_Ident='+IntToStr(cbZak.GetData)+
                                        ' and ContractType_Ident='+IntToStr(cbType.getdata));
    end
  end
  else
  begin
    if  (cbOtpr.GetData=0) or (cbOtpr.GetData=-1) then
    begin
      cbOtpr.SetActive(0);
      LabelEdit2.Visible:=false;
    end;
    LabelEdit4.Visible:=false;
    LabelEdit6.Visible:=false;
    LabelEdit5.Visible:=false;
    cbForwarder.Where:='Clients_Ident is NULL';
    cbForwarder.SQLComboBox.Recalc;
  end;
end;

procedure TFormSend.cbOtprChange(Sender: TObject);
begin
  if cbOtpr.getData<>0 then
  begin
    LabelEdit2.visible:=true;
    LabelEdit2.Text:=sql.SelectString('Clients','Telephone',
                                  'Ident='+intToStr(cbOtpr.GetData)) ;
  end
  else
  begin
    LabelEdit2.visible:=false;
  end;

end;

procedure TFormSend.cbPolychChange(Sender: TObject);
begin
  if cbPolych.GetData<>0 then
  begin
    labelEdit3.Visible:=true;
    labelEdit7.Visible:=true;
    labelEdit8.Visible:=true;
    labelEdit3.Text:=sql.SelectString('acceptor','Phone',
                                  'Ident='+IntToStr(cbPolych.GetData));
    labelEdit7.Text:=sql.SelectString('acceptor','Address',
                                  'Ident='+IntToStr(cbPolych.GetData));
    labelEdit8.Text:=sql.SelectString('acceptor','Regime',
                                  'Ident='+IntToStr(cbPolych.GetData));
  end
  else
  begin
    labelEdit3.Visible:=false;
    labelEdit7.Visible:=false;
    labelEdit8.Visible:=false;
  end;
end;

procedure TFormSend.cbPynktChange(Sender: TObject);
var
  day: string;
  query: TQuery;
  distance: string;
begin
  if cbPynkt.getdata<>0 then
  begin
    cbPolych.Visible:=true;
    eTariff.Visible:=true;
    cbPolych.Where:='City_Ident='+intToStr(cbPynkt.SQLComboBox.GetData);
    cbPolych.Recalc;
    if cbType.getdata=2 then    {автомобил}
    begin
      day:=sql.SelectString('City','Sending','Ident='+IntToStr(cbPynkt.GetData));
      if (day<>'')and (LabelEditDate2.Text='  .  .    ') then
        LabelEditDate2.Text:=FormatDateTime('dd.mm.yyyy',SToDate(day,StrToDate(LabelEditDate1.text)));
      eCountWieghtChange(Sender);
    end
  else
    if cbType.getdata=1 then   {железнодор}
    begin
      cbNTrain.Where:='City_Ident='+ IntToStr(cbPynkt.GetData)+' and Arch<>1';
      cbNTrain.SQLComboBox.Recalc;
      eCountWieghtChange(Sender) ;
      distance:=sql.selectstring('City','Distance','Ident='+IntToStr(cbPynkt.GetData));
      query:=sql.Select('TrainTariff','*','Distance>='+sql.MakeStr(distance),'Distance ASC');
      eTariff.text:=StrTo00(query.FieldByName('Tariff').AsString);
    end
    else
    begin
      Application.MessageBox('Выберите тип перевозки!','Ошибка',0);
      cbType.SetFocus;
      exit;
    end;
  end
  else
  begin
    eTariff.Visible:=false;
    cbPolych.Visible:=false;
  end;
end;

procedure TFormSend.eWieghtChange(Sender: TObject);
begin
  if cbType.getdata=2 then
  begin
    if (trim(eWieght.text)<>'0') and (trim(eVolume.text)<>'0.00') and (trim(eVolume.text)<>'0.0')
      and (trim(eWieght.text)<>'') and (trim(eVolume.text)<>'') and (trim(eVolume.text)<>'0.')
      and (trim(eVolume.text)<>'0') then
    begin
      eCountWieght.visible:=true;
      eCountWieght.Text:=CountWieght(trim(eWieght.text),trim(eVolume.text))
    end
    else
    begin
      eCountWieght.visible:=false;
      //    eCountWieght.text:='';
    end;
  end
  else
  begin
    if cbType.getdata=1 then
    begin
      if (trim(eWieght.text)<>'0')   and (trim(eWieght.text)<>'') then
      begin
        eCountWieght.visible:=true;
        eCountWieght.Text:=CountWieghtGD(trim(eWieght.text));
        LabelInteger1.Text:=trim(eWieght.text);
      end
      else
      begin
        eCountWieght.Text:='';
        eCountWieght.visible:=false;
      end;
    end
    else
    begin
      Application.MessageBox('Выберите тип перевозки!','Ошибка!',0);
      cbType.SetFocus;
      exit;
    end;
  end;
  eCountWieghtChange(Sender);
end;

function TFormSend.CountWieghtGD(Wieght:string):string;
var weight, str: string;
    j:integer;
    len:integer ;
begin
  weight:=Wieght;
  len:=Length(weight);
  if len>1 then
  begin
    str:=copy(weight,len,1);
    Delete(weight,len,1);
    j:=StrToInt(weight);
    if str <> '0' then
      j:=j+1;
  end
  else
    j:=1;

  CountWieghtGD:=IntToStr(j)+'0';
end;

function TFormSend.CountWieght(Wieght,Volume:string):string;
var
    Wfloat,Vfloat,UWFloat:real;
begin
  Wfloat:=StrToFloat(Wieght);
  Vfloat:=StrToFloat(Volume);
  UWFloat:=StrToFloat(sql.Selectstring('Constant','UnitVol',''));
  if Wfloat/Vfloat< UWFloat then
    CountWieght:=FloatToStr(Vfloat*UWFloat)
  else
    CountWieght:=FloatToStr(Wfloat);
end;

procedure TFormSend.eVolumeChange(Sender: TObject);
begin
  if cbType.getdata=2 then
  begin
    if (trim(eWieght.text)<>'0') and (trim(eVolume.text)<>'0.00') and
      (trim(eVolume.text)<>'0.0') and (trim(eWieght.text)<>'') and
      (trim(eVolume.text)<>'') and (trim(eVolume.text)<>'0.') and
      (trim(eVolume.text)<>'0')
    then
    begin
      eCountWieght.visible:=true;
      eCountWieght.Text:=CountWieght(trim(eWieght.text),trim(eVolume.text))
    end
    else
    begin
      eCountWieght.visible:=false;
      // eCountWieght.text:='';
    end;
  end;
  eCountWieghtChange(Sender);
end;

procedure TFormSend.eTariffChange(Sender: TObject);
begin
  eCountWieghtChange(Sender);
end;

procedure TFormSend.eCountWieghtChange(Sender: TObject);
var
  FW:real;
begin
  if (cbType.GetData=2) then
  begin
    if (trim(eCountWieght.text)<>'')   {автоперевозки}
      and (trim(eCountWieght.Text)<>'0') and
      ((trim(eTariff.text)='')or(trim(eTariff.text)='0.00')) then
    begin
      FW:=StrToFloat(trim(eCountWieght.text));
      if FW<200 then
        if  CheckBox8.Checked then
          eTariff.text:=sql.SelectString('City','Tariff500',
                               'Ident='+IntToStr(cbPynkt.GetData))
        else
          eTariff.text:=sql.SelectString('City','Tariff200',
                             'Ident='+IntToStr(cbPynkt.GetData));
        if ((FW>=200) and (FW<500)) then
          if  CheckBox8.Checked then
            eTariff.text:=sql.SelectString('City','Tariff1000',
                             'Ident='+IntToStr(cbPynkt.GetData))
          else
            eTariff.text:=sql.SelectString('City','Tariff500',
                               'Ident='+IntToStr(cbPynkt.GetData));
          if (FW>=500)and(FW<1000) then
            if  CheckBox8.Checked then
              eTariff.text:=sql.SelectString('City','Tariff2000',
                               'Ident='+IntToStr(cbPynkt.GetData))
            else
              eTariff.text:=sql.SelectString('City','Tariff1000',
                              'Ident='+IntToStr(cbPynkt.GetData));
          if (FW>=1000)and(FW<2000) then
            if  CheckBox8.Checked then
              eTariff.text:=sql.SelectString('City','TariffMore2000',
                                              'Ident='+IntToStr(cbPynkt.GetData))
            else
              eTariff.text:=sql.SelectString('City','Tariff2000',
                             'Ident='+IntToStr(cbPynkt.GetData));
            if (FW>=2000) then
              eTariff.text:=sql.SelectString('City','TariffMore2000',
                                              'Ident='+IntToStr(cbPynkt.GetData));

    end;
  end
  else
    if cbType.GetData=1 then
    begin
    end   {ждперевозки}
    else
    begin
      Application.MessageBox('Выберите тип перевозки!','Ошибка',0);
      cbType.SetFocus;
      exit;
    end;
    if (trim(eTariff.text)<>'0.00') and (trim(eCountWieght.Text)<>'0')
      and(trim(eTariff.text)<>'')and (trim(eCountWieght.Text)<>'') then
    begin
      eFare.Text:=Fare(trim(eTariff.text),trim(eCountWieght.Text));
    end
    else
      eFare.Text:='0.00' ;

  InsuranceSumMin;
  eInsuranceSumChange(Sender);
end;

function TFormSend.Fare(Tariff,CountWieght:string):string;
var
  FTariff,FCountWieght,FWieght:real;
  Fare1,Fare2,Fare3,Fare4,Fare5,Fare6,Fare7,Pr:real;
  Percent,Count,i:integer;
begin
  Fare2:=0;
  Fare3:=0;
  Fare4:=0;
  Fare5:=0;
  Fare6:=0;
  Fare7:=0;
  //Percent:=0;
  //Count:=0;
  FWieght:=0;
  FTariff:=StrToFloat(Tariff);
  {считаем скидку NN%}
  if trim(ePercent.text) <> '' then
    FTariff:=FTariff*(100-StrToInt(trim(ePercent.text)))/100  ;

  FCountWieght:=StrToFloat(CountWieght);
  if  trim(eWieght.text) <> '' then
    FWieght:=StrToFloat(trim(eWieght.text));

  if cbType.getData=2 then
  begin
    Fare1:=fTariff*FCountWieght;
    if CheckBox1.Checked then
    begin
      Percent:=sql.SelectInteger('Constant','PercentWarm','') ;
      Fare2:=Fare1*Percent/100;
    end;
    if CheckBox2.Checked then
    begin
      Percent:=sql.SelectInteger('Constant','PercentFragile','') ;
      Fare3:=Fare1*Percent/100;
    end;
    Fare1:=Fare2+Fare3+Fare1;
//------------------------------------------------------
    Fare2:=StrToFloat(sql.selectstring('Constant','MinPay',''));
    if Fare1< Fare2 then
      Fare1:=Fare2; {минимальная плата за провоз}
//------------------------------------------------------
    if Pos(' склад',cbPynkt.SQLComboBox.Text) <> 0 then
    Fare2:=StrToFloat(sql.selectstring('Constant','PriceSklad',''));

    if Fare1< Fare2 then
      Fare1:=Fare2; {минимальная плата за провоз до склада}
//------------------------------------------------------
    if Pos('до дверей',cbPynkt.SQLComboBox.Text) <> 0 then
      Fare2:=StrToFloat(sql.selectstring('Constant','PriceDver',''));

    if Fare1< Fare2 then
      Fare1:=Fare2; {минимальная плата за провоз до дверей}
//------------------------------------------------------
    if CheckBox1.Checked then
      Fare2:=StrToFloat(sql.selectstring('Constant','MinPayWarm','')) ;
    if Fare1< Fare2 then
      Fare1:=Fare2; {минимальная плата за провоз теплого груза}
//----------------------------------------------------------------
    if (LabelSQLComboBox1.GetData=2) and (FWieght <> 0) then
    begin
      Pr:=StrToFloat(sql.selectString('Constant','UnitPack','')); {выгрузка силами перевозчика}
      fare5:=FCountWieght*Pr;
    end;
    if CheckBox3.Checked then
    begin
      Percent:=sql.SelectInteger('Constant','PercentOversized','') ; {доплата за негаборитный груз}
      Fare4:=Fare1*Percent/100;
    end;
    Fare1:=Fare1+Fare4+Fare5;
    if (trim(LblEditMoney6.Text)<>'') and (trim(LblEditMoney6.text)<>'0.00') and     {сумму по доп услуге не суммируем с перевозной платой с 01.06.2012 }
      (StrToDate(LabelEditDate1.text) <= StrToDate('31.05.2012')) then
      fare7:= StrToFloat(trim(LblEditMoney6.Text));  {переносим в доп услуги} {доп. плата за доставку}
//----------------------------------------------------------------
 { if Pos(' склад',cbPynkt.SQLComboBox.Text) <> 0 then
   Fare2:=StrToFloat(sql.selectstring('Constant','PriceSklad',''))
  else if Pos('до дверей',cbPynkt.SQLComboBox.Text) <> 0 then
       Fare2:=StrToFloat(sql.selectstring('Constant','PriceDver',''))
         else if CheckBox1.Checked then
       Fare2:=StrToFloat(sql.selectstring('Constant','MinPayWarm',''))
              else  Fare2:=StrToFloat(sql.selectstring('Constant','MinPay','')); }
    Fare:=StrTo00(FloatToStr(Fare1+Fare7));
  end
  else
    if cbType.getdata=1 then
    begin
      Percent:=sql.SelectInteger('Constant','PercentTarGd','');
      Fare3:=StrToFloat(sql.selectstring('Constant','MinPayGd',''));
      Count:=sql.SelectInteger('City','Check','Ident='+
                              IntToStr(cbPynkt.getdata));
      if  (sql.SelectString('City','GDStrah','Ident='+IntToStr(cbPynkt.getdata)) <> '') then
        Fare6:=StrToFloat(sql.SelectString('City','GDStrah','Ident='+
                       IntToStr(cbPynkt.getdata)));
      if Count=1 then
      begin
        i:=0;
        if ePlac.AsInteger<>0 then
          i:=ePlac.AsInteger;
        Fare4:=StrToFloat(sql.selectstring('Constant','PlaceTariff',''));
        Fare4:=Fare4*i;
      end ;
      Fare1:=(FTariff*FCountWieght/10);
      Fare2:=(Fare1*Percent/100);
      if Fare2<Fare3 then
        Fare2:=fare3+Fare4+Fare1+Fare6
      else
        Fare2:=Fare2+Fare4+Fare1+Fare6;
      fare:=StrTo00(FloatToStr(Fare2));
    end
    else
    begin
      Application.MessageBox('Выберите тип перевозки!','Ошибка!',0);
      cbType.SetFocus;
      exit;
    end;
end;

procedure TFormSend.CheckBox5Click(Sender: TObject);
begin
  if CheckBox5.Checked then
  begin
    dbGrid2.Visible:=true;
    LBLEditMoney3.Visible:=true;
  end
  else
  begin
    LBLEditMoney3.Text:='0.00';
    dbGrid2.Visible:=false;
    LBLEditMoney3.Visible:=false;
  end;
end;

procedure TFormSend.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked then
  begin
    LBLEditMoney1.Visible:=true;
    eExpCount.Visible:=true;
    LBLEditMoney1.Text:=sql.Selectstring('Constant','UnitExp','');
  end
  else
  begin
    LBLEditMoney1.Text:='0.00' ;
    eExpCount.Text:='0.00';
    LBLEditMoney1.Visible:=false;
    eExpCount.Visible:=false;
  end;
end;

procedure TFormSend.CheckBox6Click(Sender: TObject);
begin
  if CheckBox6.Checked then
  begin
    LBLEditMoney2.Visible:=true;
    LabelInteger2.Visible:=true;
    LBLEditMoney2.Text:=sql.Selectstring('Constant','UnitPass','');
  end
  else
  begin
    LBLEditMoney2.Text:='0.00';
    LabelInteger2.Text:='0';
    LBLEditMoney2.Visible:=false;
    LabelInteger2.Visible:=false;
  end;
end;

procedure TFormSend.LabelInteger1Change(Sender: TObject);
begin
  if ((trim(eExpCount.text)<>'') and (trim(eExpCount.text)<>'0.00'))          {сумму по доп услуге не суммируем с перевозной платой с 01.06.2012 }
    or ((trim(LabelInteger2.text)<>'')and (trim(LabelInteger2.text)<>'0'))
    or ((trim(LblEditMoney3.text)<>'') and (trim(LblEditMoney3.text)<>'0.00'))
    or ((trim(LblEditMoney6.text)<>'') and (trim(LblEditMoney6.text)<>'0.00')
   and (StrToDate(LabelEditDate1.text) > StrToDate('31.05.2012')))   {доп услуги}
  then
  begin
    eAddServicePrace.Visible:=true;
    eAddServicePrace.Text:=addService;
  end
  else
    eAddServicePrace.Visible:=false;
end;

procedure TFormSend.LabelInteger2Change(Sender: TObject);
begin
  if ((trim(eExpCount.text)<>'') and (trim(eExpCount.text)<>'0.00'))               {сумму по доп услуге не суммируем с перевозной платой с 01.06.2012 }
    or ((trim(LabelInteger2.text)<>'')and (trim(LabelInteger2.text)<>'0'))
    or ((trim(LblEditMoney3.text)<>'') and (trim(LblEditMoney3.text)<>'0.00'))
    or ((trim(LblEditMoney6.text)<>'') and (trim(LblEditMoney6.text)<>'0.00')
    and (StrToDate(LabelEditDate1.text) > StrToDate('31.05.2012')))   {доп услуги}
  then
  begin
    eAddServicePrace.Visible:=true;
    eAddServicePrace.Text:=addService;
  end
  else
    eAddServicePrace.Visible:=false;
end;

function TFormSend.addService:string;
var
  Sum:real;
begin
  Sum:=0;
  if (trim(eExpCount.text)<>'')and (trim(LBLEditMoney1.text)<>'') then
    Sum:=Sum+StrToFloat(trim(LBLEditMoney1.text))*StrToFloat(trim(eExpCount.text));

  if (trim(LabelInteger2.text)<>'')  and (trim(LBLEditMoney2.text)<>'') then
    Sum:=Sum+StrToFloat(trim(LBLEditMoney2.text))*StrToFloat(trim(LabelInteger2.text));

  if  (trim(LBLEditMoney3.text)<>'') then
    Sum:=Sum+StrToFloat(trim(LBLEditMoney3.text));

  if ((trim(LblEditMoney6.text)<>'') and (trim(LblEditMoney6.text)<>'0.00') and   {сумму по доп услуге не суммируем с перевозной платой с 01.06.2012 }
   (StrToDate(LabelEditDate1.text) > StrToDate('31.05.2012')))   {доп услуги}
  then
    Sum:=Sum+StrToFloat(trim(LBLEditMoney6.text));
  addService:=StrTo00(FloatToStr(Sum));
end;

procedure TFormSend.DataSource1UpdateData(Sender: TObject);
begin
//eLabelInteger.text:=IntToStr(dbGrid1.co)
end;

procedure TFormSend.Query1CountChange(Sender: TField);
var
  Sum:string;
  Sum1:integer;
begin
  Sum:='';
  Sum1:=0;
  Query1.DisableControls;
  Query1.First;
  while (not Query1.eof) do
  begin
    Sum:=Sum+','+Query1.FieldByName('Name').asstring+' '+Query1.FieldByName('Count').asstring;
    Sum1:=Sum1+Query1.FieldByName('Count').asInteger;
    Query1.Next;
  end;

  Query1.EnableControls ;
  Delete(Sum,1,1);
  ePlace.Text:=Sum;
  ePlac.Text:=IntToStr(Sum1);
end;

Function TFormSend.Numbercalc:string;
var
  Num1,Num2:string;
  N1,N2:integer;
  q:TQuery;
begin
  q:=sql.Select(send_table,'Namber','`Start`='+
               sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text))),'');

  if  q.Eof then
    Number:='1/'+FormatDateTime('ddmmyy',StrToDate(LabelEditDate1.text))
  else
  begin
    Num1:=q.fieldByName('Namber').AsString;
    N1:=pos('/',Num1);
    delete(Num1,N1,Length(Num1)-N1+1) ;
    N1:=StrToInt(Num1);
    while not q.Eof do
    begin
      Num2:=q.fieldByName('Namber').AsString;
      N2:=pos('/',Num2);
      delete(Num2,N2,Length(Num2)-N2+1) ;
      N2:=StrToInt(Num2);
      if N1<N2 then N1:=N2;
      q.Next;
      end;
      Number:=IntToStr(N1+1)+'/'+FormatDateTime('ddmmyy',StrToDate(LabelEditDate1.text));
    end;
  q.Free;
end;

procedure TFormSend.eInsuranceSumChange(Sender: TObject);
begin
  if (trim(eInsuranceSum.text)<>'') and  (trim(eInsurancePercent.text)<>'') and
    (trim(eInsuranceSum.text)<>'0.00') and  (trim(eInsurancePercent.text)<>'0.00')
  then
  begin
    eInsuranceValue.visible:=true;
    if StrToFloat(trim(eInsuranceSum.text))<(StrToFloat(trim(eCountWieght.text))*100) then
    InsuranceSumMin;     {если сумма страховки меньше чем (провозная плата * 10) то пересчитываем на мин}
    eInsuranceValue.text:=StrTo00(FloatToStr((strToFloat(trim(eInsuranceSum.text))-(strToFloat(trim(eCountWieght.text))*100))*(strToFloat(trim(eInsurancePercent.text))/100)));
  end
  else
  begin
    eInsuranceValue.text:='';
    eInsuranceValue.visible:=false;
  end;
end;

procedure TFormSend.eInsurancePercentChange(Sender: TObject);
begin
  if (trim(eInsuranceSum.text)<>'') and  (trim(eInsurancePercent.text)<>'') then
  begin
    eInsuranceValue.visible:=true;
    eInsuranceValue.text:=StrTo00(FloatToStr(strToFloat(trim(eInsuranceSum.text))*(strToFloat(trim(eInsurancePercent.text))/100)));
  end
  else
  begin
    eInsuranceValue.visible:=false;
    eInsuranceValue.text:='';
  end;
end;

procedure TFormSend.eFareChange(Sender: TObject);
var
  f1,f2,f3:real;
begin
  f1:=0;
  f2:=0;
  f3:=0;
  if  trim(eFare.text)<>'' then
    f1:=StrToFloat(trim(eFare.text));

  if  trim(eAddServicePrace.text)<>'' then
    f2:=StrToFloat(trim(eAddServicePrace.text));
  if trim(eInsuranceValue.text)<>'' then
    f3:=strToFloat(trim(eInsuranceValue.text));

  f1:=f1+f2+f3;
  eSumCount.text:=StrTo00(FloatToStr(f1));
end;

procedure TFormSend.LabelEditDate1Enter(Sender: TObject);
begin
  DateTest:=LabelEditDate1.text;
end;

procedure TFormSend.LabelEditDate1Exit(Sender: TObject);
begin
  try
    FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.text));
  except
    Application.MessageBox('Неправильно введена дата!','Ошибка',0);
    PageControl1.ActivePage:=TabSheet1;
    LabelEditDate1.Text:= DateTest;
    LabelEditDate1.SetFocus;
    exit;
  end;
end;

procedure TFormSend.CheckBox1Click(Sender: TObject);
begin
  eCountWieghtChange(Sender);
end;

procedure TFormSend.CheckBox2Click(Sender: TObject);
begin
  eCountWieghtChange(Sender);
end;

procedure TFormSend.CheckBox3Click(Sender: TObject);
begin
  eCountWieghtChange(Sender);
end;

procedure TFormSend.eAddServicePraceChange(Sender: TObject);
begin
if trim(eAddServicePrace.text)<>'' then
  eFareChange(Sender);
end;

procedure TFormSend.eInsuranceValueChange(Sender: TObject);
begin
  if trim(eInsuranceValue.text)<>'' then
    eFareChange(Sender);
end;

procedure TFormSend.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex=0 then
  begin
    cbPayType.SetActive(1);
    cbZak.Where:='PersonType_Ident=1';
    cbZak.Recalc
  end;

  if RadioGroup1.ItemIndex=1 then
  begin
    cbPayType.SetActive(2);
    cbZak.Where:='PersonType_Ident=2';
    cbZak.Recalc;
  end;
end;

procedure TFormSend.LabelEditDate2Enter(Sender: TObject);
begin
  DateTest:=LabelEditDate2.text;
end;

procedure TFormSend.LabelEditDate2Exit(Sender: TObject);
begin
  if LabelEditDate2.text<>'  .  .    ' then
  begin
    try
      FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate2.text));
    except
      Application.MessageBox('Неправильно введена дата!','Ошибка',0);
      PageControl1.ActivePage:=TabSheet1;
      LabelEditDate2.Text:= DateTest;
      LabelEditDate2.SetFocus;
      exit;
    end;
  end;
end;

procedure TFormSend.LabelEditDate3Enter(Sender: TObject);
begin
  DateTest:=LabelEditDate3.text;
end;

procedure TFormSend.LabelEditDate3Exit(Sender: TObject);
var
  Year, Month, Day, YearN, MonthN, DayN: Word;
begin
  if LabelEditDate3.text<>'  .  .    ' then
  begin
    try
      FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate3.text));
      DecodeDate(StrToDate(LabelEditDate3.text),Year,Month,Day);
      DecodeDate(Now,YearN,MonthN,DayN);
      if  Year <> YearN then
        Application.MessageBox('Неправильно введен год!','Сообщение',0);
      if  Month <> MonthN then
        Application.MessageBox('Неправильно введен месяц!','Сообщение',0);

    except
      Application.MessageBox('Неправильно введена дата!','Ошибка',0);
      PageControl1.ActivePage:=TabSheet3;
      LabelEditDate3.Text:= DateTest;
      LabelEditDate3.SetFocus;
      exit;
    end;
  end;
end;

procedure TFormSend.BitBtn2Click(Sender: TObject);
var
  l:longint;
begin
  CityForm:=TCityForm.Create(Application) ;
  l:=CityForm.AddRecord;
  if l<>0 then
  begin
    cbPynkt.SQLComboBox.Recalc;
    cbPynkt.SQLComboBox.SetActive(l);
  end;
  CityForm.Free   ;
  cbTypeExit(Sender);
end;

procedure TFormSend.BitBtn1Click(Sender: TObject);
var
  l:longint;
begin
  Card:=TCard.Create(Application) ;
  l:=Card.AddRecord;
  if l<>0 then
  begin
    cbZak.Recalc;
    cbZak.SetActive(l);
    cbOtpr.Recalc;
  //  cbOtpr.SetActive(l);
  end;
  Card.Free;
  cbZakChange(Sender);
end;

procedure TFormSend.BitBtn3Click(Sender: TObject);
var
  l:longint;
begin
  Card:=TCard.Create(Application) ;
  l:=Card.AddRecord;
  if l<>0 then
  begin
    cbOtpr.Recalc;
    cbOtpr.SetActive(l);
    cbZak.Recalc;
  end;
  Card.Free;
  cbOtprChange(Sender);
end;

procedure TFormSend.BitBtn4Click(Sender: TObject);
var
  l:longint;
begin
  FormAcceptor:=TFormAcceptor.Create(Application);
  l:=FormAcceptor.AddRecord;
  if l<>0 then
  begin
    cbPolych.Where:='City_Ident='+intToStr(cbPynkt.SQLComboBox.GetData);
    cbPolych.Recalc;
    cbPolych.SetActive(l);   
         end;
          FormAcceptor.Free;
          cbPolychChange(Sender);
end;

procedure TFormSend.btPrintClick(Sender: TObject);
var
ReportMakerWP:TReportMakerWP;
p,w1,w2,w3,w4: OleVariant;
s:string;
sendrtf:string;
clientName: string;
Num,mach:string;
cuttarstring: string;
f:real;
i,Nprint:integer;
label T;
begin
try
//Nprint:=0; {указатель на формат печати 4 or 5}
if NUmber='' then
begin
  Application.MessageBox('Отправке не присвоен номер! Сохраните отправку!','',0);
  exit;
end;

  ReportMakerWP:=TReportMakerWP.Create(Application);

  ReportMakerWP.ClearParam;
if cbType.getData=2 then
begin
  ReportMakerWP.AddParam('1='+sql.SelectString('Clients','Name','Ident='+
                                               IntToStr(cbZak.GetData)));
  ReportMakerWP.AddParam('2='+sql.SelectString('Clients','Name','Ident='+
                                               IntToStr(cbOtpr.GetData)));
  ReportMakerWP.AddParam('3='+cbPynkt.SQLComboBox.text);
  ReportMakerWP.AddParam('4='+cbPolych.text);
  ReportMakerWP.AddParam('5='+LabelEdit7.text+', т. '+LabelEdit3.text);
  ReportMakerWP.AddParam('6='+LabelEdit8.text );
  ReportMakerWP.AddParam('7='+cbGryz.SQLComboBox.text );

   s:='';
   if  CheckBox1.Checked then
   s:=s+', '+CheckBox1.Caption ;
   if CheckBox2.Checked then
   s:=s+', '+CheckBox2.Caption ;
   if CheckBox3.Checked then
   s:=s+', '+CheckBox3.Caption ;
   if s<>'' then delete(s,1,2);
      cuttarstring:='';
       if trim(ePercent.text) <> '' then
       cuttarstring:= ' (льготный тариф '+trim(ePercent.text)+ '%)';

  ReportMakerWP.AddParam('8='+s );
  ReportMakerWP.AddParam('9='+LabelSQLComboBox1.SQLComboBox.Text );
  ReportMakerWP.AddParam('10='+trim(ePlace.text) );
  ReportMakerWP.AddParam('11='+trim(eWieght.text) );
  ReportMakerWP.AddParam('12='+trim(eVolume.text) );
  ReportMakerWP.AddParam('13='+trim(eCountWieght.text) );
  ReportMakerWP.AddParam('14='+StrTo00(trim(eTariff.text)) );
  ReportMakerWP.AddParam('35='+cuttarstring );
  ReportMakerWP.AddParam('15='+StrTo00(trim(eFare.text)) );
  ReportMakerWP.AddParam('16='+StrTo00(trim(eInsuranceSum.text) ));
  ReportMakerWP.AddParam('17='+StrTo00(trim(eInsuranceValue.text)) );
  ReportMakerWP.AddParam('18='+StrTo00(trim(eAddServicePrace.text)) );
  ReportMakerWP.AddParam('19='+StrTo00(trim(eSumCount.text)) );

  ReportMakerWP.AddParam('20='+cbPayType.SQLComboBox.text );
  s:=SendStr.MoneyToString(trim(eSumCount.text));
  ReportMakerWP.AddParam('21='+s );
  ReportMakerWP.AddParam('22='+trim(LabelEdit1.text) );
   s:=SendStr.DataDMstrY(StrToDate(trim(LabelEditDate1.text)));
  ReportMakerWP.AddParam('23='+s );
  Num:=Number;
  ReportMakerWP.AddParam('24='+Num );
  ReportMakerWP.AddParam('25='+CbForwarder.SQLComboBox.Text );
  s:='';
  if  CheckBox5.Checked then s:=s+'Упаковка: '+StrTo00(trim(LblEditMoney3.text))+' руб';
  if  CheckBox4.Checked then
  begin
  f:=StrToFloat(trim(LblEditMoney1.text))*StrToFloat(trim(eExpCount.Text));
  if s<>'' then s:=s+', ';
  s:=s+'Экспедирование: '+StrTo00(FloatToStr(f))+' руб';
  end;
  if  CheckBox6.Checked then
  begin
  f:=StrToFloat(trim(LblEditMoney2.text))*StrToFloat(trim(LabelInteger2.Text));
  if s<>'' then s:=s+', ';
  s:=s+'Выдача пропусков: '+StrTo00(FloatToStr(f))+' руб';
  end;
  ReportMakerWP.AddParam('26='+s );
  //---------
  i:=0;
 if ePlac.text<>'' then i:=StrToInt(trim(ePlac.Text));

  ReportMakerWP.AddParam('27='+IntToStr(i) );
  s:='';
  if LabelEditDate2.text <> '  .  .    ' then
    s:=SendStr.DataDMstrY(StrToDate(LabelEditDate2.text));
  ReportMakerWP.AddParam('28='+s );
  s:=SendStr.DataDMstrY(StrToDate(LabelEditDate4.text));
  ReportMakerWP.AddParam('29='+' Доставка:'+s );
  if  trim(LblEditMoney6.text)<>'0.00'  then       {AddServStr,Sum}
  begin
    s:= Trim(LabelEdit14.Text);
    ReportMakerWP.AddParam('30='+s );
    ReportMakerWP.AddParam('31='+StrTo00(trim(LblEditMoney6.text))+' руб' );
  end;
  if CheckBox7.Checked then
    ReportMakerWP.AddParam('32='+'Упаковка груза не соответствует условиям перевозки.'+
                                 ' Без ответственности за механические повреждения.' )
  else  ReportMakerWP.AddParam('32='+'' );
 sendrtf := 'send\sendU.rtf';   //печать для юр лиц
 clientName := sql.SelectString('Clients','Acronym','Ident='+ IntToStr(cbZak.GetData));
 clientName := trim(clientName);
 if Pos('"', clientName) = 1 then sendrtf := 'send\sendCh.rtf'; //печать для частных
 if ReportMakerWP.DoMakeReport(systemdir+sendrtf,
          systemdir+'send\send.ini', systemdir+'send\out.rtf')<>0 then
                              begin
                              ReportMakerWP.Free;
                             // application.messagebox('Закройте выходной документ в WINWORD!',
                              //'Совет!',0);
                              goto t;
                              exit
                              end;;
Nprint:=4;{указатель на формат печати}


end else if cbType.GetData=1 then   {жд перевозка}
begin
       ReportMakerWP.AddParam('1='+sql.SelectString('Clients','Name','Ident='+
                                               IntToStr(cbZak.GetData)));
       ReportMakerWP.AddParam('2='+sql.SelectString('Clients','Name','Ident='+
                                               IntToStr(cbOtpr.GetData)));
       ReportMakerWP.AddParam('3='+cbPynkt.SQLComboBox.text);
       ReportMakerWP.AddParam('4='+trim(cbPolych.text));
       ReportMakerWP.AddParam('5='+trim(LabelEdit7.text)+', т. '+trim(LabelEdit3.text));
       s:=SendStr.DataDMstrY(StrToDate(trim(LabelEditDate2.text)));
       ReportMakerWP.AddParam('6='+s );
       ReportMakerWP.AddParam('7='+cbGryz.SQLComboBox.text );
       ReportMakerWP.AddParam('8='+'Санкт-Петербург-Главный' );
       ReportMakerWP.AddParam('9='+trim(LabelEdit6.text) );
       ReportMakerWP.AddParam('10='+trim(ePlace.text) );
       ReportMakerWP.AddParam('11='+trim(eWieght.text) );
       i:=sql.SelectInteger('City','Check','Ident='+IntToStr(cbPynkt.GetData));
       // f:=0;
       if i=1 then
       begin
        i:=0;
        if trim(ePlac.text)<>'' then
          i:=StrToInt(trim(ePlac.Text));
        f:=StrToFloat(sql.SelectString('Constant','PlaceTariff',''));
        f:=f*i;
       end else f:=0;
       if f<>0 then  ReportMakerWP.AddParam('25='+', Наценка за проезд ч/з Москву: '+StrTo00(FloatToStr(f))+' руб.')
        else ReportMakerWP.AddParam('25='+' ');
       s:=STRTo00(FloatToStr(StrToFloat(trim(eFare.text))-StrToFloat(trim(eCountWieght.text))*StrToFloat(trim(eTariff.text))/10-f));


       ReportMakerWP.AddParam('12='+S );
       ReportMakerWP.AddParam('13='+trim(eCountWieght.text) );
       ReportMakerWP.AddParam('14='+StrTo00(trim(eTariff.text)) );
       ReportMakerWP.AddParam('15='+StrTo00(trim(eFare.text)) );
       ReportMakerWP.AddParam('16='+StrTo00(trim(eInsuranceSum.text) ));
       ReportMakerWP.AddParam('17='+StrTo00(trim(eInsuranceValue.text)) );
       ReportMakerWP.AddParam('18='+StrTo00(trim(eAddServicePrace.text)) );
       ReportMakerWP.AddParam('19='+StrTo00(trim(eSumCount.text)) );

       ReportMakerWP.AddParam('20='+cbPayType.SQLComboBox.text );
       s:=SendStr.MoneyToString(trim(eSumCount.text));
       ReportMakerWP.AddParam('21='+s );
       ReportMakerWP.AddParam('22='+trim(LabelEdit1.text) );
       s:=SendStr.DataDMstrY(StrToDate(LabelEditDate1.text));
       ReportMakerWP.AddParam('23='+s );
       ReportMakerWP.AddParam('24='+'Северная' );
       s:='';
       if  CheckBox5.Checked then s:=s+'Упаковка: '+StrTo00(trim(LblEditMoney3.text))+' руб';
       if  CheckBox4.Checked then
       begin
       f:=StrToFloat(trim(LblEditMoney1.text))*StrToFloat(trim(eExpCount.Text));
       if s<>'' then s:=s+', ';
       s:=s+'Экспедирование: '+StrTo00(FloatToStr(f))+' руб';
       end;
       if  CheckBox6.Checked then
       begin
       f:=StrToFloat(trim(LblEditMoney2.text))*StrToFloat(trim(LabelInteger2.Text));
       if s<>'' then s:=s+', ';
       s:=s+'Выдача пропусков: '+StrTo00(FloatToStr(f))+' руб';
       end;
       ReportMakerWP.AddParam('26='+s );
 ///--------------------------------------------------------
        i:=0;
       if trim(ePlac.text)<>'' then i:=StrToInt(trim(ePlac.Text));
 ////---------------------------------------------------------
      ReportMakerWP.AddParam('27='+IntToStr(i) );
      if ReportMakerWP.DoMakeReport(systemdir+'send\sendGd.rtf',
          systemdir+'send\sendGD.ini', systemdir+'send\out1.rtf')<>0 then
                              begin
                              ReportMakerWP.Free;
                             // application.messagebox('Закройте выходной документ в WINWORD!',
                             // 'Совет!',0);
                             goto T;
                              exit
                              end;;
Nprint:=5; {указатель на формат печати}
end else
begin
  Application.MessageBox('Выберите тип перевозки!','Ошибка!',0);
  PageControl1.ActivePage:=TabSheet1;
  CbType.SetFocus;
  exit;
end;
  ReportMakerWP.Free;

WordApplication1:=TWordApplication.Create(Application);
mach:='';
mach:= trim(WordApplication1.UserName);

if Nprint=4 then
begin
W1:=1;
w2:=sql.SelectString('Printer','NameA4','ComputerName='+sql.MakeStr(mach));
w3:=sql.SelectString('Printer','ComNameA4','ComputerName='+sql.MakeStr(mach));
p := systemdir+'send\out.rtf';
end  else if Nprint=5 then
         begin
        w1:=1;
        w2:=sql.SelectString('Printer','NameA5','ComputerName='+sql.MakeStr(mach));
        w3:=sql.SelectString('Printer','ComNameA5','ComputerName='+sql.MakeStr(mach));
        p := systemdir+'send\out1.rtf';
         end ;
w4:=WordApplication1.UserName;
if (VarToStr(w2)='') or (VarToStr(w3)='') then
begin
application.MessageBox('Информация о принтерах не внесена в базу для данной машины'+
                       ' или в параметрах WinWord не верно указано имя машины!','Ошибка!',0);
 goto T;
 exit;
end;
if w3<>w4 then   w2:= '\\'+w3+'\'+w2;

 WordApplication1.Documents.Open(p,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam);

WordApplication1.ActivePrinter:=w2;
WordApplication1.ActiveDocument.PrintOut(
	EmptyParam,EmptyParam,EmptyParam,
	EmptyParam, EmptyParam,EmptyParam,
	EmptyParam,w1,EmptyParam,
	EmptyParam,EmptyParam,EmptyParam,
        w2,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam,EmptyParam);  
T: WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
        WordApplication1.WindowState:=2;
WordApplication1.Free;
except
WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
application.MessageBox('Проверьте все настройки для печати!','Ошибка!',0);
exit
end;
end;
procedure TFormSend.BitBtn8Click(Sender: TObject);
var
    l:longint;
begin
if cbPynkt.SQLComboBox.GetData<>0 then
begin
 CityForm:=TCityForm.Create(Application) ;
  l:=CityForm.EditRecord(cbPynkt.SQLComboBox.GetData);
  if l<>0 then
    begin
    cbPynkt.SQLComboBox.Recalc;
    cbPynkt.SQLComboBox.SetActive(l);
    end;
  CityForm.Free   ;
  cbTypeExit(Sender);
end;
end;

procedure TFormSend.BitBtn6Click(Sender: TObject);
var l:longint;
begin
if cbPolych.GetData<>0 then
begin
          FormAcceptor:=TFormAcceptor.Create(Application) ;
          l:=FormAcceptor.EditRecord(cbPolych.GetData);
         if l<>0 then
         begin
          cbPolych.Where:='City_Ident='+intToStr(cbPynkt.SQLComboBox.GetData);
          cbPolych.Recalc;
          cbPolych.SetActive(l);   
         end;
          FormAcceptor.Free;
          cbPolychChange(Sender);
end;
end;


procedure TFormSend.BitBtn7Click(Sender: TObject);
var l:longint;
begin
if cbOtpr.GetData<>0 then
begin
cbOtpr.GetData;
Card:=TCard.Create(Application) ;
l:=Card.EditRecord(cbOtpr.GetData);
if l<>0 then
  begin
    cbOtpr.Recalc;
    cbOtpr.SetActive(l);
    cbZak.Recalc;
  //  cbOtpr.SetActive(l);
  end;
Card.Free;
cbOtprChange(Sender);
end;

end;

procedure TFormSend.LblEditMoney3Change(Sender: TObject);
begin
if ((trim(eExpCount.text)<>'') and (trim(eExpCount.text)<>'0.00'))
   or ((trim(LabelInteger2.text)<>'')and (trim(LabelInteger2.text)<>'0'))
   or ((trim(LblEditMoney3.text)<>'') and (trim(LblEditMoney3.text)<>'0.00'))
then begin
eAddServicePrace.Visible:=true;
eAddServicePrace.Text:=addService;
end else  eAddServicePrace.Visible:=false;
end;

procedure TFormSend.Query2CountChange(Sender: TField);
var Sum:real;
begin
Sum:=0;
Query2.DisableControls;
Query2.First;

while (not Query2.eof) do
begin
Sum:=Sum+(StrToFloat(Query2.FieldByName('Tariff').asString)*Query2.FieldByName('Count').asinteger);
Query2.Next;
end;
Query2.EnableControls ;
LBLEditMoney3.Text:=StrTo00(FloatToStr(Sum));
end;

procedure TFormSend.Query2PackNameSetText(Sender: TField;
  const Text: String);
begin
{Query2Tariff.Text:= sql.SelectString('PackTariff','Tariff','Name='+
                 sql.MakeStr(Query2.FieldByName('PackName').asString)); }
end;

procedure TFormSend.Query2PackNameChange(Sender: TField);
var Tar:string;
begin
Query2.DisableControls;
if  Query2.FieldByName('PackName').asString<>'' then
begin
Tar:=sql.SelectString('PackTariff','Tariff','Name='+
                 sql.MakeStr(Query2.FieldByName('PackName').asString)) ;
if Tar<>''  then
 Query2Tariff.Text:= Tar
 else Query2Tariff.Text:='0.00';
end;
Query2.EnableControls ;
end;

procedure TFormSend.Query2TariffChange(Sender: TField);
var Sum:real;
begin
Sum:=0;
Query2.DisableControls;
Query2.First;

while (not Query2.eof) do
begin
Sum:=Sum+(StrToFloat(Query2.FieldByName('Tariff').asString)*Query2.FieldByName('Count').asinteger);
Query2.Next;
end;
Query2.EnableControls ;
LBLEditMoney3.Text:=FloatToStr(Sum);

end;

procedure TFormSend.LabelSQLComboBox1Change(Sender: TObject);
var Day:string;
begin
day:=sql.SelectString('Train','Day','Ident='+IntToStr(cbNTrain.GetData));
  if (day<>'')and (LabelEditDate2.Text='  .  .    ') then
  LabelEditDate2.Text:=FormatDateTime('dd.mm.yyyy',SToDate(day,StrToDate(LabelEditDate1.text)));
  //eCountWieghtChange(Sender);

//eCountWieghtChange(Sender);
end;

procedure TFormSend.cbTypeChange(Sender: TObject);
begin
if  cbType.GetData=1 then    {жд}
begin
 cbNTrain.Visible:=true;
 LabelEdit10.Visible:=true;
 LabelEdit10.text:='Санкт-Петербург-Главный';
 cbPynkt.Caption:='Станция назначения' ;
//---------
 cbSendType.caption:='Состояние отправки';
 cbSendType.where:='Ident in (3,4)';
 cbSendType.SQLComboBox.Recalc;
 cbSendType.setactive(3);
 LabelEditDate3.caption:='Дата отправки';
 cbSupplier.caption:='Кем отправлена'  ;
 TabSheet3.Caption:='Отправка';

 LabelEdit9.Visible:=true;
 LabelEdit11.Visible:=true;
 LblEditMoney4.Visible:=true;
 LblEditMoney5.Visible:=true;
 LabelEdit12.Visible:=true;
 LabelInteger1.Visible:=true;
 LabelEdit13.Visible:=true;
 cbTypeWay.Visible:=true;
 cbTypeServ.Visible:=true;
 //---------
 GroupBox4.Visible:=false;
 LabelSQLComboBox1.Visible:=false;
 eVolume.Visible:=false;
 BitBTN5.Visible:=false;
 BitBTN10.Visible:=false;
end else if  cbType.GetData=2 then       {авто}
         begin
          cbNTrain.Visible:=false;
          LabelEdit10.Visible:=false;
          cbPynkt.Caption:='Пункт назначения';
          GroupBox4.Visible:=true;
          LabelSQLComboBox1.Visible:=true;
          eVolume.Visible:=true;
          BitBtn5.Visible:=true;
          BitBTN10.Visible:=true;
          cbSendType.caption:='Состояние отправки';

//---------
 cbSendType.where:='Ident in (1,2)';
 cbSendType.SQLComboBox.Recalc;
 cbSendType.setactive(1);
 LabelEditDate3.caption:='Дата доставки';
 cbSupplier.caption:='Кем доставлена'  ;
 TabSheet3.Caption:='Доставка';

 LabelEdit9.Visible:=false;
 LabelEdit11.Visible:=false;
 LblEditMoney4.Visible:=false;
 LblEditMoney5.Visible:=false;
 LabelEdit12.Visible:=false;
 LabelInteger1.Visible:=false;
 LabelEdit13.Visible:=false;
 cbTypeWay.Visible:=false;
 cbTypeServ.Visible:=false;
//------------
         end;
cbPynktChange(Sender);
eWieghtChange(Sender);

//eCountWieghtChange(Sender);
end;

procedure TFormSend.N1Click(Sender: TObject); 
var Sum:string;
    Sum1:integer;
begin
Query1.Delete;
Sum:='';
Sum1:=0;
Query1.DisableControls;
Query1.First;

while (not Query1.eof) do
begin
Sum:=Sum+','+Query1.FieldByName('Name').asstring+' '+Query1.FieldByName('Count').asstring;
Sum1:=Sum1+Query1.FieldByName('Count').asInteger;
Query1.Next;
end;

Query1.EnableControls ;
Delete(Sum,1,1);
ePlace.Text:=Sum;
ePlac.Text:=IntToStr(Sum1);
end;

procedure TFormSend.N2Click(Sender: TObject);
begin
FormSend.eWieght.SetFocus;
end;

procedure TFormSend.N3Click(Sender: TObject);
begin
    FormSend.LabelEditDate2.SetFocus;
end;

procedure TFormSend.N4Click(Sender: TObject);
var Sum:real;
begin
Query2.Delete;
Sum:=0;
Query2.DisableControls;
Query2.First;

while (not Query2.eof) do
begin
Sum:=Sum+(StrToFloat(Query2.FieldByName('Tariff').asString)*Query2.FieldByName('Count').asinteger);
Query2.Next;
end;
Query2.EnableControls ;
LBLEditMoney3.Text:=StrTo00(FloatToStr(Sum));
end;

procedure TFormSend.N5Click(Sender: TObject);
begin
FormSend.CheckBox4.setfocus;
end;

procedure TFormSend.N6Click(Sender: TObject);
begin
 FormSend.CheckBox5.setfocus;
end;

procedure TFormSend.N7Click(Sender: TObject);
begin
if  CheckBox1.Focused and (CheckBox1.Checked=false)then
CheckBox1.Checked:=true else
if  CheckBox1.Focused and (CheckBox1.Checked=true)then
CheckBox1.Checked:=false;
//----------
if  CheckBox2.Focused and (CheckBox2.Checked=false)then
CheckBox2.Checked:=true else
if  CheckBox2.Focused and (CheckBox2.Checked=true)then
CheckBox2.Checked:=false;
//------------
if  CheckBox3.Focused and (CheckBox3.Checked=false)then
CheckBox3.Checked:=true else
if  CheckBox3.Focused and (CheckBox3.Checked=true)then
CheckBox3.Checked:=false;
//-----------------
if  CheckBox4.Focused and (CheckBox4.Checked=false)then
CheckBox4.Checked:=true else
if  CheckBox4.Focused and (CheckBox4.Checked=true)then
CheckBox4.Checked:=false;
//--------------------
if  CheckBox5.Focused and (CheckBox4.Checked=false) then
CheckBox5.Checked:=true else
if  CheckBox5.Focused and (CheckBox5.Checked=true)then
CheckBox5.Checked:=false;
//-----------------
if  CheckBox6.Focused and (CheckBox6.Checked=false)then
CheckBox6.Checked:=true else
if  CheckBox6.Focused and (CheckBox6.Checked=true)then
CheckBox6.Checked:=false;
//---------------------
if RadioGroup1.Focused then
begin
 if  RadioGroup1.ItemIndex=0 then    RadioGroup1.ItemIndex:=1
   else RadioGroup1.ItemIndex:=0
end;   
end;

procedure TFormSend.ePlaceChange(Sender: TObject);
begin
if cbType.GetData=1 then
if trim(ePlace.Text)<>'' then
begin
LabelEdit12.Text:=trim(ePlace.Text);
eCountWieghtChange(Sender);
end;
end;

procedure TFormSend.PageControl1Change(Sender: TObject);
var q:TQUERY;
begin
if PageControl1.ActivePage=TabSheet3 then
begin
if CbType.GetData=1 then
begin
q:=sql.Select(send_table,'ContractType_Ident,NumberServ,DateSupp,Ident',
              'ContractType_Ident=1 and NumberServ is not NULL and DateSupp'+
              ' is not NULL','Ident DESC') ;
if (not q.eof )and (trim(LabelEdit11.Text)='') then
LabelEdit11.Text:=q.FieldByName('NumberServ').AsString;
q.Free;
q:=sql.Select(send_table,'ContractType_Ident,NumberPP,DateSupp,Ident',
              'ContractType_Ident=1 and NumberPP is not NULL and DateSupp'+
              ' is not NULL','Ident DESC') ;
if (not q.eof) and (trim(LabelEdit13.Text)='')then
LabelEdit13.Text:=q.FieldByName('NumberPP').AsString;
q.Free;
end;
end;
end;

procedure TFormSend.N8Click(Sender: TObject);
var i,j:integer;
    Foc:boolean;
begin
 i:=FormSend.ComponentCount;
 j:=1;
 Foc:=true;
 while (j<i)and Foc do
 begin
 {if FormSend.Components[j] then
 begin
 Foc:=false;
 braek;
 end;     }
  j:=j+1;
 end ;
 //FormSend.Components[j].t
end;

procedure TFormSend.cbTypeExit(Sender: TObject);
var FW:real;
days: integer;
begin
if (cbType.GetData=2) then
begin
//days:=0;
days:=sql.SelectInteger('City','DaysDel','Ident='+IntToStr(cbPynkt.GetData));
  If LabelEditDate2.Text='  .  .    ' then
  LabelEditDate4.Text:=FormatDateTime('dd.mm.yyyy',IncDay(StrToDate(LabelEditDate1.text),days))
  else   LabelEditDate4.Text:=FormatDateTime('dd.mm.yyyy',IncDay(StrToDate(LabelEditDate2.text),days));
if (trim(eCountWieght.text)<>'')   {автоперевозки}
and (trim(eCountWieght.Text)<>'0')
then
begin
FW:=StrToFloat(trim(eCountWieght.text));
if FW<200 then eTariff.text:=sql.SelectString('City','Tariff200',
                             'Ident='+IntToStr(cbPynkt.GetData));
if (FW>=200) and (FW<500) then eTariff.text:=sql.SelectString('City','Tariff500',
                               'Ident='+IntToStr(cbPynkt.GetData));
if (FW>=500)and(FW<1000) then eTariff.text:=sql.SelectString('City','Tariff1000',
                              'Ident='+IntToStr(cbPynkt.GetData));
if (FW>=1000)and(FW<2000) then eTariff.text:=sql.SelectString('City','Tariff2000',
                             'Ident='+IntToStr(cbPynkt.GetData));
if (FW>=2000) then eTariff.text:=sql.SelectString('City','TariffMore2000',
                                              'Ident='+IntToStr(cbPynkt.GetData));
end;
end else if cbType.GetData=1 then
 begin

 end   {ждперевозки}
 else begin
         Application.MessageBox('Выберите тип перевозки!','Ошибка',0);
         cbType.SetFocus;
         exit;
      end;
 if (trim(eTariff.text)<>'0.00') and (trim(eCountWieght.Text)<>'0')
 and(trim(eTariff.text)<>'')and (trim(eCountWieght.Text)<>'')
then
begin
  eFare.Text:=Fare(trim(eTariff.text),trim(eCountWieght.Text));
end else    eFare.Text:='0.00' ;
InsuranceSumMin;
eInsuranceSumChange(Sender);
end;

procedure TFormSend.BitBtn5Click(Sender: TObject);
var V:string;
    TEs:boolean;
begin
  TEs:=false;
  FormVCalc:=TFormVCalc.Create(Application) ;
  V:='';
  FormVCalc.AddRecord(TEs,V);
  if V<>'' then
    eVolume.Text:=V;
  if TEs then CheckBox3.Checked:=TEs;
    FormVCalc.Free;
end;

procedure TFormSend.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then
  begin
   LabelEditDate1Exit(Sender);
   LabelEditDate2Exit(Sender);
   LabelEditDate3Exit(Sender);
   btOkClick(Sender);
  end;
end;

procedure TFormSend.BitBtn9Click(Sender: TObject);
var l:longint;
begin
if cbZak.GetData<>0 then
begin
cbZak.GetData;
Card:=TCard.Create(Application) ;
l:=Card.EditRecord(cbZak.GetData);
if l<>0 then
    begin
    cbZak.Recalc;
    cbZak.SetActive(l);
    cbOtpr.Recalc;
  //  cbOtpr.SetActive(l);
    end;
Card.Free;
cbZakChange(Sender);
end;
end;

procedure TFormSend.BitBtn10Click(Sender: TObject);
var
UWFloat: real;
begin
if (trim(eWieght.text)<>'') and (trim(eWieght.text)<>'0.00') then
begin
  UWFloat:=StrToFloat(sql.Selectstring('Constant','UnitVol',''));
  UWFloat:=StrToFloat(trim(eWieght.text))/UWFloat ;
// eVolume.Text:=StrTo00(FloatToStr(UWFloat));
eVolume.Text:=FloatToStr(UWFloat);
end;
end;

procedure TFormSend.LblEditMoney6Change(Sender: TObject);
begin
{сумма за доп услуги}
if  (StrToDate(LabelEditDate1.text) > StrToDate('31.05.2012')) then      {сумму по доп услуге не суммируем с перевозной платой с 01.06.2012 }
begin
if ((trim(eExpCount.text)<>'') and (trim(eExpCount.text)<>'0.00'))
   or ((trim(LabelInteger2.text)<>'')and (trim(LabelInteger2.text)<>'0'))
   or ((trim(LblEditMoney3.text)<>'') and (trim(LblEditMoney3.text)<>'0.00'))
   or ((trim(LblEditMoney6.text)<>'') and (trim(LblEditMoney6.text)<>'0.00'))   {доп услуги}
then begin
eAddServicePrace.Visible:=true;
eAddServicePrace.Text:=addService;
end else  eAddServicePrace.Visible:=false;
end else
    begin
     if (trim(LblEditMoney6.text)<>'') and (trim(LblEditMoney6.text)<>'0.00') then
         eCountWieghtChange(Sender);
    end;
end;


procedure TFormSend.InsuranceSumMin;
begin
if (trim(eCountWieght.Text) <> '') and (trim(eCountWieght.Text) <> '0') then
begin
if StrToFloat(trim(eInsuranceSum.text)) < (StrToFloat(trim(eCountWieght.Text))*100) then
eInsuranceSum.text:= StrTo00(FloatToSTR((StrToFloat(trim(eCountWieght.Text))*100))) ;
end;
end;
procedure TFormSend.CheckBox8Click(Sender: TObject);
begin

eTariff.text:='0.00' ;
eCountWieghtChange(Sender);
end;


procedure TFormSend.RadioGroup1Exit(Sender: TObject);
begin
if  (trim(ePercent.text)='0') and (RadioGroup1.ItemIndex=1) then
 ePercent.text:='5';
end;

procedure TFormSend.ePercentExit(Sender: TObject);
begin
if (trim(eTariff.text) <>'0.00') and  (trim(eTariff.text) <>'') then
 eCountWieghtChange(Sender);
end;

end.

