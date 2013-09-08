unit Compiler;
{$O-}
interface
uses funchar,tsqlcls,parmlist;
function CompileNumber(req:string;sl:TDSParameter; var ErrorPos:integer):string;

implementation

function CompileNumber(req:string;sl:TDSParameter; var ErrorPos:integer):string;
var
  i:integer;
  res:string;


function CalcVariable:string;
var
  varname:string;
begin
  inc(i);
  varname:='';
  while (i<length(req)) and (req[i]<>'~') do
    begin varname:=varname+req[i]; inc(i); end;
  inc(i);
  CalcVariable:=sl.StrByName(varname);
end;
procedure ReadStr;
begin
  inc(i);
  while (i<length(req)) and (req[i]<>'''') do
    begin res:=res+req[i]; inc(i); end;
  inc(i);
end;
function GetStr:string;
var r:string;
begin
  r:='';
  while (i<length(req)) and IsAlpha(req[i]) do
    begin r:=r+req[i]; inc(i); end;
  GetStr:=r;
end;

procedure ReadSQLReq;
var
  Par1,Par2,Par3:string;
begin
  Par1:=GetStr;
  if req[i]<>',' then exit;inc(i);
  Par2:=GetStr;
  if req[i]<>',' then exit;inc(i);
  Par3:='';
  while (i<length(req)) and (req[i]<>',') and (req[i]<>')') do
    begin
      if req[i]='~' then begin Par3:=Par3+CalcVariable; dec(i); end
        else Par3:=Par3+req[i];
      inc(i);
    end;
  inc(i);
  Res:=Res+sql.SelectString(Par1,Par2,Par3);
end;
procedure ReadSubstrReq;
var
  Par1,Par2,Par3:string;
  n1,n2,c:integer;
begin
  if req[i]<>'~' then exit;
  inc(i);
  Par1:=GetStr;
  if req[i]<>'~' then exit;
  inc(i);
  if req[i]<>',' then exit;
  inc(i);
  Par2:=GetStr;
  if req[i]<>',' then exit;
  inc(i);
  Par3:=GetStr;
  if req[i]<>')' then exit;
  inc(i);
  val(Par2,n1,c);
  val(Par3,n2,c);
  Res:=Res+Copy(Par1,n1,n2);
end;
procedure ReadFunc;
var
  funcname:string;
begin
  funcname:=GetStr;
  if req[i]<>'(' then exit;
  inc(i);
  if funcname='SQL' then ReadSQLReq;
  if funcname='SUBSTR' then ReadSubstrReq;
end;
begin
  res:='';
  ErrorPos:=0;
  for i:=1 to length(req) do
    begin
      if req[i]='~' then res:=res+CalcVariable
        else if req[i]='''' then ReadStr
          else if IsAlpha(req[i]) then ReadFunc;
      if req[i]<>'+' then break;
    end;
  if i<length(req) then begin ErrorPos:=i;res:=''; end;
  while (length(res)>0) and (res[length(res)]='/') do
    Delete(res,length(res),1);
  CompileNumber:=res;
end;

end.
