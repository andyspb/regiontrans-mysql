unit LblEdtDt;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,EditDate,SQLCtrls,DBTables,TSQLCls,WinProcs;

Type TLabelEditDate=class(TSQLControl)
      protected
        BackUp,fDateFormat:string;
        procedure WriteCaption(s:string);
        Function ReadCaption:String;
        procedure WriteText(s:string);
        Function ReadText:String;
        procedure WritePC(s:boolean);
        Function ReadPC:boolean;
        procedure WriteRO(s:boolean);
        Function ReadRO:boolean;
        procedure WriteML(s:integer);
        Function ReadML:integer;
        procedure EditOnKeyUp(Sender: TObject; var Key: Word;
                                      Shift: TShiftState);
        procedure EditOnEnter(Sender: TObject);
        procedure EditOnClick(Sender: TObject);
      public
        Data:longint;
        Lbl:TLabel;
        EditDate:TEditDate;
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
        function GetHeight:integer;
        procedure Value(sl:TStringList); override;
        procedure SetValue(var q:TQuery); override;
        function GetDateTime:TDateTime;
        function OptimalWidth:integer;
      published
        property Caption:String read ReadCaption write WriteCaption;
        property DateFormat:String read fDateFormat write fDateFormat;
        property Text:String read ReadText write WriteText;
        property ParentColor:boolean read ReadPC write WritePC;
        property ReadOnly:boolean read ReadRO write WriteRO;
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

function TLabelEditDate.OptimalWidth:integer;
var dc:HDC;
    sz:TSIZE;
begin
  dc:=GetDC(EditDate.Handle);
  GetTextExtentPoint(DC,'99.99.9999',11,sz);
  ReleaseDC(EditDate.Handle,dc);
  OptimalWidth:=sz.cx
end;

function TLabelEditDate.GetHeight:integer;
begin
  GetHeight:=-EditDate.Font.Height+13-Lbl.Font.Height
end;

destructor TLabelEditDate.Destroy;
begin
  Lbl.Free;
  EditDate.Free;
  inherited Destroy;
end;

constructor TLabelEditDate.Create(AOwner:TComponent);
begin
  inherited create(AOwner);
  Lbl:=TLabel.Create(self);
  EditDate:=TEditDate.Create(self);
  Lbl.Parent:=self;
  EditDate.Parent:=self;
  DateFormat:='yyyy-mm-dd';
  Lbl.Left:=0;
  Lbl.Top:=0;
  EditDate.Left:=0;
  EditDate.OnKeyUp:=EditOnKeyUp;
  EditDate.OnEnter:=EditOnEnter;
  EditDate.OnClick:=EditonClick;
end;

procedure TLabelEditDate.Value(sl:TStringList);
begin
  if Assigned(fValueEvent) then fValueEvent(self,sl)
  else
    if (not Visible) or (Text='') or (Text='  .  .    ') then
      sl.Add('NULL')
    else
      sl.Add(sql.ConvertToDate2(sql.MakeStr(
        FormatDateTime(DateFormat,StrToDateTime(Text)))));
end;

procedure TLabelEditDate.SetValue(var q:TQuery);
begin
  if Assigned(fSetValueEvent) then fSetValueEvent(self,q)
  else
    try
      if q.FieldByName(fFieldName).IsNull then Text:='  .  .    '
      else
        Text:=DateToStr(q.FieldByName(fFieldName).AsDateTime);
    except
    end;
end;

procedure TLabelEditDate.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  EditDate.Top:=Lbl.Height;
  EditDate.Height:=-EditDate.Font.Height+10;
  EditDate.Width:=Msg.LParamLo;
  Height:=EditDate.Height+Lbl.Height;
  Width:=Msg.LParamLo;
end;

procedure TLabelEditDate.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLabelEditDate.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure TLabelEditDate.WritePC(s:boolean);
begin
  EditDate.ParentColor:=s
end;

function TLabelEditDate.ReadPC:boolean;
begin
  ReadPC:=EditDate.ParentColor
end;

procedure TLabelEditDate.WriteRO(s:boolean);
begin
  EditDate.ReadOnly:=s
end;

function TLabelEditDate.ReadRO:boolean;
begin
  ReadRO:=EditDate.ReadOnly
end;

procedure TLabelEditDate.WriteML(s:integer);
begin
  EditDate.MaxLength:=s
end;

function TLabelEditDate.ReadML:integer;
begin
  ReadML:=EditDate.MaxLength
end;

procedure TLabelEditDate.WriteText(s:String);
begin
  EditDate.Text:=s
end;

function TLabelEditDate.ReadText:String;
begin
  ReadText:=EditDate.Text
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TLabelEditDate])
end;

procedure TLabelEditDate.EditOnKeyUp(Sender: TObject; var Key: Word;
 Shift: TShiftState);
begin
  if key=VK_ESCAPE then
    EditDate.Text:=BackUp
end;

procedure TLabelEditDate.EditOnEnter(Sender: TObject);
begin
  EditDate.SetFocus;
  BackUp:=EditDate.Text
end;

procedure TLabelEditDate.EditOnClick(Sender: TObject);
begin
  if EditDate.Text='  .  .    ' then
    begin
      EditDate.SelStart:=0;
      EditDate.SelLength:=0;
    end;
end;

function TLabelEditDate.GetDateTime:TDateTime;
begin
  if (not Visible) or (Text='') or (Text='  .  .    ') then
     GetDateTime:=0
  else
    GetDateTime:=StrToDateTime(Text)
end;

end.
