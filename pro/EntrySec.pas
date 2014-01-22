unit EntrySec;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Tadjform, StdCtrls, Sqlctrls, Lbledit, ExtCtrls, Buttons, BMPBtn, tsqlcls,
  DB, DBTables, SEQUENCE;

  function Iff(const Condition: Boolean; const TruePart, FalsePart: Boolean ): Boolean;  overload;
  function Iff(const Condition: Boolean; const TruePart, FalsePart: Byte    ): Byte;     overload;
  function Iff(const Condition: Boolean; const TruePart, FalsePart: Cardinal): Cardinal; overload;
  function Iff(const Condition: Boolean; const TruePart, FalsePart: Char    ): Char;     overload;
  function Iff(const Condition: Boolean; const TruePart, FalsePart: Extended): Extended;    overload;
  function Iff(const Condition: Boolean; const TruePart, FalsePart: Integer ): Integer;  overload;
  function Iff(const Condition: Boolean; const TruePart, FalsePart: Pointer ): Pointer;  overload;
  function Iff(const Condition: Boolean; const TruePart, FalsePart: String  ): String;   overload;
  {$IFDEF SUPPORTS_INT64}
    function Iff(const Condition: Boolean; const TruePart, FalsePart: Int64   ): Int64;    overload;
  {$ENDIF SUPPORTS_INT64}

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
  version: string;
  bAllData: boolean;
  period: string;
  // krutogolov
  // strings for tables
  account_table: string;
  accounttek_table: string;
  akttek_table: string;
  invoice_table: string;
  order_table: string;
  paysheet_table: string;
  send_table: string;
  // strings for views
  accountview_view: string;
  accounttekview_view: string;
  akttekview_view: string;
  invoiceview_view: string;
  orders_view: string;
  orderstek_view: string;
  paysheetview_view: string;
  sends_view: string;
  svpayreceipt_view: string;
  vs1_view: string;
  vs2_view: string;

  // other tables
  account_table_other: string;
  accounttek_table_other: string;
  akttek_table_other: string;
  invoice_table_other: string;
  order_table_other: string;
  paysheet_table_other: string;
  send_table_other: string;

  // other views
  accountview_view_other: string;
  accounttekview_view_other: string;
  akttekview_view_other: string;
  invoiceview_view_other: string;
  orders_view_other: string;
  orderstek_view_other: string;
  paysheetview_view_other: string;
  sends_view_other: string;
  svpayreceipt_view_other: string;
  vs1_view_other: string;
  vs2_view_other: string;

type
  TTestThread = class(TThread)
  public
     Constructor Create(CreateSuspended : boolean);
  protected
     procedure Execute; override;
  end;

type
  TDeleteThread = class(TThread)
  public
     Constructor Create(CreateSuspended: boolean;
                              table_str: string;
                              ident_str: string);
  protected
    procedure Execute; override;
  private
    table: string;
    ident: string;
  end;

type
  TInsertThread = class(TThread)
  public
     Constructor Create(CreateSuspended: boolean;
                              table_str: string;
                              field_str: string;
                              value_str: string);
  protected
    procedure Execute; override;
  private
    table: string;
    field: string;
    value: string;
  end;

type
  TUpdateThread = class(TThread)
  public
     Constructor Create(CreateSuspended: boolean;
                              table_str: string;
                              value_str: string;
                              key_str: string);
  protected
    procedure Execute; override;
  private
    table: string;
    value: string;
    key: string;
  end;


implementation

uses    Menu;

{$R *.DFM}

constructor TTestThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TTestThread.Execute;
var
  sql_str: TStringList;
begin
  if (not Terminated) then
  begin
    sql_str:=TStringList.Create;
    // krutogolov
    // see @
    sql_str.Add('call  `update_tables_all_6m`;');
    sql.ExecSQL(sql_str);
    sql_str.free;
  end;
end;

constructor TDeleteThread.Create(CreateSuspended: boolean;
                                       table_str: string;
                                       ident_str: string);
begin
  table :=table_str;
  ident :=ident_str;
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TDeleteThread.Execute;
var
  sql_str: TStringList;
  temp_str: string;
begin
  if (not Terminated) then
  begin
    sql_str:=TStringList.Create;
    temp_str:='delete from ' + table + ' where `Ident` = ' + ident;
    sql_str.Add(temp_str);
    sql.ExecSQL(sql_str);
    sql_str.free;
  end;
end;

constructor TInsertThread.Create(CreateSuspended: boolean;
                                       table_str: string;
                                       field_str: string;
                                       value_str: string);
begin
  table :=table_str;
  field :=field_str;
  value :=value_str;
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TInsertThread.Execute;
begin
  if (not Terminated) then
  begin
    sql.InsertString(table, field, value);
  end;
end;

constructor TUpdateThread.Create(CreateSuspended: boolean;
                                       table_str: string;
                                       value_str: string;
                                       key_str: string);
