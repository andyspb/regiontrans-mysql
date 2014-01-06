unit FormSendBoxu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BMPBtn, toolbtn, tsqlcls, ToolWin, ComCtrls,Tadjform, SqlGrid,
  StdCtrls, Buttons, OleServer, DBTables, Word2000, LblEdtDt, Sqlctrls,
  Lbsqlcmb, ExtCtrls, EntrySec, DateUtils;

type
  TFormSendBox = class(TadjusTForm)
    ToolBar1: TToolBar;
    eCard: TToolbarButton;
    eDelete: TToolbarButton;
    eExit: TToolbarButton;
    SQLGrid1: TSQLGrid;
    eCreate: TToolbarButton;
    btPrint: TBMPBtn;
    WordApplication1: TWordApplication;
    Panel1: TPanel;
    cbPynkt: TLabelSQLComboBox;
    cbZak: TLabelSQLComboBox;
    LabelEditDate1: TLabelEditDate;
    LabelEditDate2: TLabelEditDate;
    eFilter: TToolbarButton;
    FilterDiscard: TToolbarButton;
    procedure eExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure eCardClick(Sender: TObject);
    procedure eCreateClick(Sender: TObject);
    procedure eDeleteClick(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure eFilterClick(Sender: TObject);
    procedure FilterDiscardClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbUpdateFilterButtons(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSendBox: TFormSendBox;
  send_table: string;
  akttek_table: string;
  invoice_table: string;
  sends_view: string;

implementation

uses makerepp ,SendStr,FormSendu;

{$R *.dfm}

procedure TFormSendBox.eExitClick(Sender: TObject);
begin
  close;
end;

procedure TFormSendBox.FormCreate(Sender: TObject);
var
  all: Boolean;
  cond: string;
begin
// krutogolov
  fsection:='FormSends';
//  sqlGrid1.Section:='Sends';
  sqlGrid1.Section:=EntrySec.sends_view;

  Caption := 'Картотека отправок ( ' + EntrySec.period + ' )';
  all:=EntrySec.bAllData;
  sends_view := iff(all, '`sends_all`', '`sends`');
  send_table := iff(all, '`send_all`', '`send`');
  akttek_table := iff(all, '`akttek_all`', '`akttek`');
  invoice_table := iff(all, '`invoice_all`', '`invoice`');
  // Карточку создавать только если 6М период
  // eCreate.Enabled := iff(all,False,True);
  // удалять можно отвсюду
  // eDelete.Enabled := iff(all, False, true);

  cond := '`Start` >=' + FormatDateTime('yyyy-mm-dd',IncMonth(Date,-6));
  sqlGrid1.ExecTableCond(sends_view,cond);
//cbZak.SQLComboBox.Sorted:=true;
//cbPynkt.SQLComboBox.Sorted:=true;
  if (SQLGrid1.Query.Eof) and (SQLGrid1.Query.bof)then
  begin
    eCard.Enabled:=false;
    edelete.Enabled:=false;
    SQLGrid1.visible:=false;
    btPrint.visible:=false;
  end;
end;

procedure TFormSendBox.eCardClick(Sender: TObject);
var
  result:longint;
begin
  sqlGrid1.SavePoint('Ident');
  sql.StartTransaction;
  FormSend := TFormSend.Create(Application);
  result := FormSend.EditRecord(SQLGrid1.Query);
  FormSend.Free;
  if (result <> 0) then
  begin
    sql.Commit;
    sqlGrid1.Exec;
    if (not SQLGrid1.Query.Eof) or (not SQLGrid1.Query.bof)then
    begin
      eCard.Enabled:=true;
      edelete.Enabled:=true;
      SQLGrid1.visible:=true;
    end;
  end
  else
    sql.Rollback;
end;

procedure TFormSendBox.eCreateClick(Sender: TObject);
var
  result: longint;
begin
  sql.StartTransaction;
  FormSend:=TFormSend.Create(Application) ;
  result:=FormSend.AddRecord;
  FormSend.Free;
  if (result <> 0) then
  begin
    sql.Commit;
    sqlGrid1.Exec;
    sqlGrid1.LoadPoint('Ident', result);
    if (not SQLGrid1.Query.Eof) or (not SQLGrid1.Query.bof)then
    begin
      eCard.Enabled:=true;
      edelete.Enabled:=true;
      SQLGrid1.visible:=true;
    end;
  end
  else
    sql.Rollback;
end;

procedure TFormSendBox.eDeleteClick(Sender: TObject);
var
  ident_str: string;
  del_thread: TDeleteThread;
begin
  sqlGrid1.SaveNextPoint('Ident');
  ident_str:=sqlGrid1.FieldByName('Ident').AsString;
  case Application.MessageBox('Удалить ?', 'Warning!',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
      sql.StartTransaction;
      if sql.Delete(EntrySec.send_table {'Send'},'Ident='+ IntToStr(sqlGrid1.FieldByName('Ident').asInteger))<>0 then
      begin
        Application.MessageBox('Отправка не подлежит удалению!','Ошибка',0);
        sql.rollback;
      end
      else
      begin
        if sqlGrid1.FieldByName('InvoiceNumber').asString<>'' then
          ShowMessage('Отправка просчитана в счет-фактуре № '+ sqlGrid1.FieldByName('InvoiceNumber').asString+'! '+
                  'Пересчитайте счет-фактуру, после удаления! ');
      end;
      sql.commit;
      sqlGrid1.Exec;
      // krutogolov
      // delete from other table
      del_thread := TDeleteThread.Create(True, EntrySec.send_table_other {'`send_all`'}, ident_str);
      del_thread.Resume();
    end;
    IDNO:
    begin
      exit;
    end;
  end;
  if (SQLGrid1.Query.Eof) and (SQLGrid1.Query.bof)then
  begin
    eCard.Enabled:=false;
    edelete.Enabled:=false;
    SQLGrid1.visible:=false;
  end;
end;

procedure TFormSendBox.btPrintClick(Sender: TObject);
var
  ReportMakerWP:TReportMakerWP;
  p,w1,w2,w3,w4: OleVariant;
  s:string;
  Num,mach:string;
  cuttarstring: string;
  f,f1:real;
  i,Nprint, IdSend:integer;
  Typ:integer;
  qPlace:TQuery;
  dateDel: string;
  sendrtf: string;
  clientName:string;
  cur_year: string;
  label T;
begin
  try
  //Typ:=0;
  Typ:=SQLGRID1.Query.FieldByName('ContractType_Ident').AsInteger;
  IdSend:=SQLGRID1.Query.FieldByName('Ident').AsInteger;
  clientName := SQLGRID1.Query.FieldByName('ClientAcr').AsString;
  clientName := trim(clientName);
  ReportMakerWP:=TReportMakerWP.Create(Application);

  ReportMakerWP.ClearParam;
  if Typ=2 then
  begin
    ReportMakerWP.AddParam('1='+SQLGRID1.Query.FieldByName('ClientName').AsString);
    ReportMakerWP.AddParam('2='+SQLGRID1.Query.FieldByName('ClientSenderName').AsString);
    ReportMakerWP.AddParam('3='+SQLGRID1.Query.FieldByName('CityName').AsString);
    ReportMakerWP.AddParam('4='+SQLGRID1.Query.FieldByName('AcceptorName').AsString);
    ReportMakerWP.AddParam('5='+SQLGRID1.Query.FieldByName('AcceptorAddress').AsString+
                            ', т. '+SQLGRID1.Query.FieldByName('AcceptorPhone').AsString);
    ReportMakerWP.AddParam('6='+SQLGRID1.Query.FieldByName('AcceptorRegime').AsString );
    ReportMakerWP.AddParam('7='+SQLGRID1.Query.FieldByName('NameGoodName').AsString );

    s:='';
    if  SQLGRID1.Query.FieldByName('TypeGood_Ident').Asinteger=1 then
      s:=s+', Теплая перевозка' ;
    if SQLGRID1.Query.FieldByName('TypeGood_Ident1').Asinteger=1 then
      s:=s+', Хрупкий груз' ;
    if SQLGRID1.Query.FieldByName('TypeGood_Ident2').Asinteger=1 then
      s:=s+', Негабаритный груз' ;
    if s<>'' then delete(s,1,2);
      cuttarstring:= '';
    if SQLGRID1.Query.FieldByName('CutTarif').AsInteger <> 0 then
      begin
        if SQLGRID1.Query.FieldByName('CutTarif').AsInteger = 1 then cuttarstring:= ' (льготный тариф 3%)';
        if SQLGRID1.Query.FieldByName('CutTarif').AsInteger = 2 then cuttarstring:= ' (льготный тариф 5%)';
        if SQLGRID1.Query.FieldByName('CutTarif').AsInteger = 3 then cuttarstring:= ' (льготный тариф 7%)';
      end;
    ReportMakerWP.AddParam('8='+s );
    ReportMakerWP.AddParam('9='+SQLGRID1.Query.FieldByName('RollOutName').Asstring );
    ReportMakerWP.AddParam('10='+SQLGRID1.Query.FieldByName('PackCount').Asstring  );
    ReportMakerWP.AddParam('11='+SQLGRID1.Query.FieldByName('Weight').Asstring );
    ReportMakerWP.AddParam('12='+SQLGRID1.Query.FieldByName('Volume').Asstring  );
    ReportMakerWP.AddParam('13='+SQLGRID1.Query.FieldByName('CountWeight').Asstring );
    ReportMakerWP.AddParam('14='+StrTo00(SQLGRID1.Query.FieldByName('Tariff').Asstring));
    ReportMakerWP.AddParam('35='+cuttarstring );
    ReportMakerWP.AddParam('15='+StrTo00(SQLGRID1.Query.FieldByName('Fare').Asstring) );
    ReportMakerWP.AddParam('16='+StrTo00(SQLGRID1.Query.FieldByName('InsuranceSum').Asstring ));
    ReportMakerWP.AddParam('17='+StrTo00(SQLGRID1.Query.FieldByName('InsuranceValue').Asstring) );
    ReportMakerWP.AddParam('18='+StrTo00(SQLGRID1.Query.FieldByName('AddServicePrace').Asstring) );
    ReportMakerWP.AddParam('19='+StrTo00(SQLGRID1.Query.FieldByName('SumCount').Asstring) );

    ReportMakerWP.AddParam('20='+SQLGRID1.Query.FieldByName('PayTypeName').Asstring );
    s:=SendStr.MoneyToString(SQLGRID1.Query.FieldByName('SumCount').Asstring);
    ReportMakerWP.AddParam('21='+s );
    ReportMakerWP.AddParam('22='+SQLGRID1.Query.FieldByName('PeopleFIO').Asstring);
    s:=SendStr.DataDMstrY(StrToDate(SQLGRID1.Query.FieldByName('Start').Asstring));
    ReportMakerWP.AddParam('23='+s );
    Num:=SQLGRID1.Query.FieldByName('Namber').Asstring;
    ReportMakerWP.AddParam('24='+Num );
    ReportMakerWP.AddParam('25='+SQLGRID1.Query.FieldByName('Forwarder').Asstring );
    s:='';
    if  SQLGRID1.Query.FieldByName('AddServicePack').AsInteger=1 then
      s:=s+'Упаковка: '+StrTo00(SQLGRID1.Query.FieldByName('PackTarif').Asstring)+' руб';
    if  SQLGRID1.Query.FieldByName('AddServiceExp').AsInteger=1 then
    begin
      f:=StrToFloat(SQLGRID1.Query.FieldByName('ExpTarif').Asstring)*StrToFloat(SQLGRID1.Query.FieldByName('ExpCount').Asstring);
      if s<>'' then
        s:=s+', ';
      s:=s+'Экспедирование: '+StrTo00(FloatToStr(f))+' руб';
    end;
    if  SQLGRID1.Query.FieldByName('AddServiceProp').AsInteger=1 then
    begin
      f:=StrToFloat(SQLGRID1.Query.FieldByName('PropTarif').Asstring)*StrToFloat(SQLGRID1.Query.FieldByName('PropCount').Asstring);
      if s<>'' then
        s:=s+', ';
      s:=s+'Выдача пропусков: '+StrTo00(FloatToStr(f))+' руб';
    end;
    ReportMakerWP.AddParam('26='+s );
    //---------
    i:=0;
    qPlace:=sql.select('SendPack','Count,Send_Ident','Send_Ident='+
                     IntToStr(SQLGRID1.Query.FieldByName('Ident').AsInteger),'');

    while (not qPlace.eof) do
    begin
      i:=i+qPlace.FieldByName('Count').asinteger;
      qPlace.Next;
    end;
    qPlace.free ;

    ReportMakerWP.AddParam('27='+IntToStr(i) );
    s:='';
    if SQLGRID1.Query.FieldByName('DateSend').Asstring <> '' then
      s:=SendStr.DataDMstrY(StrToDate(SQLGRID1.Query.FieldByName('DateSend').Asstring));
    ReportMakerWP.AddParam('28='+s );
    s:='';
    dateDel:= sql.SelectString(EntrySec.send_table {'Send'},'DateDelFirst','Ident='+SQLGRID1.Query.FieldByName('ident').Asstring) ;
    if Datedel<>'' then
      s:=SendStr.DataDMstrY(StrToDate(dateDel));
    if s<>'' then
      ReportMakerWP.AddParam('29='+' Доставка:'+s );
    if  SQLGRID1.Query.FieldByName('AddServSum').Asstring<>''  then       {AddServStr,Sum}
    begin
      ReportMakerWP.AddParam('30='+SQLGRID1.Query.FieldByName('AddServStr').Asstring );
      ReportMakerWP.AddParam('31='+StrTo00(SQLGRID1.Query.FieldByName('AddServSum').Asstring)+' руб' );
    end;
    if sql.SelectInteger(''+ send_table + '','TypeGood_Ident3','Ident='+IntToStr(IdSend))=1 then
      ReportMakerWP.AddParam('32='+'Упаковка груза не соответствует условиям перевозки.'+
                                 ' Без ответственности за механические повреждения.' )
    else
      ReportMakerWP.AddParam('32='+'' );
    // -- add current year
    cur_year:=IntToStr(YearOf(Now));
    ReportMakerWP.AddParam('33='+cur_year );
    sendrtf := 'send\sendU.rtf'; //печать для юр лиц
    if Pos('"', clientName) = 1 then
      sendrtf := 'send\sendCh.rtf'; //печать для частных лиц "ТЭК"

    if ReportMakerWP.DoMakeReport(systemdir+sendrtf,
                             systemdir+'send\send.ini', systemdir+'send\out.rtf')<>0 then
    begin
      ReportMakerWP.Free;
      //application.messagebox('Закройте выходной документ в WINWORD!',
      // 'Совет!',0);
      goto T;
      exit
    end;
    Nprint:=4;
  end
  else
    if Typ=1 then
    begin
      ReportMakerWP.AddParam('1='+SQLGRID1.Query.FieldByName('ClientName').AsString);
      ReportMakerWP.AddParam('2='+SQLGRID1.Query.FieldByName('ClientSenderName').AsString);
      ReportMakerWP.AddParam('3='+SQLGRID1.Query.FieldByName('CityName').AsString);
      ReportMakerWP.AddParam('4='+SQLGRID1.Query.FieldByName('AcceptorName').AsString);
      ReportMakerWP.AddParam('5='+SQLGRID1.Query.FieldByName('AcceptorAddress').AsString+
                              ', т. '+SQLGRID1.Query.FieldByName('AcceptorPhone').AsString);

      s:=SendStr.DataDMstrY(StrToDate(SQLGRID1.Query.FieldByName('DateSend').Asstring ));
      ReportMakerWP.AddParam('6='+s );
      ReportMakerWP.AddParam('7='+SQLGRID1.Query.FieldByName('NameGoodName').AsString);
      ReportMakerWP.AddParam('8='+'Санкт-Петербург-Главный' );
      ReportMakerWP.AddParam('9='+SQLGRID1.Query.FieldByName('Contract').AsString );
      ReportMakerWP.AddParam('10='+SQLGRID1.Query.FieldByName('PackCount').Asstring );
      ReportMakerWP.AddParam('11='+SQLGRID1.Query.FieldByName('Weight').Asstring);
      i:=sql.SelectInteger('City','Check','Ident='+
                            IntToStr(SQLGRID1.Query.FieldByName('City_Ident').AsInteger));
      //f:=0;
      if i=1 then
      begin
        i:=0;
        qPlace:=sql.select('SendPack','Count,Send_Ident','Send_Ident='+
                     IntToStr(SQLGRID1.Query.FieldByName('Ident').AsInteger),'');

        while (not qPlace.eof) do
        begin
          i:=i+qPlace.FieldByName('Count').asinteger;
          qPlace.Next;
        end;
        qPlace.free ;
        f:=StrToFloat(sql.SelectString('Constant','PlaceTariff',''));
        f:=f*i;
      end
      else
        f:=0;

      if f<>0 then
        ReportMakerWP.AddParam('25='+', Наценка за проезд ч/з Москву: '+
                                            StrTo00(FloatToStr(f))+' руб.')
      else
        ReportMakerWP.AddParam('25='+' ');

      f1:=StrToFloat(SQLGRID1.Query.FieldByName('Fare').Asstring)-StrToFloat(SQLGRID1.Query.FieldByName('CountWeight').Asstring)*StrToFloat(SQLGRID1.Query.FieldByName('Tariff').Asstring)/10-f;
      s:=STRTo00(FloatToStr(f1));

      ReportMakerWP.AddParam('12='+S );
      ReportMakerWP.AddParam('13='+SQLGRID1.Query.FieldByName('CountWeight').Asstring );
      ReportMakerWP.AddParam('14='+StrTo00(SQLGRID1.Query.FieldByName('Tariff').Asstring) );
      ReportMakerWP.AddParam('15='+StrTo00(SQLGRID1.Query.FieldByName('Fare').Asstring) );
      ReportMakerWP.AddParam('16='+StrTo00(SQLGRID1.Query.FieldByName('InsuranceSum').Asstring));
      ReportMakerWP.AddParam('17='+StrTo00(SQLGRID1.Query.FieldByName('InsuranceValue').Asstring) );
      ReportMakerWP.AddParam('18='+StrTo00(SQLGRID1.Query.FieldByName('AddServicePrace').Asstring) );
      ReportMakerWP.AddParam('19='+StrTo00(SQLGRID1.Query.FieldByName('SumCount').Asstring) );

      ReportMakerWP.AddParam('20='+SQLGRID1.Query.FieldByName('PayTypeName').Asstring);
      s:=SendStr.MoneyToString(SQLGRID1.Query.FieldByName('SumCount').Asstring);
      ReportMakerWP.AddParam('21='+s );
      ReportMakerWP.AddParam('22='+SQLGRID1.Query.FieldByName('PeopleFIO').Asstring );
      s:=SendStr.DataDMstrY(StrToDate(SQLGRID1.Query.FieldByName('Start').Asstring));
      ReportMakerWP.AddParam('23='+s );
       ReportMakerWP.AddParam('24='+'Северная' );
        s:='';
      if  SQLGRID1.Query.FieldByName('AddServicePack').AsInteger=1 then
         s:=s+'Упаковка: '+StrTo00(SQLGRID1.Query.FieldByName('PackTarif').Asstring)+' руб';
       if  SQLGRID1.Query.FieldByName('AddServiceExp').AsInteger=1 then
        begin
           f:=StrToFloat(SQLGRID1.Query.FieldByName('ExpTarif').Asstring)*StrToFloat(SQLGRID1.Query.FieldByName('ExpCount').Asstring);
         if s<>'' then s:=s+', ';
            s:=s+'Экспедирование: '+StrTo00(FloatToStr(f))+' руб';
        end;
       if  SQLGRID1.Query.FieldByName('AddServiceProp').AsInteger=1 then
        begin
         f:=StrToFloat(SQLGRID1.Query.FieldByName('PropTarif').Asstring)*StrToFloat(SQLGRID1.Query.FieldByName('PropCount').Asstring);
           if s<>'' then s:=s+', ';
             s:=s+'Выдача пропусков: '+StrTo00(FloatToStr(f))+' руб';
        end;
       ReportMakerWP.AddParam('26='+s );
 ///--------------------------------------------------------
        i:=0;
       qPlace:=sql.select('SendPack','Count,Send_Ident','Send_Ident='+
                     IntToStr(SQLGRID1.Query.FieldByName('Ident').AsInteger),'');

         while (not qPlace.eof) do
         begin
           i:=i+qPlace.FieldByName('Count').asinteger;
           qPlace.Next;
         end;
       qPlace.free ;
 ////---------------------------------------------------------
      ReportMakerWP.AddParam('27='+IntToStr(i) );
  if ReportMakerWP.DoMakeReport(systemdir+'send\sendGd.rtf',
                             systemdir+'send\send.ini', systemdir+'send\out1.rtf')<>0 then
                              begin
                              ReportMakerWP.Free;
                              //application.messagebox('Закройте выходной документ в WINWORD!',
                             // 'Совет!',0);
                             goto T;
                              exit
                              end;;
Nprint:=5;
end else
begin
  Application.MessageBox('Не указан тип перевозки!','Ошибка!',0);
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
if  (VarToStr(w2)='') or (VarToStr(w3)='')then
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
 WordApplication1.Free;
application.MessageBox('Проверьте все настройки для печати!','Ошибка!',0);
exit
end;

end;

procedure TFormSendBox.eFilterClick(Sender: TObject);
var cond, str,StrNill:string;
    Val:integer;
//    str1:TStringList;
begin
  try
    str:='';
    Val:=cbZak.getData ;
    //----------------------------------------
    if (Val<>0) then
      str:=str+'Client_Ident='+IntToStr(Val);
    //----------------------------------------
    Val:=cbPynkt.GetData;
    if  (Val<>0) and (str='') then
      str:=str+'City_Ident='+IntToStr(Val);
    //----------------------------------------
    if  (Val<>0) and (str<>'') then
      str:=str+' and '+'City_Ident='+IntToStr(Val);
    if  (str<>'') then
      StrNill:=' and '
    else
      StrNill:='';
    //----------------------------------------
    if  (LabelEditDate1.Text<>'  .  .    ') and (LabelEditDate2.Text<>'  .  .    ') then
      str:=str+StrNill+'(`Start`>='+
           sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.Text)))+
           ' and '+'`Start`<='+
           sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate2.Text)))+')'
    else
      if  (LabelEditDate1.Text<>'  .  .    ')and (LabelEditDate2.Text='  .  .    ')then
        str:=str+StrNill+'`Start`>='+
           sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.Text)))

    else if  (LabelEditDate2.Text<>'  .  .    ')and (LabelEditDate1.Text='  .  .    ')then
      str:=str+StrNill+'`Start`<='+
           sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate2.Text)));
    //cond := ''+ send_str + '.`Start` >=' + FormatDateTime('yyyy-mm-dd',IncMonth(Date,-6));
    cond := '`Start` >=' + FormatDateTime('yyyy-mm-dd',IncMonth(Date,-6));
    {str1:=TStringList.Create;
str1.Add('select distinct '+ send_str + '.`Ident` AS `Ident`,'+ send_str + '.`Check` AS `Check`,');
str1.Add(''+ send_str + '.`Start` AS `Start`,'+ send_str + '.`Inspector_Ident` AS `Inspector_Ident`,');
str1.Add('`inspector`.`PeopleFIO` AS `PeopleFIO`,'+ send_str + '.`ContractType_Ident` AS `ContractType_Ident`,');
str1.Add('`contracttype`.`Name` AS `ContracttypeName`,'+ send_str + '.`Client_Ident` AS `Client_Ident`,');
str1.Add('`clients`.`Name` AS `ClientName`,`clients`.`Acronym` AS `ClientAcr`,`clients`.`Telephone` AS `ClientPhone`,');
str1.Add('`clients`.`PersonType_Ident` AS `Persontype_ident`,'+ send_str + '.`Credit` AS `Credit`,'+ send_str + '.`Contract` AS `Contract`,');
str1.Add(''+ send_str + '.`Client_Ident_Sender` AS `Client_Ident_Sender`,`cl`.`Name` AS `ClientSenderName`,`cl`.`Acronym` AS `ClientSenderAcr`,');
str1.Add('`cl`.`Telephone` AS `ClientSenderPhone`,'+ send_str + '.`City_Ident` AS `City_Ident`,`city`.`Name` AS `CityName`,');
str1.Add(''+ send_str + '.`DateSend` AS `DateSend`,'+ send_str + '.`Acceptor_Ident` AS `Acceptor_Ident`,`acceptor`.`Name` AS `AcceptorName`,');
str1.Add('`acceptor`.`Address` AS `AcceptorAddress`,`acceptor`.`Regime` AS `AcceptorRegime`,`acceptor`.`Phone` AS `AcceptorPhone`,');
str1.Add(''+ send_str + '.`Forwarder_Ident` AS `Forwarder_Ident`,`forwarder`.`Name` AS `Forwarder`,'+ send_str + '.`Rollout_Ident` AS `RollOut_Ident`,');
str1.Add('`rollout`.`Name` AS `RollOutName`,'+ send_str + '.`Namegood_Ident` AS `Namegood_Ident`,`namegood`.`Name` AS `NamegoodName`,');
str1.Add(''+ send_str + '.`Typegood_Ident` AS `Typegood_Ident`,'+ send_str + '.`Weight` AS `Weight`,'+ send_str + '.`Volume` AS `Volume`,');
str1.Add(''+ send_str + '.`CountWeight` AS `CountWeight`,'+ send_str + '.`Tariff` AS `Tariff`,');
str1.Add('concat(cast(((cast('+ send_str + '.`CountWeight` as decimal(10,2)) * cast('+ send_str + '.`Tariff` as decimal(10,2))) / 10) as decimal(15,2)),' +sql.MakeStr('руб.')+') AS `MoneyGD`,');
str1.Add(''+ send_str + '.`Fare` AS `Fare`,'+ send_str + '.`PackTarif` AS `PackTarif`,'+ send_str + '.`AddServiceExp` AS `AddServiceExp`,');
str1.Add(''+ send_str + '.`AddServicePack` AS `AddServicePack`,'+ send_str + '.`AddServiceProp` AS `AddServiceProp`,');
str1.Add(''+ send_str + '.`AddServicePrace` AS `AddServicePrace`,'+ send_str + '.`InsuranceSum` AS `InsuranceSum`,');
str1.Add(''+ send_str + '.`InsurancePercent` AS `InsurancePercent`,'+ send_str + '.`InsuranceValue` AS `InsuranceValue`,');
str1.Add(''+ send_str + '.`InsurancePay` AS `InsurancePay`,'+ send_str + '.`SumCount` AS `SumCount`,'+ send_str + '.`Typegood_Ident1` AS `Typegood_Ident1`,');
str1.Add(''+ send_str + '.`Typegood_Ident2` AS `Typegood_Ident2`,'+ send_str + '.`Namber` AS `Namber`,'+ send_str + '.`PayType_Ident` AS `PayType_Ident`,');
str1.Add('`paytype`.`Name` AS `PayTypeName`,'+ send_str + '.`NmberOrder` AS `NmberOrder`,'+ send_str + '.`Invoice_Ident` AS `Invoice_Ident`,');
str1.Add(''+ invoice_str + '.`Number` AS `InvoiceNumber`,'+ invoice_str + '.`Data` AS `InvoiceDate`,'+ send_str + '.`NumberCountPattern` AS `NumberCountPattern`,');
str1.Add(''+ send_str + '.`PayText` AS `PayText`,'+ send_str + '.`StatusSupp_Ident` AS `StatusSupp_Ident`,`sendtype`.`Name` AS `SendTypeName`,');
str1.Add(''+ send_str + '.`DateSupp` AS `DateSupp`,'+ send_str + '.`Supplier_Ident` AS `Supplier_Ident`,`supplier`.`Name` AS `SupplierName`,');
str1.Add(''+ send_str + '.`SuppText` AS `SuppText`,cast('+ send_str + '.`PackCount` as char(60) charset utf8) AS `PackCount`,'+ send_str + '.`ExpCount` AS `ExpCount`,');
str1.Add(''+ send_str + '.`PropCount` AS `PropCount`,'+ send_str + '.`ExpTarif` AS `ExpTarif`,'+ send_str + '.`PropTarif` AS `PropTarif`,');
str1.Add(''+ send_str + '.`Train_Ident` AS `Train_Ident`,'+ send_str + '.`AddServStr` AS `AddServStr`,'+ send_str + '.`AddServSum` AS `AddServSum`,');
str1.Add(''+ send_str + '.`CutTarif` AS `CutTarif`,`train`.`Number` AS `Number`,'+ send_str + '.`SumWay` AS `SumWay`,');
str1.Add(''+ send_str + '.`NumberWay` AS `NumberWay`,'+ send_str + '.`SumServ` AS `SumServ`,'+ send_str + '.`NumberServ` AS `NumberServ`,');
str1.Add(''+ send_str + '.`WeightGd` AS `WeightGd`,'+ send_str + '.`PlaceGd` AS `PlaceGd`,'+ send_str + '.`NumberPP` AS `NumberPP`,');
str1.Add(''+ send_str + '.`PayTypeWay_Ident` AS `PayTypeWay_Ident`,`ptway`.`Name` AS `WayName`,'+ send_str + '.`PayTypeServ_Ident` AS `PayTypeServ_Ident`,');
str1.Add('`ptserv`.`Name` AS `ServName`,'+ send_str + '.`CountInvoice` AS `CountInvoice`,'+ send_str + '.`PlaceC` AS `PlaceC`,'+sql.MakeStr('+')+' AS `Sel`,');
str1.Add('`severtrans`.`TP_return`('+ send_str + '.`Typegood_Ident`) AS `TP`,`severtrans`.`TP1_return`('+ send_str + '.`Typegood_Ident1`) AS `TP1`,');
str1.Add('`severtrans`.`TP2_return`('+ send_str + '.`Typegood_Ident2`) AS `TP2`,concat(`severtrans`.`TP_return`('+ send_str + '.`Typegood_Ident`),' +sql.MakeStr('')+',');
str1.Add('`severtrans`.`TP1_return`('+ send_str + '.`Typegood_Ident1`),'+sql.MakeStr('')+ ',`severtrans`.`TP2_return`('+ send_str + '.`Typegood_Ident2`)) AS `Typegood`,');
str1.Add(''+ akttek_str + '.`IDENT` AS `Akttek_Ident`,'+ akttek_str + '.`Number` AS `AkttekNumber`,');
str1.Add(''+ akttek_str + '.`Data` AS `Akttekdata` ');
str1.Add('from (((((((((((((((('+ send_str + ' left join `inspector` on(('+ send_str + '.`Inspector_Ident` = `inspector`.`Ident`))) ');
str1.Add('left join `contracttype` on(('+ send_str + '.`ContractType_Ident` = `contracttype`.`Ident`))) ');
str1.Add('left join `clients` on((`clients`.`Ident` = '+ send_str + '.`Client_Ident`))) ');
str1.Add('left join `train` on((`train`.`Ident` = '+ send_str + '.`Train_Ident`))) ');
str1.Add('left join `city` on(('+ send_str + '.`City_Ident` = `city`.`Ident`))) ');
str1.Add('left join `acceptor` on((`acceptor`.`Ident` = '+ send_str + '.`Acceptor_Ident`))) ');
str1.Add('left join `rollout` on(('+ send_str + '.`Rollout_Ident` = `rollout`.`Ident`))) ');
str1.Add('left join `namegood` on(('+ send_str + '.`Namegood_Ident` = `namegood`.`Ident`))) ');
str1.Add('left join `forwarder` on((`forwarder`.`Ident` = '+ send_str + '.`Forwarder_Ident`))) ');
str1.Add('left join `paytype` on((`paytype`.`Ident` = '+ send_str + '.`PayType_Ident`))) ');
str1.Add('left join `supplier` on(('+ send_str + '.`Supplier_Ident` = `supplier`.`Ident`))) ');
str1.Add('left join `sendtype` on(('+ send_str + '.`StatusSupp_Ident` = `sendtype`.`Ident`))) ');
str1.Add('left join '+ invoice_str + ' on(('+ invoice_str + '.`Ident` = '+ send_str + '.`Invoice_Ident`))) ');
str1.Add('left join `paytype` `ptway` on((`ptway`.`Ident` = '+ send_str + '.`PayTypeWay_Ident`))) ');
str1.Add('left join `paytype` `ptserv` on((`ptserv`.`Ident` = '+ send_str + '.`PayTypeServ_Ident`))) ');
str1.Add('left join (('+ send_str + ' `s` left join `clients` `cl` on((`cl`.`Ident` = `s`.`Client_Ident_Sender`))) ');
str1.Add('left join '+ akttek_str + ' on(('+ akttek_str + '.`IDENT` = `s`.`Akttek_Ident`))) on(('+ send_str + '.`Ident` = `s`.`Ident`))) ');
str1.Add(' where ' + cond + ' and (' + str + ')');
sqlGrid1.ExecSQL(str1);
str1.free; }
    if trim(str) <> '' then
    begin
      //SqlGrid1.ExecTableCond('Sends','('+str+')'+ ' and '+ cond);
      SqlGrid1.ExecTableCond(sends_view,'('+str+')'+ ' and '+ cond);
    end
  except
    application.MessageBox('Проверьте правильность составления фильтра!','Ошибка!',0);
    exit
  end;

  FilterDiscard.Enabled := true;

