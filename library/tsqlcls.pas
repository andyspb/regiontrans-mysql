unit TSQLCLS;

interface


{$Define SQLDebugFlag}
{ $Define DebugFormFlag}
{$Define DebugFileFlag}
{ $Define DebugExceptionFlag}

Uses DBTables,Classes,Forms,DB,SysUtils
{$IfDef DebugFormFlag}
,DebugFrm
{$EndIf}
;

const sqlSuccess=0;
      sqlDBOpen=1;
      SQLER_FIELDABSENT=2000;
      LogAND:string[6]=' AND ';
      LogOR:string[6]=' OR ';
      LogNot:string[6]=' NOT ';

Type TSQLString=string[64];
Type TSQL=class(TPersistent)
       protected
         fLoginName,fLoginPassword:TSQLString;
         function DuplicateChar(Value:string;Ch:char):string;
{$IfDef SQLDebugFlag}
         procedure PrintError(msg:String;sl:TStrings);
{$EndIf}
	 procedure SplitText(sl:TStrings; p:PChar;sep:string); virtual;
       protected
         function ValueEx(const Arg: TVarRec): string;
         function MakeKeywordsEx(const Args: array of string): string; virtual;
         function MakeValuesEx(const Args: array of const): string; virtual;
       public
         StrBuf:array[0..2048] of char;
         Error:integer;
         ErrorMessage:string;
	 CurrentUserID:longint;
         TransactionCount:longint;
         TransactionFlag:boolean;
         DataBase:TDataBase;
	 DataBaseName,
         PrefixTable,
         DualTable,
         DeleteAllFrom,
         SelectAllFrom,
         Insert_Into :string[32];

         constructor Create(dsn,uid,pwd:string);
         destructor Destroy; override;

         {Virtual Functions}
         function ExecSQL(sl:TStrings):integer;
         function ExecOneSQL(s:string):integer;
         function MakeKeywords(s:string):string;
         procedure AddCondition(sl:TStrings;Condition:string); virtual;
         procedure AddOrderBy(sl:TStrings;OrderBy:string); virtual;
	 function Connect(uid,pwd:string):integer; virtual;
         function RecordCount(TableName,Condition:String):longint; virtual;
         function Select(TableName,Fields,Condition,OrderBy:string):TQuery; virtual;
	 function SelectDistinct(TableName,Fields,Condition,OrderBy:string):TQuery; virtual;
         function CreateQuery(SQLCmd:TStrings):TQuery; virtual;
         function CreateQueryOne(SQLCmd:string):TQuery; virtual;
         function Delete(TableName,Condition:string):integer; virtual;
         function Insert(TableName,Fields:string;Values:TStringList):integer; virtual;
         function InsertString(TableName,Fields,Values:String):integer; virtual;
         function InsertSelect(TableName,Fields,SelTableName,Values,Cond:String):integer; virtual;
         function Update(TableName:string;Values:TStringList;
                                          Condition:string):integer; virtual;
         function UpdateString(TableName,Values,Condition:string):integer; virtual;
         function CurrentDate:String; virtual;
         function CurrentDateTime:String; virtual;
         function CurrentUser:String; virtual;
         function AsContext:string; virtual;
         function Keyword(FieldName:string):string; virtual;
         function TableKeyword(FieldName:string):string; virtual;
         function DatePart(fn:string):string; virtual;
         function TimePart(fn:string):string; virtual;
	 function YearPart(FieldName:string):string;  virtual;
         function LengthStr(fn:string):string; virtual;
         function CharStr(fn:string):string; virtual;
	 function AddDayToDateTime(FieldName:string;Day:string):string; virtual;
         function UpperCase(fn:string):string; virtual;
         function LTrim(Value:string):string; virtual;
         function SortLongString(fn:string):string; virtual;
{serge}
         function ConvertToDate2(fn:string):string; virtual;
         function ConvertToDate(fn:string):string; virtual;
         function ConvertToDateTime(fn:string):string; virtual;

         function AddPrefix(Name:string):string; virtual;
         Function FindNextInteger(FieldName,TableName,Conditions:string;lim:longint):longint;
         function UserID(uid:string):longint; virtual;
         function CreateUser(uid,pwd:string):longint; virtual;
         function ChangePassword(uid,pwd:string):integer; virtual;
         function DropUser(uid:string):integer; virtual;
         function GrantRole(uid,group:string):integer; virtual;
         function RevokeRole(uid,group:string):integer; virtual;
         function SelectInteger(TableName,FieldName,Condition:string):longint;
         function LockRecord(Table,Field,Value,Condition:string):integer; virtual;
	 function StartTransaction:boolean; virtual;
         function Commit:boolean; virtual;
         function Rollback:boolean; virtual;
	 procedure MultiString(sl:TStrings; p:PChar); virtual;
         function CondInt(Field,Oper:string;Value:longint):string; virtual;
         function CondIntEqu(Field:string;Value:longint):string; virtual;
         function CondStr(Field,Oper,Value:string):string; virtual;
         function CondField(Field,Oper,RightField:string):string; virtual;
         function CondValue(Field,Oper,Value:string):string; virtual;
         function CondNull(Field:string):string; virtual;
         function CondNotNull(Field:string):string; virtual;
         function CondExists(TableName,Alias,Condition:string):string; virtual;
         function CondIn(Field1,TableName,Alias,Field2:TSQLString;Condition:string):string; virtual;
         function CondLike(Field,Value:string;cs:integer):string; virtual;
         function CondDate(Field,Oper:string;dt:TDateTime):string; virtual;
         function SetInt(Field:string;Value:longint):string; virtual;
         function SetRef(Field:string;Value:longint):string; virtual;
         function SetStr(Field,Value:string):string; virtual;
         function SetField(Field,RightField:string):string; virtual;
         function SetValue(Field,Value:string):string; virtual;
         function SetNull(Field:string):string; virtual;
         function SetDate(Field:string;dt:TDateTime):string; virtual;
	 function RunFunction(FunName,Params,Alias:string):TQuery; virtual;
	 function RunFunctionEx(FunName:TSQLString;Params:TStrings):TQuery; virtual;
	 function RunFunctionInt(FunName:TSQLString;Params:string):longint; virtual;
         function Eof(TableName,Cond:String):boolean; virtual;
         function ConnectCount:longint; virtual;
         function MakeStr(Value:string):string; virtual;
         procedure UpdateBlobField(TableName,Field,Condition:string;Stream:TStream);
         procedure SelectBlobField(TableName,Field,Condition:string;Stream:TStream);
       public
	 function InsertEx(const TableName: string; const Fields: array of string;
            const Values: array of const): integer; virtual;
	 function UpdateEx(const TableName: string; const Fields: array of string;
            const Values: array of const; const Condition:  string): integer; virtual;
       published
         property LoginName:TSQLString read fLoginName;
         property LoginPassword:TSQLString read fLoginPassword;
         function SelectString(TableName,FieldName,Condition:string):string;
     end;

