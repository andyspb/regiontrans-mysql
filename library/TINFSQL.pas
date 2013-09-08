unit tInfSql;

interface
Uses
   tSQLCls,DBTables,Classes,Forms,DB,SysUtils;
const sqlSuccess=0;
      sqlDBOpen=1;

Type TInformixSQL=class(TSQL)
       public
         constructor Create(dsn,uid,pwd:string);
         {Virtual Functions}
	 function Connect(uid,pwd:string):integer; override;
	function CurrentDate:String;override;
	function CurrentDateTime:String;override;
	function CurrentUser:String;override;
	function TableKeyword(FieldName:string):string;override;
	function DatePart(fn:string):string;override;
{**************serge}
        function ConvertToDate2(fn:string):string;override;
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
        function ConnectCount:longint; override;
        function LockRecord(Table,Field,Value,Condition:string):integer; override;
        function RunFunction(FunName,Params,Alias:string):TQuery; override;
        function RunFunctionEx(FunName:TSQLString;Params:TStrings):TQuery; override;
        function LTrim(Value:string):string; override;
        function InsertSelect(TableName,Fields,SelTableName,Values,Cond:String):integer;override;
     end;

implementation

constructor TInformixSQL.Create(dsn,uid,pwd:string);
begin
  inherited Create(dsn,uid,pwd);
  PrefixTable:='';
  DualTable:='DUAL'
end;

function TInformixSQL.CurrentDate:String;
begin
  CurrentDate:='TODAY'
end;

function TInformixSQL.CurrentDateTime:String;
begin
  CurrentDateTime:='CURRENT'
end;

function TInformixSQL.CurrentUser:String;
{Возвращает текущего пользователя }
begin
  CurrentUser:='USER'
end;

function TInformixSQL.TableKeyword(FieldName:string):string;
begin
  TableKeyword:=Copy(FieldName,1,18)
end;

function TInformixSQL.DatePart(fn:string):string;
{Возвращает от типа DATE часть, содержащую дату}
begin
  DatePart:='EXTEND('+fn+',''YEAR TO DAY'')';
end;

function TInformixSQL.ConvertToDate2(fn:string):string;
var r:string;
begin
  if fn[1]='''' then r:=copy(fn,2,length(fn)-2) else r:=fn;
  ConvertToDate2:='DATETIME('+r+') YEAR TO DAY';
end;

function TInformixSQL.ConvertToDate(fn:string):string;
begin
  ConvertToDate:=fn
end;

function TInformixSQL.ConvertToDateTime(fn:string):string;
begin
  ConvertToDateTime:=fn {'TO_DATE('+fn+',''YYYY-MM-DD HH24:MI:SS'')'};
end;

function TInformixSQL.TimePart(fn:string):string;
{Возвращает от типа DATE часть, содержащую время}
begin
 TimePart:='EXTEND('+fn+',''HOUR TO SECOND'')';
end;

function TInformixSQL.CharStr(fn:string):string;
{Возвращает значение типа CHAR целого цисла : x=CHR(67)-> x='D'}
begin
  CharStr:=MakeStr(' '){'CHR('+fn+')'}
end;

function TInformixSQL.UpperCase(fn:string):string;
begin
  UpperCase:='UPPER('+fn+')'
end;

function TInformixSQL.SortLongString(fn:string):string;
begin
  SortLongString:=fn;
end;

function TInformixSQL.UserID(uid:string):longint;
begin
  UserID:=0{SelectInteger('"SYS".ALL_USERS','USER_ID','UPPER("USERNAME")'+'=UPPER('+
     MakeStr(uid)+')');}
end;

function TInformixSQL.CreateUser(uid,pwd:string):longint;
begin
{  if ExecOneSQL('CREATE USER '+uid+' IDENTIFIED BY '+pwd)=0 then
    CreateUser:=UserID(uid)
  else}
    CreateUser:=-1
end;

function TInformixSQL.DropUser(uid:string):integer;
begin
  DropUser:=-1{ExecOneSQL('DROP USER '+uid)}
end;

function TInformixSQL.GrantRole(uid,group:string):integer;
begin
  GrantRole:=ExecOneSQL('GRANT '+group+' TO '+uid)
end;

function TInformixSQL.RevokeRole(uid,group:string):integer;
begin
  RevokeRole:=ExecOneSQL('REVOKE '+group+' FROM '+uid)
end;

procedure TInformixSQL.MultiString(sl:TStrings; p:PChar);
var i:integer;
begin
  if p=NIL then
    sl.Add('NULL')
  else
    if p[0]=#0 then
      sl.Add('''''')
    else
      sl.Add(MakeStr(StrPas(p)));
      { SplitText(sl,p,'||');}
end;

function TInformixSQL.RunFunction(FunName,Params,Alias:string):TQuery;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add(Params);
  RunFunction:=RunFunctionEx(FunName,sl);
  sl.Free
end;

function TInformixSQL.RunFunctionEx(FunName:TSQLString;Params:TStrings):TQuery;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add('EXECUTE PROCEDURE '+FunName+'(');
  sl.AddStrings(Params);
  sl.Add(')');
  RunFunctionEx:=CreateQuery(sl);
  sl.Free;
end;

function TInformixSQL.ConnectCount:longint;
begin
  ConnectCount:=0
end;

function TInformixSQL.LockRecord(Table,Field,Value,Condition:string):integer;
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

function TInformixSQL.ChangePassword(uid,pwd:string):integer;
var s:string;
begin
  ChangePassword:=-1;
{  s:='ALTER USER '+uid;
  if pwd<>'' then
    s:=s+' IDENTIFIED BY '+pwd;
  ChangePassword:=sql.ExecOneSQL(s)}
end;

function TInformixSQL.Connect(uid,pwd:string):integer;
begin
  Result:=inherited Connect(uid,pwd);
  execonesql('set explain on');
end;

function TInformixSQL.LTrim(Value:string):string;
begin
  LTrim:='TRIM('+Value+')'
end;

function TInformixSQL.InsertSelect(TableName,Fields,SelTableName,Values,Cond:String):integer;
var sl:TStringList;
function MakeAsgn(flds,values:String):string;
var
  f,v:string;
  r:string;
function GetWord(var s:string):string;
var
  i:integer;
  r:string;
begin
  i:=pos(',',s);
  if i=0 then i:=length(s);
  if s[i]=',' then r:=copy(s,1,i-1) else r:=copy(s,1,i);
  SYSTEM.delete(s,1,i);
  GetWord:=r;
end;
begin
 r:='';
 while flds<>'' do
   begin
     f:=GetWord(flds);
     v:=GetWord(values);
     r:=r+v+' '+f;
     if flds<>'' then r:=r+',';
   end;
 MakeAsgn:=r;
end;
begin
  sl:=TStringList.Create;
  sl.Add('SELECT ');
  sl.Add(MakeAsgn(MakeKeywords(Fields),Values));
  sl.Add('FROM '+AddPrefix(SelTableName));
  AddCondition(sl,Cond);
  sl.Add('INTO TEMP anzrows');
  ExecSQL(sl);
  sl.Clear;
  sl.Add(INSERT_INTO+AddPrefix(TableName));
  sl.Add('('+MakeKeywords(Fields)+') select * from anzrows');
  InsertSelect:=ExecSQL(sl);
  ExecOneSQL('DROP TABLE anzrows');
  sl.Free
end;

end.

