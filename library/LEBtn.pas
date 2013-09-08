unit Lebtn;

interface
Uses wintypes,SysUtils,Classes,Controls,ExtCtrls,LblEdit,
     BMPBtn,Menus,Messages,SQLCtrls,DBTables,TSQLCls;

Type TLabelEditBmpBtn=class(TSQLControl)
      protected
        substr:string;
        CurrentOfs:integer;
        FTable:TSQLString;
        FID:TSQLString;
        FInfo:TSQLString;
        FWhere:string;
        fInfoField:String;
        fData:longint;
        fOnChangeData:TNotifyEvent;
        procedure WriteCaption(s:string);
        Function ReadCaption:String;
        procedure WriteBmpFile(s:string);
        Function ReadBmpFile:String;
        procedure WritePC(s:boolean);
        Function ReadPC:boolean;
        procedure WriteRO(s:boolean);
        Function ReadRO:boolean;
        procedure WriteML(s:integer);
        Function ReadML:integer;
        procedure WriteData(s:longint);
        procedure WriteText(s:string);
        Function ReadText:string;
        procedure KeyPress(Sender:TObject;var Key:char);
        procedure KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
        procedure OnLabelEditExit(Sender:TObject);
      public
        PrevData:longint;
        PrevInfo:string;
        LabelEdit:TLabelEdit;
        Parm:Longint;
        Button:TBMPBtn;
        FOnBtnClick:TNotifyEvent;
        procedure BtnClick(Sender:TObject);
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;
        procedure WMSize(var Msg:TMessage); message WM_SIZE;
        function GetHeight:integer;
        procedure Value(sl:TStringList); override;
        procedure SetValue(var q:TQuery); override;
        procedure Clear;
        procedure OnLabelEnter(Sender:TObject);
      published
        property Caption:String read ReadCaption write WriteCaption;
        property InfoField:string read fInfoField write fInfoField;
        property Table:TSQLString read fTable write fTable;
        property ID:TSQLString read fID write fID;
        property Info:TSQLString read fInfo write fInfo;
        property Where:string read fWhere write fWhere;
        property BmpFile:String read ReadBmpFile write WriteBmpFile;
        property ParentColor:boolean read ReadPC write WritePC;
        property ReadOnly:boolean read ReadRO write WriteRO;
        property MaxLength:integer read ReadML write WriteML;
        property Text:string read ReadText write WriteText;
        property Data:longint read fData write WriteData;
        property OnChangeData:TNotifyEvent read fOnChangeData write fOnChangeData;
        property Height default 70;
        property Width default 100;
        property Align;
        property DragCursor;
        property DragMode;
        property Enabled;
        property ParentCtl3D;
        property ParentShowHint;
        property PopupMenu;
        property ShowHint;
        property TabOrder;
        property TabStop;
        property Visible;
        property OnButtonClick:TNotifyEvent read FOnBtnClick write FOnBtnClick;
        property OnDragDrop;
        property OnDragOver;
        property OnEndDrag;
        property OnEnter;
        property OnExit;
end;

procedure Register;

implementation

function TLabelEditBMPBtn.GetHeight:integer;
begin
  GetHeight:=-LabelEdit.Edit.Font.Height+13-LabelEdit.Lbl.Font.Height
end;

destructor TLabelEditBMPBtn.Destroy;
begin
  LabelEdit.Free;
  Button.Free;
  inherited Destroy;
end;

constructor TLabelEditBMPBtn.Create(AOwner:TComponent);
begin
  fInfoField:='';
  inherited create(AOwner);
  LabelEdit:=TLabelEdit.Create(self);
  Button:=TBMPBtn.Create(self);
  Button.OnClick:=BtnClick;
  LabelEdit.Parent:=self;
  Button.Parent:=self;
  PrevInfo:='';
  PrevData:=0;
  LabelEdit.Edit.OnKeyPress:=KeyPress;
  LabelEdit.Edit.OnKeyDown:=KeyDown;
  CurrentOfs:=0;
  Button.NumGlyphs:=3;
  LabelEdit.OnExit:=OnLabelEditExit
end;

procedure TLabelEditBMPBtn.WMSize(var Msg:TMessage);
var w:integer;
begin
  LabelEdit.Lbl.Height:=-LabelEdit.Lbl.Font.Height+3;
  LabelEdit.Edit.Height:=-LabelEdit.Edit.Font.Height+10;
  LabelEdit.Height:=LabelEdit.Edit.Height+LabelEdit.Lbl.Height+1;
  LabelEdit.Width:=Msg.LParamLo-LabelEdit.Edit.Height;
  Button.Left:=LabelEdit.Width;
  Button.Top:=LabelEdit.Height-LabelEdit.Edit.Height;
  Button.Height:=LabelEdit.Edit.Height-1;
  Button.Width:=LabelEdit.Edit.Height-1;
  ClientHeight:=LabelEdit.Height;
  ClientWidth:=Msg.LParamLo
end;

procedure TLabelEditBMPBtn.WriteCaption(s:String);
begin
  LabelEdit.Caption:=s
end;

function TLabelEditBMPBtn.ReadCaption:String;
begin
  ReadCaption:=LabelEdit.Caption
end;

procedure TLabelEditBMPBtn.WriteBMPFile(s:String);
begin
  Button.FileName:=s
end;

function TLabelEditBMPBtn.ReadBMPFile:String;
begin
  ReadBMPFile:=Button.FileName
end;

