
unit FineBat;

interface
Uses Files, Fr3Api,
     Classes, SysUtils;

function BatchAutoRecognize(const SourceFiles:  TStrings;
       const TargetFile, Format: string):  boolean;



implementation

const
  EmptyPacketName = 'fine.dat';
  TempPacketName  = 'temp.pac';
var
  EmptyPacketPathName:  string;


function BatchAutoRecognize(const SourceFiles:  TStrings;
       const TargetFile, Format: string):  boolean;
var
   i:		        integer;
   s, s2,
   TempPacketPathName:  string;
begin
   BatchAutoRecognize := false;

   if SourceFiles.Count = 0 then exit;

   TempPacketPathName := GetWindowsTempDir + TempPacketName;
   if not CopyFile(EmptyPacketPathName, TempPacketPathName) then exit;

   if FineBatch_IsOpen then
      if not FineBatch_Close then exit;

   if not FineBatch_Open(StrPCopy(@s, TempPacketPathName)) then exit;

   for i:=0 to SourceFiles.Count-1 do
      if not FineBatch_AddImageFile(StrPCopy(@s, SourceFiles.Strings[i]) ,
	 0, True) then exit;

   if not FineBatch_Read(False, False, False) then exit;
   if not FineBatch_Export(StrPCopy(@s, TargetFile), StrPCopy(@s2, Format),
	False, False) then exit;

   FineBatch_Remove;
   BatchAutoRecognize := true;
end;


begin
  getdir(0, EmptyPacketPathName);
  EmptyPacketPathName := EmptyPacketPathName + '\' + EmptyPacketName;
end.
