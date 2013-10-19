unit Menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Tadjform, Menus,DBTables, Sqlctrls, TSQLCLS, ComObj, DB;

type
  TFMenu = class(tform)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N5: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N20: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N19: TMenuItem;
    DBL1: TMenuItem;
//    N21: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
//    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N40: TMenuItem;
    N110: TMenuItem;
    N210: TMenuItem;
    N41: TMenuItem;
    N42: TMenuItem;
    N20071: TMenuItem;
    N43: TMenuItem;
    procedure N7Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
//    procedure N21Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure DBL1Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
//    procedure N26Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure Roles;
    procedure N29Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure N33Click(Sender: TObject);
    procedure N34Click(Sender: TObject);
    procedure N35Click(Sender: TObject);
    procedure N37Click(Sender: TObject);
    procedure N38Click(Sender: TObject);
    procedure N40Click(Sender: TObject);
    procedure N39Click(Sender: TObject);
    procedure N110Click(Sender: TObject);
    procedure N210Click(Sender: TObject);
    procedure N41Click(Sender: TObject);
    procedure N42Click(Sender: TObject);
    procedure N20071Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N43Click(Sender: TObject);
   
  private
    { Private declarations }
  public
   CurrentUser:Integer;
   CurrentUserName:string;
   CurrentUserRoles:integer;
    BYH,OPER,BOS:boolean;
    { Public declarations }
  end;

var
  FMenu: TFMenu;


implementation

uses EntrySec, ClientCard, ClientCardBox, Contracts,
   CardBoss, FormSendBoxu, FNation, FConstant, FInsp, FTrain, FOrder,
  fAccountB, FTrainTariff, FInvoiceBox, FPrint, Fpaysheet, FActiveSend,
  FormSelectu,Invoice, FFerrymanBox, FWayBill, FAktBox, fAccountTekB,SendStr,
  FWayBill2, FPrintBox,DLoad, FormUnload, DataChangeLoad, FSaldo;

{$R *.dfm}

procedure TFMenu.Roles;
begin
    N1.Visible:=Oper;
    N2.Visible:=Oper;
    N3.Visible:=Bos;
    N4.Visible:=Oper;
    N6.Visible:=Oper;
    N7.Visible:=Oper;
    N5.Visible:=Oper;
    N8.Visible:=Byh;
    N9.Visible:=Oper;
    N10.Visible:=Oper;
    N11.Visible:=Oper;
    N12.Visible:=Oper;
    N13.Visible:=Oper;
    N14.Visible:=Oper;
    N15.Visible:=Oper;
    N16.Visible:=Oper;
    N17.Visible:=Oper;
    N18.Visible:=Oper;
    N20.Visible:=Oper;
    N22.Visible:=Oper;
    N23.Visible:=Oper;
    N19.Visible:=Byh;
//    N21.Visible:=Oper;
    N24.Visible:=Oper;
    N25.Visible:=Oper;
//    N26.Visible:=Byh;
    N27.Visible:=Oper;
    N28.Visible:=Oper;
    N29.Visible:=Oper;
    N31.Visible:=Oper;
    N32.Visible:=Byh;
    N35.Visible:=Oper;
    N41.Visible:=false;
    N42.Visible:=false;
end;

