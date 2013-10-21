unit Tadjform;

interface
Uses
  TSQLCls,WinTypes,WinProcs,DBGrids,CommFunc,  Grids, DBTables,
  SysUtils,StdCtrls,Classes,Buttons,Controls,ExtCtrls,
  Messages, IniFiles,Forms,Graphics,BmpBtn,DB,Outline,
  LblEdit, LEBtn, Lbsqloln,editdate,SQLCtrls,TabNotBk,Toolbar;


Const
 StatusHeight=20;
 Forms_ini : String[30] ='Forms.ini';
 secCommon : String[10] ='Common';

Type PBoolean=^Boolean;
Type string30=string[40];

Type TAdjustForm=class(TForm)
      private
        bt :TBmpBtn; { Temporary button }
        HintFlag:boolean;
        fEdit,fLbl,fGrid,fGridTitle,fTree:TFont;
        ResizeFlag:boolean;
        OldOnActivate:TNotifyEvent;
        OldOnDeactivate:TNotifyEvent;
        OldOnResize:TNotifyEvent;
        OldOnShow:TNotifyEvent;
        procedure BeforeCreate;
        procedure AfterCreate;
      protected
         Adj:boolean;
         function readToolBarVisible:Boolean;
         procedure writeToolBarVisible(status:Boolean);
         procedure WriteSection(s:string30);
         function ReadSection:string30;
         function readStatusBarVisible:Boolean;
         procedure writeStatusBarVisible(status:Boolean);
         procedure writeOnResize(Event:TNotifyEvent);
         procedure PrintOnClick(Sender:TObject); virtual;
      public
        fSection  : string30;
        Query     : TQuery;
        ID,Parm,
        Parm2,Parm3,Parm4,
        Parm5,Parm6,Parm7: longint;
        ParamStr  : string;
        copym,
        ParmBool  : boolean;
        tcnt      : Integer;
        OldClientHeight,
        OldClientWidth  : Integer;
        FormsIni  : TIniFile;
        ToolBar   : TPanel;
        StatusBar : TPanel;
        OldHint   : TNotifyEvent;
        fOnUserCreate : TNotifyEvent;
        Client    : TPanel;
        ToolbarCaptionPresent:boolean;
        constructor Create(AC:TComponent); override;
        constructor CreateWithParm(AC:TComponent;q:TQuery;p:longint);
        constructor CreateWithParm2(AC:TComponent;q:TQuery;p,p2:longint);
        destructor Destroy; override;
        procedure AdjOnResize(Sender:TObject);
        procedure ControlChange(var c:TComponent);

        procedure DisplayHint(Sender: TObject);
        procedure OnAdjActivate(Sender:TObject);
        procedure OnAdjDeactivate(Sender:TObject);
        procedure OnAdjShow(Sender:TObject);
        function ExecQuery(sl:TStringList):integer;
        function InsertInto(Table,Fields,Values:string):integer;
        function UpdateSet(Table,Prefix,Conditions:string):integer;
        function SelectFrom(DBName,Table,Conditions:string):integer;
        procedure GetListFields(c:TWinControl;var sf:TStringList);
        procedure ValueByName(c:TWinControl;fn:string;var sl:TStringList);
        procedure SetValue(c:TWinControl;var q:TQuery);
        procedure SelectFromQuery(var q:TQuery);
        function ReadInteger(fn:string;dv:longint):longint;
        function ReadBool(fn:string;dv:boolean):boolean;
        procedure WriteInteger(fn:string;dv:longint);
        procedure WriteBool(fn:string;dv:boolean);
	function FindSQLControl(c:TWinControl;fn:string):TSQLControl;
      published
        property ToolBarVisible :Boolean
            read readToolBarVisible
            write writeToolBarVisible;
        property StatusBarVisible :Boolean
            read ReadStatusBarVisible
            write WriteStatusBarVisible;
        property Section :string30
            read ReadSection
            write WriteSection;
        Property  OnCreate:TNotifyEvent
            read fOnUserCreate
            write fOnUserCreate;
        Property  OnUserCreate:TNotifyEvent
            read fOnUserCreate
            write fOnUserCreate;
{        Property  OnResize:TNotifyEvent
            read OldOnResize
            write WriteOnResize;}
   end;
Var  FormsIniDir : TFileName;

procedure Register;

implementation
Uses Menus;

procedure Register;
begin
  RegisterComponents('LanDocs',[TAdjustForm])
end;

procedure TAdjustForm.WriteOnResize(Event:TNotifyEvent);
begin
  OldOnResize:=Event;
end;

procedure TAdjustForm.DisplayHint(Sender: TObject);
begin
  try
    StatusBar.Caption := Application.Hint
  except
  end;
