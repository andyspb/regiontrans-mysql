unit SqlGrid;

interface
Uses
  quikview,DBCtrls,DBPrint, lbdbedit,tenvirnt,userfld,GUIView,OperType,
  scrdgrid, CommFunc, TSQLCls, Filtrfrm,
  Outline,SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,
  DB,DBTables,DBGrids,Messages,Graphics,Forms,Grids,Menus,WinProcs,
  IniFiles,WinTypes,BmpBtn,Dialogs,Filtrnam,oleexcel,QExport;

const
sQueryEnabled='QueryEnabled';
sSortBy     = 'Сортировка по ';
SortAsc     = 'убыванию';
SortDesc    = 'возрастанию';
{sEditFilter = 'Редактировать фильтр';}
sSetFilter  = 'Применить фильтр';
{sChangeFilter='Редактировать фильтр';}

Type TSQLGrid=class(TWinControl)
  private
    Changed       : Boolean;
    SortDirect    : Boolean;
    QuickView     : TQuickView;
    Separator     : TPanel;
    GridWidth     : Real;
    OldX,OldY     : Integer;
    DragFlag      : Boolean;
    FilterFormFlag: Boolean;
    CUserID       : String;

    miSetFilter   : TMenuItem;
    procedure OnDestroyFilterForm(Sender:Tobject);
    function  GetFieldsCount:integer;
    function  GetField(Index:integer):TFieldDescr;
    procedure ClearFields;
    procedure GridOnKeyPress(Sender: TObject; var Key: Word;
                    Shift: TShiftState);
  protected
    fShowPrompt   : Boolean;
    fQueryEnabled : Boolean;
    FilterForm    : TFilterForm;
    FDSN          : String;
    FSection      : String;
    FSortField    : TSQLString;
    FIniFile      : TFileName;
    FOnRowChange  : TNotifyEvent;
    FOnAfterExec  : TNotifyEvent;
    FOnDrawCell   : TNotifyEvent;
    FonimCFClick  : TNotifyEvent;
    View          : TGUIView;
    imClearFilter : TMenuItem;

    procedure WriteShowPrompt(aShowPrompt:Boolean);
    procedure WriteQueryEnabled(aQueryEnabled:Boolean);
    procedure WriteDSN(s:string);
    procedure WriteSection(s:string);
    procedure WriteIF(s:TFileName);
    procedure WritePC(s:boolean);
    Function  ReadPC:boolean;
    procedure WriteRO(s:boolean);
    Function  ReadRO:boolean;
    procedure WriteDblClick(s:TNotifyEvent);
    Function  ReadDblClick:TNotifyEvent;
    procedure DSOnDataChange(Sender:TObject;Field:TField);
    procedure WMSize(var Msg:TMessage); message WM_SIZE;
    procedure SeparatorOnMouseDown(Sender:TObject;Button:TMouseButton;
                         Shift:TShiftState;X,Y:Integer);
    procedure SeparatorOnMouseMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);
    procedure SeparatorOnMouseUp(Sender:TObject;Button:TMouseButton;
                         Shift:TShiftState;X,Y:Integer);
    procedure DrawLine(X,Y:integer);

    procedure PrintOnClick(Sender:TObject);
    procedure SendToExcel(Sender:TObject);
    procedure SendToWord(Sender:TObject);
    procedure BlankPrintOnClick(Sender:TObject);
    procedure btSetFilterOnClick(Sender:TObject);
{    procedure btEditFilterOnClick(Sender:TObject);}
    procedure btClsFilterOnClick(Sender:TObject);
    procedure OnClickExec(Sender:TObject);
    procedure UseFilter(Sender:TObject);
    function ReadFTF:boolean;
    procedure WriteFTF(b:boolean);
    function ReadOnFullText:TFullTextQueryEvent;

  public
    FFields:TList;
    Query:TQuery;
    DS:TDatasource;
    Grid:TScrollDBGrid;
    FSQLStr:TStrings;
    SearchGrid:TStringGrid;
    Point:longint;
    FieldPoint:string;
    RedrawQuickViewFlag:boolean;
    ExecFlag:boolean;
    Header:TGUIHeader;

    constructor Create(AC:TComponent); override;
    destructor Destroy; override;
    procedure ExecSQL(s:TStrings);
    procedure Prepare(s:TStrings);
    procedure SaveFieldsToFile;
    procedure SetFieldsFromFile;
    procedure BuildMenu;
    procedure RedrawMenu;
    procedure ResizeAll;
    procedure SaveMenu;
    procedure SavePoint(Field:string);
    procedure SavePrevPoint(Field:string);
    procedure SaveNextPoint(Field:string);
    procedure LoadPoint(Field:string;l:longint);
    procedure ItemOnShowClick(Sender:TObject);
    procedure ItemOnQuickViewClick(Sender:TObject);
    procedure ItemOnSortClick(Sender:TObject);
    procedure ItemOnSortDirectClick(Sender:TObject);
    procedure GridOnDrawDataCell(Sender:TObject; const Rect: TRect;
                  Field:TField; State: TGridDrawState);
    procedure VisibleFieldByLabel(lbl:string;v:boolean);
    procedure EnableClear(Flag:boolean);
    function  Exec:boolean;
    procedure ExecTable(Table:string);
    procedure ExecTableCond(Table,Cond:string);
    procedure ExecTableCondOrder(Table,Cond,Order:string);
    function FieldByName(FieldName:string):TField;

    property FieldsCount: integer read GetFieldsCount;
    property Fields[Index:integer]: TFieldDescr read GetField;
    procedure ApplyDefFilter;
    procedure WriteOnFullText(FtProc:TFullTextQueryEvent);
  published
   property ShowPrompt : Boolean read fShowPrompt write WriteShowPrompt;
    property QueryEnabled: Boolean read fQueryEnabled write WriteQueryEnabled;
    property DatabaseName:string read FDSN write WriteDSN;
    property Section:string read FSection write WriteSection;
    property IniFile:TFileName read FIniFile write WriteIF;
    property ParentColor:boolean read ReadPC write WritePC;
    property ReadOnly:boolean read ReadRO write WriteRO;
    property SQLStr:TStrings read FSQLStr write Prepare;
    property SortField:TSQLString read FSortField write FSortField;
    property FullTextFlag:boolean read ReadFTF write WriteFTF;
    property Align;
    property Enabled;
    property Visible;
    property PopupMenu;
    property OnDblClick:TNotifyEvent  read ReadDblCLick write WriteDblClick;
    property OnRowChange:TNotifyEvent read FOnRowChange write FOnRowChange;
    property OnDrawCell:TNotifyEvent  read FOnDrawCell  write FOnDrawCell;
    property OnAfterExec:TNotifyEvent  read FOnAfterExec  write FOnAfterExec;
    property onimCFClick:TNotifyEvent  read FonimCFClick write FonimCFClick;

    property OnFullText:TFullTextQueryEvent read ReadOnFullText write WriteOnFullText;

  end;

