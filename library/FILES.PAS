				   unit Files;

{****************************************************************************}
{*}			            Interface				   {*}
{****************************************************************************}
Uses SysUtils, WinProcs, lli;

const
   SourceFormat = LLI_DISK_BMP;
   SourceCompress =  LLI_DISK_COMPRESS_RLE;
   SourceExtension = '.BMP';

procedure GroupDeleteFiles(const GroupName:  string);
function GetWindowsTempDir:  string; { with '\' }
function CreateTempDir(var  TempDirName:  string):  boolean;
function CopyFile(const Source, Target:  string):  boolean;
function DeleteTempDir(const TempDirName:  string):  boolean;

function GetSourceFileName(i:Integer):String;
function GetTIFFileName(i:Integer):String;
function GetOriginTIFFileName(i:Integer):String;

{****************************************************************************}
{*}		                 Implementation				   {*}
{****************************************************************************}
{$I-}

const
   FileAttr	= faReadOnly + faArchive;
   MaxFileSize	= 64000;
var
   WindowsTempDir:  string;

{-----------------------------------------------------------------------------}
procedure GroupDeleteFiles(const GroupName:  string);
var
  Rec:  TSearchRec;
  Path:  string;
begin
  if FindFirst(GroupName, faAnyFile, Rec) <> 0 then exit;
  Path := ExtractFilePath(GroupName) + '\';
  DeleteFile(Path + Rec.Name);
  while FindNext(Rec) = 0 do DeleteFile(Path + Rec.Name);
end;

{-----------------------------------------------------------------------------}
function GetSourceFileName(i:Integer):String;
begin
  GetSourceFileName := GetWindowsTempDir + intToStr(i) + SourceExtension;
end;

function GetTIFFileName(i:Integer):String;
begin
  GetTIFFileName := GetWindowsTempDir + intToStr(i) +'.tif'
end;

function GetOriginTIFFileName(i:Integer):String;
begin
  GetOriginTIFFileName := GetWindowsTempDir + intToStr(i) +'.~ti'
end;

{-----------------------------------------------------------------------------}
function GetFileSize(const FileName:  string): longint;
var
   Info:   TSearchRec;
begin
   if FindFirst(FileName, FileAttr, Info) =0 then GetFileSize := Info.Size
     else GetFileSize := 0;
end;

{-----------------------------------------------------------------------------}
function CreateTempDir(var  TempDirName:  string):  boolean;
var
   s:	string;
   Res:	string;
   h:	integer;
begin
   CreateTempDir := false;
   GetTempFileName(GetTempDrive(#0), StrPCopy(@s, TempDirName), 0, @Res);
   TempDirName := StrPas(@Res);
   MkDir(TempDirName);
   CreateTempDir := true;
end;


{-----------------------------------------------------------------------------}
function GetWindowsTempDir:  string;
begin
   GetWindowsTempDir := WindowsTempDir;
end;

{-----------------------------------------------------------------------------}
function CopyFile(const Source, Target:  string):  boolean;
var
   Size:	longint;
   Buff:	pchar;
   fin, fout:	file;
begin
   DeleteFile(Target);
   CopyFile := False;
   Size := GetFileSize(Source);
   if (Size = 0) or (Size > MaxFileSize) then exit;

   GetMem(Buff, Size);
   if IOResult <> 0 then exit;

   repeat
      Assign(fin, Source);
      Assign(fout, Target);

      reset(fin, 1);
      if IOResult <> 0 then break;

      rewrite(fout, 1);
      if IOResult <> 0 then break;

      BlockRead(fin, Buff^, Size);
      if IOResult <> 0 then break;

      BlockWrite(fout, Buff^, Size);
      if IOResult <> 0 then break;

      close(fout);
      if IOResult <> 0 then break;

      close(fin);
      if IOResult <> 0 then break;

      FreeMem(Buff, Size);
      CopyFile := true;
      exit;
   until true;

   FreeMem(Buff, Size);
end;

{-----------------------------------------------------------------------------}
function DeleteTempDir(const TempDirName:  string):  boolean;
var
   Info:	TSearchRec;
begin
   FindFirst(TempDirName + '\*.*', FileAttr, Info);

   with Info do
     begin
	while Name <> '' do
	  begin
	     DeleteFile(TempDirName + Name);
	     if FindNext(Info) <> 0 then break;
	  end;
     end;

   RmDir(TempDirName);
   if IOResult <> 0 then DeleteTempDir := false
      else DeleteTempDir := true;
end;

{-----------------------------------------------------------------------------}
BEGIN
   GetTempFileName(GetTempDrive(#0), '', 0, @WindowsTempDir);
   WindowsTempDir := StrPas(@WindowsTempDir);
   DeleteFile(WindowsTempDir);
   WindowsTempDir := ExtractFilePath(WindowsTempDir);
END.