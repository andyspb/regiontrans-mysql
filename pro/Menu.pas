unit Menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Tadjform, Menus, DBTables, Sqlctrls, TSQLCLS, ComObj, DB, Logger;

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
    N44: TMenuItem;
    updateClientsKredit1: TMenuItem;
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
    procedure N44Click(Sender: TObject);
    procedure updateClientsKredit1Click(Sender: TObject);

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
  FWayBill2, FPrintBox,DLoad, FormUnload, DataChangeLoad, FSaldo, FormSendu;

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
  updateClientsKredit1.Visible:=Bos;
end;

procedure TFMenu.N7Click(Sender: TObject);
begin
  case Application.MessageBox('�� ������������� ������ ����� �� ����������?',
                            '��������������!',MB_YESNO+MB_ICONQUESTION) of
    IDYES: close;
    IDNO:exit;
end;

end;

procedure TFMenu.N2Click(Sender: TObject);
begin    {���������������}
  EntrySecurity:=TEntrySecurity.Create(Application);
  //------------
  if (EntrySecurity.ShowModal = mrCancel) then
  begin
    EntrySecurity.Free;
    if (FMenu.CurrentUser <> 0) then
      exit
    else
      close
  end
  else
    EntrySecurity.Free;
    // krutogolov
  //------------
  N15.Caption := '�������� ( ' + EntrySec.period +' )';
  N27.Caption := '����-������� ( ' + EntrySec.period +' )';
  N25.Caption := '����� ( ' + EntrySec.period +' )';
  N24.Caption := '��������� ������ ( ' + EntrySec.period +' )';
  N29.Caption := '������ ( ' + EntrySec.period +' )';
  N37.Caption := '����-��� ( ' + EntrySec.period +' )';
  N38.Caption := '�����-��� ( ' + EntrySec.period +' )';
  Caption := '����������� ' + EntrySec.version + ' ( ������ �� ������: ' + EntrySec.period + ' )';
  //------------
  N44.Enabled := iff(EntrySec.bAllData, False, True);
  N44.Caption := iff(EntrySec.bAllData, '', '  + ������� ��������');

  if (CurrentUserRoles=1) then
  begin
    BYH:=true;
    OPER:=true;
    BOS:=true;
    //N1.Visible:=true;      {�����������������       }
    //N2.Visible:=true;      {���������������         }
    //N3.Visible:=true;      {������ �����������      }
    // N4.Visible:=true;      {���������               }
    // N5.Visible:=true;      {�����������             }
    // N6.Visible:=true;      {���������               }
    // N7.Visible:=true;      {�����                   }
    // N8.Visible:=true;      {���������               }
    // N9.Visible:=true;      {������� � �����������   }
    // N10.Visible:=true;     {�����                   }
    // N11.Visible:=true;     {��������                }
    // N12.Visible:=true;     {������                  }
    // N13.Visible:=true;     {������                  }
  end;

  if CurrentUserroles=2 then
  begin
    BYH:=true;
    OPER:=true;
    BOS:=false;
    // N1.Visible:=true;      {�����������������       }
    // N2.Visible:=true;      {���������������         }
    // N3.Visible:=false;     {������ �����������      }
    // N4.Visible:=true;      {���������               }
    // N5.Visible:=true;    {�������� ��������       }
    N6.Visible:=false;     {���������               }
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

procedure TFMenu.N4Click(Sender: TObject);  {��������� ��������}
begin
  {��������� ��������}
  CardBox:=TCardBox.Create(Application) ;
  CardBox.showModal;
  CardBox.Free;
end;

procedure TFMenu.N10Click(Sender: TObject); {���������,�����������,�����}
begin
  {����� (����������)}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('Banks',3,'');
  FormNat.Free;
end;

procedure TFMenu.N11Click(Sender: TObject);
begin   {���������,�����������,�����}
  FormContracts:=TFormContracts.Create(Application) ;
  FormContracts.ShowModal;
  FormContracts.Free;
end;

procedure TFMenu.FormCreate(Sender: TObject);
var
  Word: variant;