Var
  SystemDir:TFileName;

procedure Register;

implementation
Uses BlankLst;

procedure TSQLGrid.WriteOnFullText;
begin
  if FilterForm<>nil then FilterForm.FOnFullText:=FtProc;
end;

function TSQLGrid.ReadOnFullText:TFullTextQueryEvent;
begin
  if FilterForm<>nil then
    ReadOnFullText:=FilterForm.FOnFullText
  else
    ReadOnFullText:=NIL
end;

procedure TSQLGrid.EnableClear(Flag:boolean);
begin
  if Flag then
    imClearFilter.Enabled:=Flag;
end;

procedure TSQLGrid.DrawLine(X,Y:integer);
Var DC:HDC;
    hP,OldP:HPEN;
begin
  DC:=GetDC(Handle);
  hP:=CreatePEN(PS_SOLID,2,RGB(0,255,0));
  OldP:=SelectObject(DC,hp);
  SetROP2(DC,R2_XORPEN);
  MoveToEx(DC,X+Separator.Left,0,NIL);
  LineTo(DC,X+Separator.Left,ClientHeight);
  OldX:=X;
  OldY:=Y;
  SelectObject(DC,Oldp);
  DeleteObject(hp);
  ReleaseDC(Handle,DC)
end;

procedure TSQLGrid.SeparatorOnMouseDown(Sender:TObject;Button:TMouseButton;
 Shift:TShiftState;X,Y:Integer);
begin
  if Button=mbLeft then
    begin
      DragFlag:=TRUE;
      DrawLine(X,Y);
      SetCaptureControl(Separator)
    end
end;

procedure TSQLGrid.SeparatorOnMouseMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);
begin
  if DragFlag then
    begin
      DrawLine(OldX,OldY);
      DrawLine(X,Y)
    end
end;

procedure TSQLGrid.SeparatorOnMouseUp(Sender:TObject;Button:TMouseButton;
                       Shift:TShiftState;X,Y:Integer);
var t:integer;
begin
  if DragFlag then
    begin
      DragFlag:=FALSE;
      DrawLine(OldX,OldY);
      SetCaptureControl(NIL);
      t:=X+Separator.Left;
      if t<2 then t:=2;
      if t>ClientWidth-3 then t:=ClientWidth-3;
      GridWidth:=t/ClientWidth;
      ResizeAll
    end
end;

constructor TSQLGrid.Create(AC:TComponent);
{var
  opt:TGridOptions;}
