unit ImpLotus;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, Buttons;

 function ImportLotus(var FileName,Body,ErMsg:string): boolean;
 //Filename - имя файла
 //Body - помещается в краткое описание документа
 //Программа инициатор должна удалять файл после регистрации документа
 // Result:=True - все нормально
 // Result:=False - Отмена или ошибка при выполнении модуля, если ErrorMsg<>''
type
  TFImpLotus = class(TForm)
    MessageList: TStringGrid;
    Panel1: TPanel;
    Information: TLabel;
    GetDoc: TSpeedButton;
    ViewDoc: TSpeedButton;
    SpeedButton3: TSpeedButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    MessageText: TMemo;
    ImpBody: TCheckBox;
    ImpDocs: TComboBox;
    StaticText1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MessageListSelectCell(Sender: TObject; Col, Row: longint;
      var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ViewDocClick(Sender: TObject);
    procedure GetDocClick(Sender: TObject);
  private
    procedure ResizeCols;
    procedure FillMessageList;
  public
    { Public declarations }
  end;

var
  FImpLotus: TFImpLotus;

implementation

{$R *.DFM}

uses ComObj,ShellApi,inifiles;

const
  colCount      = 4;
  colFilesCount = 0;
  colFrom       = 1;
  colSubject    = 2;
  colReceived   = 3;
  colMessage    = 4;
  colw           = 10;
  colwFilesCount = colw*5;
  colwReceived   = colw*12;

var
  LO,LDB,docs:variant;
  colwMessage: integer=colw*40;
  colwFrom: integer=colw*22;
  colwSubject:integer=colw*15;
  TempPath: array [0..255] of char;
  MessageCount:integer;
  ErrorMsg,FileNameLoc,BodyLoc:string;
  Imp:boolean;

function ImportLotus(var FileName,Body,ErMsg:string): boolean;
begin
  FImpLotus:=TFImpLotus.Create(nil);
  FImpLotus.ShowModal;
  if Imp then
  begin
    Result:=True;
    FileName:=FileNameLoc;
    Body:=BodyLoc;
  end else
  begin
    Result:=False;
    ErMsg:=ErrorMsg;
  end;
  FImpLotus.Free;
end;

function LotusConnect(var ErrorMsg:string):boolean;
var
  FIni:TIniFile;
  Serv,DB:string;
begin
  try
    LO:=CreateOleObject('Notes.NotesSession');
    FIni:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Forms.ini');
    Serv:=FIni.ReadString('Lotus','Server','');
    DB:=FIni.ReadString('Lotus','DataBase','');
    FIni.Free;
    LDB:=LO.GetDatabase(Serv,DB);
//    LDB:=LO.CurrentDataBase.Database;
//    MessageBox(0,'2','',0);
    Result:=True;
  except
    on e:Exception do
    begin
      ErrorMsg:=e.Message;
      Result:=False;
    end;
  end;
end;

procedure TFImpLotus.FormCreate(Sender: TObject);
begin
  if not LotusConnect(ErrorMsg) then exit;
  Information.Caption:='Система Lotus Notes '+LO.NotesVersion+' Пользователь - '+LO.UserName;
  GetTempPath(200,@TempPath[0]);
  with MessageList do
  begin
    Cells[colFilesCount, 0]:='Файлов';
    Cells[colFrom, 0]      :='Отправитель';
    Cells[colSubject, 0]   :='Тема';
    Cells[colReceived, 0]  :='Получено';
  end;
  ResizeCols;
  FillMessageList;
  Imp:=False;
end;

procedure TFImpLotus.ResizeCols;
begin
  with MessageList do
  begin
    colwSubject:=Width-(colwFilesCount+colwFrom+colwReceived);
    ColWidths[colFilesCount]  :=colwFilesCount;
    ColWidths[colFrom]        :=colwFrom;
    ColWidths[colSubject]     :=colwSubject;
    ColWidths[colReceived]    :=colwReceived;
  end;
end;

procedure TFImpLotus.FillMessageList;
var
  doc,docn,EOS,EO:variant;
  i,j:integer;
begin
   MessageList.RowCount:=2;
   MessageList.FixedRows:=1;
   MessageCount:=0;
  try
    docs:=LDB.AllDocuments;
  except
    exit;
  end;
  for i:=1 to docs.Count do
  begin
    if i=1 then docn:=docs.GetFirstDocument else docn:=docs.GetNextDocument(doc);
    doc:=docn;
    MessageCount:=MessageCount+1;
    MessageList.RowCount:=MessageCount+1;
    try
    MessageList.Cells[colFrom,MessageCount]:=doc.GetFirstItem('From').Text;
    except
    end;
    try
    MessageList.Cells[colSubject,MessageCount]:=doc.GetFirstItem('Subject').Text;
    except
    end;
    try
      MessageList.Cells[colReceived,MessageCount]:=doc.GetFirstItem('DeliveredDate').Text;// DateToStr(MapiMessage.TimeReceived);
    except
      MessageList.Cells[colReceived,MessageCount]:='';
    end;
    try
    EOS:=doc.GetFirstItem('Body').EmbeddedObjects;
    except
    end;
    j:=0;
    try
    if doc.HasEmbedded then
    begin
      while true do
      begin
        try
          EO:=EOS[j];
        except
          break;
        end;
        j:=j+1;
      end;
    end;
    except
    end;
    MessageList.Cells[colFilesCount,MessageCount]:=IntToStr(j);
  end;
end;


procedure TFImpLotus.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  LO:=Unassigned;
end;

procedure TFImpLotus.MessageListSelectCell(Sender: TObject; Col,
  Row: longint; var CanSelect: Boolean);
var
  doc,docn,EO,EOS:variant;
  i,j:integer;
begin
  for i:=1 to docs.count do
  begin
    if i=1 then docn:=docs.GetFirstDocument else docn:=docs.GetNextDocument(doc);
    doc:=docn;
    if i=Row then break;
  end;
  MessageText.Lines.Text:=doc.GetFirstItem('Body').Text;
  ImpDocs.Items.Clear;
  ImpDocs.Text:='';
  EOS:=doc.GetFirstItem('Body').EmbeddedObjects;
  j:=0;
  if doc.HasEmbedded then
  begin
    while true do
    begin
      try
        EO:=EOS[j];
      except
        break;
      end;
      ImpDocs.Items.Add(EO.Name);
      j:=j+1;
    end;
  end;
  ImpDocs.ItemIndex:=0;
  ImpDocs.Enabled:=ImpDocs.Items.Count<>0;
  ViewDoc.Enabled:=ImpDocs.Items.Count<>0;
  GetDoc.Enabled:=ImpDocs.Items.Count<>0;
end;

procedure TFImpLotus.FormShow(Sender: TObject);
var
  tmp:boolean;
begin
  if MessageCount>0 then MessageListSelectCell(Sender,0,1,tmp)
  else begin
    GetDoc.Enabled:=False;
    ViewDoc.Enabled:=False;
    ImpDocs.Enabled:=False;
  end;
end;

procedure TFImpLotus.FormResize(Sender: TObject);
begin
  ResizeCols;
end;

procedure TFImpLotus.SpeedButton3Click(Sender: TObject);
begin
  Close;
end;

procedure TFImpLotus.ViewDocClick(Sender: TObject);
var
  doc,docn,EO:variant;
  i:integer;
begin
  for i:=1 to docs.count do
  begin
    if i=1 then docn:=docs.GetFirstDocument else docn:=docs.GetNextDocument(doc);
    doc:=docn;
    if i=MessageList.Row then break;
  end;
  try
  EO:=doc.GetFirstItem('Body').GetEmbeddedObject(ImpDocs.Text);
  except
  end;
  try
  FileNameLoc:=TempPath+ImpDocs.Text;
  except
  end;
  try
  EO.ExtractFile(FileNameLoc);
  except
  end;
  ShellExecute(0,'Open',PChar(ImpDocs.Text),'',TempPath,SW_SHOWNORMAL);
end;

procedure TFImpLotus.GetDocClick(Sender: TObject);
var
  i:integer;
  doc,docn,EO:variant;
begin
  for i:=1 to docs.count do
  begin
    if i=1 then docn:=docs.GetFirstDocument else docn:=docs.GetNextDocument(doc);
    doc:=docn;
    if i=MessageList.Row then break;
  end;
  EO:=doc.GetFirstItem('Body').GetEmbeddedObject(ImpDocs.Text);
  FileNameLoc:=TempPath+ImpDocs.Text;
  EO.ExtractFile(FileNameLoc);
  if ImpBody.Checked then BodyLoc:=MessageText.Lines.Text;
  Imp:=True;
  Close;
end;

end.
