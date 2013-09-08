
				  unit Saver;

{***************************************************************************}
{*}                                interface                              {*}
{***************************************************************************}
Uses  SaveText, SaveImg, Fr3Api;

const
  smReserved  = 0;
  smText      = 1;
  smImage     = 2;


function isCorrectControlData(SaveMode: word; var ControlData:  string): boolean;
function SaveProcessing(SaveMode: integer; CountOfSourceFiles:  word;
      const TargetFile, ControlData:  string): boolean;


{***************************************************************************}
{*}                                implementation                         {*}
{***************************************************************************}


function isCorrectControlData(SaveMode: word; var ControlData:  string): boolean;
begin
   case SaveMode of
     smText:  isCorrectControlData := isCorrectFineReaderControlData(ControlData);
     smImage: isCorrectControlData := True;
     else isCorrectControlData := False;
   end;
end;

{---------------------------------------------------------------------------}
function SaveProcessing(SaveMode: integer; CountOfSourceFiles:  word;
      const TargetFile, ControlData:  string): boolean;
begin
  case SaveMode of
    smImage: SaveProcessing := SaveAsImage(CountOfSourceFiles, TargetFile, ControlData);
    smText: SaveProcessing := SaveAsText(CountOfSourceFiles, TargetFile, ControlData);
  end;
end;


end.
