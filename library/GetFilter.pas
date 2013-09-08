unit GetFilter;

interface
uses DBTables,TSQLCLS,SysUtils,FiltrFrm,
  Tadjform, CommFunc, OperType, guiview, guifield,tenvirnt;

function GetSQLFilterString(FilterID:integer;MainView:TGUIView;Alias:string;UserID:integer):string;

implementation
var
 AliasName:string;
{------------------------------------------------------------------------}
procedure SetAlias(a:TName);
begin
  AliasName:=a+'.';
end;
{-------------------------------------------------------------------------------}
function LoadBlock(BlockID,ViewID:longint;MainView:TGUIView;var LastLogOper:string):string;
var q:TQuery;
    v:TGUIView;
    f:TGUIField;
    d  : string;
    sv : TGUISearch;
    op : TGUIOperation;
function GetCurValue(i:integer):string;
begin
  GetCurValue:=q.FieldByName('Value').AsString;
end;
begin
  q:=sql.Select('GUIBlockStr','',sql.Keyword('BlockID')+'='+IntToStr(BlockID),
                sql.Keyword('NumRow'));
  Result:='';
  if q.eof then exit;
  v:=Enviroment.ViewByID(ViewID);
  if v=nil then exit;
  d:='tttt'+q.FieldByName('NumRow').AsString;
  if v.GUI_ID=-1 then
      begin {FullText}
(*        if FullTextFlag and Assigned(FOnFullText){ and (FilterForm.FullContext.Text<>'')} then
          begin
            t:=TStringList.Create;
            FOnFullText(self,GetCurValue(Row),t);
            sl.AddStrings(t);
            t.Free
          end;
        ExecPrepareBlock:=Row+1;*)
      end
  else
begin
   if v=MainView then
     Result:=Result+'('
    else
     begin
      sv:=MainView.SearchByView(v);
      Result:=Result+'EXISTS(SELECT * FROM '+sql.AddPrefix(v.PhysicalName)+sql.AsContext+d+
             ' WHERE '+AliasName+sql.KeyWord(sv.FieldView)+'='+d+'.'+
             sql.KeyWord(sv.FieldSearchView)+' AND ';
     end;
  while not q.eof do
    begin
      f:=v.FieldByLabel(q.FieldByName('FieldName').AsString);
      if f<>NIL then
        begin
          op:=RelOperByLabel(q.FieldByName('RelOper').AsString);
          if q.FieldByName('ValueMode').AsString=FieldName then
             d:=q.FieldByName('Value').AsString
          else
             d:='';
          Result:=Result+op.OperToStr(f.PhysicalName,f.FieldType,
             GetCurValue(1),d,f.SymbolCount);
        end;
      LastLogOper:=(q.FieldByName('LogOper').AsString);
      if LastLogOper<>'' then
          LastLogOper:=LogOperByLabel(LastLogOper).PhysicalName;
      q.next;
      if f<>nil then
          if not q.eof then Result:=Result+' '+LastLogOper+' ';
    end;
  Result:=Result+')';
  q.free;
 end; {If FullText}
end;
{-------------------------------------------------------------------------------}
function LoadBlocks(FilterID:integer;MainView:TGUIView):string;
var
  q:TQuery;
  LLO:string;
begin
  q:=sql.Select('GUIBlock','',sql.Keyword('FilterID')+'='+IntToStr(FilterID),
                sql.Keyword('ID'));
  Result:='(';
  while not q.eof do
    begin
      LLO:='';
      Result:=Result+LoadBlock(q.FieldByName('ID').AsInteger,q.FieldByName('ViewID').AsInteger,MainView,LLO);
      q.Next;
      if not q.eof then Result:=Result+' '+LLO+' ';
    end;
  Result:=Result+')';
  q.Free
end;
{-------------------------------------------------------------------------------}
function GetSQLFilterString(FilterID:integer;MainView:TGUIView;Alias:string;UserID:integer):string;
var q:TQuery;
    i:integer;
begin
try
  SetAlias(Alias);
  q:=sql.SelectDistinct('GUIFilter','',sql.CondIntEqu('ID',FilterID),'');
  if not q.FieldByName('DataSQL').IsNull then
      Result:=q.FieldByName('DataSQL').AsString
    else
      Result:=LoadBlocks(FilterID,MainView);
  q.free;
  repeat
    i:=pos('UserID',Result);
    if i>0 then
      begin
        Delete(Result,i,6);
        Insert(IntToStr(UserID),Result,i);
      end;
  until i=0;
except
end;
end;


end.
