unit Dsfuns;

interface
uses dsapi,dsapicom,WinProcs,WinTypes,SysUtils,IniFiles,Classes,tsqlcls,
     forms
{$ifdef WIN32}
,syncobjs
{$endif}
;

const DS_SUCCESS =   0; { document server success}
const SUCCESS    = 100; { success }
{$ifdef DSQuery}
      scDocumentServer:string[20]='Document Server';
{$endif}

type

DS_TUserDescriptor=record
    SystemID:          longint;  { Client's system ID}
    UserID:            longint;  { User's ID }
end;

TDocumentService=class(TObject)
protected
  DLLName:TFileName;
  hDLL:THandle;
  DocumentServer:DS_TAbstractDocumentServer;
  fAppIniFile:string;
  {*** Added by Egorov Pavel}
  {$ifdef WIN32}
  CriticalSection : TCriticalSection;
  {$endif}
  function GetErrorMessage:string;
  function GetError:longint;
  procedure PrintError;
  Function GetStr(l:longint;n:integer):string;
  Function GetNum(s:string):longint;
  function RunFunction(FunName:PChar):longint;
  {*** Added by Egorov Pavel}
  function CheckDirExists(Dir : string) : boolean;
  function GetVersion(DirPath : string):longint;
  procedure LockCriticalSection;
  procedure UnLockCriticalSection;
  procedure ClearViewDir;
  {***}
public
  PrintFlag:boolean;
  UEDP:DS_RUnifiedExchangeDataPacket;
  constructor Create(aAppIniFile:string);
  destructor Destroy; override;
  function Put(FileName:string;DocID,VerID:longint;var DSID:longint):longint;
  function Get(var FileName:string;DocID,VerID,DSID:longint;EditMode:boolean):longint;
  function Delete(DocID,VerID,DSID:longint):longint;
  function Archive(DocID,VerID,DSID:longint):longint;
  function DeArchive(DocID,VerID,DSID:longint):longint;
  function Query(s:string;sl:TStrings):longint;
  function UnLock(DocID,VerID:longint):longint;
  {*** Added by Egorov Pavel}
  function Lock(DocID,VerID:longint):longint;
  function GetEditFiles : TStrings;
  function UnlockEditDoc(DocId,VerId : longint; SaveMode: boolean) : integer;
  {***}
  function Settings:longint;
  function IsDLLLoad:boolean;
  property Error:longint read GetError;
  property ErrorMessage:string read GetErrorMessage;
end;


implementation
uses
  Dialogs,Controls;

function TDocumentService.IsDLLLoad:boolean;
begin
  IsDLLLoad:=hDLL>=HINSTANCE_ERROR;
end;

function TDocumentService.GetError:longint;
var p:TFarProc;
    p1:TDS_ErrorCode;
begin
  if IsDLLLoad then
    begin
      p:=GetProcAddress(hDLL,'DS_ErrorCode');
      if p<>NIL then
        begin
          p1:=TDS_ErrorCode(p);
          GetError:=p1(DocumentServer);
        end
    end
  else
    GetError:=200;
end;

function TDocumentService.GetErrorMessage:string;
var p:TFarProc;
    p1:TDS_ErrorMessage;
begin
  if IsDLLLoad then
    begin
      p:=GetProcAddress(hDLL,'DS_ErrorMessage');
      if p<>NIL then
        begin
          p1:=TDS_ErrorMessage(p);
          GetErrorMessage:=p1(DocumentServer);
        end
    end
  else
    GetErrorMessage:='Не загружена библиотека для работы с файлами '+DLLName;
end;

procedure TDocumentService.PrintError;
var s:string;
begin
  if IsDLLLoad then
    begin
      if Error<>DS_SUCCESS then
        begin
          s:=ErrorMessage+#0;
          if PrintFlag then
            MessageBox(Screen.ActiveForm.Handle,@s[1],'Ошибка',0);
        end;
    end;
end;

constructor TDocumentService.Create(aAppIniFile:string);
var id:DS_TInitData;
    p:TFarProc;
    p1:TDS_CreateDocumentServer;
    f:TIniFile;
begin
  inherited Create;
  PrintFlag:=TRUE;
  fAppIniFile:=aAppIniFile;
  ClearViewDir;
  {$ifdef WIN32}
  CriticalSection:= TCriticalSection.Create;
  {$endif}
  {$ifdef DSQuery}
  f:=TIniFile.Create(aAppIniFile);
  id.ServerName:=f.ReadString(scDocumentServer,'ServerName','C090');
  id.Port:=f.ReadInteger(scDocumentServer,'Port',300);
  id.Protocol:=integer(UpperCase(f.ReadString(scDocumentServer,'Protocol','TCPIP'))='IPX');
  id.DataReceiveTimeOutMSecs:=f.ReadInteger(scDocumentServer,'DataReceiveTimeOutMSecs',0);
  id.DataSendTimeOutMSecs:=f.ReadInteger(scDocumentServer,'DataSendTimeOutMSecs',0);
  f.Free;
  {$else}
  id.ServerName:=aAppIniFile;
  {$endif}
  {$ifdef WIN32}
  hDLL:=LoadLibrary('dsapi.dll');
  {$else}
  hDLL:=LoadLibrary('dsapi16.dll');
  {$endif}
  if IsDLLLoad then
    begin
      p:=GetProcAddress(hDLL,'DS_CreateDocumentServer');
      if p<>NIL then
        begin
          p1:=TDS_CreateDocumentServer(p);
          DocumentServer:=p1(id);
        end
    end;
  PrintError
end;

destructor TDocumentService.Destroy;
var p:TFarProc;
    p1:TDS_DestroyDocumentServer;
begin
  {$ifdef WIN32}
  CriticalSection.free;
  {$endif}
  if IsDLLLoad then
    begin
      p:=GetProcAddress(hDLL,'DS_DestroyDocumentServer');
      if p<>NIL then
        begin
          p1:=TDS_DestroyDocumentServer(p);
          p1(DocumentServer);
        end;
      FreeLibrary(hDLL)
    end;
  inherited Destroy;
end;

function TDocumentService.RunFunction(FunName:PChar):longint;
var p:TFarProc;
    p1:TDS_Function;
    l:longint;
begin
  l:=200;
  if IsDLLLoad then
    begin
      p:=GetProcAddress(hDLL,FunName);
      if p<>NIL then
        begin
          p1:=TDS_Function(p);
          l:=p1(DocumentServer,UEDP);
        end
    end;
  if ((l=DS_cErrorVersionNotFound) or (l=DS_cErrorDocumentNotFound)) and
    ((StrPas(FunName)='DS_cmdDelete') or (StrPas(FunName)='DS_cmdArchive')) then
    l:=DS_SUCCESS;
  if l<>DS_SUCCESS then
    PrintError;
  RunFunction:=l;
end;

function TDocumentService.Put(FileName:string;DocID,VerID:longint;var DSID:longint):longint;
var f:TIniFile;
begin
  LockCriticalSection;
  UEDP.DocIDInClientSystem:=DocID;
  UEDP.VerIDInClientSystem:=VerID;
  UEDP.VerIDOnServer:=DSID;
  UEDP.FileTypeID:=sql.SelectInteger('ERC','FileTypeID',sql.CondIntEqu('ID',DocID));
  if FileName<>'' then
    UEDP.FileName:=FileName
  else
    begin
      f:=TIniFile.Create(fAppIniFile);
      UEDP.FileName:=f.ReadString('COMMON','OutputDir','')+GetStr(DocID,8)+'.'+GetStr(VerID,3);
      f.Free;
    end;
  Result:=RunFunction('DS_cmdPut');
  DSID:=UEDP.VerIDOnServer;
  {*** Added by Egorov Pavel }
  UnLockCriticalSection;
  if Result <> DS_SUCCESS then
    if MessageDlg('Ошибка передачи файла на сервер '+#10#13+
               'Вы можете попытаться еще раз передать файл '+#10#13+
               'на сервер или продолжить работу, а файл передать позднее'+#10#13+
               'Попытаться передать файл еще раз?',
               mtError,[mbNo,mbYes],0) = mrYes then
       Result:= Put(FileName,DocID,VerID,DSID);
  {***}
end;

procedure TDocumentService.LockCriticalSection;
begin
  {$ifdef WIN32}
  CriticalSection.Enter;
  {$endif}
end;

procedure TDocumentService.UnLockCriticalSection;
begin
  {$ifdef WIN32}
  CriticalSection.Leave;
  {$endif}
end;

{$I+}
function TDocumentService.CheckDirExists(Dir : string) : boolean;
var
  LastDir : string;
begin
  GetDir(0,LastDir);
  try
    ChDir(Dir);
    Result:= TRUE;
  except
    Result:= FALSE;
  end;
  ChDir(LastDir);
end;

function TDocumentService.GetVersion(DirPath : string):longint;
begin
  if not CheckDirExists(DirPath) then
  {$ifdef WIN32}
    CreateDir(DirPath);
  {$else}
    MkDir(DirPath);
  {$endif}
  UEDP.FileName:= DirPath+GetStr(UEDP.DocIDInClientSystem,8)+'.'+
                              GetStr(UEDP.VerIDInClientSystem,3);
  if FileExists(UEDP.FileName) then
    Result:= SUCCESS
  else
    Result:= RunFunction('DS_cmdGet');
end;

function TDocumentService.Get(var FileName:string;DocID,VerID,DSID:longint;EditMode:boolean):longint;
var
  IniFile   : TIniFile;
  OutputDir : string;
begin
  LockCriticalSection;
  UEDP.DocIDInClientSystem:=DocID;
  UEDP.VerIDInClientSystem:=VerID;
  UEDP.VerIDOnServer:=DSID;
  UEDP.IsEditMode:=EditMode;
  UEDP.AutoUnlockDateTime:=now+10;

  {*** Added by Egorov Pavel}
  IniFile:=TIniFile.Create(fAppIniFile);
  OutputDir:=IniFile.ReadString('COMMON','OutputDir','');
  IniFile.Free;

  if EditMode then
    Result:= GetVersion(OutputDir+'EditDir\')
  else
    Result:= GetVersion(OutputDir+'ViewDir\');
  FileName:= UEDP.FileName;
  UnLockCriticalSection;
  {***}
end;

procedure TDocumentService.ClearViewDir;
var
  IniFile   : TIniFile;
  ViewDir   : string;
  SearchRec : TSearchRec;
  Result    : integer;
begin
  IniFile:=TIniFile.Create(fAppIniFile);
  ViewDir:=IniFile.ReadString('COMMON','OutputDir','') + 'ViewDir\';
  IniFile.Free;
  if  CheckDirExists(ViewDir)then
    begin
      Result:= FindFirst(ViewDir+'*.*',faAnyFile XOR faDirectory, SearchRec);
      while Result = 0 do
        begin
          DeleteFile(ViewDir+SearchRec.Name);
          Result:= FindNext(SearchRec);
        end;
      FindClose(SearchRec);
    end;
end;

function TDocumentService.GetEditFiles : TStrings;
var
  IniFile   : TIniFile;
  EditDir   : string;
  SearchRec : TSearchRec;
  SearchResult : integer;
  EditFiles  : TStrings;
  nstr       :string;
begin
  EditFiles:= TStringList.Create;
  IniFile:=TIniFile.Create(fAppIniFile);
  EditDir:=IniFile.ReadString('COMMON','OutputDir','') + 'EditDir\';
  IniFile.Free;
  if  CheckDirExists(EditDir)then
    begin
      SearchResult:= FindFirst(EditDir+'*.*',faAnyFile XOR faDirectory, SearchRec);
      if SearchResult <> 0 then
        EditFiles.Add('(1=0)');
      while SearchResult = 0 do
        begin
          nstr:='("DocID"='+inttostr(GetNum(copy(SearchRec.Name,1,8)))+
                ' AND "VerN"='+inttostr(GetNum(copy(SearchRec.Name,10,3)))+')';
          SearchResult:= FindNext(SearchRec);
          if SearchResult = 0 then
            nstr:=nstr+' OR ';
          EditFiles.Add(nstr);
        end;
      FindClose(SearchRec);
    end;
  Result:= EditFiles;
end;

function TDocumentService.UnlockEditDoc(DocId,VerId : longint; SaveMode: boolean) : integer;
var
  FileName : string;
  IniFile  : TIniFile;
  DSID     : longint;
begin
  IniFile:=TIniFile.Create(fAppIniFile);
  FileName:=IniFile.ReadString('COMMON','OutputDir','') +
            'EditDir\'+GetStr(DocId,8)+'.'+GetStr(VerId,3);
  IniFile.Free;
  if SaveMode then
    Result:= Put(FileName,DocId,VerId,DSID)
  else
    Result:= UnLock(DocId,VerId);
  if Result = DS_SUCCESS then
    DeleteFile(FileName);
end;

function TDocumentService.Delete(DocID,VerID,DSID:longint):longint;
begin
  LockCriticalSection;
  UEDP.DocIDInClientSystem:=DocID;
  {$ifdef DSQuery}
  if VerID=0 then VerID:=DS_cAllVersions;
  {$endif}
  UEDP.VerIDInClientSystem:=VerID;
  UEDP.VerIDOnServer:=DSID;
  Delete:=RunFunction('DS_cmdDelete');
  UnLockCriticalSection;
end;

function TDocumentService.Archive(DocID,VerID,DSID:longint):longint;
begin
  LockCriticalSection;
  UEDP.DocIDInClientSystem:=DocID;
  {$ifdef DSQuery}
  if VerID=0 then VerID:=DS_cAllVersions;
  {$endif}
  UEDP.VerIDInClientSystem:=VerID;
  UEDP.VerIDOnServer:=DSID;
  UEDP.ArchiveAction:=DS_cArchive;
  Archive:=RunFunction('DS_cmdArchive');
  UnLockCriticalSection;
end;

function TDocumentService.DeArchive(DocID,VerID,DSID:longint):longint;
begin
  LockCriticalSection;
  UEDP.DocIDInClientSystem:=DocID;
  {$ifdef DSQuery}
  if VerID=0 then VerID:=DS_cAllVersions;
  {$endif}
  UEDP.VerIDInClientSystem:=VerID;
  UEDP.VerIDOnServer:=DSID;
  UEDP.ArchiveAction:=DS_cRestore;
  DeArchive:=RunFunction('DS_cmdArchive');
  UnLockCriticalSection;
end;

function TDocumentService.Settings:longint;
begin
  Settings:=RunFunction('DS_cmdSettings');
end;

Function TDocumentService.GetStr(l:longint;n:integer):string;
var s:string;
BEGIN
  s:='';
  while l<>0 do
    begin
      s:=chr((l mod 26)+ord('A'))+s;
      l:=l div 26;
    end;
  while length(s)<n do
    s:='A'+s;
  GetStr:=s;
End;

Function TDocumentService.GetNum(s:string):longint;
var
  i:integer;
  l:longint;
BEGIN
  l:=0;
  for i:=1 to length(s) do
   l:=l*26+(ord(s[i])-ord('A'));
  GetNum:=l;
End;

function TDocumentService.Query(s:string;sl:TStrings):longint;
var  QueryResults:  array [0..100] of DS_TQueryResult;
     i:longint;
begin
  LockCriticalSection;
  UEDP.QueryString:=s;
  UEDP.QueryStartFrom:=0;
  UEDP.QueryResultsCount:=100;
  UEDP.QueryResult:=@QueryResults;
  i:=RunFunction('DS_cmdQuery');
  Query:=i;
  if (i<>DS_SUCCESS) or (UEDP.QueryResultsCount=0) then
    sl.Add('1=0')
  else
    begin
      sl.Add('(');
      for i:=0 to UEDP.QueryResultsCount-1 do
        begin
          sl.Add(sql.CondIntEqu('ID',QueryResults[i].DocIDInClientSystem));
          if i<>UEDP.QueryResultsCount-1 then
            sl.Add(LogOR);
        end;
      sl.Add(')');
    end;
  UnLockCriticalSection;
end;

function TDocumentService.UnLock(DocID,VerID:longint):longint;
var f:TIniFile;
begin
  LockCriticalSection;
  UEDP.DocIDInClientSystem:=DocID;
  UEDP.VerIDInClientSystem:=VerID;
  UnLock:=RunFunction('DS_cmdUnLockVersion');
  UnLockCriticalSection;
end;

function TDocumentService.Lock(DocID,VerID:longint):longint;
var f:TIniFile;
begin
  LockCriticalSection;
  UEDP.DocIDInClientSystem:=DocID;
  UEDP.VerIDInClientSystem:=VerID;
  Lock:=RunFunction('DS_cmdLockVersion');
  UnLockCriticalSection;
end;

end.