var SQL:TSQL;

implementation

function TSQL.MakeKeywords(s:string):string;
var  res:string;
     i,j,k:integer;
begin
  res:='';
  repeat
    i:=pos(',',s);
    if (i=0) then i:=length(s)+1;
    j:=pos(' ',s);
    if (j=0) or (j>=i) then j:=i;
    k:=pos('(',s);
    if res<>'' then res:=res+',';
    if (k=0) or (k>=j) then
      res:=res+Keyword(Copy(s,1,j-1))+Copy(s,j,i-j)
    else
      res:=res+Copy(s,1,i-1);
    SYSTEM.Delete(s,1,i)
  until s='';
  MakeKeywords:=res
end;

function TSQL.Connect(uid,pwd:string):integer;
begin
  DataBase.Close;
  DataBase.Params.Clear;
  DataBase.Params.Add('USER NAME='+uid);
  DataBase.Params.Add('PASSWORD='+pwd);
  try
    DataBase.Open;
    Error:=0;
    fLoginName:=uid;
    fLoginPassword:=pwd;
  except on ex:EDataBaseError do
    begin
      ErrorMessage:=ex.Message;
{$IfDef SQLDebugFlag}
      PrintError(ErrorMessage,NIL);
{$EndIf}
      Error:=1
    end;
  end;
  Connect:=Error
end;

