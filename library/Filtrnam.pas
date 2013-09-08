unit Filtrnam;

interface
{ $R bmps.res}
uses
  DBTables,TSQLCls, Tadjform,
  SysUtils, WinTypes, WinProcs, Messages,
  Classes, Graphics, Controls, rdlg,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, BMPBtn, Grids, TabNotBk,
  FiltrFrm, ComCtrls, Entersql{, ComCtrls};

  const
    aOpen =101;
    aSave =102;
    mrCallEditor  = 201;
    mrDeleteFilter= 202;
    mrEditNew     = 203;
    SctionName = 'FilterSelectForm';
type
  TFilterNameForm = class(TAdjustForm)
    btOk: TBMPBtn;
    BtCreate: TBMPBtn;
    btEdit: TBMPBtn;
    btDel: TBMPBtn;
    btCancel: TBMPBtn;
    TabbedNotebook1: TTabbedNotebook;
    ObshList: TListBox;
    ObshEdit: TEdit;
    ChastList: TListBox;
    ChastEdit: TEdit;
    obshDefFilter: TCheckBox;
    ChastDefFilter: TCheckBox;
    procedure ObshListClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure btDelClick(Sender: TObject);
    procedure BtCreateClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TabbedNotebook1Click(Sender: TObject);
    procedure ChastListClick(Sender: TObject);
    function GetFilterName:string;
    procedure SetFilterName(s:string);
    procedure ObshListDblClick(Sender: TObject);
    procedure ChastListDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure ChastDefFilterClick(Sender: TObject);
    procedure obshDefFilterClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FilterForm : TFilterForm;
    EnterSQLStr: TEnterSQLStr;
    DefFilterID    : integer;
    OldDefFilterID : integer;
    Fck : boolean;
    procedure Check;
    function GetStrUserID:string;
    procedure Enablebuttons(Tab:integer);
    function GetFilterID(FilterName,UserID:string):integer;
    procedure UpdateDefFilter;
   public
    ViewName,DSN : String;
    Action     : integer;
    MaxString  : integer;
    CheckBsiz  : integer;
   procedure GetDataBase(var ListBox:TListBox;IsCommon:boolean);
    procedure SetCaption(s:String);
    property  CurFilterName:string Read GetFilterName Write SetFilterName;
    property  CurUserID:string Read GetStrUserID;
    procedure SetFilterNames(const ListBox:TListBox;const Edit:TEdit;const FilterName:string);
  end;

function ProceedDialog(sCaption,cButton,sButton,ViewName:string;EditNotEnabled:boolean;FilterForm:TFilterForm;
                          Action:integer; var FilterName,UserID:string):integer;

implementation

uses ask_ft;

{$R *.DFM}
{------------------------------------------------------------------------}
function TFilterNameForm.GetStrUserID:string;
begin
  if TabbedNotebook1.PageIndex=0 then
     GetStrUserID:=IntToStr(sql.CurrentUserID) else GetStrUserID:='NULL';
end;
{------------------------------------------------------------------------}
function TFilterNameForm.GetFilterName:string;
begin
  if TabbedNotebook1.PageIndex=0 then
      GetFilterName:=ChastEdit.Text else GetFilterName:=ObshEdit.Text
end;
procedure TFilterNameForm.SetFilterName(s:string);
begin
  if TabbedNotebook1.PageIndex=0 then
      ChastEdit.Text:=s else ObshEdit.Text:=s
end;
{------------------------------------------------------------------------}
procedure TFilterNameForm.SetCaption(s:String);
begin
  caption:=s
end;
{------------------------------------------------------------------------}
procedure TFilterNameForm.GetDataBase(var ListBox:TListBox;IsCommon:boolean);
var
 q : TQuery;
 s:string;
 len:integer;
