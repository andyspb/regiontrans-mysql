unit Lbsqloln;

interface
Uses SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,Menus,
     Messages,SQLOutLn,SQLCtrls,DBTables;

Type TLabelSQLOutline=class(TSQLControl)
      protected
        procedure WriteCaption(s:string);
        Function ReadCaption:String;
        procedure WriteWhere(s:string);
        Function ReadWhere:String;
        procedure WriteTable(s:string);
        Function ReadTable:String;
        procedure WriteID(s:string);
        Function ReadID:String;
        procedure WriteInfo(s:string);
        Function ReadInfo:String;
        procedure WriteParentID(s:string);
        Function ReadParentID:String;
        procedure WriteRoot(s:string);
        Function ReadRoot:String;
        procedure WriteRNP(s:boolean);
        Function ReadRNP:Boolean;
        procedure WriteOnClick(s:TNotifyEvent);
        Function ReadOnClick:TNotifyEvent;
        procedure WritePC(s:boolean);
        Function ReadPC:boolean;
      public
        Data:longint;
        Lbl:TLabel;
        SQLOutline:TSQLOutline;
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
        procedure Value(sl:TStringList); override;
        procedure SetValue(var q:TQuery); override;
      published
        property Align;
        property TabOrder;
        property TabStop;
        property Caption:String read ReadCaption write WriteCaption;
        property Table:String read ReadTable write WriteTable;
        property Where:String read ReadWhere write WriteWhere;
        property IDField:String read ReadID write WriteID;
        property InfoField:String read ReadInfo write WriteInfo;
        property ParentIDField:String read ReadParentID write WriteParentID;
        property RootName:String read ReadRoot write WriteRoot;
        property RootNoPresent:boolean read ReadRNP write WriteRNP;
        property ParentColor:Boolean read ReadPC write WritePC;
        property OnClick:TNotifyEvent read ReadOnClick write WriteOnClick;

end;

procedure Register;

implementation

destructor TLabelSQLOutline.Destroy;
begin
  Lbl.Free;
  SQLOutline.Free;
  inherited Destroy;
end;

procedure TLabelSQLOutline.Value(sl:TStringList);
var i:integer;
begin
  if Assigned(fValueEvent) then fValueEvent(self,sl)
  else
    if (not Visible) or (SQLOutline.GetData=0) then sl.Add('NULL')
    else
      sl.Add(IntToStr(SQLOutline.GetData));
end;

procedure TLabelSQLOutline.SetValue(var q:TQuery);
begin
  if Assigned(fSetValueEvent) then fSetValueEvent(self,q)
  else
    SQLOutline.SetActive(q.FieldByName(fFieldName).AsInteger);
end;

constructor TLabelSQLOutline.Create(AOwner:TComponent);
begin
  inherited create(AOwner);
  Lbl:=TLabel.Create(self);
  SQLOutline:=TSQLOutline.Create(self);
  Lbl.Parent:=self;
  SQLOutline.Parent:=self;
  Lbl.Left:=0;
  Lbl.Top:=0;
  SQLOutline.Left:=0;
end;

procedure TLabelSQLOutline.WMSize(var Msg:TMessage);
begin
  Lbl.Height:=-Lbl.Font.Height+3;
  Lbl.Width:=Msg.LParamLo;
  SQLOutline.Top:=Lbl.Height;
  SQLOutline.Height:=Msg.LParamHi-Lbl.Height;
  SQLOutline.Width:=Msg.LParamLo;
end;

procedure TLabelSQLOutline.WriteCaption(s:String);
begin
  Lbl.Caption:=s
end;

function TLabelSQLOutline.ReadCaption:String;
begin
  ReadCaption:=Lbl.Caption
end;

procedure TLabelSQLOutline.WriteWhere(s:String);
begin
  SQLOutline.Where:=s
end;

function TLabelSQLOutline.ReadWhere:String;
begin
  ReadWhere:=SQLOutline.Where
end;

procedure TLabelSQLOutline.WriteTable(s:String);
begin
  SQLOutline.Table:=s
end;

function TLabelSQLOutline.ReadTable:String;
begin
  ReadTable:=SQLOutline.Table
end;

procedure TLabelSQLOutline.WriteID(s:String);
begin
  SQLOutline.IDField:=s
end;

function TLabelSQLOutline.ReadID:String;
begin
  ReadID:=SQLOutline.IDField
end;

procedure TLabelSQLOutline.WriteInfo(s:String);
begin
  SQLOutline.InfoField:=s
end;

function TLabelSQLOutline.ReadInfo:String;
begin
  ReadInfo:=SQLOutline.InfoField
end;

procedure TLabelSQLOutline.WriteParentID(s:String);
begin
  SQLOutline.ParentIDField:=s
end;

function TLabelSQLOutline.ReadParentID:String;
begin
  ReadParentID:=SQLOutline.ParentIDField
end;

procedure TLabelSQLOutline.WritePC(s:Boolean);
begin
  SQLOutline.ParentColor:=s
end;

function TLabelSQLOutline.ReadPC:Boolean;
begin
  ReadPC:=SQLOutline.ParentColor
end;

procedure TLabelSQLOutline.WriteRoot(s:String);
begin
  SQLOutline.RootName:=s
end;

function TLabelSQLOutline.ReadRoot:String;
begin
  ReadRoot:=SQLOutline.RootName
end;

procedure TLabelSQLOutline.WriteOnClick(s:TNotifyEvent);
begin
  SQLOutline.OnClick:=s
end;

Function TLabelSQLOutline.ReadOnClick:TNotifyEvent;
begin
  ReadOnClick:=SQLOutline.OnClick
end;

Function TLabelSQLOutline.ReadRNP:Boolean;
begin
  ReadRNP:=SQLOutline.RootNoPresent;
end;

procedure TLabelSQLOutline.WriteRNP(s:boolean);
begin
  SQLOutline.RootNoPresent:=s;
  SQLOutline.Recalc(TRUE);
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TLabelSQLOutline])
end;


end.