procedure TFMenu.N7Click(Sender: TObject);
begin
case Application.MessageBox('Вы действительно хотите выдти из приложения?',
                            'Предупреждение!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: close;
    IDNO:exit;
end;

end;

procedure TFMenu.N2Click(Sender: TObject);
begin    {перерегестрация}
 EntrySecurity:=TEntrySecurity.Create(Application);
  if EntrySecurity.ShowModal = mrCancel then
    begin
     EntrySecurity.Free;
     if FMenu.CurrentUser<>0
       then exit
       else close
    end
  else
   EntrySecurity.Free;
 if CurrentUserRoles=1 then
 begin
  BYH:=true;
  OPER:=true;
  BOS:=true;
  //N1.Visible:=true;      {Администрирование       }
  //N2.Visible:=true;      {Перерегистрация         }
  //N3.Visible:=true;      {Список инспекторов      }
 // N4.Visible:=true;      {Картотека               }
 // N5.Visible:=true;      {Справочники             }
 // N6.Visible:=true;      {Настройки               }
 // N7.Visible:=true;      {Выход                   }
 // N8.Visible:=true;      {Константы               }
 // N9.Visible:=true;      {Справка о предприятии   }
 // N10.Visible:=true;     {Банки                   }
 // N11.Visible:=true;     {Договора                }
 // N12.Visible:=true;     {Города                  }
 // N13.Visible:=true;     {Страны                  }
 end;
  if CurrentUserroles=2 then
 begin
  BYH:=true;
  OPER:=true;
  BOS:=false;
 // N1.Visible:=true;      {Администрирование       }
 // N2.Visible:=true;      {Перерегистрация         }
 // N3.Visible:=false;     {Список инспекторов      }
 // N4.Visible:=true;      {Картотека               }
 // N5.Visible:=true;    {Карточки клиентов       }
  N6.Visible:=false;     {Настройки               }
 end;
 if CurrentUserroles=3 then
 begin
  BYH:=false;
  OPER:=true;
  BOS:=false;
 end;
 Roles;
end;

procedure TFMenu.N5Click(Sender: TObject);
begin
{CardBox:=TCardBox.Create(Application) ;
CardBox.showModal;
CardBox.Free;      }
end;

procedure TFMenu.N4Click(Sender: TObject);  {Картотека клиентов}
begin
{Картотека клиентов}
CardBox:=TCardBox.Create(Application) ;
CardBox.showModal;
CardBox.Free;
end;

procedure TFMenu.N10Click(Sender: TObject); {Настройки,справочники,банки}
begin
{Банки (справочник)}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('Banks',3,'');
  FormNat.Free;
end;

procedure TFMenu.N11Click(Sender: TObject);
begin   {Настройки,справочники,банки}
  FormContracts:=TFormContracts.Create(Application) ;
  FormContracts.ShowModal;
  FormContracts.Free;
end;

procedure TFMenu.FormCreate(Sender: TObject);
var
 Word: variant;
begin
// krutogolov
//if EntrySecurity.bAllData then
begin
  Caption := 'РегионТранс (База данных за все время)';
end;

// FMenu.CurrentUser:=sql.SelectInteger('')
//Запуск MS Word
try
  Word := GetActiveOleObject('Word.Application');
except
  try
    Word := CreateOleObject('Word.Application');
    if Word.Visible = False then
    begin
      Word.Visible := True;
    end;
  except
    ShowMessage('Не могу запустить MS Word. Запустите MS Word вручную.');
  end;
end;
FMenu.Font.Size:=20;

 //if FMenu.CurrentUser<>0
     //  then exit
 // else
 if CurrentUserRoles=1 then
 begin
    BYH:=true;
    OPER:=true;
    BOS:=true;
  //N1.Visible:=true;     {Администрирование       }
  //N2.Visible:=true;     {Перерегистрация         }
  //N3.Visible:=true;     {Список инспекторов      }
  //N4.Visible:=true;     {Картотека               }
  //N5.Visible:=true;     {Справочники             }
 // N6.Visible:=true;     {Настройки               }
 // N7.Visible:=true;     {Выход                   }
  //N8.Visible:=true;     {Константы               }
  //N9.Visible:=true;     {Справка о предприятии   }
 // N10.Visible:=true;    {Банки                   }
 // N11.Visible:=true;    {Договора                }
 // N12.Visible:=true;    {Города                  }
  //N13.Visible:=true;    {Страны                  }
 end;
  if CurrentUserroles=2 then
 begin
 BYH:=true;
 Oper:=true;
 Bos:=false;
  //N1.Visible:=true;       {Администрирование       }
  //N2.Visible:=true;       {Перерегистрация         }
  //N3.Visible:=false;      {Список инспекторов      }
  //N4.Visible:=true;       {Картотека               }
  //N5.Visible:=true;     {Карточки клиентов       }
  //N6.Visible:=false;      {Настройки               }
 end;
 if CurrentUserroles=3 then
 begin
  OPER:=true;
  Oper:=false;
  Bos:=false;
 end;
 Roles;
end;

procedure TFMenu.N12Click(Sender: TObject);
begin
{Города (справочник)}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('CityView',3,'');
  FormNat.Free;
end;

procedure TFMenu.N13Click(Sender: TObject);
begin
 {Страны (справочник)}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('Country',1,'');
  FormNat.Free;
end;

procedure TFMenu.N9Click(Sender: TObject);
begin   {Карточка предприятия}
  Application.CreateForm(TFCardBoss,FCardBoss) ;
  FCardBoss.EditRecord; 
  FCardBoss.Free;
end;

procedure TFMenu.N15Click(Sender: TObject);
begin
   {Картотека отправок}
  FormSendBox:=TFormSendBox.Create(Application) ;
  FormSendBox.ShowModal;
  FormSendBox.Free;
end;

procedure TFMenu.N16Click(Sender: TObject);
begin
{Картотека получателей}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('Acceptors',3,'');
  FormNat.Free;
end;

procedure TFMenu.N19Click(Sender: TObject);
begin  {Экспедитор}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('PackTariff',2,'');
  FormNat.Free;
end;

procedure TFMenu.N20Click(Sender: TObject);
begin   {Наименование груза}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('NameGood',1,'');
  FormNat.Free;
end;

//procedure TFMenu.N21Click(Sender: TObject);
//begin   {Технология поездов}
//  FormTrain:=TFormTrain.Create(Application) ;
//  FormTrain.EditRecord;
//  FormTrain.Free;
//end;

procedure TFMenu.N22Click(Sender: TObject);
begin   {Кем доставлен }
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('Supplier',1,'');
  FormNat.Free;
end;

procedure TFMenu.N23Click(Sender: TObject);
begin   {основания}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('OnReason',1,'');
  FormNat.Free;
end;

procedure TFMenu.N8Click(Sender: TObject);
begin    {Константы}
   FormConstant:=TFormConstant.Create(Application);
   FormConstant.AddRecord;
   FormConstant.free;
end;

procedure TFMenu.N3Click(Sender: TObject);
begin         {пользаватели}
  FormInsp:=TFormInsp.Create(Application);
  FormInsp.ShowModal;
  FormInsp.free;
end;

procedure TFMenu.DBL1Click(Sender: TObject);
begin      {Тип упаковки}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('PackType',1,'');
  FormNat.Free;
end;

procedure TFMenu.N24Click(Sender: TObject);
begin   { Приходники}
  FormOrder:=TFormOrder.Create(Application) ;
  FormOrder.ShowModal;
  FormOrder.Free;
end;

procedure TFMenu.N25Click(Sender: TObject);
begin      {счета}
  FormAccountBox:=TFormAccountBox.Create(Application) ;
  FormAccountBox.ShowModal;
  FormAccountBox.Free;
end;

//procedure TFMenu.N26Click(Sender: TObject);
//begin      {тарифы на жд перевозки}
//  FormTrainTariff :=TFormTrainTariff .Create(Application) ;
//  FormTrainTariff .Editrecord;
//  FormTrainTariff .Free;
//end;

procedure TFMenu.N27Click(Sender: TObject);
begin   {счет фактуры}
  FormInvoiceBox :=TFormInvoiceBox .Create(Application) ;
  FormInvoiceBox .ShowModal;
  FormInvoiceBox .Free;
end;

procedure TFMenu.N28Click(Sender: TObject);
begin    {настройка принтеров для печати}
//  InvoiceCompare;
  FormPrinterBox :=TFormPrinterBox .Create(Application) ;
  FormPrinterBox .ShowModal;
  FormPrinterBox .Free;
end;

procedure TFMenu.N29Click(Sender: TObject);
begin          {Платежки}
  FormPaysheetBox :=TFormPaysheetBox .Create(Application) ;
  FormPaysheetBox .ShowModal;
  FormPaysheetBox .Free;
end;

procedure TFMenu.N31Click(Sender: TObject);
begin
  FormActiveSend :=TFormActiveSend .Create(Application) ;
  FormActiveSend .ShowModal;
  FormActiveSend .Free;
end;

procedure TFMenu.N32Click(Sender: TObject);
begin
  FormSelect :=TFormSelect.Create(Application) ;
  FormSelect.ShowModal;
  FormSelect.Free;
end;

procedure TFMenu.N33Click(Sender: TObject);
begin
 {  FormNat:=TFormNat.Create(Application) ;
   FormNat.ShowList('Contacts',3,'');
   FormNat.Free;  }
end;

procedure TFMenu.N34Click(Sender: TObject);
begin
InvoiceCompare;
//DLoad.Test;
{StrTo00('6.1996') ; }
end;

procedure TFMenu.N35Click(Sender: TObject);
begin
  FormFerryManBox:=TFormFerryManBox.Create(Application) ;
  FormFerryManBox.ShowModal;
  FormFerryManBox.Free;

end;

procedure TFMenu.N40Click(Sender: TObject);
begin   {Отдельная}
  FormWayBill:=TFormWayBill.Create(Application) ;
  FormWayBill.ShowModal;
  FormWayBill.Free;
end;

procedure TFMenu.N37Click(Sender: TObject);
begin  {Акты-ТЭК}
  FormAKTBox :=TFormAKTBox .Create(Application) ;
  FormAKTBox .ShowModal;
  FormAKTBox .Free;

end;

procedure TFMenu.N38Click(Sender: TObject);
begin     {Счета-ТЭК}
  FormAccountTekBox :=TFormAccountTekBox .Create(Application) ;
  FormAccountTekBox .ShowModal;
  FormAccountTekBox .Free;

end;


procedure TFMenu.N39Click(Sender: TObject);
begin
  FormWayBill2:=TFormWayBill2.Create(Application) ;
  FormWayBill2.ShowModal;
  FormWayBill2.Free;
end;

procedure TFMenu.N110Click(Sender: TObject);
begin
{Склад1-Города (справочник)}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('CitySklad1View',0,'');
  FormNat.Free;
end;

procedure TFMenu.N210Click(Sender: TObject);
begin
{Склад2-Города (справочник)}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('CitySklad2View',0,'');
  FormNat.Free;
end;

procedure TFMenu.N41Click(Sender: TObject);
begin
  FUnload:=TFUnload.Create(Application) ;
  if FUnload.Unload =1 then
        Application.MessageBox('Данные выгружены!','Сообщение!',0)
else
Application.MessageBox('Данные выгружены с ошибкой!','Ошибка!',0);

  FUnload.Free;
end;

procedure TFMenu.N42Click(Sender: TObject);
begin
case Application.MessageBox('Загрузить данные?',
                            'Предостережение',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
       if DataChangeLoad.ChangeFile(0) = 0 then
            Application.MessageBox('Данные загружены!','Сообщение!',0)
       else
            Application.MessageBox('Данные не загружены,ошибка!','Ошибка!',0);
    end;
    IDNO:exit;
end;

end;

procedure TFMenu.N20071Click(Sender: TObject);
begin
{Сальдо на 2007 год (справочник)}
  FormSaldo:=TFormSaldo.Create(Application) ;
  FormSaldo.ShowModal;;
  FormSaldo.Free;
end;

procedure TFMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin

        Application.MessageBox('Приложение будет закрыто','Предупреждение!');
end;

procedure TFMenu.N43Click(Sender: TObject);      {обновление сервера}
var
  str1:TStringList;
begin
  str1:=TStringList.Create;
  str1.Add(' ALTER TABLE send CHANGE COLUMN InsuranceSum ');
  str1.Add(' InsuranceSum VARCHAR(12) NULL DEFAULT NULL, ');
  str1.Add(' CHANGE COLUMN InsuranceValue InsuranceValue ');
  str1.Add(' VARCHAR(12) NULL DEFAULT NULL ');
  if sql.ExecSQL(str1) = 0 then
     Application.MessageBox('Обновление сервера завершено!','',0);
  str1.free;

end;

end.



