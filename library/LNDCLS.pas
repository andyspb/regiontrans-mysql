unit Lndcls;

interface

Uses Forms,tadjform,Classes,DBTables,SysUtils,WinTypes,IniFiles,MakeRepp,dsfuns,
     filefuns,WinProcs,LanImp,dialogs,ddefuns
{$ifdef WIN32}
  ,Form_ImportEMail
  ,AppManager
{$endif}
;

type

fstrType= string[20];
TString128=string[128];

{$I ldconsts.inc}


Const
{ini strings }
  sLANDOCS_OPTIONS='LANDOCS OPTIONS';
  sCommon= 'Common';
  sDocumDir='DocumDir';
  sArchivDir='ArchivDir';
  sDeletedDir='DeletedDir';
  sUnsortDir='UnsortDir';
  sSaveLastConnection='SaveLastConnection';
  sLastConnection='LastConnection';
  sClearRegCard='ClearRegCard';
  sPrintRegCard='PrintRegCard';

Var IniDirectory:TFileName;
    UserFunAccess:set of byte;
    UserDataAccess:longint;
    CurUserName:String[127];
    CurLoginName:String[127];
    CurUserID:longint;
    CurDepartmentID:longint;
    RegDepartmentID:longint;
    PhysicalUserID,
    LicType:longint;
    SupervisorFlag:boolean;
    ViewDocFlag:boolean;

const
  LanAppSection='LanDocs Applications';

type
TLDCardType=class
  public
    ID:longint;
    Name,ViewName:TString128;
    constructor Create(q:Tquery);
end;

TLanDocsClass=class
  private
    fCardTypes:TList;
    function ReadCardType(l:Longint):TLDCardType;
    function ReadCardTypeCount:longint;
    function PrnRef(l:longint):string;
    function PrnDate(dt:TDateTime):string;
    function RunFunInt(FunName:String;Parms:TStrings):longint;
    function GetStr(l:longint;n:integer):string;
  public
    ErrorMessage:string;
    ResultDDE:string;
    PrintErrorFlag:boolean;
    {$ifdef WIN32}
    ApplicationManager : TApplicationManager;
    {$endif}
    constructor Create;
    destructor Destroy;
    procedure PrintError(em:string);

    { Directory functions}
    function TemplateDocDir:string;
    function UnSortDir:string;
    function OutputDir:string;
    function TemplateDir:string;

    function NewDispatch(aERCID,aSenderID,aPartnerID,aDeliveryTypeID:longint;
        aRecDate:TDateTime;aCopies:longint;aComments:PChar):longint;
    function EditDispatch(aMailID,aPartnerID,aDeliveryTypeID:longint;
        aRecDate:TDateTime;aCopies:longint;aComments:PChar):longint;
    function MakeReport(Handle:THandle;JournalID:longint;RPTName,DefaultFile:TString128;
        Params:TStrings;PageCount:longint):integer;
    function SelectImportFile(ImportType,DocumTypeID,FileTypeID:longint):string;
    function StartApplication(FileTypeID:longint;EditMode:boolean;cmdstr:string):integer;
    function OpenVersion(DocID,N:Longint;EditMode,WaitTerm:boolean):integer;
    function GetApplication(FileTypeID:longint;EditMode:boolean):string;
    { Document Template functions}
    function SaveTemplateDoc(ID,DocumTypeID,FileTypeID:longint;ShortName,FileName:TString128):longint;
    function DelTemplateDoc(ID:longint):longint;
    function GetTemplateDoc(ID:longint):string;
    function CopyTemplateDoc(ID:longint;s:string):string;
    { Ini functions}
    function GetIniInt(Sec,fname:string;def:longint):longint;
    function GetIniBool(Sec,fname:string;def:boolean):boolean;
    function GetIniStr(Sec,fname:string;def:string):string;
    function CardTypeByID(l:longint):TLDCardType;
    { DDE functions}
    Procedure AppDDECmd(ResultServer,ResultTopic,Cmd:TDDEString;FormFlag:boolean;FileName:TDDEString);
    function GetStatusDoc(DocID:longint):string;

    function UnlockEditDoc(DocId,VerId : longint; SaveMode: boolean) : integer;

    property CardTypes[i:longint]:TLDCardType read ReadCardType;
    property CardTypesCount:longint read ReadCardTypeCount;