end;

procedure TFormSendBox.FilterDiscardClick(Sender: TObject);
var cond: string;
//str1:TStringList;
begin
    cond := '`Start` >=' + FormatDateTime('yyyy-mm-dd',IncMonth(Date,-6));
 //   cond := ''+ send_str + '.`Start` >=' + FormatDateTime('yyyy-mm-dd',IncMonth(Date,-6));
{str1:=TStringList.Create;
str1.Add('select distinct '+ send_str + '.`Ident` AS `Ident`,'+ send_str + '.`Check` AS `Check`,');
str1.Add(''+ send_str + '.`Start` AS `Start`,'+ send_str + '.`Inspector_Ident` AS `Inspector_Ident`,');
str1.Add('`inspector`.`PeopleFIO` AS `PeopleFIO`,'+ send_str + '.`ContractType_Ident` AS `ContractType_Ident`,');
str1.Add('`contracttype`.`Name` AS `ContracttypeName`,'+ send_str + '.`Client_Ident` AS `Client_Ident`,');
str1.Add('`clients`.`Name` AS `ClientName`,`clients`.`Acronym` AS `ClientAcr`,`clients`.`Telephone` AS `ClientPhone`,');
str1.Add('`clients`.`PersonType_Ident` AS `Persontype_ident`,'+ send_str + '.`Credit` AS `Credit`,'+ send_str + '.`Contract` AS `Contract`,');
str1.Add(''+ send_str + '.`Client_Ident_Sender` AS `Client_Ident_Sender`,`cl`.`Name` AS `ClientSenderName`,`cl`.`Acronym` AS `ClientSenderAcr`,');
str1.Add('`cl`.`Telephone` AS `ClientSenderPhone`,'+ send_str + '.`City_Ident` AS `City_Ident`,`city`.`Name` AS `CityName`,');
str1.Add(''+ send_str + '.`DateSend` AS `DateSend`,'+ send_str + '.`Acceptor_Ident` AS `Acceptor_Ident`,`acceptor`.`Name` AS `AcceptorName`,');
str1.Add('`acceptor`.`Address` AS `AcceptorAddress`,`acceptor`.`Regime` AS `AcceptorRegime`,`acceptor`.`Phone` AS `AcceptorPhone`,');
str1.Add(''+ send_str + '.`Forwarder_Ident` AS `Forwarder_Ident`,`forwarder`.`Name` AS `Forwarder`,'+ send_str + '.`Rollout_Ident` AS `RollOut_Ident`,');
str1.Add('`rollout`.`Name` AS `RollOutName`,'+ send_str + '.`Namegood_Ident` AS `Namegood_Ident`,`namegood`.`Name` AS `NamegoodName`,');
str1.Add(''+ send_str + '.`Typegood_Ident` AS `Typegood_Ident`,'+ send_str + '.`Weight` AS `Weight`,'+ send_str + '.`Volume` AS `Volume`,');
str1.Add(''+ send_str + '.`CountWeight` AS `CountWeight`,'+ send_str + '.`Tariff` AS `Tariff`,');
str1.Add('concat(cast(((cast('+ send_str + '.`CountWeight` as decimal(10,2)) * cast('+ send_str + '.`Tariff` as decimal(10,2))) / 10) as decimal(15,2)),'+sql.MakeStr('руб.')+') AS `MoneyGD`,');
str1.Add(''+ send_str + '.`Fare` AS `Fare`,'+ send_str + '.`PackTarif` AS `PackTarif`,'+ send_str + '.`AddServiceExp` AS `AddServiceExp`,');
str1.Add(''+ send_str + '.`AddServicePack` AS `AddServicePack`,'+ send_str + '.`AddServiceProp` AS `AddServiceProp`,');
str1.Add(''+ send_str + '.`AddServicePrace` AS `AddServicePrace`,'+ send_str + '.`InsuranceSum` AS `InsuranceSum`,');
str1.Add(''+ send_str + '.`InsurancePercent` AS `InsurancePercent`,'+ send_str + '.`InsuranceValue` AS `InsuranceValue`,');
str1.Add(''+ send_str + '.`InsurancePay` AS `InsurancePay`,'+ send_str + '.`SumCount` AS `SumCount`,'+ send_str + '.`Typegood_Ident1` AS `Typegood_Ident1`,');
str1.Add(''+ send_str + '.`Typegood_Ident2` AS `Typegood_Ident2`,'+ send_str + '.`Namber` AS `Namber`,'+ send_str + '.`PayType_Ident` AS `PayType_Ident`,');
str1.Add('`paytype`.`Name` AS `PayTypeName`,'+ send_str + '.`NmberOrder` AS `NmberOrder`,'+ send_str + '.`Invoice_Ident` AS `Invoice_Ident`,');
str1.Add(''+ invoice_str + '.`Number` AS `InvoiceNumber`,'+ invoice_str + '.`Data` AS `InvoiceDate`,'+ send_str + '.`NumberCountPattern` AS `NumberCountPattern`,');
str1.Add(''+ send_str + '.`PayText` AS `PayText`,'+ send_str + '.`StatusSupp_Ident` AS `StatusSupp_Ident`,`sendtype`.`Name` AS `SendTypeName`,');
str1.Add(''+ send_str + '.`DateSupp` AS `DateSupp`,'+ send_str + '.`Supplier_Ident` AS `Supplier_Ident`,`supplier`.`Name` AS `SupplierName`,');
str1.Add(''+ send_str + '.`SuppText` AS `SuppText`,cast('+ send_str + '.`PackCount` as char(60) charset utf8) AS `PackCount`,'+ send_str + '.`ExpCount` AS `ExpCount`,');
str1.Add(''+ send_str + '.`PropCount` AS `PropCount`,'+ send_str + '.`ExpTarif` AS `ExpTarif`,'+ send_str + '.`PropTarif` AS `PropTarif`,');
str1.Add(''+ send_str + '.`Train_Ident` AS `Train_Ident`,'+ send_str + '.`AddServStr` AS `AddServStr`,'+ send_str + '.`AddServSum` AS `AddServSum`,');
str1.Add(''+ send_str + '.`CutTarif` AS `CutTarif`,`train`.`Number` AS `Number`,'+ send_str + '.`SumWay` AS `SumWay`,');
str1.Add(''+ send_str + '.`NumberWay` AS `NumberWay`,'+ send_str + '.`SumServ` AS `SumServ`,'+ send_str + '.`NumberServ` AS `NumberServ`,');
str1.Add(''+ send_str + '.`WeightGd` AS `WeightGd`,'+ send_str + '.`PlaceGd` AS `PlaceGd`,'+ send_str + '.`NumberPP` AS `NumberPP`,');
str1.Add(''+ send_str + '.`PayTypeWay_Ident` AS `PayTypeWay_Ident`,`ptway`.`Name` AS `WayName`,'+ send_str + '.`PayTypeServ_Ident` AS `PayTypeServ_Ident`,');
str1.Add('`ptserv`.`Name` AS `ServName`,'+ send_str + '.`CountInvoice` AS `CountInvoice`,'+ send_str + '.`PlaceC` AS `PlaceC`,'+sql.MakeStr('+')+' AS `Sel`,');
str1.Add('`severtrans`.`TP_return`('+ send_str + '.`Typegood_Ident`) AS `TP`,`severtrans`.`TP1_return`('+ send_str + '.`Typegood_Ident1`) AS `TP1`,');
str1.Add('`severtrans`.`TP2_return`('+ send_str + '.`Typegood_Ident2`) AS `TP2`,concat(`severtrans`.`TP_return`('+ send_str + '.`Typegood_Ident`),'+sql.MakeStr('')+ ',');
str1.Add('`severtrans`.`TP1_return`('+ send_str + '.`Typegood_Ident1`),'+sql.MakeStr('')+ ',`severtrans`.`TP2_return`('+ send_str + '.`Typegood_Ident2`)) AS `Typegood`,');
str1.Add(''+ akttek_str + '.`IDENT` AS `Akttek_Ident`,'+ akttek_str + '.`Number` AS `AkttekNumber`,');
str1.Add(''+ akttek_str + '.`Data` AS `Akttekdata` ');
str1.Add('from (((((((((((((((('+ send_str + ' left join `inspector` on(('+ send_str + '.`Inspector_Ident` = `inspector`.`Ident`))) ');
str1.Add('left join `contracttype` on(('+ send_str + '.`ContractType_Ident` = `contracttype`.`Ident`))) ');
str1.Add('left join `clients` on((`clients`.`Ident` = '+ send_str + '.`Client_Ident`))) ');
str1.Add('left join `train` on((`train`.`Ident` = '+ send_str + '.`Train_Ident`))) ');
str1.Add('left join `city` on(('+ send_str + '.`City_Ident` = `city`.`Ident`))) ');
str1.Add('left join `acceptor` on((`acceptor`.`Ident` = '+ send_str + '.`Acceptor_Ident`))) ');
str1.Add('left join `rollout` on(('+ send_str + '.`Rollout_Ident` = `rollout`.`Ident`))) ');
str1.Add('left join `namegood` on(('+ send_str + '.`Namegood_Ident` = `namegood`.`Ident`))) ');
str1.Add('left join `forwarder` on((`forwarder`.`Ident` = '+ send_str + '.`Forwarder_Ident`))) ');
str1.Add('left join `paytype` on((`paytype`.`Ident` = '+ send_str + '.`PayType_Ident`))) ');
str1.Add('left join `supplier` on(('+ send_str + '.`Supplier_Ident` = `supplier`.`Ident`))) ');
str1.Add('left join `sendtype` on(('+ send_str + '.`StatusSupp_Ident` = `sendtype`.`Ident`))) ');
str1.Add('left join '+ invoice_str + ' on(('+ invoice_str + '.`Ident` = '+ send_str + '.`Invoice_Ident`))) ');
str1.Add('left join `paytype` `ptway` on((`ptway`.`Ident` = '+ send_str + '.`PayTypeWay_Ident`))) ');
str1.Add('left join `paytype` `ptserv` on((`ptserv`.`Ident` = '+ send_str + '.`PayTypeServ_Ident`))) ');
str1.Add('left join (('+ send_str + ' `s` left join `clients` `cl` on((`cl`.`Ident` = `s`.`Client_Ident_Sender`))) ');
str1.Add('left join '+ akttek_str + ' on(('+ akttek_str + '.`IDENT` = `s`.`Akttek_Ident`))) on(('+ send_str + '.`Ident` = `s`.`Ident`))) ');
str1.Add(' where '+ cond);
sqlGrid1.ExecSQL(str1);
str1.free;}
//   SqlGrid1.ExecTableCond('Sends',cond);
   SqlGrid1.ExecTableCond(sends_view,cond);
  // FIX IT
  // FilterDiscard.Enabled := false;

end;

procedure TFormSendBox.FormKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
begin
if key = VK_Return then
  eCardClick(Sender)
end;

procedure TFormSendBox.cbUpdateFilterButtons(Sender: TObject);
var
  customer_str:string;
  customer_int:integer;
  //dest_str:string;
  dest_int:integer;
begin
  customer_str:='';
  customer_int:=cbZak.getData ;
  if (customer_int<>0) then
        customer_str:=customer_str+'Client_Ident='+IntToStr(customer_int);
  dest_int:=cbPynkt.GetData;
  if  (LabelEditDate1.Text<>'  .  .    ') or (LabelEditDate2.Text<>'  .  .    ')
        or (customer_int<>0) or (dest_int<>0) then
      eFilter.Enabled := true
  else
      eFilter.Enabled := false;
  // FilterDiscard.Enabled :=false;
end;

end.
