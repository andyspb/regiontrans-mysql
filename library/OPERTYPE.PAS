unit OperType;

interface

Uses Classes,SysUtils,TSQLCls;

Type TName=string[128];

Type TGUIObject=class(TObject)
     public
       DisplayLabel : TName;
       PhysicalName : TName;
     end;

Type TGUILogicOperation=class(TGUIObject)
     public
       DisplayLabel : TName;
       PhysicalName : TName;
       constructor Create(dPhysicalName,dDisplayLabel:TName);
     end;

{==================== Field Type ====================}

Type TGUIFieldType=class(TGUIObject)
     public
       procedure GetOpers(var sl:TStringList); virtual;
       function  ValueToStr(Value:string):string; virtual;
       function  CheckValue(Value:string):boolean; virtual;
       function  DefaultValue:string; virtual;
       function GetField(FieldName:TName):string; virtual;
     end;

Type TGUIInteger=class(TGUIFieldType)
       constructor Create;
       function  CheckValue(Value:string):boolean; override;
       function  DefaultValue:string; override;
     end;

Type TGUIString=class(TGUIFieldType)
       constructor Create;
       procedure GetOpers(var sl:TStringList); override;
       function  ValueToStr(Value:string):string; override;
       function GetField(FieldName:TName):string; override;
     end;

Type TGUIDate=class(TGUIFieldType)
       constructor Create;
       function  CheckValue(Value:string):boolean; override;
       function  ValueToStr(Value:string):string; override;
       function  DefaultValue:string; override;
     end;

Type TGUITime=class(TGUIFieldType)
       constructor Create;
       function  CheckValue(Value:string):boolean; override;
       function  ValueToStr(Value:string):string; override;
       function  DefaultValue:string; override;
     end;

Type TGUIMultiString=class(TGUIString)
       constructor Create;
       procedure GetOpers(var sl:TStringList); override;
     end;

Type TGUIFloat=class(TGUIFieldType)
       constructor Create;
       function  CheckValue(Value:string):boolean; override;
       function  DefaultValue:string; override;
     end;

{==================== Operations ====================}

Type TGUIOperation=class(TGUIObject)
      public
        function OperToStr(LeftField:TName;LeftFieldType:TGUIFieldType;Value:string;
                           RightField:TName;SymbolCount:longint):string; virtual;
        function RightPartPresent:boolean; virtual;
        function RightPartCanBeField:boolean; virtual;
     end;

Type TGUIEqu=class(TGUIOperation)
      public
        constructor Create;
     end;

Type TGUIBelow=class(TGUIOperation)
      public
        constructor Create;
     end;

Type TGUIAbove=class(TGUIOperation)
      public
        constructor Create;
     end;

Type TGUIBelowEqu=class(TGUIOperation)
      public
        constructor Create;
     end;

Type TGUIAboveEqu=class(TGUIOperation)
      public
        constructor Create;
     end;

Type TGUINotEqu=class(TGUIOperation)
      public
        constructor Create;
     end;

Type TGUIUnaryOperation=class(TGUIOperation)
      public
        function RightPartPresent:boolean; override;
        function RightPartCanBeField:boolean; override;
     end;

Type TGUIRightPartCanNotBeField=class(TGUIOperation)
      public
        function RightPartPresent:boolean; override;
        function RightPartCanBeField:boolean; override;
     end;

Type TGUIIsNull=class(TGUIUnaryOperation)
      public
        constructor Create;
     end;

Type TGUIIsNotNull=class(TGUIUnaryOperation)
      public
        constructor Create;
     end;

Type TGUIBegin=class(TGUIRightPartCanNotBeField)
      public
        constructor Create;
        function OperToStr(LeftField:TName;LeftFieldType:TGUIFieldType;Value:string;
                           RightField:TName;SymbolCount:longint):string; override;
     end;

Type TGUISubStr=class(TGUIRightPartCanNotBeField)
      public
        constructor Create;
        function OperToStr(LeftField:TName;LeftFieldType:TGUIFieldType;Value:string;
                           RightField:TName;SymbolCount:longint):string; override;
     end;

Procedure CreateOpers;
Procedure DestroyOpers;
function  LogOperByLabel(lb:string):TGUILogicOperation;
function  RelOperByLabel(lb:string):TGUIOperation;
function LTrim(s:string):string;

Const OpersCount=10;
      LogOpersCount=2;
      FieldsTypesCount=6;
      MainOpers=2;
      NullOpers=8;
Var
    RequestsCount : integer;
    LogOpers      : array [0..LogOpersCount-1] of TGUILogicOperation;
    Opers         : array [0..OpersCount-1] of TGUIOperation;
    FieldsTypes   : array [0..FieldsTypesCount-1] of TGUIFieldType;

implementation

constructor TGUILogicOperation.Create(dPhysicalName,dDisplayLabel:TName);
begin
  PhysicalName:=dPhysicalName;
  DisplayLabel:=dDisplayLabel
end;

{=================== Fields Types ===================}

