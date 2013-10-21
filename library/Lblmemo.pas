unit LblMemo;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,SQLCtrls,DBTables,TSQLCls,DB,WinTypes,WinProcs,tmsql;

Type TLabelMemo=class(TSQLControl)
       protected
         BackUp:TStringList;
         TextBuf:array[0..4096] of char;
       procedure WriteCaption(s:string);
        Function ReadCaption:String;
        procedure WritePC(s:boolean);
        Function ReadPC:boolean;
        procedure WriteRO(s:boolean);
        Function ReadRO:boolean;
        procedure WriteML(s:integer);
        Function ReadML:integer;
        procedure WriteOC(s:TNotifyEvent);
        Function ReadOC:TNotifyEvent;
        procedure WriteODC(s:TNotifyEvent);
        Function ReadODC:TNotifyEvent;
        procedure MemoOnKeyUp(Sender: TObject; var Key: Word;
                                      Shift: TShiftState);
        procedure MemoOnEnter(Sender: TObject);
      public
        Data:longint;
        ID:longint;
        Memo:TMemo;
        Lbl:TLabel;
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
        procedure Value(sl:TStringList); override;
        procedure SetValue(var q:TQuery); override;
        function GetTextBuf:PChar;
        function GetCurLine:longint;
      published
        property Caption:String read ReadCaption write WriteCaption;
        property ParentColor:boolean read ReadPC write WritePC;
        property ReadOnly:boolean read ReadRO write WriteRO;
        property MaxLength:integer read ReadML write WriteML;
        property OnChange:TNotifyEvent read ReadOC write WriteOC;
        property OnDblClick:TNotifyEvent read ReadODC write WriteODC;
    {    property TabOrder:integer read ReadTabOrder write WriteTabOrder;
    }
        property Align;
        property DragCursor;
        property DragMode;
        property Enabled;
        property ParentShowHint;
        property PopupMenu;
        property ShowHint;
        property TabStop;
        property TabOrder;
        property Visible;
        property OnDragDrop;
        property OnDragOver;
        property OnEndDrag;
        property OnEnter;
        property OnExit;
end;

procedure Register;

implementation

destructor TLabelMemo.Destroy;
begin
  Lbl.Free;
  Memo.Free;
  BackUp.Free;
  inherited Destroy
end;

constructor TLabelMemo.Create(AOwner:TComponent);
begin
  inherited create(AOwner);
  Memo:=TMemo.Create(self);
  Lbl:=TLabel.Create(self);
  BackUp:=TStringList.Create;
  Lbl.Parent:=self;
  Memo.Parent:=self;
  Lbl.Left:=0;
  Lbl.Top:=0;
  Memo.Left:=0;
  Memo.OnKeyUp:=MemoOnKeyUp;
  OnEnter:=MemoOnEnter;
  ID:=0;
end;

procedure TLabelMemo.Value(sl:TStringList);
begin
  if Assigned(fValueEvent) then
    fValueEvent(self,sl)
  else
    if not Visible then
      sl.Add('NULL')
    else
      sql.MultiString(sl,GetTextBuf);
end;

procedure TLabelMemo.SetValue(var q:TQuery);
Var f:TField;
    s:TMemoryStream;
    t:integer;
BEGIN
  if Assigned(fSetValueEvent) then fSetValueEvent(self,q)
  else
    begin
      f:=q.FieldByName(FieldName);
      if f is TMemoField then
        begin
          s:=TMemoryStream.Create;
          TMemoField(f).SaveToStream(s);
          t:=0;
          s.Write(t,1);
          t:=StrLen(s.Memory)-1;
          while t>=0 do
            begin
              if PChar(Longint(s.Memory)+t)^<>' ' then break;
              dec(t);
            end;
          PChar(Longint(s.Memory)+t+1)^:=#0;
          Memo.SetTextBuf(s.Memory);
          s.Free
        end
      else
        begin
          Memo.Lines.Clear;
          Memo.Lines.Add(f.AsString);
        end
    end
end;

procedure TLabelMemo.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  Memo.Top:=Lbl.Height;
  Memo.Height:=Msg.LParamHi-Lbl.Height;
  Memo.Width:=Msg.LParamLo;
end;

procedure TLabelMemo.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLabelMemo.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure TLabelMemo.WritePC(s:boolean);
begin
  Memo.ParentColor:=s
end;

function TLabelMemo.ReadPC:boolean;
begin
  ReadPC:=Memo.ParentColor
end;

procedure TLabelMemo.WriteOC(s:TNotifyEvent);
begin
  Memo.OnChange:=s
end;

function TLabelMemo.ReadOC:TNotifyEvent;
begin
  ReadOC:=Memo.OnChange
end;

procedure TLabelMemo.WriteODC(s:TNotifyEvent);
begin
  Memo.OnDblClick:=s
end;

function TLabelMemo.ReadODC:TNotifyEvent;
begin
  ReadODC:=Memo.OnDblClick
end;

procedure TLabelMemo.WriteRO(s:boolean);
begin
  Memo.ReadOnly:=s
end;

function TLabelMemo.ReadRO:boolean;
begin
  ReadRO:=Memo.ReadOnly
end;

procedure TLabelMemo.WriteML(s:integer);
begin
  if sql is TMicrosoftSQL and (s>255) then
    s:=255;
  Memo.MaxLength:=s
end;

function TLabelMemo.ReadML:integer;
begin
  ReadML:=Memo.MaxLength
end;

procedure TLabelMemo.MemoOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then begin
    Memo.Clear;
    Memo.Lines.AddStrings(BackUp)
  end
end;

procedure TLabelMemo.MemoOnEnter(Sender: TObject);
begin
  Memo.SetFocus;
  BackUp.Clear;
  BackUp.AddStrings(Memo.Lines)
end;

function TLabelMemo.GetTextBuf:PChar;
begin
  Memo.GetTextBuf(TextBuf,4096);
  GetTextBuf:=TextBuf
end;

function TLabelMemo.GetCurLine:longint;
begin
  GetCurLine:=SendMessage(Memo.Handle,EM_LINEFROMCHAR,Word(-1),0);
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TLabelMemo])
end;

end.
