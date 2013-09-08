
(*
             Document Server's shared module for client system,
             DSAPI DLLs and Server projects.

             Notes:
               - Mixed 16/32-bit version
*)


				Unit DSAPICom;

{*****************************************************************************}
{*} 				  Interface                                 {*}
{*****************************************************************************}

Uses
  SysUtils;

type
  FM_TStorageType = (FM_cNullStorage, FM_cWorkStorage, FM_cTemporaryArchiveStorage, FM_cPermanentArchiveStorage);

const
  FM_cArchiveStorageTypes = [FM_cTemporaryArchiveStorage, FM_cPermanentArchiveStorage];

  { Version IDs specifiers }
  DS_cAllVersions   = -1;
  DS_cLastVersion   = -2;
  DS_cFirstVersion  = -3;

  { Error codes }
  DS_cSuccess       = 0;
  DS_cOK            = 0;
  DS_cError         = -1;   { unspecified error's ID }
  DS_cErrorVersionNotFound  = -2;
  DS_cErrorDocumentNotFound = -3;

  { Command codes }
  DS_cCmdPut	  = 1;
  DS_cCmdGet	  = 2;
  DS_cCmdDelete	  = 3;
  DS_cCmdArchive  = 4;
  DS_cCmdQuery	  = 5;
  DS_cCmdReBuildIndex = 6;
  DS_cCmdGetServerInfo = 7;
  DS_cCmdUnLockVersion = 8;

  { File types }
  DS_cText        = 1;
  DS_cHTML        = 2;
  DS_cDOC95       = 3;
  DS_cRTF95       = 4;
  DS_cDOC97       = 5;
  DS_cRTF97       = 6;

  DS_cMediumStringLength = 80;
  DS_cShortStringLength = 32;
  DS_cTinyStringLength  = 16;

type
{$IfDef WIN32}
  DS_TString = ShortString;
{$Else}
  DS_TString = string;
{$EndIf}
  DS_TPathString = string[79];
  DS_TMediumString = string[DS_cMediumStringLength];
  DS_TShortString = string[DS_cShortStringLength];
  DS_TTinyString = string[DS_cTinyStringLength];

  { Server's description data }
  DS_TServerInfo = packed record
    ProductName:            DS_TShortString;   { product & build information }
    DeveloperInfo:          DS_TMediumString;
    MajorVersion,
    MinorVersion,
    Build:                  longint;
    BuildTime:              DS_TTinyString;
    isSearchEnginePresent:  boolean;           { true if search engine present }
    isClientSystemControllerPresent: boolean;
  end;

  DS_TFileType = longint;

  DS_PQueryResult = ^DS_TQueryResult;
  DS_TQueryResult = packed record
    DocIDInClientSystem,
    VerIDInClientSystem,
    DocIDOnServer,
    VerIDOnServer:	longint;
  end;

  DS_TInitData = packed record
    ServerName: DS_TString;
    Port:       longint;
    DataReceiveTimeOutMSecs,           { timeouts for send/receive data }
    DataSendTimeOutMSecs:   longint;   { use 0 for default system timeouts }
                                       { control (not recomend.) }
    Protocol:integer;
  end;

  DS_TArchiveAction = (DS_cArchive, DS_cRestore);

  DS_TFileTransferMode = (DS_cNormal, DS_cTextOnly, DS_cNull);

  { main data exchange packet }
  DS_RUnifiedExchangeDataPacket = packed record
    { server descriptor }
    ServerInfo:         DS_TServerInfo;

    { client descriptor }
    ClientSystemID,
    UserID:	        longint;
    UserName:           DS_TShortString;
    PhysicalUserID:	longint;
    PhysicalUserName:	DS_TShortString;

    { file/version descriptor }
    DocIDInClientSystem,
    VerIDInClientSystem,
    DocIDOnServer,
    VerIDOnServer:	longint;
    FileTypeID:         DS_TFileType;

    { result code }
    ErrorCode:		longint;

    { Query control}
    QueryStartFrom,
    QueryResultsCount:  longint;

    { command modifiers }
    ArchiveAction:      DS_TArchiveAction;
    isEditMode:		boolean;
    AutoUnLockDateTime:	TDateTime;
    isFullRebuild:      boolean;
    FileTransferMode:	DS_TFileTransferMode;

    { internally used by DSAPI DLL }
    QueryResult:        DS_PQueryResult;
    CommandID:         	longint;

    { internally used by Server }
    UserLocation:       DS_TShortString;  { network address of user's WS }
    StorageID:          longint;     { storage for version }
    WorkCopyStorageID:  longint;     { storage for copy from Permanent Archive}
    StorageType:        FM_TStorageType;
    isNewVersion,
    isNewDocument:      boolean;     { for cmd. Put - new version/document flags }

    { other fields }
    FileName:      DS_TPathString;   { internally used by DSAPI & Server }
    case Byte of
     1: (QueryString:	DS_TString);
     2: (ErrorMessage:  DS_TString);
     3: (OldFileName:   DS_TPathString);   { internally used by Server }
  end;

  DS_TAbstractDocumentServer = class
  protected
    FErrorCode: longint;
    FErrorMessage:  DS_TString;
    function RErrorMessage:  DS_TString; virtual;
  public
    function cmdPut(var UEDP:  DS_RUnifiedExchangeDataPacket): longint;
	     virtual; abstract;

    function cmdGet(var UEDP:  DS_RUnifiedExchangeDataPacket): longint ;
	     virtual; abstract;

    function cmdDelete(var UEDP:  DS_RUnifiedExchangeDataPacket): longint;
	     virtual; abstract;

    function cmdArchive(var UEDP:  DS_RUnifiedExchangeDataPacket):  longint;
	     virtual; abstract;

    function cmdQuery(var UEDP:  DS_RUnifiedExchangeDataPacket):  longint;
	     virtual; abstract;

    function cmdSettings(var UEDP:  DS_RUnifiedExchangeDataPacket): longint;
	     virtual; abstract;

    function cmdReBuildIndex(var UEDP:  DS_RUnifiedExchangeDataPacket): longint;
	     virtual; abstract;

    function cmdGetServerInfo(var UEDP:  DS_RUnifiedExchangeDataPacket): longint;
	     virtual; abstract;

    function cmdUnLockVersion(var UEDP:  DS_RUnifiedExchangeDataPacket): longint;
	     virtual; abstract;

    property ErrorCode: longint read FErrorCode;
    property ErrorMessage: DS_TString read RErrorMessage;
  end;


function DS_CommandIDToStr(CommandID:  longint):  DS_TString;
function DS_CommandParamsToStr(const UEDP:  DS_RUnifiedExchangeDataPacket):  DS_TString;
function DS_ExecResultToStr(const UEDP:  DS_RUnifiedExchangeDataPacket):  DS_TString;

{*****************************************************************************}
{*} 				  Implementation                            {*}
{*****************************************************************************}
function DS_CommandIDToStr(CommandID:  longint):  DS_TString;
begin
  case CommandID of
    DS_cCmdPut: Result := 'PUT';
    DS_cCmdGet: Result := 'GET/LOCK';
    DS_cCmdDelete: Result :='DELETE';
    DS_cCmdArchive: Result := 'ARCHIVE';
    DS_cCmdQuery: Result := 'QUERY';
    DS_cCmdReBuildIndex: Result := 'ProceedIndex';
    DS_cCmdGetServerInfo: Result := 'GetServerInfo';
    DS_cCmdUnLockVersion: Result := 'UNLOCK';
  else
    Result := 'Unknown';
  end;

  Result := Result +'('+IntToStr(CommandID)+')';
end;


{-----------------------------------------------------------------------------}
function DS_CommandParamsToStr(const UEDP:  DS_RUnifiedExchangeDataPacket):  DS_TString;

  function VersionInfo: string;
  var
    s:  string;
  begin
    case UEDP.VerIDInClientSystem of
      DS_cAllVersions: s := 'ALL';
      DS_cLastVersion: s := 'LAST';
      DS_cFirstVersion: s := 'FIRST';
    else
      s := IntToStr(UEDP.VerIDInClientSystem);
    end;
    Result := 'Doc='+IntToStr(UEDP.DocIDInClientSystem)+' '+
              'Ver='+s+'. ';
  end;

  function UserInfo: string;
  begin
    Result := 'CSID='+IntToStr(UEDP.ClientSystemID)+' '+
              'UserID='+IntToStr(UEDP.UserID)+' '+
              'UserName="'+UEDP.UserName+'". ';
  end;

var
  s:  string;
begin {DS_CommandParamsToStr}
  case UEDP.CommandID of
    DS_cCmdPut: Result := VersionInfo;
    DS_cCmdGet:
      begin
        Result := VersionInfo+' Mode=';
        if UEDP.isEditMode then Result := Result+'EDIT&LOCK'
          else Result := Result+'VIEW';
        Result := Result + '. FileTransferMode=';
        case UEDP.FileTransferMode of
         DS_cNormal:
           Result := Result + 'Normal';
         DS_cTextOnly:
           Result := Result + 'TextOnly';
         DS_cNull:
           Result := Result + 'Null';
        end;
      end;
    DS_cCmdDelete: Result := VersionInfo;
    DS_cCmdArchive:
      begin
        case UEDP.ArchiveAction of
          DS_cArchive:
            s := 'ARCHIVE';
          DS_cRestore:
            s := 'RESTORE';
        else
          s := '?'
        end;
        Result := VersionInfo+'Mode='+s;
      end;
    DS_cCmdQuery: Result := 'QS: "'+UEDP.QueryString+'"';
    DS_cCmdReBuildIndex:
      if UEDP.isFullRebuild then Result := 'Mode=FULL.'
        else Result := 'Mode=UPDATE.';
    DS_cCmdGetServerInfo: Result := '';
    DS_cCmdUnLockVersion: Result := VersionInfo;
  else
    Result := 'CommandID='+IntToStr(UEDP.CommandID);
  end;

  Result := UserInfo+Result;
end;

{-----------------------------------------------------------------------------}
function DS_ExecResultToStr(const UEDP:  DS_RUnifiedExchangeDataPacket):  DS_TString;

  function FileInfo: string;
  begin
    if (UEDP.StorageID=0) or (UEDP.FileName='') then Result := ''
      else Result := Format('FileName=%s. StorageID=%d. StorageTypeID=%d. ',
                [UEDP.FileName, UEDP.StorageID, Integer(UEDP.StorageType)]);
  end;

begin
  case UEDP.CommandID of
    DS_cCmdPut,
    DS_cCmdGet,
    DS_cCmdDelete,
    DS_cCmdArchive: Result := FileInfo;
    DS_cCmdQuery: Result := Format('Total hit(s)=%d', [UEDP.QueryResultsCount]);
    DS_cCmdReBuildIndex: Result := '';
    DS_cCmdGetServerInfo: Result := '';
    DS_cCmdUnLockVersion: Result := '';
  else
    Result := '';
  end;
  if Result<>'' then Result:='. Details: '+Result;
end;

{-----------------------------------------------------------------------------}
function DS_TAbstractDocumentServer.RErrorMessage:  DS_TString;
begin
  RErrorMessage:=FErrorMessage;
end;

END.