procedure TGUIFieldType.GetOpers(var sl:TStringList);
var i:integer;
begin
  for i:=MainOpers to OpersCount-1 do
    sl.AddObject(Opers[i].DisplayLabel,Opers[i]);
end;

function TGUIFieldType.ValueToStr(Value:string):string;
begin
  ValueToStr:=Value;
end;

function TGUIFieldType.CheckValue(Value:string):boolean;
begin
  CheckValue:=TRUE;
end;

function TGUIFieldType.DefaultValue:string;
begin
  DefaultValue:='';
end;

function TGUIFieldType.GetField(FieldName:TName):string;
begin
  GetField:=sql.Keyword(FieldName);
end;

constructor TGUIInteger.Create;
begin
  DisplayLabel:='целое';
  PhysicalName:='INTEGER'
end;

function TGUIInteger.CheckValue(Value:string):boolean;
begin
  try
    StrToInt(Value);
    CheckValue:=TRUE;
  except
    CheckValue:=FALSE;
  end;
end;

function TGUIInteger.DefaultValue:string;
begin
  DefaultValue:='0';
end;

constructor TGUIFloat.Create;
begin
  DisplayLabel:='дробное';
  PhysicalName:='Float'
end;

function TGUIFloat.CheckValue(Value:string):boolean;
begin
  try
    StrToFloat(Value);
    CheckValue:=TRUE;
  except
    CheckValue:=FALSE;
  end;
end;

function TGUIFloat.DefaultValue:string;
begin
  DefaultValue:='0.0';
end;

constructor TGUIString.Create;
begin
  DisplayLabel:='строка';
  PhysicalName:='CHAR'
end;

procedure TGUIString.GetOpers(var sl:TStringList);
var i:integer;
begin
  inherited GetOpers(sl);
  for i:=0 to MainOpers-1 do
    sl.AddObject(Opers[i].DisplayLabel,Opers[i]);
end;

function TGUIString.ValueToStr(Value:string):string;
begin
  ValueToStr:=sql.UpperCase(sql.MakeStr(Value));
end;

function TGUIString.GetField(FieldName:TName):string;
begin
  GetField:=sql.UpperCase(sql.Keyword(FieldName))
end;

constructor TGUIDate.Create;
begin
  DisplayLabel:='дата';
  PhysicalName:='DATE'
end;

function TGUIDate.CheckValue(Value:string):boolean;
begin
  try
    StrToDate(Value);
    CheckValue:=TRUE;
  except
    CheckValue:=FALSE;
  end;
end;

function TGUIDate.DefaultValue:string;
begin
  DefaultValue:=DateToStr(Now);
end;

function TGUIDate.ValueToStr(Value:string):string;
begin
  ValueToStr:=sql.ConvertToDate(sql.MakeStr(FormatDateTime('yyyy-mm-dd',
                 StrToDateTime(Value))));
end;

constructor TGUITime.Create;
begin
  DisplayLabel:='время';
  PhysicalName:='TIME'
end;

function TGUITime.CheckValue(Value:string):boolean;
begin
  try
    StrToTime(Value);
    CheckValue:=TRUE;
  except
    CheckValue:=FALSE;
  end;
end;

function TGUITime.DefaultValue:string;
begin
  DefaultValue:=FormatDateTime('hh:mm',Now);
end;

function TGUITime.ValueToStr(Value:string):string;
begin
  ValueToStr:=sql.TimePart(sql.MakeStr(Value));
end;

constructor TGUIMultiString.Create;
begin
  DisplayLabel:='много строк';
  PhysicalName:='TEXT'
end;

procedure TGUIMultiString.GetOpers(var sl:TStringList);
var i:integer;
begin
  for i:=0 to MainOpers-1 do
    sl.AddObject(Opers[i].DisplayLabel,Opers[i]);
  for i:=NullOpers to OpersCount-1 do
    sl.AddObject(Opers[i].DisplayLabel,Opers[i]);
end;

{=================== Operations ===================}

function TGUIOperation.RightPartPresent:boolean;
begin
  RightPartPresent:=TRUE;
end;

function TGUIOperation.RightPartCanBeField:boolean;
begin
  RightPartCanBeField:=TRUE;
end;

function TGUIUnaryOperation.RightPartPresent:boolean;
begin
  RightPartPresent:=FALSE;
end;

function TGUIUnaryOperation.RightPartCanBeField:boolean;
begin
  RightPartCanBeField:=FALSE;
end;

constructor TGUIBelow.Create;
begin
  DisplayLabel:='<';
  PhysicalName:='<'
end;

constructor TGUINotEqu.Create;
begin
  DisplayLabel:='<>';
  PhysicalName:='<>'
end;

constructor TGUIEqu.Create;
begin
  DisplayLabel:='=';
  PhysicalName:='='
end;

constructor TGUIBelowEqu.Create;
begin
  DisplayLabel:='<=';
  PhysicalName:='<=';
end;

constructor TGUIAboveEqu.Create;
begin
  DisplayLabel:='>=';
  PhysicalName:='>=';
