unit findapps;

interface
uses WinTypes,WinProcs,sysutils,inifiles;
type st=string[30];

function FindAlias(fn:st):string;
function RecursSearchFile(begdir:string;fn:st):string;

implementation
function RecursSearchFile(begdir:string;fn:st):string;
var sr:TSearchRec;
    r:integer;
begin
{$I-}
try
  Result:='';
  r:=sysutils.findfirst(begdir+fn,faAnyFile,sr);
  sysutils.FindClose(sr);
  if r=0 then Result:=begdir
    else
      begin
        r:=sysutils.findfirst(begdir+'*.*',faDirectory,sr);
        while r=0 do
          begin
             if (sr.attr and faDirectory<>0) and (sr.name<>'.') and (sr.name<>'..') then begin
               Result:=RecursSearchFile(begdir+sr.name+'\',fn);
               if Result<>'' then break;
             end;
             r:=sysutils.findnext(sr);
          end;
        sysutils.FindClose(sr);
      end;
except end;
if IOResult<>0 then;
end;

function FindAlias(fn:st):string;
var
	ex_path:string;
    DrivePath:PChar;
    pointer:PChar;
    Size:integer;
    Path:PChar;
    i:integer;
begin
	GetMem(DrivePath,255);
	Size:=GetLogicalDriveStrings(255,DrivePath);
    if (Size>255) and (Size<>0) then
    begin
		FreeMem(DrivePath);
		GetMem(DrivePath,Size);
		Size:=GetLogicalDriveStrings(255,DrivePath);
    end;
    i:=0;
	ex_path:='';
    while (i<Size) and (ex_path='') do
    begin
        Path:=DrivePath+i;
		if GetDriveType(Path)=DRIVE_FIXED then
		begin
			ex_path:=RecursSearchFile(Path,fn);
    		FindAlias:=ex_path;
		end else
  			FindAlias:='';
	    pointer:=StrEnd(DrivePath+i);
        i:=pointer-DrivePath+1;
    end;
	FreeMem(DrivePath);
end;

end.
