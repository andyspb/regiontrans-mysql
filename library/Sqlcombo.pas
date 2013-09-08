unit Sqlcombo;

interface
Uses TSQLCls,Outline,SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,
     DB,DBTables,Messages,Graphics,Forms,Grids,Menus;

Type TSQLComboBox=class(TComboBox)
      private
        FDSN:TFileName;
        FTable:string;
        FID:string;
        FInfo:string;
        FWhere:string;
        FNotNull:boolean;
        FNullStr:string;
        FNewItemFlag:boolean;
        FOnUserChange:TNotifyEvent;
      protected
        procedure WriteDSN(FN:TFileName);
        procedure WriteTable(FN:string);
        procedure WriteID(FN:string);
        function ReadItemIndex:integer;
        procedure WriteItemIndex(FN:integer);
        procedure WriteInfo(FN:string);
        procedure WriteWhere(FN:string);
        procedure WriteNotNull(FN:boolean);
        procedure KeyPress(Sender:TObject;var Key:char);
        procedure Change(Sender:TObject);
        procedure EvOnDropDown(Sender:TObject);
        procedure CBOnEnter(Sender:TObject);
        procedure CBOnKeyUp(Sender: TObject; var Key: Word;
                              Shift: TShiftState);
      public
        BackUp:Integer;
        substr:string;
        FillFlag:boolean;
        FRedrawOnDropDown:boolean;
        fSortFlag:boolean;
        function GetData:longint;
        procedure SetActive(l:longint);
        procedure SetActiveFirst;
        procedure Recalc;
        procedure RecalcSQL(var sl:TStringList);
        constructor Create(AC:TComponent); override;

      published
        property DatabaseName:TFileName read FDSN write WriteDSN;
        property Table:string read FTable write WriteTable;
        property IDField:string read FID write WriteID;
        property InfoField:string read FInfo write WriteInfo;
        property Where:string read FWhere write WriteWhere;
        property NotNull:boolean read FNotNull write WriteNotNull;
        property NullStr:string read FNullStr write FNullStr;
        property NewItemFlag:boolean read FNewItemFlag write FNewItemFlag;
        property NoSort:boolean read fSortFlag write fSortFlag default FALSE;
        property OnUserChange:TNotifyEvent read FOnUserChange write FOnUserChange;
        property ItemIndex:integer read ReadItemIndex write WriteItemIndex;
    end;

procedure Register;

implementation
uses Wintypes;

procedure Register;
begin
  RegisterComponents('SQLCtrls',[TSQLComboBox])
end;


function TSQLComboBox.GetData:longint;
begin
  if ItemIndex=-1 then GetData:=0
  else
    GetData:=Longint(Items.Objects[ItemIndex])
end;

constructor TSQLComboBox.Create(AC:TComponent);
begin
  inherited Create(AC);
  OnKeyPress:=KeyPress;
  OnChange:=Change;
  FillFlag:=FALSE;
  FNewItemFlag:=FALSE;
  OnDropDown:=EvOnDropDown;
  FRedrawOnDropDown:=true;
  FNotNull:=FALSE;
  NullStr:='';
  OnEnter:=CBOnEnter;
  OnKeyUp:=CBOnKeyUp;
  Recalc
end;

procedure TSQLComboBox.WriteDSN(FN:TFileName);
begin
  FDSN:=FN;
  if (not FRedrawOnDropDown) then Recalc
end;

procedure TSQLComboBox.Change(Sender:TObject);
begin
  substr:='';
  SelStart:=0;
  SelLength:=0;
  if Assigned(FOnUserChange) then FOnUserChange(Sender)
end;

Function UpCaseRus(s:char):char;
begin
  if (s>='a') and (s<='z') then s:=chr(ord('A')+ord(s)-ord('a'))
  else
    if (s>='à') and (s<='ÿ') then s:=chr(ord('À')+ord(s)-ord('à'));
  UpCaseRus:=s
end;

Function UpperCaseRus(s:string):string;
var i:integer;
begin
  for i:=1 to length(s) do
    s[i]:=UpCaseRus(s[i]);
  UpperCaseRus:=s
end;

procedure TSQLComboBox.KeyPress(Sender:TObject;var Key:char);
var i,j:integer;
    s:string;