end;

Function CheckVersJRight(DocID,RightID:longint):boolean;

var lnd:TLanDocsClass;
    DocSrv:TDocumentService;

implementation
Uses Common,TSQLCls,ImpLotus;

constructor TLDCardType.Create(q:Tquery);
begin
  ID:=q.FieldByName(fID).AsInteger;
  Name:=q.FieldByName(fName).AsString;
  ViewName:=q.FieldByName(fViewName).AsString;
end;


constructor TLanDocsClass.Create;
var q:TQuery;
begin
  {$ifdef WIN32}
  ApplicationManager:= TApplicationManager.Create;
  {$endif}
  PrintErrorFlag:=TRUE;
  fCardTypes:=TList.Create;
  q:=sql.Select(tCardType,'','',sql.Keyword('ID'));
  while not q.eof do
    begin
      fCardTypes.Add(TLDCardType.Create(q));
      q.Next
    end;
  q.Free;
end;

destructor TLanDocsClass.Destroy;
var i:longint;
begin
  for i:=0 to CardTypesCount-1 do
    CardTypes[i].Free;
  fCardTypes.Free;
  {$ifdef WIN32}
  ApplicationManager.free;
  {$endif}
end;

Function TLanDocsClass.GetStr(l:longint;n:integer):string;
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

function TLanDocsClass.PrnRef(l:longint):string;
begin
  if l<>0 then
    PrnRef:=IntToStr(l)
  else
    PrnRef:='NULL';
end;

function TLanDocsClass.PrnDate(dt:TDateTime):string;
begin
  if dt=0 then
    PrnDate:='NULL'
  else
    PrnDate:=sql.ConvertToDate(sql.MakeStr(FormatDateTime('YYYY-MM-DD',dt)));
end;

function TLanDocsClass.RunFunInt(FunName:String;Parms:TStrings):longint;
var q:TQuery;
BEGIN
  q:=sql.RunFunctionEx(FunName,Parms);
  if sql.Error=0 then
    RunFunInt:=q.Fields[0].AsInteger
  else
    RunFunInt:=0;
  q.Free;
end;

function TLanDocsClass.CardTypeByID(l:longint):TLDCardType;
var i:longint;
begin
  CardTypeByID:=NIL;
  for i:=0 to CardTypesCount-1 do
    if CardTypes[i].ID=l then
      begin
        CardTypeByID:=CardTypes[i];
        break;
      end;
end;

function TLanDocsClass.ReadCardType(l:Longint):TLDCardType;
var ct:TLDCardType;
begin
  ReadCardType:=TLDCardType(fCardTypes.Items[l]);
end;

function TLanDocsClass.ReadCardTypeCount:longint;
begin
  ReadCardTypeCount:=fCardTypes.Count;
end;

function TLanDocsClass.NewDispatch(aERCID,aSenderID,aPartnerID,aDeliveryTypeID:longint;
        aRecDate:TDateTime;aCopies:longint;aComments:PChar):longint;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add(PrnRef(aERCID)+','+PrnRef(aSenderID)+','+PrnRef(aPartnerID)+','+
    PrnRef(aDeliveryTypeID)+','+PrnDate(aRecDate)+','+IntToStr(aCopies)+',');
  sql.MultiString(sl,aComments);
  NewDispatch:=RunFunInt('LDF_NewDispatch',sl);
  sl.Free;
end;

function TLanDocsClass.EditDispatch(aMailID,aPartnerID,aDeliveryTypeID:longint;
        aRecDate:TDateTime;aCopies:longint;aComments:PChar):longint;
