Unit quikview;


Interface
uses
  dbtables,forms,extctrls,DB,messages,classes,stdctrls,dbctrls,lbdbedit,guifield;

Type TQuickView=class(TPanel)
      protected
	procedure WMSize(var Msg:TMessage); message WM_SIZE;
	procedure OnScroll(Sender: TObject; ScrollCode:TScrollCode; var ScrollPos: Integer);
      public
	ScrollBar:TScrollBar;
	constructor Create(AC:TComponent); override;
	procedure vScrollBy(dy:integer);
        procedure ResizeAll;
	procedure Add(Field:TGUIField;DS:TDataSource);
        procedure Clear;
     end;

implementation

procedure TQuickView.vScrollBy(dy:integer);
var i:integer;
begin
  for i:=0 to ControlCount-1 do
    if Controls[i]<>ScrollBar then
      Controls[i].Top:=Controls[i].Top+dy
end;

procedure TQuickView.ResizeAll;
var
  i,min,max:integer;
  t:boolean;
begin
  t:=FALSE;
  ScrollBar.Left:=ClientWidth-ScrollBar.Width;
  ScrollBar.Height:=ClientHeight;
  ScrollBar.Top:=0;
  min:=-1;
  max:=-1;
  for i:=0 to ControlCount-1 do
    if Controls[i]<>ScrollBar then
    begin
      t:=TRUE;
      Controls[i].Width:=ClientWidth-10-ScrollBar.Width;
      if (min=-1) or (Controls[i].Top<min) then min:=Controls[i].Top;
      if (max=-1) or (Controls[i].Top+Controls[i].Height>max) then
	max:=Controls[i].Top+Controls[i].Height
    end;
  ScrollBar.Visible:=max-min+10-ClientHeight>0;
  if ScrollBar.Visible and (min<>-1) then
    ScrollBar.Max:=max-min+10-ClientHeight;
  if ScrollBar.Visible=False then
   for i:=0 to ControlCount-1 do
    if Controls[i]<>ScrollBar then
	Controls[i].Width:=Controls[i].Width + 16;
  Visible:=t;
end;

procedure TQuickView.Clear;
var i:integer;
begin
  i:=0;
  ScrollBar.Position:=0;
  while i<ControlCount do
    if Controls[i]<>ScrollBar then
      begin
        if Controls[i] is TLabelDBMemo then TLabelDBMemo(Controls[i]).Free
        else
          if Controls[i] is TLabelDBEdit then TLabelDBEdit(Controls[i]).Free 
          else inc(i);
      end
    else
      inc(i);
  Visible:=FALSE; 
end;

procedure TQuickView.OnScroll(Sender: TObject; ScrollCode:TScrollCode; var ScrollPos: Integer);
var dy:integer;
begin
  dy:=0;
  case ScrollCode of
    scLineUp:    dy:=-5;
    scLineDown:  dy:=5;
    scPageUp:    dy:=-25;
    scPageDown:  dy:=25;
    scTrack:     dy:=(ScrollPos-ScrollBar.Position);
  end;

  if ScrollBar.Position+dy>ScrollBar.Max then dy:=ScrollBar.Max-ScrollBar.Position
  else
    if ScrollBar.Position+dy<0 then dy:=-ScrollBar.Position;
  vScrollBy(-dy);
  ScrollPos:=ScrollBar.Position+dy
end;

procedure TQuickView.WMSize(var Msg:TMessage);
begin
  ResizeAll
end;

constructor TQuickView.Create(AC:TComponent);
begin
  inherited Create(AC);
  BorderStyle:=bsSingle;
  ScrollBar:=TScrollBar.Create(self);
  ScrollBar.Parent:=self;
  ScrollBar.Kind:=sbVertical;
  ScrollBar.Visible:=FALSE;
  ScrollBar.Min:=0;
  ScrollBar.OnScroll:=OnScroll;
  Visible:=FALSE;
end;

procedure TQuickView.Add(Field:TGUIField;DS:TDataSource);
var
  DBEdit:TLabelDBEdit;
  DBMemo:TLabelDBMemo;
  y:integer;
begin
  try
    Visible:=FALSE;
    if ControlCount>1 then
      y:=Controls[ControlCount-1].Top+Controls[ControlCount-1].Height+2
    else
      y:=5;
    if  Field.ViewFieldName<>'' then
      begin
	DBMemo:=TLabelDBMemo.Create(self);
	DBMemo.Parent:=self;
        DBMemo.Caption:=Field.DisplayLabel;
	DBMEmo.DataField:=Field.ViewFieldName;
	DBMemo.DataSource:=DS;
	DBMemo.Memo.ScrollBars:=ssNone;
	DBMemo.Top:=y;
	DBMemo.Left:=5;
	DBMemo.Height:=(-DBMemo.Memo.Font.Height+3)*5;
	DBMemo.Width:=ClientWidth-10;
      end
    else
      begin
	DBEdit:=TLabelDBEdit.Create(self);
	DBEdit.Parent:=self;
        DBEdit.Caption:=Field.DisplayLabel;
	DBEdit.DataField:=Field.PhysicalName;
	DBEdit.DataSource:=DS;
	DBEdit.Top:=y;
	DBEdit.Left:=5;
	DBEdit.Width:=ClientWidth-10;
	DBEdit.Height:=DBEdit.GetHeight;
      end;
  except
  ;
  end
end;

end.