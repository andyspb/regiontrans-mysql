unit Lbsqlist;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,SQLList,SQLCtrls,DBTables;

Type TLabelSQLListBox=class(TSQLControl)
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
        procedure WriteOnChange(s:TNotifyEvent);
        Function ReadOnChange:TNotifyEvent;
        procedure LBOnKeyUp(Sender: TObject; var Key: Word;
                     Shift: TShiftState);
        procedure LBOnEnter(Sender: TObject);
        procedure WriteOnItemChange(s:TNotifyEvent);
        Function ReadOnItemChange:TNotifyEvent;
      public
        Data:longint;
        Lbl:TLabel;
        SQLListBox:TSQLListBox;
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
        property OnChange:TNotifyEvent read ReadOnChange write WriteOnChange;
        property OnItemChange:TNotifyEvent read ReadOnItemChange write WriteOnItemChange;
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

function TLabelSQLListBox.GetHeight:integer;
begin
  GetHeight:=Height
end;

destructor TLabelSQLListBox.Destroy;
begin
  Lbl.Free;
  SQLListBox.Free;
  inherited Destroy;
end;

constructor TLabelSQLListBox.Create(AOwner:TComponent);
begin
  inherited create(AOwner);
  Lbl:=TLabel.Create(self);
  SQLListBox:=TSQLListBox.Create(self);
  Lbl.Parent:=self;
  SQLListBox.Parent:=self;
  Lbl.Left:=0;
  Lbl.Top:=0;
  SQLListBox.Left:=0;
end;

procedure TLabelSQLListBox.Value(sl:TStringList);
var i:integer;
begin
  if Assigned(fValueEvent) then fValueEvent(self,sl)
  else
    if (not Visible) or (SQLListBox.GetData=0) then sl.Add('NULL')
    else
      sl.Add(IntToStr(SQLListBox.GetData));
end;

procedure TLabelSQLListbox.SetValue(var q:TQuery);
begin
  if Assigned(fSetValueEvent) then fSetValueEvent(self,q)
  else
    SQLListbox.SetActive(q.FieldByName(fFieldName).AsInteger);
end;

procedure TLabelSQLListBox.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  SQLListBox.Top:=Lbl.Height;
  SQLListBox.Height:=Msg.LParamHi-SQLListBox.Top;
  SQLListBox.Width:=Msg.LParamLo;
  Height:=Msg.LParamHi;
  Width:=Msg.LParamLo;
end;

procedure TLabelSQLListBox.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLabelSQLListBox.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure TLabelSQLListBox.WriteDSN(s:String);
begin
  SQLListBox.DatabaseName:=s
end;

function TLabelSQLListBox.ReadDSN:String;
begin
  ReadDSN:=SQLListBox.DatabaseName
end;

procedure TLabelSQLListBox.WriteTable(s:String);
begin
  SQLListBox.Table:=s
end;

function TLabelSQLListBox.ReadTable:String;
begin
  ReadTable:=SQLListBox.Table
end;

procedure TLabelSQLListBox.WriteID(s:String);
begin
  SQLListBox.IDField:=s
end;

function TLabelSQLListBox.ReadID:String;
begin
  ReadID:=SQLListBox.IDField
end;

procedure TLabelSQLListBox.WriteInfo(s:String);
begin
  SQLListBox.InfoField:=s
end;

function TLabelSQLListBox.ReadInfo:String;
begin
  ReadInfo:=SQLListBox.InfoField
end;

procedure TLabelSQLListBox.WriteWhere(s:String);
begin
  SQLListBox.Where:=s
end;

function TLabelSQLListBox.ReadWhere:String;
begin
  ReadWhere:=SQLListBox.Where
end;

procedure TLabelSQLListBox.WritePC(s:boolean);
begin
  SQLListBox.ParentColor:=s
end;

function TLabelSQLListBox.ReadPC:boolean;
begin
  ReadPC:=SQLListBox.ParentColor
end;

procedure TLabelSQLListBox.WriteOnChange(s:TNotifyEvent);
begin
  SQLListBox.OnClick:=s
end;

function TLabelSQLListBox.ReadOnChange:TNotifyEvent;
begin
  ReadOnChange:=SQLListBox.OnClick
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TLabelSQLListBox])
end;

procedure TLabelSQLListBox.LBOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then SQLListBox.ItemIndex:=BackUp
end;

procedure TLabelSQLListBox.LBOnEnter(Sender: TObject);
begin
  SQLListBox.SetFocus;
  BackUp:=SQLListBox.ItemIndex
end;

procedure TLabelSQLListBox.SetActive(l:longint);
begin
  SQLListbox.SetActive(l)
end;

function TLabelSQLListBox.GetData:longint;
begin
  GetData:=SQLListbox.GetData
end;

procedure TLabelSQLListBox.WriteOnItemChange(s:TNotifyEvent);
begin
  SQLListBox.OnItemChange:=s
end;

Function TLabelSQLListBox.ReadOnItemChange:TNotifyEvent;
begin
  ReadOnItemChange:=SQLListBox.OnItemChange;
end;


end.
