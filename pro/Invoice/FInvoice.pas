unit FInvoice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LblEdtDt, Sqlctrls, Lbsqlcmb, StdCtrls, Buttons, BMPBtn,
  ComCtrls, DB, TSQLCLS, DBTables, Tadjform, SqlGrid, OleServer,
  Word2000, Menus, Lbledit, DateUtils, QDialogs, EntrySec, Logger;

type
  TFormInvoice = class(TForm)
    HeaderControl1: THeaderControl;
    btPrint: TBMPBtn;
    btCansel: TBMPBtn;
    cbClient: TLabelSQLComboBox;
    LabelEditDate1: TLabelEditDate;
    WordApplication1: TWordApplication;
    cbAktReturn: TCheckBox;
    btOk: TBMPBtn;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    eNumber: TLabelEdit;
    procedure btCanselClick(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure print;
    procedure SaveInvoice;
    procedure cbClientChange(Sender: TObject);
    procedure LabelEditDate1Exit(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eNumberChange(Sender: TObject);
    procedure erExit(Sender: TObject);
  private
    { Private declarations }
  public
  Function AddRecord(i:longint):longint;
  Function EditRecord(Iden:longInt):longint;
  Function Num:string;
 // function IDSend(SendSTR:string):integer;
    { Public declarations }
  end;

var
  FormInvoice: TFormInvoice;
  Ident:longint;  {идент клиента}
  IdInv:longint; {идент счет фактуры}
  Number:string;
  NumberChange :string; {номер измененный}
  Dat:string;
  SumNDS:real; {сумма с НДС}
  Sum:real;     {сумма без НДС}
  NDS:real;    {сумма НДС}
  Fee:real;    {сумма вознаграждение агента}
  StrIdSend:string; {список номеров отправок для сф}
  code:integer;      {идентификатор 0-создаем новую, 1-создаем из вне, 2-исправляем}
  erExitTest:boolean;
  implementation
Uses makerepp ,SendStr,Invoice, Menu;
{$R *.dfm}

Function TFormInvoice.AddRecord(i:longint):longint;
begin
  NumberChange:='';
  code:=0;
  Ident:=0;
  Number:='';
  LabelEditDate1.enabled:=true;
  cbClient.enabled:=true;
  LabelEditDate1.Text:=FormatDateTime('dd.mm.yyyy',now);
  Dat:=LabelEditDate1.Text;
  cbAktReturn.Visible:=false;
  btOk.Visible:=false;
  if i<>0 then
  begin
    Ident:=i ;
    cbClient.SetActive(Ident);
    code:=1;
  end;
  if showModal=mrOk then
  begin
    AddRecord:=1;
  end
  else
    AddRecord:=0;
end;

Function TFormInvoice.EditRecord(Iden:longInt):longint;
var
  q:TQuery;
  s:string;
  SumGd:  Real;    {сумма за жд перевозку}
  NDSGD:  Real;    {НДС с суммы за жд перевозку}
  SumAvt: Real;    {сумма за авто перевозку}
  NDSAvt: Real;    {НДС с суммы за авто перевозку}
  SumAg:  Real;    {сумма вознагрождение агента}
  NDSAg:  Real;    {НДС с вознаграждения агента}
  SumPak: Real;    {сумма за упаковку}
  NDSPak: Real;    {НДС с суммы за упаковку}
  SumPakAg:Real;   {сумма вознаграждения за упаковку}
  NDSPakAg:Real;   {НДС с суммы вознаграждения за упаковку}
  SumSt:  real;    {сумма страхования}
  NDSSt:  real;    {НДС со страхования}
  SumStAg:real;    {сумма вознаграждения агента за страхование}
  NDSStAg:real;    {НДС с суммы вознагражд. агента за страх.}
  NEWN:integer;
  fields: string;
  upd_thread: TUpdateThread;
  update_thread: TUpdateThread;
begin
  IdInv:=0;
  Number:='';
  NumberChange:='';
  IdInv:=Iden;
  q:=sql.Select(EntrySec.invoice_table {'Invoice'},'','Ident='+IntToStr(IdInv),'') ;
  Number:=q.FieldByName('Number').AsString;
  NumberChange:=q.FieldByName('Number').AsString;
  eNumber.Text:=q.FieldByName('Number').AsString;
  LabelEditDate1.text:=FormatDateTime('dd.mm.yyyy',StrToDate(q.FieldByName('Data').AsString));
  NEWN:=1;
  Dat:=FormatDateTime('dd.mm.yyyy',StrToDate(q.FieldByName('Data').AsString));
  cbClient.SetValue(q);
  cbAktReturn.Visible:=true;
  if (q.FieldByName('ReportReturn').AsInteger=1) then
    cbAktReturn.checked:=true
  else
    cbAktReturn.checked:=false;
  //LabelEditDate1.enabled:=false;
  //cbClient.enabled:=false;
  btOk.Visible:=true;
  q.Free;
  Code:=2;
  if (showModal=mrOk) then
  begin
    strIdSend:='';
    q:=sql.Select(EntrySec.sends_view {'Sends'},'DateSupp,Ident,CountInvoice','Invoice_Ident='+IntToStr(IdInv)
        ,'DateSupp');
    if (not q.Eof) then
    begin
      while (not q.Eof) do
      begin
        strIdSend:=strIdSend+','+q.FieldByName('Ident').AsString;
        q.Next;
      end;
      if (Pos(',',strIdSend)=1) then
        Delete(strIdSend,1,1);
      InvoiceCount(Ident,StrIdSend,NewN);
      // Print;
    end
    else
    begin
      ShowMessage('Ненайдено отправок на счет фактуру с номером '+
          Number +'!');
      EditRecord:=0;
      exit;
    end;
    q.Free;
    //---------------------------------------
    Sum:=0;
    SumNDS:=0;
    NDS:=0;
    Fee:=0;
    SumGd:=0;
    NDSGD:=0;
    SumAvt:=0;
    NDSAvt:=0;
    SumAg:=0;
    NDSAg:=0;
    SumPak:=0;
    NDSPak:=0;
    SumPakAg:=0;
    NDSPakAg:=0;
    SumSt:=0;
    NDSSt:=0;
    SumStAg:=0;
    NDSStAg:=0;

    q:=sql.Select('PrintInvoice','Sum,SumNDS,NDS','Send_Ident in ('+StrIdSend+')','');
    if (q.Eof) then
    begin
      EditRecord:=0;
      exit;
    end
    else
    begin
      while (not q.eof) do
      begin
        Sum:=Sum+q.FieldByName('Sum').AsFloat;
        SumNDS:=SumNDS+q.FieldByName('SumNDS').AsFloat;
        NDS:=NDS+q.FieldByName('NDS').AsFloat;
        q.Next;
      end;
    end;
    q.Free;
    //----------------------
    q:=sql.Select('PrintInvoice','NameGood,SumNDS,','Send_Ident in ('+StrIdSend+')' +
                      ' and (NameGOOD like ''Вознагр.%'')','');
    while (not q.Eof) do
    begin
      Fee:=Fee+q.fieldByName('SumNDS').AsFloat;
      q.Next;
    end;
    q.Free;
    //----------------
    q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
                ' and NameGood='+
                sql.Makestr('Перевозка грузобагажа ж/д транспортом'),'') ;
    while (not q.eof) do
    begin
      SumGd:=SumGd+q.FieldByName('SumNDS').AsFloat;
      NDSGD:=NDSGD+q.FieldByName('NDS').AsFloat;
      q.Next;
    end;
    q.Free;
    //----------------
    q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
                  ' and NameGood='+
                  sql.Makestr('Перевозка грузобагажа автотранспортом'),'') ;
    while (not q.eof) do
    begin
      SumAvt:=SumAvt+q.FieldByName('SumNDS').AsFloat;
      NDSAvt:=NDSAvt+q.FieldByName('NDS').AsFloat;
      q.Next;
    end;
    q.Free;
    //----------------
    q:=sql.Select('PrintInvoice','SumNDS,NDS', 'Send_Ident in ('+StrIdSend+')' +
                 ' and NameGood='+
                 sql.Makestr('Вознагр. агента за организацию перевозки'),'') ;
    while (not q.eof) do
    begin
      SumAg:=SumAg+q.FieldByName('SumNDS').AsFloat;
      NDSAg:=NDSAg+q.FieldByName('NDS').AsFloat;
      q.Next;
    end;
    q.Free;
    //----------------
    q:=sql.Select('PrintInvoice','SumNDS,NDS', 'Send_Ident in ('+StrIdSend+')' +
                 ' and NameGood='+ sql.Makestr('Упаковочный материал'),'') ;
    while (not q.eof) do
    begin
      SumPak:=SumPak+q.FieldByName('SumNDS').AsFloat;
      NDSPak:=NDSPak+q.FieldByName('NDS').AsFloat;
      q.Next;
    end;
    q.Free;
    //----------------
    q:=sql.Select('PrintInvoice','SumNDS,NDS', 'Send_Ident in ('+StrIdSend+')' +
                  ' and NameGood='+ sql.Makestr('Вознагр. агента за упаковку'),'') ;
    while (not q.eof) do
    begin
      SumPakAg:=SumPakAg+q.FieldByName('SumNDS').AsFloat;
      NDSPakAg:=NDSPakAg+q.FieldByName('NDS').AsFloat;
      q.Next;
    end;
    q.Free;
    //----------------
    q:=sql.Select('PrintInvoice','SumNDS,NDS', 'Send_Ident in ('+StrIdSend+')' +
                  ' and NameGood='+ sql.Makestr('Страхование'),'') ;
    while (not q.eof) do
    begin
      SumSt:=SumSt+q.FieldByName('SumNDS').AsFloat;
      NDSSt:=NDSSt+q.FieldByName('NDS').AsFloat;
      q.Next;
    end;
    q.Free;
    //----------------
    q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
                  ' and NameGood='+ sql.Makestr('Вознагр. агента за страхование'),'') ;
    while (not q.eof) do
    begin
      SumStAg:=SumStAg+q.FieldByName('SumNDS').AsFloat;
      NDSStAg:=NDSStAg+q.FieldByName('NDS').AsFloat;
      q.Next;
    end;
    q.Free;
    //----------------
    if cbAktReturn.Checked then
      s:='ReportReturn='+IntToStr(1)
    else
      s:='ReportReturn='+IntToStr(0);
    //----------------
    if (Dat<>'  .  .    ')  then
      s:=s+', Data = '+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))
    else
      s:=s+',Data = NULL';
    //----------------
    if (Ident<>0) then
      s:=s+', Clients_Ident='+IntToStr(Ident)
    else
      s:=s+', Clients_Ident=NULL';
    //----------------
    s:=S+', Sum = '+sql.MakeStr(StrTo00(FloatToStr(SumNDS)))  ;
    s:=s+', NDS = '+sql.MakeStr(StrTo00(FloatToStr(NDS)));
    s:=s+', Fee = '+sql.MakeStr(StrTo00(FloatToStr(Fee)));
    //----------------
    if NumberChange<>'' then
      s:=s+', Number = '+sql.MakeStr(NumberChange)
    else
      s:=s+', Number = '+sql.MakeStr(Number);
    //----------------
    s:=s+',SumGd='+sql.MakeStr(StrTo00(FloatToStr(SumGd)));
    s:=s+',NDSGd='+sql.MakeStr(StrTo00(FloatToStr(NDSGd)));
    s:=s+',SumAvt='+sql.MakeStr(StrTo00(FloatToStr(SumAvt)));
    s:=s+',NDSAvt='+sql.MakeStr(StrTo00(FloatToStr(NDSAvt)));
    s:=s+',SumAg='+sql.MakeStr(StrTo00(FloatToStr(SumAg)));
    s:=s+',NDSAG='+sql.MakeStr(StrTo00(FloatToStr(NDSAG)));
    s:=s+',SumPak='+sql.MakeStr(StrTo00(FloatToStr(SumPak)));
    s:=s+',NDSPak='+sql.MakeStr(StrTo00(FloatToStr(NDSPak)));
    s:=s+',SumPakAg='+sql.MakeStr(StrTo00(FloatToStr(SumPakAg)));
    s:=s+',NDSPakAg='+sql.MakeStr(StrTo00(FloatToStr(NDSPakAg)));
    s:=s+',SumSt='+sql.MakeStr(StrTo00(FloatToStr(SumSt)));
    s:=s+',NDSSt='+sql.MakeStr(StrTo00(FloatToStr(NDSSt)));
    s:=s+',SumStAg='+sql.MakeStr(StrTo00(FloatToStr(SumStAg)));
    s:=s+',NDSStAg='+sql.MakeStr(StrTo00(FloatToStr(NDSStAg)));
    if (sql.UpdateString(EntrySec.invoice_table {'Invoice'},s,'Ident='+IntToStr(IdInv))<>0) then
    begin
      EditRecord:=0;
      sql.Rollback;
      exit;
    end
    else
    begin
      // success
      // update other tables
      upd_thread:= TUpdateThread.Create(True, EntrySec.invoice_table_other, s, 'Ident='+IntToStr(IdInv));
      upd_thread.Resume();
    end;
    if (NumberChange<>'') then
      Number:=NumberChange;
    fields:='NumberCountPattern='+sql.MakeStr(Number)+','+'Invoice_Ident='+IntToStr(IdInv);
    if (sql.UpdateString(EntrySec.send_table {'Send'}, fields, 'Ident in ('+StrIdSend+')')<>0) then
    begin
      sql.Rollback;
      EditRecord:=0;
      exit;
    end
    else
    begin
      // success
      // update other tables
      update_thread:= TUpdateThread.Create(True, EntrySec.send_table_other, fields, 'Ident in ('+StrIdSend+')');
      update_thread.Resume();
    end;
    sql.Delete('PrintInvoice','Send_Ident in ('+StrIdSend+')');
    EditRecord:=IdInv;
  end
  else
    EditRecord:=IdInv;
