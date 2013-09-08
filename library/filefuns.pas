unit Filefuns;

interface
Uses SysUtils,WinProcs,WinTypes,IniFiles;
Function _CopyFile(Source,Target:string):integer;
Function MoveFile(Source,Target:string):integer;
Function DelFile(Source:string):boolean;
Function CopyByMask(SourceDir,Mask,TargetDir:string):integer;
Function DeleteByMask(SourceDir,Mask:string):integer;
Function MoveByMask(SourceDir,Mask,TargetDir:string):integer;
Function IniExec(Section:string;path:string;CmdStr:string):word;
Function FilePresent(FileName:string):boolean;

var
    CopyBufSize:word;

implementation

{
================================================
     Copy File
     Returns: 0 - Success
              1 - Can't open source
              2 - Can't create target
              3 - Enough free space
================================================
}
Function _CopyFile(Source,Target:string):integer;
Var buf:PChar;
    i,j:word;
    sh,th:integer;
begin
  getmem(buf,CopyBufSize);
  _CopyFile:=0;
  sh:=FileOpen(Source,fmOpenRead);
  if sh>=0 then
    begin
       th:=FileCreate(Target);
       if th>=0 then
         begin
           repeat
             i:=FileRead(sh,buf^,CopyBufSize);
             j:=FileWrite(th,buf^,i);
           until (i<CopyBufSize) or (i>j);
           if i>j then
             _CopyFile:=3;
           FileClose(th);
         end
       else
         _CopyFile:=2;
       FileClose(sh);
    end
  else
    _CopyFile:=1;
  freemem(buf,CopyBufSize);
end;

{
================================================
     Move File
     Returns: 0 - Success
              1 - Can't open source
              2 - Can't create target
              3 - Enough free space
              4 - Can't delete source
================================================
}
Function MoveFile(Source,Target:string):integer;
var er:integer;
begin
  er:=_CopyFile(Source,Target);
  if er=0 then
    if not DelFile(Source) then
      er:=4;
  MoveFile:=er;
end;

Function DelFile(Source:string):boolean;
Var f:file;
begin
  AssignFile(f,source);
  try
    Erase(f);
    DelFile:=TRUE
  except
    DelFile:=FALSE
  end;
end;

Function MoveByMask(SourceDir,Mask,TargetDir:string):integer;
var er:integer;
begin
  er:=CopyByMask(SourceDir,Mask,TargetDir);
  if er=0 then
    er:=DeleteByMask(SourceDir,Mask);
  MoveByMask:=er
end;

Function CopyByMask(SourceDir,Mask,TargetDir:string):integer;
var SearchRec: TSearchRec;
    er:integer;
    res:integer;
begin
  res:=FindFirst(SourceDir+Mask,faAnyFile,SearchRec);
  er:=0;
  while (res=0) AND (er=0) do
     begin
       er:=_CopyFile(SourceDir+SearchRec.Name,TargetDir+SearchRec.Name);
       res:=FindNext(SearchRec);
     end;
  CopyByMask:=er
End;

Function DeleteByMask(SourceDir,Mask:string):integer;
var SearchRec: TSearchRec;
    er:integer;
    res:integer;
begin
  res:=FindFirst(SourceDir+Mask,faAnyFile,SearchRec);
  er:=0;
  while (res=0) AND (er=0) do
     begin
       if not DelFile(SourceDir+SearchRec.Name) then
         er:=4;
       res:=FindNext(SearchRec);
     end;
  DeleteByMask:=er
End;

function IniExec(Section:string;path:string;CmdStr:string):word;
var h:word;
    f:TIniFile;
begin
  f:=TIniFile.Create('win.ini');
  path:=f.ReadString(Section,path,'')+path;
  if pos('.EXE',UpperCase(path))=0 then
    path:=path+'.exe';
  if pos(' ',path)>0 then
    path:='"'+path+'"';
  if pos(' ',CmdStr)>0 then
    CmdStr:='"'+CmdStr+'"';
  if CmdStr<>'' then
    path:=path+' '+CmdStr+#0
  else path:=path+#0;
  IniExec:=WinExec(@path[1],SW_SHOW);
  f.Free;
end;

Function FilePresent(FileName:string):boolean;
Var h:integer;
BEGIN
  FilePresent:=TRUE;
  h:=FileOpen(FileName,fmOpenRead);
  if h>=0 then
    FileClose(h)
  else
    FilePresent:=FALSE;
End;

Begin
  CopyBufSize:=4096;
End.
