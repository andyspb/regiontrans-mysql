
                     unit Form_ImportEMail;

{$H+}

{*************************************************************}
{*}                        interface                        {*}
{*************************************************************}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Tadjform, StdCtrls, Buttons, BMPBtn, Grids,ActiveX,
  LanImp,ExtCtrls,IniFiles,Sqlctrls,LblMemo,  ComCtrls, Spin;

function ImportEmail(var Params: TLanImportInfo): integer;
function CommitImportEmail:  boolean;
function GetIEMMessageError:string;

type
  TFormImportEMail = class(TAdjustForm)
    lblmemoMessage: TLabelMemo;
    GroupBox1: TGroupBox;
    checkImportNoteText: TCheckBox;
    comboFiles: TComboBox;
    lFiles: TLabel;
    SGMess: TStringGrid;
    btnImport: TBMPBtn;
    btnCancel: TBMPBtn;
    btnViewDocument: TBMPBtn;
    SGIDMsg: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SGMessSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean);
    procedure SGMessDblClick(Sender: TObject);
    procedure btnViewDocumentClick(Sender: TObject);
  private
    procedure FillGridMessages;
    procedure ResizeCols;
  public
end;


{*************************************************************}
{*}                     implementation                      {*}
{*************************************************************}

{$R *.DFM}
Uses ComObj,Filefuns,ShellApi;

const
  colCount      = 4;
  colFilesCount = 0;
  colFrom       = 1;
  colSubject    = 2;
  colReceived   = 3;
  colMessage    = 4;
  colw           = 10;
  colwFilesCount = colw*5;
  colwSubject    = colw*15;
  colwReceived   = colw*12;

var
  ImportedMessageID: string;
  MO: variant;
  colwMessage: integer=colw*40;
  colwFrom: integer=colw*22;
  IEMErrorMsg: string;
  Error: boolean;
  FormImportEMail: TFormImportEMail;
  AttemptImport: integer;
  MsgCount: integer;
  FileDesc, FileName:  string;
  TempPath: array [0..255] of char;
  ProName,Pass:string;

function GetIEMMessageError:string;
begin
   Result:=IEMErrorMsg;
end;

//------------------------------------------------------------
function CommitImportEmail:  boolean;
var
   Logon:boolean;
begin
   if ImportedMessageID='' then begin Result:=False; exit; end;
   Logon:=False;
   Error:=False;
   try
      OleInitialize(nil);
      MO:=CreateOleObject('MAPI.Session');
      MO.Logon(profileName:=ProName,profilePassword:=Pass);
      Logon:=True;
      MO.GetMessage(ImportedMessageID).Delete;
      DelFile(FileName);
   except
      on e:Exception do
      begin
         IEMErrorMsg:=e.Message;
         Result:=False;
         Error:=True;
      end;
   end;
   if not Error then Result:=True;
   if Logon then MO.Logoff;
end;

function ImportEmail(var Params:TLanImportInfo): integer;
var IniFile:TIniFile;
begin
   Error:=False;
   IEMErrorMsg:='';
   IniFile:=TIniFile.Create(Params.IniFileName);
   ProName:=IniFile.ReadString(LanImpSect,LanImpName,'');
   Pass:=IniFile.ReadString(LanImpSect,LanImpPass,'');
   IniFile.Free;
   try
      OleInitialize(nil);
      MO:=CreateOleObject('MAPI.Session');
      MO.Logon(profileName:=ProName,profilePassword:=Pass);
   except
      on e:Exception do
      begin
         IEMErrorMsg:=e.Message;
         Error:=True;
      end;
   end;
   if Error then begin Result:=2; exit; end;
   FormImportEMail:=TFormImportEMail.Create(nil);
   ImportedMessageID:='';
   with FormImportEMail do
   begin
      ShowModal;
      if AttemptImport=0 then
      begin
         StrPCopy(Params.ResultFileName,FileName);
         StrPCopy(Params.ResultDescription,FileDesc);
      end;
      Result:=AttemptImport;
   end;
   MO.Logoff;
   FormImportEMail.Free;
end;

procedure TFormImportEMail.FormCreate(Sender: TObject);
begin
   Section:='ImportEMail';
   GetTempPath(200,@TempPath[0]);
   with SGMess do
   begin
      ColCount:=colCount;
      Cells[colFilesCount, 0]:='Файлов';
      Cells[colFrom, 0]      :='Отправитель';
      Cells[colSubject, 0]   :='Тема';
      Cells[colReceived, 0]  :='Получено';
      ResizeCols;
      lblmemoMessage.Memo.ScrollBars:=ssboth;
    end;
end;

procedure TFormImportEMail.ResizeCols;
begin
   with SGMess do
   begin
      colwFrom:=Width-(colwFilesCount+colwSubject+colwReceived);
      ColWidths[colFilesCount]  :=colwFilesCount;
      ColWidths[colFrom]        :=colwFrom;
      ColWidths[colSubject]     :=colwSubject;
      ColWidths[colReceived]    :=colwReceived;
   end;
