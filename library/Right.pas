unit Right;

interface

uses
  DBTables,Classes,tSqlCls;

type
  TRight=class(TObject)
  private
    DisplayLabel : String;
    BitMask : LongInt;
    Parent : TRight;
    List : TList;
    function ReadRight(Index:integer):TRight;
    function ReadRightsCount:integer;
    procedure SubTree(q:TQuery;Parent:LongInt);
  public
    ID : LongInt;
    GroupName : String;
    Level : Word;
    Checked : Boolean;
    Constructor Create(aParent:TRight);
    Destructor Destroy; override;
    Procedure BuildTree(st:longint);
    Property Childs[index:INTEGER]:TRight read ReadRight;
    Property ChildsCount:integer read ReadRightsCount;
    Function RightByID(aID:LongInt):TRight;
    Function RightByBitMask(aBitMask:LongInt):TRight;
    Function isChecked(aBitMask:LongInt):Boolean;
    Function ToggleCheck:Boolean;
    Procedure SetCheck(aChecked:Boolean);
    Function GetDisplayLabel:String;
    Procedure Clear;
  end;

implementation

uses DB;

Function TRight.GetDisplayLabel:String;
begin
  GetDisplayLabel:=DisplayLabel
end;

function TRight.ReadRight(Index:integer):TRight;
begin
  ReadRight:=TRight(List.Items[index])
end;

function TRight.ReadRightsCount:integer;
begin
  ReadRightsCount:=List.Count
end;

destructor TRight.Destroy;
var
  i:Integer;
begin
  for i:=0 to ChildsCount-1 do
    Childs[i].Free;
  List.Free;
  inherited Destroy
end;

constructor TRight.Create(aParent:TRight);
begin
  inherited Create;
  List:=TList.Create;
  Parent:=aParent;
  Level:=0;
end;


procedure TRight.BuildTree(st:longint);
var
  q: TQuery;
begin
  q:=sql.Select('FunRight','','','ID');
  subTree(q,st);
  q.Free;
end;

procedure TRight.SubTree(q:TQuery;Parent:LongInt);
var r:TRight;
    i:integer;
  fldParentID,fldID,fldDisplayLabel,fldGroupName,fldBitMask:TField;
begin
  fldParentID:=q.FieldByName('ParentID');
  fldID:=q.FieldByName('ID');
  fldDisplayLabel:=q.FieldByName('DisplayLabel');
  fldGroupName:=q.FieldByName('GroupName');
  fldBitMask:=q.FieldByName('BitMask');
  q.First;
  While Not q.Eof do
  begin
    if (fldParentID.AsInteger=Parent) or (fldParentID.IsNull) and (Parent=0) then
    begin
      r:=TRight.Create(Self);
      List.Add(r);
      r.Level:=Level+1;
      r.ID:=fldID.AsInteger;
      r.DisplayLabel:=fldDisplayLabel.AsString;
      r.GroupName:=fldGroupName.AsString;
      r.BitMask:=fldBitMask.AsInteger;
    end;
    q.Next
  end;
  for i:=0 to ChildsCount-1 do
    Childs[i].SubTree(q,Childs[i].ID);
end;

Function TRight.RightByID(aID:LongInt):TRight;
var
  i : Integer;
  p : Pointer;
begin
  if ID=aID then
    p:=self
  else
  begin
    p:=Nil;
    for i:=0 to ChildsCount-1 do
    begin
      p:=Childs[i].RightByID(aID);
      if p<>nil then
         break
    end
  end;
  RightByID:=p
end;

Function TRight.RightByBitMask(aBitMask:LongInt):TRight;
var
  i : Integer;
  p : Pointer;
begin
  if BitMask=aBitMask then
    p:=self
  else
  begin
    p:=Nil;
    for i:=0 to ChildsCount-1 do
    begin
      p:=Childs[i].RightByBitMask(aBitMask);
      if p<>nil then
         break
    end
  end;
  RightByBitMask:=p
end;

Function TRight.isChecked(aBitMask:LongInt):Boolean;
var
  p : TRight;
begin
  p:=RightByBitMask(aBitMask);
  if p=Nil then
    isChecked:=False
  else
    isChecked:=p.Checked
end;

Procedure TRight.SetCheck(aChecked:Boolean);
var
  i : Integer;
begin
  Checked:=aChecked;
  for i:=0 to ChildsCount-1 do
    Childs[i].SetCheck(aChecked)
end;

Procedure TRight.Clear;
begin
  SetCheck(False)
end;

Function TRight.ToggleCheck:Boolean;
var { Toggle children to}
  b : Boolean;
begin
  b:=not IsChecked(BitMask);
  SetCheck(b);
  ToggleCheck:=b
end;

end.