end;

procedure TFormInvoice.btCanselClick(Sender: TObject);
begin
  case Application.MessageBox('Все внесенные изменения не будут сохранены!',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: ModalResult:=mrCancel;
    IDNO:exit;
  end;
end;

procedure TFormInvoice.btPrintClick(Sender: TObject);
var q:TQUery;
    i:integer;
    j:integer;
    poin:string;
    DateS:TDate;
    test:boolean;
    NewN:integer;
begin
  Logger.LogInfo(EntrySec.version + '[FInvoice] (TFormInvoice.btPrintClick()) ');
  if (cbClient.GetData = 0) then
  begin
    Application.MessageBox('Выберите заказчика!','Ошибка!',0);
    cbClient.SetFocus;
    exit;
  end;

  if (LabelEditDate1.text = '  .  .    ') then
  begin
    Application.MessageBox('Введите дату формирования счет фактуры!','Ошибка!',0);
    LabelEditDate1.SetFocus;
    exit;
  end;

  NewN:=1;    //Подоходный налог 18% с 01.01.2004 года
  //------------------------------------------------------
  if (NumberChange <> '') then
    if (sql.SelectString(EntrySec.invoice_table {'Invoice'},'Number','Number='+sql.MakeStr(NumberChange)+
                      ' and Ident <> '+IntToStr(IdInv))<>'') then
    begin
      Application.MessageBox('Счет фактура с таким номером уже заведена,'+
                              'введите другой номер!','Ошибка!',0);
      eNumber.SetFocus;
      exit;
    end;
  //------------------------------------------------------
  erExit(Sender);;
  if (not erExitTest) then
  begin
    eNumber.SetFocus;
    exit;
  end;
  if ((Code=0) or (Code=1)) then  {создаем новую}
  begin
    test:=false;
    q:=sql.Select(EntrySec.sends_view {'Sends'},'DateSupp,Ident,CountInvoice','Client_Ident='+IntToStr(Ident)+
             ' and NumberCountPattern is NULL and( (ContractType_Ident=2 and '+
              'DateSupp is not NULL) or (ContractType_Ident=1 and '+
              'DateSupp is not NULL and SumWay is not NULL and '+
              'SumServ is not NULL)) and DateSupp<='+
              sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+
              ' and CountInvoice is not NULL','DateSupp');
    if (q.Eof) then
    begin
      ShowMessage('У клиента '+sql.Selectstring('Clients','Name','Ident='+
                            IntToStr(Ident))+
                            ' нет доставленных или отправленных отправок!');
      exit;
    end
    else
    begin
      strIdSend:='';
      i:=0;
      while (not q.Eof) do
      begin
        j:=q.FieldByName('CountInvoice').AsInteger;
        if (i+j<24) then
        begin
          i:=i+j;
          strIdSend:=strIdSend+','+q.FieldByName('Ident').AsString;
        end
        else
        if (I+J=24) then
        begin
          if (Pos(',',strIdSend)=1) then
            Delete(strIdSend,1,1);
          InvoiceCount(Ident,StrIdSend,NewN);
          if (NumberChange<>'') then
            number:=NumberChange
          else
            Number:=Num;
          SaveInvoice;
          Print;
          sql.Delete('PrintInvoice','Send_Ident in ('+StrIdSend+')');
          StrIdSend:='';
          i:=0;
        end
        else
        begin
          if (Pos(',',strIdSend)=1) then
            Delete(strIdSend,1,1);
          InvoiceCount(Ident,StrIdSend,NewN);
          if (NumberChange<>'') then
            number:=NumberChange
          else
            Number:=Num;
          SaveInvoice;
          Print;
          sql.Delete('PrintInvoice','Send_Ident in ('+StrIdSend+')');
          StrIdSend:=q.FieldByName('Ident').AsString;
          i:=j;
        end;
        q.Next;
      end;
      //----------------------------------
      if (StrIdSend<>'') then
      begin
        if (Pos(',',strIdSend)=1) then
          Delete(strIdSend,1,1);
        q:=sql.Select(EntrySec.send_table {'Send'},'DateSupp','Ident in ('+StrIdSend+')','DateSupp') ;
        DateS:=0;
        if (not q.eof) then
          DateS :=q.FieldByName('DateSupp').AsDateTime;
        if (DateS<(Now-4)) then
          Test:=true;
      end;
      //---------------------------------
      if ((i<21))and (i>0)and (Code=0)and (not test) then
      begin
        poin:='Осталось не распечатанных '+IntToStr(i)+' строк!' ;
        //p:= poin;
      {case Application.MessageBox(p,'Сообщение!',MB_YESNO+MB_ICONQUESTION)  of
      IDYES:
        begin

    Number:=Num;
    InvoiceCount(Ident,StrIdSend);
    Print;
    SaveInvoice;
    StrIdSend:='';
    i:=0;
    end;
IDNO:
end;}
        if (InputQuery('Сообщение!','Продолжить печать?',poin)) then
        begin
          if (Pos(',',strIdSend)=1) then
            Delete(strIdSend,1,1);
          InvoiceCount(Ident,StrIdSend,NewN);
          if (NumberChange<>'') then
            number:=NumberChange
          else
            Number:=Num;
          SaveInvoice;
          Print;
          sql.Delete('PrintInvoice','Send_Ident in ('+StrIdSend+')');
          StrIdSend:='';
          //    i:=0;
        end;
      end
      else
        if ((i>21)and (i>0))or test then
        begin
          if (Pos(',',strIdSend)=1) then
            Delete(strIdSend,1,1);
          InvoiceCount(Ident,StrIdSend,NewN);
          //----------------------------
          if (NumberChange<>'') then
            number:=NumberChange
          else
            Number:=Num;
          //-----------------------------
          SaveInvoice;
          Print;
          sql.Delete('PrintInvoice','Send_Ident in ('+StrIdSend+')');
          StrIdSend:='';
          //     i:=0;
        end;
        q.Free;
      end;
    end
    else
      if (Code=2) then      {исправляем уже существующую}
      begin
        strIdSend:='';
        q:=sql.Select(EntrySec.sends_view {'Sends'},'DateSupp,Ident,CountInvoice','Invoice_Ident='+IntToStr(IdInv)
             ,'DateSupp');
        if (not q.Eof) then
        begin
          while (not q.Eof) do
          begin
            strIdSend:=strIdSend+','+q.FieldByName('Ident').AsString;
            q.Next;
          end;
          if (Pos(',',strIdSend)=1) then
            Delete(strIdSend,1,1);
          InvoiceCount(Ident,StrIdSend,NewN);
          Print;
          sql.Delete('PrintInvoice','Send_Ident in ('+StrIdSend+')');
        end
        else
        begin
          ShowMessage('Ненайдено отправок на счет фактуру с номером '+
                           Number +'!');
          exit;
    end;
    q.Free;
  end;
  ModalResult:=mrOk;
end;

procedure TFormInvoice.Print;
var
  ReportMakerWP:TReportMakerWP;
  p,w1,w2,w3,w4: OleVariant;
  s:string;
  q:tQuery;
  s2, mach:string;
  i1,i2,i3,i4:integer;
  certificate_ini: string;
  invoice_ini: string;
  result: integer;
  label T;
  label T1;
begin
  try
    ReportMakerWP:=TReportMakerWP.Create(Application);
    ReportMakerWP.ClearParam;
    //--------
    q:=sql.Select('BOSS','*','','');
    ReportMakerWP.AddParam('1='+Number);
    s:=SendStr.DataDMstrY(StrToDate(Dat));
    ReportMakerWP.AddParam('2='+s);
    ReportMakerWP.AddParam('3='+q.FieldByName('Acronym').asstring);
    //if Number='' then Number:='/'+FormatDateTime('yy',StrToDate(LabelEditDate1.text));
    ReportMakerWP.AddParam('4='+q.FieldByName('UrAddress').asstring);
    ReportMakerWP.AddParam('5='+q.FieldByName('Telephone').asstring);
    ReportMakerWP.AddParam('6='+q.FieldByName('INN').asstring+'/'+q.FieldByName('KPP').asstring);
    ReportMakerWP.AddParam('7='+q.FieldByName('CalculateCount').asstring);
    s:=sql.SelectString('Bank','Name','Ident='+IntToStr(q.FieldByName('Bank_Ident').asinteger));
    ReportMakerWP.AddParam('8='+s);
    s:=sql.SelectString('Bank','KorCount','Ident='+IntToStr(q.FieldByName('Bank_Ident').asinteger));
    ReportMakerWP.AddParam('9='+s);
    s:=sql.SelectString('Bank','BIK','Ident='+IntToStr(q.FieldByName('Bank_Ident').asinteger));
    ReportMakerWP.AddParam('10='+s);
    ReportMakerWP.AddParam('11='+'Санкт-Петербург');
    ReportMakerWP.AddParam('12='+q.FieldByName('OKONX').asstring);
    ReportMakerWP.AddParam('13='+q.FieldByName('OKPO').asstring);

    ReportMakerWP.AddParam('14='+q.FieldByName('Person').asstring);
    ReportMakerWP.AddParam('15='+q.FieldByName('PersonBug').asstring);
    q.Free;
    //---------
    q:=sql.Select('Clients','*','Ident='+IntToStr(Ident),'');
    ReportMakerWP.AddParam('16='+q.FieldByName('Name').asstring);
    s:=sql.SelectString('Address','AdrName','Clients_Ident='+
        IntToStr(cbClient.SQLComboBox.GetData)+
        ' and Addresstype_Ident='+intToStr(1));
    ReportMakerWP.AddParam('17='+s);
    ReportMakerWP.AddParam('18='+q.FieldByName('Telephone').asstring);
    ReportMakerWP.AddParam('19='+q.FieldByName('INN').asstring+'/'+q.FieldByName('KPP').asstring);
    ReportMakerWP.AddParam('20='+q.FieldByName('CalculatCount').asstring);
    s:=sql.SelectString('Bank','Name','Ident='+IntToStr(q.fieldByName('Bank_Ident').asInteger));
    ReportMakerWP.AddParam('21='+s);
    s:=sql.SelectString('Bank','KorCount','Ident='+IntToStr(q.fieldByName('Bank_Ident').asInteger));
    ReportMakerWP.AddParam('22='+s);
    s:=sql.SelectString('Bank','BIK','Ident='+IntToStr(q.fieldByName('Bank_Ident').asInteger));
    ReportMakerWP.AddParam('23='+s);
    s:=sql.SelectString('City','Name','Ident='+IntToStr(q.fieldByName('City_Ident').asInteger));
    //---------------------------
    if (s<>'') then
      if (pos(' до ',s)<>0) or (pos(' склад',s)<>0) then
        delete(s,pos(' ',s),Length(s)-pos(' ',s)+1);
    //---------------------------
    ReportMakerWP.AddParam('24='+s);
    ReportMakerWP.AddParam('25='+q.FieldByName('OKONX').asstring);
    ReportMakerWP.AddParam('26='+q.FieldByName('OKPO').asstring);
    if (sql.SelectString('Contract','Number','Clients_Ident='+
            IntToStr(Ident)+
            ' and `Start`<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+
            ' and ContractType_Ident=1 and (Finish is NULL or Finish>'+
            sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+')')<>'') then
    begin
      ReportMakerWP.AddParam('27='+'№ '+sql.SelectString('Contract','Number','Clients_Ident='+
          IntToStr(Ident)+
          ' and `Start`<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+
          ' and ContractType_Ident=1 and (Finish is NULL or Finish>'+
          sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+')'));
      s2:=FormatDateTime('dd.mm.yyyy',StrToDate(sql.SelectString('Contract','Start','Clients_Ident='+
          IntToStr(Ident)+
          ' and `Start`<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+
          ' and ContractType_Ident=1 and (Finish is NULL or Finish>'+
          sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+')')));
      ReportMakerWP.AddParam('28='+' от '+S2+' г. (жд)');
    end
    else
    begin
      ReportMakerWP.AddParam('27='+'');
      ReportMakerWP.AddParam('28='+'');
    end;
    if (sql.SelectString('Contract','Number','Clients_Ident='+
             IntToStr(Ident)+
             ' and `Start`<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+
             ' and ContractType_Ident=2 and (Finish is NULL or Finish>'+
             sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+')')<>'') then
    begin
      ReportMakerWP.AddParam('29='+'№ '+sql.SelectString('Contract','Number','Clients_Ident='+
          IntToStr(Ident)+
          ' and `Start`<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+
          ' and ContractType_Ident=2 and (Finish is NULL or Finish>'+
                         sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+')'));
      ReportMakerWP.AddParam('30='+' от '+FormatDateTime('dd.mm.yyyy',StrToDate(sql.SelectString('Contract','Start','Clients_Ident='+
          IntToStr(Ident)+
          ' and `Start`<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+
          ' and ContractType_Ident=2 and (Finish is NULL or Finish>'+
          sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)))+')')))+
          ' г. (авто)');
    end
    else
    begin
      ReportMakerWP.AddParam('29='+'');
      ReportMakerWP.AddParam('30='+'');
    end;
    if (sql.SelectString('Contract','Number','Clients_Ident='+
                         IntToStr(Ident)+' and ContractType_Ident=2 and Finish is NULL')<>'') and
       (sql.SelectString('Contract','Number','Clients_Ident='+
                         IntToStr(Ident)+' and ContractType_Ident=1 and Finish is NULL')<>'') then
      ReportMakerWP.AddParam('31='+', ') else ReportMakerWP.AddParam('31='+'');
    q.Free;
    q:=sql.Select('PrintInvoice','Sum,SumNDS,NDS','Send_Ident in ('+StrIdSend+')','');
    Sum:=0;
    SumNDS:=0;
    NDS:=0;
    Fee:=0;
    if (q.Eof) then
      exit
    else
    begin
      while (not q.eof) do
      begin
        Sum:=Sum+q.FieldByName('Sum').AsFloat;
        SumNDS:=SumNDS+q.FieldByName('SumNDS').AsFloat;
        NDS:=NDS+q.FieldByName('NDS').AsFloat;
        q.Next;
      end;
    end;
    q.Free;

    ReportMakerWP.AddParam('32='+StrTo00(FloatToStr(Sum)));
    ReportMakerWP.AddParam('33='+StrTo00(FloatToStr(NDS)));
    ReportMakerWP.AddParam('34='+StrTo00(FloatToStr(SumNDS)));
    s:=SendStr.MoneyToString(StrTo00(FloatToStr(SumNDS)));
    ReportMakerWP.AddParam('35='+s);
    s:=SendStr.MoneyToString(StrTo00(FloatToStr(NDS)));
    ReportMakerWP.AddParam('36='+s);
    q:=sql.Select('PrintInvoice','NameGood,SumNDS,','Send_Ident in ('+StrIdSend+')' +
        ' and (NameGOOD like ''Вознагр.%'')','');
    while (not q.Eof) do
    begin
      Fee:=Fee+q.fieldByName('SumNDS').AsFloat;
      q.Next;
    end;
    q.Free;
    s:=SendStr.MoneyToString(StrTo00(FloatToStr(Fee)));
    ReportMakerWP.AddParam('37='+s);
    s:='Ident in ('+StrIdSend+')';
    ReportMakerWP.AddParam('38='+s);
    invoice_ini := iff(EntrySec.bAllData, 'Invoice_all.ini', 'Invoice.ini');

    result := ReportMakerWP.DoMakeReport(systemdir+'Invoice\Invoice.rtf',
        systemdir+'Invoice\'+invoice_ini, systemdir+'Invoice\out.rtf');
    if (result<>0) then
    begin
      // report failed
      ReportMakerWP.Free;
      Logger.LogError(EntrySec.version + '[FInvoice] (invoice) ReportMakerWP.DoMakeReport() failed.');
      // application.messagebox('Закройте выходной документ в WINWORD!',
      // 'Совет!',0);
      // goto T;
      exit
    end;
    ReportMakerWP.Free;
    Logger.LogInfo(EntrySec.version + '[FInvoice] (print()) TWordApplication.Create');
    WordApplication1:=TWordApplication.Create(Application);
    p := systemdir+'Invoice\out.rtf';
    w1:=2;
    //----------------------------
    if (Code=2) then    {при повторной печати даем возможность задать кол копий от 0 до 2}
    begin
      i1:=0;
      i2:=0;
      i3:=2;
      i4:=1;
      if (InputQuery('Диалог!','Какое количество копий счет-фактуры распечатать?',i1,i2,i3,i4)) then
        w1:=i1;
    end;
    //----------------------------
    if (w1=0) then       {не печатаем, если пользователь задаст "0" количество копий}
    begin
      goto T;
      exit;
    end;
    mach:='';
    mach:= trim(WordApplication1.UserName);
    w2:=sql.SelectString('Printer','NameA4','ComputerName='+sql.MakeStr(mach));
    WordApplication1.Documents.Open(p,
	      EmptyParam,EmptyParam,EmptyParam,
	      EmptyParam,EmptyParam,EmptyParam,
	      EmptyParam,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam);
    w3:=sql.SelectString('Printer','ComNameA4','ComputerName='+sql.MakeStr(mach));
    if ((VarToStr(w2)='') or (VarToStr(w3)='')) then
    begin
      Logger.LogError(EntrySec.version + '[FInvoice] (invoice) Missed printers info');
      application.MessageBox('Информация о принтерах не внесена в базу для данной машины'+
                       ' или в параметрах WinWord не верно указано имя машины!','Ошибка!',0);
      goto T;
      exit;
    end;
    w4:=WordApplication1.UserName;
    //-----------------------------
    if (w3<>w4) then
      w2:= '\\'+w3+'\'+w2;
    //-----------------------------
    WordApplication1.ActivePrinter:=w2;
    WordApplication1.ActiveDocument.PrintOut(
	      EmptyParam,EmptyParam,EmptyParam,
	      EmptyParam, EmptyParam,EmptyParam,
	      EmptyParam,w1,EmptyParam,
	      EmptyParam,EmptyParam,EmptyParam,
        w2 ,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam,EmptyParam);

T:  WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
        WordApplication1.WindowState:=2;
    WordApplication1.Free;
    Logger.LogInfo(EntrySec.version + '[FInvoice] (print()) after T: WordApplication1.Free');

    ReportMakerWP:=TReportMakerWP.Create(Application);
    ReportMakerWP.ClearParam;
    //---------------------------------
    q:=sql.Select('BOSS','*','','');
    ReportMakerWP.AddParam('1='+Number);
    s:=SendStr.DataDMstrY(StrToDate(Dat));
    ReportMakerWP.AddParam('2='+s);
    ReportMakerWP.AddParam('3='+q.FieldByName('Name').asstring);

    ReportMakerWP.AddParam('14='+q.FieldByName('Person').asstring);
    ReportMakerWP.AddParam('15='+q.FieldByName('PersonBug').asstring);
    q.Free;
    //--------------------------------------------------
    q:=sql.Select('ClientsAll','FullName,inPerson,OnReason',
                'Ident='+IntToStr(Ident),'');
    ReportMakerWP.AddParam('4='+q.FieldByName('FullName').asstring);
    ReportMakerWP.AddParam('5='+q.FieldByName('inPerson').asstring);
    ReportMakerWP.AddParam('6='+q.FieldByName('OnReason').asstring);
    q.Free;
    //----------------------------------------------------
    q:=sql.Select('PrintInvoice','Sum,SumNDS,NDS','Send_Ident in ('+StrIdSend+')','');
    Sum:=0;
    SumNDS:=0;
    NDS:=0;
    Fee:=0;
    if (q.Eof) then
      exit
    else
    begin
      while (not q.eof) do
      begin
        Sum:=Sum+q.FieldByName('Sum').AsFloat;
        SumNDS:=SumNDS+q.FieldByName('SumNDS').AsFloat;
        NDS:=NDS+q.FieldByName('NDS').AsFloat;
        q.Next;
      end;
    end;
    q.Free;

    ReportMakerWP.AddParam('32='+StrTo00(FloatToStr(Sum)));
    ReportMakerWP.AddParam('33='+StrTo00(FloatToStr(NDS)));
    ReportMakerWP.AddParam('34='+StrTo00(FloatToStr(SumNDS)));
    s:=SendStr.MoneyToString(StrTo00(FloatToStr(SumNDS)));
    ReportMakerWP.AddParam('35='+s);
    s:=SendStr.MoneyToString(StrTo00(FloatToStr(NDS)));
    ReportMakerWP.AddParam('36='+s);
    q:=sql.Select('PrintInvoice','NameGood,SumNDS,', 'Send_Ident in ('+StrIdSend+')' +
        ' and (NameGOOD like ''Вознагр.%'')','');
    while (not q.Eof) do
    begin
      Fee:=Fee+q.fieldByName('SumNDS').AsFloat;
      q.Next;
    end;
    q.Free;
    s:=SendStr.MoneyToString(StrTo00(FloatToStr(Fee)));
    ReportMakerWP.AddParam('37='+s);
    s:='Ident in ('+StrIdSend+')';
    ReportMakerWP.AddParam('38='+s);
    certificate_ini := iff(EntrySec.bAllData, 'Certificate_all.ini', 'Certificate.ini');
    //-----------------------------------------
    result:=ReportMakerWP.DoMakeReport(systemdir+'Invoice\Certificate.rtf',
        systemdir+'Invoice\' + certificate_ini, systemdir+'Invoice\out1.rtf');
    if (result<>0) then
    begin
      ReportMakerWP.Free;
      Logger.LogError(EntrySec.version + '[FInvoice] (certificate) ReportMakerWP.DoMakeReport() (Certificate) failed.');
      // application.messagebox('Закройте выходной документ в WINWORD!',
      //     'Warning!',0);
      // goto T1;
      exit;
    end;
    //-----------------------------------------
    ReportMakerWP.Free;
    WordApplication1:=TWordApplication.Create(Application);
    p := systemdir+'Invoice\out1.rtf';
    w1:=2;
    if (Code=2) then    {при повторной печати даем возможность задать кол копий от 0 до 2}
    begin
      i1:=0;
      i2:=0;
      i3:=2;
      i4:=1;
      if (InputQuery('Диалог!','Какое количество копий акта распечатать?',i1,i2,i3,i4)) then
        w1:=i1;
    end;
    if (w1=0) then       {не печатаем, если пользователь задаст "0" количество копий}
    begin
      goto T1;
      exit;
    end;
    mach:='';
    mach:= trim(WordApplication1.UserName);
    w2:=sql.SelectString('Printer','NameA4','ComputerName='+sql.MakeStr(mach));
    WordApplication1.Documents.Open(p,
	      EmptyParam,EmptyParam,EmptyParam,
	      EmptyParam,EmptyParam,EmptyParam,
	      EmptyParam,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam);

    w3:=sql.SelectString('Printer','ComNameA4','ComputerName='+sql.MakeStr(mach));
    if ((VarToStr(w2)='') or (VarToStr(w3)='')) then
    begin
      Logger.LogError(EntrySec.version + '[FInvoice] (certificate) Missed printers info');
      application.MessageBox('Информация о принтерах не внесена в базу для данной машины'+
          ' или в параметрах WinWord не верно указано имя машины!','Ошибка!',0);
      goto T1;
      exit;
    end;

    w4:=WordApplication1.UserName;
    if (w3<>w4) then
      w2:= '\\'+w3+'\'+w2;

    WordApplication1.ActivePrinter:=w2;
    WordApplication1.ActiveDocument.PrintOut(
	      EmptyParam,EmptyParam,EmptyParam,
	      EmptyParam, EmptyParam,EmptyParam,
	      EmptyParam,w1,EmptyParam,
	      EmptyParam,EmptyParam,EmptyParam,
        w2,EmptyParam,EmptyParam,
        EmptyParam,EmptyParam,EmptyParam);
T1: WordApplication1.Documents.Close(EmptyParam,EmptyParam,
        EmptyParam);
        WordApplication1.WindowState:=2;
    WordApplication1.Free;
  except
    Logger.LogError(EntrySec.version + '[FInvoice] [Print] Exceptions happened.');
    WordApplication1.Documents.Close(EmptyParam,EmptyParam, EmptyParam);
    application.MessageBox('Проверьте все настройки для печати!','Error!',0);
    exit;
  end;
end;

procedure TFormInvoice.SaveInvoice;
var str: string;
    q:TQuery;
    l:longInt;
    SumGd:  Real;    {сумма за жд перевозку}
    NDSGD:  Real;    {НДС с суммы за жд перевозку}
    SumAvt: Real;    {сумма за авто перевозку}
    NDSAvt: Real;    {НДС с суммы за авто перевозку}
    SumAg:  Real;    {сумма вознагрождение агента}
    NDSAg:  Real;    {НДС с вознаграждения агента}
    SumPak: Real;    {сумма за упаковку}
    NDSPak: Real;    {НДС с суммы за упаковку}
    SumPakAg:Real;   {сумма вознаграждения за упаковку}
    NDSPakAg:Real;   {НДС с суммы вознаграждения за упаковку}
    SumSt:  real;    {сумма страхования}
    NDSSt:  real;    {НДС со страхования}
    SumStAg:real;    {сумма вознаграждения агента за страхование}
    NDSStAg:real;    {НДС с суммы вознагражд. агента за страх.}

    upd_thread: TUpdateThread;
    ins_thread: TInsertThread;
    insert_fields: string;
    update_fields: string;

    label Ins;
    label Control;

begin
 q:=sql.Select('PrintInvoice','Sum,SumNDS,NDS','Send_Ident in ('+StrIdSend+')','');
  Sum:=0;
  SumNDS:=0;
  NDS:=0;
  Fee:=0;
    SumGd:=0;
    NDSGD:=0;
    SumAvt:=0;
    NDSAvt:=0;
    SumAg:=0;
    NDSAg:=0;
    SumPak:=0;
    NDSPak:=0;
    SumPakAg:=0;
    NDSPakAg:=0;
    SumSt:=0;
    NDSSt:=0;
    SumStAg:=0;
    NDSStAg:=0;


  if q.Eof then exit
  else begin
        While (not q.eof) do
        begin
         Sum:=Sum+q.FieldByName('Sum').AsFloat;
         SumNDS:=SumNDS+q.FieldByName('SumNDS').AsFloat;
         NDS:=NDS+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
       end;
  q.Free;
  //----------------
  q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
               ' and NameGood='+
                sql.Makestr('Перевозка грузобагажа ж/д транспортом'),'') ;
    While (not q.eof) do
        begin
         SumGd:=SumGd+q.FieldByName('SumNDS').AsFloat;
         NDSGD:=NDSGD+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
  q.Free;
 //----------------
    q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
                  ' and NameGood='+
                   sql.Makestr('Перевозка грузобагажа автотранспортом'),'') ;
    While (not q.eof) do
        begin
         SumAvt:=SumAvt+q.FieldByName('SumNDS').AsFloat;
         NDSAvt:=NDSAvt+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
                 ' and NameGood='+
                 sql.Makestr('Вознагр. агента за организацию перевозки'),'') ;
    While (not q.eof) do
        begin
         SumAg:=SumAg+q.FieldByName('SumNDS').AsFloat;
         NDSAg:=NDSAg+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
                 ' and NameGood='+
                 sql.Makestr('Упаковочный материал'),'') ;
    While (not q.eof) do
        begin
         SumPak:=SumPak+q.FieldByName('SumNDS').AsFloat;
         NDSPak:=NDSPak+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
                 ' and NameGood='+
                  sql.Makestr('Вознагр. агента за упаковку'),'') ;
    While (not q.eof) do
        begin
         SumPakAg:=SumPakAg+q.FieldByName('SumNDS').AsFloat;
         NDSPakAg:=NDSPakAg+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
  q:=sql.Select('PrintInvoice','NameGood,SumNDS,','Send_Ident in ('+StrIdSend+')' +
                ' and (NameGOOD like ''Вознагр.%'')','');
  while not q.Eof do
  begin
  Fee:=Fee+q.fieldByName('SumNDS').AsFloat;
  q.Next;
  end;
  q.Free;
 //----------------
    q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
                  ' and NameGood='+ sql.Makestr('Страхование'),'') ;
    While (not q.eof) do
        begin
         SumSt:=SumSt+q.FieldByName('SumNDS').AsFloat;
         NDSSt:=NDSSt+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------
   q:=sql.Select('PrintInvoice','SumNDS,NDS','Send_Ident in ('+StrIdSend+')' +
                 ' and NameGood='+
                 sql.Makestr('Вознагр. агента за страхование'),'') ;
    While (not q.eof) do
        begin
         SumStAg:=SumStAg+q.FieldByName('SumNDS').AsFloat;
         NDSStAg:=NDSStAg+q.FieldByName('NDS').AsFloat;
         q.Next;
        end;
   q.Free;
 //----------------