var sl:TStringList;
begin
  sl:=TStringList.Create;
  sl.Add(PrnRef(aMailID)+','+PrnRef(aPartnerID)+','+
    PrnRef(aDeliveryTypeID)+','+PrnDate(aRecDate)+','+IntToStr(aCopies)+',');
  sql.MultiString(sl,aComments);
  EditDispatch:=RunFunInt('LDF_EditDispatch',sl);
  sl.Free;
end;

function TLanDocsClass.MakeReport(Handle:THandle;JournalID:longint;RPTName,DefaultFile:TString128;
        Params:TStrings;PageCount:longint):integer;
var ReportMakerWP:TReportMakerWP;
    i:integer;
    s:String;
    f:TIniFile;
begin
  ReportMakerWP:=TReportMakerWP.Create(Application);
  ReportMakerWP.PrintCount:=PageCount;
  ReportMakerWP.AppType:=GetIniStr('Landocs Options','PrintApplication','winword');
  f:=TIniFile.Create('win.ini');
  ReportMakerWP.WordPath:=f.ReadString('Landocs Applications',ReportMakerWP.AppType,'');
  f.Free;
  ReportMakerWP.ClearParam;
  for i:=0 to Params.Count-1 do
    ReportMakerWP.AddParam(Params.Strings[i]);
  s:=sql.SelectString('RPT_Blanks','FileName',sql.CondIntEqu('JournalID',JournalID)+LogAND+
    sql.CondStr('Index','=',RPTName));
  if s<>'' then
    DefaultFile:=s;
  ReportMakerWP.DoMakeReport(TemplateDir+DefaultFile+'.rtf',
          TemplateDir+DefaultFile+'.ini', OutputDir+'report.rtf');
  ReportMakerWP.Free;
end;

{ 0 - SUCCESS
  1 - Document Server Error
  2 - Loading Error}
Function CheckVersJRight(DocID,RightID:longint):boolean;
var res:boolean;
    jID:integer;
begin
//vie, ed , cr , del
//16 17, 18, 19
  jID:=sql.SelectInteger('ERC',fJournalID,sql.CondIntEqu(fID,DocID));
  res:=sql.SelectInteger('JournalRight','FunRightID',
      sql.CondIntEqu(fUserID,CurUserID)+LogAND+
      sql.CondIntEqu('FunRightID',RightID)+LogAND+
      sql.CondIntEqu(fJournalID,jID))<>0;
  if not res then
    PrintMessage('У вас отсутствует права на выполнение данной операции.'+#13+#10+
      'Обратитесь к администратору системы.');
  CheckVersJRight:=res;
end;

function TLanDocsClass.OpenVersion(DocID,N:Longint;EditMode,WaitTerm:boolean):integer;
var s,FileName:String;
    {$ifdef WIN32}
    DS_SaveWOModification : boolean;
    {$endif}
begin
  if EditMode then
    begin if not CheckVersJRight(DocID,17) then exit end;
//   else if not CheckVersJRight(DocID,16) then exit;

  s:=GetApplication(sql.SelectInteger('ERC',fFileTypeID,sql.CondIntEqu(fID,DocID)),
       EditMode);

  Result:=DocSrv.Get(FileName,DocID,N,0,EditMode);
  if (Result = DS_SUCCESS) OR (Result = SUCCESS)then
    begin
{$ifndef DSQuery}
      Result:=IniExec(LanAppSection,s,FileName);
      if Result<32 then
        begin
          PrintError('Не могу запустить приложение');
          Result:=2;
        end;
{$else}
      if EditMode then
        sql.UpdateString('Version',sql.SetValue(fEditDate,sql.CurrentDateTime)+
           ','+sql.SetInt(fEditorID,DocSrv.UEDP.UserID),
            sql.CondIntEqu(fERCID,DocID)+LogAND+
            sql.CondIntEqu(fN,N));
    {$ifdef WIN32}
       if Result = SUCCESS then
         DS_SaveWOModification := TRUE
       else
         DS_SaveWOModification := FALSE;
       ApplicationManager.RunApplication(s,FileName,DocID,N,EditMode,DS_SaveWOModification);
    {$else}

    {$endif}
{$endif}
    end
  else
    Result:= 1;