constructor TSQL.Create(dsn,uid,pwd:string);
begin
  inherited Create;
  TransactionCount:=0;
  Insert_Into:='INSERT INTO ';
  DeleteAllFrom:='DELETE FROM ';
  SelectAllFrom:='SELECT * FROM ';
  PrefixTable:='severtrans.';
  DataBase:=TDataBase.Create(Application);
  DataBaseName:=dsn;
  DataBase.DataBaseName:=DataBaseName;
  DataBase.LoginPrompt:=FALSE;
  DataBase.AliasName:=DataBaseName;
  if uid<>'' then
    Connect(uid,pwd);
//mysql  DualTable:='SYS.DUMMY';
  CurrentUserID:=0;
  TransactionFlag:=FALSE
end;

destructor TSQL.Destroy;
begin
  DataBase.Free
end;

function TSQL.ExecSQL(sl:TStrings):integer;
var q:TQuery;
begin
  q:=TQuery.Create(Application);
  q.DataBaseName:=DataBaseName;
  q.SQL.AddStrings(sl);
  Error:=0;
  try                       

    q.ExecSQL;
  except on ex:EDataBaseError do
    begin
      ErrorMessage:=ex.Message;
{$IfDef SQLDebugFlag}
      PrintError(ErrorMessage,q.SQL);
{$EndIf}
      Error:=1;
    end
  end;
  ExecSQL:=Error;
  q.Free;
end;

function TSQL.ExecOneSQL(s:string):integer;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add(s);
  ExecOneSQL:=ExecSQL(sl);
  sl.Free;
end;

function TSQL.CreateQuery(SQLCmd:TStrings):TQuery;
var q:TQuery;
begin
  q:=TQuery.Create(Application);
  q.DataBaseName:=DataBaseName;
  q.SQL.AddStrings(SQLCmd);
  Error:=0;
  try
    q.Open;
  except on ex:EDataBaseError do
    begin
      ErrorMessage:=ex.Message;
{$IfDef SQLDebugFlag}
      PrintError(ErrorMessage,q.SQL);
{$EndIf}
      Error:=1;
    end
  end;
  CreateQuery:=q;
end;

function TSQL.CreateQueryOne(SQLCmd:string):TQuery;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add(SQLCmd);
  CreateQueryOne:=CreateQuery(sl);
  sl.Free;
end;

procedure TSQL.AddCondition(sl:TStrings;Condition:string);
begin
  if Condition<>'' then
    begin
      sl.Add('WHERE');
      sl.Add(Condition);
    end
end;

procedure TSQL.AddOrderBy(sl:TStrings;OrderBy:string);
begin
  if OrderBy<>'' then
    begin
      sl.Add('ORDER BY');
      sl.Add(OrderBy);
    end
end;

function TSQL.Select(TableName,Fields,Condition,OrderBy:string):TQuery;
var q:TQuery;
begin
  q:=TQuery.Create(Application);
  q.DataBaseName:=DataBaseName;
  if (Fields='') or (Fields='*')then
    Fields:='*' else Fields:=MakeKeywords(Fields);
  Error:=0;
  q.SQL.Add('SELECT '+Fields);
  q.SQL.Add('FROM '+AddPrefix(TableName));
  AddCondition(q.SQL,Condition);
  AddOrderBy(q.SQL,MakeKeyWords(OrderBy));
  try
    q.Open;
  except on ex:EDataBaseError do
    begin
      ErrorMessage:=ex.Message;
{$IfDef SQLDebugFlag}
      PrintError(ErrorMessage,q.SQL);
{$EndIf}
      Error:=1;
    end
  end;
  Select:=q;
end;

function TSQL.SelectDistinct(TableName,Fields,Condition,OrderBy:string):TQuery;
var q:TQuery;
begin
  q:=TQuery.Create(Application);
  q.DataBaseName:=DataBaseName;
  if Fields='' then
    Fields:='*' else Fields:=Keyword(Fields);
  Error:=0;
  q.SQL.Add('SELECT DISTINCT '+Fields);
  q.SQL.Add('FROM '+AddPrefix(TableName));
  AddCondition(q.SQL,Condition);
  AddOrderBy(q.SQL,KeyWord(OrderBy));
  try
    q.Open;
  except on ex:EDataBaseError do
    begin
      ErrorMessage:=ex.Message;
{$IfDef SQLDebugFlag}
      PrintError(ErrorMessage,q.SQL);
{$EndIf}
      Error:=1;
    end
  end;
  SelectDistinct:=q;
end;

function TSQL.Delete(TableName:string;Condition:string):integer;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add(DeleteAllFrom+AddPrefix(TableName));
  AddCondition(sl,Condition);
  Delete:=ExecSQL(sl);
  sl.Free