l:=sql.FindNextInteger('Ident',EntrySec.invoice_table {'Invoice'},'',MaxLongint);
str:=IntToStr(l);
str:=str+','+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(Dat)));
str:=str+','+IntToStr(Ident);
str:=Str+','+sql.MakeStr(StrTo00(FloatToStr(SumNDS)))  ;
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(NDS)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(Fee)));
str:=str+','+IntToStr(0);
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(SumGd)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(NDSGd)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(SumAvt)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(NDSAvt)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(SumAg)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(NDSAG)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(SumPak)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(NDSPak)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(SumPakAg)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(NDSPakAg)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(SumSt)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(NDSSt)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(SumStAg)));
str:=str+','+sql.MakeStr(StrTo00(FloatToStr(NDSStAg)));
control:
if sql.SelectString(EntrySec.invoice_table {'Invoice'},'Number','Number='+sql.MakeStr(Number))<>''
then begin
     if NumberChange<>'' then
     begin
      Application.MessageBox('Счет фактура с таким номером уже заведена,'+
                              'введите другой номер!','Ошибка!',0);
      eNumber.SetFocus;
      exit
     end;
     Number:=Num;
     goto Control;
     end
      else goto Ins;
Ins: str:=str+','+sql.MakeStr(Number);
insert_fields:='Ident,Data,Clients_Ident,Sum,'+
                    'NDS,Fee,ReportReturn,SumGD,NDSGd,SumAvt,NDSAvt,'+
                    'SumAg,NDSAg,SumPak,NDSPak,SumPakAg,NDSPakAg,SumSt,'+
                    'NDSSt,SumStag,NDSStAg,Number';