end;

function TLanDocsClass.UnlockEditDoc(DocId,VerId : longint; SaveMode: boolean) : integer;
begin
  Result:= DocSrv.UnlockEditDoc(DocId,VerId,SaveMode);
end;

procedure TLanDocsClass.PrintError(em:string);
begin
  ErrorMessage:=em+#0;
  if PrintErrorFlag then
    MessageBox(0,@ErrorMessage[1],'Ошибка',0)
end;

function TLanDocsClass.SaveTemplateDoc(ID,DocumTypeID,FileTypeID:longint;ShortName,FileName:TString128):longint;
var res:longint;
    s:string;
begin
  sql.StartTransaction;
  if ID=0 then
    begin
      ID:=sql.FindNextInteger(fID,'Template','',MaxLongint);
      res:=sql.InsertString('Template','ID,DocumTypeID,FileTypeID,ShortName',
        PrnRef(ID)+','+PrnRef(DocumTypeID)+','+PrnRef(FileTypeID)+','+
        sql.MakeStr(ShortName));
    end
  else
    begin
      res:=sql.UpdateString('Template',sql.SetInt(fDocumTypeID,DocumTypeID)+','+
        sql.SetInt(fFileTypeID,FileTypeID)+','+sql.SetStr(fShortName,ShortName),
        sql.CondIntEqu(fID,ID));
      if res=0 then DelFile(GetTemplateDoc(ID));
    end;
  if res=0 then
    begin
      if FileName<>'' then
        begin
          s:=GetStr(ID,8)+'.'+sql.SelectString('FileType','Extention',sql.CondIntEqu(fID,FileTypeID));
          if _CopyFile(FileName,TemplateDocDir+s)=0 then
            sql.UpdateString('Template',sql.SetStr('FileName',s),sql.CondIntEqu(fID,ID))
          else
            begin
              res:=-1;
              PrintError('Ошибка копирования файла');
            end
        end
    end;
  if res=0 then
    begin
      sql.Commit;
      SaveTemplateDoc:=ID
    end
  else
    begin
      sql.Rollback;
      SaveTemplateDoc:=0
    end
end;

function TLanDocsClass.DelTemplateDoc(ID:longint):longint;
begin
  DelTemplateDoc:=0;
  DelFile(GetTemplateDoc(ID));
  if sql.Delete('Template',sql.CondIntEqu(fID,ID))=0 then DelTemplateDoc:=0;
end;

function TLanDocsClass.GetTemplateDoc(ID:longint):string;
var s:string;
begin
  s:=sql.SelectString('Template','FileName',sql.CondIntEqu(fID,ID));
  if s<>'' then
    GetTemplateDoc:=TemplateDocDir+s
  else
    GetTemplateDoc:=''
end;

function TLanDocsClass.CopyTemplateDoc(ID:longint;s:string):string;
var t:string;
begin
  t:=GetTemplateDoc(ID);
  if t='' then
    PrintError('Шаблон для данного вида документа и типа файла отсутствует')
  else
    if _CopyFile(t,s)<>0 then
      begin
        PrintError('Ошибка копирования файла шаблона во временный файл');
        s:='';
      end;
  CopyTemplateDoc:=s;
end;

function TLanDocsClass.TemplateDocDir:string;
var f:TIniFile;
begin
  TemplateDocDir:=GetIniStr('COMMON','DocTemplateDir','')+'DOCTMPLT\';
end;

function TLanDocsClass.UnsortDir:string;
begin
  UnsortDir:=GetIniStr('COMMON','UnsortDir','');
end;

function TLanDocsClass.OutputDir:string;
var f:TIniFile;
begin
  OutputDir:=GetIniStr('COMMON','OutputDir','');
end;

