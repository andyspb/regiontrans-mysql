unit Lbllist;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,SQLCtrls,DBTables,TSQLCls;

Type TLabelListbox=class(TSQLControl)
      protected
        BackUp:Integer;
        procedure WriteCaption(s:string);
        Function ReadCaption:String;
        procedure WriteOnClick(s:TNotifyEvent);
        Function ReadOnClick:TNotifyEvent;
        procedure WriteOnDBlClick(s:TNotifyEvent);
        Function ReadOnDblClick:TNotifyEvent;
        procedure LLBOnKeyUp(Sender: TObject; var Key: Word;
                                      Shift: TShiftState);
        procedure LLBOnEnter(Sender: TObject);
      public
        Lbl:TLabel;
        ListBox:TListBox;
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;
        procedure Value(sl:TStringList); override;
        procedure SetValue(var q:TQuery); override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
      published
        property Caption:String read ReadCaption write WriteCaption;
        property OnClick:TNotifyEvent read ReadOnClick write WriteOnClick;
        property OnDblClick:TNotifyEvent read ReadOnDblClick write WriteOnDblClick;
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

procedure TLabelListBox.Value(sl:TStringList);
begin
  if Assigned(fValueEvent) then fValueEvent(self,sl)
  else
    if (not Visible) or (Listbox.ItemIndex=-1) then
      sl.Add('NULL')
    else
      sl.Add(sql.MakeStr(Listbox.Items[Listbox.ItemIndex]));
end;

procedure TLabelListBox.SetValue(var q:TQuery);
begin
  if Assigned(fSetValueEvent) then fSetValueEvent(self,q)
  else
    Listbox.ItemIndex:=Listbox.Items.IndexOf(q.FieldByName(fFieldName).AsString);
end;

destructor TLabelListBox.Destroy;
begin
  Lbl.Free;
  ListBox.Free;
  inherited Destroy;
end;

constructor TLabelListBox.Create(AOwner:TComponent);
begin
  inherited create(AOwner);
  Lbl:=TLabel.Create(self);
  ListBox:=TListBox.Create(self);
  Lbl.Parent:=self;
  ListBox.Parent:=self;
  Lbl.Left:=0;
  Lbl.Top:=0;
  ListBox.Left:=0;
  ListBox.OnKeyUp:=LLBOnKeyUp;
  ListBox.OnEnter:=LLBOnEnter
end;

procedure TLabelListBox.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  ListBox.Top:=Lbl.Height;
  ListBox.Height:=Msg.LParamHi-ListBox.Top;
  ListBox.Width:=Msg.LParamLo;
end;

procedure TLabelListBox.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLabelListBox.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure TLabelListBox.WriteOnClick(s:TNotifyEvent);
begin
  ListBox.OnClick:=s
end;

function TLabelListBox.ReadOnClick:TNotifyEvent;
begin
  ReadOnClick:=ListBox.OnClick
end;

procedure TLabelListBox.WriteOnDblClick(s:TNotifyEvent);
begin
  ListBox.OnDblClick:=s
end;

function TLabelListBox.ReadOnDblClick:TNotifyEvent;
begin
  ReadOnDblClick:=ListBox.OnDblClick
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TLabelListBox])
end;

procedure TLabelListBox.LLBOnEnter(Sender:TObject);
begin
  ListBox.SetFocus;
  BackUp:=ListBox.ItemIndex
end;

procedure TLabelListBox.LLBOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then
    ListBox.ItemIndex:=BackUp
end;


end.
