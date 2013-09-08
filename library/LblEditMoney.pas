unit LblEditMoney;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,SQLCtrls,DBTables,WinTypes,TSQLCls,EditMoney;

Type TLblEditMoney=class(TSQLControl)
      protected
        FOnKeyUp:TKeyEvent;
        procedure WriteCaption(s:string);
        Function ReadCaption:String;
        procedure WriteText(s:string);
        Function ReadText:String;
        procedure WriteOnChange(s:TNotifyEvent);
        Function ReadOnChange:TNotifyEvent;
        procedure WritePC(s:boolean);
        Function ReadPC:boolean;
        procedure WriteRO(s:boolean);
        Function ReadRO:boolean;
        procedure WriteML(s:integer);
        Function ReadML:integer;
        procedure LEOnEnter(Sender:TObject);
        Function ReadAlignment:TAlignment;
        procedure WriteAlignment(s:TAlignment);
      public
        BackUp:String;
        Data:longint;
        Lbl:TLabel;
        EditMoney:TEditMoney;
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
        function GetHeight:integer;
        procedure Value(sl:TStringList); override;
        procedure SetValue(var q:TQuery); override;
        procedure LEOnKeyUp(Sender: TObject; var Key: Word;
                            Shift: TShiftState);
      published
        property Alignment:TAlignment read ReadAlignment write WriteAlignment;
        property Caption:String read ReadCaption write WriteCaption;
        property Text:String read ReadText write WriteText;
        property ParentColor:boolean read ReadPC write WritePC;
        property ReadOnly:boolean read ReadRO write WriteRO;
        property OnChange:TNotifyEvent read ReadOnChange write WriteOnChange;
        property OnKeyUp:TKeyEvent read FOnKeyUp write FOnKeyUp;
        property MaxLength:integer read ReadML write WriteML;
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

function TLblEditMoney.GetHeight:integer;
begin
  GetHeight:=-EditMoney.Font.Height+13-Lbl.Font.Height
end;

destructor TLblEditMoney.Destroy;
begin
  Lbl.Free;
  EditMoney.Free;
  inherited Destroy
end;

constructor TLblEditMoney.Create(AOwner:TComponent);
begin
  FOnKeyUp:=NIL;
  inherited create(AOwner);
  Lbl:=TLabel.Create(self);
  EditMoney:=TEditMoney.Create(self);
  Lbl.Parent:=self;
  EditMoney.Parent:=self;
  Lbl.Left:=0;
  Lbl.Top:=0;
  EditMoney.Left:=0;
  OnEnter:=LEOnEnter;
  EditMoney.OnKeyUp:=LEOnKeyUp
end;

procedure TLblEditMoney.Value(sl:TStringList);
begin
  if Assigned(fValueEvent) then fValueEvent(self,sl)
  else
    if Visible then  sl.Add(sql.MakeStr(Text))
    else sl.Add('NULL')
end;

procedure TLblEditMoney.SetValue(var q:TQuery);
begin
  if Assigned(fSetValueEvent) then fSetValueEvent(self,q)
  else
    try
      Text:=q.FieldByName(fFieldName).AsString;
    except
    end;
end;

procedure TLblEditMoney.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  EditMoney.Top:=Lbl.Height;
  EditMoney.Height:=-EditMoney.Font.Height+10;
  EditMoney.Width:=Msg.LParamLo;
  Height:=EditMoney.Height+Lbl.Height;
  Width:=Msg.LParamLo;
end;

procedure TLblEditMoney.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLblEditMoney.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure TLblEditMoney.WritePC(s:boolean);
begin
  EditMoney.ParentColor:=s
end;

function TLblEditMoney.ReadPC:boolean;
begin
  ReadPC:=EditMoney.ParentColor
end;

procedure TLblEditMoney.WriteRO(s:boolean);
begin
  EditMoney.ReadOnly:=s
end;

function TLblEditMoney.ReadRO:boolean;
begin
  ReadRO:=EditMoney.ReadOnly
end;

procedure TLblEditMoney.WriteML(s:integer);
begin
  EditMoney.MaxLength:=s
end;

function TLblEditMoney.ReadML:integer;
begin
  ReadML:=EditMoney.MaxLength
end;

procedure TLblEditMoney.WriteText(s:String);
begin
  EditMoney.Text:=s
end;

function TLblEditMoney.ReadText:String;
begin
  ReadText:=EditMoney.Text
end;

procedure TLblEditMoney.WriteOnChange(s:TNotifyEvent);
begin
  EditMoney.OnChange:=s
end;

function TLblEditMoney.ReadOnChange:TNotifyEvent;
begin
  ReadOnChange:=EditMoney.OnChange
end;

procedure Register;
begin
  RegisterComponents('asd',[TLblEditMoney])
end;

procedure TLblEditMoney.LEOnEnter(Sender:TObject);
begin
  EditMoney.SetFocus;
  BackUp:=EditMoney.Text
end;

procedure TLblEditMoney.LEOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then
    EditMoney.Text:=BackUp;
  if Assigned(fOnKeyUp) then
    fOnKeyUp(Sender, Key, Shift);
end;

Function TLblEditMoney.ReadAlignment;
begin
ReadAlignment:=EditMoney.Alignment;
end;

procedure TLblEditMoney.WriteAlignment(s:TAlignment);
begin
EditMoney.Alignment:=s;
end;

end.