end;

constructor TGUIAbove.Create;
begin
  DisplayLabel:='>';
  PhysicalName:='>';
end;

constructor TGUIIsNull.Create;
begin
  DisplayLabel:='пусто';
  PhysicalName:='IS NULL';
end;

constructor TGUIIsNotNull.Create;
begin
  DisplayLabel:='не пусто';
  PhysicalName:='IS NOT NULL';
end;

function TGUIRightPartCanNotBeField.RightPartPresent:boolean;
begin
  RightPartPresent:=TRUE;
end;

function TGUIRightPartCanNotBeField.RightPartCanBeField:boolean;
begin
  RightPartCanBeField:=FALSE;
end;

constructor TGUIBegin.Create;
begin
  DisplayLabel:='|->';
  PhysicalName:='LIKE';
end;

function TGUIBegin.OperToStr(LeftField:TName;LeftFieldType:TGUIFieldType;Value:string;
                                 RightField:TName;SymbolCount:longint):string;
begin
  OperToStr:=LeftFieldType.GetField(LeftField)+' '+PhysicalName+' '+
             LeftFieldType.ValueToStr(Value+'%');
end;

constructor TGUISubStr.Create;
begin
  DisplayLabel:='[ ]';
  PhysicalName:='LIKE';
end;

function TGUISubStr.OperToStr(LeftField:TName;LeftFieldType:TGUIFieldType;Value:string;
                                 RightField:TName;SymbolCount:longint):string;
begin
  OperToStr:=LeftFieldType.GetField(LeftField)+' '+PhysicalName+' '+
             LeftFieldType.ValueToStr('%'+Value+'%');
end;

function RightShiftString(s:string;SymbolCount:integer):string;
begin
  while length(s)<SymbolCount do
    s:=' '+s;
  RightShiftString:=s;
end;

function TGUIOperation.OperToStr(LeftField:TName;LeftFieldType:TGUIFieldType;Value:string;
                                 RightField:TName;SymbolCount:longint):string;
var s:string;
begin
  s:=LeftFieldType.GetField(LeftField)+' '+PhysicalName;
  if RightPartPresent then
    begin
      s:=s+' ';
      if RightField='' then
        s:=s+LeftFieldType.ValueToStr(RightShiftString(Value,SymbolCount))
      else
        s:=s+LeftFieldType.GetField(RightField)
    end;
  OperToStr:=s
end;

Procedure CreateOpers;
begin
  if RequestsCount=0 then
    begin
      LogOpers[0]:=TGUILogicOperation.Create('AND','И');
      LogOpers[1]:=TGUILogicOperation.Create('OR','ИЛИ');
      Opers[0]:=TGUIBegin.Create;
      Opers[1]:=TGUISubStr.Create;
      Opers[2]:=TGUIEqu.Create;
      Opers[3]:=TGUIBelow.Create;
      Opers[4]:=TGUIAbove.Create;
      Opers[5]:=TGUIBelowEqu.Create;
      Opers[6]:=TGUIAboveEqu.Create;
      Opers[7]:=TGUINotEqu.Create;
      Opers[8]:=TGUIIsNull.Create;
      Opers[9]:=TGUIIsNotNull.Create;
      FieldsTypes[0]:=TGUIInteger.Create;
      FieldsTypes[1]:=TGUIString.Create;
      FieldsTypes[2]:=TGUIDate.Create;
      FieldsTypes[3]:=TGUITime.Create;
      FieldsTypes[4]:=TGUIMultiString.Create;
      FieldsTypes[5]:=TGUIFloat.Create;
    end;
  inc(RequestsCount);
end;

Procedure DestroyOpers;
var i: integer;
begin
  if RequestsCount<>0 then
    begin
      dec(RequestsCount);
      if RequestsCount=0 then
        begin
          for i:=0 to LogOpersCount-1 do
            LogOpers[i].Free;
          for i:=0 to OpersCount-1 do
            Opers[i].Free;
          for i:=0 to FieldsTypesCount-1 do
            FieldsTypes[i].Free;
        end
    end;
end;

function  RelOperByLabel(lb:string):TGUIOperation;
var i:integer;
begin
  RelOperByLabel:=NIL;
  for i:=0 to OpersCount-1 do
    if Opers[i].DisplayLabel=lb then
      begin
        RelOperByLabel:=Opers[i];
        break;
      end;
end;

function  LogOperByLabel(lb:string):TGUILogicOperation;
var i:integer;
begin
  LogOperByLabel:=NIL;
  for i:=0 to OpersCount-1 do
    if LogOpers[i].DisplayLabel=lb then
      begin
        LogOperByLabel:=LogOpers[i];
        break;
      end;
end;

function LTrim(s:string):string;
var i,k:integer;
begin
  for i:=1 to length(s) do
    if s[i]<>' ' then
      begin
        k:=i;
        break;
      end;
  Delete(s,1,k-1);
  LTrim:=s
end;

begin
  RequestsCount:=0;
end.