if sql.InsertString(EntrySec.invoice_table {'Invoice'},insert_fields,str)<>0 then
                                                        begin
                                                        sql.Rollback;
                                                        exit;
                                                        end
else
begin
// success
//update other tables
  ins_thread:= TInsertThread.Create(True, EntrySec.invoice_table_other, insert_fields, str);
  ins_thread.Resume();

end;

update_fields:='NumberCountPattern='+sql.MakeStr(Number)+','+
                    'Invoice_Ident='+IntToStr(l);
if sql.UpdateString(EntrySec.send_table {'Send'},update_fields,
                    'Ident in ('+StrIdSend+')')<>0 then begin
                                                        sql.Rollback;
                                                        exit;
                                                        end
else
begin
  upd_thread:= TUpdateThread.Create(True, EntrySec.send_table_other, update_fields, 'Ident in ('+StrIdSend+')');
  upd_thread.Resume();
end;

end;

Function TFormInvoice.Num:string;
var q:TQuery;
    Year, Month, Day: Word;
    Num1,Num2:string;
    N1,N2:integer;
begin
if Dat<>'  .  .    '  then
DecodeDate(StrToDate(Dat), Year, Month, Day)
else begin
    Application.MessageBox('Введите дату составления!','Ошибка!',0);
    exit
    end;