end;

procedure TAdjustForm.BeforeCreate;
begin
  FormsIni          := TIniFile.Create(FormsIniDir+Forms_ini);
  HintFlag          := FormsIni.ReadBool(secCommon,'HintPresent',FALSE);
  ToolBar           := TPanel.Create(Self);
  StatusBar         := TPanel.Create(Self);
  Client            := TPanel.Create(Self);
  Client.ParentColor:= false;
  Client.ParentFont := false;
  ResizeFlag:=False;
  ParmBool:=FALSE;
end;

procedure TAdjustForm.AfterCreate;
var
  i:Integer;
  c  :TComponent;
begin
  Client.Parent := Self;
  OldOnActivate:=onActivate;
  OldOnDeactivate:=onDeactivate;
  onActivate:=OnAdjActivate;
  onDeactivate:=OnAdjDeactivate;
  OldOnResize:=OnResize;
  OnResize:=AdjOnResize;
  OldOnShow:=OnShow;
  OnShow:=OnAdjShow;

  bt                := TBmpBtn.Create(Self);
  Adj:=FALSE;
  tcnt:=0;
  OldClientHeight   :=-1;
  OldClientWidth    :=-1;
  Client.Left       := 0;

  ToolBar.Parent    := Self;
  ToolBar.Left      := 0;
  ToolBar.Top       := 0;
  ToolBar.Visible   := TRUE;
  ToolBar.Align     := alNone;
  ToolBar.BevelOuter:= bvRaised;

  StatusBar.Parent  := Self;
  StatusBar.Align   := alNone;
  StatusBar.Visible := TRUE;
  StatusBar.BevelInner:=bvLowered;
  StatusBar.BevelOuter:=bvRaised;
  StatusBar.BevelWidth:=2;
  Statusbar.Alignment:=taLeftJustify;

  Client.ParentShowHint := True;
  Client.Visible := TRUE;
  Client.BevelOuter:=bvNone;

  { I need to add path to my system directory }
  { Parametrize Buttons }
  ToolBarCaptionPresent:=TRUE;
  bt.Font:=  ReadFont(FormsIni,'ToolBarButton');
  fEdit:= ReadFont(FormsIni,'Edit');
  fLbl:= ReadFont(FormsIni,'Label');
  fGrid:= ReadFont(FormsIni,'Grid');
  fGridTitle:= ReadFont(FormsIni,'GridTitle');
  fTree:= ReadFont(FormsIni,'Tree');
  bt.Height    := FormsIni.ReadInteger(secCommon,'ToolBarButtonHeight',20);
  if ToolBarCaptionPresent then
    bt.Width     := FormsIni.ReadInteger(secCommon,'ToolBarButtonWidth',50)
  else
    bt.Width:=bt.Height;
  I := 0;
  while i<ComponentCount do
    begin
      if not((Components[I]=Toolbar)or
             (Components[I]=StatusBar) or
             (Components[I]=Client)) then
        begin
          c:=Components[i];
          if (TControl(c).Parent=self) and (c<>Client) then
            TControl(c).Parent:=Client;
          ControlChange(c);
        end;
      i:=i+1;
    end;
  bt.Free;

  if HintFlag then
    begin
      ShowHint:=TRUE;
    end;

  if Assigned(fOnUserCreate) then
    fOnUserCreate(self);


  ResizeFlag:=TRUE;
  WriteSection(Section);
end;

constructor TAdjustForm.Create(AC:TComponent);
begin
  BeforeCreate;
  inherited Create(AC);
  AfterCreate;
end;

constructor TAdjustForm.CreateWithParm(AC:TComponent;q:TQuery;p:longint);
begin
  Query:=q;
  Parm:=p;
  BeforeCreate;
  inherited Create(AC);
  AfterCreate;
end;

constructor TAdjustForm.CreateWithParm2(AC:TComponent;q:TQuery;p,p2:longint);
begin
  Parm2:=p2;
  Query:=q;
  Parm:=p;
  BeforeCreate;
  inherited Create(AC);
  AfterCreate;
end;

function TAdjustForm.ReadInteger(fn:string;dv:longint):longint;
begin
  ReadInteger:=FormsIni.ReadInteger(Section,fn,dv)
end;

function TAdjustForm.ReadBool(fn:string;dv:boolean):boolean;
begin
  ReadBool:=FormsIni.ReadBool(Section,fn,dv)
end;

procedure TAdjustForm.WriteInteger(fn:string;dv:longint);
begin
  FormsIni.WriteInteger(Section,fn,dv)
end;

