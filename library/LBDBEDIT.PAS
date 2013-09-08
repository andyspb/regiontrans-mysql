unit Lbdbedit;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,DBCtrls,DB;

Type TLabelDBEdit=class(TWinControl)
      protected
        BackUp:String;
        procedure WriteCaption(s:string);
        Function ReadCaption:String;
        procedure WriteDS(s:TDataSource);
        Function ReadDS:TDataSource;
        procedure WriteDF(s:string);
        Function ReadDF:string;
        procedure LEOnEnter(Sender:TObject);
        procedure LEOnKeyUp(Sender: TObject; var Key: Word;
                              Shift: TShiftState);
      public
        Lbl:TLabel;
        Edit:TDBEdit;
        constructor Create(AOwner:TComponent); override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
        function GetHeight:integer;
      published
        property Caption:String read ReadCaption write WriteCaption;
        property DataSource:TDataSource read ReadDS write WriteDS;
        property DataField:string read ReadDF write WriteDF;
end;

Type TLabelDBMemo=class(TWinControl)
      protected
        BackUp:TStringList;
        procedure WriteCaption(s:string);
        Function ReadCaption:String;
        procedure WriteDS(s:TDataSource);
        Function ReadDS:TDataSource;
        procedure WriteDF(s:string);
        Function ReadDF:string;
        procedure MemoOnEnter(Sender:TObject);
        procedure MemoOnKeyUp(Sender: TObject; var Key: Word;
                              Shift: TShiftState);
      public
        Lbl:TLabel;
        Memo:TDBMemo;
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
        function GetHeight:integer;
      published
        property Caption:String read ReadCaption write WriteCaption;
        property DataSource:TDataSource read ReadDS write WriteDS;
        property DataField:string read ReadDF write WriteDF;
end;

procedure Register;

implementation
Uses WinTypes;

function TLabelDBEdit.GetHeight:integer;
begin
  GetHeight:=-Lbl.Font.Height+13-Edit.Font.Height
end;

constructor TLabelDBEdit.Create(AOwner:TComponent);
begin
  inherited create(AOwner);
  Lbl:=TLabel.Create(self);
  Edit:=TDBEdit.Create(self);
  Lbl.Parent:=self;
  Edit.Parent:=self;
  Lbl.Left:=0;
  Lbl.Top:=0;
  Edit.Left:=0;
  Edit.OnEnter:=LEOnEnter;
  Edit.OnKeyUp:=LEOnKeyUp
end;

procedure TLabelDBEdit.LEOnEnter(Sender:TObject);
begin
  Edit.SetFocus;
  BackUp:=Edit.Text
end;

procedure TLabelDBEdit.LEOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then
    Edit.Text:=BackUp
end;

procedure TLabelDBEdit.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  Edit.Top:=Lbl.Height;
  Edit.Height:=-Edit.Font.Height+10;
  Edit.Width:=Msg.LParamLo;
  Height:=Edit.Height+Lbl.Height+1;
  Width:=Msg.LParamLo;
end;

procedure TLabelDBEdit.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLabelDBEdit.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure TLabelDBEdit.WriteDS(s:TDataSource);
begin
  Edit.DataSource:=s
end;

function TLabelDBEdit.ReadDS:TDataSource;
begin
  ReadDS:=Edit.DataSource
end;

procedure TLabelDBEdit.WriteDF(s:string);
begin
  Edit.DataField:=s
end;

function TLabelDBEdit.ReadDF:string;
begin
  ReadDF:=Edit.DataField
end;

function TLabelDBMemo.GetHeight:integer;
begin
  GetHeight:=-Lbl.Font.Height+13-Memo.Font.Height
end;

destructor TLabelDBMemo.Destroy;
begin
  Lbl.Free;
  Memo.Free;
  BackUp.Free;
  inherited Destroy
end;

constructor TLabelDBMemo.Create(AOwner:TComponent);
begin
  inherited create(AOwner);
  Lbl:=TLabel.Create(self);
  Memo:=TDBMemo.Create(self);
  BackUp:=TStringList.Create;
  Memo.OnEnter:=MemoOnEnter;
  Memo.OnKeyUp:=MemoOnKeyUp;
  Lbl.Parent:=self;
  Memo.Parent:=self;
  Lbl.Left:=0;
  Lbl.Top:=0;
  Memo.Left:=0
end;

procedure TLabelDBMemo.MemoOnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then begin
    Memo.Clear;
    Memo.Lines.AddStrings(BackUp)
  end
end;

procedure TLabelDBMemo.MemoOnEnter(Sender:TObject);
begin
  Memo.SetFocus;
  BackUp.Clear;
  BackUp.AddStrings(Memo.Lines)
end;

procedure TLabelDBMemo.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  Memo.Top:=Lbl.Height;
  Memo.Height:=Msg.LParamHi-Memo.Top;
  Memo.Width:=Msg.LParamLo;
  Height:=Msg.LParamHi;
  Width:=Msg.LParamLo;
end;

procedure TLabelDBMemo.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLabelDBMemo.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure TLabelDBMemo.WriteDS(s:TDataSource);
begin
  Memo.DataSource:=s
end;

function TLabelDBMemo.ReadDS:TDataSource;
begin
  ReadDS:=Memo.DataSource
end;

procedure TLabelDBMemo.WriteDF(s:string);
begin
  Memo.DataField:=s
end;

function TLabelDBMemo.ReadDF:string;
begin
  ReadDF:=Memo.DataField
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TLabelDBEdit]);
  RegisterComponents('MyOwn',[TLabelDBMemo])
end;

end.