begin
try
  if not IsCommon then
    q:=sql.SelectDistinct('GUIFilter','',
                sql.CondIntEqu('UserID',sql.CurrentUserID)+LogAND
               +sql.CondStr('ViewName','=',ViewName),'')
      else
    q:=sql.SelectDistinct('GUIFilter','',
                sql.CondNull('UserID')+LogAND
               +sql.CondStr('ViewName','=',ViewName),'');
  MaxString:=0;
  ListBox.Items.Clear;
  while not q.eof do
    begin
      s:=q.FieldByName('DisplayLabel').AsString;
      ListBox.Items.AddObject(s,pointer(q.FieldByName('ID').AsInteger));
      len:=ListBox.Canvas.TextWidth(s)+20;
      if MaxString<len then MaxString:=len;
      q.Next
    end;
  q.free;
except
end;
  ListBox.Refresh;
end;
{------------------------------------------------------------------------}
procedure TFilterNameForm.ObshListClick(Sender: TObject);
begin
  if ObshList.ItemIndex>=0 then ObshEdit.Text:=ObshList.Items[ObshList.ItemIndex];
  EnableButtons(1{TabbedNotebook1.PageIndex});
  Fck:=true;
  if ObshList.ItemIndex<0 then ObshDefFilter.Checked:=false
       else ObshDefFilter.Checked:=
          (integer(ObshList.Items.Objects[ObshList.ItemIndex])=DefFilterID);
  Fck:=false;
end;
procedure TFilterNameForm.ChastListClick(Sender: TObject);
begin
  if ChastList.ItemIndex>=0 then ChastEdit.Text:=ChastList.Items[ChastList.ItemIndex];
  EnableButtons(0{TabbedNotebook1.PageIndex});
  Fck:=true;
  if ChastList.ItemIndex<0 then ChastDefFilter.Checked:=false
    else ChastDefFilter.Checked:=
          (integer(ChastList.Items.Objects[ChastList.ItemIndex])=DefFilterID);
  Fck:=false;
end;
{------------------------------------------------------------------------}
Procedure TFilterNameForm.SetFilterNames(const ListBox:TListBox;const Edit:TEdit;const FilterName:string);
var
  i:integer;
begin
  i:=ListBox.Items.IndexOf(FilterName);
  if i>=0 then Edit.Text:=FilterName;
  if i>=0 then ListBox.ItemIndex:=i
                 else
     if (ListBox.Items.Count>0) and (Edit.Text='') then
        begin
          ListBox.ItemIndex:=0;
          Edit.Text:=ListBox.Items[0];
        end;
  ListBox.OnClick(self);
end;
{------------------------------------------------------------------------}
function ProceedDialog(sCaption,cButton,sButton,ViewName:string;EditNotEnabled:boolean;FilterForm:TFilterForm;
                          Action:integer;var FilterName,UserID:string):integer;
var
  FilterNameForm:TFilterNameForm;
//  i:integer;
begin
  FilterNameForm:=TFilterNameForm.Create(Application);

  if UserID='NULL' then
      begin
        FilterNameForm.TabbedNotebook1.PageIndex:=1;
        if FilterName<>'' then FilterNameForm.obshEdit.Text:=FilterName;
      end
       else
      begin
        FilterNameForm.TabbedNotebook1.PageIndex:=0;
        if FilterName<>'' then FilterNameForm.chastEdit.Text:=FilterName;
      end;


  FilterNameForm.Action:=Action;
  FilterNameForm.ViewName:=ViewName;
  FilterNameForm.FilterForm:=FilterForm;

  FilterNameForm.EnterSQLStr:=TEnterSQLStr.Create(Application);

  FilterNameForm.SetCaption(sCaption);
  FilterNameForm.btOk.Hint:=sButton;
  FilterNameForm.btOk.Caption:=cButton;
  FilterNameForm.DefFilterID:=FilterForm.GetDefFilterID;
  FilterNameForm.OldDefFilterID:=FilterNameForm.DefFilterID;
  FilterNameForm.GetDataBase(FilterNameForm.ChastList,false);
  FilterNameForm.GetDataBase(FilterNameForm.ObshList,true);

  with FilterNameForm do SetFilterNames(ObshList,ObshEdit,FilterName);
  with FilterNameForm do SetFilterNames(ChastList,ChastEdit,FilterName);

  if EditNotEnabled then
   with FilterNameForm do
    begin
       btDel.Visible:=false;
       btCreate.Visible:=false;
       btEdit.Visible:=false;
       btCancel.Left:=btOk.Left+btOk.Width+4;
    end;
  Result:=FilterNameForm.ShowModal;
  FilterNameForm.FormsIni.WriteInteger(SctionName,'ActivePage',FilterNameForm.TabbedNotebook1.PageIndex);
  if Result=mrOk then
     begin
       FilterName:=FilterNameForm.CurFilterName;
       UserID:=FilterNameForm.CurUserID;
     end;
  FilterNameForm.Free;
