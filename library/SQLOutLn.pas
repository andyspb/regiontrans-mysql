unit SqlOutLn;

interface
Uses
     DB,TSQLCls,WinProcs,
     Outline,SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,
     DBTables,Messages,Graphics,Forms,Grids,Menus;
const
  SORT   = TRUE;
  UNSORT = FALSE;

Type TSQLOutline=class(TOutline)
      private
        FBMPCloseNode:TFileName;
        FBMPOpenNode:TFileName;
        FBMPLeaf:TFileName;

        FTable:string;
        FWhere:string;
        FID:string;
        FParentID:string;
        FInfo:string;
        FRoot:string;
        FRootNoPresent:boolean;
        FAfterRecalc:TNotifyEvent;
        OnExpandOld : EOutlineChange;
      protected
        procedure WriteBMPClose(FN:TFileName);
        procedure WriteBMPOpen(FN:TFileName);
        procedure WriteBMPLeaf(FN:TFileName);
        procedure WriteTable(FN:string);
        procedure WriteRNP(FN:boolean);
        procedure WriteID(FN:string);
        procedure WriteParentID(FN:string);
        procedure WriteInfo(FN:string);
        procedure WriteRoot(FN:string);
        procedure WriteWhere(FN:string);
        procedure WriteOnExpand(ev:EOutlineChange);
        procedure AddNextLevelItems(SortMode : boolean; pos,ParentID : integer);
        procedure CalcNextLevel(Sender: TObject; Index: LongInt);
      public
        SortFlag: boolean;
        procedure Recalc(SortMode: boolean);
        procedure ExpandAll(Sender:TObject);
        procedure CollapseAll(Sender:TObject);
        procedure SortAll(Sender:TObject);
        function GetData:longint;
        procedure SetActive(i:longint);
        constructor Create(AC:TComponent); override;
        destructor Destroy; override;

      published
        property BMPCloseNode:TFileName read FBMPCloseNode write WriteBMPClose;
        property BMPOpenNode:TFileName read FBMPOpenNode write WriteBMPOpen;
        property BMPLeaf:TFileName read FBMPLeaf write WriteBMPLeaf;
        property Table:string read FTable write WriteTable;
        property Where:string read FWhere write WriteWhere;
        property IDField:string read FID write WriteID;
        property ParentIDField:string read FParentID write WriteParentID;
        property InfoField:string read FInfo write WriteInfo;
        property RootName:string read FRoot write WriteRoot;
        property RootNoPresent:boolean read FRootNoPresent write WriteRNP;
        property OnAfterRecalc:TNotifyEvent read FAfterRecalc write FAfterRecalc;

        property Lines;
        property OutlineStyle;
        property OnExpand:EOutlineChange read OnExpandOld write WriteOnExpand;
        property OnCollapse;
        property Options;
        property Style;
        property ItemHeight;
        property OnDrawItem;
        property Align;
        property Enabled;
        property Font;
        property Color;
        property ParentColor;
        property ParentCtl3D;
        property Ctl3D;
        property TabOrder;
        property TabStop;
        property Visible;
        property OnClick;
        property DragMode;
        property DragCursor;
        property OnDragDrop;
        property OnDragOver;
        property OnEndDrag;
        property OnEnter;
        property OnExit;
        property OnMouseDown;
        property OnMouseMove;
        property OnMouseUp;
        property OnDblClick;
        property OnKeyDown;
        property OnKeyPress;
        property OnKeyUp;
        property BorderStyle;
        property ItemSeparator;
        property PicturePlus;
        property PictureMinus;
        property PictureOpen;
        property PictureClosed;
        property PictureLeaf;
        property ParentFont;
        property ParentShowHint;
        property ShowHint;
        property PopupMenu;
        property ScrollBars;
     end;

   PNodeData = ^TNodeData;
   TNodeData = packed record
     Id          : integer;
     expand_flag : boolean;
   end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SQLCtrls',[TSQLOutline])
end;