begin
  table := table_str;
  value := value_str;
  key := key_str;
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TUpdateThread.Execute;
begin
  if not Terminated then
  begin
    sql.UpdateString(table, value, key);
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

  if (q.eof) then
  begin
    Application.MessageBox('Неправильное имя или пароль!','Ошибка',0);
    eShortName.setfocus;
    exit;
  end;

  FMenu.CurrentUser:=q.FieldByName('Ident').AsInteger;
  FMenu.CurrentUserRoles:=q.FieldByName('Roles_Ident').AsInteger;
  FMenu.CurrentUserName:=eShortName.text;
  bAllData := ChBoxAll.Checked;
  version:= '2.0.01.02.14';
  period:=iff(bAllData, 'ВСЕ ВРЕМЯ', '6 Mесяцев');
  // other tables
  account_table_other:=iff(not bAllData, 'account_all', 'account');
  accounttek_table_other:=iff(not bAllData, 'accounttek_all', 'accounttek');
  akttek_table_other:=iff(not bAllData, 'akttek_all', 'akttek');
  invoice_table_other:=iff(not bAllData, 'invoice_all', 'invoice');
  order_table_other:=iff(not bAllData, 'order_all', '`order`');
  paysheet_table_other:=iff(not bAllData, 'paysheet_all', 'paysheet');
  send_table_other:=iff(not bAllData, 'send_all', 'send');
  // strings for other views
  accountview_view_other:=iff(not bAllData, 'accountview_all', 'accountview');
  accounttekview_view_other:=iff(not bAllData, 'accounttekview_all', 'accounttekview');
  akttekview_view_other:=iff(not bAllData, 'akttekview_all', 'akttekview');
  invoiceview_view_other:=iff(not bAllData, 'invoiceview_all', 'invoiceview');
  orders_view_other:=iff(not bAllData, 'orders_all', 'orders');
  orderstek_view_other:=iff(not bAllData, 'orderstek_all', 'orderstek');
  paysheetview_view_other:=iff(not bAllData, 'paysheetview_all', 'paysheetview');
  sends_view_other:=iff(not bAllData, 'sends_all', 'sends');
  svpayreceipt_view_other:=iff(not bAllData, 'svpayreceipt_all', 'svpayreceipt');
  vs1_view_other:=iff(not bAllData, 'vs1_all', 'vs1');
  vs2_view_other:=iff(not bAllData, 'vs2_all', 'vs2');

  // tables
  account_table:=iff(bAllData, 'account_all', 'account');
  accounttek_table:=iff(bAllData, 'accounttek_all', 'accounttek');
  akttek_table:=iff(bAllData, 'akttek_all', 'akttek');
  invoice_table:=iff(bAllData, 'invoice_all', 'invoice');
  order_table:=iff(bAllData, 'order_all', '`order`');
  paysheet_table:=iff(bAllData, 'paysheet_all', 'paysheet');
  send_table:=iff(bAllData, 'send_all', 'send');
  // strings for views
  accountview_view:=iff(bAllData, 'accountview_all', 'accountview');
  accounttekview_view:=iff(bAllData, 'accounttekview_all', 'accounttekview');
  akttekview_view:=iff(bAllData, 'akttekview_all', 'akttekview');
  invoiceview_view:=iff(bAllData, 'invoiceview_all', 'invoiceview');
  orders_view:=iff(bAllData, 'orders_all', 'orders');
  orderstek_view:=iff(bAllData, 'orderstek_all', 'orderstek');
  paysheetview_view:=iff(bAllData, 'paysheetview_all', 'paysheetview');
  sends_view:=iff(bAllData, 'sends_all', 'sends');
  svpayreceipt_view:=iff(bAllData, 'svpayreceipt_all', 'svpayreceipt');
  vs1_view:=iff(bAllData, 'vs1_all', 'vs1');
  vs2_view:=iff(bAllData, 'vs2_all', 'vs2');

  if (bAllData) then
  begin
    sql_str:=TStringList.Create;
    sql_str.Add('call  `update_tables_all_6m`;');
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
  if (FMenu.CurrentUser <> 0) then
  begin
    btCancel.Caption:='Отменить';
    eShortName.Edit.SetFocus;          //btOk.setfocus;
  end;
end;

procedure TEntrySecurity.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_Return) then
    btOKClick(Sender)
end;

//*******************************************************
// Funes
// Substituio do operador "?" em C
//*******************************************************
function Iff(const Condition: Boolean; const TruePart, FalsePart: Boolean): Boolean; overload;
begin
  if Condition then    Result := TruePart
  else    Result := FalsePart;
end;
//*******************************************************
function Iff(const Condition: Boolean; const TruePart, FalsePart: Byte): Byte; overload;
begin
  if Condition then    Result := TruePart
  else    Result := FalsePart;
end;
//*******************************************************
function Iff(const Condition: Boolean; const TruePart, FalsePart: Cardinal): Cardinal; overload;
begin
  if Condition then    Result := TruePart
  else    Result := FalsePart;
end;
//*******************************************************
function Iff(const Condition: Boolean; const TruePart, FalsePart: Char): Char; overload;
begin
  if Condition then    Result := TruePart
  else    Result := FalsePart;
end;
//*******************************************************
function Iff(const Condition: Boolean; const TruePart, FalsePart: Extended): Extended; overload;
begin
  if Condition then    Result := TruePart
  else    Result := FalsePart;
end;
//*******************************************************
function Iff(const Condition: Boolean; const TruePart, FalsePart: Integer): Integer; overload;
begin
  if Condition then    Result := TruePart
  else    Result := FalsePart;
end;
//*******************************************************
function Iff(const Condition: Boolean; const TruePart, FalsePart: Pointer): Pointer; overload;
begin
  if Condition then    Result := TruePart
  else    Result := FalsePart;
end;
//*******************************************************
function Iff(const Condition: Boolean; const TruePart, FalsePart: String): String; overload;
begin
  if Condition then    Result := TruePart
  else    Result := FalsePart;
end;
//*******************************************************
{$IFDEF SUPPORTS_INT64}
function Iff(const Condition: Boolean; const TruePart, FalsePart: Int64): Int64; overload;
begin
  if Condition then    Result := TruePart
  else    Result := FalsePart;
end;
{$ENDIF SUPPORTS_INT64}

end.