begin
  if not FillFlag then
    Recalc;
  case Key of
    #27:
      begin
        substr:='';
        ItemIndex:=0;
      end;
    else
      begin
        j:=-1;
        i:=0;
        if Key<>#8 then
          s:=substr+Key
        else
          s:=Copy(substr,1,length(substr)-1);
        while (i<Items.Count) and (j=-1) do
          if pos(UpperCaseRus(s),UpperCaseRus(Items.Strings[i]))=1 then j:=i
          else inc(i);
        Key:=#0;
        if not NotNull and (s='') then j:=0;
        if NewItemFlag or (j<>-1)then
          begin
            ItemIndex:=j;
            substr:=s;
            if j=-1 then Text:=s;
            if Assigned(FOnUserChange) then FOnUserChange(Sender)
          end
      end
  end;
  SelStart:=0;
  SelLength:=length(substr)
end;

procedure TSQLComboBox.WriteTable(FN:string);
begin
  FTable:=FN;
  if (not FRedrawOnDropDown) then Recalc
end;

procedure TSQLComboBox.WriteID(FN:string);
begin
  FID:=FN;
  if (not FRedrawOnDropDown) then Recalc
end;

procedure TSQLComboBox.WriteInfo(FN:string);
begin
  FInfo:=FN;
  if (not FRedrawOnDropDown) then Recalc
end;

procedure TSQLComboBox.WriteWhere(FN:string);
begin
  FWhere:=FN;
  if (not FRedrawOnDropDown) then Recalc
end;

procedure TSQLComboBox.WriteNotNull(FN:boolean);
begin
  FNotNull:=FN;
  if (not FRedrawOnDropDown) then Recalc
end;

procedure TSQLComboBox.SetActive(l:longint);
var i,t,r:longint;
BEGIN
  if not FillFlag then
    Recalc;
  t:=Items.Count-1;
  r:=-1;
  for i:=0 to t do
    if Longint(Items.Objects[i])=l then
      begin
        r:=i;
        break
      end;
  if r=-1 then r:=0;
  ItemIndex:=r
end;

procedure TSQLComboBox.SetActiveFirst;
BEGIN
  if not FillFlag then
    Recalc;
  ItemIndex:=0
end;

procedure TSQLComboBox.Recalc;
var q  :TQuery;
    l,i:longint;
    s:string;
    f1,f2:TField;
begin
  if (DatabaseName<>'') and (Table<>'') and (IDField<>'') and
     (InfoField<>'') then
  begin
     Items.Clear;
     if not NotNull then
       Items.AddObject(NullStr,Pointer(0));
     if not NoSort then
       s:=SQL.KeyWord(InfoField)
     else
       s:='';

     q:=sql.Select(Table+' CMB','',Where,s);
     f1:=q.FieldByName(IDField);
     f2:=q.FieldByName(InfoField);
     while not q.eof do
     begin
       i:=f1.AsInteger;
       l:=Items.AddObject(f2.AsString,Pointer(i));
       q.Next
     end;
     q.Free;
     substr:='';
     SelStart:=0;
     SelLength:=0;
     FillFlag:=TRUE
  end
end;

procedure TSQLComboBox.RecalcSQL(var sl:TStringList);
var q  :TQuery;
    l,i:longint;
    f1,f2:TField;
begin
  if (DatabaseName<>'') and (Table<>'') and (IDField<>'') and (InfoField<>'')  then
  begin
     Items.Clear;
     if not NotNull then
       Items.AddObject(NullStr,Pointer(0));
     q:=TQuery.Create(Application);
     if Session.DataBaseCount=0 then  q.DatabaseName:=DatabaseName
     else  q.DatabaseName:=Session.DataBases[0].AliasName;
     q.SQL.AddStrings(sl);
     if not NoSort then
       q.SQL.Add('ORDER BY '+InfoField);
     q.Open;
     f1:=q.FieldByName(IDField);
     f2:=q.FieldByName(InfoField);
     while not q.eof do
     begin
       i:=f1.AsInteger;
       l:=Items.AddObject(f2.AsString,Pointer(i));
       q.Next
     end;
     q.Free;
     substr:='';
     SelStart:=0;
     SelLength:=0;
     FillFlag:=TRUE
  end
end;

procedure TSQLComboBox.EvOnDropDown(Sender:TObject);
begin
  if not FillFlag then
    Recalc
end;

procedure TSQLComboBox.CBOnEnter(Sender:TObject);
begin
  SetFocus;
  BackUp:=ItemIndex
end;

procedure TSQLComboBox.CBOnKeyUp(Sender: TObject; var Key: Word;
                Shift: TShiftState);
begin
  if key=VK_ESCAPE then
    ItemIndex:=BackUp
end;

function TSQLComboBox.ReadItemIndex:integer;
begin
  ReadItemIndex:=inherited ItemIndex;
end;

procedure TSQLComboBox.WriteItemIndex(FN:integer);
begin
  inherited ItemIndex:=FN;
  if Assigned(FOnUserChange) then OnUserChange(self);
end;

end.
