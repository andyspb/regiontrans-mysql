unit TFilter;

interface

Uses Classes;

Type TName=string[128];

Type TGUIObject=class(TObject)
     public
       DisplayLabel : TName;
       PhysicalName : TName;
     end;

Type TGUIOperation=class(TGUIObject)
        function OperToStr(LeftField:TGUIField,Value:string,
                           RightField:TGUIField):string; virtual;
        function RightPartPresent:boolean;
     end;

function TGUIOperation.OperToStr(LeftField:TGUIField,Value:string,
                                 RightField:TGUIField):string;
begin
  OperToStr:=SQLKeyword(LeftField.PhysicalName)+GetPhysicalOper;
  if RightField=nil then
  else
    OperToStr:=
end;

Type TGUIEqu=class(TGUIOperation)
     end;


Type TGUIFieldType=class(TGUIObject)
     public
       procedure GetOpers(var sl:TStringList); virtual;
     end;

Type TGUIInteger=class(TGUIFieldType)
       constructor Create;
     end;

Type TGUIString=class(TGUIFieldType)
       constructor Create;
       procedure GetOpers(var sl:TStringList); virtual;
     end;

Type TGUIDate=class(TGUIFieldType)
       constructor Create;
     end;

Type TGUITime=class(TGUIFieldType)
       constructor Create;
     end;

Type TGUIMultiString=class(TGUIFieldType)
       constructor Create;
       procedure GetOpers(var sl:TStringList); virtual;
     end;

Type TGUIField=class(TGUIObject)
     public
       FieldType  : TGUIFieldType;
     end;

implementation

procedure TGUIFieldType.GetOpers(var sl:TStringList);
var i:integer;
begin
  for i=MainOper to OpersCount-1 do
    sl.AddObject(Opers[i].DisplayLabel,Opers[i]);
end;

constructor TGUIInteger.Create;
begin
  DisplayLabel:='целое';
  PhysicalName:='INTEGER'
end;

constructor TGUIString.Create;
begin
  DisplayLabel:='строка';
  PhysicalName:='CHAR'
end;

procedure TGUIFieldType.GetOpers(var sl:TStringList);
var i:integer;
begin
  inherited GetOpers(sl);
  for i=0 to MainOper-1 do
    sl.AddObject(Opers[i].DisplayLabel,Opers[i]);
end;

constructor TGUIDate.Create;
begin
  DisplayLabel:='дата';
  PhysicalName:='DATE'
end;

constructor TGUITime.Create;
begin
  DisplayLabel:='время';
  PhysicalName:='TIME'
end;

constructor TGUIMultiString.Create;
begin
  DisplayLabel:='много строк';
  PhysicalName:='TEXT'
end;

procedure TGUIFieldType.GetOpers(var sl:TStringList);
var i:integer;
begin
  for i=0 to MainOper-1 do
    sl.AddObject(Opers[i].DisplayLabel,Opers[i]);
end;

begin
end.
