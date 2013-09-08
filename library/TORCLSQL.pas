unit tOrclSql;

interface
Uses
   tSQLCls,DBTables,Classes,Forms,DB;
const sqlSuccess=0;
      sqlDBOpen=1;

Type TOracleSQL=class(TSQL)
       public
         constructor Create(dsn,uid,pwd:string);
         {Virtual Functions}
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
     end;

implementation

constructor TOracleSQL.Create(dsn,uid,pwd:string);
begin
  inherited Create(dsn,uid,pwd);
  PrefixTable:='"DBO".';
  DualTable:='"SYS".DUAL'
end;

function TOracleSQL.CurrentDate:String;
begin
  CurrentDate:='SYSDATE'
end;

function TOracleSQL.CurrentDateTime:String;
begin
  CurrentDateTime:='SYSDATE'
end;

function TOracleSQL.CurrentUser:String;
{Возвращает текущего пользователя }
begin
  CurrentUser:='USER'
end;

function TOracleSQL.TableKeyword(FieldName:string):string;
begin
  TableKeyword:=FieldName
end;

function TOracleSQL.DatePart(fn:string):string;
{Возвращает от типа DATE часть, содержащую дату}
begin
  DatePart:=fn
end;

function TOracleSQL.ConvertToDate(fn:string):string;
begin
  ConvertToDate:='TO_DATE('+fn+')'
end;

function TOracleSQL.ConvertToDateTime(fn:string):string;
begin
  ConvertToDateTime:='TO_DATE('+fn+',''YYYY-MM-DD HH24:MI:SS'')';
end;

function TOracleSQL.TimePart(fn:string):string;
{Возвращает от типа DATE часть, содержащую время}
begin
  TimePart:=fn
end;

function TOracleSQL.CharStr(fn:string):string;
{Возвращает значение типа CHAR целого цисла : x=CHR(67)-> x='D'}
begin
  CharStr:='CHR('+fn+')'
end;

function TOracleSQL.UpperCase(fn:string):string;
begin
  UpperCase:='UPPER('+fn+')'
end;

function TOracleSQL.SortLongString(fn:string):string;
begin
  SortLongString:=fn;
end;

function TOracleSQL.UserID(uid:string):longint;
begin
  UserID:=SelectInteger('"SYS".ALL_USERS','USER_ID','UPPER("USERNAME")'+'=UPPER('+
     MakeStr(uid)+')');
end;

function TOracleSQL.CreateUser(uid,pwd:string):longint;
begin
  if ExecOneSQL('CREATE USER '+uid+' IDENTIFIED BY '+pwd)=0 then
    CreateUser:=UserID(uid)
  else
    CreateUser:=-1
end;

function TOracleSQL.DropUser(uid:string):integer;
begin
  DropUser:=ExecOneSQL('DROP USER '+uid)
end;

function TOracleSQL.GrantRole(uid,group:string):integer;
begin
  GrantRole:=ExecOneSQL('GRANT "'+group+'" TO '+uid)
end;

function TOracleSQL.RevokeRole(uid,group:string):integer;
begin
  RevokeRole:=ExecOneSQL('REVOKE "'+group+'" FROM '+uid)
end;

procedure TOracleSQL.MultiString(sl:TStrings; p:PChar);
var i:integer;
begin
  if p=NIL then
    sl.Add('NULL')
  else
    if p[0]=#0 then
      sl.Add('''''')
    else
      SplitText(sl,p,'||');
end;

function TOracleSQL.RunFunction(FunName,Params,Alias:string):TQuery;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add(Params);
  RunFunction:=RunFunctionEx(FunName,sl);
  sl.Free
end;

function TOracleSQL.RunFunctionEx(FunName:TSQLString;Params:TStrings):TQuery;
var q:TQuery;
    sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add('DECLARE tmpVar INT; BEGIN tmpVar ::= '+AddPrefix(FunName)+'(');
  sl.AddStrings(Params);
  sl.Add('); '+PrefixTable+'LDP_P.SetTempVar(tmpVar); END;');
  ExecSQL(sl);
  RunFunctionEx:=Select(DualTable,PrefixTable+'LDP_P.GetTempVar TempVar','','');
  sl.Free;
end;

function TOracleSQL.ConnectCount:longint;
begin
  ConnectCount:=0
end;

function TOracleSQL.LockRecord(Table,Field,Value,Condition:string):integer;
var q:TQuery;
    res:integer;
    sl:TStringList;
begin
  if StartTransaction then
    begin
      if Condition<>'' then
        Condition:=' AND '+Condition;
      sl:=TStringList.Create;
      Condition:=Keyword(Field)+'='+Value+Condition;
      sl.Add('SELECT * FROM '+AddPrefix(Table));
      sl.Add('WHERE '+Condition+' FOR UPDATE NOWAIT');
      q:=CreateQuery(sl);
      if Error=1 then
         res:=2
      else
        if q.eof then
          res:=1
        else
          res:=0;
      q.Free;
      sl.Free;
    end
  else
    res:=3;
  if (res=1) or (res=2) then
    RollBack;
  LockRecord:=res;
end;

function TOracleSQL.ChangePassword(uid,pwd:string):integer;
var s:string;
begin
  s:='ALTER USER '+uid;
  if pwd<>'' then
    s:=s+' IDENTIFIED BY '+pwd;
  ChangePassword:=ExecOneSQL(s)
end;

end.

