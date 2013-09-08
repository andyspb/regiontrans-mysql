unit FiltrFrm;

interface 
uses
  Tadjform, CommFunc, OperType, guiview, guifield,tenvirnt,
  Outline,SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,
  DB,TSQLCls,DBTables,DBGrids,Messages,Graphics,Forms,Grids,Menus,WinProcs,
  IniFiles,WinTypes, BmpBtn, Dialogs, DBCtrls, LblCombo, ParamEnt,
  Sqlctrls, LblMemo, Lbledit;

Const
IniFileName = 'searchgr.ini';
sFonts      = 'Font';
sRowCount   = 'RowCount';
sFilterWithoutName = 'Фильтр без имени';
sFilterFormSection = 'FilterFormSection';
Filtr_SQL    = 1;
Filtr_Table  = 2;


FieldName      ='Имя';
FieldValue     ='Значение';
FieldParam     ='Параметр';

Type TFullTextQueryEvent=procedure (Sender:TObject;t:string;sl:TStrings) of object;
type TFilterForm=class(TAdjustForm)
        btOk         :TBmpBtn;
        btCancel     :TBmpBtn;
        btCreate     :TBmpBtn;
        btOpen       :TBmpBtn;
        btSave       :TBmpBtn;

        cbFields     :TCombobox;
        cbRelOpers   :TCombobox;
        cbValueMode  :TCombobox;
        cbValue      :TCombobox;
        cbLogOpers   :TCombobox;
        cbViews      :TComboBox;

        SearchGrid   :TStringGrid;
        OldSearchGrid:TStringGrid;

        procedure btOkOnClick(Sender:TObject);
        procedure btCancelOnClick(Sender:TObject);
        procedure btCreateOnClick(Sender:TObject);
        procedure btSaveOnClick(Sender:TObject);

        procedure cbViewsOnChange(Sender: TObject);
        procedure cbFieldsOnChange(Sender:TObject);
        procedure cbRelOpersOnChange(Sender:TObject);
        procedure cbValueModeOnChange(Sender:TObject);
        procedure cbValueOnChange(Sender:TObject);
        procedure cbValueOnDropDown(Sender: TObject);
        procedure cbLogOpersOnChange(Sender:TObject);
        procedure cbValueOnExit(Sender:TObject);

        procedure AddString(Sender:TObject);
        procedure DeleteString(Sender:TObject);
        procedure InsertString(Sender:TObject);

        procedure btOpenOnClick(Sender:TObject);

        procedure FormCreate(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure FormOnResize(Sender:TObject);
        procedure FormShow(Sender: TObject);

        procedure SGMouseUp(Sender: TObject; Button: TMouseButton;
			    Shift: TShiftState; X, Y:Integer);
        procedure SGMouseDown(Sender: TObject; Button: TMouseButton;
			    Shift: TShiftState; X, Y:Integer);
        procedure SGTLChanged(Sender: TObject);
        procedure SearchGridOnSelectCell(Sender: TObject; Col, Row: Longint;
	                                         var CanSelect: Boolean);
      private
        View          : TGUIView;
{        FilterCaption : TName;}
        ValueView     : TName;
        ValueField    : TName;
        AliasName     : TName;
        cbList        : array [0..5] of TCombobox;
        CB            : array [1..20] of TLabelComboBox;
        OldCaption,OldFilterName  : string;
        function  GetPreviousView(ActRow:longint):TGUIView;
        procedure UnvisibleCombobox(cb:TCombobox);
        procedure SetField;
        procedure SetRelOper;
        procedure SetValueMode;
        procedure SetValue;
        function  ExecPrepareBlock(var sl: TStringList;Row:longint):longint;
        procedure MoveView;
        procedure ClearRow(Row:longint);
        procedure DeleteEmptyRow;
        procedure SaveRow(BlockID,RowID:longint);
        function  SaveBlock(FilterID,RowID:longint):longint;
        procedure LoadBlock(BlockID,ViewID:longint);
        procedure LoadBlocks(FilterID:longint);
        procedure CBiOnDropDown(Sender:TObject);
        procedure CBiOnExit(Sender:TObject);
        procedure WriteFTF(b:boolean);

      protected
        ChangeValue : Boolean;
        ActivRow    : LongInt;
        procedure ResizeCB;
        procedure FillCBWithValues(var CB:TComboBox;RowNumb:integer);
        function  InitParams:boolean;
      public
        FOnFullText  :TFullTextQueryEvent;
        QueryEnabled :Boolean;
        ViewName     :TName;
        DSN          :String;
        CBStrings    :TStringList;
        DoInitParams :boolean;
        FilterName   :string;
        FilterType   :integer;
        FilterStr    :string;
        CurUserID    :string;
        fFullTextFlag:boolean;

        procedure SetView(v:TGUIView);
        procedure SetAlias(a:TName);
        procedure ClearAllStrings(Sender: TObject);
        procedure AllUnvisible;
        function  ExecPrepare(var sl: TStringList):boolean;
        procedure DoLoadFilter(FilterID:integer;UserID:string);
        procedure BackupFilter;
        procedure DeleteFilter(FilterName:string;UserID:string);
        property FullTextFlag:boolean read fFullTextFlag write WriteFTF;
        function GetDefFilterID:integer;
        procedure SaveFilter(FilterName,CurUserID:string);
      end;


implementation
uses Filtrnam;

{$R *.DFM}

{------------------------------------------------------------------------}
function TFilterForm.GetDefFilterID:integer;
begin
{Get Delault filter for specified user}
  GetDefFilterID:=sql.SelectInteger('VIEWGUIFDefault','FilterID',
             sql.CondIntEqu('UserID',sql.CurrentUserID)+LogAND+
                 sql.CondStr('ViewName','=',ViewName));
end;
{------------------------------------------------------------------------}
procedure TFilterForm.SetAlias(a:TName);
begin
  AliasName:=a+'.';
end;

procedure TFilterForm.SetView(v:TGUIView);
var i: integer;
begin
  View:=v;
  cbViews.Items.Clear;
  cbViews.Items.AddObject('',NIL);
  cbViews.Items.AddObject(v.DisplayLabel,v);
  for i:=0 to v.SearchsCount-1 do
    cbViews.Items.AddObject(v.Searchs[i].DisplayLabel,v.Searchs[i].SearchView);
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.FormCreate(Sender: TObject);
var i: integer;
begin
{  FilterCaption:=sFilterWithoutName;}
  QueryEnabled:=TRUE;
  fFullTextFlag := FALSE;
  Section:=sFilterFormSection;
  FilterName:=sFilterWithoutName;
  SearchGrid.ColCount := 6;
  cbList[0]:=cbViews;
  cbList[1]:=cbFields;
  cbList[2]:=cbRelOpers;
  cbList[3]:=cbValueMode;
  cbList[4]:=cbValue;
  cbList[5]:=cbLogOpers;

  AliasName:='';

  SearchGrid.Rows[0].Strings[0]:='Блок';
  SearchGrid.Rows[0].Strings[1]:='Поисковый реквизит';
  SearchGrid.Rows[0].Strings[2]:='Соотн.';
  SearchGrid.Rows[0].Strings[3]:='Тип правой части';
  SearchGrid.Rows[0].Strings[4]:='Значение реквизита';
  SearchGrid.Rows[0].Strings[5]:='Операция';

  cbValueMode.Items.Add(FieldValue);
  cbValueMode.Items.Add(FieldParam);
  cbValueMode.Items.Add(FieldName);

  SearchGrid.RowCount    := 2;
  for i:=0 to SearchGrid.ColCount-1 do
    SearchGrid.ColWidths[i]:=Formsini.ReadInteger(section,'Col'+IntToStr(i+1)+'Width',100);
  ActivRow := 1;
  for i:=0 to LogOpersCount-1 do
    cbLogOpers.Items.AddObject(LogOpers[i].DisplayLabel, LogOpers[i]);
  caption:='Фильтр '+#39+FilterName+#39;
  ValueView:='';
  ValueField:='';
  CBStrings:=TStringList.Create;
  FilterName:='';
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.FormClose(Sender: TObject; var Action: TCloseAction);
var i:integer;
begin
  if FormsIni<>nil then
    for i:=0 to SearchGrid.ColCount-1 do
      Formsini.WriteInteger(section,'Col'+IntToStr(i+1)+'Width',SearchGrid.ColWidths[i])
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.SGMouseUp(Sender: TObject; Button: TMouseButton;
	    Shift: TShiftState; X, Y:Integer);
begin
  if Button=mbLeft then ResizeCB
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.SGMouseDown(Sender: TObject; Button: TMouseButton;
	    Shift: TShiftState; X, Y:Integer);
begin
  AllUnvisible
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.AllUnvisible;
var i:integer;
begin
  for i:=0 to 5 do
    cbList[i].Visible:=False;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.FormOnResize(Sender:TObject);
begin
  AllUnvisible
end;
{-------------------------------------------------------------------------------}
function TFilterForm.GetPreviousView(ActRow:longint):TGUIView;
var i:longint;
begin
  Result:=NIL;
  for i:=ActRow downto 1 do
    if SearchGrid.Rows[i].Objects[0]<>NIL then
      begin
        GetPreviousView:=TGUIView(SearchGrid.Rows[i].Objects[0]);
        break;
      end;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.UnvisibleCombobox(cb:TCombobox);
begin
  cb.Visible:=FALSE
end;

procedure TFilterForm.ResizeCB;
var
  Rectangle : TRect;
  ActivCol,i: integer;
  v         : TGUIView;
  f         : TGUIField;
  op        : TGUIOperation;
  sl        : TStringList;
begin
  AllUnvisible;
  ActivRow:=SearchGrid.Row;
  ActivCol:=SearchGrid.Col;

  if (ActivCol>=0) and (ActivCol<6) then
    begin
      Rectangle := SearchGrid.CellRect(SearchGrid.Col, SearchGrid.Row);
      cbList[ActivCol].Top    := Rectangle.Top + SearchGrid.Top + 1;
      cbList[ActivCol].Left   := Rectangle.Left + SearchGrid.Left + 1;
      cbList[ActivCol].Height := Rectangle.Bottom - Rectangle.Top;
      cbList[ActivCol].Width  := Rectangle.Right - Rectangle.Left;
      cbList[ActivCol].Visible:= TRUE;
      cbList[ActivCol].SetFocus;
      case ActivCol of
      1: begin
           v:=GetPreviousView(ActivRow);
           cbFields.Items.Clear;
           if v=NIL then
             UnvisibleCombobox(cbFields)
           else
             for i:=0 to v.FieldsCount-1 do
               cbFields.Items.AddObject(v.Fields[i].DisplayLabel,v.Fields[i]);
         end;
      2: begin
               f:=TGUIField(SearchGrid.Rows[ActivRow].Objects[1]);
           cbRelOpers.Items.Clear;
           if f=NIL then
             UnvisibleCombobox(cbRelOpers)
           else
             begin
               sl:=TStringList.Create;
               f.FieldType.GetOpers(sl);
               cbRelOpers.Items.AddStrings(sl);
               sl.Free;
             end;
         end;
      3: begin
           op:=TGUIOperation(SearchGrid.Rows[ActivRow].Objects[2]);
           if (op=NIL) or not (op.RightPartPresent) then
             UnvisibleCombobox(cbValueMode)
            else
           { === Serge ===  Add/Delete "Name" }
             if  not op.RightPartCanBeField then
               begin
                 if cbValueMode.Items.Count>2 then cbValueMode.Items.Delete(2)
               end
             else
                if cbValueMode.Items.Count=2 then cbValueMode.Items.Add(FieldName);
         end;
      4: if SearchGrid.Rows[ActivRow].Strings[3]='' then
           UnvisibleCombobox(cbValue)
         else
           begin
             op:=TGUIOperation(SearchGrid.Rows[ActivRow].Objects[2]);
             cbValue.Style:=csSimple;
             cbValue.Style:=csDropDown;
             if SearchGrid.Rows[ActivRow].Strings[3]=FieldValue then
               if op.RightPartCanBeField then
                 cbValue.Style:=csDropDown
               else
                 cbValue.Style:=csSimple;
             if SearchGrid.Rows[ActivRow].Strings[3]=FieldName then
               begin
                 v:=GetPreviousView(ActivRow);
                 f:=TGUIField(SearchGrid.Rows[ActivRow].Objects[1]);
                 cbValue.Items.Clear;
                 if (v<>NIL) and (f<>NIL) then
                   begin
                     cbValue.Style:=csDropDownList;
                     cbValue.Sorted:=TRUE;
                     for i:=0 to v.FieldsCount-1 do
                       if f.FieldType=v.Fields[i].FieldType then
                         cbValue.Items.AddObject(v.Fields[i].DisplayLabel,v.Fields[i]);
                     ValueField:='';
                     ValueView:=v.PhysicalName;
                   end
                end;
               {=== serge === Set Param values cb}
             if SearchGrid.Rows[ActivRow].Strings[3]=FieldParam then
               begin
                 cbValue.Style:=csDropDown;
                 cbValue.Sorted:=TRUE;
                 ValueField:='';
               end
           end;
      5: begin
           f:=TGUIField(SearchGrid.Rows[ActivRow].Objects[1]);
           if f=NIL then
             UnvisibleCombobox(cbLogOpers)
         end;
      end;
      if cbList[ActivCol].Visible then
        cbList[ActivCol].ItemIndex:=
          cbList[ActivCol].Items.IndexOf(SearchGrid.Rows[ActivRow].Strings[ActivCol]);
      if ActivCol=4 then
        cbList[ActivCol].Text:=SearchGrid.Rows[ActivRow].Strings[ActivCol];
    end;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.SGTLChanged(Sender: TObject);
begin
  ResizeCB
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.FormShow(Sender: TObject);
begin
  BackupFilter;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.BackupFilter;
var i,j:Integer;
begin
  OldSearchGrid.ColCount:=SearchGrid.ColCount;
  OldSearchGrid.RowCount:=SearchGrid.RowCount;
  for i:=1 to SearchGrid.RowCount-1 do
    for j:=0 to SearchGrid.ColCount-1 do
      begin
        OldSearchGrid.Rows[i].Strings[j]:=SearchGrid.Rows[i].Strings[j];
        OldSearchGrid.Rows[i].Objects[j]:=SearchGrid.Rows[i].Objects[j]
      end;
  OldFilterName:=FilterName;
  OldCaption:=Caption
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.btOkOnClick(Sender:TObject);
{var l:longint;
    i:integer; }
begin
  DoInitParams:=true;
{      DeleteFilter(FilterName,CurUserID);
      l:=sql.FindNextInteger('ID','GUIFilter','',MaxLongint);
      sql.InsertString('GUIFilter','ID,DisplayLabel,ViewName,UserID',
             IntToStr(l)+','+sql.MakeStr(FilterName)+','+
             sql.MakeStr(ViewName)+','+CurUserID);
      DeleteEmptyRow;
      if SearchGrid.Rows[1].Objects[0]<>NIL then
        begin
          i:=1;
          while i<SearchGrid.RowCount do
            i:=SaveBlock(l,i);
        end;}
  FilterType:=Filtr_Table;
  SaveFilter(FilterName,CurUserID);
  ModalResult:=mrOk
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.btCancelOnClick(Sender:TObject);
var i,j:Integer;
begin
  FilterName:=OldFilterName;
  Caption:=OldCaption;
  for i:=1 to OldSearchGrid.RowCount-1 do
    for j:=0 to OldSearchGrid.ColCount-1 do
      begin
        SearchGrid.Rows[i].Strings[j]:=OldSearchGrid.Rows[i].Strings[j];
        SearchGrid.Rows[i].Objects[j]:=OldSearchGrid.Rows[i].Objects[j]
      end;
  SearchGrid.RowCount:=OldSearchGrid.RowCount;
  ModalResult:=mrCancel
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.MoveView;
begin
  if (SearchGrid.Row<SearchGrid.RowCount-1) and
    (SearchGrid.Rows[SearchGrid.Row].Objects[0]<>NIL) then
    if SearchGrid.Rows[SearchGrid.Row+1].Objects[0]=NIL then
      begin
        SearchGrid.Rows[SearchGrid.Row+1].Strings[0]:=SearchGrid.Rows[SearchGrid.Row].Strings[0];
        SearchGrid.Rows[SearchGrid.Row+1].Objects[0]:=SearchGrid.Rows[SearchGrid.Row].Objects[0]
      end;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.cbViewsOnChange(Sender: TObject);
begin
  if SearchGrid.Rows[ActivRow].Strings[0]<>cbViews.Text then SearchGrid.Rows[ActivRow].Strings[4]:='';
  if SearchGrid.Rows[SearchGrid.Row].Objects[0]<>cbViews.Items.Objects[cbViews.ItemIndex] then
    if (SearchGrid.Row=1) and (cbViews.ItemIndex=0) then
      DeleteString(NIL)
    else
      begin
        MoveView;
        SearchGrid.Rows[SearchGrid.Row].Strings[0]:=cbViews.Items.Strings[cbViews.ItemIndex];
        SearchGrid.Rows[SearchGrid.Row].Objects[0]:=cbViews.Items.Objects[cbViews.ItemIndex];
        SetField;
      end
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.SetField;
var v:TGUIView;
begin
  v:=GetPreviousView(SearchGrid.Row);
  if v<>NIL then
    begin
      SearchGrid.Rows[SearchGrid.Row].Strings[1]:=v.Fields[0].DisplayLabel;
      SearchGrid.Rows[SearchGrid.Row].Objects[1]:=v.Fields[0];
      SetRelOper;
    end
  else
    ClearRow(SearchGrid.Row);
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.SetRelOper;
var sl: TStringList;
begin
  sl:=TStringList.Create;
  TGUIField(SearchGrid.Rows[SearchGrid.Row].Objects[1]).FieldType.GetOpers(sl);
  if sl.IndexOfObject(SearchGrid.Rows[SearchGrid.Row].Objects[2])=-1 then
    begin
      SearchGrid.Rows[SearchGrid.Row].Strings[2]:=sl.Strings[0];
      SearchGrid.Rows[SearchGrid.Row].Objects[2]:=sl.Objects[0];
    end;
  sl.Free;
  SetValueMode;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.SetValueMode;
var op: TGUIOperation;
  {Setting ValueMode in appropriating with the operation}
  {then calling SetValue if needed}
begin
  op:=TGUIOperation(SearchGrid.Rows[SearchGrid.Row].Objects[2]);
  if op.RightPartPresent then
    begin
      if cbValueMode.ItemIndex<0 then cbValueMode.ItemIndex:=0;
      if not op.RightPartCanBeField or op.RightPartCanBeField and
        (SearchGrid.Rows[SearchGrid.Row].Strings[3]='') then
        SearchGrid.Rows[SearchGrid.Row].Strings[3]:=
                cbValueMode.Items.Strings[cbValueMode.ItemIndex]
              else if SearchGrid.Rows[SearchGrid.Row].Strings[3]=FieldName
                then SetValue;
    end
  else
    begin
      SearchGrid.Rows[SearchGrid.Row].Strings[3]:='';
      SetValue;
    end;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.SetValue;
  {Setting Value in appropriating with the ValueMode}
var f:TGUIField;
begin
  if SearchGrid.Rows[SearchGrid.Row].Strings[3]='' then
    begin
      SearchGrid.Rows[SearchGrid.Row].Strings[4]:='';
      SearchGrid.Rows[SearchGrid.Row].Objects[4]:=NIL
    end
  else
    begin
      f:=TGUIField(SearchGrid.Rows[SearchGrid.Row].Objects[1]);
      if f<>NIL then
        if SearchGrid.Rows[SearchGrid.Row].Strings[3]=FieldValue then
          begin
            SearchGrid.Rows[SearchGrid.Row].Strings[4]:=f.FieldType.DefaultValue;
            SearchGrid.Rows[SearchGrid.Row].Objects[4]:=NIL
          end
        else  {=== Serge === Check if it is parameter}
         if SearchGrid.Rows[SearchGrid.Row].Strings[3]=FieldName then
           begin
             SearchGrid.Rows[SearchGrid.Row].Strings[4]:=f.DisplayLabel;
             SearchGrid.Rows[SearchGrid.Row].Objects[4]:=f;
           end
          else
             begin
               SearchGrid.Rows[SearchGrid.Row].Strings[4]:='';
               SearchGrid.Rows[SearchGrid.Row].Objects[4]:=NIL;
             end
    end
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.cbFieldsOnChange(Sender: TObject);
begin
  if SearchGrid.Rows[ActivRow].Strings[1]<>cbFields.Text then SearchGrid.Rows[ActivRow].Strings[4]:='';
  if SearchGrid.Rows[SearchGrid.Row].Objects[1]<>cbFields.Items.Objects[cbFields.ItemIndex] then
    begin
      SearchGrid.Rows[SearchGrid.Row].Strings[1]:=cbFields.Items.Strings[cbFields.ItemIndex];
      SearchGrid.Rows[SearchGrid.Row].Objects[1]:=TGUIField(cbFields.Items.Objects[cbFields.ItemIndex]);
      SetRelOper;
    end
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.cbRelOpersOnChange(Sender: TObject);
begin
  if SearchGrid.Rows[SearchGrid.Row].Objects[2]<>cbRelOpers.Items.Objects[cbRelOpers.ItemIndex] then
    begin
      SearchGrid.Rows[SearchGrid.Row].Strings[2]:=cbRelOpers.Items.Strings[cbRelOpers.ItemIndex];
      SearchGrid.Rows[SearchGrid.Row].Objects[2]:=cbRelOpers.Items.Objects[cbRelOpers.ItemIndex];
      SetValueMode;
    end
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.cbValueModeOnChange(Sender: TObject);
begin
  if SearchGrid.Rows[SearchGrid.Row].Strings[3]<>cbValueMode.Items.Strings[cbValueMode.ItemIndex] then
    begin
      SearchGrid.Rows[SearchGrid.Row].Strings[3]:=cbValueMode.Items.Strings[cbValueMode.ItemIndex];
      SetValue;
    end
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.cbValueOnChange(Sender: TObject);
begin
  if SearchGrid.Rows[SearchGrid.Row].Strings[3]=FieldValue then
    begin
      SearchGrid.Rows[SearchGrid.Row].Strings[4]:=cbValue.Text;
      SearchGrid.Rows[SearchGrid.Row].Objects[4]:=NIL
    end
  else {===Serge ==== check if this is the Name or Parameter}
   if SearchGrid.Rows[SearchGrid.Row].Strings[3]=FieldName then
    begin
      SearchGrid.Rows[SearchGrid.Row].Strings[4]:=cbValue.Items.Strings[cbValue.ItemIndex];
      SearchGrid.Rows[SearchGrid.Row].Objects[4]:=cbValue.Items.Objects[cbValue.ItemIndex]
    end
      else
        begin
{          SearchGrid.Rows[SearchGrid.Row].Strings[4]:=cbValue.Items.Strings[cbValue.ItemIndex];
          SearchGrid.Rows[SearchGrid.Row].Objects[4]:=NIL;}
        end
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.FillCBWithValues(var CB:TComboBox;RowNumb:integer);
var
    v:TGUIView;
    f:TGUIField;
    q:TQuery;
    t:string[50];
    s:string;
begin
      {Fill cbValue by  Values}
 v:=GetPreviousView(RowNumb);
 if v<>NIL then
   begin
     f:=TGUIField(SearchGrid.Rows[RowNumb].Objects[1]);
     if (ValueView<>v.PhysicalName) or (ValueField<>f.PhysicalName) then
       begin
         CB.Items.Clear;
         CB.Sorted:=FALSE;
         if QueryEnabled then
           begin
             try
               t:=sql.Keyword(f.PhysicalName);
               q:=sql.SelectDistinct(v.PhysicalName,t,'',t);
               q.Open;
               while not q.eof do
                 begin
                   if not q.Fields[0].IsNull then
                     begin
                       s:=q.Fields[0].AsString;
                       if f.SymbolCount<>0 then
                         s:=LTrim(s);
                       CB.Items.Add(s);
                     end;
                   q.Next;
                 end;
               q.Free
             except
             end;
           end;
             ValueField:=f.PhysicalName;
       end
   end;
   ValueView:=v.PhysicalName;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.cbValueOnDropDown(Sender: TObject);
var
    i:integer;
begin
  if SearchGrid.Rows[SearchGrid.Row].Strings[3]=FieldValue then
    begin
      FillCBWithValues(cbValue,SearchGrid.Row);
      cbValue.ItemIndex:=cbValue.Items.IndexOf(SearchGrid.Rows[SearchGrid.Row].Strings[4])
    end
  else
    if SearchGrid.Rows[SearchGrid.Row].Strings[3]=FieldParam then
    begin
      { === Serge === Fill cbValue by Parameters}
{      if (ValueView<>'Параметры для заполнения') then
        begin}
          cbValue.Items.Clear;
          cbValue.Sorted:=TRUE;
          for i:=1 to SearchGrid.RowCount-1 do
            if (SearchGrid.Rows[i].Strings[3]=FieldParam) and
               (SearchGrid.Rows[i].Strings[4]<>'') and
               (cbValue.Items.IndexOf(SearchGrid.Rows[i].Strings[4])<0) then
                cbValue.Items.add(SearchGrid.Rows[i].Strings[4]);
          ValueView:='Параметры для заполнения'
{        end;  }
    end
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.cbLogOpersOnChange(Sender: TObject);
begin
  if cbLogOpers.ItemIndex>=0 then
  if SearchGrid.Rows[SearchGrid.Row].Objects[5]<>cbLogOpers.Items.Objects[cbLogOpers.ItemIndex] then
    begin
      SearchGrid.Rows[SearchGrid.Row].Strings[5]:=cbLogOpers.Items.Strings[cbLogOpers.ItemIndex];
      SearchGrid.Rows[SearchGrid.Row].Objects[5]:=cbLogOpers.Items.Objects[cbLogOpers.ItemIndex];
      if SearchGrid.Row=SearchGrid.RowCount-1 then
        AddString(NIL);
    end
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.ClearRow(Row:longint);
var i:integer;
begin
  for i:=0 to SearchGrid.ColCount-1 do
    begin
      SearchGrid.Rows[Row].Strings[i]:='';
      SearchGrid.Rows[Row].Objects[i]:=NIL;
    end;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.AddString(Sender:TObject);
begin
  AllUnvisible;
  SearchGrid.RowCount:=SearchGrid.RowCount+1;
  ClearRow(SearchGrid.RowCount-1);
  SearchGrid.UpDate;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.DeleteString(Sender:TObject);
var i,j:Integer;
begin
  AllUnvisible;
  if SearchGrid.RowCount=2 then
    ClearRow(1)
  else
    begin
      MoveView;
      for i:=SearchGrid.Row to SearchGrid.RowCount-2 do
        for j:=0 to SearchGrid.ColCount-1 do
          begin
            SearchGrid.Rows[i].Strings[j]:=SearchGrid.Rows[i+1].Strings[j];
            SearchGrid.Rows[i].Objects[j]:=SearchGrid.Rows[i+1].Objects[j];
          end;
      SearchGrid.RowCount:=SearchGrid.RowCount-1;
      SearchGrid.UpDate;
    end
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.InsertString(Sender:TObject);
var i,j:Integer;
begin
  if SearchGrid.Rows[SearchGrid.Row].Objects[1]<>NIL then
    begin
      AllUnvisible;
      SearchGrid.RowCount:=SearchGrid.RowCount+1;
      for i:=SearchGrid.RowCount-2 downto SearchGrid.Row do
        for j:=0 to SearchGrid.ColCount-1 do
          begin
            SearchGrid.Rows[i+1].Strings[j]:=SearchGrid.Rows[i].Strings[j];
            SearchGrid.Rows[i+1].Objects[j]:=SearchGrid.Rows[i].Objects[j];
          end;
      if SearchGrid.Rows[SearchGrid.Row].Objects[5]=NIL then
        begin
          SearchGrid.Rows[SearchGrid.Row].Strings[5]:=cbLogOpers.Items.Strings[0];
          SearchGrid.Rows[SearchGrid.Row].Objects[5]:=cbLogOpers.Items.Objects[0]
        end
    end
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.ClearAllStrings(Sender:TObject);
Var I:Integer;
begin
  DoInitParams:=false;
  FilterStr:='';
  AllUnvisible;
  for i:=1 to SearchGrid.RowCount-1 do
    ClearRow(i);
  SearchGrid.RowCount:=2;
  SearchGrid.UpDate;
{  FullContext.Text:='';}
{  FilterName:=sFilterWithoutName;}
  caption:='Фильтр '+#39+FilterName+#39
end;
{-------------------------------------------------------------------------------}
function TFilterForm.ExecPrepareBlock(var sl: TStringList;Row:longint):longint;
var i  : longint;
    v  : TGUIView;
    f  : TGUIField;
    op : TGUIOperation;
    sv : TGUISearch;
    d  : string;
    t:TStringList;
function GetCurValue(i:integer):string;
begin
  if SearchGrid.Rows[i].Strings[3]=FieldParam then
    GetCurValue:=CBStrings[i-1] else GetCurValue:=SearchGrid.Rows[i].Strings[4]
end;
begin
  { === Serge === Assemble SQL-string }
  Result:=-1;
  v:=TGUIView(SearchGrid.Rows[Row].Objects[0]);
//  f:=TGUIField(SearchGrid.Rows[Row].Objects[1]);
  d:='tttt'+IntToStr(Row);
  if v.GUI_ID=-1 then
      begin {FullText}
        if FullTextFlag and Assigned(FOnFullText){ and (FilterForm.FullContext.Text<>'')} then
          begin
            if sl.Count>1 then sl.Add(LogAND);
            t:=TStringList.Create;
            FOnFullText(self,GetCurValue(Row),t);
            sl.AddStrings(t);
            t.Free
          end;
        ExecPrepareBlock:=Row+1;
      end
  else
begin
   if v=View then
     sl.Add('(')
    else
     begin
      sv:=View.SearchByView(v);
      sl.Add('EXISTS(SELECT * FROM '+sql.AddPrefix(v.PhysicalName)+sql.AsContext+d+
             ' WHERE '+AliasName+sql.KeyWord(sv.FieldView)+'='+d+'.'+
             sql.KeyWord(sv.FieldSearchView)+' AND ');
     end;
  for i:=Row to SearchGrid.RowCount-1 do
    begin
      f:=TGUIField(SearchGrid.Rows[i].Objects[1]);
      if f<>NIL then
        begin
          op:=TGUIOperation(SearchGrid.Rows[i].Objects[2]);
          if SearchGrid.Rows[i].Objects[4]=NIL then
            d:=''
          else
            d:=TGUIField(SearchGrid.Rows[i].Objects[4]).PhysicalName;
            { Convert Grid row to SQL-string }
          sl.Add(op.OperToStr(f.PhysicalName,f.FieldType,
             GetCurValue(i),d,f.SymbolCount));
          if (i+1>=SearchGrid.RowCount) or (SearchGrid.Rows[i+1].Objects[0]<>NIL) then
            begin
              ExecPrepareBlock:=i+1;
              break
            end
          else
            sl.Add(TGUILogicOperation(SearchGrid.Rows[i].Objects[5]).PhysicalName);
        end
    end;
  sl.Add(')');
 end; {if FullText}
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.DeleteEmptyRow;
begin
  if SearchGrid.Rows[SearchGrid.RowCount-1].Objects[1]=NIL then
    begin
      SearchGrid.Row:=SearchGrid.RowCount-1;
      DeleteString(NIL);
    end;
  SearchGrid.Rows[SearchGrid.RowCount-1].Strings[5]:='';
  SearchGrid.Rows[SearchGrid.RowCount-1].Objects[5]:=NIL;
end;
{-------------------------------------------------------------------------------}
{=== serge===}{$F+}
procedure TFilterForm.CBiOnDropDown(Sender:TObject);
  {CB DropDown message handler. Determinates the }
  {CB number and fill it with data}
var
   k:integer;
   t:TComboBox;
begin
   t:=TComboBox(Sender);
   k:=t.tag; {It's the number of the combobox in the window}
   ValueView:='';
   FillCBWithValues(CB[k].ComboBox,k);
end;
procedure TFilterForm.CBiOnExit(Sender:TObject);
 {At CB accepting entered data check is it vailid.}
var
   k:integer;
   f: TGUIField;
   t:TComboBox;
begin
   t:=TComboBox(Sender);
   k:=t.tag; {It's the number of the combobox in the window}
   f:=TGUIField(SearchGrid.Rows[k].Objects[1]);
    if f<>NIL then
      if  not f.FieldType.CheckValue(CB[k].ComboBox.Text) then
        CB[k].ComboBox.Text:=f.FieldType.DefaultValue;
end;
{-------------------------------------------------------------------------------}
{=== serge===}
function TFilterForm.InitParams:boolean;
var
  PE:TParamsEnter;
  i,n,k:integer;
  op:TGUIOperation;
  f: TGUIField;
//  th:integer;
function FindLabel(l:string):integer;
var i:integer;
begin
  for i:=1 to n do
    if l=cb[i].Caption then break;
  if i>n then i:=n;
  if (n>0) and (l=cb[i].Caption) then FindLabel:=i else FindLabel:=0;
end;
begin
  Result:=true;
  for i:=1 to SearchGrid.RowCount-1 do
    if SearchGrid.Rows[i].Strings[3]=FieldParam then break;
  if i>SearchGrid.RowCount-1 then i:=SearchGrid.RowCount-1;
  if SearchGrid.Rows[i].Strings[3]<>FieldParam then exit;
  if SearchGrid.Rows[1].Objects[0]=NIL then exit;

  PE:=TParamsEnter.Create(self);
  PE.Section:='FilterParametersEnter';
  PE.FormResize(self);
{  PE.OnActivate:=PE.FormActivate;}
  PE.Width:=300;
  PE.Caption:=FilterName;

  n:=0;
  for i:=1 to SearchGrid.RowCount-1 do
    begin
      if SearchGrid.Rows[i].Strings[3]=FieldParam then
//       if FindLabel(SearchGrid.Rows[i].Strings[4])=0 then
        begin
          inc(n);
          cb[n]:=TLabelComboBox.Create(PE.Client);
          cb[n].Parent:=PE.Client;
          cb[n].Caption:=SearchGrid.Rows[i].Strings[4];
          cb[n].Combobox.OnDropDown:=CBiOnDropDown;
          cb[n].Combobox.OnExit:=CBiOnExit;
          cb[n].Combobox.tag:=n;
          f:=TGUIField(SearchGrid.Rows[i].Objects[1]);
          if f<>NIL then CB[n].ComboBox.Text:=f.FieldType.DefaultValue;
          op:=TGUIOperation(SearchGrid.Rows[i].Objects[2]);
          if op.RightPartCanBeField then
              cb[n].ComboBox.Style:=csDropDown
            else
              begin
                cb[n].ComboBox.Style:=csSimple;
                cb[n].ComboBox.onKeyUp:=PE.OnCBKeyUp;
              end
        end;
    end;
  if PE.ShowModal=mrOK then
    begin
      CBStrings.Clear;
      k:=1;
      for i:=1 to SearchGrid.RowCount-1 do
        if SearchGrid.Rows[i].Strings[3]=FieldParam then
         begin
          CBStrings.Add(CB[k{FindLabel(SearchGrid.Rows[i].Strings[4])}].ComboBox.Text);
          inc(k);
         end
         else CBStrings.Add('');
    end else Result:=false;
  PE.free;
end;
{-------------------------------------------------------------------------------}
function TFilterForm.ExecPrepare(var sl: TStringList):boolean;
var i:longint;
begin
  DeleteEmptyRow;
  Result:=true;
  if DoInitParams then if not InitParams then
    begin btCancelOnClick(self); result:=false; exit;end;
  DoInitParams:=false;
  if SearchGrid.Rows[1].Objects[0]<>NIL then
      begin
        i:=1;
        sl.Add('(');
        while i<SearchGrid.RowCount do
          begin
            i:=ExecPrepareBlock(sl,i);
            if i<SearchGrid.RowCount then
              sl.Add(TGUILogicOperation(SearchGrid.Rows[i-1].Objects[5]).PhysicalName)
          end;
        sl.Add(')');
      end;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.cbValueOnExit(Sender:TObject);
var f: TGUIField;
begin
  if SearchGrid.Rows[SearchGrid.Row].Strings[3]=FieldValue then
    begin
      if SearchGrid.Col=4 then cbValue.Style:=csDropDown;
      f:=TGUIField(SearchGrid.Rows[SearchGrid.Row].Objects[1]);
      if f<>NIL then
        if  not f.FieldType.CheckValue(SearchGrid.Rows[SearchGrid.Row].Strings[4]) then
          SearchGrid.Rows[SearchGrid.Row].Strings[4]:=f.FieldType.DefaultValue;
    end;
  if SearchGrid.Rows[SearchGrid.Row].Strings[3]=FieldParam then
    begin
      SearchGrid.Rows[SearchGrid.Row].Strings[4]:=cbValue.Text;
    end;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.btCreateOnClick(Sender:TObject);
begin
  ClearAllStrings(self);
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.LoadBlock(BlockID,ViewID:longint);
var q:TQuery;
    b:boolean;
    v:TGUIView;
    f:TGUIField;
    c,i:longint;
begin
  b:=TRUE;c:=0;v:=nil;
  q:=sql.Select('GUIBlockStr','',sql.Keyword('BlockID')+'='+IntToStr(BlockID),
                sql.Keyword('NumRow'));
  while not q.eof do
    begin
      if b then
        begin
          c:=SearchGrid.RowCount-1;
          v:=Enviroment.ViewByID(ViewID);
          SearchGrid.Rows[c].Strings[0]:=v.DisplayLabel;
          SearchGrid.Rows[c].Objects[0]:=v;
          b:=FALSE;
        end;
      f:=v.FieldByLabel(q.FieldByName('FieldName').AsString);
      SearchGrid.Rows[c].Strings[1]:=f.DisplayLabel;
      SearchGrid.Rows[c].Objects[1]:=f;
      SearchGrid.Rows[c].Strings[2]:=q.FieldByName('RelOper').AsString;
      SearchGrid.Rows[c].Objects[2]:=RelOperByLabel(q.FieldByName('RelOper').AsString);
      SearchGrid.Rows[c].Strings[3]:=q.FieldByName('ValueMode').AsString;
      if SearchGrid.Rows[c].Strings[3]=FieldName then
        begin
          f:=v.FieldByLabel(q.FieldByName('Value').AsString);
          SearchGrid.Rows[c].Strings[4]:=f.DisplayLabel;
          SearchGrid.Rows[c].Objects[4]:=f;
        end
      else
        SearchGrid.Rows[c].Strings[4]:=q.FieldByName('Value').AsString;
      i:=cbLogOpers.Items.IndexOf(q.FieldByName('LogOper').AsString);
      if i<>-1 then
        begin
          SearchGrid.Rows[c].Strings[5]:=cbLogOpers.Items.Strings[i];
          SearchGrid.Rows[c].Objects[5]:=cbLogOpers.Items.Objects[i];
        end;
      q.Next;
      inc(c);
      SearchGrid.RowCount:=SearchGrid.RowCount+1;
      ClearRow(c)
    end;
  q.Free
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.LoadBlocks(FilterID:longint);
var q:TQuery;
begin
  q:=sql.Select('GUIBlock','',sql.Keyword('FilterID')+'='+IntToStr(FilterID),
                sql.Keyword('ID'));
  while not q.eof do
    begin
      LoadBlock(q.FieldByName('ID').AsInteger,q.FieldByName('ViewID').AsInteger);
      q.Next;
    end;
  q.Free
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.DeleteFilter(FilterName:string;UserID:string);
begin
  if UserID<>'NULL' then
    sql.Delete('GUIFilter',
                sql.CondIntEqu('UserID',StrToInt(UserID))+LogAND
               +sql.CondStr('ViewName','=',ViewName)+LogAND
               +sql.CondStr('DisplayLabel','=',FilterName))
      else
    sql.Delete('GUIFilter',
                sql.CondNull('UserID')+LogAND
               +sql.CondStr('ViewName','=',ViewName)+LogAND
               +sql.CondStr('DisplayLabel','=',FilterName));
end;
{-------------------------------------------------------------------------------}
(*procedure TFilterForm.btDeleteOnClick(Sender:TObject);
var s:string;
begin
  s:=Caption;
  ClearAllStrings(self);
  DeleteFilter(s,);
end;*)
{-------------------------------------------------------------------------------}
procedure  TFilterForm.SaveRow(BlockID,RowID:longint);
var  i :longint;
     sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add(IntToStr(BlockID)+','+IntToStr(RowID));
  for i:=1 to 5 do
    sl.Add(','+sql.MakeStr(SearchGrid.Rows[RowID].Strings[i]));
  sql.Insert('GUIBlockStr',
             'BlockID,NumRow,FieldName,RelOper,ValueMode,Value,LogOper',sl);
  sl.Free;
end;
{-------------------------------------------------------------------------------}
function  TFilterForm.SaveBlock(FilterID,RowID:longint):longint;
var  i,l:longint;
begin
  Result:=-1;
  l:=sql.FindNextInteger('ID','GUIBlock','',MaxLongint);
  sql.InsertString('GUIBlock','ID,ViewID,FilterID',
                   IntToStr(l)+','+IntToStr(TGUIView(SearchGrid.Rows[RowID].Objects[0]).ID)+
                   ','+IntToStr(FilterID));
  for i:=RowID to SearchGrid.RowCount-1 do
    begin
      SaveRow(l,i);
      if (i+1>=SearchGrid.RowCount) or (SearchGrid.Rows[i+1].Objects[0]<>NIL) then
        begin
          SaveBlock:=i+1;
          break;
        end;
    end;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.DoLoadFilter(FilterID:integer;UserID:string);
var q:TQuery;
//    sl:TStringList;
begin
 try
  q:=sql.SelectDistinct('GUIFilter','',sql.CondIntEqu('ID',FilterID),'');
  if not q.eof then
    begin
      ClearAllStrings(self);
      Caption:=q.FieldByName('DisplayLabel').AsString;
      if not q.FieldByName('DataSQL').IsNull then
         begin
           FilterType:=Filtr_SQL;
           FilterStr:=q.FieldByName('DataSQL').AsString;
           DoInitParams:=false;
         end
       else
         begin
           FilterType:=Filtr_Table;
           LoadBlocks(q.FieldByName('ID').AsInteger);
           DoInitParams:=true;
         end;
      CurUserID:=UserID;
    end;
  q.Free;
  DeleteEmptyRow;
  FilterName:=Caption;
  Caption:='Фильтр '+#39+Caption+#39;
 except
  ClearAllStrings(self);
 end;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.btOpenOnClick(Sender:TObject);
begin
  ProceedDialog('Открыть фильтр','Открыть','Открыть фильтр',ViewName,true,self,
                 aOpen,FilterName,CurUserID);
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.SaveFilter(FilterName,CurUserID:string);
var l:longint;
    i:integer;
    sl:TStringList;
begin
  DeleteFilter(FilterName,CurUserID);
  l:=sql.FindNextInteger('ID','GUIFilter','',MaxLongint);
  if FilterType=Filtr_SQL then
    begin
     sl:=TStringList.Create;
     sl.Add(IntToStr(l)+','+sql.MakeStr(FilterName)+','+
         sql.MakeStr(ViewName)+','+CurUserID+',');
     sl.Add(sql.MakeStr(FilterStr));
     sql.Insert('GUIFilter','ID,DisplayLabel,ViewName,UserID,DataSQL',sl);
     sl.free;
    end
  else
    begin
      sql.InsertString('GUIFilter','ID,DisplayLabel,ViewName,UserID,DataSQL',
           IntToStr(l)+','+sql.MakeStr(FilterName)+','+
           sql.MakeStr(ViewName)+','+CurUserID+',NULL');
      DeleteEmptyRow;
      if SearchGrid.Rows[1].Objects[0]<>NIL then
        begin
          i:=1;
          while i<SearchGrid.RowCount do
            i:=SaveBlock(l,i);
        end;
    end;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.btSaveOnClick(Sender:TObject);
{var l:longint;
    i:integer;}
begin
  if ProceedDialog('Сохранить фильтр под именем','Сохранить','Сохранить',ViewName,true,self,
                          aSave,FilterName,CurUserID)=mrOk then
    begin
      SaveFilter(FilterName,CurUserID);
      Caption:='Фильтр '+#39+FilterName+#39;
    end;
end;
{-------------------------------------------------------------------------------}
procedure TFilterForm.SearchGridOnSelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
var
  Rectangle: TRect;
begin
  Rectangle := SearchGrid.CellRect(Col, Row);
  CanSelect := SearchGrid.ClientHeight > Rectangle.Bottom
end;

procedure TFilterForm.WriteFTF(b:boolean);
begin
  fFullTextFlag:=b;
{  FullContext.Visible:=b;}
  OnResize(self);
end;

end.
