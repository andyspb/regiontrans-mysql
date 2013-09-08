unit LblCombo;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,SQLCtrls,DBTables,TSQLCls;

Type TLabelComboBox=class(TSQLControl)
      protected
        BackUp:Integer;
        procedure WriteCaption(s:string);
        Function ReadCaption:String;
        procedure WriteOnChange(s:TNotifyEvent);
        Function ReadOnChange:TNotifyEvent;

      public
        Data:longint;
        Lbl:TLabel;
        ComboBox:TComboBox;
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;
        procedure Value(sl:TStringList); override;
        procedure SetValue(var q:TQuery); override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
        function  GetHeight:integer;
        procedure CBOnEnter(Sender:TObject);
        procedure CBOnKeyUp(Sender: TObject; var Key: Word;
                              Shift: TShiftState);
      published
        property Caption:String read ReadCaption write WriteCaption;
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
uses WinTypes;

function TLabelComboBox.GetHeight:integer;
begin
  GetHeight:=-Lbl.Font.Height+13-ComboBox.Font.Height
end;

procedure TLabelCombobox.Value(sl:TStringList);
begin
  if Assigned(fValueEvent) then fValueEvent(self,sl)
  else
    if Visible then sl.Add(sql.MakeStr(Combobox.Text))
    else sl.Add('NULL');
end;

procedure TLabelCombobox.SetValue(var q:TQuery);
var s:string;
begin
  if Assigned(fSetValueEvent) then fSetValueEvent(self,q)
  else
    begin
      s:=q.FieldByName(fFieldName).AsString;
      Combobox.ItemIndex:=Combobox.Items.IndexOf(s);
      Combobox.Text:=s
    end;
end;

destructor TLabelComboBox.Destroy;
begin
  Lbl.Free;
  ComboBox.Free;
  inherited Destroy;
end;

constructor TLabelComboBox.Create(AOwner:TComponent);
begin
  inherited create(AOwner);
  Lbl:=TLabel.Create(self);
  ComboBox:=TComboBox.Create(self);
  ComboBox.Style:=csDropDownList;
  Lbl.Parent:=self;
  ComboBox.Parent:=self;
  Lbl.Left:=0;
  Lbl.Top:=0;
  ComboBox.Left:=0;
  ComboBox.OnEnter:=CBOnEnter;
  ComboBox.OnKeyUp:=CBOnKeyUp;
  Width:=ComboBox.Width;
end;

procedure TLabelComboBox.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  ComboBox.Top:=Lbl.Height;
  ComboBox.Height:=-ComboBox.Font.Height+10;
  ComboBox.Width:=Msg.LParamLo;
  Height:=ComboBox.Height+Lbl.Height;
  Width:=Msg.LParamLo;
end;

procedure TLabelComboBox.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLabelComboBox.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure TLabelComboBox.WriteOnChange(s:TNotifyEvent);
begin
  ComboBox.OnChange:=s
end;

function TLabelComboBox.ReadOnChange:TNotifyEvent;
begin
  ReadOnChange:=ComboBox.OnChange
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TLabelComboBox])
end;

procedure TLabelComboBox.CBOnEnter(Sender:TObject);
begin
  ComboBox.SetFocus;
  BackUp:=ComboBox.ItemIndex
end;

procedure TLabelComboBox.CBOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then
    ComboBox.ItemIndex:=BackUp
end;

end.
