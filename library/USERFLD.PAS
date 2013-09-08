unit UserFld;

interface
Uses
  Classes,DB,GUIField,SysUtils;

Type TFieldDescr=class(TObject)
      private
        function BoolToStr(b:boolean):string;
        function GetNextParam(var s:string):string;
      public
        GUIField     : TGUIField;
        Field        : TField;
        Index,Width  : Integer;
        Checked,
        Sorted,
        QuickView    : Boolean;
        procedure LoadFromStr(s:string;fl:boolean);
        procedure SaveToStr(var s:string);
     end;

implementation

function TFieldDescr.GetNextParam(var s:string):string;
var i:integer;
begin
  i:=pos('|',s);
  if i<>0 then
    begin
      GetNextParam:=Copy(s,1,i-1);
      Delete(s,1,i)
    end
  else
    begin
      GetNextParam:=s;
      s:='';
    end
end;

function TFieldDescr.BoolToStr(b:boolean):string;
begin
  if b then
    BoolToStr:='TRUE'
  else
    BoolToStr:='FALSE'
end;

procedure TFieldDescr.LoadFromStr(s:string;fl:boolean);
begin
  if s<>'' then
    begin
      Index:=StrToInt(GetNextParam(s));
      Width:=StrToInt(GetNextParam(s));
      Checked:=GetNextParam(s)='TRUE';
      Sorted:=GetNextParam(s)='TRUE';
      QuickView:=GetNextParam(s)='TRUE';
    end
  else
    begin
      Index:=0;
      Width:=10;
      Checked:=not fl;
      Sorted:=FALSE;
      QuickView:=FALSE;
    end;
end;

procedure TFieldDescr.SaveToStr(var s:string);
begin
  s:=IntToStr(Index)+'|'+IntToStr(Width)+'|'+BoolToStr(Checked)+'|';
  s:=s+BoolToStr(Sorted)+'|'+BoolToStr(QuickView);
end;

end.