end;

function TSQL.Insert(TableName,Fields:string;Values:TStringList):integer;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add(Insert_Into+AddPrefix(TableName)+' (');
  sl.Add(MakeKeywords(Fields));
  sl.Add(') VALUES (');
  sl.AddStrings(Values);
  sl.Add(')');
  Insert:=ExecSQL(sl);
  sl.Free
end;

function TSQL.InsertString(TableName,Fields,Values:String):integer;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add(Insert_Into+AddPrefix(TableName)+' (');
  sl.Add(MakeKeywords(Fields));
  sl.Add(') VALUES (');
  sl.Add(Values);
  sl.Add(')');
  InsertString:=ExecSQL(sl);
  sl.Free
end;

function TSQL.InsertSelect(TableName,Fields,SelTableName,Values,Cond:String):integer;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add(Insert_Into+AddPrefix(TableName)+' (');
  sl.Add(MakeKeywords(Fields));
  sl.Add(') SELECT ');
  sl.Add(Values);
  sl.Add('FROM '+AddPrefix(SelTableName));
  AddCondition(sl,Cond);
  InsertSelect:=ExecSQL(sl);
  sl.Free
end;

function TSQL.Update(TableName:string;Values:TStringList;Condition:String):integer;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add('UPDATE '+AddPrefix(TableName)+' SET');
  sl.AddStrings(Values);
  AddCondition(sl,Condition);
  Update:=ExecSQL(sl);
  sl.Free
end;

function TSQL.UpdateString(TableName,Values,Condition:String):integer;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add('UPDATE '+AddPrefix(TableName)+' SET');
  sl.Add(Values);
  AddCondition(sl,Condition);
  UpdateString:=ExecSQL(sl);
  sl.Free
end;

function TSQL.CurrentDate:String;
begin
  CurrentDate:='TODAY(*)'
end;

function TSQL.CurrentDateTime:String;
begin
  CurrentDateTime:='NOW(*)'
end;

function TSQL.CurrentUser:String;
begin
  CurrentUser:='USER'
end;

function TSQL.AsContext:string;
begin
  AsContext:=' '
end;

function TSQL.AddPrefix(Name:string):string;
begin
  if pos('.',Name)=0 then
    AddPrefix:=PrefixTable+TableKeyword(Name)
  else
    AddPrefix:=Name;
end;

function TSQL.Keyword(FieldName:string):string;
var
  i:integer;
begin
//mysql replaced " with `
  FieldName:=StringReplace(FieldName, '"', '`',[rfReplaceAll, rfIgnoreCase]);
  if ((FieldName<>'') and (pos('`',FieldName)<>1)) then
    if pos(' ',FieldName)=0 then Keyword:='`'+FieldName+'`'
      else
        if ((pos(',',FieldName)=0) and (pos('(',FieldName)=0)) then
            begin
              i:=pos(' ',fieldname);
              system.insert('`',fieldname,i);
              Keyword:='`'+fieldname;
            end
          else Keyword:=FieldName
  else
       Keyword:=FieldName
end;

function TSQL.TableKeyword(FieldName:string):string;
begin
  TableKeyword:=SYSUTILS.UpperCase(FieldName);
end;

function TSQL.DatePart(fn:string):string;
begin
  DatePart:='DATE('+fn+')';
end;

function TSQL.ConvertToDate(fn:string):string;
begin
  ConvertToDate:='DATE('+fn+')';
end;

function TSQL.ConvertToDate2(fn:string):string;
begin
  ConvertToDate2:=ConvertToDate(fn);
end;

function TSQL.ConvertToDateTime(fn:string):string;
begin
  ConvertToDateTime:=fn;
end;

function TSQL.TimePart(fn:string):string;
begin
  TimePart:='CAST('+fn+' AS TIME)';
end;

function TSQL.YearPart(FieldName:string):string;
begin
  YearPart:='YEAR('+FieldName+')';
end;

function TSQL.LengthStr(fn:string):string;
begin
  LengthStr:='LENGTH('+fn+')';
end;

function TSQL.CharStr(fn:string):string;
begin
  CharStr:='CHAR('+fn+')';
end;

function TSQL.AddDayToDateTime(FieldName:string;Day:string):string;
begin
  AddDayToDateTime:=FieldName+'+'+Day;