end;
{------------------------------------------------------------------------}
Procedure TFilterNameForm.Enablebuttons(Tab:integer);
var
  s:string;
begin
  if Tab = 0 then
      s:=ChastEdit.Text else s:=ObshEdit.Text;
  if s='' then
      begin
        btEdit.Enabled:=false;
        btDel.Enabled:=false;
        btOk.Enabled:=false;
      end
    else
      begin
        btEdit.Enabled:=true;
        btDel.Enabled:=true;
        btOk.Enabled:=true;
      end;
end;
procedure TFilterNameForm.FormActivate(Sender: TObject);
begin
  Enablebuttons(TabbedNotebook1.PageIndex);
  case Action of
     aOpen : begin
                ChastEdit.ReadOnly:=true;
                obshEdit.ReadOnly:=true;
                if TabbedNotebook1.PageIndex=0 then ChastList.SetFocus
                  else ObshList.SetFocus;
             end;
     aSave : begin
               if TabbedNotebook1.PageIndex=0 then ChastEdit.SetFocus
                 else ObshEdit.SetFocus;
               btCancel.Hint:='Выход без сохранения';
             end;
  end;
end;
{------------------------------------------------------------------------}
function TFilterNameForm.GetFilterID(FilterName,UserID:string):integer;
var q:TQuery;
begin
  if UserID<>'NULL' then
    q:=sql.SelectDistinct('GUIFilter','',
                sql.CondIntEqu('UserID',StrToInt(UserID))+LogAND
               +sql.CondStr('ViewName','=',FilterForm.ViewName)+LogAND
               +sql.CondStr('DisplayLabel','=',FilterName),'')
      else
    q:=sql.SelectDistinct('GUIFilter','',
                sql.CondNull('UserID')+LogAND
               +sql.CondStr('ViewName','=',FilterForm.ViewName)+LogAND
               +sql.CondStr('DisplayLabel','=',FilterName),'');
  if not q.eof then result:=q.FieldByName('ID').AsInteger else result:=0;
  q.free;