begin
  FSection:='';
  FIniFile:='';
  FSortField:='';
  Query:=TQuery.Create(self);
  Query.Close;
  Query.SQL.Clear;
  FFields:=TList.Create;
  CreateEnviroment;
  Header:=NIL;
  inherited Create(AC);
  Changed:=False;

  Point:=-1;
  QuickView:=TQuickView.Create(self);
  QuickView.Parent:=self;
  Separator:=TPanel.Create(self);
  Separator.Parent:=self;
  GridWidth:=0.66;
  Separator.Cursor:=crHSplit;
  Separator.OnMouseDown:=SeparatorOnMouseDown;
  Separator.OnMouseMove:=SeparatorOnMouseMove;
  Separator.OnMouseUp:=SeparatorOnMouseUp;
  DragFlag:=FALSE;

  FSQLStr:=TStringList.Create;
  FSQLStr.Clear;

  DS:=TDatasource.Create(self);
  DS.DataSet:=Query;
  DS.OnDataChange:=DSOnDataChange;

  Grid:=TScrollDBGrid.Create(self);
  Grid.Parent:=self;
  Grid.DataSource:=DS;
  Grid.Options:=Grid.Options+[dgRowSelect,dgAlwaysShowSelection]-[dgIndicator];
  Grid.PopupMenu:=TPopupMenu.Create(self);
  Grid.OnDrawDataCell:=GridOnDrawDataCell;
  Grid.OnKeyDown:=GridonKeyPress;
  Grid.DefaultDrawing:=FALSE;

  FilterForm:=TFilterForm.Create(Application);
  FilterFormFlag:=TRUE;
  FilterForm.OnDestroy:=OnDestroyFilterForm;
  QuickView.PopupMenu:=Grid.PopupMenu;
  ExecFlag:=TRUE;
  RedrawQuickViewFlag:=TRUE;
end;

procedure TSQLGrid.OnDestroyFilterForm(Sender:Tobject);
begin
  FilterFormFlag:=FALSE;
  FilterForm.CBStrings.free;
end;

destructor TSQLGrid.Destroy;
begin
  SaveFieldsToFile;
  if FilterFormFlag then FilterForm.Free;
  ClearFields;
  FSQLStr.Free;
  FFields.Free;
  FreeEnviroment;
  inherited Destroy
end;

procedure TSQLGrid.ApplyDefFilter;
var
//  q:TQuery;
  FiltrID:integer;