procedure TSQLOutline.ExpandAll(Sender:TObject);
begin
  FullExpand;
end;

procedure TSQLOutline.CollapseAll(Sender:TObject);
begin
  FullCollapse;
end;

procedure TSQLOutline.SortAll(Sender:TObject);
var l:longint;
begin
  l:=GetData;
  PopupMenu.Items[2].Checked:=not PopupMenu.Items[2].Checked;
  if PopupMenu.Items[2].Checked then
    SortFlag:= SORT
  else
    SortFlag:= UNSORT;
  Recalc(SortFlag);
  FullExpand;
  SetActive(l);
end;

function TSQLOutline.GetData:longint;
begin
  if Items[SelectedItem].Data = nil then
    GetData:= 0
  else
    GetData:= PNodeData(Items[SelectedItem].Data)^.Id;
end;

procedure TSQLOutline.SetActive(i:longint);
var c:longint;
begin
  FullExpand;
  for c:=1 to ItemCount do
    if Items[c].Data = nil then
      begin
        if i = 0 then
          begin
            SelectedItem:=c;
            break
          end
      end
    else
      if PNodeData(Items[c].Data)^.Id = i then
        begin
          SelectedItem:=c;
          break
        end
end;

constructor TSQLOutline.Create(AC:TComponent);
var im:TMenuItem;
begin
  inherited Create(AC);
  PopupMenu:=TPopupMenu.Create(AC);
  im:=TMenuItem.Create(PopupMenu);
  im.Caption:='Открыть все';
  PopupMenu.Items.Add(im);
  im.OnClick:=ExpandAll;
  im:=TMenuItem.Create(PopupMenu);
  im.Caption:='Закрыть все';
  im.OnClick:=CollapseAll;
  PopupMenu.Items.Add(im);
  im:=TMenuItem.Create(PopupMenu);
  im.Caption:='Сортировать';
  im.OnClick:=SortAll;
  im.Checked:=TRUE;
  PopupMenu.Items.Add(im);
  OnExpandOld:= nil;
  inherited OnExpand:= CalcNextLevel;
  SortFlag:= SORT;
  Recalc(SortFlag);
end;

destructor TSQLOutline.Destroy;
var
  i : integer;
begin
  for i:=1 to ItemCount do
    if Items[i].Data <> nil then
      freemem(Items[i].Data,sizeof(TNodeData));
  inherited Destroy;
end;

procedure TSQLOutline.WriteBMPClose(FN:TFileName);
var
  i:Byte;
begin
  FBMPCloseNode:=FN+#0;
  i:=Pos('.',FBMPCloseNode);
  if i>0 then
    FBMPCloseNode[i]:='_';
  try
    PictureClosed.handle:=LoadBitMap(HInstance,@FBMPCloseNode[1])
  except
  end
end;

procedure TSQLOutline.WriteBMPOpen(FN:TFileName);
var
  i:Byte;
begin
  FBMPOpenNode:=FN+#0;
  i:=Pos('.',FBMPOpenNode);
  if i>0 then
    FBMPOpenNode[i]:='_';
  try
    PictureOpen.handle:=LoadBitMap(HInstance,@FBMPOpenNode[1])
  except
  end
end;

procedure TSQLOutline.WriteBMPLeaf(FN:TFileName);
var
  i:Byte;
begin
  FBMPLeaf:=FN+#0;
  i:=Pos('.',FBMPLeaf);
  if i>0 then
    FBMPLeaf[i]:='_';
  try
    PictureLeaf.handle:=LoadBitMap(HInstance,@FBMPLeaf[1])
  except
  end
end;

procedure TSQLOutline.WriteTable(FN:string);
begin
  FTable:=FN;
  Recalc(SORT);
end;

procedure TSQLOutline.WriteRNP(FN:boolean);
begin
  FRootNoPresent:=FN;
  Recalc(SORT)
end;

procedure TSQLOutline.WriteID(FN:string);
begin
  FID:=FN;
  Recalc(SORT)
end;

