unit Parmlist;

interface

uses SysUtils,Classes;
const DS_SUCCESS=0;

type
TDSParameter=class(TStringList)
protected
  function GetParam(ind:integer):string;
  function GetValue(ind:integer):string;
public
  FindFlag:boolean;
  function ParamByName(ParamName:string):integer;
  function StrByName(ParamName:string):string;
  function IntByName(ParamName:string):longint;
  function BoolByName(ParamName:string):boolean;
  procedure AddParamStr(ParamName,Value:string);
  procedure AddParamInt(ParamName:string;Value:longint);
  procedure AddParamBool(ParamName:string;Value:boolean);
  property Params[Index:integer]:string read GetParam;
  property Values[Index:integer]:string read GetValue;
end;

implementation

function TDSParameter.GetParam(ind:integer):string;
var k:integer;
begin
  k:=pos('=',Strings[ind]);
  if k>0 then
    GetParam:=Copy(Strings[ind],1,k-1)
  else
    GetParam:=Strings[ind]
end;

function TDSParameter.GetValue(ind:integer):string;
var k:integer;
begin
  k:=pos('=',Strings[ind]);
  if k>0 then
    GetValue:=Copy(Strings[ind],k+1,length(Strings[ind])-k)
  else
    GetValue:=''
end;

function TDSParameter.ParamByName(ParamName:string):integer;
var i:integer;
begin
  FindFlag:=FALSE;
  ParamByName:=-1;
  for i:=0 to Count-1 do
    if UpperCase(Params[i])=UpperCase(ParamName) then
      begin
        FindFlag:=TRUE;
        ParamByName:=i;
        break
      end;
end;

function TDSParameter.StrByName(ParamName:string):string;
var k:integer;
begin
  k:=ParamByName(ParamName);
  if FindFlag then
    StrByName:=Values[k]
  else
    StrByName:=''
end;


function TDSParameter.IntByName(ParamName:string):longint;
var k:integer;
begin
  k:=ParamByName(ParamName);
  IntByName:=0;
  if FindFlag then
    try
      IntByName:=StrToInt(Values[k])
    except
    end
end;

function TDSParameter.BoolByName(ParamName:string):boolean;
var k:integer;
begin
  k:=ParamByName(ParamName);
  if FindFlag then
    BoolByName:=Values[k]='1'
  else
    BoolByName:=FALSE
end;

procedure TDSParameter.AddParamStr(ParamName,Value:string);
var k:integer;
begin
  k:=ParamByName(ParamName);
  if FindFlag then
    Strings[k]:=ParamName+'='+Value
  else
    Add(ParamName+'='+Value)
end;

procedure TDSParameter.AddParamInt(ParamName:string;Value:longint);
begin
  AddParamStr(ParamName,IntToStr(Value));
end;

procedure TDSParameter.AddParamBool(ParamName:string;Value:boolean);
var s:string;
begin
  if Value then s:='1'
  else s:='0';
  AddParamStr(ParamName,s);
end;


end.