begin
  // FMenu.CurrentUser:=sql.SelectInteger('')
  //������ MS Word
  try
    Word := GetActiveOleObject('Word.Application');
  except
    Logger.LogError('[Menu.pas] [TFMenu.FormCreate] Failed to open MS Word.');
    try
      Word := CreateOleObject('Word.Application');
      if Word.Visible = False then
      begin
        Word.Visible := True;
      end;
    except
      ShowMessage('�� ���� ��������� MS Word. ��������� MS Word �������.');
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
    //N1.Visible:=true;     {�����������������       }
    //N2.Visible:=true;     {���������������         }
    //N3.Visible:=true;     {������ �����������      }
    //N4.Visible:=true;     {���������               }
    //N5.Visible:=true;     {�����������             }
    // N6.Visible:=true;     {���������               }
    // N7.Visible:=true;     {�����                   }
    //N8.Visible:=true;     {���������               }
    //N9.Visible:=true;     {������� � �����������   }
    // N10.Visible:=true;    {�����                   }
    // N11.Visible:=true;    {��������                }
    // N12.Visible:=true;    {������                  }
    //N13.Visible:=true;    {������                  }
  end;

  if CurrentUserroles=2 then
  begin
    BYH:=true;
    Oper:=true;
    Bos:=false;
    //N1.Visible:=true;       {�����������������       }
    //N2.Visible:=true;       {���������������         }
    //N3.Visible:=false;      {������ �����������      }
    //N4.Visible:=true;       {���������               }
    //N5.Visible:=true;     {�������� ��������       }
    //N6.Visible:=false;      {���������               }
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
  {������ (����������)}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('CityView',3,'');
  FormNat.Free;
end;

procedure TFMenu.N13Click(Sender: TObject);
begin
  {������ (����������)}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('Country',1,'');
  FormNat.Free;
end;

procedure TFMenu.N9Click(Sender: TObject);
begin   {�������� �����������}
  Application.CreateForm(TFCardBoss,FCardBoss) ;
  FCardBoss.EditRecord;
  FCardBoss.Free;
end;

procedure TFMenu.N15Click(Sender: TObject);
begin
  {��������� ��������}
  FormSendBox:=TFormSendBox.Create(Application) ;
  FormSendBox.ShowModal;
  FormSendBox.Free;
end;

procedure TFMenu.N16Click(Sender: TObject);
begin
  {��������� �����������}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('Acceptors',3,'');
  FormNat.Free;
end;

procedure TFMenu.N19Click(Sender: TObject);
begin  {����������}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('PackTariff',2,'');
  FormNat.Free;
end;

procedure TFMenu.N20Click(Sender: TObject);
begin   {������������ �����}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('NameGood',1,'');
  FormNat.Free;
end;

//procedure TFMenu.N21Click(Sender: TObject);
//begin   {���������� �������}
//  FormTrain:=TFormTrain.Create(Application) ;
//  FormTrain.EditRecord;
//  FormTrain.Free;
//end;

procedure TFMenu.N22Click(Sender: TObject);
begin   {��� ��������� }
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('Supplier',1,'');
  FormNat.Free;
end;

procedure TFMenu.N23Click(Sender: TObject);
begin   {���������}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('OnReason',1,'');
  FormNat.Free;
end;

procedure TFMenu.N8Click(Sender: TObject);
begin    {���������}
  FormConstant:=TFormConstant.Create(Application);
  FormConstant.AddRecord;
  FormConstant.free;
end;

procedure TFMenu.N3Click(Sender: TObject);
begin         {������������}
  FormInsp:=TFormInsp.Create(Application);
  FormInsp.ShowModal;
  FormInsp.free;
end;

procedure TFMenu.DBL1Click(Sender: TObject);
begin      {��� ��������}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('PackType',1,'');
  FormNat.Free;
end;

procedure TFMenu.N24Click(Sender: TObject);
begin   { ����������}
  FormOrder:=TFormOrder.Create(Application) ;
  FormOrder.ShowModal;
  FormOrder.Free;
end;

procedure TFMenu.N25Click(Sender: TObject);
begin      {�����}
  FormAccountBox:=TFormAccountBox.Create(Application) ;
  FormAccountBox.ShowModal;
  FormAccountBox.Free;
end;

