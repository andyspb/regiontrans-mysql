unit tMSql;

interface
Uses
   tSQLCls,DBTables,Classes,Forms,DB,SysUtils;
const sqlSuccess=0;
      sqlDBOpen=1;

Type TMicrosoftSQL=class(TSQL)
       public
         constructor Create(dsn,uid,pwd:string);
         {Virtual Functions}
         function Connect(uid,pwd:string):integer; override;
	 function CurrentDate:String;override;
         function CurrentDateTime:String;override;
	 function CurrentUser:String;override;
	 function TableKeyword(FieldName:string):string;override;
	 function DatePart(fn:string):string;override;
	 function ConvertToDate(fn:string):string;override;
	 function ConvertToDateTime(fn:string):string;override;
	 function TimePart(fn:string):string;override;
	 function CharStr(fn:string):string;override;
         function UpperCase(fn:string):string;override;
         function SortLongString(fn:string):string;override;
         function UserID(uid:string):longint;override;
         function CreateUser(uid,pwd:string):longint;override;
         function ChangePassword(uid,pwd:string):integer; override;
         function DropUser(uid:string):integer;override;
         function GrantRole(uid,group:string):integer;override;
         function RevokeRole(uid,group:string):integer;override;
         procedure MultiString(sl:TStrings; p:PChar);override;
         function RunFunction(FunName,Params,Alias:string):TQuery; override;
         function RunFunctionEx(FunName:TSQLString;Params:TStrings):TQuery; override;
         function ConnectCount:longint; override;
         function LockRecord(Table,Field,Value,Condition:string):integer; override;
         procedure SplitText(sl:TStrings; p:Pchar; sep:string); override;
     end;

implementation
Uses lblmemo;

constructor TMicrosoftSQL.Create(dsn,uid,pwd:string);
begin
  inherited Create(dsn,uid,pwd);
  PrefixTable:='DBA.';
  DualTable:='DBA.DUAL'
end;

function TMicrosoftSQL.CurrentDate:String;
begin
  CurrentDate:='GETDATE()'
end;

function TMicrosoftSQL.CurrentDateTime:String;
begin
  CurrentDateTime:='GETDATE()'
end;

function TMicrosoftSQL.CurrentUser:String;
{Возвращает текущего пользователя }
begin
  CurrentUser:='USER_NAME()'
end;

function TMicrosoftSQL.TableKeyword(FieldName:string):string;
begin
  TableKeyword:=SYSUTILS.UpperCase(FieldName)
end;

function TMicrosoftSQL.DatePart(fn:string):string;
{Возвращает от типа DATE часть, содержащую дату}
begin
  DatePart:=fn
end;

function TMicrosoftSQL.ConvertToDate(fn:string):string;
begin
  ConvertToDate:=fn
  {'CONVERT(DATETIME,'+fn+',102)'}
end;

function TMicrosoftSQL.ConvertToDateTime(fn:string):string;
begin
  ConvertToDateTime:=ConvertToDate(fn);
end;

function TMicrosoftSQL.TimePart(fn:string):string;
{Возвращает от типа DATE часть, содержащую время}
begin
  TimePart:=fn
end;

function TMicrosoftSQL.CharStr(fn:string):string;
{Возвращает значение типа CHAR целого цисла : x=CHR(67)-> x='D'}
begin
  CharStr:='CHAR('+fn+')'
end;

function TMicrosoftSQL.UpperCase(fn:string):string;
begin
  UpperCase:='UPPER('+fn+')'
end;

function TMicrosoftSQL.SortLongString(fn:string):string;
begin
  SortLongString:=fn;
end;

function TMicrosoftSQL.UserID(uid:string):longint;
begin
  UserID:=1;
end;

function TMicrosoftSQL.CreateUser(uid,pwd:string):longint;
var s:string;
begin
  s:='sp_addlogin '+uid;
  if pwd<>'' then
    s:=s+','+pwd;
  ExecOneSQL(s);
  if ExecOneSQL('sp_adduser '+uid+','+uid)=0 then
    CreateUser:=UserID(uid)
  else
    CreateUser:=-1
end;

function TMicrosoftSQL.DropUser(uid:string):integer;
begin
  DropUser:=ExecOneSQL('sp_dropuser '+uid);
  ExecOneSQL('sp_droplogin '+uid);
end;

function TMicrosoftSQL.GrantRole(uid,group:string):integer;
begin
  GrantRole:=sql.ExecOneSQL('sp_changegroup '+group+','+uid)
end;

function TMicrosoftSQL.RevokeRole(uid,group:string):integer;
begin
  RevokeRole:=GrantRole(uid,'public');
end;

procedure TMicrosoftSQL.MultiString(sl:TStrings; p:PChar);
//var i:integer;
begin
  if p=NIL then
    sl.Add('NULL')
  else
    if p[0]=#0 then
      sl.Add('''''')
    else
      SplitText(sl,p,'+');
end;

procedure TMicrosoftSQL.SplitText(sl:TStrings; p:Pchar; sep:string);
var i,l,t:integer;
    s:string;
begin
  l:=StrLen(p);
  s:='';
  t:=0;
  i:=0;
  while ((i<l) and (i<250)) do
    begin
{      if (p[i]=#13) and (p[i]=#10) then
        begin
          s:=s+'\x1310\';
          i:=i+2;
        end
      else
        begin}
          s:=s+p[i];
          i:=i+1;
{        end;}
    end;
  sl.Add(MakeStr(s));
end;


function TMicrosoftSQL.RunFunction(FunName,Params,Alias:string):TQuery;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add(Params);
  RunFunction:=RunFunctionEx(SYSUTILS.UpperCase(FunName),sl);
  sl.Free
end;

function TMicrosoftSQL.RunFunctionEx(FunName:TSQLString;Params:TStrings):TQuery;
var //q:TQuery;
    sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add('BEGIN DECLARE @@tmpVar INT; EXEC '+AddPrefix(FunName));
  sl.AddStrings(Params);
  sl.Add(',@@tmpVar OUTPUT; SELECT @@tmpVar TempVar; END;');
  RunFunctionEx:=CreateQuery(sl);
  sl.Free;
end;

function TMicrosoftSQL.ConnectCount:longint;
begin
  ConnectCount:=0
end;

function TMicrosoftSQL.LockRecord(Table,Field,Value,Condition:string):integer;
begin
  LockRecord:=0;
end;

function TMicrosoftSQL.ChangePassword(uid,pwd:string):integer;
var s:string;
begin
  s:='sp_password ';
  if LoginPassword='' then s:=s+'NULL' else s:=s+'"'+LoginPassword+'"';
  if pwd='' then pwd:='NULL' else pwd:='"'+pwd+'"';
  s:=s+','+pwd;
  ChangePassword:=sql.ExecOneSQL(s)
end;

function TMicrosoftSQL.Connect(uid,pwd:string):integer;
var res:integer;
begin
  res:=inherited Connect(uid,pwd);
  if res=0 then
    ExecOneSQL('SET FORCEPLAN ON');
  Connect:=res
end;

end.

