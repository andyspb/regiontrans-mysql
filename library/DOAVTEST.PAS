unit Doavtest;

interface
  uses Forms,WinProcs,WinTypes,SysUtils,iniFiles,Dialogs,Controls,RDlg;
Type
  TVirusCheck = class(TObject)
                 RepFile:string;
                 VirusName,KeyString:string;
                 VNPos:integer;
                 Fini:TIniFile;
                 leng:integer;
                 cod:word;
                 function DoTest(INIFile,SectionName,fileToTest:string;DoCure:boolean):integer;
                 function WaitReport:boolean;
               end;
  function CheckVirusProc(INIFile,SectionName,fileToTest:string):boolean;

implementation

function TVirusCheck.WaitReport:boolean;
var
  i:integer;
  f:text;
  s:string;
  sr:TSearchRec;
  r:integer;
begin
  Result:=false;
 {$I-}
{  for i:=1 to 30000 do}
  r:=GetModuleUsage(cod);

  while r>0 do
    begin
     r:=GetModuleUsage(cod);
{      if FindFirst(RepFile, faAnyFile ,sr)=0 then
        if sr.Size>leng+250 then break;
        break;}
      application.processmessages;
    end;
{  if sr.Size<leng+251 then begin Result:=false;exit; end;}
  system.assign(f,RepFile);
  system.reset(f);
  VirusName:='';
  repeat
     system.readln(f,s);
     if pos(KeyString,s)>0 then
          begin
             for i:=pos(KeyString,s)+length(KeyString) to length(s) do
               begin
                 if s[i]=' ' then break;
                 VirusName:=VirusName+s[i];
               end;
             Result:=true;
             break;
          end;
  until system.eof(f);
  system.close(f);
end;
function  TVirusCheck.DoTest(INIFile,SectionName,fileToTest:string;DoCure:boolean):integer;
var
  s:string;
  f:file;
  r:integer;
  AVName,AVOptions:string;
  k:integer;
begin
  VirusName:='';

  Fini:=TIniFile.Create(INIFile);
  RepFile:=Fini.ReadString(SectionName,'ReportFile','repfile.vir');
  AVName:=Fini.ReadString(SectionName,'Path','drweb.exe');
  if not DoCure then
    AVOptions:=Fini.ReadString(SectionName,'OptionsTest','/CL /GO /NB /NM /HA0 /RP<ReportFile>')
   else
    AVOptions:=Fini.ReadString(SectionName,'OptionsCure','/CL /GO /NB /NM /HA0 /CU /RP<ReportFile>');
  KeyString:=' '+Fini.ReadString(SectionName,'KeyString','Ё­дЁжЁа®ў ­')+' ';
  VNPos:=Fini.ReadInteger(SectionName,'VirNamePos',32);
  k:=pos('<ReportFile>',AVOptions);
  if k>0 then AVOptions:=copy(AVOptions,1,k-1)+RepFile;

  system.assign(f,RepFile);system.erase(f);
  if IOresult<>0 then;

  s:={'C:\command.com /C '+}avname+' '+fileToTest+' '+AVOptions+#0;
  leng:=length(s);
  cod:=WinExec(@s[1],SW_SHOWMINIMIZED);

  if (cod>32) then
    if WaitReport then Result:=255 else Result:=0
   else Result:=cod;
  Fini.free;
end;

function CheckVirusProc(INIFile,SectionName,fileToTest:string):boolean;
var
  r:integer;
  TVC:TVirusCheck;
  s:string;
begin
  TVC:=TVirusCheck.Create;
  repeat
   r:=TVC.DoTest(INIFile,SectionName,fileToTest,false);
   if r=255 then
      begin
        s:='В файле '+fileToTest+' найден вирус '+TVC.VirusName+#10#13'Вылечить?';
        case RusMessageDlg(s,mtConfirmation,[mbYes,mbIgnore,mbCancel],0) of
           mrYes    : begin
                         r:=TVC.DoTest(INIFile,SectionName,fileToTest,true);
                         Result:=true;
                      end;
           mrIgnore : Result:=true;
           mrCancel : Result:=false;
        end;
        break;
      end;
   if (r>0) and (r<32) then
      begin
        s:='Антивирус '+SectionName+' не найден.';
        case RusMessageDlg(s,mtConfirmation,[mbOk,mbRetry,mbCancel],0) of
          mrRetry : r:=127;
          mrOk    : Result:=true;
          mrCancel: Result:=false;
        end;
      end;
  until r<=32;
  if r=0 then Result:=true;
  TVC.free;
end;

end.