procedure TLabelEditBMPBtn.BtnClick(Sender:TObject);
begin
  if Sender=Button then
    if Assigned(FOnBtnClick) then FOnBtnClick(self);
end;

procedure TLabelEditBmpBtn.WritePC(s:boolean);
begin
  LabelEdit.ParentColor:=s
end;

function TLabelEditBmpBtn.ReadPC:boolean;
begin
  ReadPC:=LabelEdit.ParentColor
end;

procedure TLabelEditBmpBtn.WriteRO(s:boolean);
begin
  LabelEdit.ReadOnly:=s
end;

function TLabelEditBmpBtn.ReadRO:boolean;
begin
  ReadRO:=LabelEdit.ReadOnly
end;

procedure TLabelEditBmpBtn.WriteML(s:integer);
begin
  LabelEdit.MaxLength:=s
end;

function TLabelEditBmpBtn.ReadML:integer;
begin
  ReadML:=LabelEdit.MaxLength
end;

procedure TLabelEditBmpBtn.Value(sl:TStringList);
var i:integer;
begin
  if Assigned(fValueEvent) then fValueEvent(self,sl)
  else
    if Data=0 then sl.Add('NULL')
    else
      sl.Add(IntToStr(Data));
end;

procedure TLabelEditBmpBtn.SetValue(var q:TQuery);
begin
  if Assigned(fSetValueEvent) then fSetValueEvent(self,q)
  else
    begin
      Data:=q.FieldByName(fFieldName).AsInteger;
      if fInfoField<>'' then
        LabelEdit.Text:=q.FieldByName(fInfoField).AsString;
    end
end;

procedure TLabelEditBmpBtn.Clear;
begin
  LabelEdit.Text:='';
  Data:=0
end;

procedure TLabelEditBmpBtn.WriteData(s:longint);
var q:TQuery;
    b:boolean;
begin
  b:=s<>Data;
  if (Table<>'') and (ID<>'') and (Info<>'') and b then
    begin
      if s=0 then
        begin
          fData:=0;
          LabelEdit.Text:=''
        end
      else
        begin
          q:=sql.Select(Table,sql.Keyword(Info)+','+sql.Keyword(ID),
            sql.CondIntEqu(ID,s),'');
          if not q.eof  then
            begin
              fData:=s;
              LabelEdit.Text:=q.FieldByName(Info).AsString
            end;
          q.Free
        end
    end
  else
    fData:=s;
  if b and Assigned(fOnChangeData) then
    OnChangeData(self);

end;

procedure TLabelEditBmpBtn.KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
procedure DoMove(ofs:integer);
var
    q:TQuery;
begin
  Key:=0;
  if (Table<>'') and (ID<>'') and (Info<>'') and (CurrentOfs+ofs>=0) then
    begin
       q:=sql.Select(Table,sql.Keyword(Info)+','+sql.Keyword(ID),
          sql.CondLike(Info,sql.MakeStr(substr+'%'),1),sql.Keyword(Info));
       if not q.eof  then q.MoveBy(CurrentOfs+ofs);
       if not q.eof  then
         begin
           CurrentOfs:=CurrentOfs+ofs;
           Data:=q.FieldByName(ID).AsInteger;
           LabelEdit.Edit.SelStart:=0;
           LabelEdit.Edit.SelLength:=length(substr)
         end;
       q.Free;
    end;
end;
begin
  if Key=vk_up then DoMove(-1);
  if Key=vk_Down then DoMove(1);
end;

procedure TLabelEditBmpBtn.KeyPress(Sender:TObject;var Key:char);
var i,j:integer;
    q:TQuery;
    s:string;
begin
  if (Table<>'') and (ID<>'') and (Info<>'') then
    begin
      case Key of
        #27:
          begin
            LabelEdit.Text:=PrevInfo;
            Data:=PrevData;
            substr:='';
          end;
        else
          begin
            j:=-1;
            i:=0;
            if Key<>#8 then
              s:=substr+Key
            else
              s:=Copy(substr,1,length(substr)-1);
            if s='' then
              begin
                Data:=0;
                substr:=s;
              end
            else
              begin
                q:=sql.Select(Table,sql.Keyword(Info)+','+sql.Keyword(ID),
                   sql.CondLike(Info,sql.MakeStr(s+'%'),1),sql.Keyword(Info));
                if not q.eof  then
                  begin
                    Data:=q.FieldByName(ID).AsInteger;
                    substr:=s;
                    CurrentOfs:=0;
                  end;
                q.Free;
              end;
            Key:=#0
          end
      end;
      LabelEdit.Edit.SelStart:=0;
      LabelEdit.Edit.SelLength:=length(substr)
    end;
end;

procedure TLabelEditBmpBtn.OnLabelEnter(Sender:TObject);
begin
  PrevInfo:=LabelEdit.Text;
  PrevData:=Data;
end;

procedure TLabelEditBmpBtn.OnLabelEditExit(Sender:TObject);
begin
  substr:='';
  LabelEdit.Edit.SelStart:=0;
  LabelEdit.Edit.SelLength:=length(substr)
end;


procedure TLabelEditBmpBtn.WriteText(s:string);
begin
  LabelEdit.Text:=s
end;

Function TLabelEditBmpBtn.ReadText:string;
begin
  ReadText:=LabelEdit.Text
end;

procedure Register;
begin
  RegisterComponents('MyOwn',[TLabelEditBMPBtn])
end;



end.