end;

function TSQL.UpperCase(fn:string):string;
begin
  UpperCase:='UCASE('+fn+')';
end;

function TSQL.SortLongString(fn:string):string;
begin
  SortLongString:=fn;
end;

function TSQL.UserID(uid:string):longint;
var q:TQuery;
begin
  q:=Select('SYS.SYSUSERPERMS','user_id','user_name='+MakeStr(uid),'');
  UserID:=q.FieldByName('user_id').AsInteger;
  q.Free;
end;

function TSQL.CreateUser(uid,pwd:string):longint;
begin
  if ExecOneSQL('GRANT CONNECT TO "'+uid+'" IDENTIFIED BY "'+pwd+'"')=0 then
    CreateUser:=UserID(uid)
  else
    CreateUser:=-1
end;

function TSQL.DropUser(uid:string):integer;
begin
  DropUser:=ExecOneSQL('REVOKE CONNECT FROM "'+uid+'"');
end;

function TSQL.GrantRole(uid,group:string):integer;
begin
  GrantRole:=ExecOneSQL('GRANT MEMBERSHIP IN GROUP "'+group+'" TO "'+uid+'"');
end;

function TSQL.RevokeRole(uid,group:string):integer;
begin
  RevokeRole:=ExecOneSQL('REVOKE MEMBERSHIP IN GROUP "'+group+'" FROM "'+uid+'"');
end;

Function TSQL.FindNextInteger(FieldName,TableName,Conditions:string;lim:longint):longint;
var q:TQuery;
    l:longint;
begin
  q:=SelectDistinct(TableName,'MAX('+Keyword(FieldName)+') TempVar',Conditions,'');
  if q.eof then
    l:=1
  else
    begin
      l:=q.FieldByName('TempVar').AsInteger+1;
      if l>=lim then l:=1;
    end;
  q.Free;
  FindNextInteger:=l;
end;

function TSQL.SelectString(TableName,FieldName,Condition:string):string;
var q:TQuery;
begin
  q:=Select(TableName,Keyword(FieldName),Condition,'');
  SelectString:=q.FieldByName(FieldName).AsString;
  q.Free
end;

function TSQL.SelectInteger(TableName,FieldName,Condition:string):longint;
var q:TQuery;
begin
  q:=Select(TableName,Keyword(FieldName),Condition,'');
  try
    SelectInteger:=q.FieldByName(FieldName).AsInteger;
  except
    SelectInteger:=0
  end;
  q.Free
end;

function TSQL.StartTransaction:boolean;
begin
  try
    TransactionCount:=TransactionCount+1;
    DataBase.StartTransaction;
    Error:=0
  except on ex:EDataBaseError do
    begin
      ErrorMessage:=ex.Message;
      Error:=1
    end
  end;
  StartTransaction:=Error=0;
end;

function TSQL.Commit:boolean;
begin
  try
    if TransactionCount>0 then TransactionCount:=TransactionCount-1;
    DataBase.Commit;
    Error:=0
  except on ex:EDataBaseError do
    begin
      ErrorMessage:=ex.Message;
      Error:=1
    end
  end;
  Commit:=Error=0;
end;

function TSQL.Rollback:boolean;
begin
  try
    if TransactionCount>0 then TransactionCount:=TransactionCount-1;
    DataBase.Rollback;
    Error:=0
  except on ex:EDataBaseError do
    begin
      ErrorMessage:=ex.Message;
      Error:=1
    end
  end;
  RollBack:=Error=0;
end;

procedure TSQL.SplitText(sl:TStrings; p:Pchar; sep:string);
var i,l,t:integer;
    s:string;