q:=sql.select(EntrySec.invoiceview_view {'InvoiceView'},'Number,`Year`','`Year`='+IntToStr(Year),'');
if q.eof then Num:='1/'+FormatDateTime('yy',StrToDate(Dat))
     else
     begin
      Num1:=q.fieldByName('Number').AsString;
      N1:=pos('/',Num1);
      delete(Num1,N1,Length(Num1)-N1+1) ;
      N1:=StrToInt(Num1);
      while not q.Eof do
      begin
      Num2:=q.fieldByName('Number').AsString;
      N2:=pos('/',Num2);
      delete(Num2,N2,Length(Num2)-N2+1) ;
      N2:=StrToInt(Num2);
      if N1<N2 then N1:=N2;
      q.Next;
      end;
     Num:=IntToStr(N1+1)+'/'+FormatDateTime('yy',StrToDate(Dat));
     end;

 q.free;
end;
procedure TFormInvoice.cbClientChange(Sender: TObject);
begin
Ident:=cbClient.SQLComboBox.GetData;
end;

procedure TFormInvoice.LabelEditDate1Exit(Sender: TObject);
begin
Dat:=LabelEditDate1.text;
end;

procedure TFormInvoice.btOkClick(Sender: TObject);
begin
if  cbClient.GetData=0 then
begin
   Application.MessageBox('Выберите заказчика!','Ошибка!',0);
   cbClient.SetFocus;
   exit;