begin
{  q:=sql.Select('ViewGUIFDefault','',sql.CondIntEqu('UserID',UserID)+LogAND+
                             sql.CondStr('ViewName','=',FilterForm.ViewName),'');
  if q.eof then exit;}
  FiltrID:=FilterForm.GetDefFilterID;
{  q.FieldByName('FilterID').AsInteger;
  q.free;}

  FilterForm.DoLoadFilter(FiltrID,FilterForm.CurUserID);
  RedrawQuickViewFlag:=FALSE; {tcpip{PORT=500}
  if Exec then imClearFilter.Enabled:=true;
end;
procedure TSQLGrid.GridOnKeyPress(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((ssCtrl in Shift) and (key=ord('F'))) then ApplyDefFilter;
  if ((ssCtrl in Shift) and (key=ord('C'))) then btClsFilterOnClick(Self);
end;

procedure TSQLGrid.GridOnDrawDataCell(Sender:TObject; const
          Rect: TRect; Field:TField; State: TGridDrawState);
var
  s,s2  : string;
//  buf: Pointer;
  i  : integer;
//  sr : TMemoryStream;
//  t  : integer;
begin
  if Field<>nil then
  begin
    (*if Field is TMemoField then
    begin
      sr:=TMemoryStream.Create;
      try
        TMemoField(Field).SaveToStream(sr);
      except
        i:=0;
      end;
      t:=0;
      sr.Write(t,1);
      s:='';
      buf:=sr.Memory;
      for i:=0 to 255 do
        if (PChar(buf)[i]=#13) and (PChar(buf)[i+1]=#10) or (PChar(buf)[i]=#0) then break
         else s:=s+PChar(buf)[i];
      sr.Free
    end
    else*)
    s2:=Field.AsString;
    s:='';
    for i:=1 to length(s2) do
      if ((s2[i]<>#13) and (s2[i]<>#10)) then s:=s+s2[i];
    if Assigned(FOnDrawCell) and not (gdSelected IN state) then FOnDrawCell(Sender);
    case Field.Alignment of
        taLeftJustify:
          Grid.Canvas.TextRect(Rect,Rect.Left+2,Rect.Top,s);
        taRightJustify:
          Grid.Canvas.TextRect(Rect,Rect.Right-Grid.Canvas.TextWidth(s)-2,Rect.Top,s);
        taCenter:
          Grid.Canvas.TextRect(Rect,(Rect.Right-Grid.Canvas.TextWidth(s)) div 2,Rect.Top,s)
    end
  end
end;

procedure TSQLGrid.WriteQueryEnabled(aQueryEnabled:Boolean);
begin
  fQueryEnabled:=aQueryEnabled;
  FilterForm.QueryEnabled:=aQueryEnabled
end;

procedure TSQLGrid.WriteShowPrompt(aShowPrompt:Boolean);
begin
  fShowPrompt:=aShowPrompt
end;

procedure TSQLGrid.WriteDSN(s:String);
begin
  FDSN:=s;
  if Session.DataBaseCount=0 then
      Query.DatabaseName:=FDSN
  else Query.DatabaseName:=Session.DataBases[0].DataBaseName;
  FilterForm.DSN:=Query.DatabaseName;
end;

procedure TSQLGrid.WriteSection(s:string);
begin
  SaveFieldsToFile;
  Header:=Enviroment.HeaderByName(s);
  FSection:=s;
  FilterForm.btCreateOnClick(self);
  FilterForm.ViewName:=s;
  SetFieldsFromFile
end;

procedure TSQLGrid.WriteIF(s:TFileName);
begin
  FIniFile:=s;
  SetFieldsFromFile
end;

procedure TSQLGrid.ExecSQL(s:TStrings);
begin
  Prepare(s);
  Exec
end;

procedure TSQLGrid.Prepare(s:TStrings);
begin
  FSQLStr.Clear;
  FSQLStr.AddStrings(s)
end;

procedure TSQLGrid.ExecTable(Table:String);
begin
  ExecTableCondOrder(Table,'','');
end;

procedure TSQLGrid.ExecTableCond(Table,Cond:String);
begin
  ExecTableCondOrder(Table,Cond,'');
end;

procedure TSQLGrid.ExecTableCondOrder(Table,Cond,Order:String);
var s:TStringList;
begin
  s:=TStringList.Create;
  s.Add(sql.SelectAllFrom+sql.AddPrefix(Table));
  sql.AddCondition(s,Cond);
  sql.AddOrderBy(s,Order);
  Prepare(s);
  if ExecFlag then
    Exec;
  ExecFlag:=TRUE;
  s.Free
end;

procedure TSQLGrid.DSOnDataChange(Sender:TObject;Field:TField);
begin
  if Assigned(FOnRowChange) and (Field=nil) then
    FOnRowChange(self)
end;

procedure TSQLGrid.SetFieldsFromFile;
var i:integer;
    fl:TIniFile;
    b:boolean;
    f:TFieldDescr;
    s:string[128];
    sl:TStringList;
begin
  if (Header<>NIL) and (IniFile<>'') then
  begin
    fl:=TIniFile.Create(SystemDir+IniFile);
    GridWidth:=fl.ReadInteger('WIDTHS QUICK VIEW',Section,660000000)/1000000000;
    SortDirect:=fl.ReadBool('SORT DIRECT',Section,TRUE);
{***    QueryEnabled:=fl.ReadBool(sQueryEnabled,Section,TRUE);}
    if Header.View<>NIL then
      begin
        View:=Header.View;
        FilterForm.SetView(View);
//        FilterForm.ViewName:=View.PhysicalName;

        if Header.PhysicalAlias<>'' then
          s:=Header.PhysicalAlias
        else
          s:=View.PhysicalName;
        FilterForm.SetAlias(s);
        ClearFields;
        sl:=TStringList.Create;
        fl.ReadSection(Section,sl);
        b:=sl.Count<>0;
        sl.Free;
        for i:=0 to View.FieldsCount-1 do
          begin
            f:=TFieldDescr.Create;
            f.GUIField:=View.Fields[i];
            f.LoadFromStr(fl.ReadString(Section,f.GUIField.PhysicalName,''),b);
            FFields.Add(f);
          end;
        BuildMenu;
        if SQLStr.Count>0 then Exec
      end
    else
      View:=NIL;
    fl.Free
  end
end;

procedure TSQLGrid.BuildMenu;
var i:integer;
    im,imm:TMenuItem;
    f:TFieldDescr;
begin
{PopUp menu for Grid }
  if FieldsCount<>0 then
    begin
      Grid.PopupMenu.Free;
      Grid.PopupMenu:=TPopupMenu.Create(self);

      im:=TMenuItem.Create(Grid.PopupMenu);
      im.Caption:='Показать в списке';
      Grid.PopupMenu.Items.Add(im);

      im:=TMenuItem.Create(Grid.PopupMenu);
      im.Caption:='Показать в QuickView';
      Grid.PopupMenu.Items.Add(im);

      if Header.SortMenu then
       begin
          im:=TMenuItem.Create(Grid.PopupMenu);
          im.Caption:='Сортировать';
          Grid.PopupMenu.Items.Add(im);
          im:=TMenuItem.Create(Grid.PopupMenu);
          if SortDirect then
            im.Caption:='Сортировка по '+SortAsc
          else
            im.Caption:=sSortBy+SortDesc;
            im.OnClick:=ItemOnSortDirectClick;
            Grid.PopupMenu.Items.Add(im);
        end;

{      im:=TMenuItem.Create(Grid.PopupMenu);
      im.Caption:=sEditFilter;
      Grid.PopupMenu.Items.Add(im);
      im.OnClick:=btEditFilterOnClick;
      miSetFilter:=im;}

      im:=TMenuItem.Create(Grid.PopupMenu);
      im.Caption:=sSetFilter;
      Grid.PopupMenu.Items.Add(im);
      im.OnClick:=btSetFilterOnClick;


      im:=TMenuItem.Create(Grid.PopupMenu);
      im.Caption:='Очистить фильтр';
      Grid.PopupMenu.Items.Add(im);
      im.OnClick:=btClsFilterOnClick;
      imClearFilter:=im;
      imClearFilter.Enabled:=false;


      imm:=TMenuItem.Create(Grid.PopupMenu);
      imm.Caption:='Отправить текущую таблицу';
      Grid.PopupMenu.Items.Add(imm);

      im:=TMenuItem.Create(imm);
      im.Caption:='На печать';
      imm.Add(im);
      im.OnClick:=PrintOnClick;

      im:=TMenuItem.Create(imm);
      im.Caption:='В Microsoft Word';
      imm.Add(im);
      im.OnClick:=SendToWord;

      im:=TMenuItem.Create(imm);
      im.Caption:='В Microsoft Excel';
      imm.Add(im);
      im.OnClick:=SendToExcel;

      if View.BlanksCount>0 then
        begin
          im:=TMenuItem.Create(Grid.PopupMenu);
          im.Caption:='Печать бланков';
          Grid.PopupMenu.Items.Add(im);
          im.OnClick:=BlankPrintOnClick;
        end;

      for i:=0 to FieldsCount-1 do
        begin
          f:=Fields[i];
          im:=TMenuItem.Create(Grid.PopupMenu.Items[0]);
          im.Caption:=f.GUIField.DisplayLabel;
          im.Checked:=f.Checked;
          im.OnClick:=ItemOnShowClick;
          Grid.PopupMenu.Items[0].Add(im);

          im:=TMenuItem.Create(Grid.PopupMenu.Items[1]);
          im.Caption:=f.GUIField.DisplayLabel;
          im.Checked:=f.QuickView;
          im.OnClick:=ItemOnQuickViewClick;
          Grid.PopupMenu.Items[1].Add(im);

          if Header.SortMenu then
            begin
              im:=TMenuItem.Create(Grid.PopupMenu.Items[2]);
              im.Caption:=f.GUIField.DisplayLabel;
              im.OnClick:=ItemOnSortClick;
              im.Checked:=f.Sorted;
              Grid.PopupMenu.Items[2].Add(im)
            end
        end
    end
end;

procedure TSQLGrid.ItemOnShowClick(Sender:TObject);
var i:integer;
begin
  if Sender is TMenuItem then
    with Sender As TMenuItem do
    begin
      SaveMenu;
      Checked:=not Checked;
      i:=0;
      while (i<Grid.PopupMenu.Items[0].Count) and
            not (Grid.PopupMenu.Items[0].Items[i].Checked and
             Grid.PopupMenu.Items[0].Items[i].Visible) do
         inc(i);
      if i>=Grid.PopupMenu.Items[0].Count then
               Checked:=TRUE;
      VisibleFieldByLabel(Caption,Checked);
    end
end;

procedure TSQLGrid.VisibleFieldByLabel(lbl:string;v:boolean);
var i:integer;
begin
  for i:=0 to Query.FieldCount-1 do
    if Query.Fields[i].DisplayLabel=lbl then
      Query.Fields[i].Visible:=v;
end;

procedure TSQLGrid.ItemOnSortDirectClick(Sender:TObject);
//var i:integer;
begin
  if Sender is TMenuItem then
    with Sender As TMenuItem do
    begin
      SortDirect:=not SortDirect;
      if SortDirect then
        Caption:=sSortBy+SortAsc
      else
        Caption:=sSortBy+SortDesc;
      RedrawQuickViewFlag:=FALSE;
      Exec
    end
end;

procedure TSQLGrid.ItemOnQuickViewClick(Sender:TObject);
//var i:integer;
begin
  if Sender is TMenuItem then
    with Sender As TMenuItem do
    begin
      Checked:=not Checked;
      SaveMenu;
      RedrawQuickViewFlag:=TRUE;
      RedrawMenu
    end
end;

procedure TSQLGrid.ItemOnSortClick(Sender:TObject);
var i:integer;
begin
  if Sender is TMenuItem then
    with Sender As TMenuItem do
    begin
      Checked:=not Checked;
      for i:=0 to Grid.PopupMenu.Items[2].Count-1 do
        if Sender<>Grid.PopupMenu.Items[2].Items[i] then
          Grid.PopupMenu.Items[2].Items[i].Checked:=FALSE;
      RedrawQuickViewFlag:=FALSE;
      Exec
    end
end;

procedure TSQLGrid.SaveMenu;
var f:TField;
    j:integer;
    fld:TFieldDescr;
begin
  j:=0;
  while j<FieldsCount do
  begin
    fld:=Fields[j];
    f:=fld.Field;
    if f=nil then fld.Checked:=FALSE
    else
      begin
        fld.Checked:=f.Visible;
        fld.QuickView:=Grid.PopupMenu.Items[1].Items[j].Checked;
        if Header.SortMenu then
          fld.Sorted:=Grid.PopupMenu.Items[2].Items[j].Checked;
        fld.Index:=f.Index;
        fld.Width:=f.DisplayWidth;
      end;
    inc(j)
  end
end;

procedure TSQLGrid.SaveFieldsToFile;
var
  s : String;
  j : Integer;
  fl: TIniFile;
begin
  if (IniFile<>'') and (Header<>NIL) and Query.Active then
    begin
      SaveMenu;
      fl:=TIniFile.Create(SystemDir+IniFile);
      fl.WriteInteger('WIDTHS QUICK VIEW',Section,round(GridWidth*1000000000));
      if Header.SortMenu then
        fl.WriteBool('SORT DIRECT',Section,SortDirect);
      for j:=0 to FieldsCount-1 do
        begin
          Fields[j].SaveToStr(s);
          fl.WriteString(Section,Fields[j].GUIField.PhysicalName,s);
        end ;
      fl.Free;
    end;
end;

procedure TSQLGrid.RedrawMenu; { It means FillcbFields }
var
  j: Integer;
  b:boolean;
  f:TFieldDescr;
  t:array[0..100] of integer;
  s:string;
begin
  Query.DisableControls;
  if RedrawQuickViewFlag then
    begin
      QuickView.Clear;
      QuickView.PopupMenu:=Grid.PopupMenu;
    end;
  for j:=0 to Query.FieldCount-1 do
    begin
      t[j]:=-1;
      Query.Fields[j].Visible:=FALSE
    end;
  for j:=0 to FieldsCount-1 do
    begin
      f:=Fields[j];
      if f.GUIField.ViewFieldName='' then
        s:=f.GUIField.PhysicalName
      else
        s:=f.GUIField.ViewFieldName;
      b:=FALSE;
      try
        f.Field:=Query.FieldByName(s);
        b:=TRUE;
      except
        f.Field:=NIL;
      end;
      Grid.PopupMenu.Items[0].Items[j].Visible:=b;
      Grid.PopupMenu.Items[1].Items[j].Visible:=b;
      if b then
        begin
          if f.GUIField.Alignment<>-1 then
            f.Field.Alignment:=TAlignment(f.GUIField.Alignment);
          if RedrawQuickViewFlag then
            begin
              if f.QuickView then
                QuickView.Add(f.GUIField,DS);
            end;
          if (f.Index>-1) and (f.Index<Query.FieldCount) then t[f.Index]:=j;
          if f.Width<>-1 then f.Field.DisplayWidth:=f.Width;
          f.Field.DisplayLabel:=f.GUIField.DisplayLabel;
          f.Field.Visible:=Grid.PopupMenu.Items[0].Items[j].Checked
        end
    end;

  for j:=0 to Query.FieldCount-1 do
    if t[j]<>-1 then
      Fields[t[j]].Field.Index:=j;

  if  RedrawQuickViewFlag then
    QuickView.ResizeAll;
  RedrawQuickViewFlag:=TRUE;
  ResizeAll;
  Query.EnableControls;
end;


(*procedure TSqlGrid.btEditFilterOnClick(Sender:TObject);
var
 i:Integer;
 CurTime:TDateTime;
 rez:Integer;
 Text,Capt:String;
begin
  SaveMenu;
  FilterForm.AllUnvisible;
  rez:=1;
  repeat
    if FilterForm.ShowModal=mrOk then
      begin
        RedrawQuickViewFlag:=FALSE;
        CurTime:=Now;
        Exec;
        if ShowPrompt then
        begin
          Text:='Показать '+IntToStr(Query.RecordCount)+' записей'+#0;
          Capt:='Затраченное время '+TimeToStr(Now-CurTime)+#0;
          rez:=MessageBox(0,@Text[1],@Capt[1],1)
        end     {!!!!!! i never used!!!!!!}
      end
  until rez=1;
  i:=Grid.PopupMenu.Items.IndexOf(miSetFilter)
end;*)

procedure TSqlGrid.btSetFilterOnClick(Sender:TObject);
var
  CurTime:TDateTime;
  rez:Integer;
  Text,Capt:String;
begin
  SaveMenu;
  FilterForm.AllUnvisible;
//  rez:=1;
  FilterForm.BackupFilter;
  if FilterForm.FormsIni.ReadInteger(SctionName,'ActivePage',0)=0 then
       CUserID:=inttostr(sql.CurrentUserID) else CUserID:='NULL';
  if ProceedDialog('Применить фильтр','Применить','Установить фильтр',
                    FilterForm.ViewName,false,FilterForm,
                    aOpen,FilterForm.FilterName,CUserID)=mrOk then
         begin
           RedrawQuickViewFlag:=FALSE;
           CurTime:=Now;
           if Exec then imClearFilter.Enabled:=true;
           if ShowPrompt then
           begin
             Text:='Показать '+IntToStr(Query.RecordCount)+' записей'+#0;
             Capt:='Затраченное время '+TimeToStr(Now-CurTime)+#0;
//             rez:=MessageBox(0,@Text[1],@Capt[1],1)
           end;
         end;
end;

procedure TSqlGrid.btClsFilterOnClick(Sender:TObject);
begin
  FilterForm.btCreateOnClick(self);
  RedrawQuickViewFlag:=FALSE;
  if assigned(FonimCFClick) then FonimCFClick(Sender);
  Exec;
  imClearFilter.Enabled:=false;
end;


function TSqlGrid.Exec:boolean;
var
  f : TFieldDescr;
  nORDER_BY,nWHERE,k,j : Integer;
  sl : TStringList;
  s,fn : String;
  b:boolean;
begin
  SaveMenu;
  sl:=TStringList.Create;
  b:=FilterForm.DoInitParams;
  result:=true;
  if FilterForm.FilterType=Filtr_SQL then
    begin if FilterForm.FilterStr<>'' then sl.Add(FilterForm.FilterStr); end
     else
       if not FilterForm.ExecPrepare(sl) then begin result:=false;exit;end;
(*  if FullTextFlag and Assigned(FOnFullText){ and (FilterForm.FullContext.Text<>'')} then
    begin
      if sl.Count>0 then
        sl.Add(LogAND);
      t:=TStringList.Create;
      OnFullText(self,FilterForm.FullContext.Text,t);
      sl.AddStrings(t);
      t.Free
    end;*)
  Query.DisableControls;
  Query.SQL.Clear;
  Query.SQL.AddStrings(SQLStr);
  if sl.Count>0 then
    begin
      nWHERE:=ExtPos('WHERE',SQLStr);
      nORDER_BY:=ExtPos('ORDER BY',SQLStr);
      if nORDER_BY=-1 then
      begin
        if nWHERE=-1 then
      {1-ый случай : нет ни WHERE, ни ORDER BY }
              Query.SQL.Add('WHERE')
        else
      {2-ый случай : есть WHERE, но нет ORDER BY }
              Query.SQL.Add('AND');
        Query.SQL.AddStrings(sl)
      end else
      begin
        if nWHERE=-1 then
      {3-ый случай : нет WHERE,есть ORDER BY }
              Query.SQL.Insert(nOrder_By,' WHERE ')
        else
      {4-ый случай : есть WHERE, есть ORDER BY }
              Query.SQL.Insert(nOrder_By,' AND ');
        for k:=0 to Sl.Count-1 do
          Query.SQL.Insert(nOrder_By+k+1,sl.Strings[k]);

      end
    end;
  if Header<>NIL then
    if Header.SortMenu then
      begin
        s:='';
        j:=0;
        while j<FieldsCount do
        begin
          f:=Fields[j];
          fn:=sql.Keyword(f.GUIField.PhysicalName);
          if Grid.PopupMenu.Items[2].Items[j].Checked and
            Grid.PopupMenu.Items[2].Items[j].Visible then
          begin
            if s='' then  s:=s+' ORDER BY '
            else  s:=s+',';
            if f.GUIField.FieldType=FieldsTypes[4] then
              s:=s+sql.SortLongString(fn)
            else
              s:=s+fn;
            if SortDirect then  s:=s+' ASC '
            else  s:=s+' DESC '
          end;
          inc(j)
        end;
        if SortField<>'' then
          begin
            if s='' then  s:=s+' ORDER BY '
            else  s:=s+',';
            s:=s+sql.KeyWord(SortField);
            if SortDirect then  s:=s+' ASC '
            else  s:=s+' DESC '
          end;
        if s<>'' then Query.SQL.Add(s)
      end;
  Query.Open;
  LoadPoint(FieldPoint,Point);
  RedrawMenu;
  Query.EnableControls;
  sl.Free;
  {*** Grid.Reinit(Query.SQL);}
  if Assigned(FOnAfterExec) then
    FOnAfterExec(self)
end;

procedure TSQLGrid.OnClickExec(Sender:TObject);
begin
  Exec
end;

procedure TSQLGrid.UseFilter(Sender:TObject);
begin
  if FilterForm.ShowModal=mrOk then Exec
end;

{=========================================================}
procedure TSQLGrid.WMSize(var Msg:TMessage);
begin
  ResizeAll
end;

procedure TSQLGrid.ResizeAll;
begin
  Grid.Top:=0;
  Grid.Left:=0;
  Grid.Height:=ClientHeight;
  Separator.Visible:=QuickView.Visible;
  if QuickView.Visible then
    begin
      Grid.Width:=round(GridWidth*ClientWidth);
      Separator.Top:=0;
      Separator.Left:=Grid.Width+1;
      Separator.Height:=ClientHeight;
      Separator.Width:=3;

      QuickView.Top:=0;
      QuickView.Left:=Separator.Left+Separator.Width+1;
      QuickView.Height:=ClientHeight;
      QuickView.Width:=ClientWidth-QuickView.Left
    end
  else
  Grid.Width:=ClientWidth
end;


procedure TSQLGrid.WritePC(s:boolean);
begin
  Grid.ParentColor:=s
end;

function TSQLGrid.ReadPC:boolean;
begin
  ReadPC:=Grid.ParentColor
end;

procedure TSQLGrid.WriteRO(s:boolean);
begin
  Grid.ReadOnly:=s
end;

function TSQLGrid.ReadRO:boolean;
begin
  ReadRO:=Grid.ReadOnly
end;

procedure TSQLGrid.WriteDblClick(s:TNotifyEvent);
begin
  Grid.OnDblClick:=s
end;

function TSQLGrid.ReadDblClick:TNotifyEvent;
begin
  ReadDblClick:=Grid.OnDblClick
end;

procedure Register;
begin
  RegisterComponents('My',[TSQLGrid])
end;

function TSQLGrid.GetFieldsCount:integer;
begin
  GetFieldsCount:=FFields.Count
end;

function TSQLGrid.GetField(Index:integer):TFieldDescr;
begin
  try
    GetField:=FFields.Items[Index];
  except
    GetField:=NIL
  end
end;

procedure TSQLGrid.ClearFields;
var i:integer;
begin
  for i:=0 to FieldsCount-1 do
    Fields[i].Free;
  FFields.Clear
end;

procedure TSQLGrid.PrintOnClick(Sender:TObject);
var pr:TDBPrinter;
begin
  pr:=TDBPrinter.Create;
  pr.Print(Grid,Query,'');
  pr.Free
end;

procedure TSQLGrid.SendToExcel(Sender:TObject);
var
  OLEExcel1:TOLEExcel;
begin
  OLEExcel1:=TOLEExcel.Create(application);
  OLEExcel1.CreateExcelInstance;
  OLEExcel1.Visible := True;
//  SavePoint;
  OLEExcel1.QueryToExcel( Query );
//  OLEExcel1.free;
//  RestorePoint;
end;

procedure TSQLGrid.SendToWord(Sender:TObject);
var QExport:TQExport;
begin
  QExport:=TQExport.Create(Application);
  QExport.Query:=Query;
  QExport.ExportWord;
  QExport.free;
end;

procedure TSQLGrid.BlankPrintOnClick(Sender:TObject);
begin
  ShowBlankListFrm(View,query)
end;

procedure TSQLGrid.SavePoint(Field:string);
begin
  try
    Point:=Query.FieldByName(Field).AsInteger;
    FieldPoint:=Field
  except
  end
end;

procedure TSQLGrid.SavePrevPoint(Field:string);
begin
  if Query.Bof then
    Point:=-1
  else
  begin
    Query.DisableControls;
    Query.Prior;
    Point:=Query.FieldByName(Field).AsInteger;
    Query.Next;
    Query.EnableControls
  end;
  FieldPoint:=Field
end;

procedure TSQLGrid.SaveNextPoint(Field:string);
var tb:TBookMark;
begin
  if Query.Eof then
    Point:=-1
  else
  begin
    Query.DisableControls;
    tb:=Query.GetBookMark;
    Query.Next;
    if Query.Eof then
      begin
        Query.GotoBookMark(tb);
        Query.Prior;
        if Query.Bof then
          Point:=-1
        else
          Point:=Query.FieldByName(Field).AsInteger
      end
    else
      Point:=Query.FieldByName(Field).AsInteger;
    Query.GotoBookMark(tb);
    Query.FreeBookMark(tb);
    Query.EnableControls
  end;
  FieldPoint:=Field
end;

procedure TSQLGrid.LoadPoint(Field:string;l:longint);
begin
  if l<>-1 then
  begin
    Query.DisableControls;
    Query.First;
    while not Query.Eof do
      begin
        if Query.FieldByName(Field).AsInteger=l then break;
        Query.Next
      end;
    if Query.Eof then Query.First;
    Query.EnableControls;
    Point:=-1;
  end
end;

function TSQLGrid.FieldByName(FieldName:string):TField;
begin
  FieldByName:=Query.FieldByName(FieldName)
end;

function TSQLGrid.ReadFTF:boolean;
begin
  ReadFTF:=FilterForm.FullTextFlag
end;

procedure TSQLGrid.WriteFTF(b:boolean);
begin
  FilterForm.FullTextFlag:=b
end;

begin

end.