begin
  l:=StrLen(p);
  s:='';
  t:=0;
  i:=0;
  while i<l do
    begin
      if (p[i]=#13) and (p[i+1]=#10) then
        begin
          if t=1 then sl.Add(sep);
          t:=1;
          sl.Add(MakeStr(s)+sep+CharStr('13')+sep+CharStr('10'));
          s:='';
          i:=i+2;
        end
      else
        begin
          s:=s+p[i];
          if (length(s)>220) or (i=l-1) then
            begin
              if t=1 then sl.Add(sep);
              t:=1;
              sl.Add(MakeStr(s));
              s:='';
            end;
          i:=i+1;
        end;
    end;
end;

procedure TSQL.MultiString(sl:TStrings; p:Pchar);
begin
  if p=NIL then
    sl.Add('NULL')
  else
    if p[0]=#0 then
      sl.Add('''''')
    else
      begin
        sl.Add('STRING(');
        SplitText(sl,p,',');
        sl.Add(')')
      end
end;

function TSQL.LockRecord(Table,Field,Value,Condition:string):integer;
var q:TQuery;
    res:integer;
begin
  if StartTransaction then
    begin
      if Condition<>'' then
        Condition:=' AND '+Condition;
      Condition:=Keyword(Field)+'='+Value+Condition;
      q:=Select(Table,Field,Condition,'');
      if q.eof then
        res:=1
      else
        if UpdateString(Table,Field+'='+Field,Condition)<>sqlSuccess then
          res:=2
        else
          res:=0;
      q.Free;
    end
  else
    res:=3;
  if (res=1) or (res=2) then
    RollBack;
  LockRecord:=res;
end;

function TSQL.CondInt(Field,Oper:string;Value:longint):string;
begin
  CondInt:=Keyword(Field)+Oper+IntToStr(Value)
end;

function TSQL.CondIntEqu(Field:string;Value:longint):string;
begin
  CondIntEqu:=Keyword(Field)+'='+IntToStr(Value)
end;

function TSQL.CondStr(Field,Oper,Value:string):string;
begin
  CondStr:=Keyword(Field)+Oper+MakeStr(Value)
end;

function TSQL.CondField(Field,Oper,RightField:string):string;
begin
  CondField:=Keyword(Field)+Oper+Keyword(RightField)
end;

function TSQL.CondNull(Field:string):string;
begin
  CondNull:=Keyword(Field)+' IS NULL'
end;

function TSQL.CondNotNull(Field:string):string;
begin
  CondNotNull:=Keyword(Field)+' IS NOT NULL'
end;

function TSQL.CondValue(Field,Oper,Value:string):string;
begin
  CondValue:=Keyword(Field)+Oper+Value
end;

function TSQL.SetInt(Field:string;Value:longint):string;
begin
  SetInt:=Keyword(Field)+'='+IntToStr(Value)
end;

function TSQL.SetStr(Field,Value:string):string;
begin
  SetStr:=Keyword(Field)+'='+MakeStr(Value)
end;

function TSQL.SetField(Field,RightField:string):string;
begin
  SetField:=Keyword(Field)+'='+Keyword(RightField)
end;

function TSQL.SetValue(Field,Value:string):string;
begin
  SetValue:=Keyword(Field)+'='+Value
end;

function TSQL.SetRef(Field:string;Value:longint):string;
begin
  if Value=0 then
    SetRef:=SetNull(Field)
  else
    SetRef:=Keyword(Field)+'='+IntToStr(Value)
end;

function TSQL.RunFunction(FunName,Params,Alias:string):TQuery;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add('SELECT '+FunName+'(');
  sl.Add(Params);
  sl.Add(') '+sql.Keyword(Alias)+' FROM '+DualTable);
  RunFunction:=CreateQuery(sl);
  sl.Free;
end;

function TSQL.RunFunctionInt(FunName:TSQLString;Params:string):longint;
var q:TQuery;
begin
  q:=RunFunction(FunName,Params,'TempVar');
  try
    RunFunctionInt:=q.Fields[0].AsInteger;
  except
    RunFunctionInt:=0;
    Error:=SQLER_FIELDABSENT;
  end;
  q.Free;
end;

function TSQL.RunFunctionEx(FunName:TSQLString;Params:TStrings):TQuery;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add('SELECT '+FunName+'(');
  sl.AddStrings(Params);
  sl.Add(') TempVar FROM '+DualTable);
  RunFunctionEx:=CreateQuery(sl);
  sl.Free;
end;

function TSQL.RecordCount(TableName,Condition:string):longint;
var q:TQuery;
begin
  q:=Select(TableName,'COUNT(*) TempVar',Condition,'');
  RecordCount:=q.FieldByName('TempVar').AsInteger;
  q.Free;
end;

function TSQL.SetNull(Field:string):string;
begin
  SetNull:=Keyword(Field)+'=NULL'
end;


{---------------------------------------------------------------}
{$IfDef SQLDebugFlag}
procedure TSQL.PrintError(msg:String;sl:TStrings);

{$IfDef DebugFormFlag}
var  dlg: TDebugForm;
begin
  dlg:=TDebugForm.Create(NIL);
  dlg.msg.Text:=msg;
  if sl<>NIL then
    dlg.mText.Lines.AddStrings(sl);
  dlg.ShowModal;
  dlg.Free;
end;
{$EndIf}

{$IfDef DebugFileFlag}
const
  DebugFileName = 'c:\landocs.log';

var
  f:	Text;
  i:integer;
begin
  SYSTEM.Assign(f,DebugFileName);
  if FileExists(DebugFileName) then Append(f)
    else ReWrite(f);
  Writeln(f,'=================='+DateTimeToStr(now)+'======================');
  Writeln(f, msg);
  if sl<>NIL then
    for i:=0 to sl.Count-1 do
      Writeln(f, sl.Strings[i]);
  Close(f);
end;
{$EndIf}

{$IfDef DebugExceptionFlag}
begin
  raise Exception.Create(msg);
end;
{$EndIf}

{$EndIf}

{---------------------------------------------------------------}
function TSQL.Eof(TableName,Cond:String):boolean;
var q:TQuery;
begin
  q:=Select(TableName,'',Cond,'');
  Eof:=q.eof;
  q.Free
end;

function TSQL.CondExists(TableName,Alias,Condition:string):string;
begin
  if Condition<>'' then
    Condition:=' WHERE '+Condition;
  CondExists:='EXISTS(SELECT * FROM '+AddPrefix(TableName)+AsContext+Alias+Condition+')';
end;

function TSQL.CondLike(Field,Value:string;cs:integer):string;
begin
  Field:=Keyword(Field);
  if cs=1 then
    begin
      Field:=UpperCase(Field);
      Value:=UpperCase(Value);
    end;
  CondLike:=Field+' LIKE '+Value;
end;

function TSQL.CondIn(Field1,TableName,Alias,Field2:TSQLString;Condition:string):string;
begin
  if Condition<>'' then
    Condition:=' WHERE '+Condition;
  CondIn:=Keyword(Field1)+' IN (SELECT '+Keyword(Field2)+' FROM '+
              AddPrefix(TableName)+AsContext+Alias+Condition+')';
end;

function TSQL.CondDate(Field,Oper:String;dt:TDateTime):string;
begin
  CondDate:=Keyword(Field)+Oper+ConvertToDate2(MakeStr(FormatDateTime('YYYY-MM-DD',dt)))
end;

function TSQL.SetDate(Field:string;dt:TDateTime):string;
begin
  SetDate:=CondDate(Field,'=',dt)
end;

function TSQL.ConnectCount:longint;
var q:TQuery;
begin
  q:=RunFunction('db_property','''ConnCount''','TempVar');
  if q.eof then
    ConnectCount:=0
  else
    ConnectCount:=q.FieldByName('TempVar').AsInteger;
  q.Free
end;

function TSQL.ChangePassword(uid,pwd:string):integer;
var s:string;
begin
  s:='GRANT CONNECT TO "'+uid+'" ';
  if pwd<>'' then
    s:=s+'IDENTIFIED BY "'+pwd+'"';
  ChangePassword:=ExecOneSQL(s)
end;

function TSQL.DuplicateChar(Value:string;Ch:char):string;
var s:string;
    i:integer;
begin
  s:='';
  repeat
    i:=pos(ch,Value);
    if i<>0 then
      begin
        s:=s+Copy(Value,1,i-1)+ch+ch;
        SYSTEM.Delete(Value,1,i)
      end
    else
      s:=s+Value
  until i=0;
  DuplicateChar:=s;
end;

function TSQL.MakeStr(Value:string):string;
begin
  MakeStr:=''''+DuplicateChar(Value,'''')+''''
end;

function TSQL.LTrim(Value:string):string;
begin
  LTrim:='LTRIM('+Value+')'
end;

procedure TSQL.SelectBlobField(TableName,Field,Condition:string;Stream:TStream);
var f:TField;
    q:TQuery;
begin
  q:=sql.Select(TableName,Field,Condition,'');
  if Error=0 then
    begin
      f:=q.FieldByName(Field);
      if f is TBlobField then
        TBlobField(f).SaveToStream(Stream);
    end;
  q.Free;
end;

procedure TSQL.UpdateBlobField(TableName,Field,Condition:string;Stream:TStream);
var q:TQuery;
    p:TParam;
begin
  q:=TQuery.Create(Application);
  q.DataBaseName:=DataBaseName;
  p:=TParam.Create(q.Params,ptInput);
  p.Name:='BlobParam';
  p.LoadFromStream(Stream,ftBlob);
  q.SQL.Add('UPDATE '+AddPrefix(TableName)+' SET '+sql.Keyword(Field)+'=:BlobParam');
  AddCondition(q.SQL,Condition);
  Error:=0;
  try
    q.ExecSQL;
  except on ex:EDataBaseError do
    begin
      ErrorMessage:=ex.Message;
{$IfDef SQLDebugFlag}
      PrintError(ErrorMessage,q.SQL);
{$EndIf}
      Error:=1;
    end
  end;
  q.Free;
end;

{------------------------------------------------------------------------}
{                     Extra function's pack (C) by Mihey                 }
{------------------------------------------------------------------------}
{!!! !!!}

function TSQL.MakeKeywordsEx(const Args: array of string): string;
var
  i:   integer;
begin
  Result := '';
  for i:=Low(Args) to High(Args) do
    begin
     Result := Result + Keyword(Args[i]);
     if i < High(Args) then
       Result := Result + ',';
    end;
end;

{------------------------------------------------------------------------}
function TSQL.ValueEx(const Arg: TVarRec): string;
const
 BoolChars: array[Boolean] of Char = ('F', 'T');

 function MakeStr(const S:  string):  string;
 begin
   if (S=Self.CurrentDateTime) or (S='NULL') then
     { keywords }
     Result := s
    else Result := Self.MakeStr(s);
 end;

begin
 Result := '';
 with Arg do
   case VType of
     vtInteger:    Result := IntToStr(VInteger);
     vtBoolean:    Result := BoolChars[VBoolean];

     vtChar:       Result := VChar;
     vtExtended:   Result := FloatToStr(VExtended^);
     vtString:     Result := MakeStr(VString^);
     vtPChar:      Result := MakeStr(VPChar);
     vtObject:     Result := VObject.ClassName;
     vtClass:      Result := VClass.ClassName;
     vtAnsiString: Result := MakeStr(string(VAnsiString));
     vtCurrency:   Result := CurrToStr(VCurrency^);
     vtVariant:    Result := string(VVariant^);
   end; {case}
end;


{------------------------------------------------------------------------}
function TSQL.MakeValuesEx(const Args: array of const): string;
const
 BoolChars: array[Boolean] of Char = ('F', 'T');
var
 i: Integer;
begin
 Result := '';
 for i := Low(Args) to High(Args) do
   begin
     Result := Result + ValueEx(Args[i]);

     if i<High(Args) then
         Result := Result +',';
   end; {for}
end;


{------------------------------------------------------------------------}
function TSQL.InsertEx(const TableName: string; const Fields: array of string;
     const Values: array of const): integer;
var
  sl:   TStringList;
begin
  sl:=TStringList.Create;
  try
    sl.Add('INSERT INTO '+AddPrefix(TableName)+' (');

    sl.Add(MakeKeywordsEx(Fields));
    sl.Add(') VALUES (');
    sl.Add(MakeValuesEx(Values));
    sl.Add(')');
    Result := ExecSQL(sl);
  finally
    sl.Free
  end;
end;

{------------------------------------------------------------------------}
function TSQL.UpdateEx(const TableName: string; const Fields: array of string;
         const Values: array of const; const Condition:  string): integer;
var
  sl:              TStringList;
  i, l, h:         integer;
  s:               string;
begin
  sl:=TStringList.Create;
  try
    sl.Add('UPDATE '+AddPrefix(TableName)+' SET ');

{    l := MaxIntValue([Low(Fields), Low(Values)]);
    h := MinIntValue([High(Fields), High(Values)]);}

    for i := l to h do
      begin
        s := Keyword(Fields[i])+'='+ValueEx(Values[i]);
        if i < h then
          s := s+',';
        sl.Add(s);
      end;

    AddCondition(sl, Condition);
{    if Condition <> '' then
      sl.Add('('+Condition+')');}

    Result := ExecSQL(sl);
  finally
    sl.Free;
  end;
end;

 begin
  sql:=NIL;
end.

