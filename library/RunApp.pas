unit RunApp;

interface

uses
  Classes, StdCtrls, SysUtils, Forms, Windows, Dialogs,TSQLcls;

type
  RA_TString = AnsiString;

  TRunApplication = class(TThread)
  private
    { Private declarations }
    ApplicationName : RA_TString;
    CommandLine     : RA_TString;
    fFileName       : RA_TString;
    fEditMode       : boolean;
    FileDate        : integer;
    msg             : RA_TString;
    DocID,VerID     : longint;
    DS_SaveWOModification : boolean;
    procedure WriteMessage;
    function GetFileName : RA_TString;
    function GetEditMode : boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(AName,EFName : RA_TString; aDocID,aVerID:longint;
                       aEditMode,aSaveMode : boolean);
    property FileName: RA_TString read GetFileName;
    property EditMode: boolean read GetEditMode;
  end;

implementation
Uses FileFuns, lndcls,dsfuns,IniFiles;

constructor TRunApplication.Create(AName,EFName : RA_TString; aDocID,aVerID:longint;
             aEditMode, aSaveMode : boolean);
var f:TIniFile;
begin
  f:=TIniFile.Create('win.ini');
  ApplicationName:=f.ReadString('LanDocs Applications',AName,'')+AName;
  f.Free;
  fEditMode := aEditMode;
  fFileName:= EFName;
  DocID:=aDocID;
  VerID:=aVerID;
  DS_SaveWOModification:= aSaveMode;
  CommandLine:= ApplicationName+'.exe '+GetFileName;
  FreeOnTerminate:= True;
  inherited Create(false);
end;

procedure TRunApplication.Execute;
var
  si : TStartupInfo;
  pi : TProcessInformation;
  FileHandle  : integer;
  newFileDate : integer;
  l, res:longint;
begin
  { get and save date of file}
  if GetEditMode then
    begin
      FileHandle:= FileOpen(GetFileName,fmOpenReadWrite);
      FileDate:= FileGetDate(FileHandle);
      FileClose(FileHandle);
    end;

  FillChar(si,sizeof(TStartupInfo),0);
  si.cb:= sizeof(TStartupInfo);
  si.dwFlags:= STARTF_USESHOWWINDOW;
  si.wShowWindow:= SW_MAXIMIZE;
  if not CreateProcess(NIL, PChar(CommandLine),
                nil, nil, FALSE, NORMAL_PRIORITY_CLASS, nil, nil,
                si, pi ) then begin
      l:=GetLastError;
      msg:= 'Не могу запустить приложение '+CommandLine+' ('+IntToStr(l)+')';
      Synchronize(WriteMessage)
    end
  else
    begin
      CloseHandle(pi.hThread);
      WaitForSingleObject(pi.hProcess,INFINITE);
      Closehandle(pi.hProcess);

      Res:= DS_SUCCESS;
      if GetEditMode then
        begin
          { compare saved and existing date of file}
          FileHandle:= FileOpen(GetFileName,fmOpenReadWrite);
          newFileDate:= FileGetDate(FileHandle);
          FileClose(FileHandle);
          if (FileDate <> newFileDate) OR DS_SaveWOModification then
            Res:= DocSrv.Put(GetFileName,DocID,VerID,l)
          else
            Res:= DocSrv.Unlock(DocID,VerID)
        end;
      if Res = DS_SUCCESS then
        DelFile(GetFileName);
    end;
end;

procedure TRunApplication.WriteMessage;
begin
  msg:=msg+#0;
  MessageBox(0,@msg[1],'Ошибка',0);
end;

function TRunApplication.GetFileName : RA_TString;
begin
  Result:= fFileName;
end;

function TRunApplication.GetEditMode : boolean;
begin
  Result:= fEditMode;
end;

end.
