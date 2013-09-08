unit Lbsqlcmb;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,SQLCombo,SQLCtrls,DBTables;

Type TLabelSQLComboBox=class(TSQLControl)
      protected
        BackUp:Integer;
        procedure WriteCaption(s:string);
        Function ReadCaption:String;
        procedure WriteDSN(s:string);
        Function ReadDSN:String;
        procedure WriteTable(s:string);
        Function ReadTable:String;
        procedure WriteID(s:string);
        Function ReadID:String;
        procedure WriteInfo(s:string);
        Function ReadInfo:String;
        procedure WriteWhere(s:string);
        Function ReadWhere:String;
        procedure WritePC(s:boolean);
        Function ReadPC:boolean;
        procedure WriteNotNull(s:boolean);
        Function ReadNotNull:boolean;
        procedure WriteNewItemFlag(s:boolean);
        Function ReadNewItemFlag:boolean;
        procedure WriteOnChange(s:TNotifyEvent);
        Function ReadOnChange:TNotifyEvent;
        procedure CBOnKeyUp(Sender: TObject; var Key: Word;
                                      Shift: TShiftState);
        procedure CBOnEnter(Sender: TObject);
        procedure WriteNullStr(s:string);
        Function ReadNullStr:string;
      public
        Data,Parm:longint;
        Lbl:TLabel;
        SQLComboBox:TSQLComboBox;
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
        function GetHeight:integer;
        procedure Value(sl:TStringList); override;
        procedure SetValue(var q:TQuery); override;
        procedure SetActive(l:longint);
        function GetData:longint;
      published
        property Caption:String read ReadCaption write WriteCaption;
        property Table:String read ReadTable write WriteTable;
        property DatabaseName:String read ReadDSN write WriteDSN;
        property IDField:String read ReadID write WriteID;
        property InfoField:String read ReadInfo write WriteInfo;
        property Where:String read ReadWhere write WriteWhere;
        property ParentColor:boolean read ReadPC write WritePC;
        property NotNull:boolean read ReadNotNull write WriteNotNull;
        property NullStr:string read ReadNullStr write WriteNullStr;
        property NewItemFlag:boolean read ReadNewItemFlag write WriteNewItemFlag;
        property OnChange:TNotifyEvent read ReadOnChange write WriteOnChange;
        property Align;
        property DragCursor;
        property DragMode;
        property Enabled;
        property ParentShowHint;
        property PopupMenu;
        property ShowHint;
        property TabOrder;
        property TabStop;
        property Visible;
        property OnDragDrop;
        property OnDragOver;
        property OnEndDrag;
        property OnEnter;
        property OnExit;
end;

procedure Register;

implementation
Uses WinTypes;

function TLabelSQLComboBox.GetHeight:integer;
begin
  GetHeight:=-Lbl.Font.Height+13-SQLComboBox.Font.Height
end;

destructor TLabelSQLComboBox.Destroy;
begin
  Lbl.Free;
  SQLComboBox.Free;
  inherited Destroy
end;

constructor TLabelSQLComboBox.Create(AOwner:TComponent);
begin
  inherited create(AOwner);
  Lbl:=TLabel.Create(self);
  SQLComboBox:=TSQLComboBox.Create(self);
  Lbl.Parent:=self;
  SQLComboBox.Parent:=self;
  Lbl.Left:=0;
  Lbl.Top:=0;
  SQLComboBox.Left:=0;
  SQLComboBox.OnEnter:=CBOnEnter;
  SQLComboBox.OnKeyUp:=CBOnKeyUp;
  Parm:=0;
end;

procedure TLabelSQLComboBox.Value(sl:TStringList);
var i:integer;
begin
  if Assigned(fValueEvent) then fValueEvent(self,sl)
  else
    if (not Visible) or (SQLComboBox.GetData=0) then sl.Add('NULL')
    else
      sl.Add(IntToStr(SQLComboBox.GetData));
end;

