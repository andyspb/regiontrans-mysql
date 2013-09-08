unit DLoad;
interface
uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, toolbtn, StdCtrls, Buttons, BMPBtn, ToolWin, ComCtrls, Sqlctrls,
  LblCombo,Printers, LblEdtDt, ExtCtrls,TSQLCLS,SqlGrid, DB,StrUtils,FunChar,
   DBTables, Lbsqlcmb, OleServer, Word2000,XMLDOM, DBClient, MConnect;

Procedure UnltoFile(s1:TStrings;s2,s3:string);
Procedure CreateClearDir;
implementation
Procedure UnltoFile(s1:TStrings;s2,s3:string);
var
strId,s : string;
TempList1: TStrings;
FH:integer;
begin
if Pos('"',s2)<>0 then s2:=copy(s2,2,length(s2)-2);
strId:= systemdir+'Unload\'+s2;
TempList1 := TStringList.Create;
TempList1:=s1;
if TempList1.count <> 0 then
begin
if s3<>'' then strId:=strId+s3;
strId:= strId+'.txt' ;
 if not FileExists(strId) then
       begin
       FH:=FileCreate(strId); {создаем если нет файла}
       FileClose(FH);
       end;
TempList1.SaveToFile(strId);
end;
TempList1.free;

end;

Procedure CreateClearDir;
var
strId : string;
SRec: TSearchRec;
begin
strId:= systemdir+'Unload';
if DirectoryExists(strId) then
begin
  if  FindFirst(strId+'\*.*',faAnyFile,SRec) = 0 then
    begin
     repeat
     DeleteFile(strId+'\'+SRec.Name);
     until FindNext(SRec) <> 0;
     FindClose(SRec);
    end;
end
else
CreateDir(strId);
end;

end.
