unit SEQUENCE;

interface

uses DBTables,Classes,Forms,DB,SysUtils,tsqlcls;
             



         
         procedure CreateSeq(name:String;init,step:integer);
{         procedure ResetSeq(name:String);  }
         procedure SetCVSeq(name:String;value:integer);
         function NVSeq(Name:String):longint;
    {     procedure DelSeq(name:String); }



implementation

procedure CreateSeq(name:String;init,step:integer);

var
     newident:longint;
begin
  newident := sql.FindNextInteger('Ident','SEQ','',maxint);
  sql.InsertString('SEQ','Ident,Name,Initial,Step,CurValue',
    InttoStr(newident)+ ','''+ name +''','+ InttoStr(init) +','
     + InttoStr(Step)+','+ InttoStr(init))
end;
function NVSeq(Name:String):longint;
var
     newident:longint;
     q:tquery;
     ID: LongInt;
     s:string;
     i:integer;
begin
  s:=   ' Name='''+ name + '''';
     q:= sql.select('SEQ','Ident,Step,CurValue',
            s,'');
  ID := q.fieldbyname ('Ident').asinteger;
  i:=1;
  while ( sql.LockRecord('SEQ',
          'Ident',intTostr (ID),'') <> 0  )
          and ( i < 1000 ) do
      i := i + 1;
  if i < 1000 then
   begin
    newident := q.fieldbyname ('CurValue').value;
    NVSeq := newident;
    newident := newident + q.fieldbyname ('Step').value;
    sql.UpdateString('SEQ','curValue='+IntToStr(newident),
          sql.CondIntEqu('Ident',ID))  ;
    sql.Commit
   end
  else NVSeq := -1;
end;

procedure SetCVSeq(name:String;value:integer);
var
//  newident:longint;
  q:tquery;
  ID: LongInt;
  s:string;
  i:integer;
begin
  s:=' Name='''+ name + '''';
  q:=sql.select('SEQ','Ident,CurValue', s,'');
  ID:=q.fieldbyname ('Ident').asinteger;
  i:=1;
  while ( sql.LockRecord('SEQ', 'Ident',intTostr (ID),'') <> 0  )
    and ( i < 1000 ) do
      i := i + 1;
  if i < 1000 then
  begin
    sql.UpdateString('SEQ','curValue='+IntToStr(value),
          sql.CondIntEqu('Ident',ID))  ;
    sql.Commit
  end
end;

begin

end.