end;
if LabelEditDate1.text='  .  .    '  then
begin
   Application.MessageBox('Введите дату формирования счет фактуры!','Ошибка!',0);
   LabelEditDate1.SetFocus;
   exit;
end;

erExit(Sender);

if not erExitTest then
begin
  eNumber.SetFocus;
  exit;
end;

if sql.SelectString(EntrySec.invoice_table {'Invoice'},'Number','Number='+sql.MakeStr(NumberChange)+
                      ' and Ident <> '+IntToStr(IdInv))<>'' then
  begin
    Application.MessageBox('Счет фактура с таким номером уже заведена,'+
                              'введите другой номер!','Ошибка!',0);
    eNumber.SetFocus;
    exit;
  end
  else
  begin
    ModalResult:=mrOk;
  end
end;

procedure TFormInvoice.N1Click(Sender: TObject);
begin
if cbAktReturn.Checked then
  cbAktReturn.Checked:=False
else
  cbAktReturn.Checked:=true;
end;

procedure TFormInvoice.FormCreate(Sender: TObject);
begin
//cbClient.SQLComboBox.Sorted:=true;
// krutogolov
Caption := 'Счет фактура ( ' + EntrySec.period+ ' )';
//cbAktReturn.Enabled := iff (EntrySec.bAllData, False, True);
end;