function TLanDocsClass.TemplateDir:string;
var f:TIniFile;
begin
  TemplateDir:=GetIniStr('COMMON','TemplateDir','')+'TEMPLATE\';
end;

function TLanDocsClass.GetApplication(FileTypeID:longint;EditMode:boolean):string;
var s:string;
begin
  if EditMode then
    s:=fProccessFile
  else
    s:=fProccessFileView;
  GetApplication:=sql.SelectString('FileType',s,sql.CondIntEqu(fID,FileTypeID));
end;

function TLanDocsClass.StartApplication(FileTypeID:longint;EditMode:boolean;cmdstr:string):integer;
var s:string;
    res:integer;
begin
  s:=GetApplication(FileTypeID,EditMode);
  res:=IniExec(LanAppSection,s,cmdstr);
  if res<32 then
    PrintError('Не могу запустить приложение');
  StartApplication:=res;
end;

function TLanDocsClass.SelectImportFile(ImportType,DocumTypeID,FileTypeID:longint):string;
Type
   TOdmRegisterApp=function (var GWHandle: Integer; Ver:Word; AppID:LPSTR;
     dwEnvData:DWORD;pReserved:pointer): Integer; stdcall;
   TOdmUnRegisterApp=Procedure (GWHandle: Integer); stdcall;
   TODMOpenDoc=function (GWHandle:integer; flags:DWORD; lpszDocId:LPSTR; lpszDocLocation:LPSTR):integer; stdcall;
   TODMSelectDoc=function (handle:integer; lpszDocId:LPSTR; var pdwFlags:DWORD):integer; stdcall;
var s:string[20];
{$ifdef Win32}
    rc:TLanImportInfo;
{$endif}
    h,hw:THandle;
    p:TFarProc;
    res,i,GWHandle:integer;
    ic:Cardinal;
    lpszDocId,lpszDocLocation:pointer;
    Odlg:TOpenDialog;
    FileName,Body,ErrMsg:string;
begin
  s:=sql.SelectString('FileType',fExtention,sql.CondIntEqu(fID,FileTypeID));
  SelectImportFile:='';
  case ImportType of
    1: begin
         AppDDECmd('','LanImage',',LanDocs,Scan,'+s,TRUE,'LanImage');
         SelectImportFile:=ResultDDE
       end;
    2,3: begin
         Odlg:=TOpenDialog.Create(Application);
         ODlg.FileName:='';
         if FileTypeID<>0 then
           ODlg.Filter:=sql.SelectString('FileType',fShortName,sql.CondIntEqu(fID,FileTypeID))+'|*.'+s
              +'|Все файлы|*.*'
         else
           ODlg.Filter:='Все файлы|*.*';
         ODlg.InitialDir:=UnsortDir;
         if ODlg.Execute then
           SelectImportFile:=ODlg.FileName;
         Odlg.Free;
       end;
    4: begin
         {$ifdef Win32}
         StrPCopy(rc.IniFileName,FormsIniDir+Forms_ini);
         case ImportEmail(rc) of
         0: SelectImportFile:=StrPas(rc.ResultFileName);
         2: PrintError(GetIEMMessageError);
         end;
         {$else}
         PrintError('Данная версия не поддерживает импорт из E-mail');
         {$endif}
       end;
    5: begin
         SelectImportFile:=CopyTemplateDoc(sql.SelectInteger('Template',fID,
           sql.CondIntEqu(fDocumTypeID,DocumTypeID)+LogAND+
           sql.CondIntEqu(fFileTypeID,FileTypeID)),OutputDir+'tmpl.tmp');
       end;
    6: begin
         h:=LoadLibrary(
         {$IFNDEF WIN32}
         'odma.dll'
         {$ELSE}
         'odma32.dll'
         {$ENDIF}
         );
         if h<=32 then
           PrintError('Ваша операционная система не поддерживает ODMA-интерфейс')
         else
           begin
             p:=GetProcAddress(h,'ODMRegisterApp');
             if p=NIL then exit;
             if Screen.ActiveForm=NIL then
               hw:=0
             else
               hw:=Screen.ActiveForm.Handle;
             res:=TOdmRegisterApp(p)(GWHandle,100,'GRPWISE',hw,nil);
             if res<>0 then
               begin
                 PrintError('Ошибка инициализации ODMA');
                 exit;
               end;
             p:=GetProcAddress(h,'ODMSelectDoc');
             GetMem(lpszDocId,256);
             GetMem(lpszDocLocation,256);
             i:=2;
             ic:=i;
             res:=TODMSelectDoc(p)(GWHandle,lpszDocId,ic);i:=ic;
             p:=GetProcAddress(h,'ODMOpenDoc');
             if res=0 then res:=TODMOpenDoc(p)(GWHandle,2,lpszDocId,lpszDocLocation);
             SelectImportFile:=StrPas(lpszDocLocation);
             FreeMem(lpszDocLocation);
             FreeMem(lpszDocId);
             p:=GetProcAddress(h,'ODMUnRegisterApp');
             TODMUnRegisterApp(p)(GWHandle);
           end;
       end;
    7: begin
         if ImportLotus(FileName,Body,ErrMsg) then
           SelectImportFile:=FileName
         else
           if ErrMsg<>'' then PrintError(ErrMsg)
       end;
   end;
