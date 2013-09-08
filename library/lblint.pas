unit Lblint;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,SQLCtrls,DBTables,Mask;

Type TLabelInteger=class(TSQLControl)
      protected
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
        procedure EditOnKeyUp(Sender: TObject; var Key: Word;
                                      Shift: TShiftState);
        procedure EditOnEnter(Sender: TObject);
        procedure LEOnExit(Sender:TObject);
        procedure EditOnClick(Sender: TObject);
      public
        PrevValue :string;
        Data:longint;
        Lbl:TLabel;
        Edit:TMaskEdit;
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
        function GetHeight:integer;
        procedure Value(sl:TStringList); override;
        procedure SetValue(var q:TQuery); override;
        function AsInteger:longint;
      published
        property Caption:String read ReadCaption write WriteCaption;
        property Text:String read ReadText write WriteText;
        property ParentColor:boolean read ReadPC write WritePC;
        property ReadOnly:boolean read ReadRO write WriteRO;
        property OnChange:TNotifyEvent read ReadOnChange write WriteOnChange;
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
Uses WinTypes;

function TLabelInteger.GetHeight:integer;
begin
  GetHeight:=-Edit.Font.Height+13-Lbl.Font.Height
end;

destructor TLabelInteger.Destroy;
begin
  Lbl.Free;
  Edit.Free;
  inherited Destroy
end;

constructor TLabelInteger.Create(AOwner:TComponent);
begin
  inherited create(AOwner);
  Lbl:=TLabel.Create(self);
  Edit:=TMaskEdit.Create(self);
  Edit.EditMask:='99999;0; ';
  Edit.Text:='0';
  PrevValue:='0';
  Lbl.Parent:=self;
  Edit.Parent:=self;
  Lbl.Left:=0;
  Lbl.Top:=0;
  Edit.Left:=0;
  Edit.OnKeyUp:=EditOnKeyUp;
  Edit.OnEnter:=EditOnEnter;
  Edit.OnClick:=EditonClick;
  Edit.OnExit:=LEonExit
end;

procedure TLabelInteger.Value(sl:TStringList);
var l:longint;
begin
  if Assigned(fValueEvent) then fValueEvent(self,sl)
  else
    if Visible then
      begin
        try
          l:=StrToInt(Text);
           sl.Add(IntToStr(l));
        except
          sl.Add('NULL');
        end;
      end
    else sl.Add('NULL');
end;

procedure TLabelInteger.SetValue(var q:TQuery);
begin
  if Assigned(fSetValueEvent) then fSetValueEvent(self,q)
  else
    Edit.Text:=IntToStr(q.FieldByName(fFieldName).AsInteger)
end;

procedure TLabelInteger.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  Edit.Top:=Lbl.Height;
  Edit.Height:=-Edit.Font.Height+10;
  Edit.Width:=Msg.LParamLo;
  Height:=Edit.Height+Lbl.Height;
  Width:=Msg.LParamLo;
end;

procedure TLabelInteger.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLabelInteger.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure TLabelInteger.WritePC(s:boolean);
begin
  Edit.ParentColor:=s
end;

function TLabelInteger.ReadPC:boolean;
begin
  ReadPC:=Edit.ParentColor
end;

procedure TLabelInteger.WriteRO(s:boolean);
begin
  Edit.ReadOnly:=s
end;

function TLabelInteger.ReadRO:boolean;
begin
  ReadRO:=Edit.ReadOnly
end;

procedure TLabelInteger.WriteML(s:integer);
begin
  Edit.MaxLength:=s
end;

function TLabelInteger.ReadML:integer;
begin
  ReadML:=Edit.MaxLength
end;

procedure TLabelInteger.WriteText(s:String);
begin
  Edit.Text:=s
end;

function TLabelInteger.ReadText:String;
begin
  ReadText:=Edit.Text
end;

procedure TLabelInteger.WriteOnChange(s:TNotifyEvent);
begin
  Edit.OnChange:=s
end;

function TLabelInteger.ReadOnChange:TNotifyEvent;
begin
  ReadOnChange:=Edit.OnChange
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TLabelInteger])
end;

procedure TLabelInteger.LEOnExit(Sender:TObject);
begin
  try
    StrToInt(Edit.Text);
  except
    Edit.Text:=PrevValue
  end
end;

procedure TLabelInteger.EditOnKeyUp(Sender: TObject; var Key: Word;
 Shift: TShiftState);
begin
  if key=VK_ESCAPE then
    Edit.Text:=PrevValue
end;

procedure TLabelInteger.EditOnEnter(Sender: TObject);
begin
  Edit.SetFocus;
  PrevValue:=Edit.Text
end;

function TLabelInteger.AsInteger:longint;
begin
  try
    AsInteger:=StrToInt(Edit.Text)
  except
    AsInteger:=0
  end;
end;

procedure TLabelInteger.EditOnClick(Sender: TObject);
var l:longint;
begin
  Edit.SelStart:=0;
  Edit.SelLength:=0;
end;

end.
