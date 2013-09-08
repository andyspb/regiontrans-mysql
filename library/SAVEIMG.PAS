
unit SaveImg;

interface

Uses Files, TifFuncs;

function SaveAsImage(CountOfSourceFiles: word; const TargetFile,
         ControlData:  string): boolean;

implementation

function SaveAsImage(CountOfSourceFiles: word; const TargetFile,
         ControlData:  string): boolean;
var
  i : Integer;
begin

  TIFF_MakeFile(TargetFile , GetTIFFileName(1));

  for i := 2 to CountOfSourceFiles do
    TIFF_AddFile(TargetFile, GetTIFFileName(i));

  SaveAsImage := True;
end;


end.