end;

//------------------------------------------------------------
procedure TFormImportEMail.btnImportClick(Sender: TObject);
var
  MapiMessage: variant;
begin
  ImportedMessageID:=SGIDMsg.Cells[0,SGMess.Row];
  FileName:='';
  FileDesc:='';
  try
     MapiMessage:=MO.GetMessage(ImportedMessageID);
     if comboFiles.Visible then
     begin
        FileName:=TempPath+ComboFiles.Text;
        MapiMessage.Attachments.Item[comboFiles.ItemIndex+1].WriteToFile(FileName);
     end;
     if (checkImportNoteText.Visible)and(checkImportNoteText.State=cbChecked) then
        FileDesc:=MapiMessage.Text;
     if (FileName<>'')or(FileDesc<>'') then
     begin
        AttemptImport:=0;
        Close;
     end;
  except
     on e:Exception do
     begin
        IEMErrorMsg:=e.Message;
        AttemptImport:=2;
     end;
  end;
end;


//------------------------------------------------------------
procedure TFormImportEMail.btnCancelClick(Sender: TObject);
begin
  AttemptImport:=1;
  Close;
end;

//------------------------------------------------------------
procedure TFormImportEMail.FillGridMessages;
var
  MapiMessages,MapiMessage:variant;
begin
   SGMess.RowCount:=2;
   SGMess.FixedRows:=1;
   MsgCount:=0;
   MapiMessages:=MO.Inbox.Messages;
   MapiMessages.Sort[2];
   MapiMessage:=MapiMessages.GetFirst;
   while TVarData(MapiMessage).VBoolean do
      with SGMess do
      begin
         MsgCount:=MsgCount+1;
         RowCount:=MsgCount+1;
         SGIDMsg.RowCount:=MsgCount+1;
         SGIDMsg.Cells[0,MsgCount]:=MapiMessage.ID;
         Cells[colFilesCount,MsgCount]:=IntTostr(MapiMessage.Attachments.Count);
         Cells[colFrom,MsgCount]:=MapiMessage.Sender.Name+' ['+MapiMessage.Sender.Address+']';
         Cells[colSubject,MsgCount]:=MapiMessage.Subject;
         Cells[colReceived,MsgCount]:=DateToStr(MapiMessage.TimeReceived);
         MapiMessage:=MapiMessages.GetNext;
      end;
   btnImport.Enabled:=MsgCount<>0;
end;

procedure TFormImportEMail.FormResize(Sender: TObject);
begin
  ResizeCols;
end;

//------------------------------------------------------------
procedure TFormImportEMail.FormShow(Sender: TObject);
var tmp:boolean;
begin
  FillGridMessages;
  if MsgCount>0 then SGMessSelectCell(Sender,0,1,tmp)
  else begin
     btnViewDocument.Enabled:=False;
     comboFiles.Visible:=False;
     lFiles.Visible:=False;
     checkImportNoteText.Visible:=False;
  end;
  AttemptImport:=1;
end;

procedure TFormImportEMail.SGMessSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
var
  MapiMessage: variant;
  i: integer;
begin
  if Row=0 then exit;
  MapiMessage:=MO.GetMessage(SGIDMsg.Cells[0,Row]);
  lblmemoMessage.Memo.Lines.Clear;
  lblmemoMessage.Memo.Lines.Add(MapiMessage.Text);
  lblmemoMessage.Memo.SelStart:=0;
  lblmemoMessage.Memo.SelLength:=0;
  checkImportNoteText.Visible:=MapiMessage.Text<>'';
  lFiles.Visible:=MapiMessage.Attachments.Count<>0;
  comboFiles.Visible:=lFiles.Visible;
  comboFiles.Clear;
  for i:=1 to MapiMessage.Attachments.Count do
  begin
     if MapiMessage.Attachments.Item[i].Name<>'' then
        comboFiles.Items.Add(MapiMessage.Attachments.Item[i].Name)
     else
        comboFiles.Items.Add(MapiMessage.Attachments.Item[i].Source)
  end;
  if comboFiles.Visible then
  begin
     comboFiles.ItemIndex:=0;
     comboFiles.Text:=comboFiles.Items[0];
  end;
  btnViewDocument.Enabled:=comboFiles.Visible;
end;


procedure TFormImportEMail.SGMessDblClick(Sender: TObject);
begin
  btnImportClick(Sender);
end;

procedure TFormImportEMail.btnViewDocumentClick(Sender: TObject);
var
   MapiMessage:variant;
begin
   MapiMessage:=MO.GetMessage(SGIDMsg.Cells[0,SGMess.Row]);
   FileName:=TempPath+ComboFiles.Text;
   MapiMessage.Attachments.Item[comboFiles.ItemIndex+1].WriteToFile(FileName);
   ShellExecute(0,'Open',PChar(ComboFiles.Text),'',TempPath,SW_SHOWNORMAL);
end;

end.
