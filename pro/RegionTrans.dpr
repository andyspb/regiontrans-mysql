program RegionTrans;

uses
  Forms,
  tsqlcls,
  sqlgrid,
  tmsql,
  SysUtils,
  Menu in 'Menu.pas' {FMenu},
  Tadjform in '..\library\TADJFORM.pas',
  TEnvirnt in '..\library\TEnvirnt.pas',
  EntrySec in 'EntrySec.pas' {EntrySecurity},
  SEQUENCE in 'Sequence.pas',
  ClientCardBox in 'ClientCardBox.pas' {CardBox},
  ClientCardu in 'ClientCardu.pas' {card},
  CardBank in 'Inform\CardBank.pas' {FormCardBank},
  Contracts in 'Inform\Contracts.pas' {FormContracts},
  ContractCard in 'Inform\ContractCard.pas' {FormCardContract},
  FCity in 'Inform\FCity.pas' {CityForm},
  Cardcountry in 'Inform\Cardcountry.pas' {FormCountry},
  CardBoss in 'CardBoss.pas' {FCardBoss},
  FormSendu in 'Send\FormSendu.pas' {FormSend},
  FormSendBoxu in 'Send\FormSendBoxu.pas' {FormSendBox},
  FormAcceptoru in 'Inform\FormAcceptoru.pas' {FormAcceptor},
  FAddEdit in 'Inform\FAddEdit.pas' {FormAE},
  FNation in 'Inform\FNation.pas' {FormNat},
  FConstant in 'Inform\FConstant.pas' {FormConstant},
  FInsp in 'Security\FInsp.pas' {FormInsp},
  FAEInsp in 'Security\FAEInsp.pas' {FormAEInsp},
  SendStr in 'Send\SendStr.pas',
  FTrain in 'Send\FTrain.pas' {FormTrain},
  FOrder in 'order\FOrder.pas' {FormOrder},
  OrderBox in 'order\OrderBox.pas' {FormOrderBox},
  fAccountB in 'Account\fAccountB.pas' {FormAccountBox},
  FAccount in 'Account\FAccount.pas' {FormAccount},
  FTrainTariff in 'Inform\FTrainTariff.pas' {FormTrainTariff},
  Invoice in 'Invoice\Invoice.pas',
  FInvoiceBox in 'Invoice\FInvoiceBox.pas' {FormInvoiceBox},
  FInvoice in 'Invoice\FInvoice.pas' {FormInvoice},
  FPrint in 'Inform\FPrint.pas' {FormPrinter},
  Fpaysheet in 'Paysheet\Fpaysheet.pas' {FormPaysheetBox},
  Fpaysheetu in 'Paysheet\Fpaysheetu.pas' {FormPaySheet},
  FActiveSend in 'Select\FActiveSend.pas' {FormActiveSend},
  FormSelectu in 'Select\FormSelectu.pas' {FormSelect},
  FormContactu in 'Inform\FormContactu.pas' {FormContact},
  FormCalc in 'Send\FormCalc.pas' {FormVCalc},
  FFerryman in 'Inform\FFerryman.pas' {FormFerryman},
  FFerrymanBox in 'Inform\FFerrymanBox.pas' {FormFerryManBox},
  FWayBill in 'Inform\FWayBill.pas' {FormWayBill},
  FAktBox in 'Invoice\FAktBox.pas' {FormAktBox},
  FAKT in 'Invoice\FAKT.pas' {FormAkt},
  FAccountTek in 'Account\FAccountTek.pas' {FormAccountTEK},
  fAccountTekB in 'Account\fAccountTekB.pas' {FormAccountTekBox},
  FWayBill2 in 'Inform\FWayBill2.pas' {FormWayBill2},
  FPrintBox in 'Inform\FPrintBox.pas' {FormPrinterBox},
  DLoad in 'DataLoad\DLoad.pas',
  FormUnload in 'DataLoad\FormUnload.pas' {FUnload},
  DataChangeLoad in 'DataLoad\DataChangeLoad.pas',
  FSaldo in 'Inform\FSaldo.pas' {FormSaldo};

{$R *.res}

begin
  ShortDateFormat:='dd.mm.yyyy';
  DateSeparator := '.';
  DecimalSeparator := '.';
  systemdir := getcurrentdir+'\';
  FormsIniDir  := systemdir;
  //if (ParamStr(1) = 'Severtrans') then sql:=TSQL.Create(ParamStr(1),'dba','sql')
   //else
   sql:=TSQL.Create('svtest','dba','sql');
  CreateEnviroment;
  Application.Initialize;
  Application.Title := 'РегионТранс';
  Application.CreateForm(TFMenu, FMenu);
  Application.Run;
  FreeEnviroment;
  sql.Free
end.
