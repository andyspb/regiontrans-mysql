unit Ldmenus;

interface
Uses Forms,Menus,BmpBtn,classes,Controls;

type
TMenuButtonItem = class (TMenuItem)
  protected
   fButtonCaption:string;
   fButtonBMP:string;
   procedure WriteVisible(v:boolean);
   procedure WriteEnabled(v:boolean);
   procedure WriteButtonCaption(v:string);
   procedure WriteButtonBMP(v:string);
   procedure WriteHint(v:string);
   procedure WriteOnClick(v:TNotifyEvent);
   procedure WriteButtonPresent(v:boolean);

   function  ReadVisible:boolean;
   function  ReadEnabled:boolean;
   function  ReadButtonCaption:string;
   function  ReadButtonBMP:string;
   function  ReadHint:string;
   function  ReadButtonPresent:boolean;
  public
   Button:TBmpBtn;
   constructor Create(AC:TComponent);override;
   destructor Destroy;override;
  published
   property ButtonPresent:boolean Read ReadButtonPresent Write WriteButtonPresent;
   property ButtonCaption:string read fButtonCaption Write WriteButtonCaption;
   property ButtonBMP:string Read ReadButtonBMP Write WriteButtonBMP;

   property Visible:boolean Read ReadVisible Write WriteVisible;
   property Enabled:boolean Read ReadEnabled Write WriteEnabled;
   property OnClick:TNotifyEvent Write WriteOnClick;
   property Hint:string Read ReadHint Write WriteHint;
end;

procedure Register;

implementation
constructor TMenuButtonItem.Create(AC:TComponent);
var i:integer;
begin
  inherited Create(AC);
  Button:=NIL;
  fButtonCaption:='';
  fButtonBMP:='';
end;
destructor TMenuButtonItem.Destroy;
begin
{  if Button<>NIL then
    Button.free;}
  inherited destroy;
end;
{-------------------------Read----------------------}
function TMenuButtonItem.ReadButtonPresent:boolean;
begin
  if Button<>nil then ReadButtonPresent:=Button.Visible
    else ReadButtonPresent:=false;
end;
function TMenuButtonItem.ReadVisible:boolean;
begin
  ReadVisible:=inherited Visible;
end;
function TMenuButtonItem.ReadEnabled:boolean;
begin
  ReadEnabled:=inherited Enabled;
end;
function TMenuButtonItem.ReadButtonBMP:string;
begin
  if Button<>nil then ReadButtonBMP:=Button.FileName
     else ReadButtonBMP:='';
end;
function TMenuButtonItem.ReadHint:string;
begin
  ReadHint:=inherited hint;
end;
function TMenuButtonItem.ReadButtonCaption:string;
begin
  ButtonCaption:=Button.FileName;
end;
{-------------------------Write----------------------}
procedure TMenuButtonItem.WriteVisible(v:boolean);
begin
 inherited visible:=v;
 if Button<>NIL then
   Button.Visible:=v;
end;
procedure TMenuButtonItem.WriteEnabled(v:boolean);
begin
 inherited Enabled:=v;
 if Button<>NIL then
   Button.Enabled:=v;
end;
procedure TMenuButtonItem.WriteButtonPresent(v:boolean);
begin
  if v then
    begin
      Button:=TBmpBtn.Create(self);
      Button.Parent:=TWinControl(Owner);
      Button.Visible:=v;
      Button.ToolbarButton:=TRUE;
      Button.Caption:=fButtonCaption;
      Button.FileName:=fButtonBMP;
      Button.NumGlyphs:=3;
      Button.Hint:=Hint;
    end
  else
    begin
      if Button<>NIL then Button.Free;
      Button:=NIL
    end
end;
procedure TMenuButtonItem.WriteButtonCaption(v:string);
begin
 fButtonCaption:=v;
 if Button<>NIL then
   Button.Caption:=v;
end;
procedure TMenuButtonItem.WriteButtonBMP(v:string);
begin
 fButtonBMP:=v;
 if Button<>NIL then Button.FileName:=v;
end;
procedure TMenuButtonItem.WriteHint(v:string);
begin
 inherited hint:=v;
 if Button<>NIL then
   Button.Hint:=v;
end;
procedure TMenuButtonItem.WriteOnClick(v:TNotifyEvent);
begin
 inherited OnClick:=v;
 if Button<>NIL then
   Button.OnClick:=v;
end;
{-------------------------End Read/write properties-------------}
procedure Register;
{---------------------}
begin
  RegisterComponents('MenuButtonItem', [TMenuButtonItem]);
end;
end.