end;
{------------------------------------------------------------------------}
procedure TFilterNameForm.Check;
begin
  if CurFilterName='' then
    begin
       MessageDlg('Название фильтра не может быть пустым.',mtInformation,[mbOk],0);
       exit;
    end;
  if Action=aSave then
    if ((TabbedNotebook1.PageIndex=0) and (ChastList.Items.IndexOf(CurFilterName)>=0)) or
       ((TabbedNotebook1.PageIndex=1) and (ObshList.Items.IndexOf(CurFilterName)>=0)) then
       begin
         if RusMessageDlg('Фильтр с таким именем уже существует. Перезаписать?',
                mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
       end;
  if Action=aOpen then FilterForm.DoLoadFilter(GetFilterID(CurFilterName,CurUserID),CurUserID);
  ModalResult:=mrOk;
end;
{------------------------------------------------------------------------}
procedure TFilterNameForm.UpDateDefFilter;
var oldFID:integer;
begin
  if not sql.EOF('VIEWGUIFDefault',sql.CondIntEqu('UserID',sql.CurrentUserID)+LogAND+
                 sql.CondStr('ViewName','=',ViewName))
    then
      begin
        oldFID:=FilterForm.GetDefFilterID;
        sql.UpdateString('GUIFDefault',sql.SetInt('FilterID',DefFilterID),
             sql.CondIntEqu('UserID',sql.CurrentUserID)+LogAND+
             sql.CondIntEqu('FilterID',oldFID))
      end
     else
          sql.InsertString('GUIFDefault','FilterID,UserID',
                 inttostr(DefFilterID)+','+
                 inttostr(sql.CurrentUserID));
end;
{------------------------------------------------------------------------}
procedure TFilterNameForm.btOkClick(Sender: TObject);
begin
  if OldDefFilterID<>DefFilterID then UpDateDefFilter;
  check;
end;
{------------------------------------------------------------------------}
procedure TFilterNameForm.btEditClick(Sender: TObject);
var
  i:integer;
begin
  FilterForm.DoLoadFilter(GetFilterID(CurFilterName,CurUserID),CurUserID);
  if FilterForm.FilterType=Filtr_Table then
      i:=FilterForm.ShowModal
   else
     begin
      EnterSQLStr.Filterfrm:=FilterForm;
      i:=EnterSQLStr.ShowModal;
     end;
  if FilterForm.CurUserID='NULL' then
         begin
           obshEdit.Text:=FilterForm.FilterName;
           TabbedNotebook1.PageIndex:=1;
         end
        else
         begin
           chastEdit.Text:=FilterForm.FilterName;
           TabbedNotebook1.PageIndex:=0;
         end;
  if i=mrOk then ModalResult:=mrOk
     else
       begin
         GetDataBase(ChastList,false);
         GetDataBase(ObshList,true);
         i:=ChastList.Items.IndexOf(ChastEdit.Text);
         if i>=0 then ChastList.ItemIndex:=i;
         i:=ObshList.Items.IndexOf(ObshEdit.Text);
         if i>=0 then ObshList.ItemIndex:=i
{         SetFilterNames(ObshList,ObshEdit,FilterForm.FilterName);
         SetFilterNames(ChastList,ChastEdit,FilterForm.FilterName);}
       end;
end;
{------------------------------------------------------------------------}
procedure TFilterNameForm.BtCreateClick(Sender: TObject);
var
  i:integer;
  Ask_filterType: TAsk_filterType;
begin
  Ask_filterType:=TAsk_filterType.Create(Application);

  if Ask_filterType.ShowModal=mrCancel then exit;
  if Ask_filterType.RadioGroup1.ItemIndex=1 then
   begin
     FilterForm.ClearAllStrings(self);
     FilterForm.FilterName:=sFilterWithoutName;
     FilterForm.CurUserID:=CurUserID;
     FilterForm.FilterType:=Filtr_SQL;
     FilterForm.Caption:='Фильтр '+#39+sFilterWithoutName+#39;
     EnterSQLStr.FilterFrm:=FilterForm;
     i:=EnterSQLStr.ShowModal;
     if i=mrOk then FilterForm.FilterStr:=EnterSQLStr.LabelEdit1.Memo.Text;
   end
 else
   begin
     FilterForm.ClearAllStrings(self);
     FilterForm.FilterName:=sFilterWithoutName;
     FilterForm.CurUserID:=CurUserID;
     FilterForm.FilterType:=Filtr_Table;
     FilterForm.Caption:='Фильтр '+#39+sFilterWithoutName+#39;
     i:=FilterForm.ShowModal;
   end;
  if (i=mrOk) then
    if (FilterForm.CurUserID='NULL') then
       begin
         obshEdit.Text:=FilterForm.FilterName;
         TabbedNotebook1.PageIndex:=1;
       end
      else
       begin
         chastEdit.Text:=FilterForm.FilterName;
         TabbedNotebook1.PageIndex:=0;
       end;
  if i=mrOk then ModalResult:=mrOk
     else
       begin
         GetDataBase(ChastList,false);
         GetDataBase(ObshList,true);

         i:=ChastList.Items.IndexOf(ChastEdit.Text);
         if i>=0 then ChastList.ItemIndex:=i;
         if (ChastList.Items.count>0) and (ChastEdit.Text='') then begin
              ChastList.ItemIndex:=0;
              ChastEdit.Text:=ChastList.Items[0];
             end;
         i:=ObshList.Items.IndexOf(ObshEdit.Text);
         if i>=0 then ObshList.ItemIndex:=i;
         if (ObshList.Items.count>0) and (ObshEdit.Text='') then begin
              ObshList.ItemIndex:=0;
              ObshEdit.Text:=ObshList.Items[0];
             end;
         EnableButtons(TabbedNotebook1.PageIndex);
{         SetFilterNames(ObshList,ObshEdit,FilterForm.FilterName);
         SetFilterNames(ChastList,ChastEdit,FilterForm.FilterName);}
       end;
   Ask_filterType.free;
end;
{------------------------------------------------------------------------}
procedure TFilterNameForm.btDelClick(Sender: TObject);
var
  ind:integer;
begin
  if TabbedNotebook1.PageIndex=0 then
     begin
       FilterForm.DeleteFilter(CurFilterName,CurUserID);
       ind:=ChastList.Items.IndexOf(CurFilterName);
       ChastList.Items.Delete(Ind);
       if (Ind<=ChastList.Items.Count-1) then ChastList.ItemIndex:=Ind
                     else ChastList.ItemIndex:=ChastList.Items.Count-1;
       if ChastList.ItemIndex>=0 then ChastEdit.Text:=ChastList.Items[ChastList.ItemIndex]
              else ChastEdit.Text:='';
     end
   else
     begin
       FilterForm.DeleteFilter(CurFilterName,'NULL');
       ind:=obshList.Items.IndexOf(CurFilterName);
       obshList.Items.Delete(Ind);
       if (Ind<=obshList.Items.Count-1) then obshList.ItemIndex:=Ind
                     else obshList.ItemIndex:=obshList.Items.Count-1;
       if ObshList.ItemIndex>=0 then ObshEdit.Text:=ObshList.Items[ObshList.ItemIndex]
              else ObshEdit.Text:='';
     end;
  EnableButtons(TabbedNotebook1.PageIndex);
end;
{------------------------------------------------------------------------}
procedure TFilterNameForm.FormResize(Sender: TObject);
begin
  if TabbedNotebook1.PageIndex=0 then
    begin
     ChastList.Height:=TabbedNotebook1.ClientHeight - ChastEdit.Height*2
                 - ChastDefFilter.Height - 16;
     ChastEdit.Top:=ChastList.Top+ChastList.Height+4;
     ChastEdit.Width:=TabbedNotebook1.ClientWidth-10;
     ChastDefFilter.Top:=ChastList.Top+ChastList.Height+4+ChastEdit.Height+4;
    end
   else
    begin
     ObshList.Height:=TabbedNotebook1.ClientHeight - ObshEdit.Height*2
                 - obshDefFilter.Height - 16;
     ObshEdit.Top:=ObshList.Top+ObshList.Height+4;
     ObshEdit.Width:=TabbedNotebook1.ClientWidth-10;
     obshDefFilter.Top:=ObshList.Top+ObshList.Height+4+ChastEdit.Height+4;
    end;
end;
{------------------------------------------------------------------------}
procedure TFilterNameForm.TabbedNotebook1Click(Sender: TObject);
begin
  FormResize(Sender)
end;

procedure TFilterNameForm.ObshListDblClick(Sender: TObject);
begin
  btOkClick(Sender);
end;

procedure TFilterNameForm.ChastListDblClick(Sender: TObject);
begin
  btOkClick(Sender);
end;

procedure TFilterNameForm.FormCreate(Sender: TObject);
begin
  fSection:=SctionName;
  Fck := false;
end;

procedure TFilterNameForm.TabbedNotebook1Change(Sender: TObject;
  NewTab: Integer; var AllowChange: Boolean);
begin
{  Enablebuttons(NewTab);}
  if NewTab=0 then ChastListClick(Self) else ObshListClick(Self);
end;

procedure TFilterNameForm.ChastDefFilterClick(Sender: TObject);
begin
  if not Fck then DefFilterID:=integer(ChastList.Items.Objects[ChastList.ItemIndex]);
end;

procedure TFilterNameForm.obshDefFilterClick(Sender: TObject);
begin
  if not Fck then DefFilterID:=integer(ObshList.Items.Objects[ObshList.ItemIndex]);
end;

procedure TFilterNameForm.FormShow(Sender: TObject);
begin
  FormResize(self);
end;

procedure TFilterNameForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  EnterSQLStr.free;
end;

end.
