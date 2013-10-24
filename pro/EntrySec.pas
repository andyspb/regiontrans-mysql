unit EntrySec;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Tadjform, StdCtrls, Sqlctrls, Lbledit, ExtCtrls, Buttons, BMPBtn,tsqlcls,
  DB,DBTables,SEQUENCE;

type
  TEntrySecurity = class(Tadjustform)
    Bevel1: TBevel;
    eShortName: TLabelEdit;
    ePassword: TEdit;
    Label1: TLabel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    ChBoxAll: TCheckBox;
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    end;

var
  EntrySecurity: TEntrySecurity;
  bAllData: boolean;
  period: string;
  // krutogolov
  // strings for tables
  account_str: string;
  accounttek_str: string;
  akttek_str: string;
  invoice_str: string;
  order_str: string;
  paysheet_str: string;
  send_str: string;
  // strings for views
  accountview_str: string;
  accounttekview_str: string;
  akttekview_str: string;
  invoiceview_str: string;
  orders_str: string;
  orderstek_str: string;
  paysheetview_str: string;
  sends_str: string;
  svpayreceipt_str: string;
  vs1_str: string;
  vs2_str: string;


type
  TTestThread = class(TThread)
  public
     Constructor Create(CreateSuspended : boolean);
  protected
     procedure Execute; override;
  end;



implementation

uses    Menu;

{$R *.DFM}

constructor TTestThread.Create(CreateSuspended : boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TTestThread.Execute;
var
  sql_str: TStringList;
begin
  if not Terminated then
  begin
    sql_str:=TStringList.Create;
    sql_str.Add('call  `update_tables_all`;');
    sql.ExecSQL(sql_str);
    sql_str.free;
  end;
end;

procedure TEntrySecurity.btOKClick(Sender: TObject);
var
  q: TQuery;
  str: string;
  sql_str: TStringList;
  thread: TTestThread;
begin
  str:='(ShortName='''+eShortName.text +''') and (Password='''+ePassword.text+''')';
  q:=sql.select('Inspector','Ident,Roles_Ident',str ,  '' );

  if q.eof then
  begin
    Application.MessageBox('Неправильное имя или пароль!','Ошибка',0);
    eShortName.setfocus;
    exit;
  end;

  FMenu.CurrentUser:=q.FieldByName('Ident').AsInteger;
  FMenu.CurrentUserRoles:=q.FieldByName('Roles_Ident').AsInteger;
  FMenu.CurrentUserName:=eShortName.text;
  bAllData := ChBoxAll.Checked;
  if (bAllData) then
  // krutogolov
  // all data
  begin
    period:='ВСЕ ВРЕМЯ';
    // tables
    account_str:='account_all';
    accounttek_str:='accounttek_all';
    akttek_str:='akttek_all';
    invoice_str:='invoice_all';
    order_str:='order_all';
    paysheet_str:='paysheet_all';
    send_str:='send_all';
    // strings for views
    accountview_str:='accountview_all';
    accounttekview_str:='accounttekview_all';
    akttekview_str:='akttekview_all';
    invoiceview_str:='invoiceview_all';
    orders_str:='orders_all';
    orderstek_str:='orderstek_all';
    paysheetview_str:='paysheetview_all';
    sends_str:='sends_all';
    svpayreceipt_str:='svpayreceipt_all';
    vs1_str:='vs1_all';
    vs2_str:='vs2_all';
  end
  else
  // krutogolov
  // data for the period
  begin
    period:='ГОД';
    // tables
    account_str:='account';
    accounttek_str:='accounttek';
    akttek_str:='akttek';
    invoice_str:='invoice';
    order_str:='order';
    paysheet_str:='paysheet';
    send_str:='send';
    // strings for views
    accountview_str:='accountview';
    accounttekview_str:='accounttekview';
    akttekview_str:='akttekview';
    invoiceview_str:='invoiceview';
    orders_str:='orders';
    orderstek_str:='orderstek';
    paysheetview_str:='paysheetview';
    sends_str:='sends';
    svpayreceipt_str:='svpayreceipt';
    vs1_str:='vs1';
    vs2_str:='vs2';
  end;

  if (bAllData) then
  begin
    sql_str:=TStringList.Create;
    sql_str.Add('call  `update_tables_all`;');
    sql.ExecSQL(sql_str);
    sql_str.free;
  end
  else
  begin
    thread:= TTestThread.Create(True);
    thread.Resume();
  end;
  ModalResult:=mrOK;
end;

procedure TEntrySecurity.btCancelClick(Sender: TObject);
begin
  ModalResult:= mrCancel
end;

procedure TEntrySecurity.FormCreate(Sender: TObject);
begin
  eShortName.Edit.Font.Size:=10;
  ePassword.Font.Size:=10;
  fsection:='EntrySecuritySect';
end;

procedure TEntrySecurity.FormActivate(Sender: TObject);
begin
  if FMenu.CurrentUser<>0 then
  begin
    btCancel.Caption:='Отменить';
    eShortName.Edit.SetFocus;          //btOk.setfocus;
  end;
end;

procedure TEntrySecurity.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_Return then
    btOKClick(Sender)
end;

end.
