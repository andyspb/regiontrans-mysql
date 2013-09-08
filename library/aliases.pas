unit aliases;
interface
uses sysutils,inifiles;
procedure CheckAllAliases;

implementation
type st=string[20];
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
procedure CheckAllAliases;
var
  ini:TIniFile;
  s:string;
procedure FindAlias(als,fn:st);
var ex_path:string;
begin
  ex_path:=RecursSearchFile('C:\',fn);
  if ex_path='' then ex_path:=RecursSearchFile('D:\',fn);
  if ex_path='' then ex_path:='Not found';
  ini.WriteString('LanDocs Applications',als,ex_path);
end;
begin
  ini:=TIniFile.Create('win.ini');
  s:=ini.ReadString('LanDocs Applications','WINWORD','');
  if s='' then FindAlias('WINWORD','WINWORD.EXE');
  s:=ini.ReadString('LanDocs Applications','EXCEL','');
  if s='' then FindAlias('EXCEL','EXCEL.EXE');
  s:=ini.ReadString('LanDocs Applications','LANIMAGE','');
  if s='' then FindAlias('LANIMAGE','LANIMAGE.EXE');
  ini.free;
end;
end.
