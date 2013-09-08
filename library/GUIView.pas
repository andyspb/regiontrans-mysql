Unit GUIView;

interface
Uses Classes,OperType,GUIField,GUIBlank,SysUtils;


Type
      TGUISearch=class(TGUIObject)
      public
        FieldView,FieldSearchView:TName;
        SearchView:TGUIObject;
        constructor Create(sv:TGUIObject;dFieldView,dFieldSearchView:string);
     end;

Type TGUIView=class(TGUIObject)
      private
        FID      :longint;
        FFields  :TList;
        FSearchs :TList;
        FBlanks  :TList;
        function  GetField(Index:integer):TGUIField;
        function  GetCount:integer;
        function  GetSearch(Index:integer):TGUISearch;
        function  GetSearchView(Index:integer):TGUIView;
        function  GetSearchsCount:integer;
        function  GetID:longint;
        function  GetBlank(Index:integer):TGUIBlank;
        function  GetBlanksCount:integer;
      public
        property GUI_ID:longint read FID;
        property Fields[Index:integer]:TGUIField read GetField;
        property FieldsCount:integer read GetCount;
        property Searchs[Index:integer]:TGUISearch read GetSearch;
        property SearchsViews[Index:integer]:TGUIView read GetSearchView;
        property SearchsCount:integer read GetSearchsCount;
        property Blanks[Index:integer]:TGUIBlank read GetBlank;
        property BlanksCount:integer read GetBlanksCount;
        property ID:longint read GetID;
        constructor Create(dID:longint;dPhysicalName,dDisplayLabel:string);
        destructor Free;
        procedure AddField(dPhysicalName,dDisplayLabel,dViewFieldName:string;FieldType:TGUIFieldType;
                           Alignment,SymbolCount:longint);
        procedure AddSearch(Search:TGUIView;FieldView,FieldSearchView:string);
        procedure AddBlank(dID:longint;dDisplayLabel:string);
        function  FieldByName(Name:string):TGUIField;
        function  FieldByLabel(Name:string):TGUIField;
        function  SearchByView(View:TGUIView):TGUISearch;
     end;

implementation

{=========================== Search ==========================}
constructor TGUISearch.Create(sv:TGUIObject;dFieldView,dFieldSearchView:string);
begin
  SearchView:=sv;
  PhysicalName:=sv.PhysicalName;
  DisplayLabel:=sv.DisplayLabel;
  FieldView:=dFieldView;
  FieldSearchView:=dFieldSearchView;
end;

{=========================== View ==========================}
constructor TGUIView.Create(dID:longint;dPhysicalName,dDisplayLabel:string);
begin
  FID:=dID;
  DisplayLabel:=dDisplayLabel;
  PhysicalName:=dPhysicalName;
  FFields:=TList.Create;
  FSearchs:=TList.Create;
  FBlanks:=TList.Create;
end;

destructor TGUIView.Free;
var i:integer;
begin
  for i:=0 to FieldsCount-1 do
    Fields[i].Free;
  for i:=0 to SearchsCount-1 do
    Searchs[i].Free;
  for i:=0 to BlanksCount-1 do
    Blanks[i].Free;
  FSearchs.Free;
  FBlanks.Free;
  FFields.Free;
end;


function  TGUIView.GetID:longint;
begin
  GetID:=FID;
end;

function  TGUIView.GetCount:integer;
begin
  GetCount:=FFields.Count;
end;

function  TGUIView.GetField(Index:integer):TGUIField;
begin
  GetField:=FFields.Items[Index];
end;

function  TGUIView.GetSearch(Index:integer):TGUISearch;
begin
  GetSearch:=FSearchs.Items[Index];
end;

function  TGUIView.GetSearchView(Index:integer):TGUIView;
begin
  GetSearchView:=TGUIView(TGUISearch(FSearchs.Items[Index]).SearchView);
end;

function  TGUIView.GetSearchsCount:integer;
begin
  GetSearchsCount:=FSearchs.Count;
end;

function  TGUIView.GetBlank(Index:integer):TGUIBlank;
begin
  GetBlank:=FBlanks.Items[Index];
end;

function  TGUIView.GetBlanksCount:integer;
begin
  GetBlanksCount:=FBlanks.Count;
end;

procedure TGUIView.AddField(dPhysicalName,dDisplayLabel,dViewFieldName:string;FieldType:TGUIFieldType;
                            Alignment,SymbolCount:longint);
begin
  FFields.Add(TGUIField.Create(dPhysicalName,dDisplayLabel,dViewFieldName,FieldType,Alignment,SymbolCount));
end;

procedure TGUIView.AddSearch(Search:TGUIView;FieldView,FieldSearchView:string);
begin
  FSearchs.Add(TGUISearch.Create(Search,FieldView,FieldSearchView));
end;

procedure TGUIView.AddBlank(dID:longint;dDisplayLabel:string);
begin
  FBlanks.Add(TGUIBlank.Create(dID,dDisplayLabel));
end;

function  TGUIView.FieldByName(Name:string):TGUIField;
var i:integer;
begin
  FieldByName:=NIL;
  for i:=0 to FieldsCount-1 do
    if UpperCase(Fields[i].PhysicalName)=UpperCase(Name) then
      begin
        FieldByName:=Fields[i];
        break;
      end;
end;

function  TGUIView.FieldByLabel(Name:string):TGUIField;
var i:integer;
begin
  FieldByLabel:=NIL;
  for i:=0 to FieldsCount-1 do
    if Fields[i].DisplayLabel=Name then
      begin
        FieldByLabel:=Fields[i];
        break;
      end;
end;

function  TGUIView.SearchByView(View:TGUIView):TGUISearch;
var i:integer;
begin
  SearchByView:=NIL;
  for i:=0 to SearchsCount-1 do
    if Searchs[i].SearchView=View then
      begin
        SearchByView:=Searchs[i];
        break;
      end;
end;


End.