procedure TAdjustForm.WriteBool(fn:string;dv:boolean);
begin
  FormsIni.WriteBool(Section,fn,dv)
end;

procedure TAdjustForm.WriteSection(s:string30);
var btn:TBmpBtn;
    i,wd: integer;
    mn:TMenuItem;
    sl:TStringList;
begin
  try
    if s='' then s:='TempFormSection';
    fSection:=s;
    SetBounds(ReadInteger('Left',0),
              ReadInteger('Top',0),
              ReadInteger('Width',Width),
              ReadInteger('Height',Height));

    ToolBar.visible  := ReadBool('ToolBarVisible',True);
    StatusBar.visible:= ReadBool('StatusBarVisible',True);
    HelpContext:= ReadInteger('HelpContext',0);
    ToolBarCaptionPresent:=ReadBool('ToolBarCaptionPresent',True);
    wd:=FormsIni.ReadInteger('Common','ToolBarButtonWidth',50);
    for i:=0 to ComponentCount-1 do
      if Components[i] is TBmpBtn then
        begin
          btn:=TBmpBtn(Components[i]);
          if btn.ToolbarButton then
            if ToolBarCaptionPresent then
              btn.Width:=wd
            else
              btn.Width:=btn.Height;
        end;
      if ResizeFlag then OnResize(self);
  except
  end;
{================= Reports}
  if Menu<>NIL then
    begin
      mn:=TMenuItem(FindComponent('iPrint'));
      if mn<>NIL then
        begin
          for i:=0 to mn.Count-1 do
            mn.Items[i].Free;
          sl:=TStringList.Create;
          s:=s+'.Reports';
          FormsIni.ReadSection(s,sl);
          for i:=0 to sl.Count-1 do
            mn.Add(NewItem(FormsIni.ReadString(s,sl.Strings[i],''),0,FALSE,TRUE,PrintOnClick,0,sl.Strings[i]));
          sl.Free;
        end;
    end;
end;

procedure TAdjustForm.PrintOnClick(Sender:TObject);
begin
end;

procedure TAdjustForm.OnAdjActivate(Sender:TObject);
begin
{ if Section='' then messagebox(0,'aaa','bbbb',0);
}
  OldHint:=Application.OnHint;
  Application.OnHint := DisplayHint;
  if Assigned(OldOnActivate) then OldonActivate(Sender)
end;

procedure TAdjustForm.OnAdjDeactivate(Sender:TObject);
begin
  Application.OnHint := OldHint;
  if Assigned(OldonDeactivate) then OldonDeactivate(Sender)
end;

procedure TAdjustForm.OnAdjShow(Sender:TObject);
begin
  HorzScrollBar.Visible:=FALSE;
  VertScrollBar.Visible:=FALSE;
  if Assigned(OldonShow) then OldonShow(Sender)
end;

procedure TAdjustForm.AdjOnResize(Sender:TObject);
var i,cr,dx,dy:integer;
begin
  if ResizeFlag then
    begin
    ToolBar.Width:=ClientWidth;
    cr:=0;  dy:=2; dx:=4;
    for i:=0 to ToolBar.ControlCount-1 do
      if (ToolBar.Controls[i] is TBMPBtn) and ToolBar.Controls[i].Visible then
        begin
          if (dx+ToolBar.Controls[i].Width>ToolBar.Width-2) and (cr>0) then
            begin
              dy:=dy+ToolBar.Controls[i].Height+2;  dx:=4;  cr:=0;
            end;
          ToolBar.Controls[i].Left:=dx;
          ToolBar.Controls[i].Top:=dy;
          dx:=dx+ToolBar.Controls[i].Width+2;
          inc(cr);
        end;
    if FormsIni<>nil then
    begin
      if ToolBar.ControlCount>0 then
       ToolBar.Height:=dy+ToolBar.Controls[0].Height+2
      else
       ToolBar.Height:=0;


      if HintFlag then
        begin
          StatusBar.Height:=0;
          StatusBar.Visible:=FALSE;
        end
      else
        begin
          StatusBar.Height:=-StatusBar.Font.Height+15;
          StatusBar.Visible:=TRUE;
        end;
      StatusBar.Width:=ClientWidth;
      StatusBar.Top:=ClientHeight-StatusBar.Height;
      Client.top     := toolBar.height;
      Client.width   := StatusBar.width;
      Client.height  := StatusBar.top - Client.top;
    end;
    if Assigned(OldOnResize) then OldOnResize(Sender);
  end
end;


procedure TAdjustForm.ControlChange(var c:TComponent);
var
  i:integer;
// f:TFont;
  cc:TComponent;
