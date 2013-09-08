unit LblEdtTm;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,EditTime;

Type TLabelEditTime=class(TWinControl)
      protected
        BackUp:String;
        procedure WriteCaption(s:string);
        Function ReadCaption:String;
        procedure EditOnKeyUp(Sender: TObject; var Key: Word;
                                      Shift: TShiftState);
        procedure EditOnEnter(Sender: TObject);
      public
        Data:longint;
        Lbl:TLabel;
        EditTime:TEditTime;
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
      published
        property Caption:String read ReadCaption write WriteCaption;
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

destructor TLabelEditTime.Destroy;
begin
  Lbl.Free;
  EditTime.Free;
  inherited Destroy
end;

constructor TLabelEditTime.Create(AOwner:TComponent);
begin
  inherited create(AOwner);
  Lbl:=TLabel.Create(self);
  EditTime:=TEditTime.Create(self);
  Lbl.Parent:=self;
  EditTime.Parent:=self;
  Lbl.Left:=0;
  Lbl.Top:=0;
  EditTime.Left:=0;
  EditTime.OnKeyUp:=EditOnKeyUp;
  EditTime.OnEnter:=EditOnEnter
end;

procedure TLabelEditTime.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  EditTime.Top:=Lbl.Height;
  EditTime.Height:=-EditTime.Font.Height+10;
  EditTime.Width:=Msg.LParamLo;
  Height:=EditTime.Height+Lbl.Height;
  Width:=Msg.LParamLo
end;

procedure TLabelEditTime.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLabelEditTime.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TLabelEditTime])
end;

procedure TLabelEditTime.EditOnKeyUp(Sender: TObject; var Key: Word;
 Shift: TShiftState);
begin
  if key=VK_ESCAPE then
    EditTime.Text:=BackUp
end;

procedure TLabelEditTime.EditOnEnter(Sender: TObject);
begin
  EditTime.SetFocus;
  BackUp:=EditTime.Text
end;

end.