end;

Procedure TLanDocsClass.AppDDECmd(ResultServer,ResultTopic,Cmd:TDDEString;FormFlag:boolean;FileName:TDDEString);
var b:boolean;
    l:longint;
begin
  CreateDDE(ResultServer,ResultTopic);
  DDEApp:=0;
  if DDEClient.RequestData('ServerName')=NIL then
    begin
      DDEClient.Free;
      b:=FALSE;
      DDEApp:=IniExec('LanDocs Applications',FileName,'');
      if DDEApp>=HINSTANCE_ERROR then
        begin
          l:=GetCurrentTime;
          while GetCurrentTime-l<=15000 do
            begin
              CreateDDE(ResultServer,ResultTopic);
              if DDEClient.RequestData('ServerName')<>NIL then
                begin
                  b:=TRUE;
                  break;
                end;
              Yield;
              DDEClient.Free
            end
        end
      else
        PrintError('Не могу запустить '+FileName);
    end
  else
    b:=TRUE;
  if b then
    FreeDDE(Cmd,FormFlag);
end;

function TLanDocsClass.GetIniInt(Sec,fname:string;def:longint):longint;
var f:TIniFile;
begin
  f:=TIniFile.Create(FormsIniDir+Forms_ini);
  GetIniInt:=f.ReadInteger(Sec,fname,def);
  f.Free;
end;

function TLanDocsClass.GetIniBool(Sec,fname:string;def:boolean):boolean;
var f:TIniFile;
begin
  f:=TIniFile.Create(FormsIniDir+Forms_ini);
  GetIniBool:=f.ReadBool(Sec,fname,def);
  f.Free;
end;

function TLanDocsClass.GetIniStr(Sec,fname:string;def:string):string;
var f:TIniFile;
begin
  f:=TIniFile.Create(FormsIniDir+Forms_ini);
  GetIniStr:=f.ReadString(Sec,fname,def);
  f.Free;
end;

function TLanDocsClass.GetStatusDoc(DocID:longint):string;
var q:TQuery;
    s:string;
begin
  q:=sql.Select('ViewDocHistory','',sql.CondIntEqu(fDocID,DocID),'');
  s:='';
  while not q.eof do
    begin
      s:=s+'{';
      if not q.FieldByName(fED).IsNull then
        s:=s+q.FieldByName(fED).AsString;
      s:=s+','+q.FieldByName(fexname).AsString+','+q.FieldByName(fActionName).AsString+
        ','+q.FieldByName(fActionID).AsString+','+q.FieldByName(fActionStateID).AsString+'}';
      q.Next
    end;
  GetStatusDoc:=s;
  q.Free
end;

begin
  lnd:=NIL;
end.
