unit Sqllist;

interface
Uses Outline,SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,
     DB,DBTables,Messages,Graphics,Forms,Grids,Menus,TSQLCls;

Type TSQLListBox=class(TListBox)
      private
        FDSN:TFileName;
        FTable:string;
        FID:string;
        FInfo:string;
        FWhere:string;
        fSortFlag:boolean;
        fOnItemChange:TNotifyEvent;
      protected
        procedure WriteDSN(FN:TFileName);
        procedure WriteTable(FN:string);
        procedure WriteID(FN:string);
        procedure WriteInfo(FN:string);
        procedure WriteWhere(FN:string);
        function ReadItemIndex:integer;
        procedure WriteItemIndex(ind:integer);
        procedure EvOnClick(Sender:TObject);
      public
        function GetData:longint;
        procedure SetActive(l:longint);
        procedure Recalc;
        constructor Create(AC:TComponent); override;

      published
        property DatabaseName:TFileName read FDSN write WriteDSN;
        property Table:string read FTable write WriteTable;
        property IDField:string read FID write WriteID;
        property InfoField:string read FInfo write WriteInfo;
        property Where:string read FWhere write WriteWhere;
        property ItemIndex:integer read ReadItemIndex write WriteItemIndex;
        property NoSort:boolean read fSortFlag write fSortFlag default FALSE;
        property OnItemChange:TNotifyEvent read fOnItemChange write fOnItemChange;

    end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MyOwn',[TSQLListBox])
end;


function TSQLListBox.GetData:longint;
begin
  if ItemIndex=-1 then GetData:=0
  else
    GetData:=Longint(Items.Objects[ItemIndex])
end;

constructor TSQLListBox.Create(AC:TComponent);
begin
  inherited Create(AC);
  OnClick:=EvOnClick;
  Recalc
end;

procedure TSQLListBox.WriteDSN(FN:TFileName);
begin
  FDSN:=FN;
  Recalc
end;

procedure TSQLListBox.WriteTable(FN:string);
begin
  FTable:=FN;
  Recalc
end;

procedure TSQLListBox.WriteID(FN:string);
begin
  FID:=FN;
  Recalc
end;

procedure TSQLListBox.WriteInfo(FN:string);
begin
  FInfo:=FN;
  Recalc
end;

procedure TSQLListBox.WriteWhere(FN:string);
begin
  FWhere:=FN;
  Recalc
end;

procedure TSQLListBox.SetActive(l:longint);
var i:longint;
BEGIN
  for i:=0 to Items.Count-1 do
    if Longint(Items.Objects[i])=l then
      begin
        ItemIndex:=i;
        break
      end
end;

procedure TSQLListBox.Recalc;
var q  :TQuery;
    l,i:longint;
    OrderBy:string;
    f1,f2:TField;
begin
  if (DatabaseName<>'') and (Table<>'') and (IDField<>'') and (InfoField<>'') and
     (sql<>NIL) then
  begin
     Items.Clear;
     if not NoSort then
       OrderBy:=sql.Keyword(InfoField)
     else
       OrderBy:='';
     q:=sql.Select(Table,sql.Keyword(IDField)+','+sql.Keyword(InfoField),Where,OrderBy);
     f1:=q.FieldByName(IDField);
     f2:=q.FieldByName(InfoField);
     while not q.eof do
     begin
       i:=f1.AsInteger;
       l:=Items.AddObject(f2.AsString,Pointer(i));
       q.Next
     end;
     q.Free
  end
end;

procedure TSQLListBox.WriteItemIndex(ind:integer);
var l:integer;
begin
  l:=inherited ItemIndex;
  inherited ItemIndex:=ind;
  if (l<>ind) and Assigned(fOnItemChange) then
    OnItemChange(self);
end;

function TSQLListBox.ReadItemIndex:integer;
begin
  ReadItemIndex:=inherited ItemIndex;
end;

procedure TSQLListBox.EvOnClick(Sender:TObject);
begin
  if Assigned(fOnItemChange) then
    OnItemChange(self);
end;

end.