begin
  if c is TPanel then
  begin
    ParentColor:=FALSE;
    ParentFont:=FALSE;
  end
  else
  if c is TBmpBtn then
    with c as TBmpBtn do
      if not((hint='') and (caption='')) then
      begin
      ParentColor:=FALSE;
      ParentFont:=FALSE;
      if ToolBarButton then
      begin
        parent:=ToolBar;
        ParentColor:=FALSE;
        Left:=tcnt*(bt.Width+1)+4;
        Top:=2;
        Font:=bt.Font;
        Height:=bt.Height;
        Width:=bt.Width;
        if not ToolBarCaptionPresent then    { }
        begin
          Caption:='';
          Style:=bsNew
        end
        else
          Style:=bsAutoDetect;
        inc(tcnt)
      end
      else
        Font:=bt.Font;
    end;
  if c is TEdit then
    with c as TEdit do
    begin
      ParentColor:=FALSE;
      ParentFont:=FALSE;
      Font:=fEdit;
    end;
  if c is TEditDate then
    with c as TEditDate do
    begin
      ParentColor:=FALSE;
      ParentFont:=FALSE;
      Font:=fEdit;
    end;
  if c is TMemo then
    with c as TMemo do
    begin
      ParentColor:=FALSE;
      ParentFont:=FALSE;
      Font:=fEdit;
    end;
  if c is TCombobox then
    with c as TCombobox do
    begin
      ParentColor:=FALSE;
      ParentFont:=FALSE;
      Font:=fEdit;
    end;
  if c is TLabel then
    with c as TLabel do
    begin
      ParentColor:=FALSE;
      ParentFont:=FALSE;
{      if Parent=self then Parent:=Client;}
      Font:=fLbl;
    end;
  if c is TCheckBox then
    with c as TCheckBox do
    begin
      ParentColor:=FALSE;
      ParentFont:=FALSE;
{      if Parent=self then Parent:=Client;}
      Font:=fLbl;
    end;
  if c is TDBGrid then
    with c as TDBGrid do
    begin
      ParentColor:=FALSE;
      ParentFont:=FALSE;
{      if Parent=self then Parent:=Client;}
      TitleFont:=fGridTitle;
      Font:=fGrid;
    end;
  if c is TStringGrid then
    with c as TStringGrid do
    begin
      ParentColor:=FALSE;
      ParentFont:=FALSE;
{      if Parent=self then Parent:=Client;}
      Font:=fGrid;
    end;
  if c is TOutline then
    with c as TOutline do
    begin
      ParentColor:=FALSE;
      ParentFont:=FALSE;
      Font:=fTree;
    end;
  if c is TTabbedNoteBook then
    with c as TTabbedNoteBook do
      Font:=fGrid;
  if c is TLDToolBar then
    with c as TLDToolBar do
    begin
      HeightButton:=bt.Height;
      WidthButton:=bt.Width;
{      if Parent=self then Parent:=Client;}
    end;
  i:=0;
  if not (c is TForm) then
    while i<c.ComponentCount do
      begin
        cc:=c.Components[i];
        ControlChange(cc);
        i:=i+1;
      end;
end;

destructor TAdjustForm.Destroy;
begin
  if FormsIni<>nil then
  begin
    try
      WriteInteger('Left',Left);
      WriteInteger('Top',Top);
      WriteInteger('Width',Width);
      WriteInteger('Height',Height);
      WriteBool   ('ToolBarVisible',ToolBar.visible);
      WriteInteger('ToolBarHeight',ToolBar.Height);
      WriteBool   ('StatusBarVisible',StatusBar.visible);
      WriteInteger('StatusBarHeight',StatusBar.Height);
      FormsIni.Free;
    except
    end;
  end;
  fEdit.Free;
  fLbl.Free;
  fGrid.Free;
  fGridTitle.Free;
  fTree.Free;
  Screen.Cursor:=crDefault;
  inherited Destroy;
end;

function TAdjustForm.readToolBarVisible:Boolean;
begin
  readToolBarVisible:=ToolBar.Visible
end;

procedure TAdjustForm.writeToolBarVisible(status:Boolean);
begin
  ToolBar.Visible:=status
end;

function TAdjustForm.readStatusBarVisible:Boolean;
begin
  readStatusBarVisible:=StatusBar.Visible
end;

procedure TAdjustForm.writeStatusBarVisible(status:Boolean);
begin
  StatusBar.Visible:=Status
end;

function TAdjustForm.InsertInto(Table,Fields,Values:string):integer;
var sl,sf:TStringList;
    i:integer;
    fl:boolean;
