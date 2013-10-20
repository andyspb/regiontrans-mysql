Unit TEnvirnt;

Interface
Uses Classes,OperType,DBTables,Forms,TSQLCls,GUIView,SysUtils;
{======================== Enviroment ============================}

Type
    TGUIHeader=class(TObject)
      public
        Section:TName;
        SortMenu:boolean;
        PhysicalAlias:TName;
        View:TGUIView;
        constructor Create(aSection:TName;aSortMenu:boolean;aPA:TName;aView:TGUIView);
    end;

    TEnviroment=class(TObject)
      private
        FViews:TList;
        FHeaders:TList;
        Captions:TStringList;
        function  GetView(Index:integer):TGUIView;
        function  GetHeader(Index:integer):TGUIHeader;
        function  GetCount:integer;
        function  GetHeaderCount:integer;
      public
        property Views[Index:integer]:TGUIView read GetView;
        property ViewsCount:integer read GetCount;
        property Headers[Index:integer]:TGUIHeader read GetHeader;
        property HeadersCount:integer read GetHeaderCount;
        function ViewByName(Name:string):TGUIView;
        function ViewByID(IDVIEW:longint):TGUIView;
        function HeaderByName(Name:string):TGUIHeader;
        function GetCaption(l:longint):string;
        constructor Create;
        destructor Free;
     end;

procedure CreateEnviroment;
procedure FreeEnviroment;

var EnviromentRequests:integer;
    Enviroment:TEnviroment;

Implementation

{======================== Header ============================}
constructor TGUIHeader.Create(aSection:TName;aSortMenu:boolean;aPA:TName;aView:TGUIView);
begin
  Section:=aSection;
  SortMenu:=aSortMenu;
  PhysicalAlias:=aPA;
  View:=aView;
end;

{======================== Enviroment ============================}

constructor TEnviroment.Create;
var q:TQuery;
//    i:integer;
    View:TGUIView;
begin
  CreateOpers;
  FViews:=TList.Create;
  FHeaders:=TList.Create;
  if sql<>NIL then
    begin
       q:=sql.Select('GUIView','','','');
       while not q.eof do
         begin
           FViews.Add(TGUIView.Create(q.FieldByName('ID').AsInteger,
                           q.FieldByName('ViewName').AsString,
                           q.FieldByName('DisplayLabel').AsString));
           q.Next;
         end;
       q.Free;
       q:=sql.Select('GUIField','','',sql.Keyword('DisplayLabel'));
//       q:=sql.Select('GUIField','','','');
//application.messagebox('GUIField','SetFieldsFromFile',0);
       while not q.eof do
         begin
           View:=ViewByID(q.FieldByName('ViewID').AsInteger);
//application.messagebox(pchar('View'+q.FieldByName('ViewID').AsString),'SetFieldsFromFile',0);
           if View<>nil then
begin
//application.messagebox('Add','SetFieldsFromFile',0);
             View.AddField(q.FieldByName('FieldName').AsString,
                           q.FieldByName('DisplayLabel').AsString,
                           q.FieldByName('ViewFieldName').AsString,
                           FieldsTypes[q.FieldByName('FieldTypeID').AsInteger],
                           q.FieldByName('Alignment').AsInteger,
                           q.FieldByName('SymbolCount').AsInteger);
end;
           q.Next;
         end;
       q.Free;
       q:=sql.Select('GUISearchs','','','');
       while not q.eof do
         begin
           View:=ViewByID(q.FieldByName('ViewID').AsInteger);
           if View<>nil then
             begin
               View.AddSearch(ViewByID(q.FieldByName('SearchViewID').AsInteger),
                              q.FieldByName('FieldView').AsString,
                              q.FieldByName('FieldSearchView').AsString);
             end;
           q.Next;
         end;
       q.Free;
       Captions:=TStringList.Create;
       q:=sql.Select('LDCaptions','','',sql.Keyword('ID'));
       while not q.eof do
         begin
           Captions.AddObject(q.FieldByName('Caption').AsString,
                    Pointer(q.FieldByName('ID').AsInteger));
           q.Next;
         end;
       q.Free;
       q:=sql.Select('GUIHeader','','','');
       while not q.eof do
         begin
           FHeaders.Add(TGUIHeader.Create(q.FieldByName('Section').AsString,
                           q.FieldByName('SortMenu').AsString<>'-',
                           q.FieldByName('PhysicalAlias').AsString,
                           ViewByID(q.FieldByName('GUIViewID').AsInteger)));
           q.Next;
         end;
      q.Free;
    end
end;
destructor TEnviroment.Free;
var i:integer;
begin
  for i:=0 to ViewsCount-1 do
    Views[i].Free;
  FViews.Free;
  for i:=0 to HeadersCount-1 do
    Headers[i].Free;
  Captions.Free;
  DestroyOpers;
end;

function  TEnviroment.GetView(Index:integer):TGUIView;
begin
  GetView:=FViews.Items[Index];
end;

function  TEnviroment.GetCount:integer;
begin
  GetCount:=FViews.Count;
end;

function TEnviroment.ViewByName(Name:string):TGUIView;
var i:integer;
begin
  ViewByName:=NIL;
  for i:=0 to ViewsCount-1 do
    if Views[i].PhysicalName=Name then
      begin
        ViewByName:=Views[i];
        break;
      end;
end;

function TEnviroment.ViewByID(IDVIEW:longint):TGUIView;
var i:integer;
begin
  ViewByID:=NIL;
  for i:=0 to ViewsCount-1 do
    if Views[i].ID=IDVIEW then
      begin
        ViewByID:=Views[i];
        break;
      end;
end;

function TEnviroment.GetCaption(l:longint):string;
var i:longint;
begin
  GetCaption:='';
  for i:=0 to Captions.Count-1 do
    if Longint(Captions.Objects[i])=l then
      begin
        GetCaption:=Captions.Strings[i];
        break;
      end;
end;

function  TEnviroment.GetHeaderCount:integer;
begin
  GetHeaderCount:=FHeaders.Count;
end;

function  TEnviroment.GetHeader(Index:integer):TGUIHeader;
begin
  GetHeader:=FHeaders.Items[Index];
end;

function TEnviroment.HeaderByName(Name:string):TGUIHeader;
var i:integer;
begin
  HeaderByName:=NIL;
  for i:=0 to HeadersCount-1 do
    if UpperCase(Headers[i].Section)=UpperCase(Name) then
      begin
        HeaderByName:=Headers[i];
        break;
      end;
end;

procedure CreateEnviroment;
begin
  // EnviromentRequests:=param;
  if EnviromentRequests=0 then
    Enviroment:=TEnviroment.Create;
  inc(EnviromentRequests);
end;

procedure FreeEnviroment;
 begin
   
  if EnviromentRequests<>0 then
    begin
      dec(EnviromentRequests);
      if EnviromentRequests=0 then
        Enviroment.Free;
    end;
 end;
//end.
 begin
  EnviromentRequests:=0;
 //end;
end.