procedure TSQLOutline.WriteParentID(FN:string);
begin
  FParentID:=FN;
  Recalc(SORT)
end;

procedure TSQLOutline.WriteInfo(FN:string);
begin
  FInfo:=FN;
  Recalc(SORT)
end;

procedure TSQLOutline.WriteRoot(FN:string);
begin
  FRoot:=FN
end;

procedure TSQLOutline.CalcNextLevel(Sender: TObject; Index: LongInt);
var
  Id  : integer;
  pos : integer;
  level : word;
begin
  if Items[Index].Data <> nil then
    if not PNodeData(Items[Index].Data)^.expand_flag then
    begin
      PNodeData(Items[Index].Data)^.expand_flag:= TRUE;
      if Items[Index].HasItems then
        begin
          {for all children}
          pos:= Items[Index].GetFirstChild;
          level:= Items[pos].Level;
          while (pos+1 <= ItemCount) and (level = Items[pos+1].Level) do
           inc(pos);
          while pos <> -1 do
            begin
              Id:= PNodeData(Items[pos].Data)^.Id;
              AddNextLevelItems(SortFlag,pos,Id);
              pos:= Items[Index].GetPrevChild(pos);
            end;
        end;
    end;
  if Assigned(OnExpandOld) then
    OnExpandOld(Sender,Index);
end;

procedure TSQLOutline.AddNextLevelItems(SortMode : boolean; pos,ParentID : integer);
var
  q : TQuery;
  str_where : string;
  str_sort  : string;
  NodeData  : PNodeData;
begin
  if SortMode then
    str_sort:= sql.Keyword(InfoField)
  else
    str_sort:= '';
  str_where:= sql.CondIntEqu(ParentIDField,ParentID);
  if where <> '' then
    str_where:= str_where + LogAND + where;
  q:=sql.Select(Table,sql.Keyword(IDField)+','+sql.Keyword(InfoField),
                 str_where,str_sort);
  q.First;
  while not q.eof do
    begin
      getmem(NodeData,sizeof(TNodeData));
      NodeData^.Id:= q.FieldByName(IDField).AsInteger;
      NodeData^.expand_flag:= FALSE;
      AddChildObject(pos,q.FieldByName(InfoField).AsString,NodeData);
      q.Next;
    end;
  q.Free;
end;

procedure TSQLOutline.Recalc(SortMode : boolean);
var
  pos,pos1 : longint;
  q: TQuery;
  str_sort  : string;
  str_where : string;
  NodeData  : PNodeData;
begin
  if (Table<>'') and (IDField<>'') and (ParentIDField<>'') and
       (InfoField<>'') and (sql<>NIL) then
  begin
    Clear;
    if not FRootNoPresent then
      pos:= AddChildObject(0,RootName,nil)
    else
      pos:= 0;
    if SortMode then
      str_sort:= sql.Keyword(InfoField)
    else
      str_sort:= '';
    str_where:= sql.CondNull(ParentIDField);
    if where <> '' then
      str_where:= str_where + LogAND + where;

    q:=sql.Select(Table,sql.Keyword(IDField)+','+sql.Keyword(InfoField),
                  str_where,str_sort);
    q.First;
    while not q.eof do
      begin
        { add first level item }
        getmem(NodeData,sizeof(TNodeData));
        NodeData^.Id:= q.FieldByName(IDField).AsInteger;
        NodeData^.expand_flag:= FALSE;
        pos1:= AddChildObject(pos,q.FieldByName(InfoField).AsString,NodeData);
        AddNextLevelItems(SortMode,pos1,NodeData.Id);
        q.Next;
      end;
    q.Free;

    if Assigned(FAfterRecalc) then OnAfterRecalc(self);
  end
end;

procedure TSQLOutline.WriteWhere(FN:string);
begin
  FWhere:=FN;
  Recalc(SORT);
end;

procedure TSQLOutline.WriteOnExpand(ev:EOutlineChange);
begin
  OnExpandOld:=ev;
end;

end.