procedure TLabelSQLCombobox.SetValue(var q:TQuery);
begin
  if Assigned(fSetValueEvent) then fSetValueEvent(self,q)
  else
    SQLCombobox.SetActive(q.FieldByName(fFieldName).AsInteger);
end;

procedure TLabelSQLComboBox.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  SQLComboBox.Top:=Lbl.Height;
  SQLComboBox.Height:=-SQLComboBox.Font.Height+10;
  SQLComboBox.Width:=Msg.LParamLo;
  Height:=SQLComboBox.Height+Lbl.Height+1;
  Width:=Msg.LParamLo;
end;

procedure TLabelSQLComboBox.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLabelSQLComboBox.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure TLabelSQLComboBox.WriteDSN(s:String);
begin
  SQLComboBox.DatabaseName:=s
end;

function TLabelSQLComboBox.ReadDSN:String;
begin
  ReadDSN:=SQLComboBox.DatabaseName
end;

procedure TLabelSQLComboBox.WriteTable(s:String);
begin
  SQLComboBox.Table:=s
end;

function TLabelSQLComboBox.ReadTable:String;
begin
  ReadTable:=SQLComboBox.Table
end;

procedure TLabelSQLComboBox.WriteID(s:String);
begin
  SQLComboBox.IDField:=s
end;

function TLabelSQLComboBox.ReadID:String;
begin
  ReadID:=SQLComboBox.IDField
end;

procedure TLabelSQLComboBox.WriteInfo(s:String);
begin
  SQLComboBox.InfoField:=s
end;

function TLabelSQLComboBox.ReadInfo:String;
begin
  ReadInfo:=SQLComboBox.InfoField
end;

procedure TLabelSQLComboBox.WriteWhere(s:String);
begin
  SQLComboBox.Where:=s
end;

function TLabelSQLComboBox.ReadWhere:String;
begin
  ReadWhere:=SQLComboBox.Where
end;

procedure TLabelSQLComboBox.WriteNullStr(s:String);
begin
  SQLComboBox.NullStr:=s
end;

function TLabelSQLComboBox.ReadNullStr:String;
begin
  ReadNullStr:=SQLComboBox.NullStr
end;

procedure TLabelSQLComboBox.WritePC(s:boolean);
begin
  SQLComboBox.ParentColor:=s
end;

function TLabelSQLComboBox.ReadPC:boolean;
begin
  ReadPC:=SQLComboBox.ParentColor
end;

procedure TLabelSQLComboBox.WriteNotNull(s:boolean);
begin
  SQLComboBox.NotNull:=s
end;

function TLabelSQLComboBox.ReadNotNull:boolean;
begin
  ReadNotNull:=SQLComboBox.NotNull
end;

procedure TLabelSQLComboBox.WriteNewItemFlag(s:boolean);
begin
  SQLComboBox.NewItemFlag:=s
end;

function TLabelSQLComboBox.ReadNewItemFlag:boolean;
begin
  ReadNewItemFlag:=SQLComboBox.NewItemFlag
end;

procedure TLabelSQLComboBox.WriteOnChange(s:TNotifyEvent);
begin
  SQLComboBox.OnUserChange:=s
end;

function TLabelSQLComboBox.ReadOnChange:TNotifyEvent;
begin
  ReadOnChange:=SQLComboBox.OnUserChange
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TLabelSQLComboBox])
end;

procedure TLabelSQLComboBox.CBOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then SQLComboBox.ItemIndex:=BackUp
end;

procedure TLabelSQLComboBox.CBOnEnter(Sender: TObject);
begin
  SQLComboBox.SetFocus;
  BackUp:=SQLComboBox.ItemIndex;
  SQLCombobox.Substr:=''
end;

procedure TLabelSQLComboBox.SetActive(l:longint);
begin
  SQLCombobox.SetActive(l)
end;

function TLabelSQLComboBox.GetData:longint;
begin
  GetData:=SQLCombobox.GetData
end;

end.