//procedure TFMenu.N26Click(Sender: TObject);
//begin      {������ �� �� ���������}
//  FormTrainTariff :=TFormTrainTariff .Create(Application) ;
//  FormTrainTariff .Editrecord;
//  FormTrainTariff .Free;
//end;

procedure TFMenu.N27Click(Sender: TObject);
begin   {���� �������}
  FormInvoiceBox :=TFormInvoiceBox .Create(Application) ;
  FormInvoiceBox .ShowModal;
  FormInvoiceBox .Free;
end;

procedure TFMenu.N28Click(Sender: TObject);
begin    {��������� ��������� ��� ������}
//  InvoiceCompare;
  FormPrinterBox :=TFormPrinterBox .Create(Application) ;
  FormPrinterBox .ShowModal;
  FormPrinterBox .Free;
end;

procedure TFMenu.N29Click(Sender: TObject);
begin          {��������}
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
  {FormNat:=TFormNat.Create(Application) ;
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
begin   {���������}
  FormWayBill:=TFormWayBill.Create(Application) ;
  FormWayBill.ShowModal;
  FormWayBill.Free;
end;

procedure TFMenu.N37Click(Sender: TObject);
begin  {����-���}
  FormAKTBox :=TFormAKTBox .Create(Application) ;
  FormAKTBox .ShowModal;
  FormAKTBox .Free;
end;

procedure TFMenu.N38Click(Sender: TObject);
begin     {�����-���}
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
  {�����1-������ (����������)}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('CitySklad1View',0,'');
  FormNat.Free;
end;

procedure TFMenu.N210Click(Sender: TObject);
begin
  {�����2-������ (����������)}
  FormNat:=TFormNat.Create(Application) ;
  FormNat.ShowList('CitySklad2View',0,'');
  FormNat.Free;
end;

procedure TFMenu.N41Click(Sender: TObject);
begin
  FUnload:=TFUnload.Create(Application) ;
  if FUnload.Unload =1 then
    Application.MessageBox('������ ���������!','���������!',0)
  else
    Application.MessageBox('������ ��������� � �������!','������!',0);

  FUnload.Free;
end;

procedure TFMenu.N42Click(Sender: TObject);
begin
  case Application.MessageBox('��������� ������?',
                            '���������������',MB_YESNO+MB_ICONQUESTION) of
    IDYES:
    begin
      if DataChangeLoad.ChangeFile(0) = 0 then
        Application.MessageBox('������ ���������!','���������!',0)
      else
        Application.MessageBox('������ �� ���������,������!','������!',0);
    end;
    IDNO:
      exit;
    end;
end;

procedure TFMenu.N20071Click(Sender: TObject);
begin
  {������ �� 2007 ��� (����������)}
  FormSaldo:=TFormSaldo.Create(Application) ;
  FormSaldo.ShowModal;;
  FormSaldo.Free;
end;

procedure TFMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.MessageBox('���������� ����� �������','��������������!');
end;

procedure TFMenu.N43Click(Sender: TObject);      {���������� �������}
var
  sql_str:TStringList;
begin
  sql_str:=TStringList.Create;
  sql_str.Add(' ALTER TABLE send CHANGE COLUMN InsuranceSum ');
  sql_str.Add(' InsuranceSum VARCHAR(12) NULL DEFAULT NULL, ');
  sql_str.Add(' CHANGE COLUMN InsuranceValue InsuranceValue ');
  sql_str.Add(' VARCHAR(12) NULL DEFAULT NULL ');
  if sql.ExecSQL(sql_str) = 0 then
    Application.MessageBox('���������� ������� ���������!','',0);
  sql_str.free;
end;

procedure TFMenu.N44Click(Sender: TObject);
var
  result: longint;
begin
  FormSend:= TFormSend.Create(Application) ;
  result:=FormSend.AddRecord;
  if (result = 0) then
    Application.MessageBox('�������� �� �������!','Warning',0)
  else
    Application.MessageBox('�������� �������!','Confirmation',0);
  FormSend.free;
end;

procedure TFMenu.updateClientsKredit1Click(Sender: TObject);
begin
 if DataChangeLoad.UpdateClientsKredit() = 0 then
 begin
    Application.MessageBox('���������� �������� ���������!','',0);
 end;
end;

end.