procedure TFormInvoice.FormKeyDown(Sender: TObject;
var
  Key: Word;
  Shift: TShiftState);
begin
if key = VK_Return
  then btPrintClick(Sender)
end;

procedure TFormInvoice.eNumberChange(Sender: TObject);
begin
if  eNumber.Text<>'' then
  NumberChange:=trim(eNumber.Text)
else
  NumberChange:='';
end;

procedure TFormInvoice.erExit(Sender: TObject);
var
  numtest: string;
  num1: string;
//    j:      integer;
  y:Word;
begin
  numtest:='';
  erExitTest:=true;
  if NumberChange<>'' then
  begin
    try
      numtest:=trim(NumberChange);
      delete(numtest,length(numtest)-2,3);
      // j:=StrToInt(numtest);
      StrToInt(numtest);
    except
      ShowMessage('Первая часть номера - это число!');
      eNumber.SetFocus;
      erExitTest:=false;
      exit;
    end;
  if LabelEditDate1.text<>'  .  .    ' then
  begin
    y:=YearOf(StrToDate(LabelEditDate1.text));
    numtest:=IntToStr(y);
    delete(numtest,1,2);
    numtest:='/'+numtest;
    num1:=Trim(NumberChange);
    delete(num1,1,Length(num1)-3);
  if  numtest<>num1 then
  begin
    ShowMessage('Вторая часть номера - это "/" и две последние цифры от года,'+
               ' на дату формирования счет-фактуры!');
    erExitTest:=false;
    eNumber.SetFocus;
    exit;
 end;
 end;
end;
end;

end.
