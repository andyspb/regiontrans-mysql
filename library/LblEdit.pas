unit Lbledit;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,SQLCtrls,DBTables,WinTypes,TSQLCls;

Type TLabelEdit=class(TSQLControl)
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
      public
        BackUp:String;
        Data:longint;
        Lbl:TLabel;
        Edit:TEdit;
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
        function GetHeight:integer;
        procedure Value(sl:TStringList); override;
        procedure SetValue(var q:TQuery); override;
        procedure LEOnKeyUp(Sender: TObject; var Key: Word;
                            Shift: TShiftState);
        procedure LEOnExit(Sender:TObject);
      published
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

function TLabelEdit.GetHeight:integer;
begin
  GetHeight:=-Edit.Font.Height+13-Lbl.Font.Height
end;

destructor TLabelEdit.Destroy;
begin
  Lbl.Free;
  Edit.Free;
  inherited Destroy
end;

constructor TLabelEdit.Create(AOwner:TComponent);
begin
  FOnKeyUp:=NIL;
  inherited create(AOwner);
  Lbl:=TLabel.Create(self);
  Edit:=TEdit.Create(self);
  Lbl.Parent:=self;
  Edit.Parent:=self;
  Lbl.Left:=0;
  Lbl.Top:=0;
  Edit.Left:=0;
  OnEnter:=LEOnEnter;
  OnExit:=LEOnExit;
  Edit.OnKeyUp:=LEOnKeyUp
end;

procedure TLabelEdit.Value(sl:TStringList);
begin
  if Assigned(fValueEvent) then fValueEvent(self,sl)
  else
    if Visible then  sl.Add(sql.MakeStr(Text))
    else sl.Add('NULL')
end;

procedure TLabelEdit.SetValue(var q:TQuery);
begin
  if Assigned(fSetValueEvent) then fSetValueEvent(self,q)
  else
    try
      Text:=q.FieldByName(fFieldName).AsString;
    except
    end;
end;

procedure TLabelEdit.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  Edit.Top:=Lbl.Height;
  Edit.Height:=-Edit.Font.Height+10;
  Edit.Width:=Msg.LParamLo;
  Height:=Edit.Height+Lbl.Height;
  Width:=Msg.LParamLo;
end;

procedure TLabelEdit.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLabelEdit.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure TLabelEdit.WritePC(s:boolean);
begin
  Edit.ParentColor:=s
end;

function TLabelEdit.ReadPC:boolean;
begin
  ReadPC:=Edit.ParentColor
end;

procedure TLabelEdit.WriteRO(s:boolean);
begin
  Edit.ReadOnly:=s
end;

function TLabelEdit.ReadRO:boolean;
begin
  ReadRO:=Edit.ReadOnly
end;

procedure TLabelEdit.WriteML(s:integer);
begin
  Edit.MaxLength:=s
end;

function TLabelEdit.ReadML:integer;
begin
  ReadML:=Edit.MaxLength
end;

procedure TLabelEdit.WriteText(s:String);
begin
  Edit.Text:=TrimRight(s)
end;

function TLabelEdit.ReadText:String;
begin
  ReadText:=Edit.Text
end;

procedure TLabelEdit.WriteOnChange(s:TNotifyEvent);
begin
  Edit.OnChange:=s
end;

function TLabelEdit.ReadOnChange:TNotifyEvent;
begin
  ReadOnChange:=Edit.OnChange
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TLabelEdit])
end;

procedure TLabelEdit.LEOnEnter(Sender:TObject);
begin
  Edit.SetFocus;
  BackUp:=Edit.Text
end;

procedure TLabelEdit.LEOnExit(Sender:TObject);
begin
  BackUp:=Edit.Text
end;

procedure TLabelEdit.LEOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then
    Edit.Text:=BackUp;
  if Assigned(fOnKeyUp) then
    fOnKeyUp(Sender, Key, Shift);
end;

end.
