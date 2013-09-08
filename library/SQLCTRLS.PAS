unit Sqlctrls;

interface
uses SysUtils,Controls,Classes,Menus,DBTables,StdCtrls;

Type TValueNotifyEvent=procedure(Sender:TObject;var sl:TStringList) of object;
Type TSetValueNotifyEvent=procedure(Sender:TObject;var q:TQuery) of object;

const DeltaX=4;
const DeltaY=4;
Type TSQLControl=class(TWinControl)
       protected
         fFieldName:string;
         fCaptionID:longint;
         fValueEvent:TValueNotifyEvent;
         fSetValueEvent:TSetValueNotifyEvent;
         procedure WriteCaptionID(l:longint);
       public
         procedure SetBoundsEx(x,y,dx,dy:integer);
         procedure SetRight(c:TControl;dx,dy:integer);
         procedure SetDown(c:TControl;dx,dy:integer);
         procedure Value(sl:TStringList); virtual;
         procedure SetValue(var q:TQuery); virtual;
         procedure GetValue(sl:TStringList;SepFlag:boolean); virtual;
         procedure SetValueF(q:TQuery;fn:string);
       published
         property Enabled;
         property Visible;
         property FieldName:string read fFieldName write fFieldName;
         property CaptionID:longint read fCaptionID write WriteCaptionID;
         property OnGetValue:TValueNotifyEvent read fValueEvent write fValueEvent;
         property OnSetValue:TSetValueNotifyEvent read fSetValueEvent write fSetValueEvent;
     end;

implementation
Uses tenvirnt,lbledit;
{===========   TSQLControl ==============}
procedure TSQLControl.SetValue(var q:TQuery);
begin
end;

procedure TSQLControl.Value(sl:TStringList);
begin
end;

procedure TSQLControl.GetValue(sl:TStringList;SepFlag:boolean);
begin
  Value(sl);
  if SepFlag then
    sl.Add(',');
end;

procedure TSQLControl.SetBoundsEx(x,y,dx,dy:integer);
begin
  if dy=-1 then
    dy:=Height;
  SetBounds(x,y,dx,dy);
end;

procedure TSQLControl.SetRight(c:TControl;dx,dy:integer);
begin
  SetBoundsEx(c.Left+c.Width+DeltaX,c.Top,dx,dy);
end;

procedure TSQLControl.SetDown(c:TControl;dx,dy:integer);
begin
  if dx=-1 then
    dx:=c.Width;
  SetBoundsEx(c.Left,c.Top+c.Height+DeltaY,dx,dy);
end;

procedure TSQLControl.SetValueF(q:TQuery;fn:string);
var oldfn:string;
begin
  oldfn:=FieldName;
  FieldName:=fn;
  SetValue(q);
  FieldName:=oldfn;
end;

procedure TSQLControl.WriteCaptionID(l:longint);
var i:longint;
    s:string;
begin
  fCaptionID:=l;
  if (Enviroment<>NIL) and (l<>0) then
    begin
  for i:=0 to ControlCount-1 do
    begin
      if Controls[i] is TLabel then
        begin
          s:=Enviroment.GetCaption(l);
          if s<>'' then
            TLabel(Controls[i]).Caption:=s+':';
        end;
      if Controls[i] is TLabelEdit then
        begin
          s:=Enviroment.GetCaption(l);
          if s<>'' then
            TLabelEdit(Controls[i]).Caption:=s+':';
        end;
    end;
    end;
end;

end.