begin
  sl:=TStringList.Create;  sf:=TStringList.Create;
  GetListFields(Client,sf);
  if (sf.Count>0) or (Fields<>'') then
    begin
      sl.Add(sql.Insert_Into+sql.AddPrefix(Table)+' ('+sql.MakeKeywords(Fields));
      fl:=Fields<>'';
      for i:=0 to sf.Count-1 do
        begin
          if fl then  sl.Add(',')
          else        fl:=TRUE;
          sl.Add(sql.Keyword(sf[i]));
        end;
      sl.Add(') VALUES ('+Values);
      fl:=Fields<>'';
      for i:=0 to sf.Count-1 do
        begin
          if fl then  sl.Add(',')
          else        fl:=TRUE;
          ValueByName(Client,sf[i],sl);
        end;
      sl.Add(')');
      InsertInto:=ExecQuery(sl);
    end
  else
    InsertInto:=-1;
  sl.Free;  sf.Free;
end;

procedure TAdjustForm.GetListFields(c:TWinControl;var sf:TStringList);
var i:Integer;
begin
  for i:=0 to c.ControlCount-1 do
    if c.Controls[i] is TSQLControl then
      with c.Controls[i] as TSQLControl do
        begin
          if (FieldName<>'') and c.Controls[i].Visible then
            sf.Add(FieldName);
        end
    else
      if c.Controls[i] is TWinControl then
        GetListFields(TWinControl(c.Controls[i]),sf);
end;

function TAdjustForm.FindSQLControl(c:TWinControl;fn:string):TSQLControl;
var i:Integer;
    sc:TSQLControl;
begin
  FindSQLControl:=NIL;
  for i:=0 to c.ControlCount-1 do
    if c.Controls[i] is TSQLControl then
      begin
        with c.Controls[i] as TSQLControl do
          if UpperCase(FieldName)=UpperCase(fn) then
            begin
              FindSQLControl:=TSQLControl(c.Controls[i]);
              break
            end
      end
    else
      if (c.Controls[i] is TWinControl) then
        begin
          sc:=FindSQLControl(TWinControl(c.Controls[i]),fn);
          if sc<>NIL then
            begin
              FindSQLControl:=sc;
              break
            end
        end;
end;

procedure TAdjustForm.ValueByName(c:TWinControl;fn:string;var sl:TStringList);
var sc:TSQLControl;
begin
  sc:=FindSQlControl(c,fn);
  if sc<>NIL then
    sc.Value(sl);
end;

procedure TAdjustForm.SetValue(c:TWinControl;var q:TQuery);
var i:Integer;
begin
  for i:=0 to c.ControlCount-1 do
    if c.Controls[i] is TSQLControl then
      with c.Controls[i] as TSQLControl do
        begin
          if (FieldName<>'') then
            TSQLControl(c.Controls[i]).SetValue(q)
        end
    else
      if (c.Controls[i] is TWinControl) then
        SetValue(TWinControl(c.Controls[i]),q);
end;

function TAdjustForm.ExecQuery(sl:TStringList):integer;
begin
  if sql.ExecSQL(sl)=0 then
    ExecQuery:=0
  else
    ExecQuery:=1
end;

function TAdjustForm.UpdateSet(Table,Prefix,Conditions:string):integer;
var sl,sf:TStringList;
    i:integer;
    fl:boolean;
begin
  sl:=TStringList.Create;  sf:=TStringList.Create;
  GetListFields(Client,sf);
  if (sf.Count>0) or (Prefix<>'') then
    begin
      sl.Add('UPDATE '+sql.AddPrefix(Table)+' SET ');
      sl.Add(Prefix);
      fl:=Prefix<>'';
      for i:=0 to sf.Count-1 do
        begin
          if fl then  sl.Add(',')
          else        fl:=TRUE;
          sl.Add(sql.Keyword(sf[i])+'=');
          ValueByName(Client,sf[i],sl);
        end;
      if Conditions<>'' then
        sl.Add('WHERE '+Conditions);
      UpdateSet:=ExecQuery(sl);
    end
  else
    UpdateSet:=-1;
  sl.Free;  sf.Free;
end;

function TAdjustForm.SelectFrom(DBName,Table,Conditions:string):integer;
var
  q:TQuery;
begin
  q:=sql.Select(Table,'',Conditions,'');
  try
    SetValue(Client,q);
    SelectFrom:=0;
  except
    SelectFrom:=-1;
  end;
  q.Free
end;

procedure TAdjustForm.SelectFromQuery(var q:TQuery);
begin
  SetValue(Client,q);
end;

function TAdjustForm.ReadSection:string30;
begin
  if fSection='' then
    Result:=Name
  else
    Result:=fSection
end;

Begin
  FormsIniDir:='';
end.

